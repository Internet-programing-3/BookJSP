-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: internetproject
-- ------------------------------------------------------
-- Server version	8.0.21

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
-- Table structure for table `bestseller`
--

DROP TABLE IF EXISTS `bestseller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bestseller` (
  `bestSellerId` int NOT NULL,
  `bookId` int NOT NULL,
  `sales` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`bestSellerId`),
  KEY `bookId` (`bookId`),
  CONSTRAINT `bestseller_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bestseller`
--

LOCK TABLES `bestseller` WRITE;
/*!40000 ALTER TABLE `bestseller` DISABLE KEYS */;
/*!40000 ALTER TABLE `bestseller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `bookId` int NOT NULL,
  `bookName` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `writer` varchar(10) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `bookCtg` varchar(30) NOT NULL,
  `bookStatus` varchar(255) NOT NULL,
  `bookContent` text NOT NULL,
  `bookStock` int NOT NULL,
  `bookReview` text,
  `bookImg` varchar(255) DEFAULT NULL,
  `sales` int DEFAULT NULL,
  `reviewCount` int DEFAULT NULL,
  `registrationDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'위대한 개츠비',9000,'F.스콧 피츠제럴드','민음사','해외도서','판매중','미국 꿈에 관한 고전 소설',100,'아름답게 쓰여진 이야기','images/b001',NULL,NULL,'2023-12-12 11:18:24'),(2,'퓨처 셀프',19800,'벤저민 하디','상상스퀘어','국내도서','판매중','자기계발서',100,'이 책은 내 인생을 바꾼 걸작이다','images/b002',NULL,NULL,'2023-12-12 11:18:24'),(3,'그대들,  어떻게 살 것인가',12000,'요시노 겐자부로','양철북','국내도서','판매중','미야자키 하야오가 만든 영화,  그 원작의 향기. 100년 동안 사랑받아 온 인생론의 고전.',100,'책을 읽는 순간,  기억 속 배선에 앗,  하고 전기가 통하는 느낌이었다','images/b003',NULL,NULL,'2023-12-12 11:18:24'),(4,'2024 임용 면접레시피: 평가원 지역',25000,'류은진 외','미래가치','국내도서','판매중','임용고시',100,'지난 6년간 가장 많은 수험생이 선택한 임용면접책','images/b004',NULL,NULL,'2023-12-12 11:18:24'),(5,'마흔에 읽는 쇼펜하우어',17000,'강용수','유노북스','국내도서','판매중','마흔에 읽는 서양 고전',100,'마흔에게 필요한 철학 수업','images/b005',NULL,NULL,'2023-12-12 11:18:24'),(6,'어느 작가의 오후',16800,'F.스콧 피츠제럴드','인플루엔셜','국내도서','판매중','에세이',100,'소설가가 되기 전부터 나는 그의 작품을 사랑하고 부지런히 번역해왔다.','images/b006',NULL,NULL,'2023-12-12 11:18:24'),(7,'황금종이2',18500,'조정래','해냄출판사','국내도서','판매중','한글소설일반',100,'오늘날 가장 중요한 문제를 뼈아프게 직면시키는 소설','images/b007',NULL,NULL,'2023-12-12 11:18:24'),(8,'설자은,  금성으로 돌아오다',16800,'정세랑','문학동네','국내도서','판매중','설자은 시리즈1',100,'세상 어디에도 없는 황금의 도시에서 펼쳐지는 미스터리 대수사극','images/b008',NULL,NULL,'2023-12-12 11:18:24');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cartId` int NOT NULL,
  `bookId` int NOT NULL,
  `ctQty` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`cartId`),
  KEY `fk_cart_book` (`bookId`),
  KEY `userId` (`userId`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `user` (`userId`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`),
  CONSTRAINT `fk_cart_book` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cartitem`
--

DROP TABLE IF EXISTS `cartitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cartitem` (
  `cartItemId` int NOT NULL,
  `cartId` int NOT NULL,
  `bookId` int NOT NULL,
  `quantity` int NOT NULL,
  `price` int NOT NULL,
  PRIMARY KEY (`cartItemId`),
  KEY `cartId` (`cartId`),
  KEY `bookId` (`bookId`),
  CONSTRAINT `cartitem_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  CONSTRAINT `cartitem_ibfk_2` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartitem`
--

LOCK TABLES `cartitem` WRITE;
/*!40000 ALTER TABLE `cartitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `cartitem` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `orderInfo`;
CREATE TABLE orderInfo (
    ordNo INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    ordDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ordReceiver VARCHAR(20) NOT NULL,
    ordRcvAddress VARCHAR(255) NOT NULL,
    ordRcvPhone VARCHAR(20) NOT NULL,
    ordPay VARCHAR(20) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(userId)
);

DROP TABLE IF EXISTS `orderProduct`;
CREATE TABLE orderProduct (
    ordNo INT,
    bookId INT,
    ordQty INT NOT NULL,
    PRIMARY KEY (ordNo, bookId),
    FOREIGN KEY (ordNo) REFERENCES orderInfo(ordNo),
    FOREIGN KEY (bookId) REFERENCES Book(bookId)
);

--
-- Table structure for table `club`
--

DROP TABLE IF EXISTS `club`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club` (
  `clubId` int NOT NULL,
  `clubName` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`clubId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club`
--

LOCK TABLES `club` WRITE;
/*!40000 ALTER TABLE `club` DISABLE KEYS */;
/*!40000 ALTER TABLE `club` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clubcomment`
--

DROP TABLE IF EXISTS `clubcomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clubcomment` (
  `commentId` int NOT NULL,
  `content` text NOT NULL,
  `postId` int NOT NULL,
  `userId` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commentId`),
  KEY `postId` (`postId`),
  KEY `userId` (`userId`),
  CONSTRAINT `clubcomment_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `clubpost` (`postId`),
  CONSTRAINT `clubcomment_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clubcomment`
--

LOCK TABLES `clubcomment` WRITE;
/*!40000 ALTER TABLE `clubcomment` DISABLE KEYS */;
/*!40000 ALTER TABLE `clubcomment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clubpost`
--

DROP TABLE IF EXISTS `clubpost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clubpost` (
  `postId` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `userId` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `clubId` int NOT NULL,
  PRIMARY KEY (`postId`),
  KEY `userId` (`userId`),
  KEY `clubId` (`clubId`),
  CONSTRAINT `clubpost_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`),
  CONSTRAINT `clubpost_ibfk_2` FOREIGN KEY (`clubId`) REFERENCES `club` (`clubId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clubpost`
--

LOCK TABLES `clubpost` WRITE;
/*!40000 ALTER TABLE `clubpost` DISABLE KEYS */;
/*!40000 ALTER TABLE `clubpost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newrelease`
--

DROP TABLE IF EXISTS `newrelease`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newrelease` (
  `releaseId` int NOT NULL,
  `bookId` int NOT NULL,
  `releaseDate` date NOT NULL,
  PRIMARY KEY (`releaseId`),
  KEY `bookId` (`bookId`),
  CONSTRAINT `newrelease_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `book` (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newrelease`
--

LOCK TABLES `newrelease` WRITE;
/*!40000 ALTER TABLE `newrelease` DISABLE KEYS */;
/*!40000 ALTER TABLE `newrelease` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userId` int NOT NULL,
  `password` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `birth` date NOT NULL,
  `gender` char(1) NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (12312321,'123123123','123123','01012321232','123213@213213','2132-02-13','M'),(123123123,'123','123','010123123','123@123','2023-12-12','M');
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

-- Dump completed on 2023-12-16 21:08:04
