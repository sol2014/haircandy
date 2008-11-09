DROP TABLE IF EXISTS `serviceproduct`;
CREATE TABLE serviceproduct
(
	`product_no` BIGINT(20) UNSIGNED NOT NULL,
	`service_no` BIGINT(20) UNSIGNED NOT NULL,
	
	`amount` INTEGER,
	
	CONSTRAINT `product_no_fk` FOREIGN KEY(`product_no`) REFERENCES product(`product_no`),
	CONSTRAINT `service_no_fk` FOREIGN KEY(`service_no`) REFERENCES service(`service_no`),
	PRIMARY KEY (`product_no`, `service_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `serviceproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `serviceproduct` ENABLE KEYS */;