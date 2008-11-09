DROP TABLE IF EXISTS `address`;
CREATE TABLE address
(
	`address_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`address1` VARCHAR(50),
	`address2` VARCHAR(50),
	`city` VARCHAR(15),
        `province` VARCHAR(15),
	`country` VARCHAR(15),
	`postal_code` VARCHAR(6),
	`email` VARCHAR(50),
	
	PRIMARY KEY (`address_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;