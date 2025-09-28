CREATE DATABASE  IF NOT EXISTS `elec_bill` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `elec_bill`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: elec_bill
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `State` varchar(21) DEFAULT NULL,
  `C_ID` int DEFAULT NULL,
  `CityID` int DEFAULT NULL,
  `AddressText` varchar(255) DEFAULT NULL,
  KEY `fk_address_customer` (`C_ID`),
  KEY `fk_address_city` (`CityID`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`CityID`) REFERENCES `city` (`CityID`),
  CONSTRAINT `fk_address_customer` FOREIGN KEY (`C_ID`) REFERENCES `customer` (`C_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `pass` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `B_ID` int NOT NULL,
  `BillDate` date NOT NULL,
  `DueDate` date NOT NULL,
  `UnitsUsed` int NOT NULL,
  `TotalAmt` decimal(10,2) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `C_ID` int DEFAULT NULL,
  `MeterID` int DEFAULT NULL,
  `UseID` int DEFAULT NULL,
  PRIMARY KEY (`B_ID`),
  KEY `C_ID` (`C_ID`),
  KEY `MeterID` (`MeterID`),
  KEY `fk_bill_usertype` (`UseID`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`C_ID`) REFERENCES `customer` (`C_ID`),
  CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`MeterID`) REFERENCES `meter` (`MeterID`),
  CONSTRAINT `fk_bill_usertype` FOREIGN KEY (`UseID`) REFERENCES `usertype` (`UseID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `CityID` int NOT NULL AUTO_INCREMENT,
  `CityName` varchar(50) NOT NULL,
  `StateID` int NOT NULL,
  PRIMARY KEY (`CityID`),
  KEY `StateID` (`StateID`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`StateID`) REFERENCES `state` (`StateID`)
) ENGINE=InnoDB AUTO_INCREMENT=1341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (1,'Visakhapatnam',1),(2,'Vijayawada',1),(3,'Guntur',1),(4,'Nellore',1),(5,'Rajamahendravaram',1),(6,'Kurnool',1),(7,'Kakinada',1),(8,'Kadapa',1),(9,'Tirupati',1),(10,'Mangalagiri–Tadepalli',1),(11,'Anantapuram',1),(12,'Ongole',1),(13,'Vizianagaram',1),(14,'Eluru',1),(15,'Proddatur',1),(16,'Nandyal',1),(17,'Adoni',1),(18,'Madanapalle',1),(19,'Machilipatnam',1),(20,'Tenali',1),(21,'Chittoor',1),(22,'Hindupur',1),(23,'Srikakulam',1),(24,'Bhimavaram',1),(25,'Tadepalligudem',1),(26,'Guntakal',1),(27,'Dharmavaram',1),(28,'Gudivada',1),(29,'Narasaraopet',1),(30,'Kadiri',1),(31,'Tadipatri',1),(32,'Chilakaluripet',1),(33,'Bordumsa',2),(34,'Bubang',2),(35,'Changlang (North and South)',2),(36,'Chopelling',2),(37,'Deban',2),(38,'Dharampur',2),(39,'Gandhigram',2),(40,'Jairampur',2),(41,'Kharsang',2),(42,'Khemiyong',2),(43,'Kherem Bisa',2),(44,'Kutum',2),(45,'Lallung',2),(46,'Manabhum',2),(47,'Manmao',2),(48,'Miao',2),(49,'Namchik',2),(50,'Namdang',2),(51,'Namphai',2),(52,'Nampong',2),(53,'Namtok',2),(54,'New Kamlao',2),(55,'New Mohang',2),(56,'Rajanagar',2),(57,'Rangfrah',2),(58,'Ranglom',2),(59,'Two-hat',2),(60,'Vijaynagar',2),(61,'Vijoypur',2),(62,'Yangkang',2),(63,'Alinye',2),(64,'Anelih',2),(65,'Anini',2),(66,'Etalin',2),(67,'Bameng',2),(68,'Bana',2),(69,'Chyangtajo',2),(70,'Khenewa',2),(71,'Lada',2),(72,'P.kessang',2),(73,'Palizi',2),(74,'Pipu-dipu',2),(75,'Seijosa',2),(76,'Seppa',2),(77,'Thrizino',2),(78,'Veo',2),(79,'Adipasi',2),(80,'Ayeng',2),(81,'Balek',2),(82,'Bilat',2),(83,'Boleng',2),(84,'Borguli',2),(85,'Dalbing',2),(86,'Damro',2),(87,'Debing',2),(88,'Gtc',2),(89,'Hill Top',2),(90,'Kebang',2),(91,'Korang',2),(92,'Koyu',2),(93,'Ledum',2),(94,'Mebo',2),(95,'Namsing',2),(96,'Nari',2),(97,'Ngopok',2),(98,'Oyan',2),(99,'Pangin',2),(100,'Pasighat',2),(101,'Rani',2),(102,'Renging',2),(103,'Riga',2),(104,'Yagrung',2),(105,'Mirem',2),(106,'Mikong',2),(107,'Debing',2),(108,'Miglung',2),(109,'Chambang',2),(110,'Damin',2),(111,'Hiya',2),(112,'Koloriang',2),(113,'Nyapin',2),(114,'Palin',2),(115,'Sangram',2),(116,'Sarli',2),(117,'Tali',2),(118,'Alubari[1]',2),(119,'Chakma',2),(120,'Changliang',2),(121,'Chowkham',2),(122,'Danglat',2),(123,'Gohaingaon',2),(124,'Innao',2),(125,'Jaipur',2),(126,'Kamlang Nagar',2),(127,'Kherem',2),(128,'Kumari Kachari',2),(129,'Kumsai',2),(130,'Lathao',2),(131,'Lohitpur',2),(132,'Loiliang',2),(133,'Mahadevpur',2),(134,'Manmao',2),(135,'Medo',2),(136,'Momong',2),(137,'Namsai',2),(138,'Nanam',2),(139,'Peyong',2),(140,'Podumani',2),(141,'Sunpura',2),(142,'Tafragram',2),(143,'Tezu',2),(144,'Tezu Covt.college',2),(145,'Tindolong',2),(146,'Udaipur',2),(147,'Wakro',2),(148,'Wingko',2),(149,'Yealing',2),(150,'Abango',2),(151,'Anupam',2),(152,'Bijari',2),(153,'Bolung',2),(154,'Bomjir',2),(155,'Dambuk',2),(156,'Desali',2),(157,'Elopa',2),(158,'Hunli',2),(159,'Iduli',2),(160,'Jia',2),(161,'Koranu',2),(162,'Kronli',2),(163,'Meka',2),(164,'Paglam',2),(165,'Parbuk',2),(166,'Roing',2),(167,'Santipur',2),(168,'Boasimla',2),(169,'Chimpu',2),(170,'Deed',2),(171,'Godak',2),(172,'Hija',2),(173,'Joram',2),(174,'Mengio',2),(175,'Old Ziro',2),(176,'Raga',2),(177,'Ranga Nadi Project',2),(178,'Talo',2),(179,'Yachuli',2),(180,'Yazali',2),(181,'Ziro',2),(182,'A P Sectt.',2),(183,'Arunachal University',2),(184,'Balijan',2),(185,'Banderdewa',2),(186,'Doimukh',2),(187,'Donyi-Polo',2),(188,'Hawa Camp',2),(189,'Itanagar',2),(190,'Kheel',2),(191,'Kimin',2),(192,'Kokila',2),(193,'Midpu',2),(194,'Model Village',2),(195,'Naharlagun',2),(196,'Nirjuli',2),(197,'Ram Krishna Mission',2),(198,'Saglee',2),(199,'Sonajuli',2),(200,'Vivek Vihar',2),(201,'Yupia',2),(202,'B.supply',2),(203,'Damteng',2),(204,'Gispu',2),(205,'Jang',2),(206,'Kitpi',2),(207,'Lhou',2),(208,'Lumberdung',2),(209,'Lumla',2),(210,'Mukto',2),(211,'Sakpret',2),(212,'Tawang',2),(213,'Temple Gompa',2),(214,'Thingbu',2),(215,'Zimithang',2),(216,'Borduria',2),(217,'Dadam',2),(218,'Deomali',2),(219,'Hukanjuri',2),(220,'K/nokno',2),(221,'Kaimai',2),(222,'Kanubari',2),(223,'Kapu',2),(224,'Khela',2),(225,'Kheti',2),(226,'Khonsa',2),(227,'Khonsa Basti',2),(228,'Khotnu',2),(229,'Lazu',2),(230,'Longding',2),(231,'Longfong',2),(232,'Minthong',2),(233,'Nampong',2),(234,'Namsang',2),(235,'Namsang Mukh',2),(236,'Narottam Nagar',2),(237,'Nginu',2),(238,'Niausa',2),(239,'Panchou',2),(240,'Senewa',2),(241,'Soha',2),(242,'Thinsa',2),(243,'Tissa',2),(244,'Tupi',2),(245,'Valley View',2),(246,'Wakka',2),(247,'Geku',2),(248,'Gelling',2),(249,'Karko',2),(250,'Mariyang',2),(251,'Migging',2),(252,'Shimong',2),(253,'Singa',2),(254,'Tuting',2),(255,'Yingkiong',2),(256,'Daporijo',2),(257,'Dumporijo',2),(258,'Giba',2),(259,'Lemiking',2),(260,'Lepajaring',2),(261,'Maro',2),(262,'Muri',2),(263,'Nacho',2),(264,'Sippi',2),(265,'Siyum',2),(266,'Tabarijo',2),(267,'Taksing',2),(268,'Taliha',2),(269,'Balemu',2),(270,'Bhalukpong',2),(271,'Bomdila',2),(272,'Dahung',2),(273,'Dedza',2),(274,'Dirang',2),(275,'Dirang Basti',2),(276,'Kalaktang',2),(277,'Khellong',2),(278,'Lish',2),(279,'Munna Camp',2),(280,'Nafra',2),(281,'Rupa',2),(282,'Salari',2),(283,'Sangti',2),(284,'Senge',2),(285,'Shergaon',2),(286,'Singchung',2),(287,'Tenga Market',2),(288,'Tenzingaon',2),(289,'Tippi',2),(290,'Along',2),(291,'Bagra',2),(292,'Bame',2),(293,'Basar',2),(294,'Bene',2),(295,'Dali',2),(296,'Darak',2),(297,'Daring',2),(298,'Darka',2),(299,'Garu',2),(300,'Gensi',2),(301,'Kambang',2),(302,'Kaying',2),(303,'Kombo',2),(304,'Likabali',2),(305,'Liromoba',2),(306,'Logum Jining',2),(307,'Mechuka',2),(308,'Monigong',2),(309,'Nikte',2),(310,'Payum',2),(311,'Rumgong',2),(312,'Tato',2),(313,'Tirbin',2),(314,'Vivek Nagar',2),(315,'Yoji Yora',2),(316,'Yomcha',2),(317,'Guwahati',3),(318,'Silchar',3),(319,'Dibrugarh',3),(320,'Jorhat',3),(321,'Nagaon',3),(322,'Tinsukia',3),(323,'Tezpur',3),(324,'Bongaigaon',3),(325,'Diphu',3),(326,'Dhubri',3),(327,'North Lakhimpur',3),(328,'Karimganj',3),(329,'Sivasagar',3),(330,'Goalpara',3),(331,'Barpeta Town',3),(332,'Golaghat',3),(333,'Haflong',3),(334,'Rangia',3),(335,'Mangaldai',3),(336,'Tangla',3),(337,'Lanka',3),(338,'Hojai',3),(339,'Barpeta Road',3),(340,'Kokrajhar',3),(341,'Hailakandi',3),(342,'Morigaon',3),(343,'Nalbari',3),(344,'Silapathar',3),(345,'Dhekiajuli',3),(346,'Dergaon',3),(347,'Sonari',3),(348,'Kharupetia',3),(349,'Nazira',3),(350,'Lakhipur',3),(351,'Patna',4),(352,'Bhagalpur',4),(353,'Gaya',4),(354,'Munger',4),(355,'Muzaffarpur',4),(356,'Purnia',4),(357,'Katihar',4),(358,'Bihar Sharif',4),(359,'Darbhanga',4),(360,'Arrah',4),(361,'Sasaram',4),(362,'Chhapra',4),(363,'Samastipur',4),(364,'Begusarai',4),(365,'Saharsa',4),(366,'Bettiah',4),(367,'Motihari',4),(368,'Hajipur',4),(369,'Siwan',4),(370,'Sitamarhi',4),(371,'Raipur',5),(372,'Bhilai',5),(373,'Bilaspur',5),(374,'Korba',5),(375,'Rajnandgaon',5),(376,'Raigarh',5),(377,'Jagdalpur',5),(378,'Ambikapur',5),(379,'Chirmiri',5),(380,'Dhamtari',5),(381,'Mahasamund',5),(396,'Panji',6),(397,'Vasco da Gama',6),(398,'Margao',6),(399,'Mapusa',6),(400,'Mormugao',6),(401,'Ponda',6),(402,'Curchorem',6),(403,'Cuncolim',6),(404,'Canacona',6),(405,'Bicholim',6),(406,'Sanquelim',6),(407,'Valpoi',6),(408,'Quepem',6),(409,'Sanguem',6),(410,'Ahmedabad',7),(411,'Surat',7),(412,'Vadodara',7),(413,'Rajkot',7),(414,'Bhavnagar',7),(415,'Jamnagar',7),(416,'Junagadh',7),(417,'Gandhinagar',7),(418,'Anand',7),(419,'Navsari',7),(420,'Surendranagar',7),(421,'Morbi',7),(422,'Gandhidham',7),(423,'Nadiad',7),(424,'Bharuch',7),(425,'Patan',7),(426,'Porbandar',7),(427,'Mehsana',7),(428,'Bhuj',7),(429,'Veraval',7),(430,'Vapi',7),(431,'Valsad',7),(432,'Godhra',7),(433,'Palanpur',7),(434,'Himmatnagar',7),(435,'Kalol',7),(436,'Botad',7),(437,'Amreli',7),(438,'Gondal',7),(439,'Jetpur',7),(440,'Deesa',7),(441,'Faridabad',8),(442,'Gurugram',8),(443,'Rohtak',8),(444,'Hisar',8),(445,'Panipat',8),(446,'Karnal',8),(447,'Sonipat',8),(448,'Yamunanagar',8),(449,'Panchkula',8),(450,'Sirsa',8),(451,'Ambala',8),(452,'Bhiwani',8),(453,'Bahadurgarh',8),(454,'Jind',8),(455,'Thanesar',8),(456,'Kaithal',8),(457,'Rewari',8),(458,'Palwal',8),(459,'Shimla',9),(460,'Dharamsala',9),(461,'Solan',9),(462,'Mandi',9),(463,'Palampur',9),(464,'Baddi',9),(465,'Nahan',9),(466,'Paonta Sahib',9),(467,'Sundarnagar',9),(468,'Chamba',9),(469,'Una',9),(470,'Kullu',9),(471,'Hamirpur',9),(472,'Bilaspur',9),(473,'Yol Cantonment',9),(474,'Nalagarh',9),(475,'Nurpur',9),(476,'Kangra',9),(477,'Baijnath Paprola',9),(478,'Santokhgarh',9),(479,'Mehatpur Basdehra',9),(480,'Shamshi',9),(481,'Parwanoo',9),(482,'Manali',9),(483,'Tira Sujanpur',9),(484,'Ghumarwin',9),(485,'Dalhousie',9),(486,'Rohru',9),(487,'Nagrota Bagwan',9),(488,'Rampur',9),(489,'Jawalamukhi',9),(490,'Jogindernagar',9),(491,'Dera Gopipur',9),(492,'Sarkaghat',9),(493,'Jhakhri',9),(494,'Indora',9),(495,'Bhuntar',9),(496,'Nadaun',9),(497,'Theog',9),(498,'Kasauli Cantonment',9),(499,'Gagret',9),(500,'Chuari Khas',9),(501,'Daulatpur',9),(502,'Sabathu Cantonment',9),(503,'Dalhousie Cantonment',9),(504,'Rajgarh',9),(505,'Arki',9),(506,'Dagshai Cantonment',9),(507,'Seoni',9),(508,'Talai',9),(509,'Jutogh Cantonment',9),(510,'Chaupal',9),(511,'Rewalsar',9),(512,'Bakloh Cantonment',9),(513,'Jubbal',9),(514,'Bhota',9),(515,'Banjar',9),(516,'Bharmour',9),(517,'Naina Devi',9),(518,'Narkanda',9),(519,'Jamshedpur',10),(520,'Dhanbad',10),(521,'Ranchi',10),(522,'Bokaro Steel City',10),(523,'Deoghar',10),(524,'Phusro',10),(525,'Hazaribagh',10),(526,'Giridih',10),(527,'Ramgarh',10),(528,'Medininagar',10),(529,'Chirkunda',10),(530,'Bengaluru',11),(531,'Mysuru',11),(532,'Hubli–Dharwad',11),(533,'Kalaburagi',11),(534,'Mangaluru',11),(535,'Belagavi',11),(536,'Davanagere',11),(537,'Ballari',11),(538,'Vijayapura',11),(539,'Shimoga',11),(540,'Tumkur',11),(541,'Raichur',11),(542,'Bidar',11),(543,'Udupi',11),(544,'Hospet',11),(545,'Gadag-Betageri',11),(546,'Robertsonpet',11),(547,'Hassan',11),(548,'Bhadravati',11),(549,'Chitradurga',11),(550,'Kolar',11),(551,'Mandya',11),(552,'Chikmagalur',11),(553,'Gangavati',11),(554,'Bagalkot',11),(555,'Ranebennuru',11),(556,'Arsikere',11),(557,'Thiruvananthapuram',12),(558,'Kozhikode',12),(559,'Kochi',12),(560,'Kollam',12),(561,'Thrissur',12),(562,'Kannur',12),(563,'Alappuzha',12),(564,'Kottayam',12),(565,'Palakkad',12),(566,'Manjeri',12),(567,'Thalassery',12),(568,'Thrippunithura',12),(569,'Ponnani',12),(570,'Vatakara',12),(571,'Kanhangad',12),(572,'Payyanur',12),(573,'Koyilandy',12),(574,'Parappanangadi',12),(575,'Kalamassery',12),(576,'Kodungallur',12),(577,'Neyyattinkara',12),(578,'Tanur',12),(579,'Kayamkulam',12),(580,'Malappuram',12),(581,'Changanassery',12),(582,'Muvattupuzha',12),(583,'Punalur',12),(584,'Irinjalakuda',12),(585,'Kottarakkara',12),(586,'Perumbavoor',12),(587,'Changanassery',12),(588,'Koyilandy',12),(589,'Kunnamkulam',12),(590,'Kollam',12),(591,'Kottayam',12),(592,'Palakkad',12),(593,'Manjeri',12),(594,'Thalassery',12),(595,'Thrippunithura',12),(596,'Ponnani',12),(597,'Vatakara',12),(598,'Kanhangad',12),(599,'Payyanur',12),(600,'Koyilandy',12),(601,'Parappanangadi',12),(602,'Kalamassery',12),(603,'Kodungallur',12),(604,'Neyyattinkara',12),(605,'Tanur',12),(606,'Kayamkulam',12),(607,'Malappuram',12),(608,'Changanassery',12),(609,'Muvattupuzha',12),(610,'Punalur',12),(611,'Irinjalakuda',12),(612,'Kottarakkara',12),(613,'Perumbavoor',12),(614,'Changanassery',12),(615,'Koyilandy',12),(616,'Kunnamkulam',12),(617,'Kollam',12),(618,'Kottayam',12),(619,'Palakkad',12),(620,'Manjeri',12),(621,'Thalassery',12),(622,'Thrippunithura',12),(623,'Ponnani',12),(624,'Vatakara',12),(625,'Kanhangad',12),(626,'Payyanur',12),(627,'Koyilandy',12),(628,'Parappanangadi',12),(629,'Kalamassery',12),(630,'Kodungallur',12),(631,'Neyyattinkara',12),(632,'Tanur',12),(633,'Kayamkulam',12),(634,'Malappuram',12),(635,'Changanassery',12),(636,'Muvattupuzha',12),(637,'Punalur',12),(638,'Irinjalakuda',12),(639,'Kottarakkara',12),(640,'Perumbavoor',12),(641,'Changanassery',12),(642,'Koyilandy',12),(643,'Kunnamkulam',12),(644,'Kollam',12),(645,'Kottayam',12),(646,'Palakkad',12),(647,'Manjeri',12),(648,'Thalassery',12),(649,'Thrippunithura',12),(650,'Ponnani',12),(651,'Vatakara',12),(652,'Kanhangad',12),(653,'Payyanur',12),(654,'Koyilandy',12),(655,'Parappanangadi',12),(656,'Kalamassery',12),(657,'Kodungallur',12),(658,'Neyyattinkara',12),(659,'Tanur',12),(660,'Kayamkulam',12),(661,'Malappuram',12),(662,'Changanassery',12),(663,'Muvattupuzha',12),(664,'Punalur',12),(665,'Irinjalakuda',12),(666,'Kottarakkara',12),(667,'Perumbavoor',12),(668,'Changanassery',12),(669,'Koyilandy',12),(670,'Kunnamkulam',12),(671,'Kollam',12),(672,'Kottayam',12),(673,'Palakkad',12),(674,'Manjeri',12),(675,'Thalassery',12),(676,'Thrippunithura',12),(677,'Ponnani',12),(678,'Vatakara',12),(679,'Kanhangad',12),(680,'Payyanur',12),(681,'Koyilandy',12),(682,'Parappanangadi',12),(683,'Kalamassery',12),(684,'Kodungallur',12),(685,'Neyyattinkara',12),(686,'Tanur',12),(687,'Kayamkulam',12),(688,'Malappuram',12),(689,'Changanassery',12),(690,'Muvattupuzha',12),(691,'Punalur',12),(692,'Irinjalakuda',12),(693,'Kottarakkara',12),(694,'Perumbavoor',12),(695,'Changanassery',12),(696,'Koyilandy',12),(697,'Kunnamkulam',12),(698,'Kollam',12),(699,'Kottayam',12),(700,'Palakkad',12),(701,'Manjeri',12),(702,'Thalassery',12),(703,'Thrippunithura',12),(704,'Ponnani',12),(705,'Vatakara',12),(706,'Kanhangad',12),(707,'Payyanur',12),(708,'Koyilandy',12),(709,'Parappanangadi',12),(710,'Kalamassery',12),(711,'Kodungallur',12),(712,'Neyyattinkara',12),(713,'Tanur',12),(714,'Kayamkulam',12),(715,'Malappuram',12),(716,'Changanassery',12),(717,'Muvattupuzha',12),(718,'Punalur',12),(719,'Irinjalakuda',12),(720,'Kottarakkara',12),(721,'Perumbavoor',12),(722,'Changanassery',12),(723,'Indore',13),(724,'Bhopal',13),(725,'Jabalpur',13),(726,'Gwalior',13),(727,'Ujjain',13),(728,'Sagar',13),(729,'Dewas',13),(730,'Satna',13),(731,'Ratlam',13),(732,'Rewa',13),(733,'Katni',13),(734,'Singrauli',13),(735,'Burhanpur',13),(736,'Khandwa',13),(737,'Morena',13),(738,'Bhind',13),(739,'Guna',13),(740,'Shivpuri',13),(741,'Chhindwara',13),(742,'Vidisha',13),(743,'Chhatarpur',13),(744,'Mandsaur',13),(745,'Damoh',13),(746,'Neemach',13),(747,'Pithampur',13),(748,'Narmadapuram',13),(749,'Khargone',13),(750,'Itarsi',13),(751,'Sehore',13),(752,'Betul',13),(753,'Seoni',13),(754,'Datia',13),(755,'Nagda',13),(756,'Shajapur',13),(757,'Mumbai',14),(758,'Pune',14),(759,'Nagpur',14),(760,'Thane',14),(761,'Pimpri-Chinchwad',14),(762,'Nashik',14),(763,'Kalyan-Dombivli',14),(764,'Vasai-Virar',14),(765,'Aurangabad',14),(766,'Navi Mumbai',14),(767,'Solapur',14),(768,'Mira-Bhayandar',14),(769,'Bhiwandi-Nizampur',14),(770,'Amravati',14),(771,'Nanded-Waghala',14),(772,'Kolhapur',14),(773,'Ulhasnagar',14),(774,'Sangli',14),(775,'Malegaon',14),(776,'Jalgaon',14),(777,'Akola',14),(778,'Latur',14),(779,'Dhule',14),(780,'Ahmednagar',14),(781,'Chandrapur',14),(782,'Parbhani',14),(783,'Ichalkaranji',14),(784,'Jalna',14),(785,'Ambarnath',14),(786,'Bhusawal',14),(787,'Panvel',14),(788,'Badlapur',14),(789,'Beed',14),(790,'Gondia',14),(791,'Satara',14),(792,'Barshi',14),(793,'Yavatmal',14),(794,'Achalpur',14),(795,'Osmanabad',14),(796,'Nandurbar',14),(797,'Imphal',15),(798,'Kakching',15),(799,'Mayang Imphal',15),(800,'Thoubal',15),(801,'Ukhrul',15),(802,'Lilong',15),(803,'Ningthoukhong',15),(804,'Moreh',15),(805,'Moirang',15),(806,'Nambol',15),(807,'Samurou',15),(808,'Porompat',15),(809,'Rengkai',15),(810,'Sagolband',15),(811,'Sekmai Bazar',15),(812,'Sugnu',15),(813,'Thongju',15),(814,'Thongkhong Laxmi Bazar',15),(815,'Wangjing',15),(816,'Wangoi',15),(817,'Yairipok',15),(818,'Churachandpur',15),(819,'Bishnupur',15),(820,'Senapati',15),(821,'Tamenglong',15),(822,'Kangpokpi',15),(823,'Kamjong',15),(824,'Jiribam',15),(825,'Baghmara',16),(826,'Cherrapunjee',16),(827,'Jowai',16),(828,'Lawsohtun',16),(829,'Madanriting',16),(830,'Mairang',16),(831,'Mawlai',16),(832,'Mawpat',16),(833,'Nongkseh',16),(834,'Nongmynsong',16),(835,'Nongpoh',16),(836,'Nongstoin',16),(837,'Nongthymmai',16),(838,'Pynthormukhrah',16),(839,'Resubelpara',16),(840,'Shillong',16),(841,'Shillong Cantonment',16),(842,'Tura',16),(843,'Umlyngka',16),(844,'Umpling',16),(845,'Umroi',16),(846,'Williamnagar',16),(847,'Aizawl',17),(848,'Bairabi',17),(849,'Biate',17),(850,'Champhai',17),(851,'Darlawn',17),(852,'Hnahthial',17),(853,'Khawhai',17),(854,'Khawzawl',17),(855,'Kolasib',17),(856,'Lawngtlai',17),(857,'Lengpui',17),(858,'Lunglei',17),(859,'Mamit',17),(860,'N. Kawnpui',17),(861,'North Vanlaiphai',17),(862,'Saiha',17),(863,'Sairang',17),(864,'Saitual',17),(865,'Serchhip',17),(866,'Thenzawl',17),(867,'Tlabung',17),(868,'Vairengte',17),(869,'Zawlnuam',17),(870,'Changtongya',18),(871,'Chumukedima',18),(872,'Dimapur',18),(873,'Diphupar \'A\'',18),(874,'Jalukie',18),(875,'Kiphire',18),(876,'Kohima',18),(877,'Kohima Village',18),(878,'Kuda',18),(879,'Longleng',18),(880,'Medziphema',18),(881,'Mokokchung',18),(882,'Mon Town',18),(883,'Naginimora',18),(884,'Peren',18),(885,'Pfutsero',18),(886,'Phek',18),(887,'Puranabazar \'A\'',18),(888,'Rangapahar',18),(889,'Satakha Hq.',18),(890,'Tseminyu',18),(891,'Tsudikong (13th Mile Tuli Paper Mill)',18),(892,'Tuensang',18),(893,'Tuli',18),(894,'Wokha',18),(895,'Zunheboto',18),(896,'Changtongya',18),(897,'Bhubaneswar',19),(898,'Cuttack',19),(899,'Rourkela',19),(900,'Berhampur',19),(901,'Sambalpur',19),(902,'Puri',19),(903,'Balasore',19),(904,'Baripada',19),(905,'Bhadrak',19),(906,'Ludhiana',20),(907,'Amritsar',20),(908,'Jalandhar',20),(909,'Patiala',20),(910,'Bathinda',20),(911,'Mohali',20),(912,'Moga',20),(913,'Batala',20),(914,'Pathankot',20),(915,'Firozpur',20),(916,'Abohar',20),(917,'Malerkotla',20),(918,'Khanna',20),(919,'Phagwara',20),(920,'Kapurthala',20),(921,'Rajpura',20),(922,'Hoshiarpur',20),(923,'Muktsar',20),(924,'Faridkot',20),(925,'Barnala',20),(926,'Jaipur',21),(927,'Jodhpur',21),(928,'Kota',21),(929,'Bikaner',21),(930,'Bhiwadi',21),(931,'Udaipur',21),(932,'Ajmer',21),(933,'Bhilwara',21),(934,'Alwar',21),(935,'Sikar',21),(936,'Bharatpur',21),(937,'Pali',21),(938,'Sri Ganganagar',21),(939,'Beawar',21),(940,'Baran',21),(941,'Dhaulpur',21),(942,'Tonk',21),(943,'Kishangarh',21),(944,'Hanumangarh',21),(945,'Gangtok',22),(946,'Mangan',22),(947,'Namchi',22),(948,'Gyalshing',22),(949,'Pakyong',22),(950,'Soreng',22),(951,'Chennai',23),(952,'Coimbatore',23),(953,'Madurai',23),(954,'Tiruchirappalli',23),(955,'Salem',23),(956,'Ambattur',23),(957,'Tirunelveli',23),(958,'Tiruppur',23),(959,'Avadi',23),(960,'Tiruvottiyur',23),(961,'Thoothukkudi',23),(962,'Nagercoil',23),(963,'Thanjavur',23),(964,'Pallavaram',23),(965,'Dindigul',23),(966,'Vellore',23),(967,'Tambaram',23),(968,'Cuddalore',23),(969,'Kancheepuram',23),(970,'Alandur',23),(971,'Erode',23),(972,'Tiruvannamalai',23),(973,'Kumbakonam',23),(974,'Rajapalayam',23),(975,'Kurichi',23),(976,'Madavaram',23),(977,'Pudukkottai',23),(978,'Hosur',23),(979,'Ambur',23),(980,'Karaikkudi',23),(981,'Neyveli',23),(982,'Nagapattinam',23),(983,'Hyderabad',24),(984,'Warangal',24),(985,'Karimnagar',24),(986,'Nizamabad',24),(987,'Khammam',24),(988,'Mahabubnagar',24),(989,'Ramagundam',24),(990,'Mancherial',24),(991,'Nalgonda',24),(992,'Adilabad',24),(993,'Suryapet',24),(994,'Miryalaguda',24),(995,'Siddipet',24),(996,'Jagtial',24),(997,'Nirmal',24),(998,'Sircilla',24),(999,'Kamareddy',24),(1000,'Palwancha',24),(1001,'Kothagudem',24),(1002,'Bodhan',24),(1003,'Sangareddy',24),(1004,'Metpally',24),(1005,'Zahirabad',24),(1006,'Meerpet–Jillelguda',24),(1007,'Korutla',24),(1008,'Tandur',24),(1009,'Badangpet',24),(1010,'Kodad',24),(1011,'Armoor',24),(1012,'Gadwal',24),(1013,'Wanaparthy',24),(1014,'Kagaznagar',24),(1015,'Bellampalle',24),(1016,'Khanapuram Haveli',24),(1017,'Bhuvanagiri',24),(1018,'Vikarabad',24),(1019,'Mahabubabad',24),(1020,'Jangaon',24),(1021,'Mandamarri',24),(1022,'Peerzadiguda',24),(1023,'Badepally',24),(1024,'Bhadrachalam',24),(1025,'Bhainsa',24),(1026,'Boduppal',24),(1027,'Jawaharnagar',24),(1028,'Medak',24),(1029,'Shamshabad',24),(1030,'Bhupalpally',24),(1031,'Narayanpet',24),(1032,'Peddapalli',24),(1033,'Dundigal',24),(1034,'Huzurnagar',24),(1035,'Medchal',24),(1036,'Bandlaguda Jagir',24),(1037,'Kyathanpally',24),(1038,'Manuguru',24),(1039,'Naspur',24),(1040,'Narsampet',24),(1041,'Devarakonda',24),(1042,'Dubbaka',24),(1043,'Nakrekal',24),(1044,'Banswada',24),(1045,'Kalwakurthy',24),(1046,'Nagar Kurnool',24),(1047,'Parigi',24),(1048,'Thumkunta',24),(1049,'Neredcherla',24),(1050,'Luxettipet',24),(1051,'Aiza',24),(1052,'Nagaram',24),(1053,'Gajwel',24),(1054,'Chennur',24),(1055,'Asifabad',24),(1056,'Madhira',24),(1057,'Ghatkesar',24),(1058,'Kompally',24),(1059,'Dasnapur',24),(1060,'Sarapaka',24),(1061,'Husnabad',24),(1062,'Pocharam',24),(1063,'Dammaiguda',24),(1064,'Achampet',24),(1065,'Thorur',24),(1066,'Utnoor',24),(1067,'Bhoothpur',24),(1068,'Agartala',25),(1069,'Dharmanagar',25),(1070,'Udaipur',25),(1071,'Kailashahar',25),(1072,'Bishalgarh',25),(1073,'Teliamura',25),(1074,'Khowai',25),(1075,'Belonia',25),(1076,'Melaghar',25),(1077,'Mohanpur',25),(1078,'Ambassa',25),(1079,'Ranirbazar',25),(1080,'Santirbazar',25),(1081,'Kumarghat',25),(1082,'Sonamura',25),(1083,'Panisagar',25),(1084,'Amarpur',25),(1085,'Jirania',25),(1086,'Kamalpur',25),(1087,'Sabroom',25),(1088,'Kanpur',26),(1089,'Lucknow',26),(1090,'Ghaziabad',26),(1091,'Agra',26),(1092,'Meerut',26),(1093,'Varanasi',26),(1094,'Prayagraj',26),(1095,'Bareilly',26),(1096,'Aligarh',26),(1097,'Moradabad',26),(1098,'Saharanpur',26),(1099,'Gorakhpur',26),(1100,'Noida',26),(1101,'Firozabad',26),(1102,'Jhansi',26),(1103,'Muzaffarnagar',26),(1104,'Mathura-Vrindavan',26),(1105,'Budaun',26),(1106,'Rampur',26),(1107,'Shahjahanpur',26),(1108,'Farrukhabad-Fatehgarh',26),(1109,'Ayodhya',26),(1110,'Maunath Bhanjan',26),(1111,'Hapur',26),(1112,'Etawah',26),(1113,'Mirzapur-Vindhyachal',26),(1114,'Bulandshahr',26),(1115,'Sambhal',26),(1116,'Amroha',26),(1117,'Hardoi',26),(1118,'Fatehpur',26),(1119,'Raebareli',26),(1120,'Orai',26),(1121,'Sitapur',26),(1122,'Bahraich',26),(1123,'Modinagar',26),(1124,'Unnao',26),(1125,'Jaunpur',26),(1126,'Lakhimpur',26),(1127,'Hathras',26),(1128,'Banda',26),(1129,'Pilibhit',26),(1130,'Barabanki',26),(1131,'Khurja',26),(1132,'Gonda',26),(1133,'Mainpuri',26),(1134,'Lalitpur',26),(1135,'Etah',26),(1136,'Deoria',26),(1137,'Ghazipur',26),(1138,'Sultanpur',26),(1139,'Azamgarh',26),(1140,'Bijnor',26),(1141,'Sahaswan',26),(1142,'Basti',26),(1143,'Chandausi',26),(1144,'Akbarpur',26),(1145,'Ballia',26),(1146,'Tanda',26),(1147,'Greater Noida',26),(1148,'Shikohabad',26),(1149,'Shamli',26),(1150,'Awagarh',26),(1151,'Kasganj',26),(1152,'Dehradun',27),(1153,'Haridwar',27),(1154,'Roorkee',27),(1155,'Haldwani-cum-Kathgodam',27),(1156,'Rudrapur',27),(1157,'Kashipur',27),(1158,'Kolkata',28),(1159,'Asansol',28),(1160,'Siliguri',28),(1161,'Durgapur',28),(1162,'Bardhaman',28),(1163,'Malda',28),(1164,'Baharampur',28),(1165,'Habra',28),(1166,'Kharagpur',28),(1167,'Shantipur',28),(1168,'Dankuni',28),(1169,'Dhulian',28),(1170,'Ranaghat',28),(1171,'Haldia',28),(1172,'Raiganj',28),(1173,'Krishnanagar',28),(1174,'Nabadwip',28),(1175,'Medinipur',28),(1176,'Jalpaiguri',28),(1177,'Balurghat',28),(1178,'Basirhat',28),(1179,'Bankura',28),(1180,'Chakdaha',28),(1181,'Darjeeling',28),(1182,'Alipurduar',28),(1183,'Purulia',28),(1184,'Jangipur',28),(1185,'Bolpur',28),(1186,'Bangaon',28),(1187,'Andaman',29),(1188,'Nicobar',29),(1189,'Atawa',30),(1190,'Badheri',30),(1191,'Bahlana',30),(1192,'Bahlolpur',30),(1193,'Bajwāra',30),(1194,'Bijwāri Bakhta',30),(1195,'Burail',30),(1196,'Burail',30),(1197,'Buterla',30),(1198,'Chandigarh',30),(1199,'Czandigarh',30),(1200,'Dariya',30),(1201,'Dhanas',30),(1202,'Dhanaurān',30),(1203,'Dādu Mājra',30),(1204,'Fatehgarh',30),(1205,'Hala Mājra',30),(1206,'Jhāmpur',30),(1207,'Kaimbwāla',30),(1208,'Kanthala',30),(1209,'Kanthara',30),(1210,'Khoda Jassu',30),(1211,'Kursan',30),(1212,'Kānjī Māira',30),(1213,'Kānsil',30),(1214,'Kūjheri',30),(1215,'Madanpur',30),(1216,'Mahla Majra',30),(1217,'Malak',30),(1218,'Mastgarh',30),(1219,'Moloia',30),(1220,'Mārīwālā Town',30),(1221,'Palsaura',30),(1222,'Phaldan',30),(1223,'Raj Bhavan Haryana',30),(1224,'Raj Bhavan Punjab',30),(1225,'Rāipur',30),(1226,'Sangāriwāla',30),(1227,'Sarangpur',30),(1228,'Shahpur',30),(1229,'Daman',31),(1230,'Diu',31),(1231,'Dadra and Nagar Haveli',31),(1232,'Aali',32),(1233,'Alipur',32),(1234,'Asola',32),(1235,'Aya Nagar',32),(1236,'Babarpur',32),(1237,'Bakhtawarpur',32),(1238,'Bakkar Wala',32),(1239,'Bankauli',32),(1240,'Bankner',32),(1241,'Bapraula',32),(1242,'Baqiabad',32),(1243,'Barwala',32),(1244,'Bawana',32),(1245,'Begum Pur',32),(1246,'Bhalswa Jahangirpur',32),(1247,'Bhati',32),(1248,'Bhor Garh',32),(1249,'Burari',32),(1250,'Chandan Hola',32),(1251,'Chattarpur',32),(1252,'Chhawala',32),(1253,'Chilla Saroda Bangar',32),(1254,'Chilla Saroda Khadar',32),(1255,'Daryapur Kalan',32),(1256,'Dayalpur',32),(1257,'Dallopura',32),(1258,'Dindarpur',32),(1259,'Deoli',32),(1260,'Dera Mandi',32),(1261,'Fatehpur Beri',32),(1262,'Gharonda Neemka Bangar',32),(1263,'Gharoli',32),(1264,'Gheora',32),(1265,'Gokalpur',32),(1266,'Ghitorni',32),(1267,'Hastsal',32),(1268,'Holambi kalan',32),(1269,'Holambi khurd',32),(1270,'Ibrahimpur',32),(1271,'Jaitpur',32),(1272,'Jiwanpur',32),(1273,'Jaffrabad',32),(1274,'Jharoda Kalan',32),(1275,'Jonapur',32),(1276,'Jharoda Majra Burari',32),(1277,'Kanjhawala',32),(1278,'Kamalpur Majra Burari',32),(1279,'Kapas Hera',32),(1280,'Karala',32),(1281,'Karawal Nagar',32),(1282,'Kair',32),(1283,'Khanpur Dhani',32),(1284,'Khajoori Khas',32),(1285,'Khera',32),(1286,'Khera Kalan',32),(1287,'Khera Khurd',32),(1288,'Kirari Suleman Nagar',32),(1289,'Kondli',32),(1290,'Kotla Mahigiran',32),(1291,'Kusumpur',32),(1292,'Ladpur',32),(1293,'Libaspur',32),(1294,'Maidan Garhi',32),(1295,'Mehrauli',32),(1296,'Mukhmelpur',32),(1297,'Moradabad Pahari',32),(1298,'Malikpur Kohi',32),(1299,'Mithepur',32),(1300,'Molarband',32),(1301,'Mirpur Turk',32),(1302,'Mubarak Pur Dabas',32),(1303,'Mustafabad',32),(1304,'Mohammad Pur Majri',32),(1305,'Mandoli',32),(1306,'Mukandpur',32),(1307,'Mundka',32),(1308,'Mitraon',32),(1309,'Nilothi',32),(1310,'Nangloi Jat',32),(1311,'Nithari',32),(1312,'Neb Sarai',32),(1313,'Nangli Sakrawati',32),(1314,'Pooth Kalan',32),(1315,'Pooth Khurd',32),(1316,'Pul Pehlad',32),(1317,'Prahlad Pur Bangar',32),(1318,'Qadipur',32),(1319,'Quammruddin Nagar',32),(1320,'Rajapur Khurd',32),(1321,'Rajokri',32),(1322,'Rani Khera',32),(1323,'Roshanpura',32),(1324,'Sultanpur Majra',32),(1325,'Saidabad',32),(1326,'Shakarpur Baramad',32),(1327,'Sadatpur Gujran',32),(1328,'Siraspur',32),(1329,'Sahibabad Daulatpur',32),(1330,'Shafipur Ranhola',32),(1331,'Tikri Kalan',32),(1332,'Sambhalka',32),(1333,'Sultanpur',32),(1334,'Saidul Azaib',32),(1335,'Taj Pul',32),(1336,'Tukhmirpur',32),(1337,'Tilangpur Kotla',32),(1338,'Tigri',32),(1339,'Tikri Khurd',32),(1340,'Ziauddinpur',32);
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `C_ID` int NOT NULL,
  `PhoneNo` varchar(15) DEFAULT NULL,
  `EmailID` varchar(100) DEFAULT NULL,
  `ConnectionDate` date DEFAULT NULL,
  `Gender` char(1) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`C_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meter`
--

DROP TABLE IF EXISTS `meter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meter` (
  `MeterID` int NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `C_ID` int DEFAULT NULL,
  `RateID` int DEFAULT NULL,
  PRIMARY KEY (`MeterID`),
  KEY `C_ID` (`C_ID`),
  KEY `fk_meter_rate` (`RateID`),
  CONSTRAINT `fk_meter_rate` FOREIGN KEY (`RateID`) REFERENCES `rate` (`RateID`),
  CONSTRAINT `meter_ibfk_1` FOREIGN KEY (`C_ID`) REFERENCES `customer` (`C_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meter`
--

LOCK TABLES `meter` WRITE;
/*!40000 ALTER TABLE `meter` DISABLE KEYS */;
/*!40000 ALTER TABLE `meter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `name`
--

DROP TABLE IF EXISTS `name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `name` (
  `FirstName` varchar(30) DEFAULT NULL,
  `LastName` varchar(30) DEFAULT NULL,
  `C_ID` int DEFAULT NULL,
  KEY `fk_name_customer` (`C_ID`),
  CONSTRAINT `fk_name_customer` FOREIGN KEY (`C_ID`) REFERENCES `customer` (`C_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `name`
--

LOCK TABLES `name` WRITE;
/*!40000 ALTER TABLE `name` DISABLE KEYS */;
/*!40000 ALTER TABLE `name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `P_ID` int NOT NULL,
  `Date` date NOT NULL,
  `Mode` varchar(20) DEFAULT NULL,
  `B_ID` int DEFAULT NULL,
  PRIMARY KEY (`P_ID`),
  KEY `B_ID` (`B_ID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`B_ID`) REFERENCES `bill` (`B_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate`
--

DROP TABLE IF EXISTS `rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate` (
  `RateID` int NOT NULL,
  `Type` varchar(20) NOT NULL,
  `RatePerUnit` decimal(10,2) NOT NULL,
  PRIMARY KEY (`RateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate`
--

LOCK TABLES `rate` WRITE;
/*!40000 ALTER TABLE `rate` DISABLE KEYS */;
INSERT INTO `rate` VALUES (1,'Domestic',4.50),(2,'Commercial',6.75),(3,'Industrial',8.20),(4,'Agricultural',3.00);
/*!40000 ALTER TABLE `rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state` (
  `StateID` int NOT NULL,
  `StateName` varchar(50) NOT NULL,
  PRIMARY KEY (`StateID`),
  UNIQUE KEY `StateName` (`StateName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES (29,'Andaman & Nicobar Islands'),(1,'Andhra Pradesh'),(2,'Arunachal Pradesh'),(3,'Assam'),(4,'Bihar'),(30,'Chandigarh'),(5,'Chhattisgarh'),(31,'Dadra & Nagar Haveli and Daman & Diu'),(32,'Delhi'),(6,'Goa'),(7,'Gujarat'),(8,'Haryana'),(9,'Himachal Pradesh'),(33,'Jammu & Kashmir'),(10,'Jharkhand'),(11,'Karnataka'),(12,'Kerala'),(34,'Ladakh'),(35,'Lakshadweep'),(13,'Madhya Pradesh'),(14,'Maharashtra'),(15,'Manipur'),(16,'Meghalaya'),(17,'Mizoram'),(18,'Nagaland'),(19,'Odisha'),(36,'Puducherry'),(20,'Punjab'),(21,'Rajasthan'),(22,'Sikkim'),(23,'Tamil Nadu'),(24,'Telangana'),(25,'Tripura'),(26,'Uttar Pradesh'),(27,'Uttarakhand'),(28,'West Bengal');
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usertype`
--

DROP TABLE IF EXISTS `usertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usertype` (
  `UseID` int NOT NULL AUTO_INCREMENT,
  `UseType` varchar(50) NOT NULL,
  `Rate` decimal(6,2) NOT NULL,
  PRIMARY KEY (`UseID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usertype`
--

LOCK TABLES `usertype` WRITE;
/*!40000 ALTER TABLE `usertype` DISABLE KEYS */;
INSERT INTO `usertype` VALUES (1,'Domestic',5.00),(2,'Commercial',7.50),(3,'Industrial',10.00);
/*!40000 ALTER TABLE `usertype` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-28 16:21:57
