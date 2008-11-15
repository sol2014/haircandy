/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.app;

import java.util.*;

import hs.core.*;
import hs.objects.*;
import hs.persistence.*;
import hs.persistence.brokers.*;
import java.text.ParseException;

/**
 * Responsible for controller all actions that are taken by the user session
 * browsing the site. Allows a range of activities from logging in to loading
 * and saving records or performing schedule and appointment algorithms.
 * 
 * @author Philippe Durand
 */
public class SessionController
{
	/**
	 * The sessions that are currently being controlled.
	 */
	private static Vector<UserSession> sessions = new Vector<UserSession> ();

	/**
	 * Register a new user session using an existing employee object.
	 * 
	 * @param employee the employee to be used in the new session.
	 * @return the newly created user session.
	 */
	public static UserSession newSession (EmployeeBean employee)
	{
		UserSession userSession = new UserSession (employee);

		sessions.add (userSession);

		return userSession;
	}

	/**
	 * Register a new user session for a guest.
	 * 
	 * @return the user session created.
	 */
	public static UserSession newSession ()
	{
		UserSession userSession = new UserSession ();

		sessions.add (userSession);

		return userSession;
	}

	/**
	 * Removes a specified session from the list of controlled sessions.
	 * 
	 * @param session the session to be removed.
	 */
	public static void removeSession (UserSession session)
	{
		if (sessions.contains (session))
		{
			sessions.remove (session);
		}
		else
		{
			LogController.write ("SessionController->Attempted to delete a user session that does not exist!");
		}
	}

	/**
	 * Authenticate the employee using the persistence controller and return true
	 * if the employee details are valid.
	 * 
	 * @return whether the employee is authenticated or not.
	 */
	public static boolean authenticateSession (UserSession session, String id, String password)
	{
		if (id == null || password == null || id.length () < 1 || password.length () < 1)
		{
			return false;
		}

		LogController.write ("SessionController->Authenticating employee: " + id);

		EmployeeBean employee = new EmployeeBean ();
		AddressBean address = new AddressBean ();
		employee.setAddress (address);
		employee.setEmployeeNo (Integer.parseInt (id));
		employee.setPassword (password);

		DataBean[] employees = PersistenceController.search (employee);

		if (employees.length < 1)
		{
			// Could not authenticate.
			LogController.write ("SessionController->Employee could not be authenticated!");
			session.setAuthenticated (false);
		}
		else if (employees.length > 1)
		{
			// Problem with result set.
			LogController.write ("SessionController->Received multiple results on employee authentication!");
			session.setAuthenticated (false);
		}
		else
		{
			// One result left over, we authenticated.
			LogController.write ("SessionController->Employee has been authenticated, loading employee.");

			session.setEmployee ((EmployeeBean) PersistenceController.load (employee));
			session.setAuthenticated (true);
		}

		return session.isAuthenticated ();
	}

	/**
	 * Removes authentication status from a user session, this will remove the
	 * employee that is associated with the session and make the session a
	 * guest session again.
	 * 
	 * @param session the session to deauthenticate.
	 */
	public static void deauthenticateSession (UserSession session)
	{
		LogController.write ("SessionController->Deauthenticating employee: " + session.getEmployee().getEmployeeNo ());
		
		session.setAuthenticated (false);
		session.setEmployee (null);
	}
	
	// SEARCH FUNCTIONS
	/**
	 * Allows a user session to search for employees from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param employee the employee data that is being used for the search.
	 * @return the employee array containing the results.
	 */
	public static EmployeeBean[] searchEmployees (UserSession session, EmployeeBean employee)
	{
		LogController.write ("SessionController->Searching for employees...");
		return (EmployeeBean[]) PersistenceController.search (employee);
	}

	/**
	 * Allows a user session to search for sales from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param sale the sale data that is being used for the search.
	 * @return the sale array containing the results.
	 */
	public static SaleBean[] searchSales (UserSession userSession, SaleBean sale)
	{
		LogController.write ("SessionController->Searching for sales...");
		return (SaleBean[]) PersistenceController.search (sale);
	}

	/**
	 * Allows a user session to search for suppliers from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param supplier the supplier data that is being used for the search.
	 * @return the supplier array containing the results.
	 */
	public static SupplierBean[] searchSuppliers (UserSession session, SupplierBean supplier)
	{
		LogController.write ("SessionController->Searching for suppliers...");
		return (SupplierBean[]) PersistenceController.search (supplier);
	}

	/**
	 * Allows a user session to search for products from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param product the product data that is being used for the search.
	 * @return the product array containing the results.
	 */
	public static ProductBean[] searchProducts (UserSession session, ProductBean product)
	{
		LogController.write ("SessionController->Searching for products...");
		return (ProductBean[]) PersistenceController.search (product);
	}

	/**
	 * Allows a user session to search for services from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param service the service data that is being used for the search.
	 * @return the service array containing the results.
	 */
	public static ServiceBean[] searchServices (UserSession session, ServiceBean service)
	{
		LogController.write ("SessionController->Searching for services...");
		return (ServiceBean[]) PersistenceController.search (service);
	}

	/**
	 * Allows a user session to search for clients from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the search.
	 * @param cient the client data that is being used for the search.
	 * @return the client array containing the results.
	 */
	public static ClientBean[] searchClients (UserSession session, ClientBean client)
	{
		LogController.write ("SessionController->Searching for clients...");
		return (ClientBean[]) PersistenceController.search (client);
	}

	public static AppointmentBean[] searchAppointments (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Searching for appointments...");
		return (AppointmentBean[]) PersistenceController.search (appointment);
	}

	public static ScheduleBean[] searchSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Searching for schedule...");
		return (ScheduleBean[]) PersistenceController.search (schedule);
	}
	
	public static ScheduleExceptionBean[] searchScheduleExceptions (UserSession session, ScheduleExceptionBean exception)
	{
		LogController.write ("SessionController->Searching for schedule exceptions...");
		return (ScheduleExceptionBean[]) PersistenceController.search (exception);
	}
	
	public static AvailabilityExceptionBean[] searchAvailabilityExceptions (UserSession session, AvailabilityExceptionBean exception)
	{
		LogController.write ("SessionController->Searching for availability exceptions...");
		return (AvailabilityExceptionBean[]) PersistenceController.search (exception);
	}
	
	// LOAD FUNCTIONS
	/**
	 * Allows a user session to load a salon bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param salon the salon data is that is being used for the load.
	 * @return the salon object that resulted.
	 */
	public static SalonBean loadSalon (UserSession session, SalonBean salon)
	{
		LogController.write ("SessionController->Loading salon...");
		return (SalonBean) PersistenceController.load (salon);
	}

	/**
	 * Allows a user session to load a client bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param client the client data is that is being used for the load.
	 * @return the client object that resulted.
	 */
	public static ClientBean loadClient (UserSession session, ClientBean client)
	{
		LogController.write ("SessionController->Loading client...");
		client = (ClientBean) PersistenceController.load (client);

		AddressBean address = (AddressBean) PersistenceController.load (client.getAddress ());

		client.setAddress (address);

		return client;
	}

	/**
	 * Allows a user session to load a service bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param service the service data is that is being used for the load.
	 * @return the service object that resulted.
	 */
	public static ServiceBean loadService (UserSession session, ServiceBean service)
	{
		LogController.write ("SessionController->Loading service...");
		
		service = (ServiceBean) PersistenceController.load (service);

		return service;
	}

	public static AppointmentBean loadAppointment (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Loading appointment...");
		
		appointment = (AppointmentBean) PersistenceController.load (appointment);
		
		if (appointment != null)
		{
			ClientBean client = (ClientBean) PersistenceController.load (appointment.getClient ());

			EmployeeBean employee = (EmployeeBean) PersistenceController.load (appointment.getEmployee ());

			appointment.setClient (client);

			appointment.setEmployee (employee);
		}
		
		return appointment;
	}
	
	public static SaleBean loadSale (UserSession session, SaleBean sale)
	{
		LogController.write ("SessionController->Loading sale...");
		
		sale = (SaleBean) PersistenceController.load (sale);

		if (sale != null)
		{
			ClientBean client = (ClientBean) PersistenceController.load (sale.getClient ());

			EmployeeBean employee = (EmployeeBean) PersistenceController.load (sale.getEmployee ());

			sale.setClient (client);

			sale.setEmployee (employee);
		}
		
		for (ProductBean product : sale.getProductSold ().keySet ())
		{
			product.clone (loadProduct (session, product));
		}
		
		for (ServiceBean service : sale.getServiceSold ().keySet ())
		{
			service.clone (loadService (session, service));
		}
		
		return sale;
	}

	/**
	 * Allows a user session to load a address bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param address the address data is that is being used for the load.
	 * @return the address object that resulted.
	 */
	public static AddressBean loadAddress (UserSession session, AddressBean address)
	{
		LogController.write ("SessionController->Loading address...");
		
		address = (AddressBean) PersistenceController.load (address);
		return address;
	}
	
	public static EmployeeHoursBean loadEmployeeHours (UserSession session, EmployeeHoursBean employeeHours)
	{
		LogController.write ("SessionController->Loading employee hours entry...");
		Date date = employeeHours.getDate ();
		
		employeeHours = (EmployeeHoursBean) PersistenceController.load (employeeHours);
		
		return employeeHours;
	}
	
	public static ScheduleExceptionBean loadScheduleException (UserSession session, ScheduleExceptionBean ex)
	{
		LogController.write ("SessionController->Loading schedule exception bean...");
		
		ScheduleExceptionBean result = (ScheduleExceptionBean)PersistenceController.load (ex);
		return result;
	}
	
	public static ScheduleHoursBean loadScheduleHours (UserSession session, ScheduleHoursBean scheduleHours)
	{
		LogController.write ("SessionController->Loading schedule hours entry...");
		Date date = scheduleHours.getDate ();
		
		scheduleHours = (ScheduleHoursBean) PersistenceController.load (scheduleHours);
		
		if (scheduleHours == null && date != null)
		{
			// We must always have schedule hours available no matter what, in
			// this case, we create a new using default business hours from salon.
			SalonBean salon = SessionController.loadSalon(session, new SalonBean());
			int weekDay = CoreTools.getWeekDay(date);
			
		    scheduleHours = new ScheduleHoursBean ();
		    scheduleHours.setDate (date);
		    scheduleHours.setStartTime (salon.getWeekdayStartTime(weekDay));
		    scheduleHours.setEndTime (salon.getWeekdayEndTime(weekDay));
		    saveScheduleHours (session, scheduleHours);
		}
		
		return scheduleHours;
	}
	
	public static ScheduleBean loadSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Loading schedule entry...");
		
		schedule = (ScheduleBean) PersistenceController.load (schedule);
		return schedule;
	}

	/**
	 * Allows a user session to load a product bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param product the product data is that is being used for the load.
	 * @return the product object that resulted.
	 */
	public static ProductBean loadProduct (UserSession session, ProductBean product)
	{
		LogController.write ("SessionController->Loading product...");
		
		product = (ProductBean) PersistenceController.load (product);
		return product;
	}

	/**
	 * Allows a user session to load a supplier bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param supplier the supplier data is that is being used for the load.
	 * @return the supplier object that resulted.
	 */
	public static SupplierBean loadSupplier (UserSession session, SupplierBean supplier)
	{
		LogController.write ("SessionController->Loading supplier...");
		
		supplier = (SupplierBean) PersistenceController.load (supplier);
		return supplier;
	}

	/**
	 * Allows a user session to load a employee bean from the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the load.
	 * @param employee the employee data is that is being used for the load.
	 * @return the employee object that resulted.
	 */
	public static EmployeeBean loadEmployee (UserSession session, EmployeeBean employee)
	{
		LogController.write ("SessionController->Loading employee...");
		
		// Load the employee record itself.
		employee = (EmployeeBean) PersistenceController.load (employee);

		if (employee != null)
		{
			// Load the address bean that is associated with the employee.
			AddressBean address = (AddressBean) PersistenceController.load (employee.getAddress ());
			employee.setAddress (address);
		}

		return employee;
	}

	// SAVE FUNCTIONS
	/**
	 * Allows the user session to save a address bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param address the address data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveAddress (UserSession session, AddressBean address)
	{
		LogController.write ("SessionController->Saving address...");
		
		boolean result = false;
		result = PersistenceController.commit (address);
		return result;
	}

	public static boolean deleteAlerts (UserSession session)
	{
		LogController.write ("SessionController->Deleting alerts...");
		boolean result = false;
		result = PersistenceController.delete (new AlertBean ());
		return result;
	}
	
	public static boolean deleteAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Deleting alert...");
		boolean result = false;
		result = PersistenceController.delete (alert);
		return result;
	}
	
	public static boolean deleteAppointment (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Deleting appointment entry...");
		boolean result = false;
		result = PersistenceController.delete (appointment);
		return result;
	}
	public static boolean deleteSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Deleting schedule entry...");
		
		boolean result = false;
		result = PersistenceController.delete (schedule);
		return result;
	}
	
	public static boolean saveAppointment (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Saving appointment entry...");
		
		boolean result = false;
		result = PersistenceController.commit (appointment);
		return result;
	}
	
	public static boolean saveEmployeeHours (UserSession session, EmployeeHoursBean employeeHours)
	{
		LogController.write ("SessionController->Saving employee hours entry...");
		boolean result = false;
		result = PersistenceController.commit (employeeHours);
		return result;
	}
	
	public static boolean saveScheduleHours (UserSession session, ScheduleHoursBean scheduleHours)
	{
		LogController.write ("SessionController->Saving schedule hours entry...");
		
		boolean result = false;
		result = PersistenceController.commit (scheduleHours);
		
		return result;
	}
	
	public static boolean saveSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Saving schedule entry...");
		
		// When we save a schedule entry, this is the time we want to see if
		// we already have employee hours set out for that date. If we dont
		// we need to create them so that the future changes wont affect this
		// day of schedule entries.
		
		EmployeeHoursBean ehb = new EmployeeHoursBean ();
		ehb.setEmployeeNo (schedule.getEmployee ().getEmployeeNo ());
		ehb.setDate (schedule.getDate ());
		
		ehb = loadEmployeeHours (session, ehb);
		
		if (ehb == null)
		{
			// We do not have employee hours available, we need to create them.
			ehb = new EmployeeHoursBean ();
			ehb.setEmployeeNo (schedule.getEmployee().getEmployeeNo ());
			ehb.setDate (schedule.getDate ());
			
			// Make sure we have the latest employee data.
			EmployeeBean employee = schedule.getEmployee();
			employee = loadEmployee (session, employee);
			
			int weekday = CoreTools.getWeekDay (ehb.getDate ());
			Date startTime = employee.getWeekdayStartTime (weekday);
			Date endTime = employee.getWeekdayEndTime (weekday);
			ehb.setStartTime (startTime);
			ehb.setEndTime (endTime);
			
			if (!saveEmployeeHours (session, ehb))
			{
				LogController.write ("SessionController->Unable to store employee hours! This is bad.");
			}
		}
		
		boolean result = false;
		result = PersistenceController.commit (schedule);
		return result;
	}

	/**
	 * Allows the user session to save a service bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param service the service data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveService (UserSession session, ServiceBean service)
	{
		LogController.write ("SessionController->Saving service...");
		
		boolean result = false;

		result = PersistenceController.commit (service);

		return result;
	}

	public static boolean saveSale (UserSession session, SaleBean sale)
	{
		LogController.write ("SessionController->Saving sale...");
		
		boolean result = false;

		ClientBean searchClient = new ClientBean ();
		AddressBean searchAddress = new AddressBean ();
		searchClient.setAddress (searchAddress);
		searchClient.setPhoneNumber (sale.getClient ().getPhoneNumber ());

		// First thing we want to do is organize the lient bean first.
		ClientBean[] loadedClient = (ClientBean[]) PersistenceController.search (searchClient);

		if (loadedClient.length < 1)
		{
			// the client does not exist, we need to commit the client.
			if (!PersistenceController.commit (sale.getClient ().getAddress ()))
			{
				LogController.write ("SessionController->Unable to commit new client address bean to database!");
			}
			else
			{
				if (!PersistenceController.commit (sale.getClient ()))
				{
					// The commit failed, we cannot match the client.
					LogController.write ("SessionController->Unable to commit new client bean to database!");
				}
			}
		}
		else
		{
			sale.setClient (loadedClient[0]);
		}

		boolean isnew = false;
		if (sale.getTransactionNo () == null)
		{
			isnew = true;
		}

		result = PersistenceController.commit (sale);

		if (result && isnew)
		{
			// This is a first time commit of this sale. We should update inventory.
			ArrayList<ProductBean> lowProducts = new ArrayList<ProductBean> ();
			
			for (ProductBean product : sale.getProductSold ().keySet ())
			{
				int quantity = sale.getProductSold ().get (product);
				quantity = quantity * product.getQtyPer ();

				ProductBean loadedProduct = loadProduct (session, product);

				if (loadedProduct != null)
				{
					loadedProduct.setStockQty (loadedProduct.getStockQty () - quantity);
					
					// Check if the stock quantity is low.
					if (loadedProduct.getMinLevel () >= loadedProduct.getStockQty ())
					{
						// WE MUST ADD MANAGER ALERT FOR LOW INVENTORY OF THIS ITEM.
						if (!lowProducts.contains (loadedProduct))
							lowProducts.add (loadedProduct);
					}
					
					if (!saveProduct (session, loadedProduct))
					{
						LogController.write ("SessionController->Unable to save product after modifying inventory.");
						continue;
					}
					else
					{
						LogController.write ("SessionController->Modified inventory by [" + quantity + "] for product [" + loadedProduct.getProductNo () + "] sold in sale [" + sale.getTransactionNo () + "].");
					}
				}
			}
			
			for (ServiceBean service : sale.getServiceSold ().keySet ())
			{
				for (ProductBean product : service.getProductUse ().keySet ())
				{
					int quantity = service.getProductUse ().get (product);

					ProductBean loadedProduct = loadProduct (session, product);
					
					if (loadedProduct != null)
					{
						loadedProduct.setStockQty (loadedProduct.getStockQty () - quantity);

						// Check if the stock quantity is low.
						if (loadedProduct.getMinLevel () >= loadedProduct.getStockQty ())
						{
							// WE MUST ADD MANAGER ALERT FOR LOW INVENTORY OF THIS ITEM.
							if (!lowProducts.contains (loadedProduct))
								lowProducts.add (loadedProduct);
						}
						
						if (!saveProduct (session, loadedProduct))
						{
							LogController.write ("SessionController->Unable to save product after modifying inventory.");
							continue;
						}
						else
						{
							LogController.write ("SessionController->Modified inventory by [" + quantity + "] for product [" + loadedProduct.getProductNo () + "] sold in sale [" + sale.getTransactionNo () + "].");
						}
					}
				}
			}
			
			// Deal with all the products that we have found to be low.
			for (ProductBean lowProd : lowProducts)
			{
				AlertBean alert = new AlertBean ();
				alert.setType (AlertTypes.Inventory.toString ());
				alert.setRecordNo (lowProd.getProductNo ());
				
				alert = loadAlert (session, alert);
				
				if (alert == null)
				{
					alert = new AlertBean ();
					alert.setDate (new Date());
					alert.setRecordNo (lowProd.getProductNo ());
					alert.setType (AlertTypes.Inventory.toString ());
				}
				
				alert.setLink ("product?product_action=Load&product_no="+alert.getRecordNo ());
				
				double min = lowProd.getMinLevel ();
				double current = lowProd.getStockQty ();
				double percent = current / min;
				
				if (percent <= 0.0)
				{
					alert.setLevel ("High");
					alert.setMessage ("Product ["+lowProd.getName ()+"] is out of stock!");
				}
				else if (percent <= 0.50)
				{
					alert.setLevel ("Medium");
					alert.setMessage ("Product ["+lowProd.getName ()+"] is almost out of stock ["+current+"/"+min+"].");
				}
				else if (percent > 0.50)
				{
					alert.setLevel ("Low");
					alert.setMessage ("Product ["+lowProd.getName ()+"] is under the minimum quantity ["+current+"/"+min+"].");
				}
				
				saveAlert (session, alert);
			}
		}

		return result;
	}

	/**
	 * Allows the user session to save a supplier bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param supplier the supplier data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveSupplier (UserSession session, SupplierBean supplier)
	{
		LogController.write ("SessionController->Saving supplier...");
		
		boolean result = false;
		result = PersistenceController.commit (supplier);
		return result;
	}

	/**
	 * Allows the user session to save an employee bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param employee the employee data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveEmployee (UserSession session, EmployeeBean employee)
	{
		LogController.write ("SessionController->Saving employee...");
		
		boolean result = false;

		// Save the address record.
		result = PersistenceController.commit (employee.getAddress ());

		// Finally save the employee record.
		result = PersistenceController.commit (employee);

		// Availability exceptions should be cleared and re-created.
		AvailabilityExceptionBean exception = new AvailabilityExceptionBean ();
		exception.setEmployeeNo (employee.getEmployeeNo ());
		PersistenceController.delete (exception);

		// Now lets store the exceptions anew.
		if (employee.getAvailabilityExceptions () != null && employee.getAvailabilityExceptions ().size () > 0)
		{
			for (AvailabilityExceptionBean cycle : employee.getAvailabilityExceptions ())
			{
				LogController.write ("Committing a exception for employee.");
				result = PersistenceController.commit (cycle);
			}
		}

		return result;
	}

	/**
	 * Allows the user session to save a product bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param product the product data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveProduct (UserSession session, ProductBean product)
	{
		LogController.write ("SessionController->Saving product...");
		
		boolean result = false;

		result = PersistenceController.commit (product);

		return result;
	}

	/**
	 * Allows the user session to save a client bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param client the client data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveClient (UserSession session, ClientBean client)
	{
		LogController.write ("SessionController->Saving client...");
		
		boolean result = PersistenceController.commit (client.getAddress ());

		result = PersistenceController.commit (client);

		return result;
	}

	/**
	 * Allows the user session to save a salon bean using the persistence
	 * controller.
	 * 
	 * @param session the session that is doing the save.
	 * @param salon the salon data to be saved.
	 * @return whether the save was successfull or not.
	 */
	public static boolean saveSalon (UserSession session, SalonBean salon)
	{
		LogController.write ("SessionController->Saving salon...");
		
		boolean result = PersistenceController.commit (salon);

		// Availability exceptions should be cleared and re-created.
		ScheduleExceptionBean exception = new ScheduleExceptionBean ();
		PersistenceController.delete (exception);

		// Now lets store the exceptions anew.
		if (salon.getExceptions () != null && salon.getExceptions ().size () > 0)
		{
			for (ScheduleExceptionBean cycle : salon.getExceptions ())
			{
				LogController.write ("Committing a exception for salon.");
				result = PersistenceController.commit (cycle);
			}
		}
		
		return result;
	}

	public static AlertBean loadAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Loading alert...");
		
		alert = (AlertBean)PersistenceController.load (alert);
		
		return alert;
	}
	
	public static AlertBean[] loadAlerts (UserSession session)
	{
		LogController.write ("SessionController->Loading alerts...");
		
		AlertBean[] alerts = new AlertBean[0];

		if (!session.isGuest ())
		{
			AlertBean alert = new AlertBean ();
			alerts = (AlertBean[]) PersistenceController.search (alert);
		}
		else
		{
			LogController.write ("SessionController->Cannot load employee alerts if you are a guest.");
		}

		return alerts;
	}
	
	public static boolean saveAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Saving alert...");
		
		boolean result = false;
		result = PersistenceController.commit (alert);
		return result;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<AppointmentBean>> getAppointments (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions)
	{
		LogController.write ("SessionController->Getting filtered appointments...");
		
		Hashtable<EmployeeBean, ArrayList<AppointmentBean>> hash = new Hashtable<EmployeeBean, ArrayList<AppointmentBean>> ();
		
		if (scheduleExceptions != null && scheduleExceptions.size () > 0)
		{
			// We have a schedule exception for this date, that means we are not going to be sending in ANY data.
			return null;
		}
		
		AppointmentBean appointment = new AppointmentBean ();
		appointment.setDate (date);
		AppointmentBean[] appEntries = searchAppointments (session, appointment);

		ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean> ();
		for (AppointmentBean cycle : appEntries)
		{
			if (!employees.contains (cycle.getEmployee ()))
			{
				employees.add (cycle.getEmployee ());
			}
		}

		for (EmployeeBean cycle : employees)
		{
			ArrayList<AppointmentBean> cycleEntries = new ArrayList<AppointmentBean> ();

			for (AppointmentBean cycleEntry : appEntries)
			{
				if (cycleEntry.getEmployee ().equals (cycle))
				{
					cycleEntries.add (cycleEntry);
				}
			}

			hash.put (cycle, cycleEntries);
		}

		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getUnschedulable (UserSession session, java.util.Date date, ScheduleHoursBean hours)
	{
		LogController.write ("SessionController->Getting filtered unschedulable time...");
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		
		Date startTime = hours.getStartTime ();
		Date endTime = hours.getEndTime ();
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setAddress (new AddressBean ());
		
		EmployeeBean[] employees = searchEmployees (session, employee);
		
		for (EmployeeBean cycle : employees)
		{
			Date workStart = null;
			Date workEnd = null;
			
			// Here we want to see if there is already existing employee hours data.
			EmployeeHoursBean ehb = new EmployeeHoursBean ();
			ehb.setEmployeeNo (cycle.getEmployeeNo ());
			ehb.setDate (date);
			
			ehb = loadEmployeeHours (session, ehb);
			
			if (ehb == null)
			{
				// We have never stored the hours before, just use the regular.
				workStart = cycle.getWeekdayStartTime (CoreTools.getWeekDay (date));
				workEnd = cycle.getWeekdayEndTime (CoreTools.getWeekDay (date));
			}
			else
			{
				// We do have employee hours for this day, lets use those.
				workStart = ehb.getStartTime ();
				workEnd = ehb.getEndTime ();
			}
			
			ArrayList<ScheduleBean> unschedulable = new ArrayList<ScheduleBean> ();
			
			if (!CoreTools.isTimeBefore (workStart, startTime))
			{
				// The employee's start time is after the day start time.
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (cycle);
				entry.setDate (date);
				entry.setStartTime (startTime);
				entry.setEndTime (workStart);
				
				unschedulable.add (entry);
			}
			
			if (!CoreTools.isTimeBefore (endTime, workEnd))
			{
				// The end time is not before the available end time.
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (cycle);
				entry.setDate (date);
				entry.setStartTime (workEnd);
				entry.setEndTime (endTime);
				
				unschedulable.add (entry);
			}
			
			hash.put (cycle, unschedulable);
		}
		
		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getUnavailable (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions, ScheduleHoursBean hours)
	{
		LogController.write ("SessionController->Getting filtered unavailable time...");
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedule = getAllSchedule (session, date, availabilityExceptions, scheduleExceptions);
		
		Date startTime = hours.getStartTime ();
		Date endTime = hours.getEndTime ();
		
		if (startTime.equals (endTime))
			return null;
		
		if (schedule == null)
		{
			ScheduleBean sch = new ScheduleBean ();
			sch.setDate (date);
			
			ScheduleBean[] scheduleEntries = searchSchedule (session, sch);

			ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean> ();
			for (ScheduleBean cycle : scheduleEntries)
			{
				if (!employees.contains (cycle.getEmployee ()))
				{
					employees.add (cycle.getEmployee ());
				}
			}
			
			// Then we want to give ALL unavailable time.
			for (EmployeeBean employee : employees)
			{
				ArrayList<ScheduleBean> unavailable = new ArrayList<ScheduleBean> ();
				
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (employee);
				entry.setDate (date);
				entry.setStartTime (startTime);
				entry.setEndTime (endTime);
				unavailable.add (entry);
				
				hash.put (employee, unavailable);
			}
			
			return hash;
		}
		
		for (EmployeeBean employee : schedule.keySet ())
		{
			ArrayList<Date> times = new ArrayList<Date> ();
			ArrayList<ScheduleBean> working = schedule.get(employee);
			ArrayList<ScheduleBean> unavailable = new ArrayList<ScheduleBean> ();
			
			Date lastTime = null;
			
			times.add (startTime);
			lastTime = startTime;
			
			Collections.sort(working, new ScheduleStartTimeComparator());
			
			boolean addedStart = false;
			
			if (working != null && !startTime.equals (endTime))
			{
				for (ScheduleBean entry : working)
				{
					if (!lastTime.equals (entry.getStartTime ()))
					{
						times.add (entry.getStartTime ());
						addedStart = true;
					}
					else
						addedStart = false;
					
					if (!addedStart)
						times.remove (times.size()-1);
					
					times.add (entry.getEndTime ());
					lastTime = entry.getEndTime ();
				}
			}
			
			// Now, we will have our final unavailable slot either 
			if (lastTime != null && !lastTime.equals (endTime))
				times.add (endTime);
			else
				times.remove (times.size()-1);
			
			// Now we have all the times in order, lets make the unavailable time entries.
			while (!times.isEmpty ())
			{
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (employee);
				entry.setDate (date);
				entry.setStartTime (times.remove (0));
				entry.setEndTime (times.remove (0));
				
				// Make sure this entry has actual time.
				if (!entry.getStartTime ().equals (entry.getEndTime()) && entry.getStartTime ().before (entry.getEndTime ()))
					unavailable.add (entry);
			}
			
			hash.put (employee, unavailable);
		}
		
		// To reverse the schedule entries, we must first get the schedule entries themselves.
		
		return hash;
	}
	
	public static ArrayList<ScheduleBean> getSchedule (UserSession session, java.util.Date date)
	{
		LogController.write ("SessionController->Getting unfiltered schedule...");
		
		ArrayList<ScheduleBean> hash = new ArrayList<ScheduleBean> ();
		
		ScheduleBean schedule = new ScheduleBean ();
		schedule.setDate (date);
		ScheduleBean[] scheduleEntries = searchSchedule (session, schedule);
		
		for (ScheduleBean bean : scheduleEntries)
			hash.add (bean);
		
		if (hash.size() < 1)
			return null;
		
		return hash;
	}
	
	public static ArrayList<ScheduleBean> getEmployeeSchedule (UserSession session, EmployeeBean employee, java.util.Date date)
	{
		LogController.write ("SessionController->Getting employee schedule...");
		
		ArrayList<ScheduleBean> hash = new ArrayList<ScheduleBean> ();
		
		ScheduleBean schedule = new ScheduleBean ();
		schedule.setDate (date);
		schedule.setEmployee (employee);
		ScheduleBean[] scheduleEntries = searchSchedule (session, schedule);
		
		for (ScheduleBean bean : scheduleEntries)
			hash.add (bean);
		
		if (hash.size() < 1)
			return null;
		
		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getUnmovableSchedule (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedule)
	{
		LogController.write ("SessionController->Getting filtered unmovable schedule...");
		
		if (!session.getEmployee ().getRole ().equals ("Manager"))
			return schedule;
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		
		// We need to come up with the schedule entries that cannot be moved.
		
		if (schedule == null)
			return null;
		
		for (EmployeeBean employee : schedule.keySet ())
		{
			ArrayList<ScheduleBean> list = schedule.get (employee);
			ArrayList<ScheduleBean> newList = new ArrayList <ScheduleBean> ();
			
			for (ScheduleBean entry : list)
			{
				// now that we are looking at one schedule entry for 1 person, find out if there are 
				// appointments booked during this time.
				AppointmentBean app = new AppointmentBean ();
				app.setDate (date);
				app.setEmployee (employee);
				
				AppointmentBean[] apps = searchAppointments (session, app);
				
				boolean fails = false;
				
				// If we have appointment entries, include this schedule entry for the final list.
				for (AppointmentBean ab : apps)
				{
					if (ab.getStartTime ().equals (entry.getStartTime()) || (ab.getStartTime ().after (entry.getStartTime ())) && (ab.getStartTime().equals (entry.getEndTime ()) || (ab.getStartTime ().before (entry.getEndTime ()))))
						fails = true;
					
					if (ab.getEndTime ().equals (entry.getEndTime()) || ab.getEndTime ().after (entry.getStartTime ()) && (ab.getEndTime ().before (entry.getEndTime ())))
						fails = true;
				}
				
				if (fails)
				{
					newList.add (entry);
				}
			}
			
			hash.put (employee, newList);
		}
		
		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getMovableSchedule (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedule)
	{
		LogController.write ("SessionController->Getting filtered unmovable schedule...");
		
		if (!session.getEmployee ().getRole ().equals ("Manager"))
			return null;
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		
		// We need to come up with the schedule entries that can be moved.
		if (schedule == null)
			return null;
		
		for (EmployeeBean employee : schedule.keySet ())
		{
			ArrayList<ScheduleBean> list = schedule.get (employee);
			ArrayList<ScheduleBean> newList = new ArrayList <ScheduleBean> ();
			
			for (ScheduleBean entry : list)
			{
				// now that we are looking at one schedule entry for 1 person, find out if there are 
				// appointments booked during this time.
				AppointmentBean app = new AppointmentBean ();
				app.setDate (date);
				app.setEmployee (employee);
				
				AppointmentBean[] apps = searchAppointments (session, app);
				
				if (apps == null || apps.length < 1)
				{
					// We have no entries! Its movable!
					newList.add (entry);
				}
				else
				{
					boolean fails = false;
					
					for (AppointmentBean ab : apps)
					{
						if (ab.getStartTime ().equals (entry.getStartTime()) || (ab.getStartTime ().after (entry.getStartTime ())) && (ab.getStartTime().equals (entry.getEndTime ()) || (ab.getStartTime ().before (entry.getEndTime ()))))
							fails = true;
					
						if (ab.getEndTime ().equals (entry.getEndTime()) || ab.getEndTime ().after (entry.getStartTime ()) && (ab.getEndTime ().before (entry.getEndTime ())))
							fails = true;
					}

					if (!fails)
					{
						newList.add (entry);
					}
				}
			}
			
			hash.put (employee, newList);
		}
		
		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getAllSchedule (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions)
	{
		LogController.write ("SessionController->Getting filtered schedule...");
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		
		if (scheduleExceptions != null && scheduleExceptions.size () > 0)
		{
			// We have a schedule exception for this date, that means we are not going to be sending in ANY data.
			return null;
		}
		
		ScheduleBean schedule = new ScheduleBean ();
		schedule.setDate (date);
		
		ScheduleBean[] scheduleEntries = searchSchedule (session, schedule);

		ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean> ();
		for (ScheduleBean cycle : scheduleEntries)
		{
			if (!employees.contains (cycle.getEmployee ()))
			{
				employees.add (cycle.getEmployee ());
			}
		}
		
		if (availabilityExceptions != null)
		{
			for (EmployeeBean cycle : availabilityExceptions.keySet())
			{
				if (employees.contains (cycle))
					employees.remove (cycle);
			}
		}
		
		for (EmployeeBean cycle : employees)
		{
			ArrayList<ScheduleBean> cycleEntries = new ArrayList<ScheduleBean> ();

			for (ScheduleBean cycleEntry : scheduleEntries)
			{
				if (cycleEntry.getEmployee ().equals (cycle))
				{
					cycleEntries.add (cycleEntry);
				}
			}

			hash.put (cycle, cycleEntries);
		}
		
		if (hash.size() < 1)
			return null;
		
		return hash;
	}
	
	public static ArrayList<ScheduleExceptionBean> getScheduleExceptions (UserSession session, java.util.Date date)
	{
		LogController.write ("SessionController->Getting filtered schedule exceptions...");
		
		ArrayList<ScheduleExceptionBean> list = new ArrayList<ScheduleExceptionBean> ();
		
		ScheduleExceptionBean exception = new ScheduleExceptionBean ();
		exception.setDate (date);
		
		ScheduleExceptionBean[] exceptionEntries = searchScheduleExceptions (session, exception);
		
		for (ScheduleExceptionBean cycle : exceptionEntries)
		{
			list.add (cycle);
		}
		
		if (list.size() < 1)
			return null;
		
		return list;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> getAvailabilityExceptions (UserSession session, java.util.Date date)
	{
		LogController.write ("SessionController->Getting filtered availability exceptions...");
		
		Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> hash = new Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> ();
		
		AvailabilityExceptionBean exception = new AvailabilityExceptionBean ();
		exception.setDate (date);
		
		AvailabilityExceptionBean[] exceptionEntries = searchAvailabilityExceptions (session, exception);
		
		if (exceptionEntries != null)
		{
			ArrayList<Integer> employees = new ArrayList<Integer> ();
			for (AvailabilityExceptionBean cycle : exceptionEntries)
			{
				if (!employees.contains (cycle.getEmployeeNo ()))
				{
					employees.add (cycle.getEmployeeNo ());
				}
			}

			for (Integer cycle : employees)
			{
				ArrayList<AvailabilityExceptionBean> cycleEntries = new ArrayList<AvailabilityExceptionBean> ();

				for (AvailabilityExceptionBean cycleEntry : exceptionEntries)
				{
					if (cycleEntry.getEmployeeNo ().equals (cycle))
					{
						cycleEntries.add (cycleEntry);
					}
				}

				EmployeeBean employee = new EmployeeBean ();
				employee.setEmployeeNo (cycle);
				hash.put (loadEmployee (session, employee), cycleEntries);
			}
		}
		
		if (hash.size() < 1)
			return null;
		
		return hash;
	}
	
	public static ArrayList<CalendarDayStatus> getAppCalendarStatus (UserSession session, int month, int year)
	{
		ArrayList<CalendarDayStatus> list = new ArrayList<CalendarDayStatus> ();
		int totalDays = CoreTools.getDaysInMonth(year, month);
		
		java.util.Date startDate;
		java.util.Date endDate;
		
		try
		{
			startDate = CoreTools.getDate ("01/"+(month+1)+"/"+year);
			endDate = CoreTools.getDate (totalDays+"/"+(month+1)+"/"+year);
		}
		catch (ParseException e)
		{
			return null;
		}
		
		ScheduleExceptionBean[] exs = (ScheduleExceptionBean [])ScheduleExceptionBroker.getInstance ().searchDateRange (new ScheduleExceptionBean (), startDate, endDate);
		AppointmentBean [] apps = (AppointmentBean [])AppointmentBroker.getInstance ().searchDateRange (new AppointmentBean (), startDate, endDate);
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (startDate);
		
		for (int i = 1; i <= totalDays; i++)
		{
			String exString = "";
			boolean hasEx = false;
			boolean hasApps = false;
			
			for (ScheduleExceptionBean ex : exs)
				if (ex.getDate ().equals (calendar.getTime ()))
				{
					exString = ex.getReason ();
					hasEx = true;
				}
			
			for (AppointmentBean app : apps)
				if (app.getDate ().equals (calendar.getTime ()))
					hasApps = true;
			
			CalendarDayStatus status = new CalendarDayStatus (i, hasApps, hasEx, exString);
			list.add (status);
			calendar.add (Calendar.DAY_OF_YEAR, 1);
		}
		
		return list;
	}
	
	public static ArrayList<CalendarDayStatus> getSchCalendarStatus (UserSession session, int month, int year)
	{
		ArrayList<CalendarDayStatus> list = new ArrayList<CalendarDayStatus> ();
		int totalDays = CoreTools.getDaysInMonth(year, month);
		
		Date startDate;
		Date endDate;
		
		try
		{
			startDate = CoreTools.getDate ("01/"+(month+1)+"/"+year);
			endDate = CoreTools.getDate (totalDays+"/"+(month+1)+"/"+year);
		}
		catch (ParseException e)
		{
			return null;
		}
		
		ScheduleExceptionBean[] exs = (ScheduleExceptionBean [])ScheduleExceptionBroker.getInstance ().searchDateRange (new ScheduleExceptionBean (), startDate, endDate);
		ScheduleBean [] scheds = (ScheduleBean [])ScheduleBroker.getInstance ().searchDateRange (new ScheduleBean (), startDate, endDate);
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (startDate);
		
		for (int i = 1; i <= totalDays; i++)
		{
			String exString = "";
			boolean hasEx = false;
			boolean hasSched = false;
			
			for (ScheduleExceptionBean ex : exs)
				if (ex.getDate ().equals (calendar.getTime ()))
				{
					exString = ex.getReason ();
					hasEx = true;
				}
			
			for (ScheduleBean sched : scheds)
				if (sched.getDate ().equals (calendar.getTime ()))
					hasSched = true;
			
			CalendarDayStatus status = new CalendarDayStatus (i, hasSched, hasEx, exString);
			list.add (status);
			calendar.add (Calendar.DAY_OF_YEAR, 1);
		}
		
		return list;
	}
}
