DROP TABLE IF EXISTS `saleservice`;
CREATE TABLE saleservice
(
	`transaction_no` BIGINT(20) UNSIGNED NOT NULL,
	`service_no` BIGINT(20) UNSIGNED NOT NULL,
	
	`amount` INTEGER,
    
	CONSTRAINT `ss_transaction_no_fk` FOREIGN KEY (`transaction_no`) REFERENCES sale(`transaction_no`),
	CONSTRAINT `service_no_fk` FOREIGN KEY(`service_no`) REFERENCES service(`service_no`),
	PRIMARY KEY (`transaction_no`, `service_no`)
)TYPE=MYISAM;

/*!40000 ALTER TABLE `saleservice` DISABLE KEYS */;
/*!40000 ALTER TABLE `saleservice` ENABLE KEYS */;