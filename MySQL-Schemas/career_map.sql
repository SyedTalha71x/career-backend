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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_plan_summary`
--

LOCK TABLES `action_plan_summary` WRITE;
/*!40000 ALTER TABLE `action_plan_summary` DISABLE KEYS */;
INSERT INTO `action_plan_summary` VALUES (26,'Complete HTML/CSS training','self',6),(27,'Enroll in PHP course','self',6),(28,'Participate in JavaScript workshop','self',6),(29,'Develop a WordPress plugin','self',6),(30,'Optimize a website for SEO','self',6),(31,'Seek mentorship for leadership skills','mentor',6),(39,'Enroll in Adobe courses on Udemy and LinkedIn Learning','self',9),(40,'Complete a typography project using resources from Skillshare','self',9),(41,'Seek mentor feedback on design projects','mentor',9),(42,'Schedule regular check-ins to evaluate progress','self',9);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (9,NULL,'#f4b084',1),(10,37,'#a9d08e',1),(11,37,'#ccccff',1),(12,37,'#9bc2e6',1),(13,NULL,'#f4b084',2),(14,58,'#a9d08e',2),(15,58,'#ccccff',2),(16,58,'#9bc2e6',2),(17,NULL,'#f4b084',3),(18,79,'#a9d08e',3),(19,79,'#ccccff',3),(20,79,'#9bc2e6',3);
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_goals_overview`
--

LOCK TABLES `career_goals_overview` WRITE;
/*!40000 ALTER TABLE `career_goals_overview` DISABLE KEYS */;
INSERT INTO `career_goals_overview` VALUES (30,6,'Become a proficient WordPress Developer','s','2025-04-30'),(31,6,'Transition to a Team Lead role','s','2025-10-31'),(32,6,'Advance to Project Manager','l','2026-10-31'),(33,6,'Reach Product Manager level','l','2027-10-31'),(34,6,'Attain Operations Manager role','l','2028-10-31'),(35,6,'Achieve the position of Chief Technology Officer (CTO)','l','2029-10-31'),(47,9,'Become a proficient Graphic Designer','s','2025-04-30'),(48,9,'Advance to UI/UX Design Exploration','s','2025-10-30'),(49,9,'Develop expertise in Advanced UI/UX Design','l','2026-10-30'),(50,9,'Progress to UI/UX Design Specialist','l','2027-05-30'),(51,9,'Become a UI/UX Consultant','l','2028-05-30'),(52,9,'Achieve the Head of UI/UX Design position','l','2029-12-30');
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_path_progression_map`
--

LOCK TABLES `career_path_progression_map` WRITE;
/*!40000 ALTER TABLE `career_path_progression_map` DISABLE KEYS */;
INSERT INTO `career_path_progression_map` VALUES (27,6,'WordPress Developer',NULL),(28,6,'Team Lead','6 months'),(29,6,'Project Manager','12 months'),(30,6,'Product Manager','12 months'),(31,6,'Operations Manager','12 months'),(32,6,'Chief Technology Officer (CTO)','12 months'),(44,9,'Graphic Designer',NULL),(45,9,'UI/UX Designer','6 months'),(46,9,'Advanced UI/UX Designer','12 months'),(47,9,'UI/UX Design Specialist','12 months'),(48,9,'UI/UX Consultant','12 months'),(49,9,'Head of UI/UX Design','18 months');
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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_subscription`
--

LOCK TABLES `model_subscription` WRITE;
/*!40000 ALTER TABLE `model_subscription` DISABLE KEYS */;
INSERT INTO `model_subscription` VALUES (1,28,'0',3,10,'2024-10-28 12:07:53','2024-10-28 12:07:53'),(2,28,'0',3,10,'2024-10-28 12:11:29','2024-10-28 12:11:29'),(3,28,'0',5,10,'2024-10-28 12:11:47','2024-10-28 12:11:47'),(4,28,'0',5,10,'2024-10-28 12:17:55','2024-10-28 12:17:55'),(5,28,'pi_3QErrfIILuhliL1z1JtyoKQj',5,10,'2024-10-28 12:27:42','2024-10-28 12:27:42'),(6,28,'pi_3QEs3gIILuhliL1z0LkqmO8s',3,10,'2024-10-28 12:28:52','2024-10-28 12:28:52'),(7,28,'pi_3QEsHvIILuhliL1z1ATAbNvM',1,10,'2024-10-28 12:43:43','2024-10-28 12:43:43'),(8,28,'pi_3QEsJ7IILuhliL1z1RfI8Ghi',7,10,'2024-10-28 12:44:45','2024-10-28 12:44:45'),(9,28,'pi_3QFA8aIILuhliL1z1LovjTXZ',7,10,'2024-10-29 07:47:39','2024-10-29 07:47:39'),(10,28,'pi_3QFAIfIILuhliL1z1zTRYNj5',7,10,'2024-10-29 08:02:08','2024-10-29 08:02:08'),(11,28,'pi_3QFAIfIILuhliL1z1zTRYNj5',7,10,'2024-10-29 08:02:08','2024-10-29 08:02:08'),(12,28,'pi_3QEsJ7IILuhliL1z1RfI8Ghi',7,10,'2024-10-29 11:07:53','2024-10-29 11:07:53'),(13,28,'pi_3QFDJlIILuhliL1z02QBhcqz',7,10,'2024-10-29 11:11:59','2024-10-29 11:11:59'),(14,28,'pi_3QFDJlIILuhliL1z02QBhcqz',7,10,'2024-10-29 11:41:27','2024-10-29 11:41:27'),(15,28,'pi_3QFDJlIILuhliL1z02QBhcqz',7,10,'2024-10-29 11:41:38','2024-10-29 11:41:38'),(16,28,'pi_3QFZ52IILuhliL1z17qXjppS',13,10,'2024-10-30 10:34:43','2024-10-30 10:34:43'),(17,28,'pi_3QFZ52IILuhliL1z17qXjppS',13,10,'2024-10-30 10:35:14','2024-10-30 10:35:14'),(18,28,'pi_3QFZ52IILuhliL1z17qXjppS',13,10,'2024-10-30 10:35:48','2024-10-30 10:35:48'),(19,28,'pi_3QFZ52IILuhliL1z17qXjppS',13,10,'2024-10-30 10:35:54','2024-10-30 10:35:54'),(20,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:52:35','2024-10-30 10:52:35'),(21,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:54:15','2024-10-30 10:54:15'),(22,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:54:45','2024-10-30 10:54:45'),(23,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:54:45','2024-10-30 10:54:45'),(24,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:54:52','2024-10-30 10:54:52'),(25,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:55:01','2024-10-30 10:55:01'),(26,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:56:29','2024-10-30 10:56:29'),(27,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:57:39','2024-10-30 10:57:39'),(28,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:57:51','2024-10-30 10:57:51'),(29,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:57:51','2024-10-30 10:57:51'),(30,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:58:00','2024-10-30 10:58:00'),(31,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 10:59:42','2024-10-30 10:59:42'),(32,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:00:02','2024-10-30 11:00:02'),(33,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:00:03','2024-10-30 11:00:03'),(34,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:00:26','2024-10-30 11:00:26'),(35,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:01:14','2024-10-30 11:01:14'),(36,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:01:36','2024-10-30 11:01:36'),(37,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:01:47','2024-10-30 11:01:47'),(38,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:02:56','2024-10-30 11:02:56'),(39,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:02:56','2024-10-30 11:02:56'),(40,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:03:14','2024-10-30 11:03:14'),(41,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:03:28','2024-10-30 11:03:28'),(42,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:03:34','2024-10-30 11:03:34'),(43,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:03:46','2024-10-30 11:03:46'),(44,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:05:54','2024-10-30 11:05:54'),(45,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:06:11','2024-10-30 11:06:11'),(46,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:06:20','2024-10-30 11:06:20'),(47,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:06:31','2024-10-30 11:06:31'),(48,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:07:48','2024-10-30 11:07:48'),(49,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:08:43','2024-10-30 11:08:43'),(50,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:08:59','2024-10-30 11:08:59'),(51,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:09:03','2024-10-30 11:09:03'),(52,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:10:37','2024-10-30 11:10:37'),(53,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:10:37','2024-10-30 11:10:37'),(54,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:12:06','2024-10-30 11:12:06'),(55,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:13:19','2024-10-30 11:13:19'),(56,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:19:08','2024-10-30 11:19:08'),(57,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:20:08','2024-10-30 11:20:08'),(58,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:20:08','2024-10-30 11:20:08'),(59,28,'pi_3QFZVjIILuhliL1z0tIFHZXy',15,10,'2024-10-30 11:20:26','2024-10-30 11:20:26'),(60,28,'pi_3QFaCLIILuhliL1z0xnXoO44',15,10,'2024-10-30 11:36:34','2024-10-30 11:36:34'),(61,28,'pi_3QFaCLIILuhliL1z0xnXoO44',15,10,'2024-10-30 11:37:10','2024-10-30 11:37:10'),(62,28,'pi_3QFaCLIILuhliL1z0xnXoO44',15,10,'2024-10-30 11:46:59','2024-10-30 11:46:59'),(63,28,'pi_3QFaCLIILuhliL1z0xnXoO44',15,10,'2024-10-30 11:47:37','2024-10-30 11:47:37'),(64,28,'pi_3QFaObIILuhliL1z0KvIhZly',10,10,'2024-10-30 11:49:15','2024-10-30 11:49:15'),(65,28,'pi_3QFb6SIILuhliL1z1pCEJ1JS',10,10,'2024-10-30 12:34:34','2024-10-30 12:34:34'),(66,28,'pi_3QFb6SIILuhliL1z1pCEJ1JS',10,10,'2024-10-30 12:48:41','2024-10-30 12:48:41'),(67,28,'pi_3QFbU9IILuhliL1z1v8hy2KC',15,10,'2024-10-30 12:59:05','2024-10-30 12:59:05'),(68,28,'pi_3QFb6SIILuhliL1z1pCEJ1JS',10,10,'2024-10-30 13:02:06','2024-10-30 13:02:06'),(69,28,'pi_3QFbZ6IILuhliL1z1YBId5aS',19,10,'2024-10-30 13:04:12','2024-10-30 13:04:12'),(70,28,'pi_3QFbZ6IILuhliL1z1YBId5aS',19,10,'2024-10-30 13:04:51','2024-10-30 13:04:51'),(71,28,'pi_3QFb6SIILuhliL1z1pCEJ1JS',10,10,'2024-10-30 13:27:59','2024-10-30 13:27:59'),(72,28,'pi_3QFb6SIILuhliL1z1pCEJ1JS',10,10,'2024-10-30 13:27:59','2024-10-30 13:27:59'),(73,28,'pi_3QFbZ6IILuhliL1z1YBId5aS',19,10,'2024-10-30 13:27:59','2024-10-30 13:27:59'),(74,28,'pi_3QFc2XIILuhliL1z1m6tqFAJ',10,10,'2024-10-30 13:34:39','2024-10-30 13:34:39'),(75,28,'pi_3QFc6iIILuhliL1z12xflJQX',10,10,'2024-10-30 13:39:02','2024-10-30 13:39:02'),(76,28,'pi_3QFcFqIILuhliL1z1oysGhHo',10,10,'2024-10-30 13:48:26','2024-10-30 13:48:26');
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `next_steps_recommendations`
--

LOCK TABLES `next_steps_recommendations` WRITE;
/*!40000 ALTER TABLE `next_steps_recommendations` DISABLE KEYS */;
INSERT INTO `next_steps_recommendations` VALUES (16,6,'Focus on mastering technical skills as a WordPress Developer'),(17,6,'Gradually transition into leadership roles'),(18,6,'Pursue certifications in project management and agile methodologies'),(19,6,'Build strategic thinking and stakeholder management skills'),(26,9,'Focus on building a strong design portfolio to showcase skills.'),(27,9,'Engage in networking with other design professionals.'),(28,9,'Participate in design competitions to gain exposure.');
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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (3,30,'System Maintenance Scheduled','Our system will be undergoing maintenance on October 1st at 10:00 PM.','https://www.google.com/',1,1),(4,30,'Database Admin Scheduled','Our database admin system will be undergoing maintenance on September 1st at 8:00 PM.','https://www.google.com/',1,1),(5,30,'I am an infrastructure Specialist','This path has been analyse',NULL,1,1),(6,30,'react js developer','This path has been analyse',NULL,1,1),(7,30,'react js developer','This path has been analyse',NULL,0,0),(8,36,'Law grad to solicitor','This path has been analyse',NULL,1,1),(9,36,'Pipefitter to superintendant ','This path has been analyse',NULL,1,1),(10,36,'Law ','This path has been analyse',NULL,1,1),(11,36,'law 2','This path has been analyse',NULL,1,1),(12,28,'javascript','This path has been analyse',NULL,1,1),(13,30,'Law grad to solicitor','This path has been analyse',NULL,0,0),(14,30,'Pipefitter to superintendant ','This path has been analyse',NULL,0,0),(15,30,'Law ','This path has been analyse',NULL,0,0),(16,30,'law 2','This path has been analyse',NULL,0,0),(17,30,'javascript','This path has been analyse',NULL,0,0),(18,36,'IT Specialist Career','This path has been analyse',NULL,0,1),(19,37,'javascript','This path has been analyse',NULL,1,1),(20,37,'python developer','This path has been analyse',NULL,1,1),(21,37,'data entry','This path has been analyse',NULL,1,1),(22,37,'data entry operator','This path has been analyse',NULL,1,1),(23,28,'frontend developer','This path has been analyse',NULL,1,1),(24,37,'ml engineer','This path has been analyse',NULL,1,1),(25,37,' Machine learning developer','This path has been analyse',NULL,1,1),(26,37,'react js developer','This path has been analyse',NULL,1,1),(27,37,'react js developer','This path has been analyse',NULL,1,1),(28,37,'ai engineer','This path has been analyse',NULL,1,1),(29,37,'data entry operator','This path has been analyse',NULL,1,1),(30,37,' python developer','This path has been analyse',NULL,1,1),(31,37,' python developer','This path has been analyse',NULL,1,1),(32,37,' python developer','This path has been analyse',NULL,1,1),(33,37,'python developer','This path has been analyse',NULL,1,1),(34,37,' python developer','This path has been analyse',NULL,1,1),(35,37,'mechanic ','This path has been analyse',NULL,1,1),(36,37,'blockchain developer','This path has been analyse',NULL,1,1),(37,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(38,37,' python developer','This path has been analyse',NULL,1,1),(39,37,' python developer','This path has been analyse',NULL,1,1),(40,37,'blockchain with Ai developer','This path has been analyse',NULL,1,1),(41,37,'mechanic ','This path has been analyse',NULL,1,1),(42,37,'react js developer','This path has been analyse',NULL,1,1),(43,37,'data entry operator','This path has been analyse',NULL,1,1),(44,37,'ai engineer','This path has been analyse',NULL,1,1),(45,37,'data entry operator','This path has been analyse',NULL,1,1),(46,37,'singer','This path has been analyse',NULL,0,1),(47,37,'python developer banna hy mujhe','This path has been analyse',NULL,0,1),(48,37,'python developer banna hy mujhe','This path has been analyse',NULL,0,1),(49,37,'javascript deveoper','This path has been analyse',NULL,0,1),(50,37,'ml engineer','This path has been analyse',NULL,0,1),(51,37,'javascript deveoper','This path has been analyse',NULL,0,1),(52,28,'python developer','This path has been analyse',NULL,1,1),(53,28,'python developer','This path has been analyse',NULL,1,1),(54,28,'python developer','This path has been analyse',NULL,1,1),(55,28,'singer','This path has been analyse',NULL,0,1),(56,28,'ai engineer','This path has been analyse',NULL,0,1),(57,28,'frontend developer','This path has been analyse',NULL,0,1),(58,28,'graphic designer','This path has been analyse',NULL,0,1),(59,28,'wordpress developer','This path has been analyse',NULL,0,1),(60,28,'graphic designer','This path has been analyse',NULL,0,1),(61,28,'wordpress developer','This path has been analyse',NULL,0,1),(62,28,'data analyst','This path has been analyse',NULL,0,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `path`
--

LOCK TABLES `path` WRITE;
/*!40000 ALTER TABLE `path` DISABLE KEYS */;
INSERT INTO `path` VALUES (1,'I am a graphic designer & wanna be a Frontend Developer.',NULL,'analysed',28,'graphic designer',NULL),(2,'I am a wordpress developer & wanna be a data scientist what would be the roadmap for it?',NULL,'analysed',28,'wordpress developer',NULL),(3,'I am professional singer & wanna be a data analyst',NULL,'analysed',28,'data analyst',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis`
--

LOCK TABLES `skill_gap_analysis` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis` DISABLE KEYS */;
INSERT INTO `skill_gap_analysis` VALUES (150,6,'HTML/CSS','High','pending'),(151,6,'PHP','High','pending'),(152,6,'JavaScript','High','pending'),(153,6,'WordPress Plugins','High','pending'),(154,6,'SEO','Medium','pending'),(155,6,'Leadership','High','pending'),(156,6,'Project Management','High','pending'),(157,6,'Conflict Resolution','Medium','pending'),(158,6,'Time Management','Medium','pending'),(159,6,'Technical Expertise','High','pending'),(160,6,'Agile Methodologies','High','pending'),(161,6,'Risk Management','Medium','pending'),(162,6,'Budgeting','Medium','pending'),(163,6,'Client Relations','Medium','pending'),(164,6,'Resource Allocation','Medium','pending'),(165,6,'Strategic Thinking','Medium','pending'),(166,6,'Product Lifecycle','Medium','pending'),(167,6,'Market Analysis','Medium','pending'),(168,6,'Stakeholder Management','Medium','pending'),(169,6,'Roadmapping','Medium','pending'),(170,6,'Process Improvement','Medium','pending'),(171,6,'Performance Metrics','Medium','pending'),(172,6,'Operational Strategy','Medium','pending'),(173,6,'Change Management','Medium','pending'),(174,6,'Analytical Thinking','Medium','pending'),(175,6,'Visionary Leadership','High','pending'),(176,6,'Technology Roadmap','High','pending'),(177,6,'Innovation Management','Medium','pending'),(178,6,'Cross-Department Collaboration','Medium','pending'),(179,6,'Risk Assessment','High','pending'),(240,9,'Adobe Photoshop','High','pending'),(241,9,'Adobe Illustrator','High','pending'),(242,9,'Typography','Medium','pending'),(243,9,'Layout Design','Medium','pending'),(244,9,'Color Theory','Medium','pending'),(245,9,'Wireframing','High','pending'),(246,9,'Prototyping','High','pending'),(247,9,'User Research','High','pending'),(248,9,'Usability Testing','High','pending'),(249,9,'Interaction Design','High','pending'),(250,9,'Design Thinking','High','pending'),(251,9,'Information Architecture',NULL,'completed'),(252,9,'Responsive Design',NULL,'completed'),(253,9,'A/B Testing','High','pending'),(254,9,'Accessibility','High','pending'),(255,9,'Visual Design','Medium','pending'),(256,9,'User Journeys','Medium','pending'),(257,9,'Persona Development','Medium','pending'),(258,9,'User-Centered Design','High','pending'),(259,9,'Design Systems','Medium','pending'),(260,9,'Client Management','Medium','pending'),(261,9,'Project Planning','Medium','pending'),(262,9,'Communication','Medium','pending'),(263,9,'Problem Solving','High','pending'),(264,9,'Time Management','Medium','pending'),(265,9,'Leadership','Medium','pending'),(266,9,'Team Building','Medium','pending'),(267,9,'Strategic Planning','Medium','pending'),(268,9,'Budget Management','Medium','pending'),(269,9,'Mentorship','Medium','pending');
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
) ENGINE=InnoDB AUTO_INCREMENT=392 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_gap_analysis_resources`
--

LOCK TABLES `skill_gap_analysis_resources` WRITE;
/*!40000 ALTER TABLE `skill_gap_analysis_resources` DISABLE KEYS */;
INSERT INTO `skill_gap_analysis_resources` VALUES (182,150,'HTML/CSS','Codecademy','https://www.codecademy.com/learn/learn-html-css'),(183,150,'HTML/CSS','W3Schools','https://www.w3schools.com/html/'),(184,151,'PHP','Udemy','https://www.udemy.com/course/php-for-beginners/'),(185,151,'PHP','PHP.net','https://www.php.net/manual/en/'),(186,152,'JavaScript','FreeCodeCamp','https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/'),(187,152,'JavaScript','MDN Web Docs','https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide'),(188,153,'WordPress Plugins','LinkedIn Learning','https://www.linkedin.com/learning/wordpress-plugin-development'),(189,153,'WordPress Plugins','Plugin Handbook','https://developer.wordpress.org/plugins/'),(190,154,'SEO','Moz','https://moz.com/beginners-guide-to-seo'),(191,154,'SEO','Coursera','https://www.coursera.org/specializations/seo'),(192,155,'Leadership','Harvard Business Review','https://hbr.org/topic/leadership'),(193,155,'Leadership','Coursera','https://www.coursera.org/learn/leading-people-teams'),(194,156,'Project Management','PMI','https://www.pmi.org/certifications/types/certified-associate-capm'),(195,156,'Project Management','edX','https://www.edx.org/course/introduction-to-project-management'),(196,157,'Conflict Resolution','Udemy','https://www.udemy.com/course/conflict-resolution-skills/'),(197,157,'Conflict Resolution','LinkedIn Learning','https://www.linkedin.com/learning/conflict-resolution-foundations'),(198,158,'Time Management','Coursera','https://www.coursera.org/learn/work-smarter-not-harder'),(199,158,'Time Management','LinkedIn Learning','https://www.linkedin.com/learning/time-management-fundamentals'),(200,159,'Technical Expertise','Pluralsight','https://www.pluralsight.com/paths/technical-leadership'),(201,159,'Technical Expertise','Udacity','https://www.udacity.com/course/technical-program-management--nd087'),(202,160,'Agile Methodologies','Scrum.org','https://www.scrum.org/resources/what-is-agile'),(203,160,'Agile Methodologies','Coursera','https://www.coursera.org/specializations/agile-development'),(204,161,'Risk Management','PMI','https://www.pmi.org/certifications/risk-management-pmi-rmp'),(205,161,'Risk Management','Udemy','https://www.udemy.com/course/risk-management/'),(206,162,'Budgeting','Coursera','https://www.coursera.org/learn/finance-for-non-finance'),(207,162,'Budgeting','edX','https://www.edx.org/course/introduction-to-corporate-finance'),(208,163,'Client Relations','LinkedIn Learning','https://www.linkedin.com/learning/building-rapport-with-customers'),(209,163,'Client Relations','HubSpot','https://academy.hubspot.com/courses/customer-success'),(210,164,'Resource Allocation','MindTools','https://www.mindtools.com/pages/article/newPPM_88.htm'),(211,164,'Resource Allocation','Coursera','https://www.coursera.org/learn/resource-management-capacity-planning'),(212,165,'Strategic Thinking','LinkedIn Learning','https://www.linkedin.com/learning/strategic-thinking'),(213,165,'Strategic Thinking','Harvard Business Review','https://hbr.org/2015/01/the-big-picture-building-strategic-skills'),(214,166,'Product Lifecycle','Coursera','https://www.coursera.org/learn/product-management'),(215,166,'Product Lifecycle','Udemy','https://www.udemy.com/course/product-management-101/'),(216,167,'Market Analysis','LinkedIn Learning','https://www.linkedin.com/learning/market-research-foundations'),(217,167,'Market Analysis','edX','https://www.edx.org/micromasters/marketing-analytics'),(218,168,'Stakeholder Management','Udemy','https://www.udemy.com/course/stakeholder-management/'),(219,168,'Stakeholder Management','LinkedIn Learning','https://www.linkedin.com/learning/managing-stakeholders'),(220,169,'Roadmapping','ProductPlan','https://www.productplan.com/learn/product-roadmap/'),(221,169,'Roadmapping','Udemy','https://www.udemy.com/course/agile-roadmap-planning/'),(222,170,'Process Improvement','Six Sigma','https://www.sixsigmaonline.org/six-sigma-certification/yellow-belt/'),(223,170,'Process Improvement','LinkedIn Learning','https://www.linkedin.com/learning/process-improvement-foundations'),(224,171,'Performance Metrics','Coursera','https://www.coursera.org/learn/metrics'),(225,171,'Performance Metrics','LinkedIn Learning','https://www.linkedin.com/learning/measuring-team-performance'),(226,172,'Operational Strategy','Coursera','https://www.coursera.org/learn/operations-management'),(227,172,'Operational Strategy','edX','https://www.edx.org/course/operational-management-strategy'),(228,173,'Change Management','LinkedIn Learning','https://www.linkedin.com/learning/change-management-foundations'),(229,173,'Change Management','Prosci','https://www.prosci.com/change-management/thought-leadership-library'),(230,174,'Analytical Thinking','Coursera','https://www.coursera.org/learn/critical-thinking'),(231,174,'Analytical Thinking','LinkedIn Learning','https://www.linkedin.com/learning/thinking-critically'),(232,175,'Visionary Leadership','Harvard Business Review','https://hbr.org/topic/visionary-leadership'),(233,175,'Visionary Leadership','Coursera','https://www.coursera.org/learn/visionary-leadership'),(234,176,'Technology Roadmap','Pluralsight','https://www.pluralsight.com/paths/technology-roadmap'),(235,176,'Technology Roadmap','LinkedIn Learning','https://www.linkedin.com/learning/planning-a-technology-roadmap'),(236,177,'Innovation Management','edX','https://www.edx.org/course/managing-innovation'),(237,177,'Innovation Management','Coursera','https://www.coursera.org/learn/innovation-management'),(238,178,'Cross-Department Collaboration','LinkedIn Learning','https://www.linkedin.com/learning/cross-functional-collaboration'),(239,178,'Cross-Department Collaboration','Udemy','https://www.udemy.com/course/effective-communication-and-collaboration/'),(240,179,'Risk Assessment','PMI','https://www.pmi.org/learning/library/risk-assessment-management-structuring-6894'),(241,179,'Risk Assessment','Coursera','https://www.coursera.org/learn/risk-management'),(362,240,'Adobe Photoshop','Udemy','https://www.udemy.com/course/adobe-photoshop-cc-complete-beginner-to-advanced-training/'),(363,240,'Adobe Photoshop','LinkedIn Learning','https://www.linkedin.com/learning/photoshop-2024-essential-training'),(364,241,'Adobe Illustrator','Coursera','https://www.coursera.org/learn/adobe-illustrator-cc'),(365,241,'Adobe Illustrator','YouTube','https://www.youtube.com/watch?v=Q1nUEuTFkHs'),(366,242,'Typography','Skillshare','https://www.skillshare.com/classes/Typography-That-Works-Typographic-Composition-and-Fonts/123456'),(367,243,'Layout Design','Domestika','https://www.domestika.org/en/courses/1234-introduction-to-graphic-design-layout-and-composition'),(368,244,'Color Theory','Khan Academy','https://www.khanacademy.org/humanities/art-history-basics/ah-art-elements-techniques/color/a/color-and-light'),(369,245,'Wireframing','Figma','https://www.figma.com/resources/learn-design/wireframing-for-beginners/'),(370,246,'Prototyping','InVision','https://www.invisionapp.com/inside-design/prototyping-course'),(371,247,'User Research','Interaction Design Foundation','https://www.interaction-design.org/courses/conducting-usability-research'),(372,248,'Usability Testing','Google','https://www.google.com/design/spec/usability-testing.html'),(373,249,'Interaction Design','Coursera','https://www.coursera.org/specializations/interaction-design'),(374,250,'Design Thinking','IDEO U','https://www.ideou.com/pages/design-thinking'),(375,253,'A/B Testing','Optimizely','https://www.optimizely.com/optimization-glossary/ab-testing/'),(376,254,'Accessibility','W3C','https://www.w3.org/WAI/'),(377,255,'Visual Design','Medium','https://medium.com/design-bootcamp/principles-of-visual-design-6b99e5f14e9e'),(378,256,'User Journeys','NNG','https://www.nngroup.com/articles/journey-mapping-101/'),(379,257,'Persona Development','HubSpot','https://blog.hubspot.com/marketing/buyer-persona-research'),(380,258,'User-Centered Design','Microsoft','https://www.microsoft.com/design/ux-guide'),(381,259,'Design Systems','Smashing Magazine','https://www.smashingmagazine.com/2019/06/design-systems-guide/'),(382,260,'Client Management','LinkedIn Learning','https://www.linkedin.com/learning/client-management-for-creative-teams'),(383,261,'Project Planning','Coursera','https://www.coursera.org/specializations/project-management'),(384,262,'Communication','Toastmasters','https://www.toastmasters.org/pathways-overview'),(385,263,'Problem Solving','MIT OpenCourseWare','https://ocw.mit.edu/courses/special-programs/sp-268-the-missing-semester-of-your-cs-education-january-iap-2020/'),(386,264,'Time Management','Mind Tools','https://www.mindtools.com/pages/main/newMN_HTE.htm'),(387,265,'Leadership','Harvard Business Review','https://hbr.org/2000/03/leadership-that-gets-results'),(388,266,'Team Building','Team Building USA','https://www.teambuildingusa.com/'),(389,267,'Strategic Planning','Strategic Management Society','https://www.strategicmanagement.net/research'),(390,268,'Budget Management','Investopedia','https://www.investopedia.com/articles/pf/08/personal-budget.asp'),(391,269,'Mentorship','Mentorloop','https://mentorloop.com/resources/mentoring-guide/');
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
) ENGINE=InnoDB AUTO_INCREMENT=496 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (181,'Adobe Photoshop',1,37,'pending'),(182,'Adobe Illustrator',2,37,'pending'),(183,'Typography',3,37,'pending'),(184,'Layout Design',4,37,'pending'),(185,'Color Theory',5,37,'pending'),(186,'Wireframing',1,38,'pending'),(187,'Prototyping',2,38,'pending'),(188,'User Research',3,38,'pending'),(189,'Usability Testing',4,38,'pending'),(190,'Interaction Design',5,38,'pending'),(191,'Design Thinking',1,39,'pending'),(192,'Information Architecture',2,39,'completed'),(193,'Responsive Design',3,39,'completed'),(194,'A/B Testing',4,39,'pending'),(195,'Accessibility',5,39,'pending'),(196,'Visual Design',1,40,'pending'),(197,'User Journeys',2,40,'pending'),(198,'Persona Development',3,40,'pending'),(199,'User-Centered Design',4,40,'pending'),(200,'Design Systems',5,40,'pending'),(201,'Client Management',1,41,'pending'),(202,'Project Planning',2,41,'pending'),(203,'Communication',3,41,'pending'),(204,'Problem Solving',4,41,'pending'),(205,'Time Management',5,41,'pending'),(206,'Leadership',1,42,'pending'),(207,'Team Building',2,42,'pending'),(208,'Strategic Planning',3,42,'pending'),(209,'Budget Management',4,42,'pending'),(210,'Mentorship',5,42,'pending'),(211,'Team Leadership',1,43,'pending'),(212,'Project Management',2,43,'pending'),(213,'Conflict Resolution',3,43,'pending'),(214,'Feedback Delivery',4,43,'pending'),(215,'Delegation',5,43,'pending'),(216,'Creative Vision',1,44,'pending'),(217,'Brand Strategy',2,44,'pending'),(218,'Art Direction',3,44,'pending'),(219,'Client Relations',4,44,'pending'),(220,'Innovation',5,44,'pending'),(221,'Advanced Leadership',1,45,'pending'),(222,'Strategic Insight',2,45,'pending'),(223,'Market Analysis',3,45,'pending'),(224,'Creative Problem Solving',4,45,'pending'),(225,'Negotiation',5,45,'pending'),(226,'Executive Leadership',1,46,'pending'),(227,'Visionary Thinking',2,46,'pending'),(228,'Cross-Departmental Collaboration',3,46,'pending'),(229,'Change Management',4,46,'pending'),(230,'Decision Making',5,46,'pending'),(231,'Executive Oversight',1,47,'pending'),(232,'Global Strategy',2,47,'pending'),(233,'Industry Leadership',3,47,'pending'),(234,'Corporate Governance',4,47,'pending'),(235,'Business Acumen',5,47,'pending'),(236,'HTML',1,48,'pending'),(237,'CSS',2,48,'pending'),(238,'Responsive Design',3,48,'pending'),(239,'Web Typography',4,48,'pending'),(240,'Basic JavaScript',5,48,'pending'),(241,'JavaScript',1,49,'pending'),(242,'React',2,49,'pending'),(243,'Version Control (Git)',3,49,'pending'),(244,'APIs',4,49,'pending'),(245,'DOM Manipulation',5,49,'pending'),(246,'Vue.js',1,50,'pending'),(247,'Angular',2,50,'pending'),(248,'Webpack',3,50,'pending'),(249,'Sass',4,50,'pending'),(250,'Performance Optimization',5,50,'pending'),(251,'Node.js',1,51,'pending'),(252,'Express.js',2,51,'pending'),(253,'Database Management',3,51,'pending'),(254,'Authentication',4,51,'pending'),(255,'RESTful Services',5,51,'pending'),(256,'Technical Leadership',1,52,'pending'),(257,'Code Review',2,52,'pending'),(258,'System Architecture',3,52,'pending'),(259,'Agile Methodologies',4,52,'pending'),(260,'Continuous Integration',5,52,'pending'),(261,'HTML',1,53,'pending'),(262,'CSS',2,53,'pending'),(263,'Responsive Design',3,53,'pending'),(264,'Web Graphics',4,53,'pending'),(265,'Basic JavaScript',5,53,'pending'),(266,'JavaScript',1,54,'pending'),(267,'React',2,54,'pending'),(268,'CSS Preprocessors',3,54,'pending'),(269,'Version Control',4,54,'pending'),(270,'Debugging',5,54,'pending'),(271,'Advanced JavaScript',1,55,'pending'),(272,'Angular',2,55,'pending'),(273,'API Integration',3,55,'pending'),(274,'Responsive Frameworks',4,55,'pending'),(275,'Testing and Debugging',5,55,'pending'),(276,'Leadership',1,56,'pending'),(277,'Mentorship',2,56,'pending'),(278,'Advanced React',3,56,'pending'),(279,'Performance Tuning',4,56,'pending'),(280,'Security Best Practices',5,56,'pending'),(281,'System Design',1,57,'pending'),(282,'Scalability',2,57,'pending'),(283,'Technical Strategy',3,57,'pending'),(284,'Cross-Platform Development',4,57,'pending'),(285,'Advanced Problem Solving',5,57,'pending'),(286,'HTML/CSS',1,58,'completed'),(287,'PHP',2,58,'pending'),(288,'JavaScript',3,58,'pending'),(289,'WordPress Plugins',4,58,'pending'),(290,'SEO',5,58,'pending'),(291,'Client Communication',1,59,'pending'),(292,'Project Management',2,59,'pending'),(293,'Responsive Design',3,59,'pending'),(294,'Content Management',4,59,'pending'),(295,'Problem Solving',5,59,'pending'),(296,'Google Analytics',1,60,'pending'),(297,'Social Media Marketing',2,60,'pending'),(298,'Email Campaigns',3,60,'pending'),(299,'Content Creation',4,60,'pending'),(300,'SEO Optimization',5,60,'pending'),(301,'Adobe XD',1,61,'pending'),(302,'User Research',2,61,'pending'),(303,'Wireframing',3,61,'pending'),(304,'Prototyping',4,61,'pending'),(305,'Usability Testing',5,61,'pending'),(306,'Content Writing',1,62,'pending'),(307,'SEO',2,62,'pending'),(308,'Content Strategy',3,62,'pending'),(309,'Social Media',4,62,'pending'),(310,'Audience Engagement',5,62,'pending'),(311,'Excel',1,63,'pending'),(312,'SQL',2,63,'pending'),(313,'Data Visualization',3,63,'pending'),(314,'Statistical Analysis',4,63,'pending'),(315,'Python',5,63,'pending'),(316,'Leadership',1,64,'pending'),(317,'Project Management',2,64,'pending'),(318,'Conflict Resolution',3,64,'pending'),(319,'Time Management',4,64,'pending'),(320,'Technical Expertise',5,64,'pending'),(321,'Agile Methodologies',1,65,'completed'),(322,'Risk Management',2,65,'completed'),(323,'Budgeting',3,65,'completed'),(324,'Client Relations',4,65,'pending'),(325,'Resource Allocation',5,65,'pending'),(326,'Strategic Thinking',1,66,'pending'),(327,'Product Lifecycle',2,66,'pending'),(328,'Market Analysis',3,66,'pending'),(329,'Stakeholder Management',4,66,'pending'),(330,'Roadmapping',5,66,'pending'),(331,'Process Improvement',1,67,'pending'),(332,'Performance Metrics',2,67,'pending'),(333,'Operational Strategy',3,67,'pending'),(334,'Change Management',4,67,'pending'),(335,'Analytical Thinking',5,67,'pending'),(336,'Visionary Leadership',1,68,'pending'),(337,'Technology Roadmap',2,68,'pending'),(338,'Innovation Management',3,68,'pending'),(339,'Cross-Department Collaboration',4,68,'pending'),(340,'Risk Assessment',5,68,'pending'),(341,'React.js',1,69,'pending'),(342,'Vue.js',2,69,'pending'),(343,'CSS Preprocessors',3,69,'pending'),(344,'JavaScript Frameworks',4,69,'pending'),(345,'Version Control',5,69,'pending'),(346,'Node.js',1,70,'pending'),(347,'Express.js',2,70,'pending'),(348,'Database Management',3,70,'pending'),(349,'RESTful APIs',4,70,'pending'),(350,'Cloud Services',5,70,'pending'),(351,'ETL Processes',1,71,'pending'),(352,'Big Data Technologies',2,71,'pending'),(353,'Data Warehousing',3,71,'pending'),(354,'Apache Hadoop',4,71,'pending'),(355,'Data Mining',5,71,'pending'),(356,'Machine Learning Algorithms',1,72,'pending'),(357,'TensorFlow',2,72,'pending'),(358,'Scikit-learn',3,72,'pending'),(359,'Model Evaluation',4,72,'pending'),(360,'Python Programming',5,72,'pending'),(361,'Data Modeling',1,73,'pending'),(362,'Predictive Analytics',2,73,'pending'),(363,'Data Visualization Tools',3,73,'pending'),(364,'Statistical Modeling',4,73,'pending'),(365,'Advanced Python',5,73,'pending'),(366,'Python Syntax',1,74,'completed'),(367,'Data Structures',2,74,'completed'),(368,'Error Handling',3,74,'completed'),(369,'Object-Oriented Programming',4,74,'pending'),(370,'Libraries like Pandas and NumPy',5,74,'pending'),(371,'Data Cleaning',1,75,'pending'),(372,'Exploratory Data Analysis',2,75,'pending'),(373,'Statistical Methods',3,75,'pending'),(374,'Data Visualization',4,75,'pending'),(375,'Python Libraries: Matplotlib, Seaborn',5,75,'pending'),(376,'Supervised Learning',1,76,'pending'),(377,'Unsupervised Learning',2,76,'pending'),(378,'Model Evaluation',3,76,'pending'),(379,'Scikit-learn',4,76,'pending'),(380,'Feature Engineering',5,76,'pending'),(381,'Project Management',1,77,'pending'),(382,'Data Wrangling',2,77,'pending'),(383,'Model Deployment',3,77,'pending'),(384,'Data Ethics',4,77,'pending'),(385,'Collaboration Tools',5,77,'pending'),(386,'Advanced Data Modeling',1,78,'pending'),(387,'Predictive Analytics',2,78,'pending'),(388,'Big Data Handling',3,78,'pending'),(389,'Machine Learning Deployment',4,78,'pending'),(390,'Continuous Learning',5,78,'pending'),(391,'Data Literacy',1,79,'pending'),(392,'Statistical Analysis',2,79,'pending'),(393,'Problem Solving',3,79,'pending'),(394,'Creativity',4,79,'pending'),(395,'Adaptability',5,79,'pending'),(396,'Music Industry Knowledge',1,80,'pending'),(397,'Data Visualization',2,80,'pending'),(398,'Trend Analysis',3,80,'pending'),(399,'Communication',4,80,'pending'),(400,'Data Collection',5,80,'pending'),(401,'Project Management',1,81,'pending'),(402,'Critical Thinking',2,81,'pending'),(403,'Data Cleaning',3,81,'pending'),(404,'Collaboration',4,81,'pending'),(405,'Presentation Skills',5,81,'pending'),(406,'Networking',1,82,'pending'),(407,'Interpersonal Skills',2,82,'pending'),(408,'Industry Research',3,82,'pending'),(409,'Negotiation',4,82,'pending'),(410,'Influence',5,82,'pending'),(411,'Public Speaking',1,83,'pending'),(412,'Active Listening',2,83,'pending'),(413,'Event Participation',3,83,'pending'),(414,'Note-taking',4,83,'pending'),(415,'Continuous Learning',5,83,'pending'),(416,'Consulting',1,84,'pending'),(417,'Strategic Planning',2,84,'pending'),(418,'Analytical Thinking',3,84,'pending'),(419,'Client Management',4,84,'pending'),(420,'Decision Making',5,84,'pending'),(421,'Leadership',1,85,'pending'),(422,'Team Management',2,85,'completed'),(423,'Performance Evaluation',3,85,'completed'),(424,'Conflict Resolution',4,85,'completed'),(425,'Time Management',5,85,'pending'),(426,'Strategic Thinking',1,86,'pending'),(427,'Project Planning',2,86,'pending'),(428,'Resource Allocation',3,86,'pending'),(429,'Risk Management',4,86,'pending'),(430,'Goal Setting',5,86,'pending'),(431,'Data Governance',1,87,'pending'),(432,'Policy Development',2,87,'pending'),(433,'Compliance',3,87,'pending'),(434,'Quality Assurance',4,87,'pending'),(435,'Stakeholder Engagement',5,87,'pending'),(436,'Mentoring',1,88,'pending'),(437,'Coaching',2,88,'pending'),(438,'Feedback',3,88,'pending'),(439,'Career Development',4,88,'pending'),(440,'Empathy',5,88,'pending'),(441,'Executive Leadership',1,89,'pending'),(442,'Visionary Thinking',2,89,'pending'),(443,'Budget Management',3,89,'pending'),(444,'Corporate Governance',4,89,'pending'),(445,'Change Management',5,89,'pending'),(446,'Technical Proficiency',1,90,'pending'),(447,'SQL',2,90,'pending'),(448,'Python',3,90,'pending'),(449,'Excel',4,90,'pending'),(450,'Data Wrangling',5,90,'pending'),(451,'Data Visualization',1,91,'pending'),(452,'Tableau',2,91,'pending'),(453,'Power BI',3,91,'pending'),(454,'Design Thinking',4,91,'pending'),(455,'User Experience',5,91,'pending'),(456,'Statistics',1,92,'pending'),(457,'Regression Analysis',2,92,'pending'),(458,'Predictive Modeling',3,92,'pending'),(459,'Machine Learning',4,92,'pending'),(460,'Hypothesis Testing',5,92,'pending'),(461,'Machine Learning',1,93,'pending'),(462,'Model Deployment',2,93,'pending'),(463,'Algorithm Optimization',3,93,'pending'),(464,'Data Engineering',4,93,'pending'),(465,'Big Data',5,93,'pending'),(466,'Data Science',1,94,'pending'),(467,'Artificial Intelligence',2,94,'pending'),(468,'Deep Learning',3,94,'pending'),(469,'Research',4,94,'pending'),(470,'Innovation',5,94,'pending'),(471,'Certification Preparation',1,95,'pending'),(472,'Exam Techniques',2,95,'pending'),(473,'Time Management',3,95,'pending'),(474,'Focus',4,95,'pending'),(475,'Persistence',5,95,'pending'),(476,'Project Execution',1,96,'pending'),(477,'Collaboration',2,96,'pending'),(478,'Data Interpretation',3,96,'pending'),(479,'Problem Solving',4,96,'pending'),(480,'Attention to Detail',5,96,'pending'),(481,'Portfolio Development',1,97,'pending'),(482,'Self-Promotion',2,97,'pending'),(483,'Content Creation',3,97,'pending'),(484,'Branding',4,97,'pending'),(485,'Presentation',5,97,'pending'),(486,'Job Search',1,98,'pending'),(487,'Resume Writing',2,98,'pending'),(488,'Interviewing',3,98,'pending'),(489,'Networking',4,98,'pending'),(490,'Negotiation',5,98,'pending'),(491,'Advanced Analysis',1,99,'pending'),(492,'Leadership',2,99,'pending'),(493,'Mentoring',3,99,'pending'),(494,'Strategic Thinking',4,99,'pending'),(495,'Relationship Building',5,99,'pending');
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
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps`
--

LOCK TABLES `steps` WRITE;
/*!40000 ALTER TABLE `steps` DISABLE KEYS */;
INSERT INTO `steps` VALUES (37,'Graphic Designer','Build a strong foundation in graphic design principles and software.',1,1,'pending',9),(38,'UI/UX Design Exploration','Explore user interface and user experience design.',1,1,'pending',10),(39,'Advanced UI/UX Design','Master advanced concepts in UI/UX design.',2,1,'pending',10),(40,'UI/UX Design Specialist','Become a specialist in UI/UX design with a strong portfolio.',3,1,'pending',10),(41,'UI/UX Consultant','Consult on UI/UX projects for various clients.',4,1,'pending',10),(42,'Head of UI/UX Design','Lead a team of designers in a UI/UX department.',5,1,'pending',10),(43,'Design Team Lead','Lead a small team of graphic designers.',1,1,'pending',11),(44,'Creative Director','Oversee the creative direction of projects.',2,1,'pending',11),(45,'Senior Creative Director','Manage larger creative teams and complex projects.',3,1,'pending',11),(46,'VP of Design','Guide the overall design strategy of the company.',4,1,'pending',11),(47,'Chief Design Officer','Head the design department at the executive level.',5,1,'pending',11),(48,'Web Design Basics','Learn the basics of web design and development.',1,1,'pending',12),(49,'Frontend Development','Gain skills in frontend development technologies.',2,1,'pending',12),(50,'Advanced Frontend Development','Develop advanced skills in frontend frameworks.',3,1,'pending',12),(51,'Full Stack Developer','Expand knowledge to include backend technologies.',4,1,'pending',12),(52,'Lead Frontend Developer','Lead a team of frontend developers on complex projects.',5,1,'pending',12),(53,'Transition to Web Design','Begin transitioning skills from graphic design to web design.',2,1,'pending',9),(54,'Junior Frontend Developer','Secure a position as a junior frontend developer.',3,1,'pending',9),(55,'Frontend Developer','Establish yourself as a competent frontend developer.',4,1,'pending',9),(56,'Senior Frontend Developer','Achieve a senior position in frontend development.',5,1,'pending',9),(57,'Frontend Architect','Become a frontend architect, designing complex systems.',6,1,'pending',9),(58,'WordPress Developer','Enhance your skills and experience as a WordPress Developer to build a strong foundation.',1,2,'pending',13),(59,'Freelance Web Consultant','Explore freelance opportunities to broaden your expertise in various web technologies.',1,2,'pending',14),(60,'Digital Marketing Specialist','Gain insights into digital marketing strategies and tools.',2,2,'pending',14),(61,'UX/UI Designer','Develop skills in user experience and interface design.',3,2,'pending',14),(62,'Tech Blogger','Start a tech blog to share knowledge and establish authority in the field.',4,2,'pending',14),(63,'Data Analyst','Transition into data analysis to build foundational skills for data science.',5,2,'pending',14),(64,'Team Lead','Lead a team of WordPress developers, managing projects and team dynamics.',1,2,'pending',15),(65,'Project Manager','Oversee web development projects from inception to completion.',2,2,'pending',15),(66,'Product Manager','Define product vision and strategy, collaborating with cross-functional teams.',3,2,'pending',15),(67,'Operations Manager','Manage daily operations and optimize processes for efficiency.',4,2,'pending',15),(68,'Chief Technology Officer (CTO)','Lead the technology strategy and innovation at an organizational level.',5,2,'pending',15),(69,'Front-end Developer','Specialize in front-end technologies to enhance user interfaces.',1,2,'pending',16),(70,'Full Stack Developer','Expand your skills to include back-end development.',2,2,'pending',16),(71,'Data Engineer','Focus on data infrastructure and pipeline development.',3,2,'pending',16),(72,'Machine Learning Engineer','Develop machine learning models and algorithms.',4,2,'pending',16),(73,'Data Scientist','Reach your goal of becoming a data scientist with expertise in data analysis and modeling.',5,2,'pending',16),(74,'Learn Python Programming','Gain proficiency in Python, which is essential for data science.',2,2,'pending',13),(75,'Master Data Analysis','Develop core skills in data analysis to handle real-world datasets.',3,2,'pending',13),(76,'Engage in Machine Learning','Learn the fundamentals of machine learning algorithms and their applications.',4,2,'pending',13),(77,'Specialize in Data Science Projects','Work on projects to apply data science skills in real-world scenarios.',5,2,'pending',13),(78,'Achieve Data Scientist Role','Secure a position as a data scientist, applying all acquired skills to solve complex data problems.',6,2,'pending',13),(79,'Transition from Singing to Data Analysis','Begin learning foundational data analysis skills while leveraging existing creative skills.',1,3,'pending',17),(80,'Explore Music Data Analysis','Analyze music industry data to find trends and insights.',1,3,'pending',18),(81,'Develop a Music Analytics Project','Create a project that analyzes a specific aspect of music data.',2,3,'pending',18),(82,'Network with Music Data Professionals','Build connections in the music data field.',3,3,'pending',18),(83,'Attend Music Data Conferences','Participate in industry events to stay updated.',4,3,'pending',18),(84,'Become a Music Data Consultant','Offer expert advice on music data to various stakeholders.',5,3,'pending',18),(85,'Lead a Data Analysis Team','Manage a team of data analysts in a company.',1,3,'pending',19),(86,'Develop Strategic Data Initiatives','Plan and implement data-driven strategies.',2,3,'pending',19),(87,'Enhance Data Governance','Improve data quality and governance in the organization.',3,3,'pending',19),(88,'Mentor Future Data Leaders','Guide and mentor upcoming data professionals.',4,3,'pending',19),(89,'Become a Chief Data Officer','Oversee data management and strategy at the executive level.',5,3,'pending',19),(90,'Master Data Analysis Tools','Gain expertise in tools like Excel, SQL, and Python.',1,3,'pending',20),(91,'Specialize in Data Visualization','Focus on creating impactful data visualizations.',2,3,'pending',20),(92,'Conduct Advanced Statistical Analysis','Perform complex data analyses using statistical methods.',3,3,'pending',20),(93,'Implement Machine Learning Models','Develop and deploy machine learning models.',4,3,'pending',20),(94,'Become a Data Science Expert','Achieve expertise in data science methodologies and applications.',5,3,'pending',20),(95,'Complete Data Analysis Certification','Obtain a certification in data analysis to validate skills.',2,3,'pending',17),(96,'Gain Practical Experience','Work on real-world data analysis projects to gain hands-on experience.',3,3,'pending',17),(97,'Build a Data Portfolio','Create a portfolio showcasing data analysis projects and skills.',4,3,'pending',17),(98,'Secure a Data Analyst Position','Apply for and secure a position as a data analyst.',5,3,'pending',17),(99,'Advance to Senior Data Analyst','Gain more responsibility and expertise as a senior data analyst.',6,3,'pending',17);
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
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_activities`
--

LOCK TABLES `training_activities` WRITE;
/*!40000 ALTER TABLE `training_activities` DISABLE KEYS */;
INSERT INTO `training_activities` VALUES (55,6,'HTML/CSS Intensive Bootcamp','Ability to build structured and styled web pages','Completion of projects and quizzes','4 weeks','2024-11-30 00:00:00','Self'),(56,6,'PHP Development Course','Understanding of PHP fundamentals and building dynamic websites','Project submissions and assessments','6 weeks','2025-01-15 00:00:00','Self'),(57,6,'JavaScript Mastery Workshop','Proficiency in JavaScript for front-end development','Completion of exercises and a capstone project','6 weeks','2025-03-01 00:00:00','Self'),(58,6,'WordPress Plugin Development Training','Capability to develop and customize WordPress plugins','Development of a custom plugin','4 weeks','2025-04-01 00:00:00','Self'),(59,6,'SEO Fundamentals Workshop','Knowledge to optimize websites for search engines','SEO audit of a website','3 weeks','2025-04-30 00:00:00','Self'),(60,6,'Leadership Skills Development Program','Enhanced leadership capabilities','360-degree feedback','4 weeks','2025-06-01 00:00:00','Self'),(61,6,'Project Management Certification','PMI certified associate in project management','Certification exam','8 weeks','2025-08-01 00:00:00','Self'),(78,9,'Adobe Photoshop Mastery Workshop','Become proficient in Adobe Photoshop for graphic design.','Completion of design projects','6 weeks','2025-01-15 00:00:00','Self'),(79,9,'Adobe Illustrator Advanced Techniques','Gain advanced skills in Adobe Illustrator.','Portfolio of vector designs','6 weeks','2025-03-01 00:00:00','Self'),(80,9,'Typography and Layout Design Course','Develop a keen eye for typography and layout in design.','Typography project','4 weeks','2025-04-01 00:00:00','Self'),(81,9,'UI/UX Design Fundamentals','Understand the basics of UI/UX design, including wireframing and prototyping.','Design a basic app interface','8 weeks','2025-10-30 00:00:00','Self'),(82,9,'Advanced UI/UX Design Techniques','Master advanced UI/UX principles, including usability testing and interaction design.','Usability tested UI prototype','12 weeks','2026-10-30 00:00:00','Self');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainning_plan`
--

LOCK TABLES `trainning_plan` WRITE;
/*!40000 ALTER TABLE `trainning_plan` DISABLE KEYS */;
INSERT INTO `trainning_plan` VALUES (6,'Engage in continuous learning by attending industry conferences, networking with professionals, and subscribing to tech and leadership journals. Regularly participate in webinars and workshops to stay updated with the latest trends and technologies in your field.',15),(9,'Engage in continuous learning by attending workshops, conferences, and webinars related to UI/UX design. Subscribe to industry publications and follow influential designers on social media to stay updated with the latest trends and techniques. Consider joining professional organizations such as the Interaction Design Association (IxDA) to connect with peers and gain access to additional resources.',10);
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

-- Dump completed on 2024-11-01  6:14:30
