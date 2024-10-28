/*!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.18-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: career_map
-- ------------------------------------------------------
-- Server version	10.6.18-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_plan_summary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) NOT NULL,
  `responsiblity` enum('self','mentor','self/mentor') NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `action_plan_summary_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_plan_summary`
--

LOCK TABLES `action_plan_summary` WRITE;
/*!40000 ALTER TABLE `action_plan_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_plan_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `step_id` bigint(20) DEFAULT NULL,
  `color` varchar(255) NOT NULL,
  `path_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`step_id`),
  KEY `fk_branch_path_id` (`path_id`),
  CONSTRAINT `fk_branch_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_branch_step_id` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,NULL,'#f4b084',1),(2,1,'#a9d08e',1),(3,1,'#ccccff',1),(4,1,'#9bc2e6',1);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_goals_overview`
--

DROP TABLE IF EXISTS `career_goals_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `career_goals_overview` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `type` enum('s','l') NOT NULL,
  `completion_date` date NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `career_goals_overview_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_goals_overview`
--

LOCK TABLES `career_goals_overview` WRITE;
/*!40000 ALTER TABLE `career_goals_overview` DISABLE KEYS */;
/*!40000 ALTER TABLE `career_goals_overview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_path_progression_map`
--

DROP TABLE IF EXISTS `career_path_progression_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `career_path_progression_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) NOT NULL,
  `role` varchar(255) NOT NULL,
  `suggested_timing` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `career_path_progression_map_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_path_progression_map`
--

LOCK TABLES `career_path_progression_map` WRITE;
/*!40000 ALTER TABLE `career_path_progression_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `career_path_progression_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facebook_login`
--

DROP TABLE IF EXISTS `facebook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facebook_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `google_id` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `profile_picture` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
-- Table structure for table `instagram_login`
--

DROP TABLE IF EXISTS `instagram_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instagram_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instagram_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linkedin_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `linkedin_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model_subscription` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `amount` int(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_subscription`
--

LOCK TABLES `model_subscription` WRITE;
/*!40000 ALTER TABLE `model_subscription` DISABLE KEYS */;
INSERT INTO `model_subscription` VALUES (1,28,'0',3,10,'2024-10-28 12:07:53','2024-10-28 12:07:53'),(2,28,'0',3,10,'2024-10-28 12:11:29','2024-10-28 12:11:29'),(3,28,'0',5,10,'2024-10-28 12:11:47','2024-10-28 12:11:47'),(4,28,'0',5,10,'2024-10-28 12:17:55','2024-10-28 12:17:55'),(5,28,'pi_3QErrfIILuhliL1z1JtyoKQj',5,10,'2024-10-28 12:27:42','2024-10-28 12:27:42'),(6,28,'pi_3QEs3gIILuhliL1z0LkqmO8s',3,10,'2024-10-28 12:28:52','2024-10-28 12:28:52');
/*!40000 ALTER TABLE `model_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES (1,'Transaction'),(6,'Pricing'),(7,'Subscription');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `next_steps_recommendations`
--

DROP TABLE IF EXISTS `next_steps_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `next_steps_recommendations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) NOT NULL,
  `recommendations` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `next_steps_recommendations_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `next_steps_recommendations`
--

LOCK TABLES `next_steps_recommendations` WRITE;
/*!40000 ALTER TABLE `next_steps_recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `next_steps_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(350) NOT NULL,
  `description` varchar(350) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `read` tinyint(4) NOT NULL DEFAULT 0,
  `seen` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (3,30,'System Maintenance Scheduled','Our system will be undergoing maintenance on October 1st at 10:00 PM.','https://www.google.com/',1,1),(4,30,'Database Admin Scheduled','Our database admin system will be undergoing maintenance on September 1st at 8:00 PM.','https://www.google.com/',1,1),(5,30,'I am an infrastructure Specialist','This path has been analyse',NULL,1,1),(6,30,'react js developer','This path has been analyse',NULL,1,1),(7,30,'react js developer','This path has been analyse',NULL,0,0),(8,36,'Law grad to solicitor','This path has been analyse',NULL,1,1),(9,36,'Pipefitter to superintendant ','This path has been analyse',NULL,1,1),(10,36,'Law ','This path has been analyse',NULL,1,1),(11,36,'law 2','This path has been analyse',NULL,1,1),(12,28,'javascript','This path has been analyse',NULL,1,1),(13,30,'Law grad to solicitor','This path has been analyse',NULL,0,0),(14,30,'Pipefitter to superintendant ','This path has been analyse',NULL,0,0),(15,30,'Law ','This path has been analyse',NULL,0,0),(16,30,'law 2','This path has been analyse',NULL,0,0),(17,30,'javascript','This path has been analyse',NULL,0,0),(18,36,'IT Specialist Career','This path has been analyse',NULL,0,1),(19,37,'javascript','This path has been analyse',NULL,1,1),(20,37,'python developer','This path has been analyse',NULL,1,1),(21,37,'data entry','This path has been analyse',NULL,1,1),(22,37,'data entry operator','This path has been analyse',NULL,1,1),(23,28,'frontend developer','This path has been analyse',NULL,1,1),(24,37,'ml engineer','This path has been analyse',NULL,1,1),(25,37,' Machine learning developer','This path has been analyse',NULL,1,1),(26,37,'react js developer','This path has been analyse',NULL,1,1),(27,37,'react js developer','This path has been analyse',NULL,1,1),(28,37,'ai engineer','This path has been analyse',NULL,1,1),(29,37,'data entry operator','This path has been analyse',NULL,1,1),(30,37,' python developer','This path has been analyse',NULL,1,1),(31,37,' python developer','This path has been analyse',NULL,1,1),(32,37,' python developer','This path has been analyse',NULL,1,1),(33,37,'python developer','This path has been analyse',NULL,1,1),(34,37,' python developer','This path has been analyse',NULL,1,1),(35,37,'mechanic ','This path has been analyse',NULL,1,1),(36,37,'blockchain developer','This path has been analyse',NULL,1,1),(37,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(38,37,' python developer','This path has been analyse',NULL,1,1),(39,37,' python developer','This path has been analyse',NULL,1,1),(40,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(41,37,'mechanic ','This path has been analyse',NULL,1,1),(42,37,'react js developer','This path has been analyse',NULL,1,1),(43,37,'data entry operator','This path has been analyse',NULL,1,1),(44,37,'ai engineer','This path has been analyse',NULL,1,1),(45,37,'data entry operator','This path has been analyse',NULL,1,1),(46,37,'singer','This path has been analyse',NULL,0,1),(47,37,'python developer banna hy mujhe','This path has been analyse',NULL,0,1),(48,37,'python developer banna hy mujhe','This path has been analyse',NULL,0,1),(49,37,'javascript deveoper','This path has been analyse',NULL,0,1),(50,37,'ml engineer','This path has been analyse',NULL,0,1),(51,37,'javascript deveoper','This path has been analyse',NULL,0,1),(52,28,'python developer','This path has been analyse',NULL,1,1),(53,28,'python developer','This path has been analyse',NULL,1,1),(54,28,'python developer','This path has been analyse',NULL,1,1),(55,28,'singer','This path has been analyse',NULL,0,0),(56,28,'ai engineer','This path has been analyse',NULL,0,0),(57,28,'frontend developer','This path has been analyse',NULL,0,0),(58,28,'graphic designer','This path has been analyse',NULL,0,0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outlook_login`
--

DROP TABLE IF EXISTS `outlook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outlook_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outlook_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `path` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `prompt` longtext DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `status` enum('pending','analysed','analysing') DEFAULT 'pending',
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(250) DEFAULT NULL,
  `gpt_id` varchar(350) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `path_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `path`
--

LOCK TABLES `path` WRITE;
/*!40000 ALTER TABLE `path` DISABLE KEYS */;
INSERT INTO `path` VALUES (1,'I am a graphic designer & wanna be a Frontend Developer.',NULL,'analysed',28,'graphic designer',NULL);
/*!40000 ALTER TABLE `path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_modules`
--

DROP TABLE IF EXISTS `permission_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_modules` (
  `permission_id` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
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
INSERT INTO `permission_modules` VALUES (13,6),(14,7),(15,7),(13,6),(14,7),(15,7);
/*!40000 ALTER TABLE `permission_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_to_role`
--

DROP TABLE IF EXISTS `permission_to_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_to_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `permission_to_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permission_to_role_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_to_role`
--

LOCK TABLES `permission_to_role` WRITE;
/*!40000 ALTER TABLE `permission_to_role` DISABLE KEYS */;
INSERT INTO `permission_to_role` VALUES (6,2,4,'2024-09-19 08:09:57','2024-09-19 08:09:57'),(7,2,5,'2024-09-19 08:09:57','2024-09-19 08:09:57');
/*!40000 ALTER TABLE `permission_to_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `slug` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (4,'index','2024-09-19 07:50:57','2024-09-19 08:00:13','transaction-index'),(5,'create','2024-09-19 07:50:57','2024-09-19 07:50:57','transaction-create'),(6,'update','2024-09-19 07:50:57','2024-09-19 07:50:57','transaction-update'),(13,'index','2024-09-19 11:27:53','2024-09-19 11:27:53','pricing-index'),(14,'createIndex','2024-09-19 11:29:12','2024-09-19 11:29:12','subscription-create-index'),(15,'viewIndex','2024-09-19 11:29:12','2024-09-19 11:29:12','subscription-view-index');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_to_users`
--

DROP TABLE IF EXISTS `role_to_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_to_users` (
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `role_id` (`role_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `role_to_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `role_to_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_to_users`
--

LOCK TABLES `role_to_users` WRITE;
/*!40000 ALTER TABLE `role_to_users` DISABLE KEYS */;
INSERT INTO `role_to_users` VALUES (1,30),(2,35),(1,30),(2,35);
/*!40000 ALTER TABLE `role_to_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','2024-09-19 07:29:05','2024-09-19 07:39:58'),(2,'sub user','2024-09-19 08:04:12','2024-09-19 08:04:12');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_gap_analysis`
--

DROP TABLE IF EXISTS `skill_gap_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_gap_analysis` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `priority` enum('High','Medium','Low') DEFAULT NULL,
  `status` enum('pending','completed') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `skill_gap_analysis_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis`
--

LOCK TABLES `skill_gap_analysis` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis` DISABLE KEYS */;
/*!40000 ALTER TABLE `skill_gap_analysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_gap_analysis_resources`
--

DROP TABLE IF EXISTS `skill_gap_analysis_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_gap_analysis_resources` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `skill_gap_analysis_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis_resources`
--

LOCK TABLES `skill_gap_analysis_resources` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis_resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `skill_gap_analysis_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skills` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `sort` tinyint(1) NOT NULL,
  `step_id` bigint(20) DEFAULT NULL,
  `status` enum('pending','completed') DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (1,'Adobe Creative Suite',1,1,'pending'),(2,'UI/UX Design',2,1,'pending'),(3,'Typography',3,1,'pending'),(4,'Color Theory',4,1,'pending'),(5,'Responsive Design',5,1,'pending'),(6,'User Research',1,2,'pending'),(7,'Wireframing',2,2,'pending'),(8,'Prototyping',3,2,'pending'),(9,'Usability Testing',4,2,'pending'),(10,'Information Architecture',5,2,'pending'),(11,'SEO',1,3,'pending'),(12,'Content Creation',2,3,'pending'),(13,'Social Media Management',3,3,'pending'),(14,'Analytics',4,3,'pending'),(15,'Campaign Management',5,3,'pending'),(16,'Leadership',1,4,'pending'),(17,'Project Management',2,4,'pending'),(18,'Creative Strategy',3,4,'pending'),(19,'Team Management',4,4,'pending'),(20,'Brand Development',5,4,'pending'),(21,'Team Leadership',1,5,'pending'),(22,'Conflict Resolution',2,5,'pending'),(23,'Performance Management',3,5,'pending'),(24,'Budgeting',4,5,'pending'),(25,'Resource Allocation',5,5,'pending'),(26,'Product Roadmapping',1,6,'pending'),(27,'Stakeholder Management',2,6,'pending'),(28,'Market Analysis',3,6,'pending'),(29,'Agile Methodologies',4,6,'pending'),(30,'Prioritization',5,6,'pending'),(31,'Visionary Leadership',1,7,'pending'),(32,'Strategic Planning',2,7,'pending'),(33,'Design Thinking',3,7,'pending'),(34,'Innovation',4,7,'pending'),(35,'Mentorship',5,7,'pending'),(36,'HTML/CSS',1,8,'pending'),(37,'JavaScript',2,8,'pending'),(38,'Version Control (Git)',3,8,'pending'),(39,'Responsive Design',4,8,'pending'),(40,'Cross-Browser Compatibility',5,8,'pending'),(41,'Node.js',1,9,'pending'),(42,'Database Management',2,9,'pending'),(43,'APIs',3,9,'pending'),(44,'Server-Side Logic',4,9,'pending'),(45,'Cloud Services',5,9,'pending'),(46,'Technical Leadership',1,10,'pending'),(47,'Code Review',2,10,'pending'),(48,'Architecture Design',3,10,'pending'),(49,'Continuous Integration',4,10,'pending'),(50,'Quality Assurance',5,10,'pending'),(51,'HTML',1,11,'pending'),(52,'CSS',2,11,'pending'),(53,'JavaScript',3,11,'pending'),(54,'Responsive Design',4,11,'pending'),(55,'DOM Manipulation',5,11,'pending'),(56,'Project Management',1,12,'pending'),(57,'Git/GitHub',2,12,'pending'),(58,'Web Design',3,12,'pending'),(59,'Debugging',4,12,'pending'),(60,'Code Optimization',5,12,'pending'),(61,'React',1,13,'pending'),(62,'Vue.js',2,13,'pending'),(63,'State Management',3,13,'pending'),(64,'Component-Based Architecture',4,13,'pending'),(65,'Single Page Applications',5,13,'pending'),(66,'Interviewing',1,14,'pending'),(67,'Technical Communication',2,14,'pending'),(68,'Problem Solving',3,14,'pending'),(69,'Team Collaboration',4,14,'pending'),(70,'Adaptability',5,14,'pending'),(71,'Advanced JavaScript',1,15,'pending'),(72,'Performance Optimization',2,15,'pending'),(73,'Security Best Practices',3,15,'pending'),(74,'Testing and Debugging',4,15,'pending'),(75,'Mentorship',5,15,'pending');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `steps` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `sort` tinyint(4) NOT NULL,
  `path_id` bigint(20) DEFAULT NULL,
  `status` enum('pending','completed') DEFAULT 'pending',
  `branch_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  KEY `fk_steps_branch_id` (`branch_id`),
  CONSTRAINT `fk_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`),
  CONSTRAINT `fk_steps_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE CASCADE,
  CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps`
--

LOCK TABLES `steps` WRITE;
/*!40000 ALTER TABLE `steps` DISABLE KEYS */;
INSERT INTO `steps` VALUES (1,'Current Position: Graphic Designer','Leverage existing design skills and begin exploring frontend development.',1,1,'pending',1),(2,'Explore UI/UX Design','Deepen understanding of user interface and experience design.',1,1,'pending',2),(3,'Digital Marketing Specialist','Utilize design skills to create compelling digital marketing strategies.',2,1,'pending',2),(4,'Creative Director','Lead creative projects and guide design teams.',3,1,'pending',2),(5,'Design Team Lead','Manage a team of designers and oversee project delivery.',1,1,'pending',3),(6,'Product Manager','Bridge the gap between design and product development.',2,1,'pending',3),(7,'Chief Design Officer','Define the design vision and strategy for the company.',3,1,'pending',3),(8,'Frontend Developer','Transition to frontend development with a focus on design integration.',1,1,'pending',4),(9,'Full Stack Developer','Expand skills to include backend development.',2,1,'pending',4),(10,'Technical Lead','Lead a team of developers and oversee technical projects.',3,1,'pending',4),(11,'Learn HTML, CSS, and JavaScript','Develop foundational skills in frontend development.',2,1,'pending',1),(12,'Build a Portfolio of Web Projects','Create a portfolio showcasing frontend development projects.',3,1,'pending',1),(13,'Gain Experience with Frontend Frameworks','Learn and apply modern frontend frameworks like React or Vue.js.',4,1,'pending',1),(14,'Secure a Frontend Developer Position','Apply for and secure a position as a frontend developer.',5,1,'pending',1),(15,'Advance to Senior Frontend Developer','Enhance expertise and take on more complex projects.',6,1,'pending',1);
/*!40000 ALTER TABLE `steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `valid_till` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (8,'Gold Plan',20.99,10),(9,'Platnium Plan',20.99,10),(10,'Bronze Plan',13.22,20);
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_activities`
--

DROP TABLE IF EXISTS `training_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `training_activities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `expected_outcomes` text NOT NULL,
  `progress_measurement` varchar(255) NOT NULL,
  `duration` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `responsible` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `training_activities_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `trainning_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_activities`
--

LOCK TABLES `training_activities` WRITE;
/*!40000 ALTER TABLE `training_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `training_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainning_plan`
--

DROP TABLE IF EXISTS `trainning_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainning_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_recommendation` text NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainning_plan`
--

LOCK TABLES `trainning_plan` WRITE;
/*!40000 ALTER TABLE `trainning_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `trainning_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_subscription`
--

DROP TABLE IF EXISTS `user_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expiry_date` datetime NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `subscription_id` (`subscription_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_subscription_ibfk_1` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  CONSTRAINT `user_subscription_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_subscription`
--

LOCK TABLES `user_subscription` WRITE;
/*!40000 ALTER TABLE `user_subscription` DISABLE KEYS */;
INSERT INTO `user_subscription` VALUES (9,8,30,'2024-08-30 00:00:00','pi_3PprfnIILuhliL1z00EGL4bm','2024-08-20 13:00:35','2024-08-20 13:00:35'),(11,10,29,'2024-09-10 00:00:00','pi_3Pq8dfIILuhliL1z1pFtpte9','2024-08-21 07:07:31','2024-08-21 07:07:31'),(13,10,29,'2024-09-10 00:00:00','pi_3PqEplIILuhliL1z0hxEU6sZ','2024-08-21 13:44:24','2024-08-21 13:44:24'),(14,10,29,'2024-09-10 00:00:00','pi_3PqEplIILuhliL1z0hxEU6sZ','2024-08-21 13:44:24','2024-08-21 13:44:24');
/*!40000 ALTER TABLE `user_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `otp_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'hussain21x','hussain12@gmail.com','8b117546c9cdd79b2f88159fd94e1195623f7f8b53b54a2bb3b7675ecd834a93',NULL,NULL,NULL),(2,'faris21x','faris12@gmail.com','8a91dbf39a7d58400d17676648461e8d9895a7a48ea02e6a641de439b402a656',NULL,NULL,NULL),(3,'talha17x','talha@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL),(4,'aiman12','aiman@gmail.com','1a62b2b12c469335995cced03433260373e0b975344059e1a1fbdc66e6aca914',NULL,NULL,NULL),(5,'haris12','haris12@gmail.com','cffd26c9ddbb65b048a0f714b704a5ed9a5ad7a66130b7a43963899528a97928',NULL,NULL,NULL),(6,'test1','test12@gmail.com','c42bd77fb632be76f683bc427943fb3f848170dc33c14b7d5dc1b771db078c84',NULL,NULL,NULL),(7,'one71x','one@gmail.com','4d312d42968237ea5e754e39580b0f7fbb906dbf8608847310df370ed45828dd',NULL,NULL,NULL),(8,'syed71x','syed@gmail.com','73f72fcd6f1108782be74a62f817922edfc021a5d6a68513ec8aa9af4fad3b45',NULL,NULL,NULL),(9,'mustafa69x','mustafa@gmail.com','8e352b24effd2b624844f3d5d0fb2a0960903bf8aee759c2226a98993329c702',NULL,NULL,NULL),(10,'shayan71x','shayan@gmail.com','506c78e44f2184e46a6467bb17cf6b5937821be63a6170a8b8a07331b1660e13',NULL,NULL,NULL),(11,'Two69x$','two@gmail.com','2e1d7dfa4ca32532c7d453db04da86afcf38f0cc4008e1f577854b32c51115a7','https://images.pexels.com/photos/2310713/pexels-photo-2310713.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',NULL,NULL),(13,'hunain69x','hunain@gmail.com','840dc021cf333401c6b8f854939c7065058c6468843a37610071ded8569902b6',NULL,NULL,NULL),(14,'three12','three12@gmail.com','b7af263584bc6e827fa262dd8eb99d8bb3b1b43d045d3643acc8d975e49d30a3',NULL,NULL,NULL),(15,'hassan','hassan123@gmail.com','5c80b9535206b56dc8d78543de507d3e3fe08636dc6a9d12deb1dac0e7e5bb87',NULL,'gQXel3','2024-08-19 14:40:39'),(19,'poka123','poka123@gmail.com','22306f9ad37b7be1e823c6a1ccbc2cb944e6c9962f8f9da5103dc3f70b622c77',NULL,NULL,NULL),(21,'anas71x','anas@gmail.com','5410327224be6b772e71705ef1c6e8f87d8d253754c56f1521f642cef16b3898',NULL,NULL,NULL),(22,'areeba12','areeba@gmail.com','8d080c78cd9eb424ad93536b6b4faf3e521661a1bab4068cdc5e902ac623651f',NULL,NULL,NULL),(23,'tassaract','tassaract@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL),(24,'tassaract1','tassaract1@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL),(27,'ahmed','ahmed@gmail.com','77a2e452cc950bddfa44fe8c61db107305166800b489adf97f31fad9e2ba72f6',NULL,NULL,NULL),(28,'hassan123','hassanalirajput2004@gmail.com','f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd',NULL,'puVzLQ','2024-10-08 13:13:09'),(29,'talha_83x','pc16777.syedtalhahussain@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL),(30,'syed899x','syedtalha71x@gmail.com','ea045594007793a45a9d9a22d3dea1416603ad40bcb9fa0fae570e4cfdf5acd4',NULL,NULL,NULL),(31,'amna','amna@gmail.com','a24738c27f7a51a6079b03d7149a5c12e4608a356c4d17e316b71941d819c346',NULL,NULL,NULL),(32,'noor','noor@gmail.com','6913c81ff94fc68e7b04d1de8b226fcd528fcb3c939cacce6bb5859c7a6157b4',NULL,NULL,NULL),(33,'faizan_18x','faizan@gmail.com','49f606bc2b2239194f22b0f301ff6aec2860e636f5eed176e308f6fd2c55fcde',NULL,NULL,NULL),(34,'khan','khan@gmail.com','cad3fe7aae4d46b047d0164e64aed2b1a98b74bf45d0fc23be076005504bace6',NULL,NULL,NULL),(35,'hadi','hadi@gmail.com','b87622c28e68762bc12fd2e4fddc2daae09a09679d54b4e8d4de7814ec8207c4',NULL,NULL,NULL),(36,'Alroylewis','Alroylewis@hotmail.co.uk','f95a6ba11d2cdcfcf9a073ea603492139bd05f71709af61b73dc4594f3f4866d',NULL,NULL,NULL),(37,'hassan321','unitedfurniture75@gmail.com','f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd',NULL,NULL,NULL),(38,'zaidworks515','zaid_works515@outlook.com','d4598a2752541ac5de8ebc3b1923b57f9052ede3f40ae572957b5fe9b984cb83',NULL,NULL,NULL);
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

-- Dump completed on 2024-10-28 12:39:40
