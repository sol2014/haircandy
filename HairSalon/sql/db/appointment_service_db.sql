DROP TABLE IF EXISTS `appointmentservice`;
CREATE TABLE appointmentservice
(
	`appointment_no` BIGINT(20) UNSIGNED NOT NULL,
	`service_no` BIGINT(20) UNSIGNED NOT NULL,
	
	`amount` INTEGER,

	CONSTRAINT `appointment_ser_no_fk` FOREIGN KEY (`appointment_no`) REFERENCES appointment(`appointment_no`),
	CONSTRAINT `service_no_fk` FOREIGN KEY(`service_no`) REFERENCES service(`service_no`),
	PRIMARY KEY (`appointment_no`, `service_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `appointmentservice` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointmentservice` ENABLE KEYS */;