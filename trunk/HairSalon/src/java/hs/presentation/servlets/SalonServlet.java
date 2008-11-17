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
import hs.presentation.*;
import hs.app.*;
import java.util.ArrayList;

/**
 * The salon servlet will handle all http requests that will deal with
 * manipulation of salon information in the system.
 * 
 * @author Philippe Durand
 */
public class SalonServlet extends DispatcherServlet
{
	/**
	 * Sets up defaults for action handling used by this servlet. See the
	 * DispatcherServlet for more details.
	 * 
	 * @throws java.lang.NoSuchMethodException
	 */
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("salon_action");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Revert", "performRevert");
	}

	/**
	 * This action allows the user to revert all of the salon information
	 * on the page by loading the information from the system.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing revert.");
		
		userSession.setAttribute ("salon_feedback", "Salon was reverted successfully.");
		
		forward ("/view-salon.jsp", request, response);
	}
	
	/**
	 * This action allows the user to save the salon information into the 
	 * system. Any errors about the business hours or any other values will
	 * be sent back to the page to be displayed to the user.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing save.");
		
		String serialized_salon = (String) request.getParameter ("temp_salon");
		SalonBean salon = null;
		
		boolean exceptionFailed = false;
		
		if (serialized_salon == null)
		{
			salon = new SalonBean ();
		}
		else
		{
			salon = (SalonBean) CoreTools.deserializeBase64 (serialized_salon);
			
			String[] dates = request.getParameterValues ("dates");
			String[] reasons = request.getParameterValues ("reasons");

			try
			{
				ArrayList<ScheduleExceptionBean> sebs = new ArrayList<ScheduleExceptionBean> ();
				
				if (dates != null)
				{
					for (int i = 0; i < dates.length; i++)
					{
						ScheduleExceptionBean seb = new ScheduleExceptionBean ();
						seb.setDate (CoreTools.getDate (dates[i]));
						seb.setReason (reasons[i]);
						
						// We must check to make sure that the schedule exception is not going to
						// violate already existing schedule entries.
						if (SessionController.getSchedule (userSession, seb.getDate()) != null)
						{
							exceptionFailed = true;
						}
						else
							sebs.add (seb);
					}
				}
				
				salon.setExceptions (sebs);
			}
			catch (Exception e)
			{
			}
		}
		
		boolean inputFailed = false;
		
		String name = request.getParameter ("salon_name").trim ();
		if (name == null || name.length () < 1)
		{
			userSession.setAttribute ("salon_error_salon_name", "");
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
			userSession.setAttribute ("salon_error_salon_name", "");
			inputFailed = true;
		}
		
		String phoneNumber = request.getParameter ("phone_number").trim ();
        if (phoneNumber == null || phoneNumber.length () != 10)
        {
            userSession.setAttribute ("salon_error_phone_number", "");
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
				userSession.setAttribute ("salon_error_phone_number", "");
				inputFailed = true;
			}
        }
		
		String address1 = request.getParameter ("address1").trim ();
		if (address1 == null || address1.length () < 1)
		{
			userSession.setAttribute ("salon_error_address1", "");
			inputFailed = true;
		}
		else salon.setAddress1 (address1);
		
		String address2 = request.getParameter ("address2").trim ();
		salon.setAddress2 (address2);
		
		String city = request.getParameter ("city").trim ();
		if (city == null || city.length () < 1)
		{
			userSession.setAttribute ("salon_error_city", "");
			inputFailed = true;
		}
		else salon.setCity (city);
		
		String province = request.getParameter ("province").trim ();
		if (province == null || province.length () < 1)
		{
			userSession.setAttribute ("salon_error_province", "");
			inputFailed = true;
		}
		else salon.setProvince (province);
		
		String country = request.getParameter ("country").trim ();
		if (country == null || country.length () < 1)
		{
			userSession.setAttribute ("salon_error_country", "");
			inputFailed = true;
		}
		else salon.setCountry (country);
		
		String postalCode = request.getParameter ("postal_code").trim ();
		if (postalCode == null || postalCode.length () < 1)
		{
			userSession.setAttribute ("salon_error_postal_code", "");
			inputFailed = true;
		}
		else salon.setPostalCode (postalCode);
		
		String email = request.getParameter ("email").trim ();
		if (email == null || email.length () < 1)
		{
			userSession.setAttribute ("salon_error_email", "");
			inputFailed = true;
		}
		else salon.setEmail (email);
		
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
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to convert date information.");
			inputFailed = true;
		}
		
		if (!salon.getMondayStart ().equals (salon.getMondayEnd ()) && !salon.getMondayStart ().before (salon.getMondayEnd ()))
		{
			userSession.setAttribute ("salon_error_monday", "");
			inputFailed = true;
		}
		
		if (!salon.getTuesdayStart ().equals (salon.getTuesdayEnd ()) && !salon.getTuesdayStart ().before (salon.getTuesdayEnd ()))
		{
			userSession.setAttribute ("salon_error_tuesday", "");
			inputFailed = true;
		}
		
		if (!salon.getWednesdayStart ().equals (salon.getWednesdayEnd ()) && !salon.getWednesdayStart ().before (salon.getWednesdayEnd ()))
		{
			userSession.setAttribute ("salon_error_wednesday", "");
			inputFailed = true;
		}
		
		if (!salon.getThursdayStart ().equals (salon.getThursdayEnd ()) && !salon.getThursdayStart ().before (salon.getThursdayEnd ()))
		{
			userSession.setAttribute ("salon_error_thursday", "");
			inputFailed = true;
		}
		
		if (!salon.getFridayStart ().equals (salon.getFridayEnd ()) && !salon.getFridayStart ().before (salon.getFridayEnd ()))
		{
			userSession.setAttribute ("salon_error_friday", "");
			inputFailed = true;
		}
		
		if (!salon.getSaturdayStart ().equals (salon.getSaturdayEnd ()) && !salon.getSaturdayStart ().before (salon.getSaturdayEnd ()))
		{
			userSession.setAttribute ("salon_error_saturday", "");
			inputFailed = true;
		}
		
		if (!salon.getSundayStart ().equals (salon.getSundayEnd ()) && !salon.getSundayStart ().before (salon.getSundayEnd ()))
		{
			userSession.setAttribute ("salon_error_sunday", "");
			inputFailed = true;
		}
		
		if (inputFailed)
		{
			userSession.setAttribute ("salon_error", "You have provided invalid input! Review the fields in red.");
			
			userSession.setAttribute ("temp_salon", salon);
			
			redirect ("view-salon.jsp", request, response);
			return;
		}
		
		if (!SessionController.saveSalon (userSession, salon))
		{
			userSession.setAttribute ("salon_error", "Unable to save salon information to database! Contact system administrator.");
			
			userSession.setAttribute ("temp_salon", salon);
		}
		else
		{
			if (exceptionFailed)
				userSession.setAttribute ("employee_error", "Some exceptions conflicted with existing schedule entries.");
			
			userSession.setAttribute ("salon_feedback", "Salon information saved successfully.");
			
			userSession.removeAttribute ("temp_salon");
		}
		
		redirect ("view-salon.jsp", request, response);
	}
}
