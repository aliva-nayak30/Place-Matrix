
package controller.collegeAdmin;

import dao.StudentDAO;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/collegeadmin/students")
public class CollegeManageStudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Integer collegeId =
                (Integer) session.getAttribute("collegeId");

        if (collegeId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.setAttribute(
                "students",
                studentDAO.getStudentsByCollegeId(collegeId)
        );

        request.getRequestDispatcher("/collegeadmin/students.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Integer collegeId =
                (Integer) session.getAttribute("collegeId");

        String action = request.getParameter("action");

        try {

            int studentId = Integer.parseInt(
                    request.getParameter("studentId")
            );

            if ("approve".equals(action) ||
                    "reject".equals(action)) {

                updateApproval(
                        studentId,
                        collegeId,
                        "approve".equals(action)
                                ? "APPROVED"
                                : "REJECTED"
                );

            } else if ("markPlaced".equals(action)) {

                String company =
                        request.getParameter("companyName");

                double packageLpa =
                        Double.parseDouble(
                                request.getParameter("packageLpa")
                        );

                String sql =
                        "UPDATE students SET is_placed = 1, " +
                                "placed_company = ?, placed_package = ? " +
                                "WHERE id = ? AND college_id = ? " +
                                "AND status = 'APPROVED'";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setString(1, company);
                    ps.setDouble(2, packageLpa);
                    ps.setInt(3, studentId);
                    ps.setInt(4, collegeId);

                    ps.executeUpdate();
                }

            } else if ("unplace".equals(action)) {

                String sql =
                        "UPDATE students SET is_placed = 0, " +
                                "placed_company = NULL, placed_package = NULL " +
                                "WHERE id = ? AND college_id = ?";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setInt(1, studentId);
                    ps.setInt(2, collegeId);

                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMsg",
                    "Unable to update student: " + e.getMessage()
            );
        }

        response.sendRedirect(
                request.getContextPath() + "/collegeadmin/students"
        );
    }

    private void updateApproval(
            int studentId,
            int collegeId,
            String status) throws SQLException {

        String selectSQL =
                "SELECT s.user_id, u.email_verified " +
                        "FROM students s " +
                        "JOIN users u ON s.user_id = u.id " +
                        "WHERE s.id = ? AND s.college_id = ?";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId;
            boolean emailVerified;

            try (PreparedStatement ps =
                         conn.prepareStatement(selectSQL)) {

                ps.setInt(1, studentId);
                ps.setInt(2, collegeId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        throw new SQLException(
                                "Student not found in your college."
                        );
                    }

                    userId = rs.getInt("user_id");
                    emailVerified = rs.getBoolean("email_verified");
                }
            }

            if ("APPROVED".equals(status) && !emailVerified) {
                throw new SQLException(
                        "Student must verify their email before approval."
                );
            }

            String updateStudent =
                    "UPDATE students SET status = ? " +
                            "WHERE id = ? AND college_id = ?";

            try (PreparedStatement ps =
                         conn.prepareStatement(updateStudent)) {

                ps.setString(1, status);
                ps.setInt(2, studentId);
                ps.setInt(3, collegeId);

                if (ps.executeUpdate() == 0) {
                    throw new SQLException(
                            "Student status could not be updated."
                    );
                }
            }

            String updateUser =
                    "UPDATE users SET is_active = ? WHERE id = ?";

            try (PreparedStatement ps =
                         conn.prepareStatement(updateUser)) {

                ps.setBoolean(1, "APPROVED".equals(status));
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            conn.commit();

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {}
            }

            throw e;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }
}
