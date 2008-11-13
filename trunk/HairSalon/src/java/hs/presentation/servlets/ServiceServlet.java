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
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.objects.*;
import hs.app.*;
import hs.presentation.*;

/**
 * Service presentation servlet that deals with searching, maintaining and
 * creating service record requests from the user.
 * 
 * @author Philippe Durand
 */
public class ServiceServlet extends DispatcherServlet
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
		setActionAttribute ("service_action");
		
		// Ajax actions
		addExternalAction ("ServiceSearch", "performServiceSearch");
		addExternalAction ("EmployeeServiceRefill", "performEmployeeServiceRefill");
		addExternalAction ("SaleServiceRefill", "performSaleServiceRefill");
		addExternalAction ("AppointmentServiceRefill", "performAppointmentServiceRefill");
		
		// User actions
		addExternalAction ("Search", "performSearch");
		addExternalAction ("Load", "performLoad");
		addExternalAction ("Revert", "performRevert");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Finish", "performSave");
		addExternalAction ("New Service", "performNewService");
	}
	
	public void performAppointmentServiceRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing appointment service refill.");
		
		Hashtable<ServiceBean, Integer> searchResults = new Hashtable<ServiceBean, Integer> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		String[] quantitys = request.getParameterValues ("quantity");

		if (names != null && quantitys != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ServiceBean sb = new ServiceBean ();
				sb.setServiceNo (Integer.parseInt (ids[i]));
				sb = SessionController.loadService (userSession, sb);
				searchResults.put (sb, Integer.parseInt (quantitys[i]));
			}
		}

		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-appointmentservice-delete.jsp", request, response);
	}
	
	public void performSaleServiceRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing sale service refill.");
		
		Hashtable<ServiceBean, Integer> searchResults = new Hashtable<ServiceBean, Integer> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		String[] quantitys = request.getParameterValues ("quantity");

		if (names != null && quantitys != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ServiceBean sb = new ServiceBean ();
				sb.setServiceNo (Integer.parseInt (ids[i]));
				sb = SessionController.loadService (userSession, sb);
				searchResults.put (sb, Integer.parseInt (quantitys[i]));
			}
		}

		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-saleservice-delete.jsp", request, response);
	}

	public void performEmployeeServiceRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing employee service refill.");
		
		ArrayList<ServiceBean> searchResults = new ArrayList<ServiceBean> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");

		if (names != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ServiceBean sb = new ServiceBean ();
				sb.setServiceNo (Integer.parseInt (ids[i]));
				sb = SessionController.loadService (userSession, sb);
				searchResults.add (sb);
			}
		}

		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-employeeservice-delete.jsp", request, response);
	}

	public void performServiceSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing service search.");
		
		String name = request.getParameter ("service_name");
		if (name.equals(""))
		{
			name = null;
		}
		ServiceBean sb = new ServiceBean ();
		sb.setName (name);
		sb.setEnabled (true);
		
		ServiceBean[] searchResults = SessionController.searchServices (userSession, sb);
		ArrayList<ServiceBean> sbs = new ArrayList<ServiceBean> ();
		for (ServiceBean bean : searchResults)
		{
			sbs.add (bean);
		}
		request.setAttribute ("searchResults", sbs);
		forward ("ajax/ajax-service-add.jsp", request, response);
	}

	/**
	 * Used to search for service records and then show the results to the
	 * page for the user to select one.
	 * 
	 * @param session the user session that is requesting the action.
	 * @param request the http request used.
	 * @param response the http response used.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing search.");
		
		ServiceBean service = new ServiceBean ();

		String name = request.getParameter ("firstfield");
		if (!name.equals (""))
		{
			service.setName (name);
		}

		String description = request.getParameter ("description");
		if (!description.equals (""))
		{
			service.setDescription (description);
		}

		String used = request.getParameter ("enabled");
		if (!used.equals ("None"))
		{
			service.setEnabled (used.equals ("True"));
		}

		ServiceBean[] searchResults = SessionController.searchServices (userSession, service);

		userSession.setAttribute ("service_search_result", searchResults);

		userSession.setAttribute ("service_search_name", name);
		userSession.setAttribute ("service_search_description", description);
		userSession.setAttribute ("service_search_enabled", used);

		redirect ("search-services.jsp", request, response);
	}

	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String serialized_service = (String) request.getParameter ("temp_service");
		ServiceBean service = null;

		if (serialized_service == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");

			userSession.setAttribute ("service_error", "Unable to revert service bean, temporary data lost!");

			forward ("/search-service.jsp", request, response);

			return;
		}
		else
		{
			service = (ServiceBean) CoreTools.deserializeBase64 (serialized_service);
		}

		service = SessionController.loadService (userSession, service);

		if (service != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+service.getServiceNo ());
			
			userSession.setAttribute ("service_load_result", service);
			userSession.setAttribute ("service_feedback", "Service was reverted successfully.");

			forward ("/maintain-service.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("service_error", "Unable to revert service bean from the database!");

			forward ("/search-service.jsp", request, response);
		}
	}

	/**
	 * Loads the service record from the database and show the information
	 * in a maintenance page.
	 * 
	 * @param session the user session that is requesting the action.
	 * @param request the http request used.
	 * @param response the http response used.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String service_no = (String) request.getParameter ("service_no");
		ServiceBean service = new ServiceBean ();

		try
		{
			service.setServiceNo (Integer.parseInt (service_no));
		}
		catch (Exception ex)
		{
			LogController.write (this, "Invalid service number requested externally: " + service_no);
			// Maybe we should do something to show an error on the page?
			return;
		}

		service = SessionController.loadService (userSession, service);

		if (service != null)
		{
			LogController.write (this, "[USER REQUEST] Performing load: "+service.getServiceNo ());
			
			userSession.setAttribute ("service_load_result", service);

			forward ("/maintain-service.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("service_error", ErrorCodes.LoadError);

			forward ("/search-service.jsp", request, response);
		}
	}

	public void performNewService (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing new service.");
		
		userSession.setAttribute ("service_new_duration", 0);

		redirect ("create-service.jsp", request, response);
	}

	/**
	 * Saves the service details into the database.
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
		String serialized_service = (String) request.getParameter ("temp_service");
		ServiceBean service = null;

		if (serialized_service == null)
		{
			service = new ServiceBean ();
		}
		else
		{
			service = (ServiceBean) CoreTools.deserializeBase64 (serialized_service);

			String[] products = request.getParameterValues ("products");
			Hashtable<ProductBean, Integer> hash = service.getProductUse ();

			// There is a bug here, if we clear the hash, then it fixes the save.
			// if we dont clear, then we get duplicates in the hashtable.

			hash.clear ();
			if (products != null)
			{
				for (String product : products)
				{
					try
					{
						ProductBean pb = new ProductBean ();
						String[] productinfo = product.split (":");

						pb.setProductNo (Integer.parseInt (productinfo[0]));
						int amount = 0;

						try
						{
							amount = Integer.parseInt (productinfo[1]);
						}
						catch (Exception e)
						{
							amount = 0;
						}

						pb = (ProductBean) SessionController.loadProduct (userSession, pb);

						while (hash.contains (pb))
						{
							hash.remove (pb);
						}
						hash.remove (pb);
						hash.put (pb, amount);
					}
					catch (Exception e)
					{
						// Invalid product integer, unlikely.
					}
				}
			}

			service.setProductUse (hash);
		}

		boolean inputFailed = false;

		String name = request.getParameter ("firstfield").trim ();
		if (name == null || name.length () < 1)
		{
			userSession.setAttribute ("service_error_name", "");
			inputFailed = true;
		}
		else
		{
			service.setName (name);
		}
		String description = request.getParameter ("description").trim ();
		if (description == null || description.length () < 1)
		{
			userSession.setAttribute ("service_error_description", "");
			inputFailed = true;
		}
		else
		{
			service.setDescription (description);
		}
		
		int hours = 0;
		int minutes = 0;
		
		String durationHours = request.getParameter ("duration_hour");
		if (!durationHours.equals (""))
		{
			try
			{
				hours = Integer.parseInt (durationHours);
			}
			catch (Exception e)
			{
			}
		}

		String durationMinutes = request.getParameter ("duration_min");
		if (!durationMinutes.equals (""))
		{
			try
			{
				minutes = Integer.parseInt (durationMinutes);
			}
			catch (Exception e)
			{
			}
		}
		
		int duration = (hours*60)+minutes;
		service.setDuration (duration);
		
		String price = request.getParameter ("price");
		try
		{
			service.setPrice (Double.parseDouble (price));
		}
		catch(Exception e)
		{
			userSession.setAttribute ("service_error_price", "");
			inputFailed = true;
		}
		
		String used = request.getParameter ("enabled").trim ();
		service.setEnabled (Boolean.parseBoolean (used));

		if (inputFailed)
		{
			userSession.setAttribute ("service_error", "You have provided invalid input! Review the fields in red.");

			if (serialized_service == null)
			{
				userSession.setAttribute ("service_new_name", name);
				userSession.setAttribute ("service_new_description", description);
				userSession.setAttribute ("service_new_duration", duration);
				userSession.setAttribute ("service_new_price", price);
				userSession.setAttribute ("service_new_enabled", used);

				redirect ("create-service.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("temp_service", service);

				redirect ("service?service_action=Load&service_no=" + service.getServiceNo (), request, response);
			}

			return;
		}

		// Save the delays and then reload the results back to the maintain page.
		if (SessionController.saveService (userSession, service))
		{
			LogController.write (this, "[USER REQUEST] Performing save: "+service.getServiceNo ());
			
			userSession.setAttribute ("service_feedback", "Service was saved successfully.");

			userSession.removeAttribute ("temp_service");

			redirect ("service?service_action=Load&service_no=" + service.getServiceNo (), request, response);
		}
		else
		{
			if (serialized_service == null)
			{
				userSession.setAttribute ("service_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("service_new_name", name);
				userSession.setAttribute ("service_new_description", description);
				userSession.setAttribute ("service_new_duration", duration);
				userSession.setAttribute ("service_new_price", price);
				userSession.setAttribute ("service_new_enabled", used);

				redirect ("create-service.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("service_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("temp_service", service);

				redirect ("service?service_action=Load&service_no=" + service.getServiceNo (), request, response);
			}
		}
	}
}
