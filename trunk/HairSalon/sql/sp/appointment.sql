delimiter //

DROP PROCEDURE IF EXISTS LoadAppointment//

CREATE PROCEDURE LoadAppointment (IN p_appointment_no BIGINT(20))
BEGIN
	SELECT * FROM appointment
		WHERE appointment_no = p_appointment_no;

	SELECT * FROM appointmentservice
        WHERE appointment_no = p_appointment_no;

    SELECT * FROM appointmentproduct
        WHERE appointment_no = p_appointment_no;
END
//

DROP PROCEDURE IF EXISTS SearchAppointment//

CREATE PROCEDURE SearchAppointment (IN p_client_no BIGINT(20),
									IN p_employee_no BIGINT(20),
									IN p_ap_date DATE,
									IN p_start_time TIME,
									IN p_end_time TIME,
									IN p_is_complete BOOLEAN)
BEGIN
	SELECT * 
	FROM appointment
	WHERE ((p_client_no IS NULL) OR (client_no =p_client_no))
	AND ((p_employee_no IS NULL) OR (employee_no =p_employee_no))
	AND ((p_ap_date IS NULL) OR (ap_date = p_ap_date))
	AND ((p_start_time IS NULL) OR (start_time = p_start_time))
	AND ((p_end_time IS NULL) OR (end_time = p_end_time))
	AND ((p_is_complete IS NULL) OR (is_complete = p_is_complete));
END
//

DROP PROCEDURE IF EXISTS CreateAppointment//

CREATE PROCEDURE CreateAppointment (IN p_client_no BIGINT(20),
									IN p_employee_no BIGINT(20),
                                    IN p_ap_date DATE,
                                    IN p_start_time TIME,
                                    IN p_end_time TIME,
                                    IN p_is_complete BOOLEAN,
									OUT p_key BIGINT(20))
BEGIN
    INSERT INTO appointment (client_no, employee_no, ap_date, start_time, end_time, is_complete)
    VALUES (p_client_no, p_employee_no, p_ap_date, p_start_time, p_end_time, p_is_complete);

	SET p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS UpdateAppointment//

CREATE PROCEDURE UpdateAppointment (IN p_appointment_no BIGINT(20),
									IN p_client_no BIGINT(20),
									IN p_employee_no BIGINT(20),
									IN p_ap_date DATE,
									IN p_start_time TIME,
									IN p_end_time TIME,
									IN p_is_complete BOOLEAN)
BEGIN
	UPDATE appointment
	SET client_no = p_client_no,
		employee_no = p_employee_no,
		ap_date = p_ap_date,
		start_time = p_start_time,
		end_time = p_end_time,
		is_complete = p_is_complete
	WHERE appointment_no = p_appointment_no;
	
END
//

DROP PROCEDURE IF EXISTS DeleteAppointment//

CREATE PROCEDURE DeleteAppointment (IN p_appointment_no BIGINT(20))
BEGIN
    DELETE FROM appointment
        WHERE appointment_no = p_appointment_no;
END
//

DROP PROCEDURE IF EXISTS AddAppointmentProduct//

CREATE PROCEDURE AddAppointmentProduct (IN p_appointment_no BIGINT(20), IN p_product_no BIGINT(20), IN p_amount INTEGER)
BEGIN
    INSERT INTO appointmentproduct (appointment_no, product_no, amount) VALUES (p_appointment_no, p_product_no, p_amount);
END
//

DROP PROCEDURE IF EXISTS DeleteAppointmentProducts//

CREATE PROCEDURE DeleteAppointmentProducts (IN p_appointment_no BIGINT(20))
BEGIN
    DELETE FROM appointmentproduct
    WHERE appointment_no = p_appointment_no;
END
//

DROP PROCEDURE IF EXISTS AddAppointmentService//

CREATE PROCEDURE AddAppointmentService (IN p_appointment_no BIGINT(20), IN p_service_no BIGINT(20), IN p_amount INTEGER)
BEGIN
    INSERT INTO appointmentservice (appointment_no, service_no, amount) VALUES (p_appointment_no, p_service_no, p_amount);
END
//

DROP PROCEDURE IF EXISTS DeleteAppointmentServices//

CREATE PROCEDURE DeleteAppointmentServices (IN p_appointment_no BIGINT(20))
BEGIN
    DELETE FROM appointmentservice
    WHERE appointment_no = p_appointment_no;
END
//

delimiter ;