DROP TABLE IF EXISTS `salon`;
CREATE TABLE `salon`
(
	`name` VARCHAR(50) NOT NULL,
	`address1` VARCHAR(50),
	`address2` VARCHAR(50),
	`city` VARCHAR(15),
	`province` VARCHAR(15),
	`country` VARCHAR(15),
	`postal_code` VARCHAR(6),
	`phone_number` VARCHAR(10),
	`email` VARCHAR(50),
	`tax_rate` DECIMAL(2,2) NOT NULL,
	`monday_start` TIME NOT NULL,
	`monday_end` TIME NOT NULL,
	`tuesday_start` TIME NOT NULL,
	`tuesday_end` TIME NOT NULL,
	`wednesday_start` TIME NOT NULL,
	`wednesday_end` TIME NOT NULL,
	`thursday_start` TIME NOT NULL,
	`thursday_end` TIME NOT NULL,
	`friday_start` TIME NOT NULL,
	`friday_end` TIME NOT NULL,
	`saturday_start` TIME NOT NULL,
	`saturday_end` TIME NOT NULL,
	`sunday_start` TIME NOT NULL,
	`sunday_end` TIME NOT NULL
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `salon` DISABLE KEYS */;
/*!40000 ALTER TABLE `salon` ENABLE KEYS */;
