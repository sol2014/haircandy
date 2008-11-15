delimiter //

DROP PROCEDURE IF EXISTS LoadSchedule//

CREATE PROCEDURE LoadSchedule (IN p_schedule_no BIGINT)
BEGIN
	SELECT * FROM schedule
		WHERE schedule_no = p_schedule_no;
END
//

DROP PROCEDURE IF EXISTS SearchScheduleRange//

CREATE PROCEDURE SearchScheduleRange(IN p_employee_no BIGINT(20),
								   IN p_start_date DATE,
								   IN p_end_date DATE,
								   IN p_start_time TIME,
								   IN p_end_time TIME)
BEGIN
	SELECT * FROM schedule
        WHERE ((p_employee_no IS NULL) OR (employee_no = p_employee_no))
        AND ((p_start_date IS NULL || p_end_date IS NULL) OR (date BETWEEN p_start_date AND p_end_date))
        AND ((p_start_time IS NULL) OR (start_time = p_start_time))
        AND ((p_end_time IS NULL) OR (end_time = p_end_time))
	ORDER BY date DESC;
END
//

DROP PROCEDURE IF EXISTS SearchSchedule//

CREATE PROCEDURE SearchSchedule(IN p_employee_no BIGINT(20),
								   IN p_date DATE,
								   IN p_start_time TIME,
								   IN p_end_time TIME)
BEGIN
	SELECT * FROM schedule
        WHERE ((p_employee_no IS NULL) OR (employee_no = p_employee_no))
        AND ((p_date IS NULL) OR (date = p_date))
        AND ((p_start_time IS NULL) OR (start_time = p_start_time))
        AND ((p_end_time IS NULL) OR (end_time = p_end_time))
	ORDER BY date DESC;
END
//

DROP PROCEDURE IF EXISTS CreateSchedule//

CREATE PROCEDURE CreateSchedule(IN p_employee_no BIGINT(20),
								   IN p_date DATE,
								   IN p_start_time TIME,
								   IN p_end_time TIME,
								OUT p_key BIGINT(20))
BEGIN
    INSERT INTO schedule(employee_no,date,start_time,end_time)
    VALUES(p_employee_no,p_date,p_start_time,p_end_time);
	
	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS UpdateSchedule//

CREATE PROCEDURE UpdateSchedule(IN p_schedule_no BIGINT(20),
								   IN p_employee_no BIGINT(20),
								   IN p_date DATE,
								   IN p_start_time TIME,
								   IN p_end_time TIME)
BEGIN
	UPDATE schedule 
	SET employee_no = p_employee_no,
            date = p_date,
			start_time = p_start_time,
            end_time = p_end_time
	WHERE schedule_no = p_schedule_no;
END
//

DROP PROCEDURE IF EXISTS DeleteSchedule//

CREATE PROCEDURE DeleteSchedule(IN p_schedule_no BIGINT(20))
BEGIN
    DELETE FROM schedule
    WHERE schedule_no = p_schedule_no;
END
//

delimiter ;