INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-10-12', '10:00:00', '14:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-11-12', '10:00:00', '14:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-12', '8:00:00', '12:00:00');

INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-13', '10:00:00', '14:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-14', '10:00:00', '14:00:00'
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-15', '10:00:00', '14:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-16', '10:00:00', '14:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-17', '8:00:00', '12:00:00');
INSERT INTO `schedulehours` (`date`, `start_time`, `end_time`) VALUE ('2008-12-18', '10:00:00', '14:00:00');


INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2008-10-12', '9:00:00', '15:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2008-10-12', '9:00:00', '15:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2008-11-12', '9:00:00', '15:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2008-12-12', '8:00:00', '12:00:00');

INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (3, '2008-12-13', '11:00:00', '17:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (3, '2008-12-14', '9:00:00', '17:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (4, '2008-12-14', '9:00:00', '16:00:00');
INSERT INTO `employeehours` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (4, '2008-12-15', '9:00:00', '16:00:00');

INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2008-10-12', '10:00:00', '14:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2008-10-12', '11:00:00', '12:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (1, '2008-11-12', '11:00:00', '12:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (2, '2008-12-12', '8:00:00', '11:00:00');

INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (3, '2008-12-13', '11:00:00', '14:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (3, '2008-12-14', '10:00:00', '14:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (4, '2008-12-14', '11:00:00', '13:00:00');
INSERT INTO `schedule` (`employee_no`, `date`, `start_time`, `end_time`) VALUE (4, '2008-12-15', '10:00:00', '14:00:00');

INSERT INTO `scheduleexception` (`date`, `reason`) VALUE ('2008-12-25', 'Christmas Day');

INSERT INTO `availabilityexception` (`employee_no`,`date`,`reason`) VALUE (1, '2008-12-12', 'Ski Trip');
INSERT INTO `availabilityexception` (`employee_no`,`date`,`reason`) VALUE (2, '2008-12-31', 'Vacation');