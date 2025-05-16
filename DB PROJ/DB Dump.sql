CREATE DATABASE  IF NOT EXISTS `albion` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `albion`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: albion
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
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `City_Name` varchar(13) NOT NULL,
  `CityID` int NOT NULL,
  PRIMARY KEY (`CityID`),
  UNIQUE KEY `City_Name_UNIQUE` (`City_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES ('Bridgewatch',5),('Fort Sterling',2),('Lymhurst',4),('Martlock',3),('Thetford',1);
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `Item_Name` varchar(30) NOT NULL,
  `ItemID` int NOT NULL,
  PRIMARY KEY (`ItemID`),
  UNIQUE KEY `Item_Name_UNIQUE` (`Item_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES ('Bean Seeds',9),('Copper Bar',2),('Copper Ore',1),('Novice Broadsword',5),('Novices Mule',10),('Novices Soldier Armor',7),('Novices Soldier Boots',8),('Novices Soldier Helmet',6),('Rugged Hide',3),('Stiff Leather',4);
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market`
--

DROP TABLE IF EXISTS `market`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market` (
  `ItemID` int NOT NULL,
  `CityID` int NOT NULL,
  `Price` int NOT NULL,
  UNIQUE KEY `ItemID` (`ItemID`,`CityID`),
  UNIQUE KEY `ItemID_2` (`ItemID`,`CityID`),
  UNIQUE KEY `ItemID_3` (`ItemID`,`CityID`),
  UNIQUE KEY `ItemID_4` (`ItemID`,`CityID`),
  UNIQUE KEY `ItemID_5` (`ItemID`,`CityID`),
  KEY `market_ibfk_2` (`CityID`),
  CONSTRAINT `market_ibfk_1` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `market_ibfk_2` FOREIGN KEY (`CityID`) REFERENCES `city` (`CityID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market`
--

LOCK TABLES `market` WRITE;
/*!40000 ALTER TABLE `market` DISABLE KEYS */;
INSERT INTO `market` VALUES (1,1,44),(1,2,38),(1,3,37),(1,4,69),(1,5,24),(2,1,26),(2,2,10),(2,3,12),(2,4,23),(2,5,21),(3,1,76),(3,2,77),(3,3,80),(3,4,68),(3,5,73),(4,1,35),(4,2,42),(4,3,48),(4,4,58),(4,5,73),(5,1,250),(5,2,229),(5,3,185),(5,4,317),(5,5,140),(6,1,115),(6,2,170),(6,3,144),(6,4,199),(6,5,237),(7,1,296),(7,2,451),(7,3,386),(7,4,147),(7,5,101),(8,1,167),(8,2,196),(8,3,217),(8,4,214),(8,5,269),(9,1,335),(9,2,342),(9,3,345),(9,4,303),(9,5,350),(10,1,682),(10,2,575),(10,3,657),(10,4,583),(10,5,747);
/*!40000 ALTER TABLE `market` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_log`
--

DROP TABLE IF EXISTS `market_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market_log` (
  `CityID` int NOT NULL,
  `ItemID` int NOT NULL,
  `New_Price` int NOT NULL,
  `Old_Price` int NOT NULL,
  `Change_Date` timestamp NOT NULL,
  KEY `CityID` (`CityID`),
  KEY `ItemID` (`ItemID`),
  CONSTRAINT `market_log_ibfk_1` FOREIGN KEY (`CityID`) REFERENCES `city` (`CityID`),
  CONSTRAINT `market_log_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `item` (`ItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_log`
--

LOCK TABLES `market_log` WRITE;
/*!40000 ALTER TABLE `market_log` DISABLE KEYS */;
INSERT INTO `market_log` VALUES (1,1,200,200,'2025-05-05 23:26:03'),(1,1,200,17,'2025-05-05 23:27:56'),(1,1,17,18,'2025-05-05 23:28:25'),(1,1,18,17,'2025-05-05 23:28:52'),(1,1,17,17,'2025-05-05 23:29:17'),(1,1,17,18,'2025-05-05 23:29:27'),(1,1,18,18,'2025-05-05 23:30:40'),(1,1,17,18,'2025-05-05 23:30:50'),(2,1,50,30,'2025-05-07 17:55:00'),(1,1,18,17,'2025-05-07 17:55:12'),(2,1,30,50,'2025-05-07 21:56:54');
/*!40000 ALTER TABLE `market_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe` (
  `Result_ItemID` int NOT NULL,
  `IngredientID` int NOT NULL,
  `Amount` int NOT NULL,
  KEY `recipe_ibfk_1` (`Result_ItemID`),
  KEY `recipe_ibfk_2` (`IngredientID`),
  CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`Result_ItemID`) REFERENCES `item` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `recipe_ibfk_2` FOREIGN KEY (`IngredientID`) REFERENCES `item` (`ItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe`
--

LOCK TABLES `recipe` WRITE;
/*!40000 ALTER TABLE `recipe` DISABLE KEYS */;
INSERT INTO `recipe` VALUES (2,1,1),(4,3,1),(5,2,16),(5,4,8),(6,2,8),(7,2,16),(8,2,8);
/*!40000 ALTER TABLE `recipe` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-16  2:45:46
