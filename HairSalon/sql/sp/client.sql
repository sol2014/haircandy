/*
author Nuha Bazara
*/
delimiter //

DROP PROCEDURE IF EXISTS LoadClient//

CREATE PROCEDURE LoadClient (IN p_client_no BIGINT)
BEGIN
	SELECT * FROM client
		WHERE client_no = p_client_no;
END
//

DROP PROCEDURE IF EXISTS SearchClient//

CREATE PROCEDURE SearchClient (IN p_first_name VARCHAR(15),
                                IN p_last_name VARCHAR(15),
                                IN p_phone_number VARCHAR(10),
								IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
                                IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50),
								IN p_enabled Boolean)
BEGIN
    SELECT * FROM client
		WHERE ( address_no IN (
			SELECT address_no FROM `address`
                WHERE ((p_address1 IS NULL) OR (address1 LIKE CONCAT("%",p_address1,"%")))
				AND ((p_address2 IS NULL) OR (address2 LIKE CONCAT("%",p_address2,"%")))
				AND ((p_city IS NULL) OR (city LIKE CONCAT("%",p_city,"%")))
				AND ((p_province IS NULL) OR (province LIKE CONCAT("%",p_province,"%")))
				AND ((p_country IS NULL) OR (country LIKE CONCAT("%",p_country,"%")))
				AND ((p_postal_code IS NULL) OR (postal_code LIKE CONCAT("%",p_postal_code,"%")))
				AND ((p_email IS NULL) OR (email LIKE CONCAT("%",p_email,"%"))) ) )
		AND ((p_first_name IS NULL) OR (first_name LIKE CONCAT("%",p_first_name,"%")))
		AND ((p_last_name IS NULL) OR (last_name LIKE CONCAT("%",p_last_name,"%")))
		AND ((p_phone_number IS NULL) OR (phone_number LIKE CONCAT("%",p_phone_number,"%")))
		AND ((p_enabled IS NULL ) OR (enabled = p_enabled))
		ORDER BY last_name ASC;
END
//

DROP PROCEDURE IF EXISTS CreateClient//

CREATE PROCEDURE CreateClient (IN p_first_name VARCHAR(15),
                                 IN p_last_name VARCHAR(15),
                                 IN p_address_no BIGINT(20),
                                 IN p_phone_number VARCHAR(10),
									IN p_enabled Boolean,
									OUT p_key BIGINT(20))
BEGIN
    INSERT INTO client (first_name, last_name, address_no, phone_number,enabled)
    VALUES (p_first_name, p_last_name, p_address_no, p_phone_number,p_enabled);

	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS UpdateClient//

CREATE PROCEDURE UpdateClient (IN p_client_no BIGINT(20),
                                IN p_first_name VARCHAR(15),
                                IN p_last_name VARCHAR(15),
                                IN p_address_no BIGINT(20),
                                IN p_phone_number VARCHAR(10),
								IN p_enabled Boolean)
BEGIN
	UPDATE client
	SET first_name = p_first_name,
            last_name = p_last_name,
            address_no = p_address_no,
            phone_number = p_phone_number,
			enabled = p_enabled
	WHERE client_no = p_client_no;
END
//

DROP PROCEDURE IF EXISTS DeleteClient//

CREATE PROCEDURE DeleteClient(IN p_client_no BIGINT(20))
BEGIN 
    DELETE FROM client
    WHERE client_no = p_client_no;
END
//

delimiter ;