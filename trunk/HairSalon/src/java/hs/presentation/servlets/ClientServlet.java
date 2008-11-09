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

public class ClientServlet extends DispatcherServlet
{
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("client_action");
		addExternalAction ("ClientLookup", "performClientLookup");
		addExternalAction ("Search", "performSearch");
		addExternalAction ("New Client", "performNewClient");
		addExternalAction ("Load", "performLoad");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Finish", "performSave");
		addExternalAction ("Revert", "performRevert");
	}

	public void performClientLookup (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String phoneNumber = request.getParameter ("phone_number");
		
		LogController.write (this, "[USER REQUEST] Performing client lookup: "+phoneNumber);
		
		ClientBean client = new ClientBean ();
		AddressBean ab = new AddressBean ();
		client.setAddress (ab);
		client.setPhoneNumber (phoneNumber);

		ClientBean[] results = SessionController.searchClients (userSession, client);

		if (results.length > 0)
		{
			ClientBean theClient = results[0];
			try
			{
				response.setContentType ("text/html");
				response.setCharacterEncoding ("UTF-8");
				PrintWriter pw = response.getWriter ();
				pw.print ("finished('" + theClient.getFirstName () + "','" + theClient.getLastName () + "');");
				pw.close ();
			}
			catch (Exception e)
			{
			}
		}
	}

	public void performSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing search.");
		
		ClientBean client = new ClientBean ();
		AddressBean address = new AddressBean ();

		String firstName = request.getParameter ("first_name");
		if (!firstName.equals (""))
		{
			client.setFirstName (firstName);
		}

		String lastName = request.getParameter ("last_name");
		if (!lastName.equals (""))
		{
			client.setLastName (lastName);
		}

		String phoneNumber = request.getParameter ("phone_number");
		if (!phoneNumber.equals (""))
		{
			client.setPhoneNumber (phoneNumber);
		}

		String address1 = request.getParameter ("address1");
		if (!address1.equals (""))
		{
			address.setAddress1 (address1);
		}

		String address2 = request.getParameter ("address2");
		if (!address2.equals (""))
		{
			address.setAddress2 (address2);
		}

		String city = request.getParameter ("city");
		if (!city.equals (""))
		{
			address.setCity (city);
		}

		String province = request.getParameter ("province");
		if (!province.equals (""))
		{
			address.setProvince (province);
		}

		String country = request.getParameter ("country");
		if (!country.equals (""))
		{
			address.setCountry (country);
		}

		String postalCode = request.getParameter ("postal_code");
		if (!postalCode.equals (""))
		{
			address.setPostalCode (postalCode);
		}
		String email = request.getParameter ("email");
		if (!email.equals (""))
		{
			address.setEmail (email);
		}

		client.setAddress (address);

		String used = request.getParameter ("enabled");
		if (!used.equals ("None"))
		{
			client.setEnabled (used.equals ("True"));
		}

		ClientBean[] searchResults = SessionController.searchClients (userSession, client);

		userSession.setAttribute ("client_search_result", searchResults);

		// We also need to keep track of all the search parameters we used, to show back on page.
		userSession.setAttribute ("client_search_first_name", firstName);
		userSession.setAttribute ("client_search_last_name", lastName);
		userSession.setAttribute ("client_search_phone_number", phoneNumber);
		userSession.setAttribute ("client_search_address1", address1);
		userSession.setAttribute ("client_search_address2", address2);
		userSession.setAttribute ("client_search_city", city);
		userSession.setAttribute ("client_search_province", province);
		userSession.setAttribute ("client_search_country", country);
		userSession.setAttribute ("client_search_postal_code", postalCode);
		userSession.setAttribute ("client_search_email", email);
		userSession.setAttribute ("client_search_enabled", used);

		redirect ("search-clients.jsp", request, response);
	}

	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String serialized_client = (String) request.getParameter ("temp_client");
		ClientBean client = null;
		
		if (serialized_client == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");

			userSession.setAttribute ("client_error", "Unable to revert client, temporary data lost!");

			forward ("/search-client.jsp", request, response);

			return;
		}
		else
		{
			client = (ClientBean) CoreTools.deserializeBase64 (serialized_client);
		}

		client = SessionController.loadClient (userSession, client);

		if (client != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+client.getClientNo());
			
			userSession.setAttribute ("client_load_result", client);
			userSession.setAttribute ("client_feedback", "Client was reverted successfully.");

			forward ("/maintain-client.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("client_error", "Unable to revert client from the database!");

			forward ("/search-client.jsp", request, response);
		}
	}

	public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String client_no = (String) request.getParameter ("client_no");
		ClientBean client = new ClientBean ();

		try
		{
			client.setClientNo (Integer.parseInt (client_no));
		}
		catch (Exception ex)
		{
			LogController.write (this, "Invalid client number requested externally: " + client_no);
			// Maybe we should do something to show an error on the page?
			return;
		}

		client = SessionController.loadClient (userSession, client);

		if (client != null)
		{
			LogController.write (this, "[USER REQUEST] Performing load: "+client.getClientNo());
			
			userSession.setAttribute ("client_load_result", client);

			forward ("maintain-client.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("client_error", "Unable to load client record! Please contact system administrator.");

			forward ("search-clients.jsp", request, response);
		}
	}

	public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		// We want to grab the temporary bean data
		String serialized_client = (String) request.getParameter ("temp_client");
		ClientBean client = null;
		AddressBean address = null;

		if (serialized_client == null)
		{
			// This is a new client.
			client = new ClientBean ();
			address = new AddressBean ();
			client.setAddress (address);
		}
		else
		{
			client = (ClientBean) CoreTools.deserializeBase64 (serialized_client);
			address = client.getAddress ();
		}

		boolean inputFailed = false;

		String firstName = request.getParameter ("first_name").trim ();
		if (firstName == null || firstName.length () < 1)
		{
			userSession.setAttribute ("client_error_first_name", "");
			inputFailed = true;
		}
		else
		{
			client.setFirstName (firstName);
		}
		String lastName = request.getParameter ("last_name").trim ();
		if (lastName == null || lastName.length () < 1)
		{
			userSession.setAttribute ("client_error_last_name", "");
			inputFailed = true;
		}
		else
		{
			client.setLastName (lastName);
		}
		String phoneNumber = request.getParameter ("phone_number").trim ();
		if (phoneNumber == null || phoneNumber.length () != 10)
		{
			userSession.setAttribute ("client_error_phone_number", "");
			inputFailed = true;
		}
		else
		{
			if (CoreTools.containsOnlyNumbers (phoneNumber))
			{
				client.setPhoneNumber (phoneNumber);
			}
			else
			{
				userSession.setAttribute ("client_error_phone_number", "");
				inputFailed = true;
			}
		}

		String address1 = request.getParameter ("address1");
		address.setAddress1 (address1);

		String address2 = request.getParameter ("address2");
		address.setAddress2 (address2);

		String city = request.getParameter ("city");
		address.setCity (city);

		String province = request.getParameter ("province");
		address.setProvince (province);

		String country = request.getParameter ("country");
		address.setCountry (country);

		String postalCode = request.getParameter ("postal_code");
		address.setPostalCode (postalCode);

		String email = request.getParameter ("email");
		address.setEmail (email);

		String used = request.getParameter ("enabled");
		client.setEnabled (Boolean.parseBoolean (used));

		if (inputFailed)
		{
			userSession.setAttribute ("client_error", "You have provided invalid input! Review the fields in red.");

			if (serialized_client == null)
			{
				userSession.setAttribute ("client_new_first_name", firstName);
				userSession.setAttribute ("client_new_last_name", lastName);
				userSession.setAttribute ("client_new_phone_number", phoneNumber);
				userSession.setAttribute ("client_new_address1", address1);
				userSession.setAttribute ("client_new_address2", address2);
				userSession.setAttribute ("client_new_city", city);
				userSession.setAttribute ("client_new_province", province);
				userSession.setAttribute ("client_new_country", country);
				userSession.setAttribute ("client_new_postal_code", postalCode);
				userSession.setAttribute ("client_new_email", email);
				userSession.setAttribute ("client_new_enabled", used);

				redirect ("create-client.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("temp_client", client);

				redirect ("client?client_action=Load&client_no=" + client.getClientNo (), request, response);
			}

			return;
		}

		if (SessionController.saveClient (userSession, client))
		{
			LogController.write (this, "[USER REQUEST] Performing save: "+client.getClientNo ());
			
			userSession.setAttribute ("client_feedback", "Client was saved successfully.");

			// We are doing a final save here, lets make sure we have no temp data left.
			userSession.removeAttribute ("temp_client");

			redirect ("client?client_action=Load&client_no=" + client.getClientNo (), request, response);
		}
		else
		{
			if (serialized_client == null)
			{
				userSession.setAttribute ("client_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("client_new_first_name", firstName);
				userSession.setAttribute ("client_new_last_name", lastName);
				userSession.setAttribute ("client_new_phone_number", phoneNumber);
				userSession.setAttribute ("client_new_address1", address1);
				userSession.setAttribute ("client_new_address2", address2);
				userSession.setAttribute ("client_new_city", city);
				userSession.setAttribute ("client_new_province", province);
				userSession.setAttribute ("client_new_country", country);
				userSession.setAttribute ("client_new_postal_code", postalCode);
				userSession.setAttribute ("client_new_email", email);
				userSession.setAttribute ("client_new_enabled", used);

				redirect ("create-client.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("client_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("temp_client", client);

				redirect ("client?client_action=Load&client_no=" + client.getClientNo (), request, response);
			}
		}
	}

	public void performNewClient (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing new client.");
		
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (userSession, salon);

		if (salon != null)
		{
			userSession.setAttribute ("client_new_city", salon.getCity ());
			userSession.setAttribute ("client_new_province", salon.getProvince ());
			userSession.setAttribute ("client_new_country", salon.getCountry ());
		}

		forward ("create-client.jsp", request, response);
	}
}
