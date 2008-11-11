DROP TABLE IF EXISTS `schedulehours`;
CREATE TABLE schedulehours
(
	`date` DATE NOT NULL,
	
	`start_time` TIME NOT NULL,
	`end_time` TIME NOT NULL,
	
	PRIMARY KEY (`date`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;