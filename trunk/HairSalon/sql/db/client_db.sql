DROP TABLE IF EXISTS `client`;
CREATE TABLE client
(
	`client_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	`first_name` VARCHAR(15) NOT NULL,
	`last_name` VARCHAR(15) NOT NULL,
	`address_no` BIGINT(20) UNSIGNED NOT NULL,	
	`phone_number` VARCHAR(10) NOT NULL,
	`enabled` BOOLEAN,
	
	CONSTRAINT `client_address_no_fk` FOREIGN KEY (`address_no`) REFERENCES address(`address_no`),	
	PRIMARY KEY (`client_no`),
	UNIQUE KEY (`phone_number`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `client` DISABLE KEYS */;
/*!40000 ALTER TABLE `client` ENABLE KEYS */;