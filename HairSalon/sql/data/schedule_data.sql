INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2009-10-12', '11:00:00', '12:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2009-10-12', '11:00:00', '12:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2009-11-12', '11:00:00', '12:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2009-12-12', '11:00:00', '12:00:00');

INSERT INTO `scheduleexception` (`date`, `reason`) VALUE ('2009-11-12', 'Test');

INSERT INTO `availabilityexception` (`employee_no`,`date`,`reason`) VALUE (1, '2009-12-12', 'Test');
