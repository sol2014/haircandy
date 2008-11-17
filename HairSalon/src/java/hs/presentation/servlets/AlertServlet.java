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
import hs.app.*;
import hs.objects.*;
import hs.presentation.*;

/**
 * The alert servlet will handle all http requests that will deal with
 * manipulation and lookup of alert information in the system.
 * 
 * @author Philippe Durand
 */
public class AlertServlet extends DispatcherServlet
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
		setActionAttribute ("alert_action");
		addExternalAction ("Delete", "performDelete");
		addExternalAction ("DeleteAll", "performDeleteAll");
	}

	/**
	 * This action deletes all alerts from the system.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performDeleteAll (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing all alert delete.");
		
		SessionController.deleteAlerts(userSession);
		
		forward ("welcome-employee.jsp", request, response);
	}
	
	/**
	 * This action deletes a single alert from the system.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performDelete (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String alert_no = request.getParameter ("alert_no");
		
		LogController.write (this, "[USER REQUEST] Performing alert delete: "+alert_no);
		
		AlertBean alert = new AlertBean ();
		
		try
		{
			alert.setAlertNo (Integer.parseInt (alert_no));
		}
		catch (Exception e)
		{
			LogController.write (this, "Received invalid value for alert number: "+alert_no);
			return;
		}
		
		SessionController.deleteAlert (userSession, alert);
		
		forward ("welcome-employee.jsp", request, response);
	}
}
