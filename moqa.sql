-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: moqa
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.13.10.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `content` text,
  `created` timestamp NULL DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  `viewed` int(11) DEFAULT '0',
  `vote_up` int(11) DEFAULT '0',
  `vote_down` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (7,'test',1,'good','2014-02-25 11:52:11','2014-02-25 09:19:15',0,0,0),(8,'test',1,'good','2014-01-07 09:38:04','2014-01-07 09:38:04',0,0,0),(9,'godo',0,'问题','2014-01-24 08:29:44','2014-01-24 08:29:44',0,0,0),(10,'good',2,'gob','2014-02-23 07:22:34','2014-02-23 07:22:34',0,0,0),(11,'',2,'','2014-02-23 08:07:04','2014-02-23 08:07:04',0,0,0),(12,'',2,'','2014-02-23 08:08:50','2014-02-23 08:08:50',0,0,0),(13,'',2,'','2014-02-23 08:09:22','2014-02-23 08:09:22',0,0,0),(14,'',2,'','2014-02-23 08:12:18','2014-02-23 08:12:18',0,0,0),(15,'',2,'','2014-02-23 08:13:24','2014-02-23 08:13:24',0,0,0),(16,'good',2,'test','2014-02-25 12:01:29','2014-02-25 12:01:29',NULL,NULL,NULL),(17,'now',2,'good question','2014-02-27 02:50:33','2014-02-27 02:50:33',NULL,NULL,NULL),(18,'good',2,'test','2014-02-27 03:07:23','2014-02-27 03:07:23',NULL,NULL,NULL),(19,'test',2,'too','2014-02-27 03:09:05','2014-02-27 03:09:05',NULL,NULL,NULL),(20,'good',2,'gd','2014-02-27 03:16:04','2014-02-27 03:16:04',NULL,NULL,NULL),(21,'good',2,'gd','2014-02-27 03:16:50','2014-02-27 03:16:50',NULL,NULL,NULL),(22,'good',2,'gd','2014-02-27 03:17:15','2014-02-27 03:17:15',NULL,NULL,NULL),(23,'good',2,'gd','2014-02-27 03:17:38','2014-02-27 03:17:38',NULL,NULL,NULL),(24,'test',2,'test','2014-02-27 03:22:36','2014-02-27 03:22:36',NULL,NULL,NULL);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'leetom','202cb962ac59075b964b07152d234b70','','0000-00-00 00:00:00'),(2,'test','098f6bcd4621d373cade4e832627b4f6','','0000-00-00 00:00:00'),(3,'tt','912ec803b2ce49e4a541068d495ab570','tgest@test.cn','2014-02-20 12:18:13');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-02-27 11:31:02
