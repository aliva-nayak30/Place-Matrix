package entity;

import java.sql.Date;

public class CompanyPosting {
    private int id;
    private int collegeId;
    private int recruiterId;
    private String jobTitle;
    private String jobDescription;
    private double packageAmount;
    private double cgpaRequired;
    private int backlogAllowed;
    private String skillsRequired;
    private String location;
    private Date lastDate;
    private String status;
    private String createdAt;

    public CompanyPosting() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    public int getRecruiterId() { return recruiterId; }
    public void setRecruiterId(int recruiterId) { this.recruiterId = recruiterId; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getJobDescription() { return jobDescription; }
    public void setJobDescription(String jobDescription) { this.jobDescription = jobDescription; }

    public double getPackageAmount() { return packageAmount; }
    public void setPackageAmount(double packageAmount) { this.packageAmount = packageAmount; }

    public double getCgpaRequired() { return cgpaRequired; }
    public void setCgpaRequired(double cgpaRequired) { this.cgpaRequired = cgpaRequired; }

    public int getBacklogAllowed() { return backlogAllowed; }
    public void setBacklogAllowed(int backlogAllowed) { this.backlogAllowed = backlogAllowed; }

    public String getSkillsRequired() { return skillsRequired; }
    public void setSkillsRequired(String skillsRequired) { this.skillsRequired = skillsRequired; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Date getLastDate() { return lastDate; }
    public void setLastDate(Date lastDate) { this.lastDate = lastDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}