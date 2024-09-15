-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: localhost    Database: career_map_2
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
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `step_id` bigint DEFAULT NULL,
  `color` varchar(255) NOT NULL,
  `path_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`step_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (18,NULL,'black',3),(19,507,'green',3),(20,507,'purple',3),(21,507,'blue',3);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facebook_login`
--

DROP TABLE IF EXISTS `facebook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facebook_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
-- Table structure for table `instagram_login`
--

DROP TABLE IF EXISTS `instagram_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instagram_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instagram_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `linkedin_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
-- Table structure for table `outlook_login`
--

DROP TABLE IF EXISTS `outlook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outlook_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `outlook_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `prompt` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','analyzing','analyzed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `user_id` int DEFAULT NULL,
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
INSERT INTO `path` VALUES (1,NULL,'Abdul Basit Arif Resume (1).pdf','blue','analyzed',2),(2,'I am a javascript developer',NULL,'#bb861e','analyzed',30),(3,'𝐉𝐨𝐢𝐧 𝐎𝐮𝐫 𝐓𝐞𝐚𝐦! Tassaract Corp Pvt Ltd 𝐢𝐬 𝐇𝐢𝐫𝐢𝐧𝐠 𝐚 𝐆𝐫𝐚𝐩𝐡𝐢𝐜 𝐃𝐞𝐬𝐢𝐠𝐧𝐞𝐫\n                                    Are you a creative thinker with a passion for design? Tassaract Corp Pvt Ltd is looking for a talented Graphic Designer to elevate our brand with creative and impactful designs! \n                                    Position: Graphic Designer\n                                    Experience Required: Minimum 1 year\n                                    Job Type: Hybrid\n                                    Location: Gulshan-e-Iqbal, Karachi\n\n                                    𝗞𝗲𝘆 𝗥𝗲𝘀𝗽𝗼𝗻𝘀𝗶𝗯𝗶𝗹𝗶𝘁𝗶𝗲𝘀:\n                                    •Design eye-catching visuals for both digital and print media\n                                    •Collaborate with the team to create engaging content for various platforms\n                                    •Develop creative concepts that align with our brand identity\n                                    •Ensure all designs are consistent with the latest design trends\n                                    •Provide input on design strategies and improve existing designs\n\n                                    𝗥𝗲𝗾𝘂𝗶𝗿𝗲𝗺𝗲𝗻𝘁𝘀:\n                                    •Strong portfolio showcasing your design skills across different mediums\n                                    •Proficiency in Adobe Creative Suite (Photoshop, Illustrator, InDesign)\n                                    •Experience with UI/UX design is a plus\n                                    •Familiarity with web design tools such as Figma or Sketch\n                                    •Excellent communication and collaboration skills\n                                    •1 year of experience in graphic design\n\n                                    𝗛𝗼𝘄 𝘁𝗼 𝗔𝗽𝗽𝗹𝘆:\n                                    If you\'re passionate about design and ready to make an impact, we want to hear from you! Please send your resume and portfolio to 𝗰𝗮𝗿𝗲𝗲𝗿𝘀@𝘁𝗮𝘀𝘀𝗮𝗿𝗮𝗰𝘁.𝗰𝗼𝗺\n\n                                    Based on this info write the skills which are required for this role',NULL,'blue','analyzed',30);
/*!40000 ALTER TABLE `path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_module`
--

DROP TABLE IF EXISTS `permission_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_module` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_module`
--

LOCK TABLES `permission_module` WRITE;
/*!40000 ALTER TABLE `permission_module` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `permission_module_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_permission_module` (`permission_module_id`),
  CONSTRAINT `fk_permission_module` FOREIGN KEY (`permission_module_id`) REFERENCES `permission_module` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'create-tabbars','2024-08-29 08:19:23','2024-08-29 12:14:42',NULL),(2,'create-tab','2024-08-29 12:13:06','2024-08-29 12:14:58',NULL),(3,'view-content','2024-08-30 06:00:18','2024-08-30 06:00:18',NULL);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_to_permission`
--

DROP TABLE IF EXISTS `role_to_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_to_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `role_to_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_to_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_to_permission`
--

LOCK TABLES `role_to_permission` WRITE;
/*!40000 ALTER TABLE `role_to_permission` DISABLE KEYS */;
INSERT INTO `role_to_permission` VALUES (1,4,2,'2024-08-29 12:22:04','2024-08-29 12:22:04'),(3,4,1,'2024-08-29 12:39:37','2024-08-29 12:39:37'),(4,5,2,'2024-08-30 06:01:46','2024-08-30 06:01:46'),(5,5,3,'2024-08-30 06:01:46','2024-08-30 06:01:46');
/*!40000 ALTER TABLE `role_to_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','2024-08-29 07:19:15','2024-08-29 07:23:08'),(2,'user','2024-08-29 07:29:26','2024-08-29 07:29:26'),(3,'sub admin','2024-08-29 12:04:49','2024-08-29 12:04:49'),(4,'sub child','2024-08-29 12:07:17','2024-08-29 12:09:38'),(5,'sub user','2024-08-30 05:59:37','2024-08-30 05:59:37');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort` tinyint(1) NOT NULL,
  `step_id` bigint DEFAULT NULL,
  `status` enum('pending','completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2549 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (2514,'Cloud Management',1,507,'pending'),(2515,'Infrastructure Automation',2,507,'pending'),(2516,'Linux/Windows System Administration',3,507,'pending'),(2517,'Scripting (Python, Shell)',4,507,'pending'),(2518,'Continuous Integration/Continuous Deployment',5,507,'pending'),(2519,'Intrusion Detection',1,508,'pending'),(2520,'Incident Response',2,508,'pending'),(2521,'Security Assessment and Testing',3,508,'pending'),(2522,'Security Systems Management',4,508,'pending'),(2523,'Cybersecurity Knowledge',5,508,'pending'),(2524,'Security Architecture Design',1,509,'pending'),(2525,'Network and Security Infrastructure',2,509,'pending'),(2526,'Risk Assessment',3,509,'pending'),(2527,'Security Policy Development',4,509,'pending'),(2528,'Data and Network Encryption',5,509,'pending'),(2529,'Leadership',1,510,'pending'),(2530,'Project Management',2,510,'pending'),(2531,'Teamwork and Collaboration',3,510,'pending'),(2532,'Conflict Resolution',4,510,'pending'),(2533,'Strategic Planning',5,510,'pending'),(2534,'IT Service Management',1,511,'pending'),(2535,'Strategic Planning',2,511,'pending'),(2536,'Budgeting',3,511,'pending'),(2537,'Vendor Management',4,511,'pending'),(2538,'Resource Allocation',5,511,'pending'),(2539,'Advanced Cloud Management',1,512,'pending'),(2540,'Advanced Infrastructure Automation',2,512,'pending'),(2541,'Performance Tuning',3,512,'pending'),(2542,'Advanced System Administration',4,512,'pending'),(2543,'Complex Problem Solving',5,512,'pending'),(2544,'Cloud Architecture',1,513,'pending'),(2545,'Cloud Migration',2,513,'pending'),(2546,'Cloud Security',3,513,'pending'),(2547,'Cloud Service Management',4,513,'pending'),(2548,'Cloud Cost Optimization',5,513,'pending');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills2`
--

DROP TABLE IF EXISTS `skills2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills2` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `step_id` bigint DEFAULT NULL,
  `skills` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `skills2_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `steps2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=442 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills2`
--

LOCK TABLES `skills2` WRITE;
/*!40000 ALTER TABLE `skills2` DISABLE KEYS */;
INSERT INTO `skills2` VALUES (291,69,'Basic design skills'),(292,69,'Adobe Creative Suite'),(293,69,'Creativity'),(294,69,'Communication'),(295,69,'Collaboration'),(296,70,'UI/UX design basics'),(297,70,'Figma'),(298,70,'Sketch'),(299,70,'User research'),(300,70,'Wireframing'),(301,72,'Self-management'),(302,72,'Client communication'),(303,72,'Flexibility'),(304,72,'Adobe Creative Suite'),(305,72,'Creativity'),(306,73,'Client relationship management'),(307,73,'Advanced design skills'),(308,73,'Time management'),(309,73,'Marketing'),(310,73,'Negotiation'),(311,74,'Advanced design skills'),(312,74,'Adobe Creative Suite'),(313,74,'UI/UX design'),(314,74,'Team collaboration'),(315,74,'Creativity'),(316,75,'Organizational skills'),(317,75,'Basic design skills'),(318,75,'Adobe Creative Suite'),(319,75,'Communication'),(320,75,'Attention to detail'),(321,76,'Communication'),(322,76,'Patience'),(323,76,'Teaching'),(324,76,'Design skills'),(325,76,'Adobe Creative Suite'),(326,78,'Digital design'),(327,78,'Adobe Creative Suite'),(328,78,'Creativity'),(329,78,'UI/UX design'),(330,78,'Web design tools'),(331,79,'Leadership'),(332,79,'Advanced digital design'),(333,79,'Project management'),(334,79,'UI/UX design'),(335,79,'Web design tools'),(336,80,'Advanced design skills'),(337,80,'Adobe Creative Suite'),(338,80,'UI/UX design'),(339,80,'Team collaboration'),(340,80,'Creativity'),(341,81,'Problem Solving'),(342,81,'Coding'),(343,81,'Algorithm Development'),(344,81,'Data Structures'),(345,81,'Software Design'),(346,82,'Teamwork'),(347,82,'Real-world Coding'),(348,82,'Project Management'),(349,82,'Software Development Lifecycle'),(350,83,'HTML'),(351,83,'CSS'),(352,83,'JavaScript'),(353,83,'Reactjs'),(354,83,'Nodejs'),(355,83,'Expressjs'),(356,83,'MongoDB'),(357,84,'Leadership'),(358,84,'Communication'),(359,84,'Mentoring'),(360,84,'Teaching'),(361,84,'Advanced Software Development'),(362,85,'React Native'),(363,85,'HTML'),(364,85,'CSS'),(365,85,'JavaScript'),(366,85,'Mobile UI/UX'),(367,86,'Security Protocols'),(368,86,'Cryptography'),(369,86,'Network Security'),(370,86,'Secure Coding'),(371,86,'Penetration Testing'),(372,88,'HTML'),(373,88,'CSS'),(374,88,'JavaScript'),(375,88,'Reactjs'),(376,88,'UI/UX Design'),(377,89,'Leadership'),(378,89,'Time Management'),(379,89,'Project Management'),(380,89,'Advanced Frontend Development'),(381,89,'Team Coordination'),(382,90,'Advanced Mobile Development'),(383,90,'Team Leadership'),(384,90,'Strategic Planning'),(385,90,'Project Management'),(386,90,'Problem Solving'),(387,91,'HTML'),(388,91,'CSS'),(389,91,'JavaScript'),(390,91,'React'),(391,91,'Git'),(392,92,'Illustrator'),(393,92,'Photoshop'),(394,92,'Sketch'),(395,92,'InVision'),(396,92,'Figma'),(397,94,'Angular'),(398,94,'Vue'),(399,94,'Webpack'),(400,94,'Redux'),(401,94,'Jest'),(402,95,'Design Patterns'),(403,95,'Performance Tuning'),(404,95,'Refactoring'),(405,95,'TypeScript'),(406,95,'Progressive Web Apps'),(407,96,'Leadership'),(408,96,'Project Management'),(409,96,'Agile'),(410,96,'Scrum'),(411,96,'Code Reviews'),(412,97,'Strategic Planning'),(413,97,'Business Acumen'),(414,97,'Resource Allocation'),(415,97,'Risk Management'),(416,97,'Negotiation'),(417,98,'HTML'),(418,98,'CSS'),(419,98,'JavaScript'),(420,98,'Node.js'),(421,98,'Express.js'),(422,99,'CI/CD'),(423,99,'AWS'),(424,99,'Docker'),(425,99,'Kubernetes'),(426,99,'Jenkins'),(427,101,'MongoDB'),(428,101,'GraphQL'),(429,101,'React'),(430,101,'Redux'),(431,101,'Webpack'),(432,102,'Leadership'),(433,102,'Project Management'),(434,102,'Agile'),(435,102,'Scrum'),(436,102,'Code Reviews'),(437,103,'Strategic Planning'),(438,103,'Business Acumen'),(439,103,'Resource Allocation'),(440,103,'Risk Management'),(441,103,'Negotiation');
/*!40000 ALTER TABLE `skills2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sort` tinyint NOT NULL,
  `path_id` bigint DEFAULT NULL,
  `status` enum('pending','completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `branch_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `fk_path_id` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`),
  CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=514 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps`
--

LOCK TABLES `steps` WRITE;
/*!40000 ALTER TABLE `steps` DISABLE KEYS */;
INSERT INTO `steps` VALUES (507,'DevOps Engineer','Managing and automating cloud infrastructure',1,3,'pending',18),(508,'Security Analyst','Analyzing and improving system security',1,3,'pending',19),(509,'Security Architect','Designing secure network and system infrastructure',2,3,'pending',19),(510,'Team Lead DevOps','Leading a team of DevOps engineers',1,3,'pending',20),(511,'Information Technology Manager','Managing IT services and teams',2,3,'pending',20),(512,'Senior DevOps Engineer','Handling complex DevOps projects and responsibilities',1,3,'pending',21),(513,'Cloud Solutions Architect','Designing and implementing cloud solutions',2,3,'pending',21);
/*!40000 ALTER TABLE `steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `steps2`
--

DROP TABLE IF EXISTS `steps2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps2` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `path_id` bigint DEFAULT NULL,
  `branch_no` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_optional` tinyint(1) DEFAULT NULL,
  `is_sub_branch` tinyint(1) DEFAULT NULL,
  `is_goal` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `steps2_ibfk_1` FOREIGN KEY (`path_id`) REFERENCES `path` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `steps2`
--

LOCK TABLES `steps2` WRITE;
/*!40000 ALTER TABLE `steps2` DISABLE KEYS */;
INSERT INTO `steps2` VALUES (69,3,1,'Junior Graphic Designer','Start your career as a junior graphic designer, focusing on improving your skills and gaining practical experience.',0,0,0,'2024-09-09 16:00:25'),(70,3,1,'UI/UX Design Intern','Gain experience with UI/UX design to enhance your skill set and broaden your career opportunities.',1,0,0,'2024-09-09 16:00:25'),(71,3,1,'Unknown Title','No description',0,0,0,'2024-09-09 16:00:25'),(72,3,1,'Freelance Graphic Designer','Take on freelance projects to explore different industries, improve your portfolio, and gain versatility in your design skills.',0,1,0,'2024-09-09 16:00:25'),(73,3,1,'Established Freelance Graphic Designer','Become a well-known freelance designer with a strong portfolio and a wide range of clients.',0,1,1,'2024-09-09 16:00:25'),(74,3,1,'Graphic Designer at Tassaract Corp Pvt Ltd','Join Tassaract Corp Pvt Ltd as a graphic designer, creating impactful designs and contributing to the company\'s brand identity.',0,0,1,'2024-09-09 16:00:25'),(75,3,2,'Design Assistant','Start as a design assistant to get a basic understanding of the industry and the process of design development.',0,0,0,'2024-09-09 16:00:25'),(76,3,2,'Design Educator','Share your knowledge and passion for design by teaching others, either one-on-one or in a classroom setting.',1,0,0,'2024-09-09 16:00:25'),(77,3,2,'Unknown Title','No description',0,0,0,'2024-09-09 16:00:25'),(78,3,2,'Digital Media Designer','Specialize in digital media design, creating visuals for digital platforms such as websites, apps, and social media.',0,1,0,'2024-09-09 16:00:25'),(79,3,2,'Senior Digital Media Designer','Become a senior designer, leading projects and guiding junior designers.',0,1,1,'2024-09-09 16:00:25'),(80,3,2,'Graphic Designer at Tassaract Corp Pvt Ltd','Join Tassaract Corp Pvt Ltd as a graphic designer, creating impactful designs and contributing to the company\'s brand identity.',0,0,1,'2024-09-09 16:00:25'),(81,1,1,'Software Engineering BS','Complete a Bachelor\'s degree in Software Engineering from a reputable university to gain foundational knowledge in software development.',0,0,0,'2024-09-09 16:02:42'),(82,1,1,'Internship','Gain practical experience in software development by doing internships and project work.',0,0,0,'2024-09-09 16:02:42'),(83,1,1,'Full Stack Developer (MERN)','Work as a Full Stack Developer focusing on MERN stack to build complex, user-centric applications.',0,0,0,'2024-09-09 16:02:42'),(84,1,1,'Lead Trainer (Model Application and API Development)','Become a Lead Trainer to share knowledge and skills, and help guide future software developers.',0,0,1,'2024-09-09 16:02:42'),(85,1,2,'Mobile Application Developer','Become a mobile application developer focusing on React Native to create various applications.',0,0,0,'2024-09-09 16:02:42'),(86,1,2,'Specialization in Cyber Security','Acquire specialization in Cyber Security to enhance secure coding practices and handle application security.',1,0,0,'2024-09-09 16:02:42'),(87,1,2,'Unknown Title','No description',0,0,0,'2024-09-09 16:02:42'),(88,1,2,'Frontend Developer','Work as a Frontend developer to create engaging, user-friendly interfaces for web and mobile applications.',0,1,0,'2024-09-09 16:02:42'),(89,1,2,'Frontend Team Lead','Become a team lead to manage a team of frontend developers, maintaining the quality and timely delivery of projects.',0,1,1,'2024-09-09 16:02:42'),(90,1,2,'Senior Mobile Application Developer','Become a senior mobile developer to handle more complex projects and lead mobile development teams.',0,0,1,'2024-09-09 16:02:42'),(91,2,1,'Junior Frontend Developer','Working with a team to design, develop, and maintain user interfaces.',0,0,0,'2024-09-09 16:05:50'),(92,2,1,'UX/UI Designer','Designing user interfaces and enhancing user experience for applications.',1,0,0,'2024-09-09 16:05:50'),(93,2,1,'Unknown Title','No description',0,0,0,'2024-09-09 16:05:50'),(94,2,1,'Senior Frontend Developer','Leading frontend development and managing junior frontend developers.',0,1,0,'2024-09-09 16:05:50'),(95,2,1,'Frontend Architect','Designing and implementing frontend architecture of applications.',1,1,0,'2024-09-09 16:05:50'),(96,2,1,'Frontend Team Lead','Leading a team of frontend developers and architects to accomplish project goals.',0,1,1,'2024-09-09 16:05:50'),(97,2,1,'CTO','Overseeing the technological needs of the company and developing policies and goals.',0,0,1,'2024-09-09 16:05:50'),(98,2,2,'Junior Full Stack Developer','Working with both frontend and backend programming languages to build software applications.',0,0,0,'2024-09-09 16:05:50'),(99,2,2,'DevOps Engineer','Working with developers and the IT staff to oversee code releases and deployments.',1,0,0,'2024-09-09 16:05:50'),(100,2,2,'Unknown Title','No description',0,0,0,'2024-09-09 16:05:50'),(101,2,2,'Senior Full Stack Developer','Leading software development and managing junior full stack developers.',0,1,0,'2024-09-09 16:05:50'),(102,2,2,'Full Stack Team Lead','Managing a team of full stack developers to accomplish project goals.',0,1,1,'2024-09-09 16:05:50'),(103,2,2,'CTO','Overseeing the technological needs of the company and developing policies and goals.',0,0,1,'2024-09-09 16:05:50');
/*!40000 ALTER TABLE `steps2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `valid_till` int DEFAULT NULL,
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
  `payment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_expiration` datetime DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_role` (`role_id`),
  CONSTRAINT `fk_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'hussain21x','hussain12@gmail.com','8b117546c9cdd79b2f88159fd94e1195623f7f8b53b54a2bb3b7675ecd834a93',NULL,NULL,NULL,NULL),(2,'faris21x','faris12@gmail.com','8a91dbf39a7d58400d17676648461e8d9895a7a48ea02e6a641de439b402a656',NULL,NULL,NULL,NULL),(3,'talha17x','talha@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL,NULL),(4,'aiman12','aiman@gmail.com','1a62b2b12c469335995cced03433260373e0b975344059e1a1fbdc66e6aca914',NULL,NULL,NULL,NULL),(5,'haris12','haris12@gmail.com','cffd26c9ddbb65b048a0f714b704a5ed9a5ad7a66130b7a43963899528a97928',NULL,NULL,NULL,NULL),(6,'test1','test12@gmail.com','c42bd77fb632be76f683bc427943fb3f848170dc33c14b7d5dc1b771db078c84',NULL,NULL,NULL,NULL),(7,'one71x','one@gmail.com','4d312d42968237ea5e754e39580b0f7fbb906dbf8608847310df370ed45828dd',NULL,NULL,NULL,NULL),(8,'syed71x','syed@gmail.com','73f72fcd6f1108782be74a62f817922edfc021a5d6a68513ec8aa9af4fad3b45',NULL,NULL,NULL,NULL),(9,'mustafa69x','mustafa@gmail.com','8e352b24effd2b624844f3d5d0fb2a0960903bf8aee759c2226a98993329c702',NULL,NULL,NULL,NULL),(10,'shayan71x','shayan@gmail.com','506c78e44f2184e46a6467bb17cf6b5937821be63a6170a8b8a07331b1660e13',NULL,NULL,NULL,NULL),(11,'Two69x$','two@gmail.com','2e1d7dfa4ca32532c7d453db04da86afcf38f0cc4008e1f577854b32c51115a7','https://images.pexels.com/photos/2310713/pexels-photo-2310713.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',NULL,NULL,NULL),(13,'hunain69x','hunain@gmail.com','840dc021cf333401c6b8f854939c7065058c6468843a37610071ded8569902b6',NULL,NULL,NULL,NULL),(14,'three12','three12@gmail.com','b7af263584bc6e827fa262dd8eb99d8bb3b1b43d045d3643acc8d975e49d30a3',NULL,NULL,NULL,NULL),(15,'hassan','hassan123@gmail.com','5c80b9535206b56dc8d78543de507d3e3fe08636dc6a9d12deb1dac0e7e5bb87',NULL,'gQXel3','2024-08-19 14:40:39',NULL),(19,'poka123','poka123@gmail.com','22306f9ad37b7be1e823c6a1ccbc2cb944e6c9962f8f9da5103dc3f70b622c77',NULL,NULL,NULL,NULL),(21,'anas71x','anas@gmail.com','5410327224be6b772e71705ef1c6e8f87d8d253754c56f1521f642cef16b3898',NULL,NULL,NULL,NULL),(22,'areeba12','areeba@gmail.com','8d080c78cd9eb424ad93536b6b4faf3e521661a1bab4068cdc5e902ac623651f',NULL,NULL,NULL,NULL),(23,'tassaract','tassaract@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL,NULL),(24,'tassaract1','tassaract1@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL,NULL),(27,'ahmed','ahmed@gmail.com','77a2e452cc950bddfa44fe8c61db107305166800b489adf97f31fad9e2ba72f6',NULL,NULL,NULL,NULL),(28,'Poka','hassanalirajput2004@gmail.com','f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd',NULL,NULL,NULL,NULL),(29,'talha_83x','pc16777.syedtalhahussain@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL,NULL),(30,'syed899x','syedtalha71x@gmail.com','ea045594007793a45a9d9a22d3dea1416603ad40bcb9fa0fae570e4cfdf5acd4',NULL,NULL,NULL,5),(31,'amna','amna@gmail.com','a24738c27f7a51a6079b03d7149a5c12e4608a356c4d17e316b71941d819c346',NULL,NULL,NULL,1),(32,'noor','noor@gmail.com','6913c81ff94fc68e7b04d1de8b226fcd528fcb3c939cacce6bb5859c7a6157b4',NULL,NULL,NULL,NULL),(33,'faizan_18x','faizan@gmail.com','49f606bc2b2239194f22b0f301ff6aec2860e636f5eed176e308f6fd2c55fcde',NULL,NULL,NULL,NULL),(34,'khan','khan@gmail.com','cad3fe7aae4d46b047d0164e64aed2b1a98b74bf45d0fc23be076005504bace6',NULL,NULL,NULL,NULL);
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

-- Dump completed on 2024-09-15 11:32:50
