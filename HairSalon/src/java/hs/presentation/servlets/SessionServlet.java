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
 * Session presentation servlet that deals with the session aspect of
 * requests for login/logout.
 * 
 * @author Philippe Durand
 */
public class SessionServlet extends DispatcherServlet
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
		setActionAttribute ("session_action");
		setDefaultExternalAction ("showLogin");
		addExternalAction ("Login", "performLogin");
		addExternalAction ("Logout", "performLogout");
	}

	/**
	 * Used to show the user the login page.
	 * 
	 * @param session
	 * @param request
	 * @param response
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
	 * Perform the login action, uses the "login_username" and "login_password"
	 * attribute tags to obtain the login request parameters.
	 * 
	 * @param session the user session that is requesting the action.
	 * @param request the http request used.
	 * @param response the http response used.
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

		Cookie passCookie = new Cookie ("PASSWORD", password);
		passCookie.setMaxAge (365 * 24 * 60 * 60);

		response.addCookie (idCookie);
		response.addCookie (passCookie);

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
	 * Performs the logout for an employee session. Uses no attributes to perform
	 * this action.
	 * 
	 * @param session
	 * @param request
	 * @param response
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
