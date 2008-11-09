delimiter //

DROP PROCEDURE IF EXISTS LoadSupplier//

CREATE PROCEDURE LoadSupplier (IN p_supplier_no BIGINT(20))
BEGIN
	SELECT * FROM supplier
		WHERE supplier_no = p_supplier_no;
        
        SELECT * FROM product
                WHERE product_no IN
        (
            SELECT product_no FROM supplierproduct
                WHERE supplier_no = p_supplier_no
        );
END
//

DROP PROCEDURE IF EXISTS SearchSupplier//

CREATE PROCEDURE SearchSupplier(IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
								IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50),
								IN p_supplier_name VARCHAR(50),
								IN p_description VARCHAR(150),
								IN p_phone_number VARCHAR(10),
								IN p_enabled BOOLEAN)
BEGIN
	SELECT * FROM supplier
		WHERE (address_no IN (
			SELECT address_no FROM `address`
				WHERE ((p_address1 IS NULL) OR (address1 LIKE CONCAT("%",p_address1,"%")))
				AND ((p_address2 IS NULL) OR (address2 LIKE CONCAT("%",p_address2,"%")))
				AND ((p_city IS NULL) OR (city LIKE CONCAT("%",p_city,"%")))
				AND ((p_province IS NULL) OR (province LIKE CONCAT("%",p_province,"%")))
				AND ((p_country IS NULL) OR (country LIKE CONCAT("%",p_country,"%")))
				AND ((p_postal_code IS NULL) OR (postal_code LIKE CONCAT("%",p_postal_code,"%")))
				AND ((p_email IS NULL) OR (email LIKE CONCAT("%",p_email,"%"))) ))
		AND ((p_supplier_name IS NULL) OR (supplier_name LIKE CONCAT("%",p_supplier_name,"%")))
		AND ((p_description IS NULL) OR (description LIKE CONCAT("%",p_description,"%")))
		AND ((p_phone_number IS NULL) OR (phone_number LIKE CONCAT("%",p_phone_number,"%")))
		AND ((p_enabled IS NULL) OR (enabled = p_enabled))
		ORDER BY supplier_name ASC;

        SELECT *
                  FROM `address`
                  WHERE ((p_address1 IS NULL) OR (address1 = p_address1))
                  AND ((p_address2 IS NULL) OR (address2 = p_address2))
                  AND ((p_city IS NULL) OR (city = p_city))
                  AND ((p_province IS NULL) OR (province = p_province))
                  AND ((p_country IS NULL) OR (country = p_country))
                  AND ((p_postal_code IS NULL) OR (postal_code = p_postal_code))
                  AND ((p_email IS NULL) OR (email = p_email));
END
//

DROP PROCEDURE IF EXISTS CreateSupplier//

CREATE PROCEDURE CreateSupplier(
								IN p_address_no BIGINT(20),
								IN p_supplier_name VARCHAR(50),
								IN p_description VARCHAR(150),
								IN p_phone_number VARCHAR(10),
                                IN p_enabled BOOLEAN,
								OUT p_supplier_no BIGINT(20))
BEGIN
    INSERT INTO supplier (address_no, supplier_name, description, phone_number,enabled)
    VALUES (p_address_no, p_supplier_name, p_description, p_phone_number,p_enabled);
    set p_supplier_no = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS UpdateSupplier//

CREATE PROCEDURE UpdateSupplier(IN p_supplier_no BIGINT(20),
								IN p_address_no BIGINT(20),
								IN p_supplier_name VARCHAR(50),
								IN p_description VARCHAR(150),
								IN p_phone_number VARCHAR(10),
								IN p_enabled BOOLEAN)
BEGIN
	UPDATE supplier
        SET
		address_no =p_address_no,
		supplier_name =p_supplier_name,
		description = p_description,
		phone_number = p_phone_number,
		enabled = p_enabled
        WHERE supplier_no = p_supplier_no;
END
//

DROP PROCEDURE IF EXISTS DeleteSupplier//

CREATE PROCEDURE DeleteSupplier(IN p_supplier_no BIGINT(20))
BEGIN
    DELETE FROM supplier
    WHERE supplier_no = p_supplier_no;
END
//

DROP PROCEDURE IF EXISTS DeleteSupplierProducts//

CREATE PROCEDURE DeleteSupplierProducts(IN p_supplier_no BIGINT(20))
BEGIN
    DELETE FROM supplierproduct
    WHERE supplier_no = p_supplier_no;
END
//

DROP PROCEDURE IF EXISTS AddSupplierProduct//

CREATE PROCEDURE AddSupplierProduct(IN p_supplier_no BIGINT(20), IN p_product_no BIGINT(20))
BEGIN
    INSERT INTO 
  `supplierproduct`
(
  `supplier_no`,
  `product_no`
) 
VALUE (
  p_supplier_no,
  p_product_no
);
END
//

delimiter ;