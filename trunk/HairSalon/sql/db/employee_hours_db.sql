DROP TABLE IF EXISTS `employeehours`;
CREATE TABLE employeehours
(
	`employee_no` BIGINT(20) NOT NULL,
	`date` DATE NOT NULL,
	
	`start_time` TIME NOT NULL,
	`end_time` TIME NOT NULL,
	
	PRIMARY KEY (`date`, `employee_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
