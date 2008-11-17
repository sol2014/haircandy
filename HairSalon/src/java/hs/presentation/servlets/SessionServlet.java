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
import hs.presentation.*;

/**
 * The session servlet will handle all http requests that will deal with
 * logging in and out of the system.
 * 
 * @author Philippe Durand
 */
public class SessionServlet extends DispatcherServlet
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
		setActionAttribute ("session_action");
		setDefaultExternalAction ("showLogin");
		addExternalAction ("Login", "performLogin");
		addExternalAction ("Logout", "performLogout");
	}

	/**
	 * This action brings up the page to allow the user to login.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void showLogin (UserSession session, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		// For this action we just want to dispatch this request right to the login page.
		LogController.write (this, "[USER REQUEST] Performing show login.");
		
		redirect ("login-employee.jsp", request, response);
	}

	/**
	 * This action allows a user to log into the system using their employee
	 * id and their password.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLogin (UserSession session, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing login.");

		String id = request.getParameter ("login_id");
		String password = request.getParameter ("login_password");

		// we should store the cookie with the information we got.
		Cookie idCookie = new Cookie ("USERNAME", id);
		idCookie.setMaxAge (365 * 24 * 60 * 60);

		response.addCookie (idCookie);

		// Now we use the controller to authenticate the session using those values.
		if (SessionController.authenticateSession (session, id, password))
		{
			// Now we dispatch the request to the application servlet.
			forward ("application", request, response);
		}
		else
		{
			session.setAttribute ("session_login_id", id);
			session.setAttribute ("login_error", "Authentication failed! Invalid id and/or password.");

			redirect ("login-employee.jsp", request, response);
		}
	}

	/**
	 * This action allows an employee to log out of the system and sends them
	 * back to the login page.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLogout (UserSession session, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing logout.");

		SessionController.deauthenticateSession (session);

		forward ("login-employee.jsp", request, response);
	}
}
