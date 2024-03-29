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
 * using the site. Allows a range of activities from logging in to loading
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
	
	/**
	 * Allows a user session to search for employees using specific criteria.
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
	 * Allows a user session to search for sales using specific criteria.
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
	 * Allows a user session to search for sales using specific criteria and
	 * using a specific date range.
	 * 
	 * @param session the session that is doing the search.
	 * @param sale the sale data that is being used for the search.
	 * @return the sale array containing the results.
	 */
	public static SaleBean[] searchSalesRange (UserSession userSession, SaleBean sale, Date start, Date end)
	{
		LogController.write ("SessionController->Searching for sales within a date range...");
		return (SaleBean[]) SaleBroker.getInstance().searchRange (sale, start, end);
	}
	
	/**
	 * Allows a user session to search for suppliers using specific criteria.
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
	 * Allows a user session to search for products using specific criteria.
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
	 * Allows a user session to search for services using specific criteria.
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
	 * Allows a user session to search for clients using specific criteria.
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

	/**
	 * Allows searching for appointments using specific criteria.
	 * 
	 * @param session the session that is doing the search.
	 * @param appointment the appointment criteria to use when searching.
	 * @return the list of appointments found if any.
	 */
	public static AppointmentBean[] searchAppointments (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Searching for appointments...");
		return (AppointmentBean[]) PersistenceController.search (appointment);
	}

	/**
	 * Allows searching of schedule entries using specific criteria.
	 * 
	 * @param session the session that is doing the search.
	 * @param schedule the schedule criteria to use when searching.
	 * @return the list of schedule entries found if any.
	 */
	public static ScheduleBean[] searchSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Searching for schedule...");
		return (ScheduleBean[]) PersistenceController.search (schedule);
	}
	
	/**
	 * Allows searching of schedule exceptions using specific criteria.
	 * 
	 * @param session the session that is doing the search.
	 * @param exception the exception criteria to use when searching.
	 * @return the list of schedule exceptions found if any.
	 */
	public static ScheduleExceptionBean[] searchScheduleExceptions (UserSession session, ScheduleExceptionBean exception)
	{
		LogController.write ("SessionController->Searching for schedule exceptions...");
		return (ScheduleExceptionBean[]) PersistenceController.search (exception);
	}
	
	/**
	 * Allows searching of availability exceptions using specific criteria.
	 * 
	 * @param session the session doing the search.
	 * @param exception the exception criteria to use when searching.
	 * @return the list of availability exceptions found if any.
	 */
	public static AvailabilityExceptionBean[] searchAvailabilityExceptions (UserSession session, AvailabilityExceptionBean exception)
	{
		LogController.write ("SessionController->Searching for availability exceptions...");
		return (AvailabilityExceptionBean[]) PersistenceController.search (exception);
	}
	
	/**
	 * Allows a user session to load a salon bean using specific criteria.
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
	 * Allows a user session to load a client bean using specific criteria.
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
	 * Allows a user session to load a service bean using specific criteria.
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

	/**
	 * Allows the loading of an appointment record using the specific criteria.
	 * 
	 * @param session the session that is doing the load.
	 * @param appointment the appointment criteria for the load.
	 * @return the appointment that is loaded if any.
	 */
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
		
		for (ProductBean product : appointment.getProducts ().keySet ())
		{
			product.clone (loadProduct (session, product));
		}
		
		for (ServiceBean service : appointment.getServices ().keySet ())
		{
			service.clone (loadService (session, service));
		}
		
		return appointment;
	}
	
	/**
	 * Allows the loading of a sale record using the specified criteria.
	 * 
	 * @param session the user session doing the load.
	 * @param sale the sale criteria to use when loading.
	 * @return the sale that was loaded if any.
	 */
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
	 * Allows the loading of an address record using the specific criteria.
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
	
	/**
	 * Allows the loading of employee hours using the specific criteria.
	 * 
	 * @param session the session that is doing the load.
	 * @param employeeHours the employee hours criteria to use when loading.
	 * @return the employee hours loaded if any.
	 */
	public static EmployeeHoursBean loadEmployeeHours (UserSession session, EmployeeHoursBean employeeHours)
	{
		LogController.write ("SessionController->Loading employee hours entry...");
		Date date = employeeHours.getDate ();
		
		employeeHours = (EmployeeHoursBean) PersistenceController.load (employeeHours);
		
		return employeeHours;
	}
	
	/**
	 * Allows the loading of schedule exceptions using the specified criteria.
	 * 
	 * @param session the session that is doing the load.
	 * @param ex the exception criteria used during the load.
	 * @return the schedule exception loaded if any.
	 */
	public static ScheduleExceptionBean loadScheduleException (UserSession session, ScheduleExceptionBean ex)
	{
		LogController.write ("SessionController->Loading schedule exception bean...");
		
		ScheduleExceptionBean result = (ScheduleExceptionBean)PersistenceController.load (ex);
		return result;
	}
	
	/**
	 * Allows the loading of schedule hours using the specified criteria.
	 * 
	 * @param session the session that is doing the load.
	 * @param scheduleHours the schedule hours criteria to use when loading.
	 * @return the schedule hours loaded if any.
	 */
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
	
	/**
	 * Allows the loading of schedule entries using the specified criteria.
	 * 
	 * @param session the session that is doing the load.
	 * @param schedule the schedule criteria that is used when loading.
	 * @return the schedule entry loaded if any.
	 */
	public static ScheduleBean loadSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Loading schedule entry...");
		
		schedule = (ScheduleBean) PersistenceController.load (schedule);
		return schedule;
	}

	/**
	 * Allows the loading of product record using the specified criteria.
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
	 * Allows the loading a supplier bean using the specified criteria.
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
	 * Allows the loading of an employee bean using the specified criteria.
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

	/**
	 * Allows the saving of an address record using the specified bean.
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

	/**
	 * Allows deleting of all alerts that are in the system.
	 * 
	 * @param session the session that is performing the delete.
	 * @return whether the alerts were deleted or not.
	 */
	public static boolean deleteAlerts (UserSession session)
	{
		LogController.write ("SessionController->Deleting alerts...");
		boolean result = false;
		result = PersistenceController.delete (new AlertBean ());
		return result;
	}
	
	/**
	 * Allows the deletion of a single alert using the specified criteria.
	 * 
	 * @param session the session that is doing the delete.
	 * @param alert the alert object to delete.
	 * @return whether the alert was deleted or not.
	 */
	public static boolean deleteAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Deleting alert...");
		boolean result = false;
		result = PersistenceController.delete (alert);
		return result;
	}
	
	/**
	 * Allows the deletion of an appointment record using the specified bean.
	 * 
	 * @param session the session that is doing the delete.
	 * @param appointment the appointment to be deleted.
	 * @return whether the appointment was deleted or not.
	 */
	public static boolean deleteAppointment (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Deleting appointment entry...");
		boolean result = false;
		result = PersistenceController.delete (appointment);
		return result;
	}
	
	/**
	 * Allows the deletion of a schedule entry using the specified bean.
	 * 
	 * @param session the session doing the deletion.
	 * @param schedule the schedule bean to delete.
	 * @return whether the schedule entry was deleted or not.
	 */
	public static boolean deleteSchedule (UserSession session, ScheduleBean schedule)
	{
		LogController.write ("SessionController->Deleting schedule entry...");
		
		boolean result = false;
		result = PersistenceController.delete (schedule);
		return result;
	}
	
	/**
	 * Allows the saving of an appointment record using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param appointment the appointment to save.
	 * @return whether the appointment was saved or not.
	 */
	public static boolean saveAppointment (UserSession session, AppointmentBean appointment)
	{
		LogController.write ("SessionController->Saving appointment entry...");
		
		boolean result = false;
		result = PersistenceController.commit (appointment);
		return result;
	}
	
	/**
	 * Allows the saving of employee hour records using the specified bean.
	 * This function will determine whether the data being saved is valid or
	 * not.
	 * 
	 * @param session the session doing the save.
	 * @param hours the employee hours to save.
	 * @return whether the employee hours were saved or not.
	 */
	public static boolean saveEmployeeHours (UserSession session, EmployeeHoursBean hours)
	{
		LogController.write ("SessionController->Saving employee hours entry...");
		boolean result = true;
		
		// We have to make sure that these hours do not cause any issues.
		ArrayList<ScheduleBean> schedule = getSchedule (session, hours.getDate ());
		
		Date earliest = null;
		Date latest = null;
		boolean found = false;
		
		if (schedule != null)
		{
			for (ScheduleBean entry : schedule)
			{
				if (entry.getEmployee ().getEmployeeNo ().equals (hours.getEmployeeNo ()))
				{
					found = true;
					
					if (earliest == null)
						earliest = entry.getStartTime ();
					else if (earliest.after (entry.getStartTime()))
						earliest = entry.getStartTime ();

					if (latest == null)
						latest = entry.getEndTime();
					else if (earliest.before (entry.getEndTime ()))
						latest = entry.getEndTime();
				}
			}
			
			if (!found)
			{
				result = true;
			}
			else
			{
				if (hours.getStartTime ().after (earliest))
					result = false;

				if (hours.getEndTime ().before (latest))
					result = false;
			}
		}
		else
			result = true;
		
		if (result)
			result = PersistenceController.commit (hours);
		
		return result;
	}
	
	/**
	 * Allow the saving of schedule hours using the specified bean. This function
	 * will check whether the data being saved is valid or not.
	 * 
	 * @param session the session doing the saving.
	 * @param hours the schedule hours to be saved.
	 * @return whether the schedule hours were saved or not.
	 */
	public static boolean saveScheduleHours (UserSession session, ScheduleHoursBean hours)
	{
		LogController.write ("SessionController->Saving schedule hours entry...");
		
		boolean result = true;
		
		// We have to make sure that these hours do not cause any issues.
		ArrayList<ScheduleBean> schedule = getSchedule (session, hours.getDate ());
		
		Date earliest = null;
		Date latest = null;
		
		if (schedule != null)
		{
			for (ScheduleBean entry : schedule)
			{
				if (earliest == null)
					earliest = entry.getStartTime ();
				else if (earliest.after (entry.getStartTime()))
					earliest = entry.getStartTime ();

				if (latest == null)
					latest = entry.getEndTime();
				else if (earliest.before (entry.getEndTime ()))
					latest = entry.getEndTime();
			}

			if (hours.getStartTime ().after (earliest))
				result = false;

			if (hours.getEndTime ().before (latest))
				result = false;
		}
		else
			result = true;
		
		if (result)
			result = PersistenceController.commit (hours);
		
		return result;
	}
	
	/**
	 * Allows saving of schedule entries using the specified bean. This will
	 * make sure to use the available employee hours to check if the schedule
	 * data is valid.
	 * 
	 * @param session the session doing the saving.
	 * @param schedule the schedule entry to be saved.
	 * @return whether the schedule entry was saved or not.
	 */
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
	 * Allows the saving of service records using the specified service bean.
	 * 
	 * @param session the session doing the saving.
	 * @param service the service to be saved.
	 * @return whether the service was saved or not.
	 */
	public static boolean saveService (UserSession session, ServiceBean service)
	{
		LogController.write ("SessionController->Saving service...");
		
		boolean result = false;

		result = PersistenceController.commit (service);

		return result;
	}

	/**
	 * Allows the saving of sale records using the specified sale bean. This
	 * function will also perform the consumption and sale of products by
	 * removing them from the inventory. Inventory alerts are created during
	 * this procedure if the inventory is getting low.
	 * 
	 * @param session the session doing the saving.
	 * @param sale the sale to be saved.
	 * @return whether the sale was saved or not.
	 */
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
	 * Allows saving of supplier information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param supplier the supplier to be saved.
	 * @return whether the supplier was saved or not.
	 */
	public static boolean saveSupplier (UserSession session, SupplierBean supplier)
	{
		LogController.write ("SessionController->Saving supplier...");
		
		boolean result = false;
		result = PersistenceController.commit (supplier);
		return result;
	}

	/**
	 * Allows saving of employee information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param employee the employee to be saved.
	 * @return whether the employee was saved or not.
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
	 * Allows the saving of product information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param product the product to be saved.
	 * @return whether the product was saved or not.
	 */
	public static boolean saveProduct (UserSession session, ProductBean product)
	{
		LogController.write ("SessionController->Saving product...");
		
		boolean result = false;

		result = PersistenceController.commit (product);

		return result;
	}

	/**
	 * Allows the saving of client information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param client the client to be saved.
	 * @return whether the client was saved or not.
	 */
	public static boolean saveClient (UserSession session, ClientBean client)
	{
		LogController.write ("SessionController->Saving client...");
		
		boolean result = PersistenceController.commit (client.getAddress ());

		result = PersistenceController.commit (client);

		return result;
	}

	/**
	 * Allows the saving of salon information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param salon the salon information to be saved.
	 * @return whether the salon information was saved or not.
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

	/**
	 * Allows the loading of an alert using the specified criteria.
	 * 
	 * @param session the session doing the loading.
	 * @param alert the alert criteria to use when loading.
	 * @return the alert that is loaded if any.
	 */
	public static AlertBean loadAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Loading alert...");
		
		alert = (AlertBean)PersistenceController.load (alert);
		
		return alert;
	}
	
	/**
	 * Allows the loading of all alerts in the system.
	 * 
	 * @param session the session doing the loading.
	 * @return the array of alerts that were loaded if any.
	 */
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
	
	/**
	 * Allows the saving of alert information using the specified bean.
	 * 
	 * @param session the session doing the saving.
	 * @param alert the alert to be saved.
	 * @return whether the alert was saved or not.
	 */
	public static boolean saveAlert (UserSession session, AlertBean alert)
	{
		LogController.write ("SessionController->Saving alert...");
		
		boolean result = false;
		result = PersistenceController.commit (alert);
		return result;
	}
	
	/**
	 * Obtains all the appointments that are available for the specified date.
	 * The availability exceptions and schedule exceptions are taken into
	 * account when returning the list of appointments.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the appointments for.
	 * @param availabilityExceptions the availability exceptions to concider.
	 * @param scheduleExceptions the schedule exceptions to concider.
	 * @return the hashtable of employee appointments obtained.
	 */
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
	
	/**
	 * Obtains all the unschedulable time entries for a specific date. This takes
	 * into account the specified schedule hours for that date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the unschedulable time for.
	 * @param hours the schedule hours to concider.
	 * @return the hashtable of employee unschedulable time entries.
	 */
	public static Hashtable<EmployeeBean, ArrayList<ScheduleBean>> getUnschedulable (UserSession session, java.util.Date date, ScheduleHoursBean hours)
	{
		LogController.write ("SessionController->Getting filtered unschedulable time...");
		
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> hash = new Hashtable<EmployeeBean, ArrayList<ScheduleBean>> ();
		
		Date salonStart = hours.getStartTime ();
		Date salonEnd = hours.getEndTime ();
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setAddress (new AddressBean ());
		
		EmployeeBean[] employees = searchEmployees (session, employee);
		
		for (EmployeeBean cycle : employees)
		{
			Date employeeStart = null;
			Date employeeEnd = null;
			
			// Here we want to see if there is already existing employee hours data.
			EmployeeHoursBean ehb = new EmployeeHoursBean ();
			ehb.setEmployeeNo (cycle.getEmployeeNo ());
			ehb.setDate (date);
			
			ehb = loadEmployeeHours (session, ehb);
			
			if (ehb == null)
			{
				// We have never stored the hours before, just use the regular.
				employeeStart = cycle.getWeekdayStartTime (CoreTools.getWeekDay (date));
				employeeEnd = cycle.getWeekdayEndTime (CoreTools.getWeekDay (date));
			}
			else
			{
				// We do have employee hours for this day, lets use those.
				employeeStart = ehb.getStartTime ();
				employeeEnd = ehb.getEndTime ();
			}
			
			ArrayList<ScheduleBean> unschedulable = new ArrayList<ScheduleBean> ();
			
			if (employeeStart.equals (employeeEnd))
			{
				// The employee does not work today.
				ScheduleBean entry = new ScheduleBean ();
				entry.setEmployee (cycle);
				entry.setDate (date);
				entry.setStartTime (salonStart);
				entry.setEndTime (salonEnd);
				unschedulable.add (entry);
			}
			else
			{
				if (!CoreTools.isTimeBefore (employeeStart, salonStart))
				{
					// The employee's start time is after the day start time.
					ScheduleBean entry = new ScheduleBean ();
					entry.setEmployee (cycle);
					entry.setDate (date);
					entry.setStartTime (salonStart);
					entry.setEndTime (employeeStart);

					unschedulable.add (entry);
				}

				if (!CoreTools.isTimeBefore (salonEnd, employeeEnd))
				{
					// The end time is not before the available end time.
					ScheduleBean entry = new ScheduleBean ();
					entry.setEmployee (cycle);
					entry.setDate (date);
					entry.setStartTime (employeeEnd);
					entry.setEndTime (salonEnd);

					unschedulable.add (entry);
				}
			}
			
			hash.put (cycle, unschedulable);
		}
		
		return hash;
	}
	
	/**
	 * Obtains the unavailable time entries for one date. This takes into account
	 * the employee availability exceptions and schedule exceptions that
	 * are passed into it.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the unavailable time for.
	 * @param availabilityExceptions the availability exceptions to concider.
	 * @param scheduleExceptions the schedule exceptions to concider.
	 * @param hours the schedule hours to concider.
	 * @return the hashtable of employee unavailable time entries.
	 */
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
	
	/**
	 * Obtains the schedule entries from the system for a specific date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the schedule entries for.
	 * @return the schedule entries array obtained.
	 */
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
	
	/**
	 * Obtains the schedule entries for a specific date and employee.
	 * 
	 * @param session the session doing the get.
	 * @param employee the employee to obtain schedule entries for.
	 * @param date the date to obtain the schedule entries for.
	 * @return the array of schedule entries obtained.
	 */
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
	
	/**
	 * Obtains the unmovable entries filtered from the hashtable of employee
	 * schedule entries for a specified date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the unmovable entries for.
	 * @param schedule the hashtable of employee schedule entries.
	 * @return the resulting hashtable of unmovable employee schedule entries.
	 */
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
					if (ab.getStartTime ().equals (entry.getStartTime()) || (ab.getStartTime ().after (entry.getStartTime ())) && ((ab.getStartTime ().before (entry.getEndTime ()))))
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
	
	/**
	 * Obtains the movable entries filtered from the hashtable of employee
	 * schedule entries for a specified date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the movable entries for.
	 * @param schedule the hashtable of employee schedule entries.
	 * @return the resulting hashtable of movable employee schedule entries.
	 */
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
	
	/**
	 * Obtains all schedule entries for the specified date while concidering
	 * the specified availability exceptions and schedule exceptions.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain the schedule entries for.
	 * @param availabilityExceptions the availability exceptions to concider.
	 * @param scheduleExceptions the schedule exceptions to concider.
	 * @return the hashtable of employee schedule entries.
	 */
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
	
	/**
	 * Obtains the schedule exceptions for a specified date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain schedule exceptions for.
	 * @return the schedule exceptions that were obtained if any.
	 */
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
	
	/**
	 * Obtains the availability exceptions for a specified date.
	 * 
	 * @param session the session doing the get.
	 * @param date the date to obtain availability exceptions for.
	 * @return the hashtable of employee availability exceptions.
	 */
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
	
	/**
	 * Obtains a quick structure to read when generating a calendar of appointment
	 * schedule. This will obtain any information necessary to represent the
	 * calendar with important information like exceptions or appointments.
	 * 
	 * @param session the session doing the get.
	 * @param month the month to obtain information for.
	 * @param year the year to obtain information for.
	 * @return the array of calendar day status objects.
	 */
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
	
	/**
	 * Obtains a quick structure to read when generating a calendar of employee
	 * schedule. This will obtain any information necessary to represent the
	 * calendar with important information like exceptions or schedule entries.
	 * 
	 * @param session the session doing the get.
	 * @param month the month to obtain information for.
	 * @param year the year to obtain information for.
	 * @return the array of calendar day status objects.
	 */
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
