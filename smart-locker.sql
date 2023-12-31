-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: localhost    Database: smart-locker
-- ------------------------------------------------------
-- Server version	8.0.18

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
-- Table structure for table `__efmigrationshistory`
--

DROP TABLE IF EXISTS `__efmigrationshistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ProductVersion` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__efmigrationshistory`
--

LOCK TABLES `__efmigrationshistory` WRITE;
/*!40000 ALTER TABLE `__efmigrationshistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `__efmigrationshistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `histories`
--

DROP TABLE IF EXISTS `histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `histories` (
  `history_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_send` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locker_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_time` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `end_time` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipper` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receiver` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `fk_histories_users_idx` (`user_send`),
  KEY `fk_histories_lockers_idx` (`locker_id`),
  CONSTRAINT `fk_histories_lockers_idx` FOREIGN KEY (`locker_id`) REFERENCES `lockers` (`locker_id`),
  CONSTRAINT `fk_histories_users_idx` FOREIGN KEY (`user_send`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `histories`
--

LOCK TABLES `histories` WRITE;
/*!40000 ALTER TABLE `histories` DISABLE KEYS */;
INSERT INTO `histories` VALUES ('899e91e0-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','06:00','07:00',NULL,NULL),('899eb141-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','07:00','08:00',NULL,NULL),('899ecbf5-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','08:00','09:00',NULL,NULL),('899ee5c9-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','09:00','10:00',NULL,NULL),('899f0257-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','10:00','11:00',NULL,NULL),('899f2664-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','11:00','12:00',NULL,NULL),('899f4bf2-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','12:00','13:00',NULL,NULL),('899f6ea6-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','13:00','14:00',NULL,NULL),('899f97ef-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','14:00','15:00',NULL,NULL),('899fcc10-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','15:00','16:00',NULL,NULL),('899ff2fe-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','16:00','17:00',NULL,NULL),('89a01254-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker1','17:00','18:00',NULL,NULL),('89a033cc-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','06:00','07:00',NULL,NULL),('89a05663-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','07:00','08:00',NULL,NULL),('89a093f6-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','08:00','09:00',NULL,NULL),('89a0b7cd-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','09:00','10:00',NULL,NULL),('89a10263-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','10:00','11:00',NULL,NULL),('89a137e8-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','11:00','12:00',NULL,NULL),('89a15ab6-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','12:00','13:00',NULL,NULL),('89a178ec-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','13:00','14:00',NULL,NULL),('89a1a1c1-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','14:00','15:00',NULL,NULL),('89a1c6bf-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','15:00','16:00',NULL,NULL),('89a1f1f4-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','16:00','17:00',NULL,NULL),('89a225c7-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker2','17:00','18:00',NULL,NULL),('89a24784-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','06:00','07:00',NULL,NULL),('89a272b5-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','07:00','08:00',NULL,NULL),('89a290fa-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','08:00','09:00',NULL,NULL),('89a2adac-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','09:00','10:00',NULL,NULL),('89a2c546-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','10:00','11:00',NULL,NULL),('89a2dccf-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','11:00','12:00',NULL,NULL),('89a2f882-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','12:00','13:00',NULL,NULL),('89a3119b-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','13:00','14:00',NULL,NULL),('89a32c24-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','14:00','15:00',NULL,NULL),('89a344fa-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','15:00','16:00',NULL,NULL),('89a35cbd-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','16:00','17:00',NULL,NULL),('89a374a8-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker3','17:00','18:00',NULL,NULL),('89a38d69-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','06:00','07:00',NULL,NULL),('89a3a921-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','07:00','08:00',NULL,NULL),('89a3c376-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','08:00','09:00',NULL,NULL),('89a3def2-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','09:00','10:00',NULL,NULL),('89a3f84f-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','10:00','11:00',NULL,NULL),('89a41196-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','11:00','12:00',NULL,NULL),('89a42a33-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','12:00','13:00',NULL,NULL),('89a44218-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','13:00','14:00',NULL,NULL),('89a4592d-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','14:00','15:00',NULL,NULL),('89a470c9-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','15:00','16:00',NULL,NULL),('89a488c7-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','16:00','17:00',NULL,NULL),('89a4a9a6-591c-11ee-bbd5-e8d8d1fd33e3',NULL,'Locker4','17:00','18:00',NULL,NULL);
/*!40000 ALTER TABLE `histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lockers`
--

DROP TABLE IF EXISTS `lockers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lockers` (
  `locker_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('on','off') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`locker_id`),
  UNIQUE KEY `locker_id_UNIQUE` (`locker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lockers`
--

LOCK TABLES `lockers` WRITE;
/*!40000 ALTER TABLE `lockers` DISABLE KEYS */;
INSERT INTO `lockers` VALUES ('Locker1','Location1','on'),('Locker2','Location1','off'),('Locker3','Location2','on'),('Locker4','Location2','on');
/*!40000 ALTER TABLE `lockers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otps`
--

DROP TABLE IF EXISTS `otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otps` (
  `otp_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `otp_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration_time` datetime NOT NULL,
  `user_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `locker_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`otp_id`),
  UNIQUE KEY `otp_id_UNIQUE` (`otp_id`),
  UNIQUE KEY `otp_code_UNIQUE` (`otp_code`),
  KEY `fk_otps_users_idx` (`user_id`),
  KEY `fk_otps_lockers_idx` (`locker_id`),
  CONSTRAINT `fk_otps_lockers_idx` FOREIGN KEY (`locker_id`) REFERENCES `lockers` (`locker_id`),
  CONSTRAINT `fk_otps_users_idx` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otps`
--

LOCK TABLES `otps` WRITE;
/*!40000 ALTER TABLE `otps` DISABLE KEYS */;
/*!40000 ALTER TABLE `otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_id_UNIQUE` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('1','Admin',NULL),('2','User',NULL),('3','Shipper',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mail` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  KEY `fk_users_roles_idx` (`role_id`),
  CONSTRAINT `fk_users_roles_idx` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('U001','ban cntt','haunguyen42195@gmail.com','12','2','abc'),('U002','Quản lí tòa nhà','nghiabongda2@gmail.com','123','2','abc'),('U003','nghia123','2051052090nghia@ou.edu.vn','1234','3','abc'),('U004','Ban CNTT','nghiabongda2@gmail.com','1','2','abc'),('U005','Hau123','2051052036hau@ou.edu.vn','12345','2','abc');
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

-- Dump completed on 2023-10-23 14:12:08
