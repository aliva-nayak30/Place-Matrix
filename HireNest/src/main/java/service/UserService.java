package service;

import dao.CollegeDAO;
import dao.RecruiterDAO;
import dao.StudentDAO;
import dao.UserDAO;
import entity.College;
import entity.Recruiter;
import entity.Student;
import entity.User;
import util.PasswordUtil;

import java.sql.SQLException;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private RecruiterDAO recruiterDAO = new RecruiterDAO();
    private CollegeDAO collegeDAO = new CollegeDAO();

    public boolean isEmailExists(String email) throws SQLException {
        return userDAO.isEmailExists(email);
    }

    public boolean isRegNoExists(String regNo) {
        return studentDAO.isRegistrationNoExists(regNo);
    }

    public User getUserByEmail(String email) throws SQLException {
        return userDAO.findByEmail(email);
    }

    public User getUserById(int id) throws SQLException {
        return userDAO.getUserById(id);
    }

    // ==========================================
    // REGISTER STUDENT (Normal Registration)
    // ==========================================
    public boolean registerStudent(User user, Student student) {
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        boolean userSaved = userDAO.saveUser(user);
        if (!userSaved) return false;

        student.setUserId(user.getId());
        boolean studentSaved = studentDAO.saveStudent(student);

        if (!studentSaved) {
            userDAO.deleteUser(user.getId()); // Rollback
            return false;
        }
        return true;
    }

    // ==========================================
    // REGISTER RECRUITER (Normal Registration)
    // ==========================================
    public boolean registerRecruiter(User user, String name, String phone, int collegeId) {
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        boolean userSaved = userDAO.saveUser(user);
        if (!userSaved) return false;

        Recruiter r = new Recruiter();
        r.setUserId(user.getId());
        r.setCollegeId(collegeId);
        r.setCompanyName(name);
        r.setHrName(name);
        r.setHrEmail(user.getEmail());
        r.setPhone(phone);
        r.setStatus("PENDING"); // Needs College Admin approval

        boolean recSaved = recruiterDAO.saveRecruiter(r);
        if (!recSaved) {
            userDAO.deleteUser(user.getId());
            return false;
        }
        return true;
    }

    // ==========================================
    // REGISTER RECRUITER FROM INVITE LINK
    // ==========================================
    public boolean registerRecruiterFromInvite(
            User user,
            String companyName,
            String hrName,
            String hrEmail,
            String companyWebsite,
            String phone,
            int collegeId) throws SQLException {

        user.setRole("RECRUITER");
        user.setCollegeId(collegeId);
        user.setActive(false);

        user.setPassword(
                PasswordUtil.hashPassword(user.getPassword())
        );

        boolean userSaved = userDAO.saveUser(user);

        if (!userSaved) {
            return false;
        }

        Recruiter recruiter = new Recruiter();

        recruiter.setUserId(user.getId());
        recruiter.setCollegeId(collegeId);
        recruiter.setCompanyName(companyName);
        recruiter.setHrName(hrName);
        recruiter.setHrEmail(hrEmail);
        recruiter.setCompanyWebsite(companyWebsite);
        recruiter.setPhone(phone);

        // Recruiter must wait for College Admin approval
        recruiter.setStatus("PENDING");

        boolean recruiterSaved = recruiterDAO.saveRecruiter(recruiter);

        if (!recruiterSaved) {
            userDAO.deleteUser(user.getId());
            return false;
        }

        return true;
    }

    // ==========================================
    // REGISTER COLLEGE ADMIN (With New College)
    // ==========================================
    public boolean registerCollegeAdminWithCollege(User user, String collegeName, String collegeCode, String location) {
        try {
            if (collegeDAO.isCollegeCodeExists(collegeCode)) {
                System.out.println("Code exists: " + collegeCode);
                return false;
            }

            College college = new College();
            college.setCollegeName(collegeName);
            college.setCollegeCode(collegeCode);
            college.setLocation(location);
            college.setActive(false); // Pending Super Admin approval

            boolean collegeSaved = collegeDAO.saveCollege(college);
            if (!collegeSaved) {
                System.out.println("Failed to save college to DB.");
                return false;
            }

            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
            user.setRole("COLLEGE_ADMIN");
            user.setCollegeId(college.getId());
            user.setActive(false);

            boolean userSaved = userDAO.saveUser(user);
            if (!userSaved) {
                System.out.println("Failed to save user to DB.");
                return false;
            }

            return true;

        } catch (Exception e) {
            System.out.println("Exception in registerCollegeAdminWithCollege: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}