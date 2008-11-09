DROP TABLE IF EXISTS `employeeservice`;
CREATE TABLE employeeservice
(
	`employee_no` BIGINT(20) UNSIGNED NOT NULL,
	`service_no` BIGINT(20) UNSIGNED NOT NULL,
	
	CONSTRAINT `employee_no_fk` FOREIGN KEY(`employee_no`) REFERENCES employee(`employee_no`),
	CONSTRAINT `service_no_fk` FOREIGN KEY(`service_no`) REFERENCES service(`service_no`),
	PRIMARY KEY (`employee_no`, `service_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `employeeservice` DISABLE KEYS */;
/*!40000 ALTER TABLE `employeeservice` ENABLE KEYS */;