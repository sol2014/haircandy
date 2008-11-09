DROP TABLE IF EXISTS `supplier`;
CREATE TABLE supplier
(
	`supplier_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	`address_no` BIGINT(20) UNSIGNED NOT NULL,
	`supplier_name` VARCHAR(50) NOT NULL,
	`description` VARCHAR(150),
	`phone_number` VARCHAR(10),
	`enabled` BOOLEAN,
	
	CONSTRAINT `address_no_fk` FOREIGN KEY(`address_no`) REFERENCES address(`address_no`),
	PRIMARY KEY (`supplier_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;

