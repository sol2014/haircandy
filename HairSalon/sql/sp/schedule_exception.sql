delimiter //

DROP PROCEDURE IF EXISTS LoadScheduleException//

CREATE PROCEDURE LoadScheduleException (IN p_date DATE)
BEGIN
	SELECT * FROM scheduleexception
		WHERE date = p_date;
END
//

DROP PROCEDURE IF EXISTS SearchScheduleException//

CREATE PROCEDURE SearchScheduleException (IN p_date DATE,
										IN p_reason VARCHAR(150))
BEGIN
    SELECT * from scheduleexception
    WHERE ((p_date IS NULL) OR (date = p_date))
		AND ((p_reason IS NULL) OR (reason = p_reason));
END
//

DROP PROCEDURE IF EXISTS CreateScheduleException//

CREATE PROCEDURE CreateScheduleException(IN p_date DATE,
				IN p_reason VARCHAR(150))
BEGIN
    DELETE FROM scheduleexception
    WHERE date = p_date;
    
    INSERT INTO scheduleexception (date, reason)
    VALUES (p_date, p_reason);
END
//

DROP PROCEDURE IF EXISTS DeleteScheduleException//

CREATE PROCEDURE DeleteScheduleException(IN p_date DATE)
BEGIN
    DELETE FROM scheduleexception
    WHERE date = p_date;
END
//

DROP PROCEDURE IF EXISTS DeleteScheduleExceptions//

CREATE PROCEDURE DeleteScheduleExceptions()
BEGIN
    DELETE FROM scheduleexception;
END
//

delimiter ;