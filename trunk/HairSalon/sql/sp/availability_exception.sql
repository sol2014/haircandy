delimiter //

DROP PROCEDURE IF EXISTS LoadAvailabilityException//

CREATE PROCEDURE LoadAvailabilityException (IN p_employee_no BIGINT(20), IN p_date DATE)
BEGIN
	SELECT * FROM availabilityexception
		WHERE employee_no = p_employee_no
          AND date = p_date;
END
//

DROP PROCEDURE IF EXISTS SearchAvailabilityException//

CREATE PROCEDURE SearchAvailabilityException (IN p_employee_no BIGINT(20),
												IN p_date DATE,
												IN p_reason VARCHAR(150))
BEGIN
    SELECT * from availabilityexception
    WHERE ((p_employee_no IS NULL) OR (employee_no = p_employee_no))
		AND ((p_date IS NULL) OR (date = p_date))
		AND ((p_reason IS NULL) OR (reason = p_reason));
END
//

DROP PROCEDURE IF EXISTS CreateAvailabilityException//

CREATE PROCEDURE CreateAvailabilityException(IN p_employee_no BIGINT(20),
                IN p_date DATE,
				IN p_reason VARCHAR(150))
BEGIN
    DELETE FROM availabilityexception
    WHERE employee_no = p_employee_no
      AND date = p_date;
    
    INSERT INTO availabilityexception (employee_no, date, reason)
    VALUES (p_employee_no, p_date, p_reason);
END
//

DROP PROCEDURE IF EXISTS DeleteAvailabilityException//

CREATE PROCEDURE DeleteAvailabilityException(IN p_employee_no BIGINT(20), IN p_date DATE)
BEGIN
    DELETE FROM availabilityexception
    WHERE employee_no = p_employee_no
      AND date = p_date;
END
//

DROP PROCEDURE IF EXISTS DeleteAvailabilityExceptions//

CREATE PROCEDURE DeleteAvailabilityExceptions(IN p_employee_no BIGINT(20))
BEGIN
    DELETE FROM availabilityexception
    WHERE employee_no = p_employee_no;
END
//

delimiter ;