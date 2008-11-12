delimiter //

DROP PROCEDURE IF EXISTS LoadEmployeeHours//

CREATE PROCEDURE LoadEmployeeHours (IN p_employee_no BIGINT(20), IN p_date DATE)
BEGIN
	SELECT * FROM employeehours
		WHERE employee_no = p_employee_no AND date = p_date;
END
//

DROP PROCEDURE IF EXISTS UpdateEmployeeHours//

CREATE PROCEDURE UpdateEmployeeHours (IN p_employee_no BIGINT(20), IN p_date DATE, IN p_start_time TIME,
															IN p_end_time TIME)
BEGIN
	DELETE FROM employeehours
		WHERE employee_no = p_employee_no AND date = p_date;
    
    INSERT INTO employeehours (employee_no, date, start_time, end_time)
		VALUES (p_employee_no, p_date, p_start_time, p_end_time);
END
//

DROP PROCEDURE IF EXISTS DeleteEmployeeHours//

CREATE PROCEDURE DeleteEmployeeHours (IN p_employee_no BIGINT(20), IN p_date DATE)
BEGIN
    DELETE FROM employeehours
		WHERE employee_no = p_employee_no AND date = p_date;
END
//

delimiter ;
