delimiter //

DROP PROCEDURE IF EXISTS LoadEmployee//

CREATE PROCEDURE LoadEmployee (IN p_employee_no BIGINT(20))
BEGIN
	SELECT * FROM employee
		WHERE employee_no = p_employee_no;
		
	SELECT * FROM service
        WHERE service_no IN
        (
            SELECT service_no FROM employeeservice
                WHERE employee_no = p_employee_no
        );
	
    SELECT * FROM availabilityexception
        WHERE employee_no = p_employee_no;
END
//

DROP PROCEDURE IF EXISTS AuthenticateEmployee//

CREATE PROCEDURE AuthenticateEmployee (IN p_employee_no BIGINT(20),
										IN p_password VARCHAR(15))
BEGIN
	SELECT * FROM employee
		WHERE password = p_password
		AND employee_no = p_employee_no
		AND enabled = true;
END
//

DROP PROCEDURE IF EXISTS SearchEmployee//

CREATE PROCEDURE SearchEmployee (IN p_employee_no BIGINT(20),
								IN p_password VARCHAR(15),
								IN p_first_name VARCHAR(25),
                                IN p_last_name VARCHAR(25),
                                IN p_phone_number VARCHAR(10),
                                IN p_role VARCHAR(15),
                                IN p_address1 VARCHAR(50),
								IN p_address2 VARCHAR(50),
								IN p_city VARCHAR(15),
                                IN p_province VARCHAR(15),
								IN p_country VARCHAR(15),
								IN p_postal_code VARCHAR(6),
								IN p_email VARCHAR(50),
								IN p_enabled BOOLEAN)
BEGIN
	SELECT * FROM employee
        WHERE ( address_no IN (
                SELECT address_no FROM `address`
                  WHERE ((p_address1 IS NULL) OR (address1 LIKE CONCAT("%",p_address1,"%")))
                  AND ((p_address2 IS NULL) OR (address2 LIKE CONCAT("%",p_address2,"%")))
                  AND ((p_city IS NULL) OR (city LIKE CONCAT("%",p_city,"%")))
                  AND ((p_province IS NULL) OR (province LIKE CONCAT("%",p_province,"%")))
                  AND ((p_country IS NULL) OR (country LIKE CONCAT("%",p_country,"%")))
                  AND ((p_postal_code IS NULL) OR (postal_code LIKE CONCAT("%",p_postal_code,"%")))
                  AND ((p_email IS NULL) OR (email LIKE CONCAT("%",p_email,"%"))) ) )
		AND ((p_employee_no IS NULL) OR (employee_no = p_employee_no))
		AND ((p_password IS NULl) OR (password = p_password))
		AND ((p_first_name IS NULL) OR (first_name LIKE CONCAT("%",p_first_name,"%")))
		AND ((p_last_name IS NULL ) OR (last_name LIKE CONCAT("%",p_last_name,"%")))
		AND ((p_phone_number IS NULL) OR (phone_number LIKE CONCAT("%",p_phone_number,"%")))
		AND ((p_role IS NULL ) OR (role = p_role))
		AND ((p_enabled IS NULL ) OR (enabled = p_enabled))
		ORDER BY last_name ASC;
END
//

DROP PROCEDURE IF EXISTS CreateEmployee//

CREATE PROCEDURE CreateEmployee (IN p_address_no BIGINT(20),
								IN p_password VARCHAR(15),
								IN p_first_name VARCHAR(25),
								IN p_last_name VARCHAR(25),
								IN p_phone_number VARCHAR(10),
								IN p_role VARCHAR(15),
								IN p_monday_start TIME,
								IN p_monday_end TIME,
								IN p_tuesday_start TIME,
								IN p_tuesday_end TIME,
								IN p_wednesday_start TIME,
								IN p_wednesday_end TIME,
								IN p_thursday_start TIME,
								IN p_thursday_end TIME,
								IN p_friday_start TIME,
								IN p_friday_end TIME,
								IN p_saturday_start TIME,
								IN p_saturday_end TIME,
								IN p_sunday_start TIME,
								IN p_sunday_end TIME,
								IN p_enabled BOOLEAN,
								OUT p_key BIGINT(20))
BEGIN
	INSERT INTO employee (address_no, password, first_name, last_name, phone_number, role,
		monday_start, monday_end, tuesday_start, tuesday_end,wednesday_start,wednesday_end,
		thursday_start,thursday_end,friday_start,friday_end,saturday_start,saturday_end,sunday_start,sunday_end,enabled)
		VALUES (p_address_no, p_password, p_first_name, p_last_name, p_phone_number, p_role,
		p_monday_start, p_monday_end, p_tuesday_start, p_tuesday_end, p_wednesday_start,
		p_wednesday_end, p_thursday_start, p_thursday_end, p_friday_start, p_friday_end,
		p_saturday_start, p_saturday_end, p_sunday_start, p_sunday_end,p_enabled);
	
	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS AddEmployeeService//

CREATE PROCEDURE AddEmployeeService (IN p_employee_no BIGINT(20), IN p_service_no BIGINT(20))
BEGIN
    INSERT INTO employeeservice (employee_no, service_no) VALUES (p_employee_no, p_service_no);
END
//

DROP PROCEDURE IF EXISTS DeleteEmployeeServices//

CREATE PROCEDURE DeleteEmployeeServices (IN p_employee_no BIGINT(20))
BEGIN
    DELETE FROM employeeservice
    WHERE employee_no = p_employee_no;
END
//

DROP PROCEDURE IF EXISTS UpdateEmployee//

CREATE PROCEDURE UpdateEmployee (IN p_employee_no BIGINT(20),
								IN p_address_no BIGINT(20),
								IN p_password VARCHAR(15),
								IN p_first_name VARCHAR(25),
								IN p_last_name VARCHAR(25),
								IN p_phone_number VARCHAR(10),
								IN p_role VARCHAR(15),
								IN p_monday_start TIME,
								IN p_monday_end TIME,
								IN p_tuesday_start TIME,
								IN p_tuesday_end TIME,
								IN p_wednesday_start TIME,
								IN p_wednesday_end TIME,
								IN p_thursday_start TIME,
								IN p_thursday_end TIME,
								IN p_friday_start TIME,
								IN p_friday_end TIME,
								IN p_saturday_start TIME,
								IN p_saturday_end TIME,
								IN p_sunday_start TIME,
								IN p_sunday_end TIME,
								IN p_enabled BOOLEAN)
BEGIN
	UPDATE employee 
		SET password = p_password,
			first_name = p_first_name,
			last_name =p_last_name,
			phone_number = p_phone_number,
			role = p_role,
			monday_start = p_monday_start,
			monday_end = p_monday_end,
			tuesday_start = p_tuesday_start,
			tuesday_end = p_tuesday_end,
			wednesday_start = p_wednesday_start,
			wednesday_end = p_wednesday_end,
			thursday_start = p_thursday_start,
			thursday_end = p_thursday_end,
			friday_start = p_friday_start,
			friday_end = p_friday_end,
			saturday_start = p_saturday_start,
			saturday_end = p_saturday_end,
			sunday_start = p_sunday_start,
			sunday_end = p_sunday_end,
			address_no = p_address_no,
			enabled = p_enabled
		WHERE employee_no = p_employee_no;
END
//

DROP PROCEDURE IF EXISTS DeleteEmployee//

CREATE PROCEDURE DeleteEmployee (IN p_employee_no BIGINT(20))
BEGIN
    DELETE FROM employee
        WHERE employee_no = p_employee_no;
END
//

delimiter ;
