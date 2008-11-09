DROP TABLE IF EXISTS `appointmentproduct`;
CREATE TABLE appointmentproduct
(
	`appointment_no` BIGINT(20) UNSIGNED NOT NULL,
	`product_no` BIGINT(20) UNSIGNED NOT NULL,
	
	`amount` INTEGER,
	
	CONSTRAINT `appointment_no_fk` FOREIGN KEY (`appointment_no`) REFERENCES appointment(`appointment_no`),
	CONSTRAINT `product_no_fk` FOREIGN KEY(`product_no`) REFERENCES product(`product_no`),
	PRIMARY KEY (`appointment_no`, `product_no`)
)TYPE=MYISAM;

/*!40000 ALTER TABLE `appointmentproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointmentproduct` ENABLE KEYS */;