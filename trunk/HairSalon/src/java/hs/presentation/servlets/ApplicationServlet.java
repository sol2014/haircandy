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

import hs.app.*;
import hs.core.*;
import hs.objects.*;
import hs.presentation.*;

/**
 * Application presentation servlet that deals with the application aspects
 * of requests for moving about the site including the welcome page.
 * 
 * @author Philippe Durand
 */
public class ApplicationServlet extends DispatcherServlet
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
		//setInternalActionAttribute ("internal_application_action");
		setActionAttribute ("application_action");
		setDefaultExternalAction ("performWelcome");
		addExternalAction ("Finish", "performSetupFinish");
	}
	
	/**
	 * Will be used when the application needs to welcome the user to the main page of the site.
	 * 
	 * @param session the user session that requested the action be performed.
	 * @param request the http request that is used to perform this action.
	 * @param response the http response that will be sent to the browser.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performWelcome (UserSession session, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing welcome.");
		
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (session, salon);
		
		// We need to check if we have a Salon record, otherwise we go to first time setup.
		if (salon == null)
		{
			redirect ("hairsalon-setup.jsp", request, response);
			return;
		}
		
		if (session.isGuest())
		{
			redirect ("welcome-guest.jsp", request, response);
		}
		else
		{
			redirect ("welcome-employee.jsp", request, response);
		}
	}
	
	public void performSetupFinish (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing first time setup.");
		
		String serialized_salon = (String) request.getParameter ("temp_salon");
		String serialized_manager = (String) request.getParameter ("temp_manager");
		
		SalonBean salon = null;
		EmployeeBean manager = null;
		AddressBean address = null;
		
		if (serialized_salon == null)
		{
			salon = new SalonBean ();
		}
		else
		{
			salon = (SalonBean) CoreTools.deserializeBase64 (serialized_salon);
		}
		
		if (serialized_manager == null)
		{
			manager = new EmployeeBean ();
			address = new AddressBean ();
			manager.setAddress (address);
		}
		else
		{
			manager = (EmployeeBean) CoreTools.deserializeBase64 (serialized_manager);
			address = manager.getAddress ();
		}
		
		boolean inputFailed = false;
		
		String name = request.getParameter ("salon_name").trim ();
		if (name == null || name.length () < 1)
		{
			userSession.setAttribute ("setup_error_salon_name", "");
			inputFailed = true;
		}
		else salon.setName (name);
		
		String tax = request.getParameter ("tax").trim ();
		try
		{
			salon.setTaxRate (Double.parseDouble (tax));
		}
		catch (Exception e)
		{
			userSession.setAttribute ("setup_error_tax_rate", "");
			inputFailed = true;
		}
		
		String phoneNumber = request.getParameter ("phone_number").trim ();
        if (phoneNumber == null || phoneNumber.length () != 10)
        {
            userSession.setAttribute ("setup_error_phone_number", "");
            inputFailed = true;
        }
        else
        {
			if (CoreTools.containsOnlyNumbers(phoneNumber))
			{
				salon.setPhoneNumber (phoneNumber);
			}
			else
			{
				userSession.setAttribute ("setup_error_phone_number", "");
				inputFailed = true;
			}
        }
		
		String address1 = request.getParameter ("address1").trim ();
		if (address1 == null || address1.length () < 1)
		{
			userSession.setAttribute ("setup_error_address1", "");
			inputFailed = true;
		}
		else salon.setAddress1 (address1);
		
		String address2 = request.getParameter ("address2").trim ();
		salon.setAddress2 (address2);
		
		String city = request.getParameter ("city").trim ();
		if (city == null || city.length () < 1)
		{
			userSession.setAttribute ("setup_error_city", "");
			inputFailed = true;
		}
		else salon.setCity (city);
		
		String province = request.getParameter ("province").trim ();
		if (province == null || province.length () < 1)
		{
			userSession.setAttribute ("setup_error_province", "");
			inputFailed = true;
		}
		else salon.setProvince (province);
		
		String country = request.getParameter ("country").trim ();
		if (country == null || country.length () < 1)
		{
			userSession.setAttribute ("setup_error_country", "");
			inputFailed = true;
		}
		else salon.setCountry (country);
		
		String postalCode = request.getParameter ("postal_code").trim ();
		if (postalCode == null || postalCode.length () < 1)
		{
			userSession.setAttribute ("setup_error_postal_code", "");
			inputFailed = true;
		}
		else salon.setPostalCode (postalCode);
		
		String email = request.getParameter ("email").trim ();
		if (email == null || email.length () < 1)
		{
			userSession.setAttribute ("setup_error_email", "");
			inputFailed = true;
		}
		else salon.setEmail (email);
		
		String firstName = request.getParameter ("manager_first_name").trim ();
		if (firstName == null || firstName.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_first_name", "");
			inputFailed = true;
		}
		else manager.setFirstName (firstName);
		
		String lastName = request.getParameter ("manager_last_name").trim ();
		if (lastName == null || lastName.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_last_name", "");
			inputFailed = true;
		}
		else manager.setLastName (lastName);
		
		String mphoneNumber = request.getParameter ("manager_phone_number").trim ();
        if (mphoneNumber == null || mphoneNumber.length () != 10)
        {
            userSession.setAttribute ("setup_error_manager_phone_number", "");
            inputFailed = true;
        }
        else
        {
			if (CoreTools.containsOnlyNumbers(mphoneNumber))
			{
				manager.setPhoneNumber (mphoneNumber);
			}
			else
			{
				userSession.setAttribute ("setup_error_manager_phone_number", "");
				inputFailed = true;
			}
        }
		
		manager.setRole ("Manager");
		
		String password = request.getParameter ("password").trim ();
		if (password == null || password.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_password", "");
			inputFailed = true;
		}
		else manager.setPassword (password);
		
		String maddress1 = request.getParameter ("address1").trim ();
		if (maddress1 == null || maddress1.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_address1", "");
			inputFailed = true;
		}
		else address.setAddress1 (maddress1);
		
		String maddress2 = request.getParameter ("address2").trim ();
		address.setAddress2 (maddress2);
		
		String mcity = request.getParameter ("city").trim ();
		if (mcity == null || mcity.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_city", "");
			inputFailed = true;
		}
		else address.setCity (mcity);
		
		String mprovince = request.getParameter ("province").trim ();
		if (mprovince == null || mprovince.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_province", "");
			inputFailed = true;
		}
		else address.setProvince (mprovince);
		
		String mcountry = request.getParameter ("country").trim ();
		if (mcountry == null || mcountry.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_country", "");
			inputFailed = true;
		}
		else address.setCountry (mcountry);
		
		String mpostalCode = request.getParameter ("postal_code").trim ();
		if (mpostalCode == null || mpostalCode.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_postal_code", "");
			inputFailed = true;
		}
		else address.setPostalCode (mpostalCode);
		
		String memail = request.getParameter ("email").trim ();
		if (memail == null || memail.length () < 1)
		{
			userSession.setAttribute ("setup_error_manager_email", "");
			inputFailed = true;
		}
		else address.setEmail (memail);
		
		String monday_start = ServletHelper.readTimeRequest (request, "setup_monday_start");
		String monday_end = ServletHelper.readTimeRequest (request, "setup_monday_end");
		String tuesday_start = ServletHelper.readTimeRequest (request, "setup_tuesday_start");
		String tuesday_end = ServletHelper.readTimeRequest (request, "setup_tuesday_end");
		String wednesday_start = ServletHelper.readTimeRequest (request, "setup_wednesday_start");
		String wednesday_end = ServletHelper.readTimeRequest (request, "setup_wednesday_end");
		String thursday_start = ServletHelper.readTimeRequest (request, "setup_thursday_start");
		String thursday_end = ServletHelper.readTimeRequest (request, "setup_thursday_end");
		String friday_start = ServletHelper.readTimeRequest (request, "setup_friday_start");
		String friday_end = ServletHelper.readTimeRequest (request, "setup_friday_end");
		String saturday_start = ServletHelper.readTimeRequest (request, "setup_saturday_start");
		String saturday_end = ServletHelper.readTimeRequest (request, "setup_saturday_end");
		String sunday_start = ServletHelper.readTimeRequest (request, "setup_sunday_start");
		String sunday_end = ServletHelper.readTimeRequest (request, "setup_sunday_end");

		try
		{
			salon.setMondayStart (CoreTools.getTime (monday_start));
			salon.setMondayEnd (CoreTools.getTime (monday_end));
			salon.setTuesdayStart (CoreTools.getTime (tuesday_start));
			salon.setTuesdayEnd (CoreTools.getTime (tuesday_end));
			salon.setWednesdayStart (CoreTools.getTime (wednesday_start));
			salon.setWednesdayEnd (CoreTools.getTime (wednesday_end));
			salon.setThursdayStart (CoreTools.getTime (thursday_start));
			salon.setThursdayEnd (CoreTools.getTime (thursday_end));
			salon.setFridayStart (CoreTools.getTime (friday_start));
			salon.setFridayEnd (CoreTools.getTime (friday_end));
			salon.setSaturdayStart (CoreTools.getTime (saturday_start));
			salon.setSaturdayEnd (CoreTools.getTime (saturday_end));
			salon.setSundayStart (CoreTools.getTime (sunday_start));
			salon.setSundayEnd (CoreTools.getTime (sunday_end));
			
			manager.setMondayStart (CoreTools.getTime (monday_start));
			manager.setMondayEnd (CoreTools.getTime (monday_end));
			manager.setTuesdayStart (CoreTools.getTime (tuesday_start));
			manager.setTuesdayEnd (CoreTools.getTime (tuesday_end));
			manager.setWednesdayStart (CoreTools.getTime (wednesday_start));
			manager.setWednesdayEnd (CoreTools.getTime (wednesday_end));
			manager.setThursdayStart (CoreTools.getTime (thursday_start));
			manager.setThursdayEnd (CoreTools.getTime (thursday_end));
			manager.setFridayStart (CoreTools.getTime (friday_start));
			manager.setFridayEnd (CoreTools.getTime (friday_end));
			manager.setSaturdayStart (CoreTools.getTime (saturday_start));
			manager.setSaturdayEnd (CoreTools.getTime (saturday_end));
			manager.setSundayStart (CoreTools.getTime (sunday_start));
			manager.setSundayEnd (CoreTools.getTime (sunday_end));
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to convert date information.");
			inputFailed = true;
		}
		
		if (!salon.getMondayStart ().equals (salon.getMondayEnd ()) && !salon.getMondayStart ().before (salon.getMondayEnd ()))
		{
			userSession.setAttribute ("setup_error_monday", "");
			inputFailed = true;
		}
		
		if (!salon.getTuesdayStart ().equals (salon.getTuesdayEnd ()) && !salon.getTuesdayStart ().before (salon.getTuesdayEnd ()))
		{
			userSession.setAttribute ("setup_error_tuesday", "");
			inputFailed = true;
		}
		
		if (!salon.getWednesdayStart ().equals (salon.getWednesdayEnd ()) && !salon.getWednesdayStart ().before (salon.getWednesdayEnd ()))
		{
			userSession.setAttribute ("setup_error_wednesday", "");
			inputFailed = true;
		}
		
		if (!salon.getThursdayStart ().equals (salon.getThursdayEnd ()) && !salon.getThursdayStart ().before (salon.getThursdayEnd ()))
		{
			userSession.setAttribute ("setup_error_thursday", "");
			inputFailed = true;
		}
		
		if (!salon.getFridayStart ().equals (salon.getFridayEnd ()) && !salon.getFridayStart ().before (salon.getFridayEnd ()))
		{
			userSession.setAttribute ("setup_error_friday", "");
			inputFailed = true;
		}
		
		if (!salon.getSaturdayStart ().equals (salon.getSaturdayEnd ()) && !salon.getSaturdayStart ().before (salon.getSaturdayEnd ()))
		{
			userSession.setAttribute ("setup_error_saturday", "");
			inputFailed = true;
		}
		
		if (!salon.getSundayStart ().equals (salon.getSundayEnd ()) && !salon.getSundayStart ().before (salon.getSundayEnd ()))
		{
			userSession.setAttribute ("setup_error_sunday", "");
			inputFailed = true;
		}
		
		if (inputFailed)
		{
			userSession.setAttribute ("setup_error", "You have provided invalid input! Review the fields in red.");
			
			userSession.setAttribute ("temp_salon", salon);
			userSession.setAttribute ("temp_manager", manager);
			
			redirect ("hairsalon-setup.jsp", request, response);
			return;
		}
		
		if (!SessionController.saveSalon (userSession, salon) || !SessionController.saveEmployee (userSession, manager))
		{
			userSession.setAttribute ("setup_error", "Unable to save information to database! Contact system administrator.");
			
			userSession.setAttribute ("temp_salon", salon);
			userSession.setAttribute ("temp_manager", manager);
			
			redirect ("hairsalon-setup.jsp", request, response);
			return;
		}
		else
		{
			userSession.removeAttribute ("temp_salon");
			userSession.removeAttribute ("temp_manager");
		}
		
		redirect ("application", request, response);
	}
}
