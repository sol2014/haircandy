delimiter //

DROP PROCEDURE IF EXISTS LoadService//

CREATE PROCEDURE LoadService (IN p_service_no BIGINT(20))
BEGIN
	SELECT * FROM service
		WHERE service_no = p_service_no;

	SELECT * FROM serviceproduct lnk
		JOIN `product` p ON lnk.`product_no` = p.`product_no`
		WHERE lnk.`service_no` = p_service_no;
END
//

DROP PROCEDURE IF EXISTS SearchService//

CREATE PROCEDURE SearchService (IN p_name VARCHAR(15),
						  IN p_description VARCHAR(150),
						  IN p_duration SMALLINT,
						  IN p_price DECIMAL(5,2),
						  IN p_enabled BOOLEAN)
BEGIN 
    SELECT * from service
		WHERE ((p_name IS NULL) OR (name LIKE CONCAT("%",p_name,"%")))
		AND ((p_description IS NULL) OR (description LIKE CONCAT("%",p_description,"%")))
		AND ((p_duration IS NULL) OR (duration = p_duration))
		AND ((p_price IS NULL) OR (price = p_price))
		AND ((p_enabled IS NULL) OR (enabled = p_enabled))
		ORDER BY name ASC;
END
//

DROP PROCEDURE IF EXISTS CreateService//

CREATE PROCEDURE CreateService(IN p_name VARCHAR(15),
				IN p_description VARCHAR(150),
                IN p_duration SMALLINT,
				IN p_price DECIMAL(5,2),
				IN p_enabled BOOLEAN, OUT p_key BIGINT(20))
BEGIN
    INSERT INTO service(name,description,duration,price,enabled)
    VALUES(p_name,p_description,p_duration,p_price,p_enabled);
	
	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS AddServiceProduct//

CREATE PROCEDURE AddServiceProduct (IN p_service_no BIGINT(20), IN p_product_no BIGINT(20), IN p_amount INTEGER)
BEGIN
    INSERT INTO serviceproduct (service_no, product_no, amount) VALUES (p_service_no, p_product_no, p_amount);
END
//

DROP PROCEDURE IF EXISTS DeleteServiceProducts//

CREATE PROCEDURE DeleteServiceProducts (IN p_service_no BIGINT(20))
BEGIN
    DELETE FROM serviceproduct
    WHERE service_no = p_service_no;
END
//

DROP PROCEDURE IF EXISTS UpdateService//

CREATE PROCEDURE UpdateService(IN p_service_no BIGINT(20),
							   IN p_name VARCHAR(15),
							   IN p_description VARCHAR(150),
							   IN p_duration SMALLINT,
								IN p_price DECIMAL(5,2),
								IN p_enabled BOOLEAN)
BEGIN
	UPDATE service
	SET name = p_name,
		description = p_description,
		duration = p_duration,
		price = p_price,
		enabled = p_enabled
	WHERE service_no = p_service_no;
END
//

DROP PROCEDURE IF EXISTS DeleteService//

CREATE PROCEDURE DeleteService(IN p_service_no BIGINT(20))
BEGIN
    DELETE FROM service
    WHERE service_no = p_service_no;
END
//

delimiter ;