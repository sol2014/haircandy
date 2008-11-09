DROP TABLE IF EXISTS `supplierproduct`;
CREATE TABLE supplierproduct
(
	`supplier_no` BIGINT(20) UNSIGNED NOT NULL,
	`product_no`  BIGINT(20) UNSIGNED NOT NULL,
	
	CONSTRAINT `supplier_no_fk` FOREIGN KEY(`supplier_no`) REFERENCES supplier(`supplier_no`),
	CONSTRAINT `product_no_fk` FOREIGN KEY(`product_no`) REFERENCES product(`product_no`),
	PRIMARY KEY (`supplier_no`, `product_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `supplierproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplierproduct` ENABLE KEYS */;