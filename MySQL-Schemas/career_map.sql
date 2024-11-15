-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: localhost    Database: career_map
-- ------------------------------------------------------
-- Server version	8.0.37-0ubuntu0.23.10.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_plan_summary`
--

DROP TABLE IF EXISTS `action_plan_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_plan_summary` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `responsiblity` enum('self','mentor','self/mentor') COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `action_plan_summary_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_plan_summary`
--

LOCK TABLES `action_plan_summary` WRITE;
/*!40000 ALTER TABLE `action_plan_summary` DISABLE KEYS */;
INSERT INTO `action_plan_summary` VALUES (1,'Complete Adobe Creative Suite course','self',1),(2,'Participate in UI/UX Design Workshop','self',1),(3,'Enroll in HTML, CSS, and JavaScript Bootcamp','self',1),(4,'Find a mentor for career guidance','mentor',1),(5,'Build a personal web project portfolio','self',1),(6,'Complete PHP, HTML/CSS, JavaScript, and WordPress development trainings','self',2),(7,'Develop SEO skills through online courses','self',2),(8,'Enroll in leadership and communication workshops','self',2),(9,'Prepare for PMP Certification and Agile training','self',2),(10,'Seek mentorship for project management guidance','mentor',2);
/*!40000 ALTER TABLE `action_plan_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `step_id` bigint DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`step_id`),
  KEY `fk_branch_path_id` (`path_id`),
  CONSTRAINT `fk_branch_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_branch_step_id` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,NULL,'#f4b084',1),(2,1,'#a9d08e',1),(3,1,'#ccccff',1),(4,1,'#9bc2e6',1),(5,NULL,'#f4b084',2),(6,16,'#a9d08e',2),(7,16,'#ccccff',2),(8,16,'#9bc2e6',2),(9,NULL,'#f4b084',10),(10,37,'#a9d08e',10),(11,37,'#ccccff',10),(12,37,'#9bc2e6',10);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_goals_overview`
--

DROP TABLE IF EXISTS `career_goals_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_goals_overview` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `title` text COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('s','l') COLLATE utf8mb4_general_ci NOT NULL,
  `completion_date` varchar(350) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `career_goals_overview_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_goals_overview`
--

LOCK TABLES `career_goals_overview` WRITE;
/*!40000 ALTER TABLE `career_goals_overview` DISABLE KEYS */;
INSERT INTO `career_goals_overview` VALUES (1,1,'Master Graphic Design Tools and Concepts','s','2025-04-01'),(2,1,'Develop Proficiency in Web Development Fundamentals','s','2025-10-01'),(3,1,'Build and Diversify a Web Development Portfolio','s','2026-04-01'),(4,1,'Gain Experience with Frontend Frameworks','s','2026-10-01'),(5,1,'Secure a Frontend Developer Position','l','2027-04-01'),(6,1,'Advance to Senior Frontend Developer','l','2028-04-01'),(7,2,'Transition from WordPress Developer to Project Manager','s','2025-10-01'),(8,2,'Obtain PMP Certification and Agile Methodology Expertise','s','2026-04-01'),(9,2,'Lead Data Science Projects','l','2027-10-01'),(10,2,'Become a Data Science Manager','l','2028-10-01'),(11,2,'Achieve Director of Data Science Role','l','2029-10-01');
/*!40000 ALTER TABLE `career_goals_overview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_path_progression_map`
--

DROP TABLE IF EXISTS `career_path_progression_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_path_progression_map` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `suggested_timing` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `career_path_progression_map_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_path_progression_map`
--

LOCK TABLES `career_path_progression_map` WRITE;
/*!40000 ALTER TABLE `career_path_progression_map` DISABLE KEYS */;
INSERT INTO `career_path_progression_map` VALUES (1,1,'Graphic Designer',NULL),(2,1,'Junior Web Developer','6 months'),(3,1,'Frontend Developer','12 months'),(4,1,'Senior Frontend Developer','18 months'),(5,2,'Current WordPress Developer Role',NULL),(6,2,'Project Manager','12 months'),(7,2,'Data Science Project Lead','12 months'),(8,2,'Data Science Manager','12 months'),(9,2,'Director of Data Science','12 months');
/*!40000 ALTER TABLE `career_path_progression_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facebook_login`
--

DROP TABLE IF EXISTS `facebook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facebook_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `facebook_id` (`facebook_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facebook_login`
--

LOCK TABLES `facebook_login` WRITE;
/*!40000 ALTER TABLE `facebook_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `facebook_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_login`
--

DROP TABLE IF EXISTS `google_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `google_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `google_id` (`google_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_login`
--

LOCK TABLES `google_login` WRITE;
/*!40000 ALTER TABLE `google_login` DISABLE KEYS */;
INSERT INTO `google_login` VALUES (4,'109075669814140893830','pycess76x@gmail.com','Talha Hussain','https://lh3.googleusercontent.com/a/ACg8ocIa9k1DVtuum9RBvO7yaYjcaUZX_ev4cXOl8ZxFOR8fZ9nnBA=s96-c','2024-08-08 11:14:20','2024-08-08 11:14:20'),(5,'110076916993612126119','pc16777.syedtalhahussain@gmail.com','Syed Talha Hussain','https://lh3.googleusercontent.com/a/ACg8ocJtV42Mo0Nk89nzEzcKovoOy8Ew1iCB7WPeu9EZHvJ9ZmowSw=s96-c','2024-08-12 08:23:09','2024-08-13 11:17:13'),(8,'116605168680275671000','syedtalha71x@gmail.com','Talha','https://lh3.googleusercontent.com/a/ACg8ocI0Uc1DRZWyA28sY-Byf-q1MEw_4kAkUp_6eGDY9R3-FlAGXw=s96-c','2024-08-22 09:43:07','2024-08-22 09:43:07');
/*!40000 ALTER TABLE `google_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpt_data`
--

DROP TABLE IF EXISTS `gpt_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpt_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `result` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `step_id` bigint NOT NULL,
  `parent_gpt_id` varchar(350) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `prompt` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `gpt_data_logs_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpt_data`
--

LOCK TABLES `gpt_data` WRITE;
/*!40000 ALTER TABLE `gpt_data` DISABLE KEYS */;
INSERT INTO `gpt_data` VALUES (1,'Becoming an automation expert involves a combination of education, hands-on experience, and continuous learning in the field of automation technologies. Here are the steps you can take to develop your skills and advance your career as an automation expert:\n\n### 1. **Educational Background**\n   - **Earn a Relevant Degree**: Consider obtaining a degree in computer science, software engineering, information technology, electrical engineering, or a related field. This foundational knowledge is critical for understanding automation principles and technologies.\n   - **Cert',23,NULL,'2024-11-04 08:23:45','how to become an automation expert '),(2,'Gaining experience in automation after you\'ve acquired the necessary skills can be accomplished through a variety of approaches. Here are some effective strategies:\n\n### 1. **Hands-On Projects**\n   - **Personal Projects**: Create your own automation projects using tools like Selenium (for web applications), Ansible, Puppet, or automation scripts. Open-source projects can provide a great way to practice and showcase your skills.\n   - **Automation Challenges**: Participate in coding challenges or hackathons that focus on automation solutions.',23,'1','2024-11-04 08:23:55','after learning automation how to get experience '),(3,'Becoming a lead data engineer typically requires a combination of educational qualifications, technical skills, experience, and soft skills. Here’s a step-by-step guide to help you achieve this goal:\n\n### 1. Educational Background\n- **Degree**: Obtain a bachelor’s degree in a relevant field such as Computer Science, Information Technology, Software Engineering, Mathematics, or a related discipline. A master’s degree can be a plus but is not always necessary.\n  \n### 2. Gain Relevant Experience\n-',24,NULL,'2024-11-04 13:27:06','how can i become a lead data engineer  '),(4,'Transitioning from an automation role to a DevOps position involves building on your automation skills and learning about the broader practices and tools associated with DevOps. Here are the steps you can take:\n\n### 1. **Understand DevOps Principles**\n   - **Cultural Shift**: Familiarize yourself with the DevOps culture, which emphasizes collaboration between development and operations teams, continuous integration, continuous delivery (CI/CD), and Agile methodologies.\n   - **Learn the DevOps Lifecycle**: Understand the stages',23,'2','2024-11-04 13:27:53','after automation what were the further steps for devops  ');
/*!40000 ALTER TABLE `gpt_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instagram_login`
--

DROP TABLE IF EXISTS `instagram_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instagram_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instagram_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `instagram_id` (`instagram_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instagram_login`
--

LOCK TABLES `instagram_login` WRITE;
/*!40000 ALTER TABLE `instagram_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `instagram_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `linkedin_login`
--

DROP TABLE IF EXISTS `linkedin_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `linkedin_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `linkedin_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `linkedin_id` (`linkedin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `linkedin_login`
--

LOCK TABLES `linkedin_login` WRITE;
/*!40000 ALTER TABLE `linkedin_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `linkedin_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_subscription`
--

DROP TABLE IF EXISTS `model_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_subscription` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `payment_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `branch_id` int NOT NULL,
  `amount` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_subscription`
--

LOCK TABLES `model_subscription` WRITE;
/*!40000 ALTER TABLE `model_subscription` DISABLE KEYS */;
INSERT INTO `model_subscription` VALUES (1,28,'0',3,10,'2024-10-28 12:07:53','2024-10-28 12:07:53'),(2,28,'0',3,10,'2024-10-28 12:11:29','2024-10-28 12:11:29'),(3,28,'0',5,10,'2024-10-28 12:11:47','2024-10-28 12:11:47'),(4,28,'0',5,10,'2024-10-28 12:17:55','2024-10-28 12:17:55'),(5,28,'pi_3QErrfIILuhliL1z1JtyoKQj',5,10,'2024-10-28 12:27:42','2024-10-28 12:27:42'),(6,28,'pi_3QEs3gIILuhliL1z0LkqmO8s',3,10,'2024-10-28 12:28:52','2024-10-28 12:28:52'),(7,28,'pi_3QEsHvIILuhliL1z1ATAbNvM',1,10,'2024-10-28 12:43:43','2024-10-28 12:43:43'),(8,28,'pi_3QEsJ7IILuhliL1z1RfI8Ghi',7,10,'2024-10-28 12:44:45','2024-10-28 12:44:45'),(9,40,'pi_3QIShkIILuhliL1z1WBcxyP9',11,10,'2024-11-07 10:12:52','2024-11-07 10:12:52');
/*!40000 ALTER TABLE `model_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES (1,'Transaction');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `next_steps_recommendations`
--

DROP TABLE IF EXISTS `next_steps_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `next_steps_recommendations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `recommendations` text COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `next_steps_recommendations_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `next_steps_recommendations`
--

LOCK TABLES `next_steps_recommendations` WRITE;
/*!40000 ALTER TABLE `next_steps_recommendations` DISABLE KEYS */;
INSERT INTO `next_steps_recommendations` VALUES (1,1,'Focus on mastering responsive design techniques.'),(2,1,'Develop a strong understanding of JavaScript fundamentals.'),(3,1,'Start building a portfolio of web development projects.'),(4,2,'Focus on completing all pending technical skills within the next 6 months.'),(5,2,'Schedule regular sessions with a mentor to discuss career progression.'),(6,2,'Engage in networking opportunities to connect with professionals in desired roles.');
/*!40000 ALTER TABLE `next_steps_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `title` varchar(350) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(350) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `read` tinyint NOT NULL DEFAULT '0',
  `seen` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (3,30,'System Maintenance Scheduled','Our system will be undergoing maintenance on October 1st at 10:00 PM.','https://www.google.com/',1,1),(4,30,'Database Admin Scheduled','Our database admin system will be undergoing maintenance on September 1st at 8:00 PM.','https://www.google.com/',1,1),(5,30,'I am an infrastructure Specialist','This path has been analyse',NULL,1,1),(6,30,'react js developer','This path has been analyse',NULL,1,1),(7,30,'react js developer','This path has been analyse',NULL,0,0),(8,36,'Law grad to solicitor','This path has been analyse',NULL,1,1),(9,36,'Pipefitter to superintendant ','This path has been analyse',NULL,1,1),(10,36,'Law ','This path has been analyse',NULL,1,1),(11,36,'law 2','This path has been analyse',NULL,1,1),(12,28,'javascript','This path has been analyse',NULL,1,1),(13,30,'Law grad to solicitor','This path has been analyse',NULL,0,0),(14,30,'Pipefitter to superintendant ','This path has been analyse',NULL,0,0),(15,30,'Law ','This path has been analyse',NULL,0,0),(16,30,'law 2','This path has been analyse',NULL,0,0),(17,30,'javascript','This path has been analyse',NULL,0,0),(18,36,'IT Specialist Career','This path has been analyse',NULL,0,1),(19,37,'javascript','This path has been analyse',NULL,1,1),(20,37,'python developer','This path has been analyse',NULL,1,1),(21,37,'data entry','This path has been analyse',NULL,1,1),(22,37,'data entry operator','This path has been analyse',NULL,1,1),(23,28,'frontend developer','This path has been analyse',NULL,1,1),(24,37,'ml engineer','This path has been analyse',NULL,1,1),(25,37,' Machine learning developer','This path has been analyse',NULL,1,1),(26,37,'react js developer','This path has been analyse',NULL,1,1),(27,37,'react js developer','This path has been analyse',NULL,1,1),(28,37,'ai engineer','This path has been analyse',NULL,1,1),(29,37,'data entry operator','This path has been analyse',NULL,1,1),(30,37,' python developer','This path has been analyse',NULL,1,1),(31,37,' python developer','This path has been analyse',NULL,1,1),(32,37,' python developer','This path has been analyse',NULL,1,1),(33,37,'python developer','This path has been analyse',NULL,1,1),(34,37,' python developer','This path has been analyse',NULL,1,1),(35,37,'mechanic ','This path has been analyse',NULL,1,1),(36,37,'blockchain developer','This path has been analyse',NULL,1,1),(37,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(38,37,' python developer','This path has been analyse',NULL,1,1),(39,37,' python developer','This path has been analyse',NULL,1,1),(40,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(41,37,'mechanic ','This path has been analyse',NULL,1,1),(42,37,'react js developer','This path has been analyse',NULL,1,1),(43,37,'data entry operator','This path has been analyse',NULL,1,1),(44,37,'ai engineer','This path has been analyse',NULL,1,1),(45,37,'data entry operator','This path has been analyse',NULL,1,1),(46,37,'singer','This path has been analyse',NULL,1,1),(47,37,'python developer banna hy mujhe','This path has been analyse',NULL,1,1),(48,37,'python developer banna hy mujhe','This path has been analyse',NULL,1,1),(49,37,'javascript deveoper','This path has been analyse',NULL,1,1),(50,37,'ml engineer','This path has been analyse',NULL,1,1),(51,37,'javascript deveoper','This path has been analyse',NULL,1,1),(52,28,'python developer','This path has been analyse',NULL,1,1),(53,28,'python developer','This path has been analyse',NULL,1,1),(54,28,'python developer','This path has been analyse',NULL,1,1),(55,28,'singer','This path has been analyse',NULL,0,0),(56,28,'ai engineer','This path has been analyse',NULL,0,0),(57,28,'frontend developer','This path has been analyse',NULL,0,0),(58,28,'graphic designer','This path has been analyse',NULL,0,0),(59,28,'wordpress developer','This path has been analyse',NULL,0,0),(60,40,'video editor','This path has been analyse',NULL,0,1);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outlook_login`
--

DROP TABLE IF EXISTS `outlook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outlook_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `outlook_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outlook_id` (`outlook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outlook_login`
--

LOCK TABLES `outlook_login` WRITE;
/*!40000 ALTER TABLE `outlook_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `outlook_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `path`
--

DROP TABLE IF EXISTS `path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `path` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `prompt` longtext COLLATE utf8mb4_unicode_ci,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','analysed','analysing') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `user_id` int DEFAULT NULL,
  `title` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gpt_id` varchar(350) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `path_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `path`
--

LOCK TABLES `path` WRITE;
/*!40000 ALTER TABLE `path` DISABLE KEYS */;
INSERT INTO `path` VALUES (1,'I am a graphic designer & wanna be a Frontend Developer.',NULL,'analysed',28,'graphic designer',NULL),(2,'I am a wordpress developer & wanna be a data scientist what would be the roadmap for it?',NULL,'analysed',28,'wordpress developer',NULL),(3,'Welcome to the era of automation',NULL,'pending',30,'I am an automation expert',NULL),(4,'Welcome to the era of frontend',NULL,'pending',30,'I am an frontend expert',NULL),(5,'Welcome to the era of backend',NULL,'pending',30,'I am an backend expert',NULL),(6,'Welcome to the era of devops',NULL,'pending',30,'I am an devops expert',NULL),(7,'Welcome to the era of infrastructure',NULL,'pending',30,'I am an infrastructure expert',NULL),(8,'Welcome to the era of ml',NULL,'pending',30,'I am an ml expert',NULL),(9,'Welcome to the era of ml',NULL,'pending',30,'I am an ml expert',NULL),(10,'how can I shift my field from video editor to civil engineer?',NULL,'analysed',40,'video editor',NULL),(11,'I am a graphic designer & wanna be a machine learning engineer',NULL,'pending',7,'graphic designer',NULL);
/*!40000 ALTER TABLE `path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_modules`
--

DROP TABLE IF EXISTS `permission_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_modules` (
  `permission_id` int DEFAULT NULL,
  `module_id` int DEFAULT NULL,
  KEY `permission_id` (`permission_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `permission_modules_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `permission_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_modules`
--

LOCK TABLES `permission_modules` WRITE;
/*!40000 ALTER TABLE `permission_modules` DISABLE KEYS */;
INSERT INTO `permission_modules` VALUES (1,1);
/*!40000 ALTER TABLE `permission_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_to_role`
--

DROP TABLE IF EXISTS `permission_to_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_to_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `permission_to_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permission_to_role_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_to_role`
--

LOCK TABLES `permission_to_role` WRITE;
/*!40000 ALTER TABLE `permission_to_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_to_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'create','2024-11-15 10:04:32','2024-11-15 10:04:32','subscriptions-create');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_to_users`
--

DROP TABLE IF EXISTS `role_to_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_to_users` (
  `role_id` int NOT NULL,
  `user_id` int NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `role_to_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `role_to_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_to_users`
--

LOCK TABLES `role_to_users` WRITE;
/*!40000 ALTER TABLE `role_to_users` DISABLE KEYS */;
INSERT INTO `role_to_users` VALUES (1,1,1),(2,2,2),(2,3,3),(3,4,4),(2,6,6),(2,7,7);
/*!40000 ALTER TABLE `role_to_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Super Admin','2024-11-11 12:47:56','2024-11-11 12:47:56'),(2,'Admin','2024-11-11 12:50:19','2024-11-11 12:50:19'),(3,'User','2024-11-11 12:51:28','2024-11-11 12:51:28'),(4,'Sub Admin','2024-11-13 12:14:27','2024-11-13 12:14:27');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_gap_analysis`
--

DROP TABLE IF EXISTS `skill_gap_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_gap_analysis` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `title` text COLLATE utf8mb4_general_ci NOT NULL,
  `priority` enum('High','Medium','Low') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('pending','completed') COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `skill_gap_analysis_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis`
--

LOCK TABLES `skill_gap_analysis` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis` DISABLE KEYS */;
INSERT INTO `skill_gap_analysis` VALUES (1,1,'Adobe Creative Suite','High','pending'),(2,1,'UI/UX Design','High','pending'),(3,1,'Typography','Medium','pending'),(4,1,'Color Theory','Medium','pending'),(5,1,'Responsive Design','High','pending'),(6,1,'HTML','High','pending'),(7,1,'CSS','High','pending'),(8,1,'JavaScript','High','pending'),(9,1,'DOM Manipulation','High','pending'),(10,1,'Project Management','Medium','pending'),(11,1,'Git/GitHub','High','pending'),(12,1,'Web Design','High','pending'),(13,1,'Debugging','High','pending'),(14,1,'Code Optimization','Medium','pending'),(15,1,'React','High','pending'),(16,1,'Vue.js','High','pending'),(17,1,'State Management','High','pending'),(18,1,'Component-Based Architecture','High','pending'),(19,1,'Single Page Applications','High','pending'),(20,1,'Interviewing','High','pending'),(21,1,'Technical Communication','Medium','pending'),(22,1,'Problem Solving','High','pending'),(23,1,'Team Collaboration','Medium','pending'),(24,1,'Adaptability','Medium','pending'),(25,1,'Advanced JavaScript','High','pending'),(26,1,'Performance Optimization','Medium','pending'),(27,1,'Security Best Practices','Medium','pending'),(28,1,'Testing and Debugging','High','pending'),(29,1,'Mentorship','Medium','pending'),(30,2,'PHP','High','pending'),(31,2,'HTML/CSS','High','pending'),(32,2,'JavaScript','High','pending'),(33,2,'WordPress CMS','High','pending'),(34,2,'SEO','High','pending'),(35,2,'Leadership','High','pending'),(36,2,'Communication','High','pending'),(37,2,'Project Planning','High','pending'),(38,2,'Budget Management','High','pending'),(39,2,'Risk Management','High','pending'),(40,2,'PMP Certification','High','pending'),(41,2,'Agile Methodology','High','pending'),(42,2,'Process Improvement','High','pending'),(43,2,'Time Management','High','pending'),(44,2,'Stakeholder Engagement','High','pending'),(45,2,'Data Science Project Management','High','pending'),(46,2,'Team Leadership','High','pending'),(47,2,'Resource Allocation','High','pending'),(48,2,'Performance Metrics','High','pending'),(49,2,'Strategic Planning','High','pending'),(50,2,'Team Building','High','pending'),(51,2,'Advanced Data Science','High','pending'),(52,2,'Business Acumen','High','pending'),(53,2,'Decision Making','High','pending'),(54,2,'Visionary Leadership','High','pending'),(55,2,'Executive Leadership','High','pending'),(56,2,'Strategic Vision','High','pending'),(57,2,'Industry Expertise','High','pending'),(58,2,'Organizational Development','High','pending'),(59,2,'Innovation Management','High','pending');
/*!40000 ALTER TABLE `skill_gap_analysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_gap_analysis_resources`
--

DROP TABLE IF EXISTS `skill_gap_analysis_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_gap_analysis_resources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `skill_gap_analysis_id` bigint NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `platform` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis_resources`
--

LOCK TABLES `skill_gap_analysis_resources` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis_resources` DISABLE KEYS */;
INSERT INTO `skill_gap_analysis_resources` VALUES (1,1,'Adobe Creative Suite','Udemy','https://www.udemy.com/adobe-creative-cloud-course/'),(2,2,'UI/UX Design','Coursera','https://www.coursera.org/specializations/ui-ux-design'),(3,3,'Typography','LinkedIn Learning','https://www.linkedin.com/learning/typography-complete-guide'),(4,4,'Color Theory','Skillshare','https://www.skillshare.com/classes/Color-Theory-for-Designers/1234567'),(5,5,'Responsive Design','freeCodeCamp','https://www.freecodecamp.org/learn/responsive-web-design/'),(6,6,'HTML','Codecademy','https://www.codecademy.com/learn/learn-html'),(7,7,'CSS','W3Schools','https://www.w3schools.com/css/'),(8,8,'JavaScript','MDN Web Docs','https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide'),(9,9,'DOM Manipulation','YouTube','https://www.youtube.com/watch?v=0ik6X4DJKCc'),(10,10,'Project Management','Coursera','https://www.coursera.org/learn/project-management'),(11,11,'Git/GitHub','GitHub Learning Lab','https://lab.github.com/githubtraining/introduction-to-github'),(12,12,'Web Design','Udacity','https://www.udacity.com/course/web-design-for-everybody--ud304'),(13,13,'Debugging','Pluralsight','https://www.pluralsight.com/courses/debugging-javascript-chrome'),(14,14,'Code Optimization','Coursera','https://www.coursera.org/learn/web-application-optimization'),(15,15,'React','React Official Website','https://reactjs.org/docs/getting-started.html'),(16,16,'Vue.js','Vue.js Official Website','https://vuejs.org/v2/guide/'),(17,17,'State Management','Egghead.io','https://egghead.io/courses/manage-complex-state-in-react-apps-with-redux'),(18,18,'Component-Based Architecture','Udemy','https://www.udemy.com/course/react-the-complete-guide-incl-redux/'),(19,19,'Single Page Applications','Pluralsight','https://www.pluralsight.com/courses/angularjs-building-spa'),(20,20,'Interviewing','LinkedIn Learning','https://www.linkedin.com/learning/mastering-common-interview-questions'),(21,21,'Technical Communication','Coursera','https://www.coursera.org/learn/technical-communication'),(22,22,'Problem Solving','Khan Academy','https://www.khanacademy.org/college-careers-more/personal-finance/problem-solving'),(23,23,'Team Collaboration','Skillshare','https://www.skillshare.com/classes/Successful-Collaboration-Working-in-a-Team/2345678'),(24,24,'Adaptability','Udemy','https://www.udemy.com/course/adaptability-the-key-to-success/'),(25,25,'Advanced JavaScript','Eloquent JavaScript','https://eloquentjavascript.net/'),(26,26,'Performance Optimization','Udacity','https://www.udacity.com/course/website-performance-optimization--ud884'),(27,27,'Security Best Practices','Coursera','https://www.coursera.org/learn/web-security-fundamentals'),(28,28,'Testing and Debugging','Pluralsight','https://www.pluralsight.com/courses/javascript-testing-debugging'),(29,29,'Mentorship','LinkedIn Learning','https://www.linkedin.com/learning/becoming-a-thought-leader'),(30,30,'PHP','Udemy','https://www.udemy.com/course/php-for-beginners/'),(31,30,'PHP','Codecademy','https://www.codecademy.com/learn/learn-php'),(32,31,'HTML/CSS','Coursera','https://www.coursera.org/learn/html-css-javascript'),(33,31,'HTML/CSS','FreeCodeCamp','https://www.freecodecamp.org/learn/responsive-web-design/'),(34,32,'JavaScript','Mozilla Developer Network','https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide'),(35,32,'JavaScript','Udemy','https://www.udemy.com/course/the-complete-javascript-course/'),(36,33,'WordPress CMS','LinkedIn Learning','https://www.linkedin.com/learning/wordpress-essential-training'),(37,33,'WordPress CMS','WordPress Codex','https://codex.wordpress.org/Getting_Started_with_WordPress'),(38,34,'SEO','Google Digital Garage','https://learndigital.withgoogle.com/digitalgarage/course/digital-marketing'),(39,34,'SEO','Moz','https://moz.com/beginners-guide-to-seo'),(40,35,'Leadership','Coursera','https://www.coursera.org/courses?query=leadership'),(41,35,'Leadership','LinkedIn Learning','https://www.linkedin.com/learning/leadership-foundations'),(42,36,'Communication','Udemy','https://www.udemy.com/course/communication-skills-for-beginners/'),(43,36,'Communication','LinkedIn Learning','https://www.linkedin.com/learning/communicating-with-confidence'),(44,37,'Project Planning','Coursera','https://www.coursera.org/learn/project-management'),(45,37,'Project Planning','Project Management Institute','https://www.pmi.org/learning/library/project-planning-structure-6571'),(46,38,'Budget Management','edX','https://www.edx.org/course/financial-management'),(47,38,'Budget Management','LinkedIn Learning','https://www.linkedin.com/learning/budgeting-in-project-management'),(48,39,'Risk Management','Coursera','https://www.coursera.org/learn/risk-management'),(49,39,'Risk Management','Udemy','https://www.udemy.com/course/risk-management/'),(50,40,'PMP Certification','PMI','https://www.pmi.org/certifications/project-management-pmp'),(51,40,'PMP Certification','LinkedIn Learning','https://www.linkedin.com/learning/prepare-for-the-project-management-professional-pmp-exam'),(52,41,'Agile Methodology','Scrum.org','https://www.scrum.org/resources/training'),(53,41,'Agile Methodology','Coursera','https://www.coursera.org/specializations/agile-development'),(54,42,'Process Improvement','LinkedIn Learning','https://www.linkedin.com/learning/process-improvement-foundations'),(55,42,'Process Improvement','Coursera','https://www.coursera.org/learn/introduction-process-improvement'),(56,43,'Time Management','Udemy','https://www.udemy.com/course/productivity-and-time-management/'),(57,43,'Time Management','LinkedIn Learning','https://www.linkedin.com/learning/time-management-fundamentals'),(58,44,'Stakeholder Engagement','Coursera','https://www.coursera.org/learn/stakeholder-management'),(59,44,'Stakeholder Engagement','LinkedIn Learning','https://www.linkedin.com/learning/engaging-stakeholders'),(60,45,'Data Science Project Management','Coursera','https://www.coursera.org/learn/data-science-project-management'),(61,45,'Data Science Project Management','DataCamp','https://www.datacamp.com/courses/managing-data-science-projects'),(62,46,'Team Leadership','LinkedIn Learning','https://www.linkedin.com/learning/leading-your-team'),(63,46,'Team Leadership','Coursera','https://www.coursera.org/learn/team-leadership-communication'),(64,47,'Resource Allocation','Udemy','https://www.udemy.com/course/resource-allocation/'),(65,47,'Resource Allocation','LinkedIn Learning','https://www.linkedin.com/learning/managing-resources'),(66,48,'Performance Metrics','Coursera','https://www.coursera.org/learn/measuring-performance'),(67,48,'Performance Metrics','LinkedIn Learning','https://www.linkedin.com/learning/performance-management'),(68,49,'Strategic Planning','Udemy','https://www.udemy.com/course/strategic-planning/'),(69,49,'Strategic Planning','LinkedIn Learning','https://www.linkedin.com/learning/strategic-planning-foundations'),(70,50,'Team Building','Coursera','https://www.coursera.org/learn/high-performing-teams'),(71,50,'Team Building','LinkedIn Learning','https://www.linkedin.com/learning/team-building'),(72,51,'Advanced Data Science','edX','https://www.edx.org/micromasters/advanced-data-science'),(73,51,'Advanced Data Science','Coursera','https://www.coursera.org/specializations/aml'),(74,52,'Business Acumen','LinkedIn Learning','https://www.linkedin.com/learning/developing-business-acumen'),(75,52,'Business Acumen','Coursera','https://www.coursera.org/specializations/business-strategy'),(76,53,'Decision Making','Udemy','https://www.udemy.com/course/decision-making/'),(77,53,'Decision Making','LinkedIn Learning','https://www.linkedin.com/learning/making-decisions'),(78,54,'Visionary Leadership','Coursera','https://www.coursera.org/learn/visionary-leadership'),(79,54,'Visionary Leadership','LinkedIn Learning','https://www.linkedin.com/learning/visionary-leadership-skills'),(80,55,'Executive Leadership','Harvard Business School Online','https://online.hbs.edu/courses/executive-leadership/'),(81,55,'Executive Leadership','LinkedIn Learning','https://www.linkedin.com/learning/executive-leadership'),(82,56,'Strategic Vision','Coursera','https://www.coursera.org/specializations/strategic-leadership'),(83,56,'Strategic Vision','LinkedIn Learning','https://www.linkedin.com/learning/strategic-vision'),(84,57,'Industry Expertise','Coursera','https://www.coursera.org/specializations/industry-4-0'),(85,57,'Industry Expertise','LinkedIn Learning','https://www.linkedin.com/learning/industry-expertise'),(86,58,'Organizational Development','LinkedIn Learning','https://www.linkedin.com/learning/organizational-development'),(87,58,'Organizational Development','Coursera','https://www.coursera.org/learn/organizational-development'),(88,59,'Innovation Management','Coursera','https://www.coursera.org/specializations/innovation-management'),(89,59,'Innovation Management','LinkedIn Learning','https://www.linkedin.com/learning/innovation-management');
/*!40000 ALTER TABLE `skill_gap_analysis_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort` tinyint(1) NOT NULL,
  `step_id` bigint DEFAULT NULL,
  `status` enum('pending','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (1,'Adobe Creative Suite',1,1,'pending'),(2,'UI/UX Design',2,1,'pending'),(3,'Typography',3,1,'pending'),(4,'Color Theory',4,1,'pending'),(5,'Responsive Design',5,1,'pending'),(6,'User Research',1,2,'pending'),(7,'Wireframing',2,2,'pending'),(8,'Prototyping',3,2,'pending'),(9,'Usability Testing',4,2,'pending'),(10,'Information Architecture',5,2,'pending'),(11,'SEO',1,3,'pending'),(12,'Content Creation',2,3,'pending'),(13,'Social Media Management',3,3,'pending'),(14,'Analytics',4,3,'pending'),(15,'Campaign Management',5,3,'pending'),(16,'Leadership',1,4,'pending'),(17,'Project Management',2,4,'pending'),(18,'Creative Strategy',3,4,'pending'),(19,'Team Management',4,4,'pending'),(20,'Brand Development',5,4,'pending'),(21,'Team Leadership',1,5,'pending'),(22,'Conflict Resolution',2,5,'pending'),(23,'Performance Management',3,5,'pending'),(24,'Budgeting',4,5,'pending'),(25,'Resource Allocation',5,5,'pending'),(26,'Product Roadmapping',1,6,'pending'),(27,'Stakeholder Management',2,6,'pending'),(28,'Market Analysis',3,6,'pending'),(29,'Agile Methodologies',4,6,'pending'),(30,'Prioritization',5,6,'pending'),(31,'Visionary Leadership',1,7,'pending'),(32,'Strategic Planning',2,7,'pending'),(33,'Design Thinking',3,7,'pending'),(34,'Innovation',4,7,'pending'),(35,'Mentorship',5,7,'pending'),(36,'HTML/CSS',1,8,'pending'),(37,'JavaScript',2,8,'pending'),(38,'Version Control (Git)',3,8,'pending'),(39,'Responsive Design',4,8,'pending'),(40,'Cross-Browser Compatibility',5,8,'pending'),(41,'Node.js',1,9,'pending'),(42,'Database Management',2,9,'pending'),(43,'APIs',3,9,'pending'),(44,'Server-Side Logic',4,9,'pending'),(45,'Cloud Services',5,9,'pending'),(46,'Technical Leadership',1,10,'pending'),(47,'Code Review',2,10,'pending'),(48,'Architecture Design',3,10,'pending'),(49,'Continuous Integration',4,10,'pending'),(50,'Quality Assurance',5,10,'pending'),(51,'HTML',1,11,'pending'),(52,'CSS',2,11,'pending'),(53,'JavaScript',3,11,'pending'),(54,'Responsive Design',4,11,'pending'),(55,'DOM Manipulation',5,11,'pending'),(56,'Project Management',1,12,'pending'),(57,'Git/GitHub',2,12,'pending'),(58,'Web Design',3,12,'pending'),(59,'Debugging',4,12,'pending'),(60,'Code Optimization',5,12,'pending'),(61,'React',1,13,'pending'),(62,'Vue.js',2,13,'pending'),(63,'State Management',3,13,'pending'),(64,'Component-Based Architecture',4,13,'pending'),(65,'Single Page Applications',5,13,'pending'),(66,'Interviewing',1,14,'pending'),(67,'Technical Communication',2,14,'pending'),(68,'Problem Solving',3,14,'pending'),(69,'Team Collaboration',4,14,'pending'),(70,'Adaptability',5,14,'pending'),(71,'Advanced JavaScript',1,15,'pending'),(72,'Performance Optimization',2,15,'pending'),(73,'Security Best Practices',3,15,'pending'),(74,'Testing and Debugging',4,15,'pending'),(75,'Mentorship',5,15,'pending'),(76,'PHP',1,16,'pending'),(77,'HTML/CSS',2,16,'pending'),(78,'JavaScript',3,16,'pending'),(79,'WordPress CMS',4,16,'pending'),(80,'SEO',5,16,'pending'),(81,'Excel',1,17,'pending'),(82,'SQL',2,17,'pending'),(83,'Data Visualization',3,17,'pending'),(84,'Statistical Analysis',4,17,'pending'),(85,'Critical Thinking',5,17,'pending'),(86,'Data Science Basics',1,18,'pending'),(87,'Networking',2,18,'pending'),(88,'Problem-Solving',3,18,'pending'),(89,'Team Collaboration',4,18,'pending'),(90,'Project Management',5,18,'pending'),(91,'Portfolio Development',1,19,'pending'),(92,'Python for Data Science',2,19,'pending'),(93,'Data Cleaning',3,19,'pending'),(94,'Visualization Tools',4,19,'pending'),(95,'Git/GitHub',5,19,'pending'),(96,'Community Engagement',1,20,'pending'),(97,'Continuous Learning',2,20,'pending'),(98,'Mentorship',3,20,'pending'),(99,'Knowledge Sharing',4,20,'pending'),(100,'Networking',5,20,'pending'),(101,'Open Source Contribution',1,21,'pending'),(102,'Collaboration',2,21,'pending'),(103,'Coding Best Practices',3,21,'pending'),(104,'Version Control',4,21,'pending'),(105,'Problem Solving',5,21,'pending'),(106,'Leadership',1,22,'pending'),(107,'Communication',2,22,'pending'),(108,'Project Planning',3,22,'pending'),(109,'Budget Management',4,22,'pending'),(110,'Risk Management',5,22,'pending'),(111,'PMP Certification',1,23,'pending'),(112,'Agile Methodology',2,23,'pending'),(113,'Process Improvement',3,23,'pending'),(114,'Time Management',4,23,'pending'),(115,'Stakeholder Engagement',5,23,'pending'),(116,'Data Science Project Management',1,24,'pending'),(117,'Team Leadership',2,24,'pending'),(118,'Resource Allocation',3,24,'pending'),(119,'Performance Metrics',4,24,'pending'),(120,'Strategic Planning',5,24,'pending'),(121,'Team Building',1,25,'pending'),(122,'Advanced Data Science',2,25,'pending'),(123,'Business Acumen',3,25,'pending'),(124,'Decision Making',4,25,'pending'),(125,'Visionary Leadership',5,25,'pending'),(126,'Executive Leadership',1,26,'pending'),(127,'Strategic Vision',2,26,'pending'),(128,'Industry Expertise',3,26,'pending'),(129,'Organizational Development',4,26,'pending'),(130,'Innovation Management',5,26,'pending'),(131,'Python',1,27,'pending'),(132,'Data Structures',2,27,'pending'),(133,'Libraries (Pandas, NumPy)',3,27,'pending'),(134,'Data Manipulation',4,27,'pending'),(135,'Coding Best Practices',5,27,'pending'),(136,'Machine Learning',1,28,'pending'),(137,'Supervised Learning',2,28,'pending'),(138,'Unsupervised Learning',3,28,'pending'),(139,'Model Evaluation',4,28,'pending'),(140,'Python Libraries (scikit-learn)',5,28,'pending'),(141,'Competitive Analysis',1,29,'pending'),(142,'Problem Solving',2,29,'pending'),(143,'Algorithm Optimization',3,29,'pending'),(144,'Collaboration',4,29,'pending'),(145,'Critical Thinking',5,29,'pending'),(146,'Natural Language Processing',1,30,'pending'),(147,'Computer Vision',2,30,'pending'),(148,'Big Data Technologies',3,30,'pending'),(149,'Advanced Algorithms',4,30,'pending'),(150,'Research and Development',5,30,'pending'),(151,'Technical Leadership',1,31,'pending'),(152,'Mentorship',2,31,'pending'),(153,'Innovation',3,31,'pending'),(154,'Technical Strategy',4,31,'pending'),(155,'Cross-Functional Collaboration',5,31,'pending'),(156,'Data Analysis',1,32,'pending'),(157,'Python',2,32,'pending'),(158,'R Programming',3,32,'pending'),(159,'SQL',4,32,'pending'),(160,'Statistical Analysis',5,32,'pending'),(161,'Machine Learning',1,33,'pending'),(162,'Supervised Learning',2,33,'pending'),(163,'Unsupervised Learning',3,33,'pending'),(164,'Model Evaluation',4,33,'pending'),(165,'Data Preprocessing',5,33,'pending'),(166,'Project Management',1,34,'pending'),(167,'Data Cleaning',2,34,'pending'),(168,'Data Visualization',3,34,'pending'),(169,'Python Libraries',4,34,'pending'),(170,'Problem Solving',5,34,'pending'),(171,'Deep Learning',1,35,'pending'),(172,'Natural Language Processing',2,35,'pending'),(173,'Big Data',3,35,'pending'),(174,'Data Engineering',4,35,'pending'),(175,'Time Series Analysis',5,35,'pending'),(176,'Data-Driven Decision Making',1,36,'pending'),(177,'Advanced Statistical Analysis',2,36,'pending'),(178,'Predictive Modeling',3,36,'pending'),(179,'Communication Skills',4,36,'pending'),(180,'Business Acumen',5,36,'pending'),(181,'JavaScript Basics',6,8,'pending'),(182,'react Basics',7,8,'pending'),(183,'react Basics',8,9,'pending'),(184,'nextjs basics',9,9,'pending'),(185,'css basics',10,9,'pending'),(186,'html basics',6,10,'pending'),(187,'Video Editing',1,37,'pending'),(188,'Storytelling',2,37,'pending'),(189,'Creativity',3,37,'pending'),(190,'Attention to Detail',4,37,'pending'),(191,'Time Management',5,37,'pending'),(192,'Research Skills',1,38,'pending'),(193,'Networking',2,38,'pending'),(194,'Self-Learning',3,38,'pending'),(195,'Critical Thinking',4,38,'pending'),(196,'Communication',5,38,'pending'),(197,'Workshop Participation',1,39,'pending'),(198,'Technical Understanding',2,39,'pending'),(199,'Collaboration',3,39,'pending'),(200,'Inquiry Skills',4,39,'pending'),(201,'Note-taking',5,39,'pending'),(202,'Online Learning',1,40,'pending'),(203,'Basic Engineering Concepts',2,40,'pending'),(204,'Time Management',3,40,'pending'),(205,'Discipline',4,40,'pending'),(206,'Technical Skills',5,40,'pending'),(207,'Networking',1,41,'pending'),(208,'Professional Communication',2,41,'pending'),(209,'Mentoring',3,41,'pending'),(210,'Relationship Building',4,41,'pending'),(211,'Industry Insight',5,41,'pending'),(212,'Practical Experience',1,42,'pending'),(213,'Technical Application',2,42,'pending'),(214,'Teamwork',3,42,'pending'),(215,'Problem Solving',4,42,'pending'),(216,'Project Management',5,42,'pending'),(217,'Leadership',1,43,'pending'),(218,'Decision Making',2,43,'pending'),(219,'Team Management',3,43,'pending'),(220,'Conflict Resolution',4,43,'pending'),(221,'Motivation',5,43,'pending'),(222,'Project Planning',1,44,'pending'),(223,'Risk Management',2,44,'pending'),(224,'Budgeting',3,44,'pending'),(225,'Scheduling',4,44,'pending'),(226,'Resource Allocation',5,44,'pending'),(227,'Strategic Planning',1,45,'pending'),(228,'Operations Management',2,45,'pending'),(229,'Team Leadership',3,45,'pending'),(230,'Performance Evaluation',4,45,'pending'),(231,'Client Relations',5,45,'pending'),(232,'Executive Decision Making',1,46,'pending'),(233,'Advanced Leadership',2,46,'pending'),(234,'Organizational Strategy',3,46,'pending'),(235,'Change Management',4,46,'pending'),(236,'Innovation Management',5,46,'pending'),(237,'Visionary Leadership',1,47,'pending'),(238,'Cross-functional Leadership',2,47,'pending'),(239,'Executive Communication',3,47,'pending'),(240,'Strategic Alignment',4,47,'pending'),(241,'Stakeholder Management',5,47,'pending'),(242,'Advanced Technical Skills',1,48,'pending'),(243,'Analytical Skills',2,48,'pending'),(244,'Engineering Software Proficiency',3,48,'pending'),(245,'Complex Problem Solving',4,48,'pending'),(246,'Research and Development',5,48,'pending'),(247,'Structural Analysis',1,49,'pending'),(248,'Design Principles',2,49,'pending'),(249,'Load Calculations',3,49,'pending'),(250,'Material Science',4,49,'pending'),(251,'Safety Standards',5,49,'pending'),(252,'Technical Leadership',1,50,'pending'),(253,'Project Design',2,50,'pending'),(254,'Innovation',3,50,'pending'),(255,'Technical Mentorship',4,50,'pending'),(256,'Quality Assurance',5,50,'pending'),(257,'Research Skills',1,51,'pending'),(258,'Innovation',2,51,'pending'),(259,'Prototype Development',3,51,'pending'),(260,'Data Analysis',4,51,'pending'),(261,'Technical Writing',5,51,'pending'),(262,'Technical Vision',1,52,'pending'),(263,'Strategic Innovation',2,52,'pending'),(264,'Technology Leadership',3,52,'pending'),(265,'Cross-disciplinary Collaboration',4,52,'pending'),(266,'Industry Influence',5,52,'pending'),(267,'Basic Mathematics',1,53,'pending'),(268,'Physics',2,53,'pending'),(269,'Problem Solving',3,53,'pending'),(270,'Technical Literacy',4,53,'pending'),(271,'Analytical Thinking',5,53,'pending'),(272,'Engineering Principles',1,54,'pending'),(273,'Structural Design',2,54,'pending'),(274,'Surveying',3,54,'pending'),(275,'Construction Management',4,54,'pending'),(276,'Environmental Engineering',5,54,'pending'),(277,'Practical Application',1,55,'pending'),(278,'Field Work',2,55,'pending'),(279,'Technical Documentation',3,55,'pending'),(280,'Project Assistance',4,55,'pending'),(281,'Communication Skills',5,55,'pending'),(282,'Technical Expertise',1,56,'pending'),(283,'Regulatory Knowledge',2,56,'pending'),(284,'Ethical Practice',3,56,'pending'),(285,'Problem Solving',4,56,'pending'),(286,'Professional Responsibility',5,56,'pending'),(287,'Project Management',1,57,'pending'),(288,'Design and Analysis',2,57,'pending'),(289,'Construction Oversight',3,57,'pending'),(290,'Client Interaction',4,57,'pending'),(291,'Sustainability Practices',5,57,'pending');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sort` tinyint NOT NULL,
  `path_id` bigint DEFAULT NULL,
  `status` enum('pending','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `branch_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  KEY `fk_steps_branch_id` (`branch_id`),
  CONSTRAINT `fk_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`),
  CONSTRAINT `fk_steps_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE CASCADE,
  CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps`
--

LOCK TABLES `steps` WRITE;
/*!40000 ALTER TABLE `steps` DISABLE KEYS */;
INSERT INTO `steps` VALUES (1,'Current Position: Graphic Designer','Leverage existing design skills and begin exploring frontend development.',1,1,'pending',1),(2,'Explore UI/UX Design','Deepen understanding of user interface and experience design.',1,1,'pending',2),(3,'Digital Marketing Specialist','Utilize design skills to create compelling digital marketing strategies.',2,1,'pending',2),(4,'Creative Director','Lead creative projects and guide design teams.',3,1,'pending',2),(5,'Design Team Lead','Manage a team of designers and oversee project delivery.',1,1,'pending',3),(6,'Product Manager','Bridge the gap between design and product development.',2,1,'pending',3),(7,'Chief Design Officer','Define the design vision and strategy for the company.',3,1,'pending',3),(8,'Frontend Developer','Transition to frontend development with a focus on design integration.',1,1,'pending',4),(9,'Full Stack Developer','Expand skills to include backend development.',2,1,'pending',4),(10,'Technical Lead','Lead a team of developers and oversee technical projects.',3,1,'pending',4),(11,'Learn HTML, CSS, and JavaScript','Develop foundational skills in frontend development.',2,1,'pending',1),(12,'Build a Portfolio of Web Projects','Create a portfolio showcasing frontend development projects.',3,1,'pending',1),(13,'Gain Experience with Frontend Frameworks','Learn and apply modern frontend frameworks like React or Vue.js.',4,1,'pending',1),(14,'Secure a Frontend Developer Position','Apply for and secure a position as a frontend developer.',5,1,'pending',1),(15,'Advance to Senior Frontend Developer','Enhance expertise and take on more complex projects.',6,1,'pending',1),(16,'Current WordPress Developer Role','Leverage current skills and projects to build a foundation for transition.',1,2,'pending',5),(17,'Explore Data Analysis Tools','Learn data analysis using tools like Excel and SQL.',1,2,'pending',6),(18,'Participate in Data Science Workshops','Attend workshops to gain practical insights into data science.',2,2,'pending',6),(19,'Build a Portfolio with Data Projects','Create a portfolio showcasing data analysis projects.',3,2,'pending',6),(20,'Join Data Science Communities','Engage with data science communities for learning and growth.',4,2,'pending',6),(21,'Contribute to Open Source Data Projects','Enhance skills by contributing to open source data projects.',5,2,'pending',6),(22,'Transition to Project Management','Shift focus to managing projects and teams.',1,2,'pending',7),(23,'Get Certified in Project Management','Obtain PMP or equivalent certifications.',2,2,'pending',7),(24,'Lead Data Science Projects','Manage data science projects within the organization.',3,2,'pending',7),(25,'Become a Data Science Manager','Oversee data science teams and initiatives.',4,2,'pending',7),(26,'Director of Data Science','Direct overall data science strategy and execution.',5,2,'pending',7),(27,'Learn Python for Data Science','Master Python programming with a focus on data science applications.',1,2,'pending',8),(28,'Master Machine Learning Algorithms','Deep dive into machine learning techniques and algorithms.',2,2,'pending',8),(29,'Engage in Data Science Competitions','Participate in competitions to solve real-world data problems.',3,2,'pending',8),(30,'Advanced Data Science Specialization','Specialize in fields like NLP, Computer Vision, or Big Data.',4,2,'pending',8),(31,'Become a Lead Data Scientist','Lead technical data science initiatives and mentor junior data scientists.',5,2,'pending',8),(32,'Learn Data Analysis Fundamentals','Develop a strong foundation in data analysis techniques and tools.',2,2,'pending',5),(33,'Acquire Machine Learning Skills','Gain proficiency in machine learning algorithms and their applications.',3,2,'pending',5),(34,'Work on Data Science Projects','Apply data science skills in real-world projects to gain practical experience.',4,2,'pending',5),(35,'Pursue Advanced Data Science Courses','Enroll in advanced courses to deepen understanding in specific areas of data science.',5,2,'pending',5),(36,'Achieve Data Scientist Role','Secure a position as a data scientist and contribute to data-driven decision making.',6,2,'pending',5),(37,'Current Role as Video Editor','Understand the current skills and responsibilities as a video editor.',1,10,'pending',9),(38,'Exploratory Research in Civil Engineering','Explore the field of civil engineering through online resources, webinars, and informational interviews.',1,10,'pending',10),(39,'Attend Civil Engineering Workshops','Participate in workshops and seminars to gain insight into the civil engineering field.',2,10,'pending',10),(40,'Online Courses in Civil Engineering','Enroll in online courses to learn basic concepts of civil engineering.',3,10,'pending',10),(41,'Networking with Civil Engineers','Connect with professionals in the civil engineering field for advice and mentorship.',4,10,'pending',10),(42,'Internship in Civil Engineering','Gain practical experience by interning with a civil engineering firm.',5,10,'pending',10),(43,'Develop Leadership Skills','Enhance leadership skills through workshops and training programs.',1,10,'pending',11),(44,'Project Management Certification','Obtain a certification in project management to handle engineering projects.',2,10,'pending',11),(45,'Management Role in Engineering Firm','Transition into a managerial role within an engineering firm.',3,10,'pending',11),(46,'Executive Management Training','Participate in executive training programs to prepare for high-level management roles.',4,10,'pending',11),(47,'Director of Engineering','Reach the role of Director of Engineering, overseeing multiple projects and teams.',5,10,'pending',11),(48,'Advanced Civil Engineering Courses','Pursue advanced courses to deepen technical knowledge in civil engineering.',1,10,'pending',12),(49,'Specialization in Structural Engineering','Specialize in structural engineering to focus on designing and analyzing structures.',2,10,'pending',12),(50,'Technical Lead in Engineering Projects','Take on a technical lead role in major engineering projects.',3,10,'pending',12),(51,'Research and Development Engineer','Engage in research and development to innovate in civil engineering.',4,10,'pending',12),(52,'Chief Technical Officer (CTO)','Achieve the position of CTO, overseeing all technical aspects of the engineering firm.',5,10,'pending',12),(53,'Gain Basic Engineering Knowledge','Start learning the fundamentals of engineering through online courses or community college classes.',2,10,'pending',9),(54,'Pursue a Degree in Civil Engineering','Enroll in a civil engineering degree program to gain a formal education in the field.',3,10,'pending',9),(55,'Internship or Entry-Level Position','Secure an internship or entry-level position in a civil engineering firm to gain practical experience.',4,10,'pending',9),(56,'Obtain Professional Engineer (PE) License','Pass the licensing exam to become a certified Professional Engineer.',5,10,'pending',9),(57,'Establish Career as Civil Engineer','Work as a civil engineer, designing and overseeing construction projects.',6,10,'pending',9);
/*!40000 ALTER TABLE `steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `valid_till` int DEFAULT NULL,
  `total_path` int DEFAULT NULL,
  `total_training_plan` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `points` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (1,'Pioneer Plan',99.00,365,15,3,'Ideal for ambitious career explorers aiming for top-level growth and insight.','Up to 15 maps + 3 training plans'),(2,'Navigator Plan',55.00,365,6,1,'Great for building multiple career paths with guided support.','Up to 6 maps + 1 training plan'),(3,'Explorer Plan',28.00,365,2,0,'Up to 2 maps with tailored AI path suggestions. Perfect for exploring your next big move.','Up to 2 maps with tailored AI path suggestions');
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_activities`
--

DROP TABLE IF EXISTS `training_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_activities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `expected_outcomes` text COLLATE utf8mb4_general_ci NOT NULL,
  `progress_measurement` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `duration` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `responsible` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `training_activities_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_activities`
--

LOCK TABLES `training_activities` WRITE;
/*!40000 ALTER TABLE `training_activities` DISABLE KEYS */;
INSERT INTO `training_activities` VALUES (1,1,'Adobe Creative Suite Masterclass','Proficiency in Adobe Photoshop, Illustrator, and InDesign','Project submissions and quizzes','6 weeks','2025-01-01 00:00:00','Self'),(2,1,'UI/UX Design Workshop','Understanding of user-centered design principles','Design projects and peer review','4 weeks','2025-03-01 00:00:00','Self'),(3,1,'HTML, CSS, and JavaScript Bootcamp','Ability to create static and interactive web pages','Code reviews and projects','12 weeks','2025-06-01 00:00:00','Self'),(4,1,'Git/GitHub Essentials','Effective version control using Git','Repository submissions','2 weeks','2025-08-01 00:00:00','Self'),(5,1,'React and Vue.js Development Course','Proficiency in building single-page applications','Capstone project','8 weeks','2026-01-01 00:00:00','Self'),(6,1,'Advanced JavaScript and Performance Optimization','Deep understanding of JavaScript and performance tuning','Performance audits and coding challenges','6 weeks','2026-07-01 00:00:00','Self'),(7,2,'PHP and WordPress Development Bootcamp','Proficiency in PHP and WordPress CMS','Completion of projects and quizzes','12 weeks','2025-01-15 00:00:00','Self'),(8,2,'Advanced JavaScript and Frontend Development','Mastery of JavaScript and frontend frameworks','Project-based assessments','8 weeks','2025-04-01 00:00:00','Self'),(9,2,'SEO and Digital Marketing Strategy','In-depth understanding of SEO and marketing strategies','Completion of a capstone project','6 weeks','2025-06-01 00:00:00','Self'),(10,2,'Project Management Fundamentals','Knowledge of project management principles','Exams and case studies analysis','4 weeks','2025-08-01 00:00:00','Self'),(11,2,'PMP Certification Preparation','Readiness for PMP certification exam','Mock exams and peer reviews','12 weeks','2025-11-01 00:00:00','Self'),(12,2,'Agile Methodology Training','Understanding Agile practices','Practical applications and simulations','6 weeks','2026-02-01 00:00:00','Self'),(13,2,'Leadership and Team Management Workshop','Enhanced leadership capabilities','Leadership role plays and feedback','3 days','2026-05-01 00:00:00','Self'),(14,2,'Data Science Project Management Training','Ability to manage data science projects','Project management simulations','8 weeks','2026-10-01 00:00:00','Self'),(15,2,'Advanced Data Science Techniques Course','Advanced data science skills','Capstone project and peer evaluation','10 weeks','2027-04-01 00:00:00','Self');
/*!40000 ALTER TABLE `training_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainning_plan`
--

DROP TABLE IF EXISTS `trainning_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainning_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_recommendation` text COLLATE utf8mb4_general_ci NOT NULL,
  `branch_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainning_plan`
--

LOCK TABLES `trainning_plan` WRITE;
/*!40000 ALTER TABLE `trainning_plan` DISABLE KEYS */;
INSERT INTO `trainning_plan` VALUES (1,'Continuously seek out new learning opportunities, such as attending web development conferences, participating in hackathons, and engaging with online developer communities. Regularly update your portfolio with new projects and ensure your skills are aligned with industry trends by subscribing to tech newsletters and following key influencers in the web development space.',1),(2,'Pursue continuous learning opportunities such as attending industry conferences, participating in webinars, and engaging in professional communities. Stay updated with the latest trends in technology and management by reading industry publications and following thought leaders on platforms like LinkedIn and Twitter. Consider contributing to open-source projects to gain practical experience and visibility in the tech community.',7);
/*!40000 ALTER TABLE `trainning_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_subscription`
--

DROP TABLE IF EXISTS `user_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_subscription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subscription_id` int NOT NULL,
  `user_id` int NOT NULL,
  `expiry_date` datetime NOT NULL,
  `payment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `current_path` int DEFAULT NULL,
  `current_training_plan` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscription_id` (`subscription_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_subscription_ibfk_1` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  CONSTRAINT `user_subscription_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_subscription`
--

LOCK TABLES `user_subscription` WRITE;
/*!40000 ALTER TABLE `user_subscription` DISABLE KEYS */;
INSERT INTO `user_subscription` VALUES (1,3,30,'2025-11-06 00:00:00','pi_3QI9axIILuhliL1z10hl3OKa','2024-11-06 13:48:30','2024-11-06 14:35:47',2,1),(3,3,40,'2025-11-07 00:00:00','pi_3QIRTzIILuhliL1z1ydYrSJ3','2024-11-07 09:04:08','2024-11-07 09:05:21',1,NULL),(4,3,40,'2025-11-07 00:00:00','pi_3QIRTzIILuhliL1z1ydYrSJ3','2024-11-07 09:04:23','2024-11-07 09:05:21',1,NULL);
/*!40000 ALTER TABLE `user_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_expiration` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'talha','syedtalha71x@gmail.com','ea045594007793a45a9d9a22d3dea1416603ad40bcb9fa0fae570e4cfdf5acd4',NULL,NULL,NULL,'2024-11-14 12:22:05'),(2,'hassan','hassanalirajput2004@gmail.com','f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd',NULL,NULL,NULL,'2024-11-14 12:26:14'),(3,'uzair','uzair@gmail.com','af1abd7e6077af6e448753f5c5a0b0381beb86b5aec98db8f6d37ee1c680c4ba',NULL,NULL,NULL,'2024-11-14 12:29:50'),(4,'checking','checking@gmail.com','8439c887e770b87564eeb7575ab935947b3d771ea812d8894068de3ba1855b6d',NULL,NULL,NULL,'2024-11-14 12:31:41'),(6,'daniyal','daniyal@gmail.com','29cf8b1808bfedf71270ecb7e096199a671e4dc27e4b6a0e5cebd50632a64fa0',NULL,NULL,NULL,'2024-11-14 14:01:32'),(7,'hadi','hadi@gmail.com','21531406955bb2b6b59816dc059ab1db65cc749776114b5370e26f58a13d82cd',NULL,NULL,NULL,'2024-11-14 14:33:13');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-15 16:09:19
