DROP TABLE IF EXISTS `sale`;
CREATE TABLE sale
(
	`transaction_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`client_no` BIGINT(20) UNSIGNED NOT NULL,
	`employee_no` BIGINT(20) UNSIGNED NOT NULL,
	`payment_type` VARCHAR(10) NOT NULL,
	`total_due` DECIMAL(9,2),
	`total_tax` DECIMAL(9,2),
	`discount` TINYINT,
	`is_complete` BOOLEAN,
	`is_void` BOOLEAN,
	`payment` DECIMAL(9,2),
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT `client_sale_no_fk` FOREIGN KEY(`client_no`) REFERENCES client(`client_no`),
	CONSTRAINT `employee_sale_no_fk` FOREIGN KEY(`employee_no`) REFERENCES employee(`employee_no`),
	PRIMARY KEY (`transaction_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;
