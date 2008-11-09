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

/**
 * Responsible for controller all actions that are taken by the user session
 * browsing the site. Allows a range of activities from logging in to loading
 * and saving records or performing useful actions.
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
	
	public static boolean saveSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Saving schedule entry...");
		
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
			for (ProductBean low : lowProducts)
			{
				AlertBean alert = new AlertBean ();
				alert.setDate (new Date());
				alert.setRecordNo (low.getProductNo ());
				alert.setType (AlertTypes.Inventory.toString ());
				
				double min = low.getMinLevel ();
				double current = low.getStockQty ();
				double percent = current / min;
				
				if (percent <= 0.25)
					alert.setLevel ("High");
				else if (percent <= 0.50)
					alert.setLevel ("Medium");
				else if (percent > 0.50)
					alert.setLevel ("Low");
				
				if (current < 1)
				{
					alert.setMessage ("The product named ["+low.getName ()+"] is out of stock.");
				}
				else
				{
					alert.setMessage ("The product named ["+low.getName ()+"] is currently under the minimum quantity levels.");
				}
				
				EmployeeBean manager = new EmployeeBean ();
				manager.setRole ("Manager");
				manager.setAddress (new AddressBean ());
				
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
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getUnavailable (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions)
	{
		LogController.write ("SessionController->Getting filtered unavailable time...");
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedule = getSchedule (session, date, availabilityExceptions, scheduleExceptions);
		
		SalonBean salon = new SalonBean();
		salon = loadSalon (session, salon);
		Date startTime = salon.getWeekdayStartTime (CoreTools.getWeekDay (date));
		Date endTime = salon.getWeekdayEndTime (CoreTools.getWeekDay (date));
		
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
			
			Date currentTime = null;
			
			ArrayList<ScheduleBean> working = schedule.get(employee);
			ArrayList<Date> times = new ArrayList<Date> ();
			ArrayList<ScheduleBean> unavailable = new ArrayList<ScheduleBean> ();
			
			times.add (startTime);
			
			if (working != null && !startTime.equals (endTime))
			{
				for (ScheduleBean entry : working)
				{
					// This is 1 schedule entry.
					Date st = entry.getStartTime ();
					Date et = entry.getEndTime ();

					if (currentTime == null)
					{
						currentTime = et;
						times.add (st);
						times.add (et);
					}
					else
					{
						boolean added = false;

						// we have inserted a time before, we will need to see where this fits in.
						for (Date cycle : times)
						{
							if (!st.after (cycle))
							{
								// This should be inserted before cycle
								int index = times.indexOf (cycle);
								times.add (index, et);
								times.add (index, st);
								added = true;
							}
						}

						if (!added)
						{
							times.add (st);
							times.add (et);
						}
					}
				}
			}
			
			times.add (endTime);
			
			// Now we have all the times in order, lets make the unavailable time entries.
			while (!times.isEmpty ())
			{
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (employee);
				entry.setDate (date);
				entry.setStartTime (times.remove (0));
				entry.setEndTime (times.remove (0));
				unavailable.add (entry);
			}
			
			hash.put (employee, unavailable);
		}
		
		// To reverse the schedule entries, we must first get the schedule entries themselves.
		
		return hash;
	}
	
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getSchedule (UserSession session, java.util.Date date, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions)
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
}
