DROP TABLE IF EXISTS `employee`;
CREATE TABLE employee
(
    `employee_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
    
	`address_no` BIGINT(20) UNSIGNED NOT NULL,
	`password` VARCHAR(15) NOT NULL,
	`first_name` VARCHAR(25) NOT NULL,
	`last_name` VARCHAR(25) NOT NULL,
	`phone_number` VARCHAR(10),
	`role` VARCHAR(15),
	`enabled` BOOLEAN,
	
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
	`sunday_end` TIME NOT NULL,

	CONSTRAINT `address_no_fk` FOREIGN KEY(`address_no`) REFERENCES address(`address_no`),
	PRIMARY KEY (`employee_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;