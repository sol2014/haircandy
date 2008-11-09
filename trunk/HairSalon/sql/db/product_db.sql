DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`
(
	`product_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`brand` VARCHAR(25) NOT NULL,
	`product_name` VARCHAR(25) NOT NULL,
	`product_type` VARCHAR(25),
	`stock_qty` INTEGER NOT NULL, 
	`min_level` INTEGER  NOT NULL,
	`qty_per` INTEGER NOT NULL, 
	`price` DECIMAL(9,2) NOT NULL, 
	`unit` VARCHAR(5) NOT NULL, 
	`enabled` BOOLEAN,
	
	PRIMARY KEY (`product_no`)
)ENGINE=MyISAM;

/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;