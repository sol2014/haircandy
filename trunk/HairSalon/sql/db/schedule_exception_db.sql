DROP TABLE IF EXISTS `scheduleexception`;
CREATE TABLE scheduleexception
(
	`date` DATE NOT NULL,
	`reason` VARCHAR(150),
	
	PRIMARY KEY (`date`)
)TYPE=MYISAM;

/*!40000 ALTER TABLE `scheduleexception` DISABLE KEYS */;
/*!40000 ALTER TABLE `scheduleexception` ENABLE KEYS */;