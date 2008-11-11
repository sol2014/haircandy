delimiter //

DROP PROCEDURE IF EXISTS LoadSalon//

CREATE PROCEDURE LoadSalon ()
BEGIN
	SELECT * FROM salon;

	SELECT * FROM scheduleexception;
END
//

DROP PROCEDURE IF EXISTS AddScheduleException//

CREATE PROCEDURE AddScheduleException (IN p_date DATE, 
										IN p_reason VARCHAR(50), 
										IN p_start_time TIME,
										IN p_end_time TIME)
BEGIN
    INSERT INTO scheduleexception (date, reason, start_time, end_time) 
		VALUES (p_date, p_reason, p_start_time, p_end_time);
END
//

DROP PROCEDURE IF EXISTS DeleteScheduleExceptions//

CREATE PROCEDURE DeleteScheduleExceptions ()
BEGIN
    DELETE FROM scheduleexception;
END
//

DROP PROCEDURE IF EXISTS UpdateSalon//

CREATE PROCEDURE UpdateSalon(IN p_name VARCHAR(50),
							IN p_address1 VARCHAR(50),
							IN p_address2 VARCHAR(50),
							IN p_city VARCHAR(15),
							IN p_province VARCHAR(15),
							IN p_country VARCHAR(15),
							IN p_postal_code VARCHAR(6),
							IN p_phone_number VARCHAR(10),
							IN p_email VARCHAR(50),
							IN p_tax_rate DECIMAL(2,2),
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
							IN p_sunday_end TIME)
BEGIN
	UPDATE salon 
	SET name = p_name,
		address1 = p_address1,
		address2 = p_address2,
		city = p_city,
		province = p_province,
		country = p_country,
		postal_code = p_postal_code,
		phone_number = p_phone_number,
		email = p_email,
		tax_rate = p_tax_rate,
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
		sunday_end = p_sunday_end;
END
//

delimiter ;		