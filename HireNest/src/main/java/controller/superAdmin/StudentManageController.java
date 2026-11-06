package controller.superAdmin;

import dao.StudentDAO;
import entity.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/superadmin/students")
public class StudentManageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "toggle":
                    toggleStatus(request, response);
                    break;
                case "delete":
                    deleteStudent(request, response);
                    break;
                // Removed markPlaced action since only College Admin can do this now.
                case "list":
                default:
                    listStudents(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            listStudents(request, response);
        }
    }

    // ============ LIST (with search + filter) ============
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String branch = request.getParameter("branch");
        String minCgpa = request.getParameter("minCgpa");

        List<Student> students = studentDAO.searchStudents(search, branch, minCgpa);
        List<String> branches = studentDAO.getAllBranches();

        request.setAttribute("students", students);
        request.setAttribute("branches", branches);
        request.setAttribute("search", search);
        request.setAttribute("filterBranch", branch);
        request.setAttribute("filterCgpa", minCgpa);

        request.getRequestDispatcher("/superadmin/students.jsp").forward(request, response);
    }

    // ============ TOGGLE BLOCK (via users.is_active) ============
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean current = Boolean.parseBoolean(request.getParameter("active"));

            boolean ok = studentDAO.toggleUserStatus(userId, !current);

            HttpSession session = request.getSession();
            if (ok) session.setAttribute("successMsg", "Status updated.");
            else session.setAttribute("errorMsg", "Failed.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/superadmin/students");
    }

    // ============ DELETE ============
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("id"));
            int userId = Integer.parseInt(request.getParameter("userId"));

            boolean ok = studentDAO.deleteStudentAndUser(studentId, userId);

            HttpSession session = request.getSession();
            if (ok) session.setAttribute("successMsg", "Student deleted.");
            else session.setAttribute("errorMsg", "Delete failed.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/superadmin/students");
    }
}