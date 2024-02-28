-- MySQL dump 10.13  Distrib 8.0.27, for Linux (x86_64)
--
-- Host: localhost    Database: Mangiare
-- ------------------------------------------------------
-- Server version	8.0.27-0ubuntu0.20.04.1

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
-- Table structure for table `Avaliacao`
--

DROP TABLE IF EXISTS `Avaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Avaliacao` (
  `IDAvaliacao` int NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(512) DEFAULT NULL,
  `Classificacao` int NOT NULL,
  `Data` datetime NOT NULL,
  `IDRestaurante` int NOT NULL,
  `IDUtilizador` int NOT NULL,
  PRIMARY KEY (`IDAvaliacao`),
  KEY `FK_AVALRestauranteID` (`IDRestaurante`),
  KEY `FK_AVALUtilizadorID` (`IDUtilizador`),
  CONSTRAINT `FK_AVALRestauranteID` FOREIGN KEY (`IDRestaurante`) REFERENCES `Restaurante` (`IDRestaurante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AVALUtilizadorID` FOREIGN KEY (`IDUtilizador`) REFERENCES `Utilizador` (`IDUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Avaliacao`
--

LOCK TABLES `Avaliacao` WRITE;
/*!40000 ALTER TABLE `Avaliacao` DISABLE KEYS */;
INSERT INTO `Avaliacao` VALUES (15,'sdfsdfasdfasdfaasdfdfas',7,'2022-01-17 00:00:00',7,8),(16,'asdasdasd',1,'2022-01-17 00:00:00',7,8),(17,'dasasddasdasasd',9,'2022-01-17 00:00:00',7,7);
/*!40000 ALTER TABLE `Avaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Favorito`
--

DROP TABLE IF EXISTS `Favorito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Favorito` (
  `IDFavorito` int NOT NULL AUTO_INCREMENT,
  `Data` datetime NOT NULL,
  `IDRestaurante` int NOT NULL,
  `IDUtilizador` int NOT NULL,
  PRIMARY KEY (`IDFavorito`),
  KEY `FK_UtilizadorID` (`IDUtilizador`),
  KEY `FK_RestauranteID` (`IDRestaurante`),
  CONSTRAINT `FK_RestauranteID` FOREIGN KEY (`IDRestaurante`) REFERENCES `Restaurante` (`IDRestaurante`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UtilizadorID` FOREIGN KEY (`IDUtilizador`) REFERENCES `Utilizador` (`IDUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorito`
--

LOCK TABLES `Favorito` WRITE;
/*!40000 ALTER TABLE `Favorito` DISABLE KEYS */;
/*!40000 ALTER TABLE `Favorito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Restaurante`
--

DROP TABLE IF EXISTS `Restaurante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Restaurante` (
  `IDRestaurante` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(64) NOT NULL,
  `Descricao` varchar(512) NOT NULL,
  `Ementa` varchar(8192) NOT NULL,
  `Horario` varchar(512) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  PRIMARY KEY (`IDRestaurante`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Restaurante`
--

LOCK TABLES `Restaurante` WRITE;
/*!40000 ALTER TABLE `Restaurante` DISABLE KEYS */;
INSERT INTO `Restaurante` VALUES (2,'Cantina UM','Cantina da Universidade do Minho','Frango','Segunda a Sexta das 12 às 14 e 19 às 21',41.561904,-8.397836),(4,'Speedy','Lindo demais','Ja sabes','Sempre aberto',41.56252961882725,-8.393104076385498),(6,'McDonald\'s','Fast Food','Hambúrgueres','8 às 20 todos os dias',41.55898129577299,-8.406622409820557),(7,'aaaaaa','ssssss','ddddddd','ffffff',41.55740776889781,-8.418102264404297),(8,'vvvffv','fvdfvdfvd','fvddfvvdf','fvdfvdvdf',41.560811676791154,-8.402352333068848),(12,'adssdadas','sdasdasda','sdasdasdads','asdasdasd',41.56183923639524,-8.421106338500977),(13,'a','a','a','a',5,5),(14,'a','a','a','a',5,5),(15,'a','a','a','a',5,5),(16,'a','a','a','a',5,5),(17,'a','a','a','a',5,5),(18,'a','a','a','a',5,5),(19,'a','a','a','a',5,5),(20,'a','a','a','a',5,5),(21,'a','a','a','a',5,5),(22,'a','a','a','a',5,5),(23,'a','a','a','a',5,5),(24,'a','a','a','a',5,5),(25,'a','a','a','a',5,5),(26,'a','a','a','a',5,5),(27,'a','a','a','a',5,5),(28,'a','a','a','a',5,5),(29,'a','a','a','a',5,5),(30,'a','a','a','a',5,5),(31,'a','a','a','a',5,5),(32,'a','a','a','a',5,5),(33,'a','a','a','a',5,5),(34,'a','a','a','a',5,5),(35,'a','a','a','a',5,5),(36,'a','a','a','a',5,5),(37,'a','a','a','a',5,5),(38,'a','a','a','a',5,5),(39,'a','a','a','a',5,5),(40,'a','a','a','a',5,5),(41,'a','a','a','a',5,5),(42,'a','a','a','a',5,5);
/*!40000 ALTER TABLE `Restaurante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utilizador`
--

DROP TABLE IF EXISTS `Utilizador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utilizador` (
  `IDUtilizador` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(32) NOT NULL,
  `Email` varchar(64) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `Latitude` double DEFAULT NULL,
  `Longitude` double DEFAULT NULL,
  PRIMARY KEY (`IDUtilizador`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utilizador`
--

LOCK TABLES `Utilizador` WRITE;
/*!40000 ALTER TABLE `Utilizador` DISABLE KEYS */;
INSERT INTO `Utilizador` VALUES (7,'ADMIN','a','a',NULL,NULL),(8,'b','b','b',NULL,NULL),(9,'oooooooo','oooo@ooo.com','oooooooo',NULL,NULL);
/*!40000 ALTER TABLE `Utilizador` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-20 11:09:48
