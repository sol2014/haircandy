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
}
