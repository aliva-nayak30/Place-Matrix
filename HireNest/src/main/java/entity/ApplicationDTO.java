package entity;

import java.sql.Date;
import java.sql.Timestamp;

public class ApplicationDTO {

    // ========== From applications table ==========
    private int id;
    private int studentId;
    private int jobId;
    private String status;
    private Timestamp appliedDate;
    private String recruiterRemarks;
    private Date interviewDate;
    private String interviewLocation;

    // ========== From jobs table (JOIN) ==========
    private String companyName;
    private String companyLogo;
    private String role;
    private String location;
    private double packageLpa;

    public ApplicationDTO() {}

    // ==================================================
    // GETTERS & SETTERS
    // ==================================================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    // ✅ THIS WAS MISSING
    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getAppliedDate() { return appliedDate; }
    public void setAppliedDate(Timestamp appliedDate) { this.appliedDate = appliedDate; }

    public String getRecruiterRemarks() { return recruiterRemarks; }
    public void setRecruiterRemarks(String recruiterRemarks) { this.recruiterRemarks = recruiterRemarks; }

    public Date getInterviewDate() { return interviewDate; }
    public void setInterviewDate(Date interviewDate) { this.interviewDate = interviewDate; }

    public String getInterviewLocation() { return interviewLocation; }
    public void setInterviewLocation(String interviewLocation) { this.interviewLocation = interviewLocation; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getCompanyLogo() { return companyLogo; }
    public void setCompanyLogo(String companyLogo) { this.companyLogo = companyLogo; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public double getPackageLpa() { return packageLpa; }
    public void setPackageLpa(double packageLpa) { this.packageLpa = packageLpa; }
}