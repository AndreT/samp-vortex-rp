-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: samp
-- ------------------------------------------------------
-- Server version	5.5.16

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
-- Table structure for table `adminlog`
--

DROP TABLE IF EXISTS `adminlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminlog` (
  `entryID` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  `entryTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tickcount` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`entryID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminlog`
--

LOCK TABLES `adminlog` WRITE;
/*!40000 ALTER TABLE `adminlog` DISABLE KEYS */;
INSERT INTO `adminlog` VALUES (1,'','2011-07-28 18:10:33',0);
/*!40000 ALTER TABLE `adminlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `assetID` int(6) NOT NULL AUTO_INCREMENT,
  `assetName` varchar(255) NOT NULL DEFAULT '(null)',
  `assetValue` varchar(255) NOT NULL DEFAULT '(null)',
  PRIMARY KEY (`assetID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'taxValue','10'),(2,'min_group_invite_level','3'),(3,'min_level_upgrade_cost','2500'),(4,'twitter','VortexRoleplay');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atms`
--

DROP TABLE IF EXISTS `atms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atms` (
  `atmId` int(11) NOT NULL AUTO_INCREMENT,
  `atmPosX` varchar(128) NOT NULL,
  `atmPosY` varchar(128) NOT NULL,
  `atmPosZ` varchar(128) NOT NULL,
  `atmPosRotX` varchar(128) NOT NULL,
  `atmPosRotY` varchar(128) NOT NULL,
  `atmPosRotZ` varchar(128) NOT NULL,
  PRIMARY KEY (`atmId`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atms`
--

LOCK TABLES `atms` WRITE;
/*!40000 ALTER TABLE `atms` DISABLE KEYS */;
INSERT INTO `atms` VALUES (1,'2228.39','-1707.78','13.25','0','0','270.0'),(2,'2228.39','-1707.78','13.25','0','0','270.0'),(3,'1275.7958984375','368.31481933594','19.19758605957','0','0','73.759948730469'),(4,'1260.8796386719','209.30152893066','19.19758605957','0','0','65.504638671875'),(5,'2303.4577636719','-13.539554595947','26.12727355957','0','0','272.43542480469'),(6,'2316.1015625','-88.522567749023','26.12727355957','0','0','0'),(7,'1155.6235351563','-1464.9141845703','15.44321346283','0','0','290.21020507813'),(8,'387.16552734375','-1816.0512695313','7.4834146499634','0','0','272.48046875'),(9,'-24.385023117065','-92.001075744629','1003.1897583008','0','0','180.54052734375'),(10,'-31.811220169067','-58.106018066406','1003.1897583008','0','0','181.21594238281'),(11,'1212.7785644531','2.451762676239','1000.5647583008','0','0','0'),(12,'2324.4028320313','-1644.9445800781','14.469946861267','0','0','0'),(13,'651.19305419922','-520.48815917969','15.978837013245','0','0','0'),(14,'691.08215332031','-618.5625','15.978837013245','0','0','268.69067382813'),(15,'45.78035736084','-291.80926513672','1.5024013519287','0','0','182.93444824219'),(16,'173.23471069336','-155.07606506348','1.2210245132446','0','0','89.730041503906'),(17,'294.80','-84.01','1001.0','0.00000000','0.00000000','90.00000000'),(18,'2065.439453125','-1897.5510253906','13.19670009613','0','0','0'),(19,'1497.7467041016','-1749.8747558594','15.088212013245','0','0','177.38134765625'),(20,'2093.5124511719','-1359.5474853516','23.62727355957','0','0','0'),(21,'2139.4487304688','-1164.0811767578','23.63508605957','0','0','91.309509277344'),(22,'1482.7761230469','-1010.3353881836','26.48664855957','0','0','0'),(23,'-1835.60144043','63.24560547','1054.83203125','0.00000000','0.00000000','270.00000000'),(24,'-1835.59985352','64.59873199','1054.83203125','0.00000000','0.00000000','270.00000000');
/*!40000 ALTER TABLE `atms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banksuspensions`
--

DROP TABLE IF EXISTS `banksuspensions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banksuspensions` (
  `transactionID` int(32) NOT NULL AUTO_INCREMENT,
  `suspendeeID` int(32) NOT NULL,
  `playerID` int(32) NOT NULL,
  `suspensionReason` varchar(128) NOT NULL,
  PRIMARY KEY (`transactionID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banksuspensions`
--

LOCK TABLES `banksuspensions` WRITE;
/*!40000 ALTER TABLE `banksuspensions` DISABLE KEYS */;
INSERT INTO `banksuspensions` VALUES (1,1,1,'asfdas'),(2,1,1,'Tax evasion');
/*!40000 ALTER TABLE `banksuspensions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bans`
--

DROP TABLE IF EXISTS `bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bans` (
  `banID` SMALLINT(6) NOT NULL AUTO_INCREMENT,
  `playerNameBanned` VARCHAR(24) NOT NULL,
  `playerBanReason` VARCHAR(48) NOT NULL,
  `playerBanDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IPBanned` VARCHAR(16) NOT NULL,
  `playerBannedBy` VARCHAR(24) NOT NULL DEFAULT 'System',
  PRIMARY KEY (`banID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bans`
--

LOCK TABLES `bans` WRITE;
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businesses`
--

DROP TABLE IF EXISTS `businesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `businesses` (
  `businessID` int(6) NOT NULL AUTO_INCREMENT,
  `businessName` varchar(32) NOT NULL DEFAULT '(null)',
  `businessOwner` varchar(24) NOT NULL DEFAULT 'Nobody',
  `businessType` int(6) NOT NULL DEFAULT '0',
  `businessExteriorX` varchar(255) NOT NULL DEFAULT '0',
  `businessExteriorY` varchar(255) NOT NULL DEFAULT '0',
  `businessExteriorZ` varchar(255) NOT NULL DEFAULT '0',
  `businessInteriorX` varchar(255) NOT NULL DEFAULT '0',
  `businessInteriorY` varchar(255) NOT NULL DEFAULT '0',
  `businessInteriorZ` varchar(255) NOT NULL DEFAULT '0',
  `businessInterior` int(6) NOT NULL DEFAULT '0',
  `businessLock` int(6) NOT NULL DEFAULT '1',
  `businessPrice` int(12) NOT NULL DEFAULT '0',
  `businessVault` int(12) NOT NULL DEFAULT '0',
  `businessMiscX` varchar(255) NOT NULL DEFAULT '0.0',
  `businessMiscY` varchar(255) NOT NULL DEFAULT '0.0',
  `businessMiscZ` varchar(255) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`businessID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesses`
--

LOCK TABLES `businesses` WRITE;
/*!40000 ALTER TABLE `businesses` DISABLE KEYS */;
INSERT INTO `businesses` VALUES (1,'Nothing','Nobody',4,'1352.352050','-1758.997192','13.507802','-27.201389','-58.012557','1003.546875',6,0,0,235,'0.000000','0.000000','0.000000'),(2,'Jims Sticky Ring','Nobody',7,'1038.053710','-1340.732666','13.745111','376.870758','-193.306152','1000.632812',17,1,0,85,'0.000000','0.000000','0.000000'),(3,'Nothing','Calgon_Washing',4,'1072.309448','-1269.224609','13.681709','-100.342987','-24.840753','1000.718750',3,0,0,0,'0.000000','0.000000','0.000000');
/*!40000 ALTER TABLE `businesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businessitems`
--

DROP TABLE IF EXISTS `businessitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `businessitems` (
  `itemId` int(6) NOT NULL AUTO_INCREMENT,
  `itemBusinessId` int(6) NOT NULL DEFAULT '0',
  `itemTypeId` int(6) NOT NULL DEFAULT '0',
  `itemPrice` int(6) NOT NULL DEFAULT '10',
  `itemName` varchar(64) NOT NULL DEFAULT 'Undefined',
  PRIMARY KEY (`itemId`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businessitems`
--

LOCK TABLES `businessitems` WRITE;
/*!40000 ALTER TABLE `businessitems` DISABLE KEYS */;
INSERT INTO `businessitems` VALUES (6,1,9,10,'Purple Dildo'),(7,1,10,15,'Small White Vibrator'),(8,1,11,20,'Large White Vibrator'),(9,1,12,15,'Silver Vibrator'),(10,1,13,10,'Flowers'),(11,11,0,10,'All Skins');
/*!40000 ALTER TABLE `businessitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatlogs`
--

DROP TABLE IF EXISTS `chatlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chatlogs` (
  `entryID` int(12) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  `playerinternalid` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`entryID`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatlogs`
--

LOCK TABLES `chatlogs` WRITE;
/*!40000 ALTER TABLE `chatlogs` DISABLE KEYS */;
INSERT INTO `chatlogs` VALUES (1,'(American Accent) {FFFFFF}Calgon Washing says: a',1),(2,'{FFFFFF}Calgon Washing says: Hi',1),(3,'{FFFFFF}Calgon Washing says: ata',1),(4,'{FFFFFF}Calgon Washing says: a',1),(5,'{FFFFFF}Calgon Washing says: ata',1),(6,'{FFFFFF}Calgon Washing says: ata',1),(7,'{FFFFFF}Calgon Washing says: a',1),(8,'{FFFFFF}Calgon Washing says: a',1),(9,'(American Accent) {FFFFFF}Calgon Washing says: a',1),(10,'(American Accent) {FFFFFF}Calgon Washing says: a',1),(11,'(American Accent) {FFFFFF}Calgon Washing says: a',1);
/*!40000 ALTER TABLE `chatlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `groupID` int(12) NOT NULL AUTO_INCREMENT,
  `groupRankName1` varchar(32) NOT NULL DEFAULT '(null)',
  `groupRankName2` varchar(32) NOT NULL DEFAULT '(null)',
  `groupRankName3` varchar(32) NOT NULL DEFAULT '(null)',
  `groupRankName4` varchar(32) NOT NULL DEFAULT '(null)',
  `groupRankName5` varchar(32) NOT NULL DEFAULT '(null)',
  `groupRankName6` varchar(32) NOT NULL DEFAULT '(null)',
  `groupName` varchar(255) NOT NULL DEFAULT 'None',
  `groupHQExteriorPosX` varchar(255) NOT NULL DEFAULT '0',
  `groupHQExteriorPosY` varchar(255) NOT NULL DEFAULT '0',
  `groupHQExteriorPosZ` varchar(255) NOT NULL DEFAULT '0',
  `groupHQInteriorPosX` varchar(255) NOT NULL DEFAULT '0',
  `groupHQInteriorPosY` varchar(255) NOT NULL DEFAULT '0',
  `groupHQInteriorPosZ` varchar(255) NOT NULL DEFAULT '0',
  `groupHQInteriorID` int(4) NOT NULL DEFAULT '0',
  `groupHQLockStatus` int(2) NOT NULL DEFAULT '1',
  `groupMOTD` varchar(128) NOT NULL DEFAULT '(null)',
  `groupSafePosX` varchar(255) NOT NULL DEFAULT '0',
  `groupSafePosY` varchar(255) NOT NULL DEFAULT '0',
  `groupSafePosZ` varchar(255) NOT NULL DEFAULT '0',
  `groupType` int(12) NOT NULL DEFAULT '0',
  `groupSafeMoney` int(6) NOT NULL DEFAULT '1',
  `groupSafeMats` int(6) NOT NULL DEFAULT '1',
  PRIMARY KEY (`groupID`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'Officer','Detective','Sergeant','Lieutenant','Captain','Chief','Los Santos Police Department','1555.498168','-1675.593750','16.195299','246.393981','108.453521','1003.218750',10,0,'Finally changed the LSPD motd!','226.471572','124.153427','999.015625',1,14549,620),(2,'(null)','(null)','(null)','(null)','(null)','(null)','Los Santos Fire & Medical Department','1172.408569','-1325.474365','15.405900','378.026000','-190.515502','1000.632812',17,0,'(null)','0.000000','0.000000','0.000000',0,0,0),(3,'potato','Prospect','Patch','Enforcer','Road Captain','President','San Andreas Government','2308.412109','-1637.348022','14.827047','316.232727','-169.791290','999.601013',6,1,'(/setfrequency #1979)','356.696594','151.063232','1025.789062',1,5000,7150),(4,'Recruit','Hustler Loco','Huslter Loco','El Cholo','Lieutenant Governor','President','Government','1481.016479','-1771.215820','18.795755','389.451202','173.810348','1008.382812',3,0,'Leader-Lamont will be inactive till Monday have fun and RP till I am back.','368.132080','162.652603','1008.382812',2,4960,0),(5,'(null)','(null)','(null)','(null)','(null)','(null)','Test','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',1,1,1),(6,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1),(7,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1),(8,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1),(9,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1),(10,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1),(11,'(null)','(null)','(null)','(null)','(null)','(null)','None','0.000000','0.000000','0.000000','0.000000','0.000000','0.000000',0,1,'(null)','0.000000','0.000000','0.000000',0,1,1);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `houses` (
  `houseID` int(12) NOT NULL AUTO_INCREMENT,
  `houseExteriorPosX` varchar(255) NOT NULL DEFAULT '0',
  `houseExteriorPosY` varchar(255) NOT NULL DEFAULT '0',
  `houseExteriorPosZ` varchar(255) NOT NULL DEFAULT '0',
  `houseInteriorPosX` varchar(255) NOT NULL DEFAULT '0',
  `houseInteriorPosY` varchar(255) NOT NULL DEFAULT '0',
  `houseInteriorPosZ` varchar(255) NOT NULL DEFAULT '0',
  `houseInteriorID` int(4) NOT NULL DEFAULT '0',
  `houseExteriorID` int(4) NOT NULL DEFAULT '0',
  `houseOwner` varchar(24) NOT NULL DEFAULT 'Nobody',
  `housePrice` int(12) NOT NULL DEFAULT '0',
  `houseLocked` int(2) NOT NULL DEFAULT '1',
  `houseMoney` int(12) NOT NULL DEFAULT '0',
  `houseWeapon1` int(12) NOT NULL DEFAULT '0',
  `houseWeapon2` int(12) NOT NULL DEFAULT '0',
  `houseWeapon3` int(12) NOT NULL DEFAULT '0',
  `houseMaterials` int(12) NOT NULL DEFAULT '0',
  `houseWardrobe1` int(12) NOT NULL DEFAULT '0',
  `houseWardrobe2` int(12) NOT NULL DEFAULT '0',
  `houseWardrobe3` int(12) NOT NULL DEFAULT '0',
  `houseWardrobe4` int(12) NOT NULL DEFAULT '0',
  `houseWardrobe5` int(12) NOT NULL DEFAULT '0',
  `houseWeapon4` int(12) NOT NULL DEFAULT '0',
  `houseWeapon5` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`houseID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `houses`
--

LOCK TABLES `houses` WRITE;
/*!40000 ALTER TABLE `houses` DISABLE KEYS */;
INSERT INTO `houses` VALUES (1,'1179.991821','-1260.972534','18.898437','266.813812','305.123809','999.148437',2,0,'Nobody',0,1,0,0,0,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `jobID` int(12) NOT NULL AUTO_INCREMENT,
  `jobType` int(12) NOT NULL DEFAULT '0',
  `jobPositionX` varchar(255) NOT NULL,
  `jobPositionY` varchar(255) NOT NULL,
  `jobPositionZ` varchar(255) NOT NULL,
  `jobName` varchar(255) NOT NULL,
  PRIMARY KEY (`jobID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,1,'1366.959960','-1291.690551','13.546875','Arms Dealer'),(2,2,'606.585144','-1438.753540','14.052495','Detective'),(3,3,'2329.9673','-2315.4370','13.5469','Mechanic'),(4,4,'376.1711','-2071.6523','7.8359','Fisherman');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `namechanges`
--

DROP TABLE IF EXISTS `namechanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `namechanges` (
  `namechangeid` int(6) NOT NULL AUTO_INCREMENT,
  `userid` int(6) NOT NULL,
  `oldname` varchar(24) NOT NULL,
  `newname` varchar(24) NOT NULL,
  `adminid` int(6) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`namechangeid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `namechanges`
--

LOCK TABLES `namechanges` WRITE;
/*!40000 ALTER TABLE `namechanges` DISABLE KEYS */;
/*!40000 ALTER TABLE `namechanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pages` (
  `pageId` int(6) NOT NULL AUTO_INCREMENT,
  `pageName` varchar(128) NOT NULL,
  `pageContent` varchar(10000) NOT NULL,
  `pageAuthor` int(6) NOT NULL,
  `pageCreationTS` int(32) NOT NULL,
  `pageUpdateTS` int(32) NOT NULL,
  `pageSpecialTemplate` varchar(32) NOT NULL,
  PRIMARY KEY (`pageId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES (1,'Home','Vortex Roleplay is an amazing server, it is powered by the vxrp2 script and UCP, the UCP produced by Frederick Wright with designs from Peter Wright, and the script produced by Frederick Wright and Stefan Rosic.<br /><br />I can\'t wait to meet you <br /> And I know and I know <br /> I\'ll have to learn how to teach you <br /> I need to let the fool in me go <br /> I\'m gonna work like crazy <br /> Give you everything you need <br /> Build the world that you will see <br /> I will see you soon <br /> I will be waiting at the other end <br /> Take your time coming through <br /> You will never have to this again <br /> I will show you them all <br /> Lessons I\'ve learned will have to guide <br /> I\'ll come running when you call <br /> But for now, just stay inside <br />',1,1321669061,1321669061,''),(2,'About Us','This community is based on the roleplaying mode in SA-MP, there\'s a UCP (this) and a SA-MP server which run in conjunction with each other to deliver a dynamic, entertaining and generally great experience. <br /><br />This community is powered by the vxrp2 package&mdash;which includes the UCP and SA-MP server script.',1,1321673299,1321678392,''),(3,'Statistics','Here\'s a few of the most significant statistics we have on record:<br /><br />',1,1321678751,1321678751,'stats'),(4,'Server Information','127.0.0.1:7777',1,1321750275,1321750275,''),(5,'Staff Roster','Here\'s a list of the special people that help us run this community on a daily basis&mdash;they contribute their time, money and mental health to keeping this community a great place.<br /><br />',1,1321750395,1321750395,'staff'),(6,'Logout','You\'ve now logged out. <br /><br />Thanks for stopping by!',1,1321759357,1321759357,'logout'),(7,'Password Recovery','You can use this page to recover your password.',1,1321760418,1321760418,'recovery'),(8,'Login','You can login from this page.',1,1321760513,1321760513,'login'),(9,'FAQ','Here\'s a short FAQ covering the basics of the UCP. If you\'re confused, this is the place to visit.<br /><br /><b>How do I login?</b><br />The login box positioned at the top right allows you to login with your in-game username and password.',1,1321940685,1321940685,'');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phonecontacts`
--

DROP TABLE IF EXISTS `phonecontacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phonecontacts` (
  `contactID` int(32) NOT NULL AUTO_INCREMENT,
  `contactAdded` int(32) NOT NULL,
  `contactAddee` int(32) NOT NULL,
  `contactName` varchar(24) NOT NULL,
  PRIMARY KEY (`contactID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phonecontacts`
--

LOCK TABLES `phonecontacts` WRITE;
/*!40000 ALTER TABLE `phonecontacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phonecontacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phonelogs`
--

DROP TABLE IF EXISTS `phonelogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phonelogs` (
  `logID` int(32) NOT NULL AUTO_INCREMENT,
  `phoneNumber` int(32) NOT NULL,
  `phoneName` varchar(24) NOT NULL,
  `phoneAction` varchar(768) NOT NULL,
  PRIMARY KEY (`logID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phonelogs`
--

LOCK TABLES `phonelogs` WRITE;
/*!40000 ALTER TABLE `phonelogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `phonelogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playeraccounts`
--

DROP TABLE IF EXISTS `playeraccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playeraccounts` (
  `playerID` int(12) NOT NULL AUTO_INCREMENT,
  `playerLevel` int(6) NOT NULL DEFAULT '0',
  `playerName` varchar(24) NOT NULL,
  `playerPassword` varchar(129) NOT NULL,
  `playerEmail` varchar(255) NOT NULL,
  `playerMoney` int(16) NOT NULL DEFAULT '10000',
  `playerBanned` int(12) NOT NULL DEFAULT '0',
  `playerPublicProfile` int(2) NOT NULL,
  `playerAdminLevel` int(6) NOT NULL DEFAULT '0',
  `playerRegistrationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `playerSkin` int(3) NOT NULL DEFAULT '299',
  `playerPosX` varchar(255) NOT NULL DEFAULT '739.083740',
  `playerPosY` varchar(255) NOT NULL DEFAULT '-1417.779785',
  `playerPosZ` varchar(255) NOT NULL DEFAULT '13.523437',
  `playerBankMoney` int(16) NOT NULL DEFAULT '20000',
  `playerHealth` varchar(255) NOT NULL DEFAULT '100',
  `playerArmour` int(255) NOT NULL DEFAULT '0',
  `playerAccent` varchar(40) NOT NULL DEFAULT 'American',
  `playerSeconds` int(5) NOT NULL DEFAULT '0',
  `playerInterior` int(6) NOT NULL DEFAULT '0',
  `playerVirtualWorld` int(6) NOT NULL DEFAULT '0',
  `playerJob` int(3) NOT NULL DEFAULT '0',
  `playerWeapon0` int(6) NOT NULL DEFAULT '0',
  `playerWeapon1` int(6) NOT NULL DEFAULT '0',
  `playerWeapon2` int(6) NOT NULL DEFAULT '0',
  `playerWeapon3` int(6) NOT NULL DEFAULT '0',
  `playerWeapon4` int(6) NOT NULL DEFAULT '0',
  `playerWeapon5` int(6) NOT NULL DEFAULT '0',
  `playerWeapon6` int(6) NOT NULL DEFAULT '0',
  `playerWeapon7` int(6) NOT NULL DEFAULT '0',
  `playerWeapon8` int(6) NOT NULL DEFAULT '0',
  `playerWeapon9` int(6) NOT NULL DEFAULT '0',
  `playerWeapon10` int(6) NOT NULL DEFAULT '0',
  `playerWeapon11` int(6) NOT NULL DEFAULT '0',
  `playerWeapon12` int(6) NOT NULL DEFAULT '0',
  `playerJobSkill1` int(6) NOT NULL DEFAULT '0',
  `playerJobSkill2` int(6) NOT NULL DEFAULT '0',
  `playerMaterials` int(12) NOT NULL DEFAULT '0',
  `playerGroup` int(6) NOT NULL DEFAULT '0',
  `playerGroupRank` int(6) NOT NULL DEFAULT '0',
  `playerHours` int(12) NOT NULL DEFAULT '0',
  `playerWarning1` varchar(32) NOT NULL DEFAULT '(null)',
  `playerWarning2` varchar(32) NOT NULL DEFAULT '(null)',
  `playerWarning3` varchar(32) NOT NULL DEFAULT '(null)',
  `playerHospitalized` int(3) NOT NULL DEFAULT '0',
  `playerAdminName` varchar(24) NOT NULL DEFAULT '(null)',
  `playerFirstLogin` int(2) NOT NULL DEFAULT '1',
  `playerGender` int(2) NOT NULL DEFAULT '0',
  `playerPrisonID` int(2) NOT NULL DEFAULT '0',
  `playerPrisonTime` int(6) NOT NULL DEFAULT '0',
  `playerPhoneNumber` int(12) NOT NULL DEFAULT '-1',
  `playerPhoneBook` int(2) NOT NULL DEFAULT '0',
  `playerIP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `playerHelperLevel` int(6) NOT NULL DEFAULT '0',
  `playerDropCarTimeout` int(12) NOT NULL DEFAULT '0',
  `playerRope` int(6) NOT NULL DEFAULT '0',
  `playerAdminDuty` int(2) NOT NULL DEFAULT '0',
  `playerCrimes` int(12) NOT NULL DEFAULT '0',
  `playerArrests` int(12) NOT NULL DEFAULT '0',
  `playerWarrants` int(12) NOT NULL DEFAULT '0',
  `playerPasswordToken` int(16) NOT NULL DEFAULT '0',
  `playerCarModel` int(6) NOT NULL DEFAULT '0',
  `playerCarMod0` int(6) NOT NULL DEFAULT '0',
  `playerCarMod1` int(6) NOT NULL DEFAULT '0',
  `playerCarMod2` int(6) NOT NULL DEFAULT '0',
  `playerCarMod3` int(6) NOT NULL DEFAULT '0',
  `playerCarMod4` int(6) NOT NULL DEFAULT '0',
  `playerCarMod5` int(6) NOT NULL DEFAULT '0',
  `playerCarMod6` int(6) NOT NULL DEFAULT '0',
  `playerCarMod7` int(6) NOT NULL DEFAULT '0',
  `playerCarMod8` int(6) NOT NULL DEFAULT '0',
  `playerCarMod9` int(6) NOT NULL DEFAULT '0',
  `playerCarMod10` int(6) NOT NULL DEFAULT '0',
  `playerCarMod11` int(6) NOT NULL DEFAULT '0',
  `playerCarMod12` int(6) NOT NULL DEFAULT '0',
  `playerCarPosX` varchar(255) NOT NULL DEFAULT '0.0',
  `playerCarPosY` varchar(255) NOT NULL DEFAULT '0.0',
  `playerCarPosZ` varchar(255) NOT NULL DEFAULT '0.0',
  `playerCarPosZAngle` varchar(255) NOT NULL DEFAULT '0.0',
  `playerCarColour1` int(6) NOT NULL DEFAULT '-1',
  `playerCarColour2` int(6) NOT NULL DEFAULT '-1',
  `playerAge` int(6) NOT NULL,
  `playerCarPaintJob` int(6) NOT NULL DEFAULT '-1',
  `playerCarLock` int(6) NOT NULL DEFAULT '0',
  `playerStatus` int(6) NOT NULL DEFAULT '0',
  `playerBiography` longtext NOT NULL,
  `playerFightStyle` int(6) NOT NULL DEFAULT '0',
  `playerVIP` int(6) NOT NULL DEFAULT '0',
  `playerExpireVIP` int(64) NOT NULL DEFAULT '0',
  `playerCarWeapon1` int(12) NOT NULL DEFAULT '0',
  `playerCarWeapon2` int(12) NOT NULL DEFAULT '0',
  `playerCarWeapon3` int(12) NOT NULL DEFAULT '0',
  `playerCarWeapon4` int(12) NOT NULL DEFAULT '0',
  `playerCarWeapon5` int(12) NOT NULL DEFAULT '0',
  `playerCarTrunk1` int(12) NOT NULL DEFAULT '0',
  `playerCarTrunk2` int(12) NOT NULL DEFAULT '0',
  `playerPhoneCredit` int(12) NOT NULL DEFAULT '0',
  `playerWalkieTalkie` int(12) NOT NULL DEFAULT '-1',
  `playerAdminTitle` varchar(255) NOT NULL DEFAULT '(null)',
  `playerCarLicensePlate` varchar(32) NOT NULL DEFAULT '3VF4 TW0',
  `playerAdminPIN` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`playerID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playeraccounts`
--

LOCK TABLES `playeraccounts` WRITE;
/*!40000 ALTER TABLE `playeraccounts` DISABLE KEYS */;
INSERT INTO `playeraccounts` VALUES (1,8,'Calgon_Washing','B1534A37909292F982AEFD206E7523987FB9329117079F73845918804D3A74A6F19314B3B1E9337185B610D8D954CA2442CDB0D2EB6E717A18B95ACBA12C263A','mrfrederickwright@gmail.com',10000,0,0,0,'2003-10-27 02:59:04',299,'755.896240','-1395.423950','13.368103',20000,'100.000000',0,'British',60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'(null)','(null)','(null)',0,'Calgon',0,1,0,0,1352,0,'127.0.0.1',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'0.000000','0.000000','0.000000','0.000000',-1,-1,1993,-1,0,0,'',0,0,0,0,0,0,0,0,0,0,0,-1,'DIRECTOR OF WORLD!!1','3VF4 TW0',0);
/*!40000 ALTER TABLE `playeraccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playeradvertisements`
--

DROP TABLE IF EXISTS `playeradvertisements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playeradvertisements` (
  `adID` int(12) NOT NULL AUTO_INCREMENT,
  `playerID` int(12) NOT NULL DEFAULT '0',
  `advertisementText` varchar(255) NOT NULL,
  `advertisementTimestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Time2` int(64) NOT NULL,
  PRIMARY KEY (`adID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playeradvertisements`
--

LOCK TABLES `playeradvertisements` WRITE;
/*!40000 ALTER TABLE `playeradvertisements` DISABLE KEYS */;
/*!40000 ALTER TABLE `playeradvertisements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playerconnections`
--

DROP TABLE IF EXISTS `playerconnections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playerconnections` (
  `conID` int(12) NOT NULL AUTO_INCREMENT,
  `conName` varchar(24) NOT NULL DEFAULT '(null)',
  `conIP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `conTS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `conPlayerID` int(6) NOT NULL,
  PRIMARY KEY (`conID`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playerconnections`
--

LOCK TABLES `playerconnections` WRITE;
/*!40000 ALTER TABLE `playerconnections` DISABLE KEYS */;
INSERT INTO `playerconnections` VALUES (1,'Calgon_Washing','127.0.0.1','2011-12-17 05:38:09',1),(2,'Calgon_Washing','127.0.0.1','2011-12-17 06:02:45',1),(3,'Calgon_Washing','127.0.0.1','2011-12-17 06:06:04',1),(4,'Calgon_Washing','127.0.0.1','2011-12-17 06:10:52',1),(5,'Calgon_Washing','127.0.0.1','2011-12-17 06:13:34',1),(6,'Calgon_Washing','127.0.0.1','2011-12-17 06:15:22',1),(7,'Calgon_Washing','127.0.0.1','2011-12-17 19:06:53',1),(8,'Calgon_Washing','127.0.0.1','2011-12-17 21:58:25',1),(9,'Calgon_Washing','127.0.0.1','2011-12-17 21:59:48',1),(10,'Calgon_Washing','127.0.0.1','2011-12-17 22:00:31',1),(11,'Calgon_Washing','127.0.0.1','2011-12-17 22:19:09',1),(12,'Calgon_Washing','127.0.0.1','2011-12-19 06:06:06',1),(13,'Calgon_Washing','127.0.0.1','2011-12-19 06:10:00',1),(14,'Calgon_Washing','127.0.0.1','2011-12-19 06:28:55',1),(15,'Calgon_Washing','127.0.0.1','2011-12-19 06:32:48',1),(16,'Calgon_Washing','127.0.0.1','2011-12-19 06:35:02',1),(17,'Calgon_Washing','127.0.0.1','2011-12-19 06:35:40',1),(18,'Calgon_Washing','127.0.0.1','2011-12-19 06:40:03',1),(19,'Calgon_Washing','127.0.0.1','2011-12-19 06:42:36',1),(20,'Calgon_Washing','127.0.0.1','2011-12-19 06:43:51',1),(21,'Calgon_Washing','127.0.0.1','2011-12-19 08:21:31',1),(22,'Calgon_Washing','127.0.0.1','2011-12-19 08:25:33',1),(23,'Calgon_Washing','127.0.0.1','2011-12-19 08:29:42',1),(24,'Calgon_Washing','127.0.0.1','2011-12-19 08:30:40',1),(25,'Calgon_Washing','127.0.0.1','2011-12-19 08:54:08',1),(26,'Calgon_Washing','127.0.0.1','2011-12-19 08:55:17',1),(27,'Calgon_Washing','127.0.0.1','2011-12-21 06:04:35',1),(28,'Calgon_Washing','127.0.0.1','2011-12-21 06:07:01',1),(29,'Calgon_Washing','127.0.0.1','2011-12-23 06:46:37',1),(30,'Calgon_Washing','127.0.0.1','2011-12-23 07:13:29',1),(31,'Calgon_Washing','127.0.0.1','2011-12-23 07:18:59',1),(32,'Calgon_Washing','127.0.0.1','2011-12-23 07:21:31',1),(33,'Calgon_Washing','127.0.0.1','2011-12-23 07:22:12',1),(34,'Calgon_Washing','127.0.0.1','2011-12-23 07:26:05',1),(35,'Calgon_Washing','127.0.0.1','2011-12-23 07:29:56',1),(36,'Calgon_Washing','127.0.0.1','2011-12-23 07:40:12',1),(37,'Calgon_Washing','127.0.0.1','2011-12-23 07:48:04',1),(38,'Calgon_Washing','127.0.0.1','2011-12-23 07:49:49',1),(39,'Calgon_Washing','127.0.0.1','2011-12-23 07:51:52',1),(40,'Calgon_Washing','127.0.0.1','2011-12-23 07:53:34',1),(41,'Calgon_Washing','127.0.0.1','2011-12-24 11:29:02',1),(42,'Calgon_Washingu','127.0.0.1','2011-12-26 19:26:59',2),(43,'Calgon_Washingd','127.0.0.1','2011-12-26 19:31:26',3),(44,'Calgon_Washing','127.0.0.1','2011-12-27 11:24:20',1),(45,'Calgon_Washing','127.0.0.1','2011-12-27 11:27:36',1),(46,'Calgon_Washing','127.0.0.1','2011-12-27 11:31:33',2),(47,'Calgon_Washing','127.0.0.1','2011-12-27 11:35:01',3),(48,'Calgon_Washing','127.0.0.1','2011-12-27 11:36:46',4),(49,'Calgon_Washing','127.0.0.1','2011-12-27 11:40:40',5),(50,'Calgon_Washing','127.0.0.1','2011-12-27 11:47:14',6),(51,'Calgon_Washingb','127.0.0.1','2011-12-27 11:50:52',7),(52,'Calgon_Washing','127.0.0.1','2011-12-27 11:59:44',1);
/*!40000 ALTER TABLE `playerconnections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playervehicles`
--

DROP TABLE IF EXISTS `playervehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playervehicles` (
  `pvId` int(12) NOT NULL AUTO_INCREMENT,
  `pvModel` int(4) NOT NULL DEFAULT '404',
  `pvOwnerId` int(12) NOT NULL DEFAULT '1',
  `pvPosX` varchar(64) NOT NULL DEFAULT '0.00',
  `pvPosY` varchar(64) NOT NULL DEFAULT '0.00',
  `pvPosZ` varchar(64) NOT NULL DEFAULT '0.00',
  `pvPosZAngle` varchar(64) NOT NULL DEFAULT '0.0000',
  `pvColour1` int(4) NOT NULL DEFAULT '-1',
  `pvColour2` int(4) NOT NULL DEFAULT '-1',
  `pvPaintjob` int(3) NOT NULL DEFAULT '-1',
  `pvStaticPrice` int(12) NOT NULL DEFAULT '1000',
  `pvComponent0` int(6) NOT NULL DEFAULT '0',
  `pvComponent1` int(6) NOT NULL DEFAULT '0',
  `pvComponent2` int(6) NOT NULL DEFAULT '0',
  `pvComponent3` int(6) NOT NULL DEFAULT '0',
  `pvComponent4` int(6) NOT NULL DEFAULT '0',
  `pvComponent5` int(6) NOT NULL DEFAULT '0',
  `pvComponent6` int(6) NOT NULL DEFAULT '0',
  `pvComponent7` int(6) NOT NULL DEFAULT '0',
  `pvComponent8` int(6) NOT NULL DEFAULT '0',
  `pvComponent9` int(6) NOT NULL DEFAULT '0',
  `pvComponent10` int(6) NOT NULL DEFAULT '0',
  `pvComponent11` int(6) NOT NULL DEFAULT '0',
  `pvComponent12` int(6) NOT NULL DEFAULT '0',
  `pvComponent13` int(6) NOT NULL DEFAULT '0',
  `pvSpawned` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pvId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playervehicles`
--

LOCK TABLES `playervehicles` WRITE;
/*!40000 ALTER TABLE `playervehicles` DISABLE KEYS */;
INSERT INTO `playervehicles` VALUES (1,404,1,'518.688537','-1547.015136','15.870270','60.0',-1,-1,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `playervehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehicles` (
  `vehicleID` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleModelID` int(11) NOT NULL DEFAULT '0',
  `vehiclePosX` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosY` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosZ` varchar(255) NOT NULL DEFAULT '0',
  `vehiclePosRotation` varchar(255) NOT NULL DEFAULT '0',
  `vehicleGroup` int(12) NOT NULL DEFAULT '0',
  `vehicleCol1` int(4) NOT NULL DEFAULT '-1',
  `vehicleCol2` int(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`vehicleID`)
) ENGINE=MyISAM AUTO_INCREMENT=228 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,404,'165','-77','1.2322','268.2855',0,-1,-1),(2,404,'211','-66','1.2321','268.2551',0,-1,-1),(3,404,'751.665283','-1389.538452','13.322164','89.495262',0,-1,-1),(4,400,'752.375976','-1432.742797','13.615872','90.580131',0,-1,-1),(5,404,'675.557189','-1418.354858','13.845458','178.619018',0,-1,-1),(6,405,'687.382019','-1389.534912','13.365043','271.115905',0,-1,-1),(7,405,'802.868225','-1357.842163','13.338722','359.030944',0,-1,-1),(8,405,'811.844421','-1448.789306','12.752715','266.710021',0,-1,-1),(9,405,'810.518920','-1464.418334','12.827484','266.651275',0,-1,-1),(10,405,'782.136657','-1615.985351','13.257864','88.584762',0,-1,-1),(11,410,'782.411743','-1622.980102','13.033214','89.784202',0,-1,-1),(12,418,'782.072326','-1637.036865','13.487715','92.873207',0,-1,-1),(13,429,'782.456298','-1605.434814','13.062502','270.049316',0,-1,-1),(14,400,'589.098693','-1353.819091','14.436399','103.056861',0,-1,-1),(15,461,'522.446228','-1351.895996','15.585676','264.098083',0,-1,-1),(16,451,'482.266479','-1496.612182','20.004512','174.294586',0,-1,-1),(17,596,'1595.452270','-1710.411743','5.609890','358.434692',1,0,1),(18,596,'1591.322387','-1710.356445','5.598965','359.526794',1,0,1),(19,596,'1587.505371','-1710.321411','5.604707','0.266475',1,0,1),(20,596,'1583.127929','-1710.242675','5.604492','358.928009',1,0,1),(21,427,'1544.870361','-1651.072753','6.042683','88.367126',1,0,1),(22,475,'1030.952392','-1104.128173','23.632232','176.893142',0,-1,-1),(23,561,'852.338623','-1363.938720','13.369482','181.573944',0,-1,-1),(24,405,'766.683288','-1389.604858','13.436820','269.460906',0,-1,-1),(25,405,'780.082092','-1411.068359','13.332835','270.044647',0,-1,-1),(26,405,'874.151245','-1314.755249','13.337226','268.934844',0,-1,-1),(27,405,'865.696960','-1332.868408','13.337948','87.941444',0,-1,-1),(28,475,'966.693969','-1332.846557','13.309975','268.910430',0,-1,-1),(29,405,'1015.203796','-1363.763183','13.245702','267.853271',0,-1,-1),(30,412,'868.561828','-1590.775634','13.298800','314.721649',0,-1,-1),(31,405,'1339.341430','-1764.749267','13.407732','357.629760',0,-1,-1),(32,440,'1362.034423','-1658.919677','13.503669','271.589874',0,-1,-1),(33,483,'809.874145','-1815.177001','13.016591','89.257255',0,-1,-1),(34,404,'781.674987','-1788.679199','12.839591','86.136375',0,-1,-1),(35,405,'789.782226','-1763.330688','13.150688','266.846008',0,-1,-1),(36,496,'734.857604','-1581.064819','14.031931','90.799415',0,-1,-1),(37,547,'803.586914','-1542.447753','13.293317','267.514129',0,-1,-1),(38,496,'847.095031','-1503.018920','12.727922','177.142959',0,-1,-1),(39,496,'841.921630','-1502.850219','12.684292','175.866439',0,-1,-1),(40,496,'829.981323','-1501.607543','12.783299','177.448394',0,-1,-1),(41,462,'761.949951','-1461.084594','12.609677','185.311187',0,-1,-1),(42,560,'1108.676391','-1024.857299','31.608118','0.412980',0,-1,-1),(43,572,'-77.587341','-1607.466186','2.699387','119.226287',0,-1,-1),(44,508,'-81.042747','-1571.015991','2.985532','354.378753',0,-1,-1),(45,467,'337.728454','-1788.965698','4.626303','0.043815',0,-1,-1),(46,579,'321.221862','-1809.746948','4.397583','180.312911',0,-1,-1),(47,500,'350.318176','-1809.728759','4.193988','179.361740',0,-1,-1),(48,574,'370.419097','-1783.308593','5.217405','90.367225',0,-1,-1),(49,462,'384.137969','-1745.624145','8.529071','355.805847',0,-1,-1),(50,480,'575.651672','-1742.610107','12.747517','261.400573',0,-1,-1),(51,426,'642.032714','-1704.480957','14.340312','348.428344',0,-1,-1),(52,560,'654.571166','-1657.363647','14.260266','271.046783',0,-1,-1),(53,437,'598.897521','-1509.435546','15.221081','89.172615',0,-1,-1),(54,458,'837.172668','-1135.490844','23.615922','90.499725',0,-1,-1),(55,404,'1015.559143','-1358.845458','13.106759','273.677246',0,-1,-1),(56,560,'1099.024902','-1775.521850','13.049141','88.971397',0,-1,-1),(57,405,'1098.918945','-1754.956176','13.226701','269.940429',0,-1,-1),(58,426,'1062.231567','-1740.304931','13.214911','90.694374',0,-1,-1),(59,550,'1062.374877','-1760.858886','13.222027','89.649948',0,-1,-1),(60,440,'1062.748779','-1775.515869','13.468499','269.653259',0,-1,-1),(61,404,'1042.881347','-1659.245483','13.192656','0.370968',0,-1,-1),(62,420,'1746.279052','-1858.853271','13.194557','89.215812',0,-1,-1),(63,543,'1841.270996','-1871.105834','13.206789','0.598140',0,-1,-1),(64,440,'2445.408935','-1763.193847','13.702497','359.204681',0,-1,-1),(65,468,'2450.423828','-1795.969970','14.053714','352.568481',0,-1,-1),(66,463,'2296.221435','-1646.627929','14.345527','90.189559',0,-1,-1),(67,463,'2295.840820','-1643.168212','14.334943','93.815551',0,-1,-1),(68,463,'2296.114257','-1639.615722','14.301908','92.151947',0,-1,-1),(69,567,'2369.559570','-1530.199096','23.776443','268.999572',0,-1,-1),(70,452,'728.129272','-1493.830200','-0.526360','181.436080',0,-1,-1),(71,473,'718.719787','-1492.688842','-0.391828','181.919418',0,-1,-1),(72,515,'1922.245849','-1799.496093','14.568037','91.002204',0,-1,-1),(73,475,'1912.929443','-1873.734130','13.346440','1.256161',0,-1,-1),(74,596,'1578.709716','-1710.332519','5.605350','0.468142',1,0,1),(75,596,'1574.381347','-1710.466918','5.603787','358.604614',1,0,1),(76,497,'1564.470947','-1700.056884','28.567625','89.027664',1,-1,-1),(77,497,'2492.684814','-1477.251098','33.663585','288.261138',1,-1,-1),(78,475,'342.352935','-1649.782104','33.034633','261.553283',0,3,3),(79,601,'1545.697143','-1663.158325','5.672533','88.610504',1,0,0),(80,601,'1545.757080','-1667.983398','5.680265','93.104125',1,-1,-1),(81,601,'1545.703979','-1672.054687','5.649398','89.590744',1,-1,-1),(82,528,'1546.054199','-1676.117065','5.934583','88.693527',1,-1,-1),(83,528,'1546.057861','-1680.451782','5.937458','89.301239',1,-1,-1),(84,528,'1546.054077','-1684.632934','5.934979','90.645957',1,-1,-1),(85,427,'1544.868164','-1654.947265','6.040959','88.693794',1,0,1),(86,427,'1544.784667','-1659.093261','6.042477','89.030929',1,0,1),(87,596,'1570.402709','-1710.572998','5.611326','0.079130',1,0,1),(88,566,'2006.730712','-1130.475097','25.006479','271.781158',0,-1,-1),(89,566,'2047.274902','-1130.184082','23.859603','269.242675',0,-1,-1),(90,566,'2132.037841','-1107.403930','25.059555','253.565765',0,-1,-1),(91,579,'2148.029052','-1175.634765','23.750961','89.973327',0,-1,-1),(92,579,'2162.174072','-1192.469238','23.751901','268.029907',0,-1,-1),(93,566,'2162.412841','-1153.052856','23.710971','269.728210',0,-1,-1),(94,405,'2148.456298','-1138.475097','25.366859','87.989265',0,-1,-1),(95,405,'2228.833740','-1163.266723','25.650917','269.607788',0,-1,-1),(96,567,'2205.750976','-1160.755004','25.602447','87.242446',0,-1,-1),(97,536,'2228.620849','-1170.344726','25.480102','268.830261',0,-1,-1),(98,536,'2205.360595','-1173.072509','25.466541','89.162956',0,-1,-1),(99,534,'2217.280517','-1166.314453','25.450433','269.658752',0,-1,-1),(100,534,'2216.413574','-1157.495361','25.450048','270.693450',0,-1,-1),(101,510,'2278.103759','-1169.629638','25.893653','222.274871',0,-1,-1),(102,405,'2347.259277','-1245.461303','22.374910','270.945434',0,-1,-1),(103,542,'2376.562011','-1280.603637','23.655597','178.966125',0,-1,-1),(104,542,'2358.144531','-1360.423339','23.763486','92.530906',0,-1,-1),(105,536,'2376.672607','-1299.964111','23.647462','179.866744',0,-1,-1),(106,468,'2410.878906','-1311.159545','24.220138','356.263610',0,-1,-1),(107,422,'2398.801269','-1309.187255','25.490083','91.011291',0,-1,-1),(108,474,'2429.805419','-1223.059082','25.090261','177.043380',0,-1,-1),(109,575,'2428.582031','-1243.364624','23.743181','357.442718',0,-1,-1),(110,542,'2445.245117','-1274.621582','23.652658','179.666137',0,-1,-1),(111,468,'2493.012695','-1298.126342','32.383800','266.937286',0,-1,-1),(112,509,'2460.615478','-1277.365234','23.509323','358.449066',0,-1,-1),(113,536,'2478.388916','-1336.938110','27.334846','181.378967',0,-1,-1),(114,542,'2432.583496','-1370.271118','24.225345','85.998558',0,-1,-1),(115,542,'2445.390380','-1419.317260','23.648374','179.402099',0,-1,-1),(116,543,'2465.221923','-1424.597534','23.567634','270.135528',0,-1,-1),(117,542,'2570.943115','-1490.339721','23.759757','265.611328',0,-1,-1),(118,466,'2517.191894','-1672.530029','13.795278','62.281379',0,-1,-1),(119,492,'2510.002685','-1665.563110','13.270333','10.099714',0,-1,-1),(120,604,'2510.781494','-1469.573364','23.765993','268.307556',0,-1,-1),(121,413,'2534.973632','-1474.220825','24.079555','88.875686',0,-1,-1),(122,402,'2447.528076','-1557.215820','23.831733','91.600372',0,-1,-1),(123,521,'2405.421875','-1535.638061','23.565990','1.178117',0,-1,-1),(124,475,'2390.673095','-1506.840332','23.639503','89.398071',0,-1,-1),(125,421,'2390.492919','-1493.970581','23.715665','89.216384',0,-1,-1),(126,510,'2308.141845','-1545.844970','25.033649','239.483749',0,-1,-1),(127,492,'2468.376953','-1670.513305','13.175024','189.761352',0,-1,-1),(128,518,'2481.380371','-1653.149047','13.058115','90.058456',0,-1,-1),(129,600,'2473.172119','-1702.886718','13.237924','358.593688',0,-1,-1),(130,418,'2493.797851','-1755.040527','13.580317','359.122863',0,-1,-1),(131,462,'2468.805419','-1755.473144','13.143450','270.610961',0,-1,-1),(132,600,'2416.516357','-1712.522094','13.473533','359.175598',0,-1,-1),(133,401,'2353.847656','-1754.004150','13.241666','271.929016',0,-1,-1),(134,463,'2295.876953','-1635.701293','14.272754','82.320091',0,-1,-1),(135,586,'2296.032226','-1631.398071','14.223673','86.539810',0,-1,-1),(136,554,'2239.489013','-1630.693603','15.786031','337.053863',0,-1,-1),(137,602,'2159.134765','-1805.201782','13.184434','89.954452',0,-1,-1),(138,448,'2118.785888','-1784.506103','12.982527','178.940704',0,-1,-1),(139,448,'2109.709472','-1784.598754','12.981993','180.909713',0,-1,-1),(140,405,'415.335296','-1229.404174','51.382884','106.621589',0,28,63),(141,482,'2094.639160','-1817.445190','13.503071','269.610656',0,-1,-1),(142,603,'2065.695556','-1903.580200','13.385325','0.183454',0,-1,-1),(143,587,'2062.125976','-1919.732666','13.271661','179.336608',0,-1,-1),(144,581,'2261.998535','-1695.998657','13.326378','171.965576',0,-1,-1),(145,535,'1981.110351','-1985.329101','13.309557','179.242935',0,-1,-1),(146,491,'1980.675170','-1995.683227','13.310117','1.006582',0,-1,-1),(147,405,'1938.382080','-2086.348876','13.438286','89.860298',0,-1,-1),(148,481,'1938.383911','-1985.967285','13.063698','231.385543',0,-1,-1),(149,561,'1937.934814','-2080.131103','13.373329','270.411834',0,-1,-1),(150,555,'1947.735839','-2113.987304','13.230031','88.903961',0,-1,-1),(151,558,'1947.536254','-2123.651123','13.176467','88.518463',0,-1,-1),(152,405,'1938.324096','-2141.958496','13.436142','359.297760',0,-1,-1),(153,487,'1955.410034','-2646.498535','13.702231','1.520841',0,-1,-1),(154,487,'1963.766845','-2647.876708','13.714962','358.484558',0,-1,-1),(155,487,'1973.071777','-2647.945800','13.717036','352.316680',0,-1,-1),(156,485,'1963.754272','-2610.601806','13.200948','88.439674',0,-1,-1),(157,593,'1615.942626','-2629.725341','14.092255','357.986083',0,-1,-1),(158,577,'1933.041748','-2377.893798','13.439205','176.714843',0,101,112),(159,519,'1890.380004','-2627.763671','14.451828','358.420501',0,-1,-1),(160,513,'1822.243774','-2633.044921','14.079403','354.030181',0,-1,-1),(161,469,'1760.458740','-2629.542968','14.134824','0.590342',0,-1,-1),(162,511,'1684.139892','-2628.005615','14.921717','0.000000',0,-1,-1),(163,485,'1655.062988','-2538.219726','13.203288','88.035346',0,-1,-1),(164,485,'1652.384277','-2547.680908','13.201418','88.283134',0,-1,-1),(165,536,'1698.992919','-2093.838134','13.284269','358.962585',0,-1,-1),(166,567,'1667.954467','-2113.279785','13.414836','88.697029',0,-1,-1),(167,482,'1705.017700','-2129.666992','13.664293','178.141006',0,-1,-1),(168,535,'1744.597534','-2136.259765','13.310214','179.287673',0,-1,-1),(169,468,'1780.279541','-2146.582275','13.220867','196.641967',0,-1,-1),(170,534,'1793.325317','-2149.065917','13.337731','180.350280',0,-1,-1),(171,438,'1800.796508','-1931.982421','13.391670','179.739791',0,-1,-1),(172,404,'1804.165771','-1912.059570','13.129108','270.620788',0,-1,-1),(173,438,'1793.115356','-1932.338745','13.390651','178.191467',0,-1,-1),(174,438,'1786.340087','-1932.312988','13.388663','178.055755',0,-1,-1),(175,438,'1779.057373','-1932.885498','13.388607','178.138778',0,-1,-1),(176,588,'1762.483276','-1895.911376','13.468975','220.351379',0,-1,-1),(177,475,'1804.003540','-1907.683105','13.211242','265.723907',0,0,1),(178,585,'1836.886840','-1853.893554','12.973378','179.445556',0,-1,-1),(179,410,'1599.250122','-1814.865478','13.077863','89.297950',0,-1,-1),(180,489,'1656.504760','-1820.552856','13.690002','89.079689',0,-1,-1),(181,604,'1303.373901','-1249.778930','13.291378','181.637954',0,-1,-1),(182,554,'1265.687866','-1240.358642','16.625320','240.255584',0,-1,-1),(183,605,'1238.209228','-1264.608276','13.207221','268.129058',0,-1,-1),(184,527,'1134.175537','-1342.338256','13.488230','180.729797',0,-1,-1),(185,518,'1156.375488','-1228.114135','16.762702','0.720550',0,-1,-1),(186,482,'1092.807983','-1226.072875','15.933856','1.331722',0,-1,-1),(187,442,'922.836242','-1107.243164','24.097713','268.129882',0,0,50),(188,409,'877.437805','-929.255065','42.451271','120.644195',0,-1,-1),(189,428,'604.352050','-1283.441528','16.041818','281.453521',0,-1,-1),(190,466,'213.975784','-1774.974243','3.632672','90.403160',0,-1,-1),(191,468,'-93.615974','-1561.525634','2.278604','133.723510',0,-1,-1),(192,473,'-17.994480','-1576.918579','-0.311673','143.387817',0,-1,-1),(193,478,'-72.086891','-1183.310668','1.743297','334.601745',0,-1,-1),(194,598,'1601.936645','-1703.951171','5.652599','89.763504',1,0,1),(195,598,'1602.068115','-1700.046997','5.656033','87.696670',1,0,1),(196,598,'1601.900390','-1691.950073','5.661239','89.544853',1,0,1),(197,598,'1601.878784','-1688.057373','5.657492','89.232452',1,0,1),(198,598,'1601.864990','-1683.951293','5.661933','91.067909',1,0,1),(199,599,'1585.081909','-1671.935546','6.092749','268.033691',1,0,1),(200,599,'1585.126831','-1667.761840','6.090360','271.570037',1,0,1),(201,523,'1561.716918','-1713.487915','5.460953','0.894876',1,0,0),(202,523,'1564.358032','-1713.288452','5.456365','2.918209',1,0,0),(203,523,'1566.673339','-1713.478271','5.450061','0.000000',1,0,0),(204,523,'1561.871582','-1709.642456','5.472393','4.760974',1,0,0),(205,523,'1564.233032','-1709.821166','5.460930','5.982583',1,0,0),(206,523,'1566.612304','-1709.650024','5.456602','2.981255',1,0,0),(207,598,'1602.192626','-1695.840332','5.635756','89.169677',1,0,1),(208,405,'2607.853515','-2199.597900','13.421837','179.172424',0,-1,-1),(209,462,'2479.193115','-2240.101318','13.144433','177.881164',0,-1,-1),(210,462,'2476.264404','-2239.816162','13.143652','177.103347',0,-1,-1),(211,552,'2546.595458','-2488.053466','13.336634','359.073913',0,-1,-1),(212,470,'2788.127441','-2456.916259','13.627800','88.069335',0,-1,-1),(213,462,'2472.218750','-2239.428222','13.145025','174.556442',0,-1,-1),(214,482,'2528.177001','-2010.362915','13.672184','267.463714',0,-1,-1),(215,502,'2757.459472','-1876.182373','9.594129','178.667373',0,-1,-1),(216,602,'2776.788574','-1840.178222','9.587071','19.632228',0,-1,-1),(217,522,'1794.828369','-1431.360107','13.056793','287.765045',0,-1,-1),(218,588,'1026.492675','-1872.626708','12.955672','89.538612',0,-1,-1),(219,525,'1558.769775','-1710.871582','5.766008','0.815397',1,79,0),(220,454,'376.747528','-2148.755371','0.034113','186.947570',0,-1,-1),(221,453,'351.653839','-2137.700195','-0.392954','103.374656',0,-1,-1),(222,453,'338.139556','-2161.123046','-0.208551','146.548873',0,-1,-1),(223,608,'1936.943359','-2397.021240','14.071707','85.179031',0,-1,-1),(224,490,'1656.324096','-1715.598388','15.738873','178.092437',3,0,0),(225,490,'1662.082153','-1715.333374','15.735816','177.897216',3,0,0),(226,415,'1668.477783','-1703.375976','15.381911','271.928283',3,0,0),(227,415,'1668.179443','-1698.766113','15.380616','270.662384',3,0,0);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-01-10 17:43:39
