DROP TABLE IF EXISTS `schedule`;
CREATE TABLE schedule
(
	`schedule_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`employee_no` BIGINT(20) UNSIGNED NOT NULL,
	`date` DATE NOT NULL,
	`start_time` TIME NOT NULL,
	`end_time` TIME NOT NULL,
	
	CONSTRAINT `employee_sch_no_fk` FOREIGN KEY(`employee_no`) REFERENCES employee(`employee_no`),
	PRIMARY KEY (`schedule_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;