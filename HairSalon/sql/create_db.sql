/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE=`NO_AUTO_VALUE_ON_ZERO` */;

CREATE DATABASE IF NOT EXISTS cmps350_hairsalon;
USE cmps350_hairsalon;

SOURCE ./db/salon_db.sql
SOURCE ./db/product_db.sql
SOURCE ./db/client_db.sql
SOURCE ./db/schedule_db.sql
SOURCE ./db/service_db.sql
SOURCE ./db/address_db.sql
SOURCE ./db/employee_db.sql
SOURCE ./db/employee_service_db.sql
SOURCE ./db/employee_hours_db.sql
SOURCE ./db/service_product_db.sql
SOURCE ./db/supplier_db.sql
SOURCE ./db/supplier_product_db.sql
SOURCE ./db/schedule_exception_db.sql
SOURCE ./db/schedule_hours_db.sql
SOURCE ./db/availability_exception_db.sql
SOURCE ./db/sale_db.sql
SOURCE ./db/sale_product_db.sql
SOURCE ./db/sale_service_db.sql
SOURCE ./db/appointment_db.sql
SOURCE ./db/appointment_service_db.sql
SOURCE ./db/appointment_product_db.sql
SOURCE ./db/alert_db.sql

SOURCE ./sp/address.sql
SOURCE ./sp/appointment.sql
SOURCE ./sp/availability_exception.sql
SOURCE ./sp/client.sql
SOURCE ./sp/employee.sql
SOURCE ./sp/employee_hours.sql
SOURCE ./sp/product.sql
SOURCE ./sp/sale.sql
SOURCE ./sp/salon.sql
SOURCE ./sp/schedule.sql
SOURCE ./sp/schedule_exception.sql
SOURCE ./sp/schedule_hours.sql
SOURCE ./sp/service.sql
SOURCE ./sp/supplier.sql
SOURCE ./sp/alert.sql

SOURCE ./data/salon_data.sql
SOURCE ./data/client_data.sql
SOURCE ./data/product_data.sql
SOURCE ./data/service_data.sql
SOURCE ./data/address_data.sql
SOURCE ./data/employee_data.sql
SOURCE ./data/supplier_data.sql
SOURCE ./data/schedule_data.sql

SOURCE ./data/sale_data.sql
SOURCE ./data/saleservice_data.sql
SOURCE ./data/saleproduct_data.sql

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;