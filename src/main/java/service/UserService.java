package service;

import dao.UserDAO;
import dao.StudentDAO;
import dao.RecruiterDAO;
import entity.User;
import entity.Student;
import entity.Recruiter;

public class UserService {
    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private RecruiterDAO recruiterDAO;

    public UserService() {
        this.userDAO = new UserDAO();
        this.studentDAO = new StudentDAO();
        this.recruiterDAO = new RecruiterDAO();
    }
    public boolean registerStudent(User user, Student student) {
        try {
            if (userDAO.isEmailExists(user.getEmail())) {
                System.out.println("Email already exists: " + user.getEmail());
                return false;
            }

            if (studentDAO.isRegistrationNoExists(student.getRegistrationNo())) {
                System.out.println("Registration number already exists: " + student.getRegistrationNo());
                return false;
            }

            boolean userSaved = userDAO.saveUser(user);
            if (!userSaved) {
                System.out.println("Failed to save user");
                return false;
            }

            student.setUserId(user.getId());

            boolean studentSaved = studentDAO.saveStudent(student);
            if (!studentSaved) {
                userDAO.deleteUser(user.getId());
                System.out.println("Failed to save student, rolling back user");
                return false;
            }

            System.out.println("Student registered successfully: " + user.getEmail());
            return true;

        } catch (Exception e) {
            System.out.println("Exception in registerStudent: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public boolean registerRecruiter(User user, String name, String phone, int collegeId) {
        try {
            if (userDAO.isEmailExists(user.getEmail())) {
                System.out.println("Email already exists: " + user.getEmail());
                return false;
            }

            boolean userSaved = userDAO.saveUser(user);
            if (!userSaved) {
                return false;
            }

            Recruiter recruiter = new Recruiter();
            recruiter.setUserId(user.getId());
            recruiter.setCollegeId(collegeId);
            recruiter.setCompanyName(name);
            recruiter.setHrName(name);
            recruiter.setHrEmail(user.getEmail());
            recruiter.setPhone(phone);
            recruiter.setStatus("PENDING");

            boolean recruiterSaved = recruiterDAO.saveRecruiter(recruiter);
            if (!recruiterSaved) {
                userDAO.deleteUser(user.getId());
                return false;
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean registerCollegeAdmin(User user) {
        try {
            if (userDAO.isEmailExists(user.getEmail())) {
                System.out.println("Email already exists: " + user.getEmail());
                return false;
            }
            return userDAO.saveUser(user);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public User loginUser(String email, String password) {
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            return null;
        }
        return userDAO.getUserByEmailAndPassword(email, password);
    }
    public boolean isEmailExists(String email) {
        return userDAO.isEmailExists(email);
    }

    public boolean isRegNoExists(String regNo) {
        return studentDAO.isRegistrationNoExists(regNo);
    }

    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
}