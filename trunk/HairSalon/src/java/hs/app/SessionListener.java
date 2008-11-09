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

import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;

/**
 * This will assist in initializing user sessions.
 * 
 * @author pdurand
 */
public class SessionListener implements HttpSessionListener
{
    public void sessionCreated(HttpSessionEvent event)
    {
        HttpSession session = event.getSession();
		
		LogController.write ("Session created!");
		
		// Add the user session data to the http session.
		UserSession userSession = SessionController.newSession ();
		session.setAttribute ("user_session", userSession);
    }
	
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

