delimiter //

DROP PROCEDURE IF EXISTS LoadAlert//

CREATE PROCEDURE LoadAlert (IN p_alert_type VARCHAR(10), IN p_record_no BIGINT(20))
BEGIN
	SELECT * FROM alert
		WHERE alert_type = p_alert_type
            AND record_no = p_record_no;
END
//

DROP PROCEDURE IF EXISTS ListAlerts//

CREATE PROCEDURE ListAlerts ()
BEGIN
	SELECT * FROM alert;
END
//

DROP PROCEDURE IF EXISTS CreateAlert//

CREATE PROCEDURE CreateAlert (IN p_alert_type VARCHAR(10),
									IN p_date DATE,
									IN p_message VARCHAR(250),
									IN p_link VARCHAR(250),
									IN p_level VARCHAR(10),
									IN p_record_no BIGINT(20),
									OUT p_key BIGINT(20))
BEGIN
    DELETE FROM alert
        WHERE alert_type = p_alert_type AND record_no = p_record_no;

	INSERT INTO alert (alert_type, date, message, link, level, record_no)
		VALUES (p_alert_type, p_date, p_message, p_link, p_level, p_record_no);

    set p_key = LAST_INSERT_ID();
END
//

DROP PROCEDURE IF EXISTS DeleteAlerts//

CREATE PROCEDURE DeleteAlerts ()
BEGIN
    DELETE FROM alert;
END
//

DROP PROCEDURE IF EXISTS DeleteAlert//

CREATE PROCEDURE DeleteAlert (IN p_alert_no BIGINT(20))
BEGIN
    DELETE FROM alert
        WHERE alert_no = p_alert_no;
END
//

delimiter ;
