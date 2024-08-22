-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: authentication
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `facebook_login`
--

DROP TABLE IF EXISTS `facebook_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facebook_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
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
  `google_id` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `profile_picture` text,
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
  `instagram_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
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
  `linkedin_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
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
  `outlook_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
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
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
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
  `payment_id` varchar(255) DEFAULT NULL,
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
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `otp_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'hussain21x','hussain12@gmail.com','8b117546c9cdd79b2f88159fd94e1195623f7f8b53b54a2bb3b7675ecd834a93',NULL,NULL,NULL),(2,'faris21x','faris12@gmail.com','8a91dbf39a7d58400d17676648461e8d9895a7a48ea02e6a641de439b402a656',NULL,NULL,NULL),(3,'talha17x','talha@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL),(4,'aiman12','aiman@gmail.com','1a62b2b12c469335995cced03433260373e0b975344059e1a1fbdc66e6aca914',NULL,NULL,NULL),(5,'haris12','haris12@gmail.com','cffd26c9ddbb65b048a0f714b704a5ed9a5ad7a66130b7a43963899528a97928',NULL,NULL,NULL),(6,'test1','test12@gmail.com','c42bd77fb632be76f683bc427943fb3f848170dc33c14b7d5dc1b771db078c84',NULL,NULL,NULL),(7,'one71x','one@gmail.com','4d312d42968237ea5e754e39580b0f7fbb906dbf8608847310df370ed45828dd',NULL,NULL,NULL),(8,'syed71x','syed@gmail.com','73f72fcd6f1108782be74a62f817922edfc021a5d6a68513ec8aa9af4fad3b45',NULL,NULL,NULL),(9,'mustafa69x','mustafa@gmail.com','8e352b24effd2b624844f3d5d0fb2a0960903bf8aee759c2226a98993329c702',NULL,NULL,NULL),(10,'shayan71x','shayan@gmail.com','506c78e44f2184e46a6467bb17cf6b5937821be63a6170a8b8a07331b1660e13',NULL,NULL,NULL),(11,'Two69x$','two@gmail.com','2e1d7dfa4ca32532c7d453db04da86afcf38f0cc4008e1f577854b32c51115a7','https://images.pexels.com/photos/2310713/pexels-photo-2310713.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',NULL,NULL),(13,'hunain69x','hunain@gmail.com','840dc021cf333401c6b8f854939c7065058c6468843a37610071ded8569902b6',NULL,NULL,NULL),(14,'three12','three12@gmail.com','b7af263584bc6e827fa262dd8eb99d8bb3b1b43d045d3643acc8d975e49d30a3',NULL,NULL,NULL),(15,'hassan','hassan123@gmail.com','5c80b9535206b56dc8d78543de507d3e3fe08636dc6a9d12deb1dac0e7e5bb87',NULL,'gQXel3','2024-08-19 14:40:39'),(19,'poka123','poka123@gmail.com','22306f9ad37b7be1e823c6a1ccbc2cb944e6c9962f8f9da5103dc3f70b622c77',NULL,NULL,NULL),(21,'anas71x','anas@gmail.com','5410327224be6b772e71705ef1c6e8f87d8d253754c56f1521f642cef16b3898',NULL,NULL,NULL),(22,'areeba12','areeba@gmail.com','8d080c78cd9eb424ad93536b6b4faf3e521661a1bab4068cdc5e902ac623651f',NULL,NULL,NULL),(23,'tassaract','tassaract@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL),(24,'tassaract1','tassaract1@gmail.com','e07c1b21783643c0a9b33e3e80fe7f275a4ea3c20b0c00b910fc91f6177e3039',NULL,NULL,NULL),(27,'ahmed','ahmed@gmail.com','77a2e452cc950bddfa44fe8c61db107305166800b489adf97f31fad9e2ba72f6',NULL,NULL,NULL),(28,'Poka','hassanalirajput2004@gmail.com','f24189059d64afc71e47e8f5aa90714023773477ee6bdacb15337148a6932acd',NULL,NULL,NULL),(29,'talha_83x','pc16777.syedtalhahussain@gmail.com','866d9540979b7e1b9686517bae7308eef0cb7c5217a3f49d5a0132190595b232',NULL,NULL,NULL),(30,'syed899x','syedtalha71x@gmail.com','ea045594007793a45a9d9a22d3dea1416603ad40bcb9fa0fae570e4cfdf5acd4',NULL,NULL,NULL);
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

-- Dump completed on 2024-08-22 17:29:44
