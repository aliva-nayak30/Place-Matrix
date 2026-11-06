package entity;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int studentId;
    private int jobId;
    private Timestamp appliedDate;
    private String status;

    // Joined fields
    private String companyName;
    private String role;
    private String logoPath;
    private String location;
    private double ctc;

    public Application() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }

    public Timestamp getAppliedDate() { return appliedDate; }
    public void setAppliedDate(Timestamp appliedDate) { this.appliedDate = appliedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getLogoPath() { return logoPath; }
    public void setLogoPath(String logoPath) { this.logoPath = logoPath; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public double getCtc() { return ctc; }
    public void setCtc(double ctc) { this.ctc = ctc; }

    // Optional: nice for debugging
    @Override
    public String toString() {
        return "Application{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", jobId=" + jobId +
                ", status='" + status + '\'' +
                ", companyName='" + companyName + '\'' +
                ", role='" + role + '\'' +
                ", appliedDate=" + appliedDate +
                '}';
    }
}