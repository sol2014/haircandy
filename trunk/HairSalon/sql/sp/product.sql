delimiter //

DROP PROCEDURE IF EXISTS LoadProduct//

CREATE PROCEDURE LoadProduct (IN p_product_no BIGINT(20))
BEGIN
	SELECT * FROM product
		WHERE product_no = p_product_no;
END
//

DROP PROCEDURE IF EXISTS SearchProduct//

CREATE PROCEDURE SearchProduct (IN p_brand VARCHAR(25),
                                IN p_product_name VARCHAR(25),
                                IN p_product_type VARCHAR(25),
                                IN p_stock_qty INTEGER,
                                IN p_min_level INTEGER,
                                IN p_qty_per INTEGER,
                                IN p_price DECIMAL(5,2),
                                IN p_unit VARCHAR(5),
                                IN p_enabled Boolean)
BEGIN
    SELECT * FROM product
        WHERE ((p_brand IS NULL) OR (brand LIKE CONCAT("%",p_brand,"%")))
        AND ((p_product_name IS NULL)OR (product_name LIKE CONCAT("%",p_product_name,"%")))
        AND ((p_product_type IS NULL) OR (product_type = p_product_type))
        AND ((p_stock_qty IS NULL) OR (stock_qty = p_stock_qty))
        AND ((p_min_level IS NULL) OR (min_level = p_min_level))
        AND ((p_qty_per IS NULL) OR (qty_per = p_qty_per))
        AND ((p_price IS NULL) OR (price = p_price))
        AND ((p_unit IS NULL) OR (unit = p_unit))
        AND ((p_enabled IS NULL ) OR (enabled = p_enabled))
		ORDER BY product_name ASC;
END
//

DROP PROCEDURE IF EXISTS CreateProduct//

CREATE PROCEDURE CreateProduct (IN p_brand VARCHAR(25),
							   IN p_product_name VARCHAR(25),
							   IN p_product_type VARCHAR(25),
							   IN p_stock_qty INTEGER,
							   IN p_min_level INTEGER,
							   IN p_qty_per INTEGER,
							   IN p_price DECIMAL(5,2),
							   IN p_unit VARCHAR(5),
							   IN p_enabled Boolean, OUT p_key BIGINT(20))
BEGIN 
    INSERT INTO product(brand, product_name, product_type, stock_qty, min_level, qty_per, price, unit, enabled)
        VALUES(p_brand, p_product_name, p_product_type, p_stock_qty, p_min_level, p_qty_per, p_price, p_unit, p_enabled);
	
	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS DeleteProduct//

CREATE PROCEDURE DeleteProduct (IN p_product_no BIGINT(20))
BEGIN
    DELETE FROM product 
        WHERE product_no = p_product_no;
END
//

DROP PROCEDURE IF EXISTS UpdateProduct//

CREATE PROCEDURE UpdateProduct (IN p_product_no BIGINT(20),
							   IN p_brand VARCHAR(25),
							   IN p_product_name VARCHAR(25),
							   IN p_product_type VARCHAR(25),
							   IN p_stock_qty INTEGER,
							   IN p_min_level INTEGER,
							   IN p_qty_per INTEGER,
							   IN p_price DECIMAL(5,2),
							   IN p_unit VARCHAR(5),
							   IN p_enabled Boolean)
BEGIN
	UPDATE product 
        SET brand = p_brand,
		product_name = p_product_name,
		product_type =p_product_type,
		stock_qty = p_stock_qty,
		min_level =p_min_level,
		qty_per =p_qty_per,
		price =p_price,
		unit =p_unit,
		enabled = p_enabled
		WHERE product_no = p_product_no;
END
//

delimiter ;