/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.presentation.servlets;

import hs.presentation.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.objects.*;
import hs.app.*;
import java.util.ArrayList;

/**
 * The supplier servlet will handle all http requests that will deal with
 * manipulation and lookup of supplier information in the system.
 * 
 * @author Joey Ren
 */
public class SupplierServlet extends DispatcherServlet
{
	/**
	 * Sets up defaults for action handling used by this servlet. See the
	 * DispatcherServlet for more details.
	 * 
	 * @throws java.lang.NoSuchMethodException
	 */
	@Override
	public void setupActionMethods ()
			throws NoSuchMethodException
	{
		setActionAttribute ("supplier_action");
		addExternalAction ("Search", "performSearch");
		addExternalAction ("Load", "performLoad");
		addExternalAction ("Revert", "performRevert");
		addExternalAction ("Save", "performSave");
		addExternalAction ("New Supplier", "performCreate");
		addExternalAction ("Finish", "performSave");
	}
	
	/**
	 * This action will allow the user to create a new supplier by sending
	 * them to the supplier creation page with some default values.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performCreate (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing new supplier.");
		
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (userSession, salon);
		
		if (salon != null)
		{
			userSession.setAttribute ("supplier_new_city", salon.getCity ());
			userSession.setAttribute ("supplier_new_province", salon.getProvince ());
			userSession.setAttribute ("supplier_new_country", salon.getCountry ());
		}
		
		redirect ("create-supplier.jsp", request, response);
	}
	
	/**
	 * This action allows the user to revert a supplier maintain page back
	 * to default values by reloading the information from the system.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		String serialized_supplier = (String) request.getParameter ("temp_supplier");
		SupplierBean supplier = null;

		if (serialized_supplier == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");
			
			userSession.setAttribute ("supplier_error", "Unable to revert supplier, temporary data lost!");

			forward ("/search-supplier.jsp", request, response);
			
			return;
		}
		else
		{
			supplier = (SupplierBean) CoreTools.deserializeBase64 (serialized_supplier);
		}
		
		supplier = SessionController.loadSupplier (userSession, supplier);

		if (supplier != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+supplier.getSupplierNo());
			
			userSession.setAttribute ("supplier_load_result", supplier);
			userSession.setAttribute ("supplier_feedback", "Supplier was reverted successfully.");
			
			forward ("/maintain-supplier.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("supplier_error", "Unable to revert supplier from the database!");

			forward ("/search-supplier.jsp", request, response);
		}
	}
	
	/**
	 * This action allows the user to load the supplier information and 
	 * display it to the page.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String supplierNo = request.getParameter ("supplier_no");
		SupplierBean supplier = new SupplierBean ();
		
		try
		{
			supplier.setSupplierNo (Integer.parseInt (supplierNo));
		}
		catch (Exception e)
		{
			LogController.write (this, "Invalid supplier number requested externally: " + supplierNo);
			return;
		}

		supplier = (SupplierBean) SessionController.loadSupplier (userSession, supplier);

		if (supplier != null)
		{
			LogController.write (this, "[USER REQUEST] Performing load: "+supplier.getSupplierNo());
			
			userSession.setAttribute ("supplier_load_result", supplier);

			forward ("/maintain-supplier.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("supplier_error", "There was a problem loading the supplier from the database! Contact your system administrator.");

			forward ("/search-suppliers.jsp", request, response);
		}
	}

	/**
	 * This action allows a user to save new or existing supplier information
	 * into the system. Any invalid information is sent back to the page to 
	 * notify the user of errors.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String serialized_supplier = (String) request.getParameter ("temp_supplier");
		SupplierBean supplier = null;
		AddressBean address = null;
		
		if (serialized_supplier == null)
		{
			supplier = new SupplierBean ();
			address = new AddressBean ();
			supplier.setAddress (address);
		}
		else
		{
			supplier = (SupplierBean) CoreTools.deserializeBase64 (serialized_supplier);
			address = supplier.getAddress ();
			
			String[] products = request.getParameterValues ("products");
			ArrayList<ProductBean> productBeans = new ArrayList<ProductBean> ();

			if (products != null)
			{
				for (String product : products)
				{
					try
					{
						ProductBean pb = new ProductBean ();
						pb.setProductNo (Integer.parseInt (product));
						pb = (ProductBean) SessionController.loadProduct (userSession, pb);
						productBeans.add (pb);
					}
					catch (Exception e)
					{
					}
				}
			}
			
			supplier.setProducts (productBeans);
		}
		
		boolean inputFailed = false;
		
		String address1 = request.getParameter ("address1").trim ();
		if (address1 == null || address1.length () < 1)
		{
			userSession.setAttribute ("supplier_error_address1", "");
			inputFailed = true;
		}
		else address.setAddress1 (address1);
		
		String address2 = request.getParameter ("address2").trim ();
		address.setAddress2 (address2);
		
		String city = request.getParameter ("city").trim ();
		if (city == null || city.length () < 1)
		{
			userSession.setAttribute ("supplier_error_city", "");
			inputFailed = true;
		}
		else address.setCity (city);
		
		String province = request.getParameter ("province").trim ();
		if (province == null || province.length () < 1)
		{
			userSession.setAttribute ("supplier_error_province", "");
			inputFailed = true;
		}
		else address.setProvince (province);
		
		String country = request.getParameter ("country").trim ();
		if (country == null || country.length () < 1)
		{
			userSession.setAttribute ("supplier_error_country", "");
			inputFailed = true;
		}
		else address.setCountry (country);
		
		String postal_code = request.getParameter ("postal_code").trim ();
		if (postal_code == null || postal_code.length () < 1)
		{
			userSession.setAttribute ("supplier_error_postal_code", "");
			inputFailed = true;
		}
		else address.setPostalCode (postal_code);
		
		String email = request.getParameter ("email").trim ();
		if (email == null || email.length () < 1)
		{
			userSession.setAttribute ("supplier_error_email", "");
			inputFailed = true;
		}
		else address.setEmail (email);
		
		supplier.setAddress (address);
		
		String name = request.getParameter ("name").trim ();
		if (name == null || name.length () < 1)
		{
			userSession.setAttribute ("supplier_error_name", "");
			inputFailed = true;
		}
		else supplier.setName (name);
		
		String description = request.getParameter ("description").trim ();
		if (description == null || description.length () < 1)
		{
			userSession.setAttribute ("supplier_error_description", "");
			inputFailed = true;
		}
		else supplier.setDescription (description);
		
		String phoneNumber = request.getParameter ("phone_number").trim ();
        if (phoneNumber == null || phoneNumber.length () != 10)
        {
            userSession.setAttribute ("supplier_error_phone_number", "");
            inputFailed = true;
        }
        else
        {
			if (CoreTools.containsOnlyNumbers(phoneNumber))
			{
				supplier.setPhoneNumber (phoneNumber);
			}
			else
			{
				userSession.setAttribute ("supplier_error_phone_number", "");
				inputFailed = true;
			}
        }
		
		String used = request.getParameter ("enabled").trim ();
		supplier.setEnabled (Boolean.parseBoolean (used));
		
		if (inputFailed)
		{
			userSession.setAttribute ("supplier_error", "You have provided invalid input! Review the fields in red.");
			
			if (serialized_supplier == null)
			{
				userSession.setAttribute ("supplier_new_name", name);
				userSession.setAttribute ("supplier_new_description", description);
				userSession.setAttribute ("supplier_new_phone_number", description);
				userSession.setAttribute("supplier_new_address1", address1);
                userSession.setAttribute("supplier_new_address2", address2);
                userSession.setAttribute("supplier_new_city", city);
                userSession.setAttribute("supplier_new_province", province);
                userSession.setAttribute("supplier_new_country", country);
                userSession.setAttribute("supplier_new_postal_code", postal_code);
                userSession.setAttribute("supplier_new_email", email);
				userSession.setAttribute("supplier_new_enabled", used);
				
				redirect ("create-supplier.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("temp_supplier", supplier);

				redirect ("supplier?supplier_action=Load&supplier_no=" + supplier.getSupplierNo (), request, response);
			}
			
			return;
		}
		
		// Save the delays and then reload the results back to the maintain page.
		if (SessionController.saveSupplier (userSession, supplier))
		{
			LogController.write (this, "[USER REQUEST] Performing save: "+supplier.getSupplierNo());
			
			userSession.setAttribute ("supplier_feedback", "Supplier was saved successfully.");

			userSession.removeAttribute ("temp_supplier");

			redirect ("supplier?supplier_action=Load&supplier_no=" + supplier.getSupplierNo (), request, response);
		}
		else
		{
			if (serialized_supplier == null)
			{
				userSession.setAttribute ("supplier_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("supplier_new_name", name);
				userSession.setAttribute ("supplier_new_description", description);
				userSession.setAttribute ("supplier_new_phone_number", description);
				userSession.setAttribute("supplier_new_address1", address1);
                userSession.setAttribute("supplier_new_address2", address2);
                userSession.setAttribute("supplier_new_city", city);
                userSession.setAttribute("supplier_new_province", province);
                userSession.setAttribute("supplier_new_country", country);
                userSession.setAttribute("supplier_new_postal_code", postal_code);
                userSession.setAttribute("supplier_new_email", email);
				userSession.setAttribute("supplier_new_enabled", used);
				
				redirect ("create-supplier.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("supplier_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("temp_supplier", supplier);

				redirect ("supplier?supplier_action=Load&supplier_no=" + supplier.getSupplierNo (), request, response);
			}
		}
	}

	/**
	 * This action allows a user to search for supplier records and display
	 * them on the search page.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing search.");
		
		SupplierBean supplier = new SupplierBean ();
		AddressBean address = new AddressBean ();

		String name = request.getParameter ("name").trim ();
		if (!name.equals (""))
		{
			supplier.setName (name);
		}

		String description = request.getParameter ("description").trim ();
		if (!description.equals (""))
		{
			supplier.setDescription (description);
		}

		String phoneNumber = request.getParameter ("phone_number").trim ();
		if (!phoneNumber.equals (""))
		{
			supplier.setPhoneNumber (phoneNumber);
		}

		String address1 = request.getParameter ("address1").trim ();
		if (!address1.equals (""))
		{
			address.setAddress1 (address1);
		}

		String address2 = request.getParameter ("address2").trim ();
		if (!address2.equals (""))
		{
			address.setAddress2 (address2);
		}

		String city = request.getParameter ("city").trim ();
		if (!city.equals (""))
		{
			address.setCity (city);
		}

		String province = request.getParameter ("province").trim ();
		if (!province.equals (""))
		{
			address.setProvince (province);
		}

		String country = request.getParameter ("country").trim ();
		if (!country.equals (""))
		{
			address.setCountry (country);
		}

		String postalCode = request.getParameter ("postal_code").trim ();
		if (!postalCode.equals (""))
		{
			address.setPostalCode (postalCode);
		}

		String email = request.getParameter ("email").trim ();
		if (!email.equals (""))
		{
			address.setEmail (email);
		}

		supplier.setAddress (address);
		
		String used = request.getParameter ("enabled");
		if (!used.equals ("None"))
		{
			supplier.setEnabled (used.equals ("True"));
		}
		
		SupplierBean[] dbs = SessionController.searchSuppliers (userSession, supplier);

		userSession.setAttribute ("supplier_search_result", dbs);

		userSession.setAttribute ("supplier_search_name", name);
		userSession.setAttribute ("supplier_search_description", description);
		userSession.setAttribute ("supplier_search_phone_number", phoneNumber);
		userSession.setAttribute ("supplier_search_address1", address1);
		userSession.setAttribute ("supplier_search_address2", address2);
		userSession.setAttribute ("supplier_search_city", city);
		userSession.setAttribute ("supplier_search_province", province);
		userSession.setAttribute ("supplier_search_country", country);
		userSession.setAttribute ("supplier_search_postal_code", postalCode);
		userSession.setAttribute ("supplier_search_email", email);
		userSession.setAttribute ("supplier_search_enabled", used);
		
		redirect ("search-suppliers.jsp", request, response);
	}
}
