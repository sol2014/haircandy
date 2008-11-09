DROP TABLE IF EXISTS `availabilityexception`;
CREATE TABLE availabilityexception
(
	`employee_no` BIGINT(20) UNSIGNED NOT NULL,
	`date` DATE NOT NULL,
	`reason` VARCHAR(150),
	
	CONSTRAINT `employee_no_fk` FOREIGN KEY (`employee_no`) REFERENCES employee(`employee_no`),
	PRIMARY KEY (`employee_no`, `date`)
)TYPE=MYISAM;

/*!40000 ALTER TABLE `availabilityexception` DISABLE KEYS */;
/*!40000 ALTER TABLE `availabilityexception` ENABLE KEYS */;
