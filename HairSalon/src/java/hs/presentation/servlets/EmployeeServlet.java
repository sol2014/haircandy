/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.presentation.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.objects.*;
import hs.app.*;
import hs.presentation.*;
import java.util.ArrayList;
import java.util.Date;

/**
 * Employee presentation servlet that deals with searching, maintaining and
 * creating employee record requests from the user.
 * 
 * @author Philippe Durand
 */
public class EmployeeServlet extends DispatcherServlet
{
	/**
	 * Sets up internal and external action attribute tags used for this servlet
	 * as well as setting the action methods using reflection.
	 * 
	 * @throws java.lang.NoSuchMethodException
	 */
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("employee_action");
		addExternalAction ("Search", "performSearch");
		addExternalAction ("New Employee", "performNewEmployee");
		addExternalAction ("Load", "performLoad");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Finish", "performSave");
		addExternalAction ("Revert", "performRevert");
		addExternalAction ("UpdateHours", "performUpdateHours");
		addExternalAction ("LoadAvailability", "performLoadAvailability");
		addExternalAction ("UpdateAvailability", "performUpdateAvailability");
		addExternalAction ("UpdatePassword", "performUpdatePassword");
	}
	
	public void performUpdatePassword (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String employeeNo = request.getParameter ("employee_no");
		String oldPassword = request.getParameter ("old_password");
		String newPassword = request.getParameter ("new_password");
		
		EmployeeBean employee = new EmployeeBean ();
		PrintWriter pw = response.getWriter ();
		
		try
		{
			employee.setEmployeeNo (Integer.parseInt (employeeNo));
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to load availability for invalid employee number: "+employeeNo);
			return;
		}
		
		employee = SessionController.loadEmployee (userSession, employee);
		
		if (employee != null)
		{
			if (employee.getPassword ().equals (oldPassword))
			{
				employee.setPassword (newPassword);
				SessionController.saveEmployee (userSession, employee);
				pw.write ("ok");
			}
			else
			{
				pw.write ("bad");
			}
		}
		else
		{
			LogController.write (this, "Unable to find employee by number for availability load.");
			return;
		}
	}
	
	public void performUpdateAvailability (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		PrintWriter pw = response.getWriter ();
		
		String employeeNo = request.getParameter ("employee_no");
		String monday_start = request.getParameter ("monday_start");
		String monday_end = request.getParameter ("monday_end");
		String tuesday_start = request.getParameter ("tuesday_start");
		String tuesday_end = request.getParameter ("tuesday_end");
		String wednesday_start = request.getParameter ("wednesday_start");
		String wednesday_end = request.getParameter ("wednesday_end");
		String thursday_start = request.getParameter ("thursday_start");
		String thursday_end = request.getParameter ("thursday_end");
		String friday_start = request.getParameter ("friday_start");
		String friday_end = request.getParameter ("friday_end");
		String saturday_start = request.getParameter ("saturday_start");
		String saturday_end = request.getParameter ("saturday_end");
		String sunday_start = request.getParameter ("sunday_start");
		String sunday_end = request.getParameter ("sunday_end");
		
		EmployeeBean employee = new EmployeeBean ();
		
		try
		{
			employee.setEmployeeNo (Integer.parseInt (employeeNo));
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to load availability for invalid employee number: "+employeeNo);
			return;
		}
		
		employee = SessionController.loadEmployee (userSession, employee);
		
		if (employee != null)
		{
			try
			{
				employee.setMondayStart (CoreTools.getTime (monday_start));
				employee.setMondayEnd (CoreTools.getTime (monday_end));
				employee.setTuesdayStart (CoreTools.getTime (tuesday_start));
				employee.setTuesdayEnd (CoreTools.getTime (tuesday_end));
				employee.setWednesdayStart (CoreTools.getTime (wednesday_start));
				employee.setWednesdayEnd (CoreTools.getTime (wednesday_end));
				employee.setThursdayStart (CoreTools.getTime (thursday_start));
				employee.setThursdayEnd (CoreTools.getTime (thursday_end));
				employee.setFridayStart (CoreTools.getTime (friday_start));
				employee.setFridayEnd (CoreTools.getTime (friday_end));
				employee.setSaturdayStart (CoreTools.getTime (saturday_start));
				employee.setSaturdayEnd (CoreTools.getTime (saturday_end));
				employee.setSundayStart (CoreTools.getTime (sunday_start));
				employee.setSundayEnd (CoreTools.getTime (sunday_end));
			}
			catch (Exception e)
			{
				LogController.write (this, "Invalid availability data found from form.");
				return;
			}
			
			String wrongHours = "";
			
			if (!employee.getMondayStart ().equals (employee.getMondayEnd ()) && !employee.getMondayStart ().before (employee.getMondayEnd ()))
			{
				wrongHours += "monday:";
			}

			if (!employee.getTuesdayStart ().equals (employee.getTuesdayEnd ()) && !employee.getTuesdayStart ().before (employee.getTuesdayEnd ()))
			{
				wrongHours += "tuesday:";
			}

			if (!employee.getWednesdayStart ().equals (employee.getWednesdayEnd ()) && !employee.getWednesdayStart ().before (employee.getWednesdayEnd ()))
			{
				wrongHours += "wednesday:";
			}

			if (!employee.getThursdayStart ().equals (employee.getThursdayEnd ()) && !employee.getThursdayStart ().before (employee.getThursdayEnd ()))
			{
				wrongHours += "thursday:";
			}

			if (!employee.getFridayStart ().equals (employee.getFridayEnd ()) && !employee.getFridayStart ().before (employee.getFridayEnd ()))
			{
				wrongHours += "friday:";
			}

			if (!employee.getSaturdayStart ().equals (employee.getSaturdayEnd ()) && !employee.getSaturdayStart ().before (employee.getSaturdayEnd ()))
			{
				wrongHours += "saturday:";
			}

			if (!employee.getSundayStart ().equals (employee.getSundayEnd ()) && !employee.getSundayStart ().before (employee.getSundayEnd ()))
			{
				wrongHours += "sunday:";
			}
			
			if (wrongHours.length () > 0)
			{
				// We had some errors with the times, lets send this to the page.
				pw.write (wrongHours);
			}
			else
			{
				SessionController.saveEmployee (userSession, employee);
				pw.write ("ok");
			}
		}
		else
		{
			LogController.write (this, "Unable to find employee by number for availability load.");
			return;
		}
	}
	
	public void performLoadAvailability (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String employeeNo = request.getParameter ("employee_no");
		EmployeeBean employee = new EmployeeBean ();
		
		try
		{
			employee.setEmployeeNo (Integer.parseInt (employeeNo));
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to load availability for invalid employee number: "+employeeNo);
			return;
		}
		
		employee = SessionController.loadEmployee (userSession, employee);
		
		if (employee != null)
		{
			userSession.setAttribute ("employee_load_result", employee);
			forward ("ajax/ajax-availability.jsp", request, response);
		}
		else
		{
			LogController.write (this, "Unable to find employee by number for availability load.");
			return;
		}
	}
	
	public void performUpdateHours (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String employeeNo = request.getParameter ("employee_no");
		String date = request.getParameter ("date");
		String startTime = request.getParameter ("start_time");
		String endTime = request.getParameter ("end_time");
		
		EmployeeHoursBean ehb = new EmployeeHoursBean ();
		
		try
		{
			ehb.setEmployeeNo (Integer.parseInt (employeeNo));
			ehb.setDate (CoreTools.getDate (date));
			ehb.setStartTime (CoreTools.getTime (startTime));
			ehb.setEndTime (CoreTools.getTime (endTime));
		}
		catch (Exception e)
		{
			LogController.write (this, "Attemped to update employee hours with invalid data!");
			return;
		}
		
		LogController.write (this, "[USER REQUEST] Performing employee hours update: "+CoreTools.showDate (ehb.getDate()));
		
		if (!ehb.getStartTime ().equals (ehb.getEndTime ()) && !ehb.getStartTime ().before (ehb.getEndTime ()))
		{
			LogController.write (this, "We cannot apply employee hours unless start time occurs before end time.");
		}
		else
		{
			if (!SessionController.saveEmployeeHours (userSession, ehb))
			{
				LogController.write (this, "Unable to save employee hours.");
			}
			else
			{
				LogController.write (this, "Saved employee hours successfully.");
			}
		}
	}
	
	/**
	 * Used to search for employee records and then show the results to the
	 * page for the user to select one.
	 * 
	 * @param session the user session that is requesting the action.
	 * @param request the http request used.
	 * @param response the http response used.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing search.");
		
		EmployeeBean employee = new EmployeeBean ();
		AddressBean address = new AddressBean ();
		employee.setAddress (address);

		String firstName = request.getParameter ("first_name");
		if (!firstName.equals (""))
		{
			employee.setFirstName (firstName);
		}

		String lastName = request.getParameter ("last_name");
		if (!lastName.equals (""))
		{
			employee.setLastName (lastName);
		}

		String phoneNumber = request.getParameter ("phone_number");
		if (!phoneNumber.equals (""))
		{
			employee.setPhoneNumber (phoneNumber);
		}

		String role = request.getParameter ("role");
		if (!role.equals ("") && !role.equals ("None"))
		{
			employee.setRole (role);
		}

		String address1 = request.getParameter ("address1");
		if (!address1.equals (""))
		{
			address.setAddress1 (address1);
		}

		String address2 = request.getParameter ("address2");
		if (!address2.equals (""))
		{
			address.setAddress2 (request.getParameter ("address2"));
		}

		String city = request.getParameter ("city");
		if (!city.equals (""))
		{
			address.setCity (city);
		}

		String province = request.getParameter ("province");
		if (!province.equals (""))
		{
			address.setProvince (province);
		}

		String country = request.getParameter ("country");
		if (!country.equals (""))
		{
			address.setCountry (country);
		}

		String postalCode = request.getParameter ("postal_code");
		if (!postalCode.equals (""))
		{
			address.setPostalCode (postalCode);
		}

		String email = request.getParameter ("email");
		if (!email.equals (""))
		{
			address.setEmail (request.getParameter ("email"));
		}
		
		String used = request.getParameter ("enabled");
		if (!used.equals ("None"))
		{
			employee.setEnabled (used.equals ("True"));
		}
		
		EmployeeBean[] searchResults = SessionController.searchEmployees (userSession, employee);

		userSession.setAttribute ("employee_search_result", searchResults);

		// We also need to keep track of all the search parameters we used, to show back on page.
		userSession.setAttribute ("employee_search_first_name", firstName);
		userSession.setAttribute ("employee_search_last_name", lastName);
		userSession.setAttribute ("employee_search_phone_number", phoneNumber);
		userSession.setAttribute ("employee_search_role", role);
		userSession.setAttribute ("employee_search_address1", address1);
		userSession.setAttribute ("employee_search_address2", address2);
		userSession.setAttribute ("employee_search_city", city);
		userSession.setAttribute ("employee_search_province", province);
		userSession.setAttribute ("employee_search_country", country);
		userSession.setAttribute ("employee_search_postal_code", postalCode);
		userSession.setAttribute ("employee_search_email", email);
		userSession.setAttribute ("employee_search_enabled", used);

		redirect ("search-employees.jsp", request, response);
	}

	public void performNewEmployee (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing new employee.");
		
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (userSession, salon);
		
		if (salon != null)
		{
			userSession.setAttribute ("employee_new_city", salon.getCity ());
			userSession.setAttribute ("employee_new_province", salon.getProvince ());
			userSession.setAttribute ("employee_new_country", salon.getCountry ());
			
			userSession.setAttribute ("employee_new_monday_start", CoreTools.showTime (salon.getMondayStart ()));
			userSession.setAttribute ("employee_new_monday_end", CoreTools.showTime (salon.getMondayEnd ()));
			userSession.setAttribute ("employee_new_tuesday_start", CoreTools.showTime (salon.getTuesdayStart ()));
			userSession.setAttribute ("employee_new_tuesday_end", CoreTools.showTime (salon.getTuesdayEnd ()));
			userSession.setAttribute ("employee_new_wednesday_start", CoreTools.showTime (salon.getWednesdayStart ()));
			userSession.setAttribute ("employee_new_wednesday_end", CoreTools.showTime (salon.getWednesdayEnd ()));
			userSession.setAttribute ("employee_new_thursday_start", CoreTools.showTime (salon.getThursdayStart ()));
			userSession.setAttribute ("employee_new_thursday_end", CoreTools.showTime (salon.getThursdayEnd ()));
			userSession.setAttribute ("employee_new_friday_start", CoreTools.showTime (salon.getFridayStart ()));
			userSession.setAttribute ("employee_new_friday_end", CoreTools.showTime (salon.getFridayEnd ()));
			userSession.setAttribute ("employee_new_saturday_start", CoreTools.showTime (salon.getSaturdayStart ()));
			userSession.setAttribute ("employee_new_saturday_end", CoreTools.showTime (salon.getSaturdayEnd ()));
			userSession.setAttribute ("employee_new_sunday_start", CoreTools.showTime (salon.getSundayStart ()));
			userSession.setAttribute ("employee_new_sunday_end", CoreTools.showTime (salon.getSundayEnd ()));
		}
		
		userSession.setAttribute ("employee_new_phone_number", "");
		userSession.setAttribute ("employee_new_password", "");
		
		forward ("create-employee.jsp", request, response);
	}

	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String serialized_employee = (String) request.getParameter ("temp_employee");
		EmployeeBean employee = null;

		if (serialized_employee == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");

			userSession.setAttribute ("employee_error", "Unable to revert employee, temporary data lost!");

			forward ("/search-employee.jsp", request, response);

			return;
		}
		else
		{
			employee = (EmployeeBean) CoreTools.deserializeBase64 (serialized_employee);
		}

		employee = SessionController.loadEmployee (userSession, employee);

		if (employee != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+employee.getEmployeeNo ());
			
			userSession.setAttribute ("employee_load_result", employee);
			userSession.setAttribute ("employee_feedback", "Employee was reverted successfully.");

			forward ("/maintain-employee.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("employee_error", "Unable to revert employee from the database!");

			forward ("/search-employee.jsp", request, response);
		}
	}

	/**
	 * Loads the employee record from the database and show the information
	 * in a employee maintenance page.
	 * 
	 * @param session the user session that is requesting the action.
	 * @param request the http request used.
	 * @param response the http response used.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String employee_no = (String) request.getParameter ("employee_no");
		EmployeeBean employee = new EmployeeBean ();

		try
		{
			employee.setEmployeeNo (Integer.parseInt (employee_no));
		}
		catch (Exception ex)
		{
			LogController.write (this, "Invalid employee number requested externally: " + employee_no);
			// Maybe we should do something to show an error on the page?
			return;
		}

		employee = SessionController.loadEmployee (userSession, employee);

		if (employee != null)
		{
			LogController.write (this, "[USER REQUEST] Performing load: "+employee.getEmployeeNo ());
			
			userSession.setAttribute ("employee_load_result", employee);

			forward ("maintain-employee.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("employee_error", "Unable to load employee record! Please contact system administrator.");

			forward ("search-employee.jsp", request, response);
		}
	}

	/**
	 * Saves the employee details into the database.
	 * 
	 * @param session
	 * @param request
	 * @param response
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		// We want to grab the temporary bean data
		String serialized_employee = (String) request.getParameter ("temp_employee");
		EmployeeBean employee = null;
		AddressBean address = null;
		boolean exceptionFailed = false;
		
		if (serialized_employee == null)
		{
			employee = new EmployeeBean ();
			address = new AddressBean ();
			employee.setAddress (address);
		}
		else
		{
			employee = (EmployeeBean) CoreTools.deserializeBase64 (serialized_employee);
			address = employee.getAddress ();
			
			String[] services = request.getParameterValues ("services");
			String[] dates = request.getParameterValues ("dates");
			String[] reasons = request.getParameterValues ("reasons");

			try
			{
				if (services != null)
				{
					ArrayList<ServiceBean> sbs = new ArrayList<ServiceBean> ();
					for (String s : services)
					{
						ServiceBean sb = new ServiceBean ();
						sb.setServiceNo (Integer.parseInt (s));
						sbs.add (sb);
					}
					employee.setServices (sbs);
				}

				if (dates != null)
				{
					ArrayList<AvailabilityExceptionBean> aebs = new ArrayList<AvailabilityExceptionBean> ();

					for (int i = 0; i < dates.length; i++)
					{
						AvailabilityExceptionBean aeb = new AvailabilityExceptionBean ();
						aeb.setEmployeeNo (employee.getEmployeeNo ());
						Date date = CoreTools.getDate (dates[i]);
						aeb.setDate (date);
						aeb.setReason (reasons[i]);
						
						if (SessionController.getEmployeeSchedule (userSession, employee, date) != null)
						{
							// There is schedule data on this date.
							exceptionFailed = true;
						}
						else
							aebs.add (aeb);
					}

					employee.setAvailabilityExceptions (aebs);
				}
			}
			catch (Exception e)
			{

			}
		}
		
		boolean inputFailed = false;
		
		String firstName = request.getParameter ("first_name").trim ();
		if (firstName == null || firstName.length () < 1)
		{
			userSession.setAttribute ("employee_error_first_name", "");
			inputFailed = true;
		}
		else employee.setFirstName (firstName);
		
		String lastName = request.getParameter ("last_name").trim ();
		if (lastName == null || lastName.length () < 1)
		{
			userSession.setAttribute ("employee_error_last_name", "");
			inputFailed = true;
		}
		else employee.setLastName (lastName);
		
		String phoneNumber = request.getParameter ("phone_number").trim ();
        if (phoneNumber == null || phoneNumber.length () != 10)
        {
            userSession.setAttribute ("employee_error_phone_number", "");
            inputFailed = true;
        }
        else
        {
			if (CoreTools.containsOnlyNumbers(phoneNumber))
			{
				employee.setPhoneNumber (phoneNumber);
			}
			else
			{
				userSession.setAttribute ("employee_error_phone_number", "");
				inputFailed = true;
			}
        }
		
		String role = request.getParameter ("role");
		employee.setRole (role);
		
		String password = request.getParameter ("password").trim ();
		if (password == null || password.length () < 1)
		{
			userSession.setAttribute ("employee_error_password", "");
			inputFailed = true;
		}
		else employee.setPassword (password);
		
		String address1 = request.getParameter ("address1").trim ();
		if (address1 == null || address1.length () < 1)
		{
			userSession.setAttribute ("employee_error_address1", "");
			inputFailed = true;
		}
		else address.setAddress1 (address1);
		
		String address2 = request.getParameter ("address2").trim ();
		address.setAddress2 (address2);
		
		String city = request.getParameter ("city").trim ();
		if (city == null || city.length () < 1)
		{
			userSession.setAttribute ("employee_error_city", "");
			inputFailed = true;
		}
		else address.setCity (city);
		
		String province = request.getParameter ("province").trim ();
		if (province == null || province.length () < 1)
		{
			userSession.setAttribute ("employee_error_province", "");
			inputFailed = true;
		}
		else address.setProvince (province);
		
		String country = request.getParameter ("country").trim ();
		if (country == null || country.length () < 1)
		{
			userSession.setAttribute ("employee_error_country", "");
			inputFailed = true;
		}
		else address.setCountry (country);
		
		String postalCode = request.getParameter ("postal_code").trim ();
		if (postalCode == null || postalCode.length () < 1)
		{
			userSession.setAttribute ("employee_error_postal_code", "");
			inputFailed = true;
		}
		else address.setPostalCode (postalCode);
		
		String email = request.getParameter ("email").trim ();
		if (email == null || email.length () < 1)
		{
			userSession.setAttribute ("employee_error_email", "");
			inputFailed = true;
		}
		else address.setEmail (email);
		
		String used = request.getParameter ("enabled");
		employee.setEnabled (Boolean.parseBoolean (used));
		
		String monday_start = ServletHelper.readTimeRequest (request, "monday_start");
		String monday_end = ServletHelper.readTimeRequest (request, "monday_end");
		String tuesday_start = ServletHelper.readTimeRequest (request, "tuesday_start");
		String tuesday_end = ServletHelper.readTimeRequest (request, "tuesday_end");
		String wednesday_start = ServletHelper.readTimeRequest (request, "wednesday_start");
		String wednesday_end = ServletHelper.readTimeRequest (request, "wednesday_end");
		String thursday_start = ServletHelper.readTimeRequest (request, "thursday_start");
		String thursday_end = ServletHelper.readTimeRequest (request, "thursday_end");
		String friday_start = ServletHelper.readTimeRequest (request, "friday_start");
		String friday_end = ServletHelper.readTimeRequest (request, "friday_end");
		String saturday_start = ServletHelper.readTimeRequest (request, "saturday_start");
		String saturday_end = ServletHelper.readTimeRequest (request, "saturday_end");
		String sunday_start = ServletHelper.readTimeRequest (request, "sunday_start");
		String sunday_end = ServletHelper.readTimeRequest (request, "sunday_end");
		
		try
		{
			employee.setMondayStart (CoreTools.getTime (monday_start));
			employee.setMondayEnd (CoreTools.getTime (monday_end));
			employee.setTuesdayStart (CoreTools.getTime (tuesday_start));
			employee.setTuesdayEnd (CoreTools.getTime (tuesday_end));
			employee.setWednesdayStart (CoreTools.getTime (wednesday_start));
			employee.setWednesdayEnd (CoreTools.getTime (wednesday_end));
			employee.setThursdayStart (CoreTools.getTime (thursday_start));
			employee.setThursdayEnd (CoreTools.getTime (thursday_end));
			employee.setFridayStart (CoreTools.getTime (friday_start));
			employee.setFridayEnd (CoreTools.getTime (friday_end));
			employee.setSaturdayStart (CoreTools.getTime (saturday_start));
			employee.setSaturdayEnd (CoreTools.getTime (saturday_end));
			employee.setSundayStart (CoreTools.getTime (sunday_start));
			employee.setSundayEnd (CoreTools.getTime (sunday_end));
		}
		catch (Exception e)
		{
			LogController.write (this, "Invalid availability data found from form.");
			return;
		}
		
		if (!employee.getMondayStart ().equals (employee.getMondayEnd ()) && !employee.getMondayStart ().before (employee.getMondayEnd ()))
		{
			userSession.setAttribute ("employee_error_monday", "");
			inputFailed = true;
		}
		
		if (!employee.getTuesdayStart ().equals (employee.getTuesdayEnd ()) && !employee.getTuesdayStart ().before (employee.getTuesdayEnd ()))
		{
			userSession.setAttribute ("employee_error_tuesday", "");
			inputFailed = true;
		}
		
		if (!employee.getWednesdayStart ().equals (employee.getWednesdayEnd ()) && !employee.getWednesdayStart ().before (employee.getWednesdayEnd ()))
		{
			userSession.setAttribute ("employee_error_wednesday", "");
			inputFailed = true;
		}
		
		if (!employee.getThursdayStart ().equals (employee.getThursdayEnd ()) && !employee.getThursdayStart ().before (employee.getThursdayEnd ()))
		{
			userSession.setAttribute ("employee_error_thursday", "");
			inputFailed = true;
		}
		
		if (!employee.getFridayStart ().equals (employee.getFridayEnd ()) && !employee.getFridayStart ().before (employee.getFridayEnd ()))
		{
			userSession.setAttribute ("employee_error_friday", "");
			inputFailed = true;
		}
		
		if (!employee.getSaturdayStart ().equals (employee.getSaturdayEnd ()) && !employee.getSaturdayStart ().before (employee.getSaturdayEnd ()))
		{
			userSession.setAttribute ("employee_error_saturday", "");
			inputFailed = true;
		}
		
		if (!employee.getSundayStart ().equals (employee.getSundayEnd ()) && !employee.getSundayStart ().before (employee.getSundayEnd ()))
		{
			userSession.setAttribute ("employee_error_sunday", "");
			inputFailed = true;
		}
		
		if (inputFailed)
		{
			userSession.setAttribute ("employee_error", "You have provided invalid input! Review the fields in red.");
			
			if (serialized_employee == null)
			{
				userSession.setAttribute ("employee_new_first_name", firstName);
				userSession.setAttribute ("employee_new_last_name", lastName);
				userSession.setAttribute ("employee_new_phone_number", phoneNumber);
				userSession.setAttribute ("employee_new_role", role);
				userSession.setAttribute ("employee_new_password", password);
				userSession.setAttribute ("employee_new_address1", address1);
				userSession.setAttribute ("employee_new_address2", address2);
				userSession.setAttribute ("employee_new_city", city);
				userSession.setAttribute ("employee_new_province", province);
				userSession.setAttribute ("employee_new_country", country);
				userSession.setAttribute ("employee_new_postal_code", postalCode);
				userSession.setAttribute ("employee_new_email", email);

				userSession.setAttribute ("employee_new_monday_start", monday_start);
				userSession.setAttribute ("employee_new_monday_end", monday_end);
				userSession.setAttribute ("employee_new_tuesday_start", tuesday_start);
				userSession.setAttribute ("employee_new_tuesday_end", tuesday_end);
				userSession.setAttribute ("employee_new_wednesday_start", wednesday_start);
				userSession.setAttribute ("employee_new_wednesday_end", wednesday_end);
				userSession.setAttribute ("employee_new_thursday_start", thursday_start);
				userSession.setAttribute ("employee_new_thursday_end", thursday_end);
				userSession.setAttribute ("employee_new_friday_start", friday_start);
				userSession.setAttribute ("employee_new_friday_end", friday_end);
				userSession.setAttribute ("employee_new_saturday_start", saturday_start);
				userSession.setAttribute ("employee_new_saturday_end", saturday_end);
				userSession.setAttribute ("employee_new_sunday_start", sunday_start);
				userSession.setAttribute ("employee_new_sunday_end", sunday_end);
				userSession.setAttribute ("employee_new_enabled", used);
				
				redirect ("create-employee.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("temp_employee", employee);

				redirect ("employee?employee_action=Load&employee_no=" + employee.getEmployeeNo (), request, response);
			}
			
			return;
		}
		
		// Save the delays and then reload the results back to the maintain page.
		if (SessionController.saveEmployee (userSession, employee))
		{
			LogController.write (this, "[USER REQUEST] Performing save: "+employee.getEmployeeNo ());
			
			if (exceptionFailed)
				userSession.setAttribute ("employee_error", "Some exceptions conflicted with existing schedule entries.");
			
			userSession.setAttribute ("employee_feedback", "Employee was saved successfully.");

			// We are doing a final save here, lets make sure we have no temp data left.
			userSession.removeAttribute ("temp_employee");

			redirect ("employee?employee_action=Load&employee_no=" + employee.getEmployeeNo (), request, response);
		}
		else
		{
			if (serialized_employee == null)
			{
				userSession.setAttribute ("employee_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("employee_new_first_name", firstName);
				userSession.setAttribute ("employee_new_last_name", lastName);
				userSession.setAttribute ("employee_new_phone_number", phoneNumber);
				userSession.setAttribute ("employee_new_role", role);
				userSession.setAttribute ("employee_new_password", password);
				userSession.setAttribute ("employee_new_address1", address1);
				userSession.setAttribute ("employee_new_address2", address2);
				userSession.setAttribute ("employee_new_city", city);
				userSession.setAttribute ("employee_new_province", province);
				userSession.setAttribute ("employee_new_country", country);
				userSession.setAttribute ("employee_new_postal_code", postalCode);
				userSession.setAttribute ("employee_new_email", email);

				userSession.setAttribute ("employee_new_monday_start", monday_start);
				userSession.setAttribute ("employee_new_monday_end", monday_end);
				userSession.setAttribute ("employee_new_tuesday_start", tuesday_start);
				userSession.setAttribute ("employee_new_tuesday_end", tuesday_end);
				userSession.setAttribute ("employee_new_wednesday_start", wednesday_start);
				userSession.setAttribute ("employee_new_wednesday_end", wednesday_end);
				userSession.setAttribute ("employee_new_thursday_start", thursday_start);
				userSession.setAttribute ("employee_new_thursday_end", thursday_end);
				userSession.setAttribute ("employee_new_friday_start", friday_start);
				userSession.setAttribute ("employee_new_friday_end", friday_end);
				userSession.setAttribute ("employee_new_saturday_start", saturday_start);
				userSession.setAttribute ("employee_new_saturday_end", saturday_end);
				userSession.setAttribute ("employee_new_sunday_start", sunday_start);
				userSession.setAttribute ("employee_new_sunday_end", sunday_end);
				userSession.setAttribute ("employee_new_enabled", used);
				
				redirect ("create-employee.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("employee_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("temp_employee", employee);

				redirect ("employee?employee_action=Load&employee_no=" + employee.getEmployeeNo (), request, response);
			}
		}
	}

	private void populateBean (EmployeeBean employee, AddressBean address, HttpServletRequest request)
	{
		String firstName = request.getParameter ("first_name");
		employee.setFirstName (firstName);

		String lastName = request.getParameter ("last_name");
		employee.setLastName (lastName);

		String phoneNumber = request.getParameter ("phone_number");
		employee.setPhoneNumber (phoneNumber);

		employee.setRole (request.getParameter ("role"));

		employee.setPassword (request.getParameter ("password"));

		String address1 = request.getParameter ("address1");
		address.setAddress1 (address1);

		String address2 = request.getParameter ("address2");
		address.setAddress2 (address2);

		String city = request.getParameter ("city");
		address.setCity (city);

		String province = request.getParameter ("province");
		address.setProvince (province);

		String country = request.getParameter ("country");
		address.setCountry (country);

		String postalCode = request.getParameter ("postal_code");
		address.setPostalCode (postalCode);

		String email = request.getParameter ("email");
		address.setEmail (email);
		
		String enabled = request.getParameter ("enabled");
		employee.setEnabled (Boolean.valueOf(enabled));
		
		String monday_start = request.getParameter ("monday_start");
		String monday_end = request.getParameter ("monday_end");
		String tuesday_start = request.getParameter ("tuesday_start");
		String tuesday_end = request.getParameter ("tuesday_end");
		String wednesday_start = request.getParameter ("wednesday_start");
		String wednesday_end = request.getParameter ("wednesday_end");
		String thursday_start = request.getParameter ("thursday_start");
		String thursday_end = request.getParameter ("thursday_end");
		String friday_start = request.getParameter ("friday_start");
		String friday_end = request.getParameter ("friday_end");
		String saturday_start = request.getParameter ("saturday_start");
		String saturday_end = request.getParameter ("saturday_end");
		String sunday_start = request.getParameter ("sunday_start");
		String sunday_end = request.getParameter ("sunday_end");

		try
		{
			employee.setMondayStart (CoreTools.getTime (monday_start));
			employee.setMondayEnd (CoreTools.getTime (monday_end));
			employee.setTuesdayStart (CoreTools.getTime (tuesday_start));
			employee.setTuesdayEnd (CoreTools.getTime (tuesday_end));
			employee.setWednesdayStart (CoreTools.getTime (wednesday_start));
			employee.setWednesdayEnd (CoreTools.getTime (wednesday_end));
			employee.setThursdayStart (CoreTools.getTime (thursday_start));
			employee.setThursdayEnd (CoreTools.getTime (thursday_end));
			employee.setFridayStart (CoreTools.getTime (friday_start));
			employee.setFridayEnd (CoreTools.getTime (friday_end));
			employee.setSaturdayStart (CoreTools.getTime (saturday_start));
			employee.setSaturdayEnd (CoreTools.getTime (saturday_end));
			employee.setSundayStart (CoreTools.getTime (sunday_start));
			employee.setSundayEnd (CoreTools.getTime (sunday_end));
		}
		catch (Exception e)
		{
			LogController.write (this, "Invalid availability data found from form.");
			return;
		}
	}
}
