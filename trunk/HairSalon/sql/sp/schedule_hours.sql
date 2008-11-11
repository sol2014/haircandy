delimiter //

DROP PROCEDURE IF EXISTS LoadScheduleHours//

CREATE PROCEDURE LoadScheduleHours (IN p_date DATE)
BEGIN
	SELECT * FROM schedulehours
		WHERE date = p_date;
END
//

DROP PROCEDURE IF EXISTS UpdateScheduleHours//

CREATE PROCEDURE UpdateScheduleHours (IN p_date DATE, IN p_start_time TIME,
															IN p_end_time TIME)
BEGIN
	DELETE FROM schedulehours
		WHERE date = p_date;
    
    INSERT INTO schedulehours (date, start_time, end_time)
		VALUES (p_date, p_start_time, p_end_time);
END
//

DROP PROCEDURE IF EXISTS DeleteScheduleHours//

CREATE PROCEDURE DeleteScheduleHours(IN p_date DATE)
BEGIN
    DELETE FROM schedulehours
		WHERE date = p_date;
END
//

delimiter ;