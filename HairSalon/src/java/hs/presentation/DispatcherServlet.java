/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.presentation;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.lang.reflect.*;

import hs.core.*;

/**
 * A dispatcher servlet that provides an easy way to dispatch request and
 * responses to the resource provided and streamlines post and get to a single
 * processing method. It also allows the servlets that extend this, can easily
 * register actions to be handled internally and externally (from jsps).
 * 
 * @author Philippe Durand
 */
public abstract class DispatcherServlet extends HttpServlet
{
	private boolean actionInitialized = false;
	private boolean isGetAllowed = true;
	private boolean isPostAllowed = true;
	private String actionTag = null;
	private Method defaultInternalMethod = null;
	private Method defaultExternalMethod = null;
	private Hashtable<String, Method> internalActions = new Hashtable<String, Method> ();
	private Hashtable<String, Method> externalActions = new Hashtable<String, Method> ();

	public boolean getIsGetAllowed ()
	{
		return isGetAllowed;
	}

	public void setIsGetAllowed (boolean isAllowed)
	{
		isGetAllowed = isAllowed;
	}

	public boolean getIsPostAllowed ()
	{
		return isPostAllowed;
	}

	public void setIsPostAllowed (boolean isAllowed)
	{
		isPostAllowed = isAllowed;
	}

	public Class[] getActionArgs ()
	{
		return new Class[]
			{
				UserSession.class, HttpServletRequest.class, HttpServletResponse.class
			};
	}

	public void setActionAttribute (String actionTag)
	{
		this.actionTag = actionTag;
	}

	public void setDefaultInternalAction (String methodName) throws NoSuchMethodException
	{
		Method method = this.getClass ().getMethod (methodName, getActionArgs ());
		this.defaultInternalMethod = method;
	}

	public void addInternalAction (String action, Method method)
	{
		this.internalActions.put (action, method);
	}

	//added by joey
	public void addInternalAction (String action, String methodName) throws NoSuchMethodException
	{
		Method method = this.getClass ().getMethod (methodName, getActionArgs ());
		addInternalAction (action, method);
	}
	//end
	public void removeInternalAction (String action)
	{
		this.internalActions.remove (action);
	}

	public void setDefaultExternalAction (String methodName) throws NoSuchMethodException
	{
		Method method = this.getClass ().getMethod (methodName, getActionArgs ());
		this.defaultExternalMethod = method;
	}

	public void addExternalAction (String action, Method method)
	{
		this.externalActions.put (action, method);
	}

	//added by joey
	public void addExternalAction (String action, String methodName) throws NoSuchMethodException
	{
		Method method = this.getClass ().getMethod (methodName, getActionArgs ());
		addExternalAction (action, method);
	}
	//end
	public void removeExternalAction (String action)
	{
		this.externalActions.remove (action);
	}

	@Override
	public void init ()
	{
		setIsPostAllowed (true);
		setIsGetAllowed (true);

		try
		{
			setupActionMethods ();
		}
		catch (NoSuchMethodException methodEx)
		{
			LogController.write (this, "FATAL: No such method: " + methodEx.getMessage ());
			return;
		}
		finally
		{
			actionInitialized = true;
		}
	}

	/**
	 * Gives the servlet the opportunity to setup its internal and external
	 * action attribute tags used to receive requests. They also will need to setup
	 * the action methods that will be used with which attribute values.
	 * 
	 * @throws java.lang.NoSuchMethodException
	 */
	public abstract void setupActionMethods () throws NoSuchMethodException;

	/**
	 * Processes the request coming to the servlet and grabs the attributes
	 * set by the servlet and uses them to fire off pre-determined methods
	 * set in the setupActionMethods function of the servlet.
	 * 
	 * @param request the http request coming from the browser.
	 * @param response the http response going to the browser.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	protected void processRequest (HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		if (!actionInitialized)
		{
			LogController.write (this, "This dispatcher servlet is not initialized properly!");
			return;
		}

		if (actionTag == null)
		{
			LogController.write (this, "There is no action attribute tag name!");
			return;
		}

		HttpSession httpSession = request.getSession ();
		UserSession userSession = (UserSession) httpSession.getAttribute ("user_session");
		
		if (userSession == null)
		{
			LogController.write (this, "User session is no longer available in this http session.");
			
			userSession = new UserSession ();
			
			// We always want a user session though...
			httpSession.setAttribute ("user_session", userSession);
		}
		
		String action = (String) request.getAttribute (actionTag);

		try
		{
			if (action == null)
			{
				// There is no action attribute specified, check parameters.
				String external_action = (String) request.getParameter (actionTag);

				if (external_action != null)
				{
					Method method = externalActions.get (external_action);

					if (method != null)
					{
						LogController.write (this, "Performing external action: " + external_action);
						method.invoke (this, new Object[] { userSession, request, response });
					}
					else
					{
						if (defaultExternalMethod != null)
						{
							LogController.write (this, "Performing default external action.");
							defaultExternalMethod.invoke (this, new Object[]
								{
									userSession, request, response
								});
						}
						else
						{
							LogController.write (this, "Unable to perform default external action.");
						}
					}
				}
				else
				{
					if (defaultExternalMethod != null)
					{
						LogController.write (this, "Performing default external action.");
						defaultExternalMethod.invoke (this, new Object[]
							{
								userSession, request, response
							});
					}
					else
					{
						LogController.write (this, "Unable to perform default external action.");
					}
				}
			}
			else
			{
				Method method = internalActions.get (action);

				if (method != null)
				{
					LogController.write (this, "Performing internal action: " + action);
					method.invoke (this, new Object[]
						{
							userSession, request, response
						});
				}
				else
				{
					if (defaultInternalMethod != null)
					{
						LogController.write (this, "Performing default internal action.");
						defaultInternalMethod.invoke (this, new Object[]
							{
								userSession, request, response
							});
					}
					else
					{
						LogController.write (this, "Unable to perform default internal action.");
					}
				}

				request.removeAttribute ("application_action");
			}
		}
		catch (IllegalAccessException accessEx)
		{
			LogController.write (this, "Exception while processing request: " + accessEx.getMessage ());
		}
		catch (InvocationTargetException invokeEx)
		{
			LogController.write (this, "Exception while processing request: " + invokeEx.toString());
			invokeEx.printStackTrace ();
		}
		catch (Exception ex)
		{
			LogController.write (this, "Unknown exception: "+ ex.toString ());
		}
	}

	/**
	 * Allows one to forward the following request and response using the request
	 * dispatcher.
	 * 
	 * @param resource the resource to forward the request/response to.
	 * @param request the http request to forward.
	 * @param response the http response to forward.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	protected void forward (String resource, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		RequestDispatcher rd = request.getRequestDispatcher (resource);
		rd.forward (request, response);
	}

	/**
	 * Allows one to forward the following request and response using the request
	 * dispatcher.
	 * 
	 * @param resource the resource to forward the request/response to.
	 * @param request the http request to forward.
	 * @param response the http response to forward.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	protected void redirect (String resource, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		response.sendRedirect (response.encodeRedirectURL (resource));
	}

	@Override
	protected void doGet (HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		if (getIsGetAllowed ())
		{
			processRequest (request, response);
		}
	}

	@Override
	protected void doPost (HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		if (getIsPostAllowed ())
		{
			processRequest (request, response);
		}
	}
}
