package entity;

import java.sql.Date;

public class Job {
    private int id;
    private String companyName;
    private String role;
    private double ctc;
    private String location;
    private double minCgpa;
    private Date deadline;
    private String logoPath;
    private String skills;

    public Job() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public double getCtc() { return ctc; }
    public void setCtc(double ctc) { this.ctc = ctc; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public double getMinCgpa() { return minCgpa; }
    public void setMinCgpa(double minCgpa) { this.minCgpa = minCgpa; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public String getLogoPath() { return logoPath; }
    public void setLogoPath(String logoPath) { this.logoPath = logoPath; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
}