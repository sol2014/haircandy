/*
author Nuha Bazara
*/
delimiter //

DROP PROCEDURE IF EXISTS LoadSale//

CREATE PROCEDURE LoadSale (IN p_transaction_no BIGINT(20))
BEGIN
	SELECT * FROM sale
		WHERE transaction_no = p_transaction_no;

    SELECT * FROM saleservice
        WHERE transaction_no = p_transaction_no;

    SELECT * FROM saleproduct
        WHERE transaction_no = p_transaction_no;
END
//

DROP PROCEDURE IF EXISTS SearchSale //

CREATE PROCEDURE SearchSale(IN p_client_no BIGINT(20),
							IN p_employee_no BIGINT(20),
							IN p_payment_type VARCHAR(10),
							IN p_total_due DECIMAL(5,2),
							IN p_total_tax DECIMAL(5,2),
							IN p_discount TINYINT,
							IN p_payment DECIMAL(5,2),
							IN p_is_complete BOOLEAN)
BEGIN
	SELECT * 
	FROM sale
        WHERE ((p_client_no IS NULL) OR (client_no = p_client_no))
        AND ((p_employee_no IS NULL) OR (employee_no = p_employee_no))
        AND ((p_payment_type IS NULL) OR (payment_type = p_payment_type))
        AND ((p_total_due IS NULL )OR (total_due = p_total_due))
		AND ((p_total_tax IS NULL) OR (total_tax = p_total_tax))
		AND ((p_discount IS NULL) OR (discount = p_discount))
        AND ((p_payment IS NULL) OR (payment = p_payment))
        AND ((p_is_complete IS NULL) OR (is_complete = p_is_complete));
END
//

DROP PROCEDURE IF EXISTS CreateSale//

CREATE PROCEDURE CreateSale(IN p_client_no BIGINT(20),
							IN p_employee_no BIGINT(20),
							IN p_payment_type VARCHAR(10),
							IN p_total_due DECIMAL(5,2),
							IN p_total_tax DECIMAL(5,2),
							IN p_discount TINYINT,
							IN p_payment DECIMAL(5,2),
							IN p_is_complete BOOLEAN,
                            OUT p_key BIGINT(20))
BEGIN
    INSERT INTO sale(client_no,employee_no,payment_type,total_due,total_tax,discount,payment,is_complete)
    VALUES(p_client_no,p_employee_no,p_payment_type,p_total_due,p_total_tax,p_discount,p_payment,p_is_complete);

    SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS DeleteSale//

CREATE PROCEDURE DeleteSale (IN p_transaction_no BIGINT(20))
BEGIN
    DELETE FROM sale
    WHERE transaction_no = p_transaction_no;
END
//

DROP PROCEDURE IF EXISTS UpdateSale//

CREATE PROCEDURE UpdateSale(IN p_transaction_no BIGINT(20),
							IN p_client_no BIGINT(20),
							IN p_employee_no BIGINT(20),
							IN p_payment_type VARCHAR(10),
							IN p_total_due DECIMAL(5,2),
							IN p_total_tax DECIMAL(5,2),
							IN p_discount TINYINT,
							IN p_payment DECIMAL(5,2),
							IN p_is_complete BOOLEAN)
BEGIN
	UPDATE sale
	SET client_no = p_client_no,
		employee_no = p_employee_no,
		payment_type =p_payment_type,
		total_due = p_total_due,
		total_tax = p_total_tax,
		discount = p_discount,
		payment =p_paymet,
		is_complete = p_is_complete
	WHERE transaction_no = p_transaction_no;
END
//

DROP PROCEDURE IF EXISTS AddSaleProduct//

CREATE PROCEDURE AddSaleProduct (IN p_transaction_no BIGINT(20), IN p_product_no BIGINT(20), IN p_amount INTEGER)
BEGIN
    INSERT INTO saleproduct (transaction_no, product_no, amount) VALUES (p_transaction_no, p_product_no, p_amount);
END
//

DROP PROCEDURE IF EXISTS DeleteSaleProducts//

CREATE PROCEDURE DeleteSaleProducts (IN p_transaction_no BIGINT(20))
BEGIN
    DELETE FROM saleproduct
    WHERE transaction_no = p_transaction_no;
END
//

DROP PROCEDURE IF EXISTS AddSaleService//

CREATE PROCEDURE AddSaleService (IN p_transaction_no BIGINT(20), IN p_service_no BIGINT(20), IN p_amount INTEGER)
BEGIN
    INSERT INTO saleservice (transaction_no, service_no, amount) VALUES (p_transaction_no, p_service_no, p_amount);
END
//

DROP PROCEDURE IF EXISTS DeleteSaleServices//

CREATE PROCEDURE DeleteSaleServices (IN p_transaction_no BIGINT(20))
BEGIN
    DELETE FROM saleservice
    WHERE transaction_no = p_transaction_no;
END
//
delimiter ;