/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.app;

import javax.servlet.http.*;

import hs.core.*;

/**
 * This will assist in initializing/destroying user sessions.
 * 
 * @author pdurand
 */
public class SessionListener implements HttpSessionListener
{
	/**
	 * Occurs when a new session is created in our web application.
	 * 
	 * @param event
	 */
    public void sessionCreated(HttpSessionEvent event)
    {
        HttpSession session = event.getSession();
		
		LogController.write ("Session created!");
		
		// Add the user session data to the http session.
		UserSession userSession = SessionController.newSession ();
		session.setAttribute ("user_session", userSession);
    }
	
	/**
	 * Occurs when a session is destroyed and removed from the web application.
	 * 
	 * @param event
	 */
    public void sessionDestroyed(HttpSessionEvent event)
    {
        HttpSession session = event.getSession();
		
		LogController.write ("Session destroyed!");
		
		UserSession userSession = (UserSession)session.getAttribute ("user_session");
		
		SessionController.removeSession (userSession);
		
		// Clear the user session data from the http session.
		session.removeAttribute ("user_session");
    }
}

