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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

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
			
			SimpleDateFormat format = new SimpleDateFormat ("HH:mm");
			
			userSession.setAttribute ("employee_new_monday_start", format.format (salon.getMondayStart ()));
			userSession.setAttribute ("employee_new_monday_end", format.format (salon.getMondayEnd ()));
			userSession.setAttribute ("employee_new_tuesday_start", format.format (salon.getTuesdayStart ()));
			userSession.setAttribute ("employee_new_tuesday_end", format.format (salon.getTuesdayEnd ()));
			userSession.setAttribute ("employee_new_wednesday_start", format.format (salon.getWednesdayStart ()));
			userSession.setAttribute ("employee_new_wednesday_end", format.format (salon.getWednesdayEnd ()));
			userSession.setAttribute ("employee_new_thursday_start", format.format (salon.getThursdayStart ()));
			userSession.setAttribute ("employee_new_thursday_end", format.format (salon.getThursdayEnd ()));
			userSession.setAttribute ("employee_new_friday_start", format.format (salon.getFridayStart ()));
			userSession.setAttribute ("employee_new_friday_end", format.format (salon.getFridayEnd ()));
			userSession.setAttribute ("employee_new_saturday_start", format.format (salon.getSaturdayStart ()));
			userSession.setAttribute ("employee_new_saturday_end", format.format (salon.getSaturdayEnd ()));
			userSession.setAttribute ("employee_new_sunday_start", format.format (salon.getSundayStart ()));
			userSession.setAttribute ("employee_new_sunday_end", format.format (salon.getSundayEnd ()));
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
			
			DateFormat df = new SimpleDateFormat ("dd/MM/yyyy");
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
						aeb.setDate (df.parse (dates[i]));
						aeb.setReason (reasons[i]);
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
			employee.setMondayStart (new SimpleDateFormat ("HH:mm").parse (monday_start));
			employee.setMondayEnd (new SimpleDateFormat ("HH:mm").parse (monday_end));
			employee.setTuesdayStart (new SimpleDateFormat ("HH:mm").parse (tuesday_start));
			employee.setTuesdayEnd (new SimpleDateFormat ("HH:mm").parse (tuesday_end));
			employee.setWednesdayStart (new SimpleDateFormat ("HH:mm").parse (wednesday_start));
			employee.setWednesdayEnd (new SimpleDateFormat ("HH:mm").parse (wednesday_end));
			employee.setThursdayStart (new SimpleDateFormat ("HH:mm").parse (thursday_start));
			employee.setThursdayEnd (new SimpleDateFormat ("HH:mm").parse (thursday_end));
			employee.setFridayStart (new SimpleDateFormat ("HH:mm").parse (friday_start));
			employee.setFridayEnd (new SimpleDateFormat ("HH:mm").parse (friday_end));
			employee.setSaturdayStart (new SimpleDateFormat ("HH:mm").parse (saturday_start));
			employee.setSaturdayEnd (new SimpleDateFormat ("HH:mm").parse (saturday_end));
			employee.setSundayStart (new SimpleDateFormat ("HH:mm").parse (sunday_start));
			employee.setSundayEnd (new SimpleDateFormat ("HH:mm").parse (sunday_end));
		}
		catch (Exception e)
		{
			LogController.write (this, "Invalid availability data found from form.");
			return;
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
			employee.setMondayStart (new SimpleDateFormat ("HH:mm").parse (monday_start));
			employee.setMondayEnd (new SimpleDateFormat ("HH:mm").parse (monday_end));
			employee.setTuesdayStart (new SimpleDateFormat ("HH:mm").parse (tuesday_start));
			employee.setTuesdayEnd (new SimpleDateFormat ("HH:mm").parse (tuesday_end));
			employee.setWednesdayStart (new SimpleDateFormat ("HH:mm").parse (wednesday_start));
			employee.setWednesdayEnd (new SimpleDateFormat ("HH:mm").parse (wednesday_end));
			employee.setThursdayStart (new SimpleDateFormat ("HH:mm").parse (thursday_start));
			employee.setThursdayEnd (new SimpleDateFormat ("HH:mm").parse (thursday_end));
			employee.setFridayStart (new SimpleDateFormat ("HH:mm").parse (friday_start));
			employee.setFridayEnd (new SimpleDateFormat ("HH:mm").parse (friday_end));
			employee.setSaturdayStart (new SimpleDateFormat ("HH:mm").parse (saturday_start));
			employee.setSaturdayEnd (new SimpleDateFormat ("HH:mm").parse (saturday_end));
			employee.setSundayStart (new SimpleDateFormat ("HH:mm").parse (sunday_start));
			employee.setSundayEnd (new SimpleDateFormat ("HH:mm").parse (sunday_end));
		}
		catch (Exception e)
		{
			LogController.write (this, "Invalid availability data found from form.");
			return;
		}
	}
}
