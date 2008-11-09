delimiter //

DROP PROCEDURE IF EXISTS LoadAddress//

CREATE PROCEDURE LoadAddress (IN p_address_no BIGINT(20))
BEGIN
	SELECT * FROM address
		WHERE address_no = p_address_no;
END
//

DROP PROCEDURE IF EXISTS SearchAddress//

CREATE PROCEDURE SearchAddress (IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
                                IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50))
BEGIN
	SELECT * FROM address
		WHERE ((p_address1 IS NULL ) OR (address1 = p_address1))
		AND ((p_address2 IS NULL) OR (address2 = p_address2))
		AND ((p_city IS NULL ) OR (city = p_city))
        AND ((p_province IS NULL) OR (province = p_province))
		AND ((p_country IS NULL) OR (country = p_country))
		AND ((p_postal_code IS NULL ) OR (postal_code = p_postal_code))
		AND ((p_email IS NULL ) OR (email = p_email));
END
//

DROP PROCEDURE IF EXISTS CreateAddress//

CREATE PROCEDURE CreateAddress (IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
                                IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50), OUT p_key BIGINT(20))
BEGIN
	INSERT INTO address (address1, address2, city, province, country, postal_code, email)
		VALUES (p_address1, p_address2, p_city, p_province, p_country, p_postal_code, p_email);

    set p_key = LAST_INSERT_ID();

END
//

DROP PROCEDURE IF EXISTS UpdateAddress//

CREATE PROCEDURE UpdateAddress (IN p_address_no BIGINT(20),
								IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
								IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50))
BEGIN
	UPDATE address
    SET address1 = p_address1,
      address2 = p_address2,
      city = p_city,
      province = p_province,
      country = p_country,
      postal_code = p_postal_code,
      email = p_email
    WHERE address_no = p_address_no;
END
//

DROP PROCEDURE IF EXISTS DeleteAddress//

CREATE PROCEDURE DeleteAddress (IN p_address_no BIGINT(20))
BEGIN
    DELETE FROM address
        WHERE address_no = p_address_no;
END
//

delimiter ;
