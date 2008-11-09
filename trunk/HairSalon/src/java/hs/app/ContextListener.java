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

import hs.core.*;
import hs.persistence.*;

/**
 * Context listener will help initialize/shutdown our application services.
 * 
 * @author Philippe Durand
 */
public class ContextListener implements ServletContextListener
{
	/**
	 * Initializes the various controllers that we need during the application's
	 * lifecycle.
	 * 
	 * @param event Details about the event.
	 */
    public void contextInitialized(ServletContextEvent event)
    {
        ServletContext context = event.getServletContext();
        
		String url = context.getInitParameter ("db_url");
		String username = context.getInitParameter ("db_username");
		String password = context.getInitParameter ("db_password");
		
		LogController.initialize ();
		PersistenceController.initialize (url, username, password);
    }
	
	/**
	 * Shuts down the controllers that were used for our application to function.
	 * 
	 * @param event Details about the event.
	 */
    public void contextDestroyed(ServletContextEvent event)
    {
        ServletContext context = event.getServletContext ();
		
		PersistenceController.shutdown ();
		LogController.shutdown ();
    }
}
