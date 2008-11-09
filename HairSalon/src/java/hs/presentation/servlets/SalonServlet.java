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

public class SalonServlet extends DispatcherServlet
{
	/**
	 * Sets up internal and external action attribute tags used for this
	 * servlet as well as setting the action methods using reflection.
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

	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing revert.");
		
		userSession.setAttribute ("salon_feedback", "Salon was reverted successfully.");
		
		forward ("/view-salon.jsp", request, response);
	}
	
	/**
	 * Saves the salon details into the database.
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
		
		String hairStations = request.getParameter ("hair_stations").trim ();
		try
		{
			salon.setHairStations (Integer.parseInt (hairStations));
		}
		catch (Exception e)
		{
			userSession.setAttribute ("salon_error_hair_stations", "");
			inputFailed = true;
		}
		
		String beautyStations = request.getParameter ("beauty_stations").trim ();
		try
		{
			salon.setBeautyStations (Integer.parseInt (beautyStations));
		}
		catch (Exception e)
		{
			userSession.setAttribute ("salon_error_beauty_stations", "");
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
