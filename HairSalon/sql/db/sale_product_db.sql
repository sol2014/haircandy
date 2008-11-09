DROP TABLE IF EXISTS `saleproduct`;
CREATE TABLE saleproduct
(
	`transaction_no` BIGINT(20) UNSIGNED NOT NULL,
	`product_no` BIGINT(20) UNSIGNED NOT NULL,

	`amount` INTEGER,

	CONSTRAINT `sp_transaction_no_fk` FOREIGN KEY (`transaction_no`) REFERENCES sale(`transaction_no`),
	CONSTRAINT `product_no_fk` FOREIGN KEY(`product_no`) REFERENCES product(`product_no`),
	PRIMARY KEY (`transaction_no`, `product_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `saleproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `saleproduct` ENABLE KEYS */;