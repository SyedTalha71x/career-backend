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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

-- Dump completed on 2024-08-22 17:02:16
