-- MySQL dump 10.13  Distrib 8.0.40, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: vocard
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `email_auth`
--

DROP TABLE IF EXISTS `email_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_auth` (
  `email` varchar(255) NOT NULL,
  `code` int NOT NULL COMMENT '이메일 인증',
  PRIMARY KEY (`email`),
  CONSTRAINT `email` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_books`
--

DROP TABLE IF EXISTS `term_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `language` varchar(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_days`
--

DROP TABLE IF EXISTS `term_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_days` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level_id` int NOT NULL,
  `day_number` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `level_id_idx` (`level_id`),
  CONSTRAINT `level_id` FOREIGN KEY (`level_id`) REFERENCES `term_levels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_detail_cn`
--

DROP TABLE IF EXISTS `term_detail_cn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_detail_cn` (
  `id` int NOT NULL AUTO_INCREMENT,
  `terms_id` int NOT NULL,
  `word` varchar(255) NOT NULL,
  `meaning` varchar(255) NOT NULL,
  `phonetic` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `terms_id_idx` (`terms_id`),
  CONSTRAINT `terms_id_cn` FOREIGN KEY (`terms_id`) REFERENCES `terms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_detail_en`
--

DROP TABLE IF EXISTS `term_detail_en`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_detail_en` (
  `id` int NOT NULL AUTO_INCREMENT,
  `terms_id` int NOT NULL,
  `word` varchar(255) NOT NULL,
  `meaning` varchar(255) NOT NULL,
  `part_of_speech` varchar(50) NOT NULL,
  `phonetic` varchar(255) NOT NULL,
  `example` text NOT NULL,
  `example_meaning` text NOT NULL,
  `synonym` varchar(255) DEFAULT NULL,
  `antonym` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `terms_id_idx` (`terms_id`),
  CONSTRAINT `terms_id` FOREIGN KEY (`terms_id`) REFERENCES `terms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_detail_jp_kanji`
--

DROP TABLE IF EXISTS `term_detail_jp_kanji`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_detail_jp_kanji` (
  `id` int NOT NULL AUTO_INCREMENT,
  `terms_id` int NOT NULL,
  `word` varchar(50) NOT NULL,
  `meaning` varchar(50) NOT NULL,
  `shape` varchar(255) DEFAULT NULL,
  `radical` varchar(255) DEFAULT NULL,
  `strokes` varchar(50) NOT NULL,
  `on_reading` varchar(255) DEFAULT NULL,
  `kun_reading` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `terms_id_idx` (`terms_id`),
  CONSTRAINT `terms_id_jp_kanji` FOREIGN KEY (`terms_id`) REFERENCES `terms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_detail_jp_voca`
--

DROP TABLE IF EXISTS `term_detail_jp_voca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_detail_jp_voca` (
  `id` int NOT NULL AUTO_INCREMENT,
  `terms_id` int NOT NULL,
  `word` varchar(255) NOT NULL,
  `meaning` varchar(255) NOT NULL,
  `yomigana` varchar(255) DEFAULT NULL,
  `example` text,
  PRIMARY KEY (`id`),
  KEY `terms_id_idx` (`terms_id`),
  CONSTRAINT `terms_id_jp_voca` FOREIGN KEY (`terms_id`) REFERENCES `terms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_levels`
--

DROP TABLE IF EXISTS `term_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_levels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `level` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `book_id_idx` (`book_id`),
  CONSTRAINT `book_id` FOREIGN KEY (`book_id`) REFERENCES `term_books` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_user_progress`
--

DROP TABLE IF EXISTS `term_user_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_user_progress` (
  `day_id` int NOT NULL,
  `email` varchar(255) NOT NULL,
  `review_count` int NOT NULL DEFAULT '0',
  `last_studied_at` varchar(16) NOT NULL,
  PRIMARY KEY (`day_id`,`email`),
  KEY `day_id_idx` (`day_id`),
  KEY `email_idx` (`email`),
  CONSTRAINT `day_id_progress` FOREIGN KEY (`day_id`) REFERENCES `term_days` (`id`),
  CONSTRAINT `email_progress` FOREIGN KEY (`email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `terms`
--

DROP TABLE IF EXISTS `terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `day_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `day_id_idx` (`day_id`),
  CONSTRAINT `day_id` FOREIGN KEY (`day_id`) REFERENCES `term_days` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `email` varchar(255) NOT NULL,
  `nickname` varchar(255) NOT NULL COMMENT '사용자 정보',
  `password` varchar(255) NOT NULL,
  `is_verified` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`email`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-03 22:46:02
