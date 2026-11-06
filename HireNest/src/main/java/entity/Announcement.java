package entity;

public class  Announcement {
        private int id;
        private String title;
        private String message;
        private String targetAudience;
        private Integer createdBy;
        private Integer collegeId;
        private boolean isActive;
        private String createdAt;

        public Announcement() {}

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public String getTargetAudience() { return targetAudience; }
        public void setTargetAudience(String targetAudience) { this.targetAudience = targetAudience; }

        public Integer getCreatedBy() { return createdBy; }
        public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

        public Integer getCollegeId() { return collegeId; }
        public void setCollegeId(Integer collegeId) { this.collegeId = collegeId; }

        public boolean isActive() { return isActive; }
        public void setActive(boolean active) { isActive = active; }

        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }

