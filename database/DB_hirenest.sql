CREATE DATABASE  IF NOT EXISTS `hirenest_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hirenest_db`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: hirenest_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `target_audience` enum('ALL','STUDENTS','RECRUITERS','COLLEGE_ADMIN','TPO') DEFAULT 'ALL',
  `created_by` int DEFAULT NULL,
  `college_id` int DEFAULT NULL,
  `is_active` tinyint DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `announcements_ibfk_2` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `college_id` int NOT NULL,
  `student_id` int NOT NULL,
  `company_posting_id` int NOT NULL,
  `status` enum('Applied','Shortlisted','Interview','Rejected','Hired','Withdrawn') DEFAULT 'Applied',
  `applied_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `recruiter_remarks` text,
  `interview_date` date DEFAULT NULL,
  `interview_location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_application` (`student_id`,`company_posting_id`),
  KEY `college_id` (`college_id`),
  KEY `company_posting_id` (`company_posting_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`company_posting_id`) REFERENCES `company_postings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `college_admin`
--

DROP TABLE IF EXISTS `college_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `college_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `college_id` int NOT NULL,
  `department` varchar(100) DEFAULT 'Training & Placement',
  `designation` varchar(100) DEFAULT 'TPO',
  `phone` varchar(15) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `college_admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `college_admin_ibfk_2` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `college_admin`
--

LOCK TABLES `college_admin` WRITE;
/*!40000 ALTER TABLE `college_admin` DISABLE KEYS */;
INSERT INTO `college_admin` VALUES (3,8,13,'Training & Placement Cell','TPO','9988776655','2026-09-19 18:23:59'),(4,9,14,'Training & Placement Cell','TPO','3344998866','2026-09-21 06:42:07');
/*!40000 ALTER TABLE `college_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colleges`
--

DROP TABLE IF EXISTS `colleges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colleges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `college_name` varchar(200) NOT NULL,
  `college_code` varchar(50) NOT NULL,
  `location` varchar(200) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `registered_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_date` timestamp NULL DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text,
  `logo` varchar(255) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `college_code` (`college_code`),
  UNIQUE KEY `uk_college_code` (`college_code`),
  KEY `fk_colleges_created_by` (`created_by`),
  CONSTRAINT `colleges_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_colleges_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colleges`
--

LOCK TABLES `colleges` WRITE;
/*!40000 ALTER TABLE `colleges` DISABLE KEYS */;
INSERT INTO `colleges` VALUES (1,'SOA University','SOA','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(2,'IIT Bhubaneswar','IITBBS','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(3,'NIT Rourkela','NITR','Rourkela, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Utkal University','UTKAL','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(5,'Ravenshaw University','RAVEN','Cuttack, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(6,'VSSUT Burla','VSSUT','Sambalpur, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(8,'Centurion University','CENTU','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(9,'Siksha O Anusandhan','SOA2','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(10,'Gandhi Institute','GIFT','Bhubaneswar, Odisha','APPROVED','2026-09-11 13:30:50','2026-09-11 13:30:50',NULL,NULL,NULL,NULL,NULL,NULL),(11,'Centurion University','CUTM','Bhubaneswar, Odisha','APPROVED','2026-09-19 14:13:04','2026-09-19 14:13:04',NULL,NULL,NULL,NULL,NULL,NULL),(12,'Centurion University Technology & Management','CUTM1','Bhubaneswar,Jatni','APPROVED','2026-09-19 17:41:31','2026-09-19 17:55:09',NULL,NULL,NULL,NULL,NULL,7),(13,'Centurion University Technology & Management','CUTM3','Bhubaneswar,Jatni','APPROVED','2026-09-19 18:23:59','2026-09-19 18:26:41',NULL,NULL,NULL,NULL,NULL,8),(14,'Centurion University Technology & Management','CUTM4','Balangir','PENDING','2026-09-21 06:42:07',NULL,NULL,NULL,NULL,NULL,NULL,9);
/*!40000 ALTER TABLE `colleges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `colleges_with_companies`
--

DROP TABLE IF EXISTS `colleges_with_companies`;
/*!50001 DROP VIEW IF EXISTS `colleges_with_companies`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `colleges_with_companies` AS SELECT 
 1 AS `posting_id`,
 1 AS `college_id`,
 1 AS `job_title`,
 1 AS `package`,
 1 AS `location`,
 1 AS `last_date`,
 1 AS `cgpa_required`,
 1 AS `backlog_allowed`,
 1 AS `status`,
 1 AS `company_name`,
 1 AS `company_logo`,
 1 AS `industry`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `company_postings`
--

DROP TABLE IF EXISTS `company_postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_postings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `college_id` int NOT NULL,
  `recruiter_id` int NOT NULL,
  `job_title` varchar(150) NOT NULL,
  `job_description` text,
  `package` decimal(10,2) DEFAULT NULL,
  `cgpa_required` decimal(3,2) DEFAULT '0.00',
  `backlog_allowed` int DEFAULT '0',
  `skills_required` text,
  `location` varchar(100) DEFAULT NULL,
  `last_date` date NOT NULL,
  `status` enum('OPEN','CLOSED','COMPLETED') DEFAULT 'OPEN',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `company_logo` varchar(255) DEFAULT NULL,
  `total_vacancies` int DEFAULT '0',
  `drive_date` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `college_id` (`college_id`),
  KEY `recruiter_id` (`recruiter_id`),
  CONSTRAINT `company_postings_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `company_postings_ibfk_2` FOREIGN KEY (`recruiter_id`) REFERENCES `recruiters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_postings`
--

LOCK TABLES `company_postings` WRITE;
/*!40000 ALTER TABLE `company_postings` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_postings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `college_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `message` text NOT NULL,
  `type` varchar(50) DEFAULT 'INFO',
  `is_read` tinyint(1) DEFAULT '0',
  `for_role` enum('STUDENT','RECRUITER','COLLEGE_ADMIN','SUPER_ADMIN','ALL') DEFAULT 'ALL',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recruiters`
--

DROP TABLE IF EXISTS `recruiters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recruiters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `college_id` int NOT NULL,
  `company_name` varchar(150) NOT NULL,
  `hr_name` varchar(100) NOT NULL,
  `hr_email` varchar(100) NOT NULL,
  `company_website` varchar(200) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `company_logo` varchar(255) DEFAULT NULL,
  `company_description` text,
  `industry` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `recruiters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recruiters_ibfk_2` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recruiters`
--

LOCK TABLES `recruiters` WRITE;
/*!40000 ALTER TABLE `recruiters` DISABLE KEYS */;
INSERT INTO `recruiters` VALUES (1,6,11,'Sanjit Roy','Sanjit Roy','tcs31@gmail.com',NULL,'9668656439','PENDING','2026-09-19 15:14:32',NULL,NULL,NULL),(2,10,12,'Mahesh Nayak','Mahesh Nayak','mahesh2008@gmail.com',NULL,'8637255136','PENDING','2026-09-21 06:46:12',NULL,NULL,NULL);
/*!40000 ALTER TABLE `recruiters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resume_analysis`
--

DROP TABLE IF EXISTS `resume_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resume_analysis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `ats_score` int DEFAULT '0',
  `contact_score` int DEFAULT '0',
  `skills_score` int DEFAULT '0',
  `education_score` int DEFAULT '0',
  `experience_score` int DEFAULT '0',
  `keywords_score` int DEFAULT '0',
  `format_score` int DEFAULT '0',
  `suggestions` text,
  `analyzed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `resume_analysis_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resume_analysis`
--

LOCK TABLES `resume_analysis` WRITE;
/*!40000 ALTER TABLE `resume_analysis` DISABLE KEYS */;
/*!40000 ALTER TABLE `resume_analysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `college_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `registration_no` varchar(50) NOT NULL,
  `branch` varchar(50) NOT NULL,
  `passout_year` int DEFAULT '2026',
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `cgpa` decimal(3,2) DEFAULT '0.00',
  `is_placed` tinyint DEFAULT '0',
  `backlogs` int DEFAULT '0',
  `tenth_percentage` decimal(5,2) DEFAULT '0.00',
  `twelfth_percentage` decimal(5,2) DEFAULT '0.00',
  `skills` text,
  `resume_path` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text,
  `profile_photo` varchar(255) DEFAULT NULL,
  `linkedin_url` varchar(255) DEFAULT NULL,
  `github_url` varchar(255) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ats_score` int DEFAULT '0',
  `ats_last_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `registration_no` (`registration_no`),
  KEY `college_id` (`college_id`),
  KEY `fk_students_users` (`user_id`),
  CONSTRAINT `fk_students_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `students_ibfk_2` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,2,8,'Sandhya Rani Padhi','padhi12@gmail.com','250320100142','MSc IT',2026,NULL,NULL,0.00,0,0,0.00,0.00,'',NULL,'7077437891','','uploads\\photos\\student_1.jpeg','','','PENDING','2026-09-11 18:33:59',0,NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `role` enum('SUPER_ADMIN','COLLEGE_ADMIN','STUDENT','RECRUITER') NOT NULL,
  `college_id` int DEFAULT NULL,
  `is_active` tinyint DEFAULT '1',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'','padhi12@gmail.com','Padhi30#',NULL,NULL,'STUDENT',8,1,NULL,'2026-09-11 18:33:59','2026-09-18 09:00:29'),(3,'HireNestAdmin','admin@hirenest.com','Hirenest2005@',NULL,NULL,'SUPER_ADMIN',NULL,1,'2026-09-21 17:28:29','2026-09-19 11:26:24','2026-09-21 17:28:29'),(5,'CUTM Placement Officer','placement@cutm.ac.in','admin123',NULL,NULL,'COLLEGE_ADMIN',11,1,NULL,'2026-09-19 14:08:31','2026-09-19 15:47:16'),(6,'Sanjit Roy','tcs31@gmail.com','test123@90','9668656439',NULL,'RECRUITER',11,1,NULL,'2026-09-19 15:14:32','2026-09-19 15:14:32'),(7,'Jayadratha Nayak','jayadratha12@gmail.com','Jayadrath123@','9456873908',NULL,'COLLEGE_ADMIN',12,1,NULL,'2026-09-19 17:41:31','2026-09-19 17:55:09'),(8,'Arpita Parida','arpita12@gmail.com','Arpita90#','9988776655',NULL,'COLLEGE_ADMIN',13,1,NULL,'2026-09-19 18:23:59','2026-09-19 18:24:49'),(9,'Amrit Panda','amrit90@gmail.com','Amrit90#','3344998866',NULL,'COLLEGE_ADMIN',14,0,NULL,'2026-09-21 06:42:07','2026-09-21 06:42:07'),(10,'Mahesh Nayak','mahesh2008@gmail.com','Mahesh2008@','8637255136',NULL,'RECRUITER',12,1,NULL,'2026-09-21 06:46:12','2026-09-21 06:46:12');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `colleges_with_companies`
--

/*!50001 DROP VIEW IF EXISTS `colleges_with_companies`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `colleges_with_companies` AS select `cp`.`id` AS `posting_id`,`cp`.`college_id` AS `college_id`,`cp`.`job_title` AS `job_title`,`cp`.`package` AS `package`,`cp`.`location` AS `location`,`cp`.`last_date` AS `last_date`,`cp`.`cgpa_required` AS `cgpa_required`,`cp`.`backlog_allowed` AS `backlog_allowed`,`cp`.`status` AS `status`,`r`.`company_name` AS `company_name`,`r`.`company_logo` AS `company_logo`,`r`.`industry` AS `industry` from (`company_postings` `cp` join `recruiters` `r` on((`cp`.`recruiter_id` = `r`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-21 23:10:50
