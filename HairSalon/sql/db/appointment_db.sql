DROP TABLE IF EXISTS `appointment`;
CREATE TABLE appointment
(
	`appointment_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`client_no` BIGINT(20) UNSIGNED NOT NULL,
	`employee_no` BIGINT(20) UNSIGNED NOT NULL,
	`ap_date` DATE,
	`start_time` TIME,
	`end_time` TIME,
	`is_complete` BOOLEAN,
	
	CONSTRAINT `client_appointment_no_fk` FOREIGN KEY(`client_no`) REFERENCES client(`client_no`),
	CONSTRAINT `employee_appointment_no_fk` FOREIGN KEY(`employee_no`) REFERENCES employee(`employee_no`),
	PRIMARY KEY (`appointment_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;