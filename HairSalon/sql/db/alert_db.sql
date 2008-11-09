DROP TABLE IF EXISTS `alert`;
CREATE TABLE alert
(
	`alert_no` BIGINT(20) UNSIGNED NOT NULL auto_increment,
	`alert_type` VARCHAR(10) NOT NULL,
	`level` VARCHAR(10) NOT NULL,
	`date` DATE NOT NULL,
	`message` VARCHAR(250) NOT NULL,
	`link` VARCHAR(250),
	`record_no` BIGINT(20),
	
	PRIMARY KEY (`alert_no`)
)ENGINE=MyISAM;
