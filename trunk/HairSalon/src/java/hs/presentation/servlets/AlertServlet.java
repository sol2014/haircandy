/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
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

public class AlertServlet extends DispatcherServlet
{
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("alert_action");
		addExternalAction ("Delete", "performDelete");
	}

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
		
		if (SessionController.deleteAlert (userSession, alert))
		{
			
		}
		else
		{
			
		}
		
		forward ("welcome-employee.jsp", request, response);
	}
}
