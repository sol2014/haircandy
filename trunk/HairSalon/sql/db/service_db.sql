DROP TABLE IF EXISTS `service`;
CREATE TABLE service
(
	`service_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	
	`name` VARCHAR(15) NOT NULL,
	`description` VARCHAR(150),
	`duration` SMALLINT(2),
	`price` DECIMAL(4,2) NOT NULL, 
	`enabled` BOOLEAN,
	
	PRIMARY KEY (`service_no`)
)TYPE=MyISAM;

/*!40000 ALTER TABLE `service` DISABLE KEYS */;
/*!40000 ALTER TABLE `service` ENABLE KEYS */;