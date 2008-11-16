/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package hs.presentation.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.objects.*;
import hs.app.*;
import hs.presentation.*;
import java.util.Hashtable;

/**
 *
 * @author Nuha Bazara
 */
public class SaleServlet extends DispatcherServlet
{
    public void setupActionMethods () throws NoSuchMethodException
    {
        setActionAttribute ("sale_action");
        addExternalAction ("Search", "performSearch");
        addExternalAction ("Load", "performLoad");
		addExternalAction ("Save", "performSave");
        addExternalAction ("Finish", "performSave");
		addExternalAction ("Revert", "performRevert");
        addExternalAction ("New Sale", "performNewSale");
    }

    public void performSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
		LogController.write (this, "[USER REQUEST] Performing search.");
		
        SaleBean sale = new SaleBean ();
        EmployeeBean employee = new EmployeeBean ();
        ClientBean client = new ClientBean ();

        sale.setClient (client);
        sale.setEmployee (employee);
		
        String paymentType = request.getParameter ("search_payment_type");
		if (paymentType == null) paymentType = "";
        if (!paymentType.equals ("") && !paymentType.equals("None"))
        {
            sale.setPaymentType (paymentType);
        }
		
        String totalDue = request.getParameter ("search_total_due");
		if (totalDue == null) totalDue = "";
        if (!totalDue.equals (""))
        {
            sale.setTotalDue (Double.parseDouble (totalDue));
        }
		
        String isComplete = request.getParameter ("search_is_complete");
		if (isComplete == null) isComplete = "";
        if (!isComplete.equals ("None"))
        {
            sale.setIsComplete (isComplete.toLowerCase ().equals ("true"));
        }
		
		String isVoid = request.getParameter ("search_is_void");
		if (isVoid == null) isVoid = "";
        if (!isVoid.equals ("None"))
        {
            sale.setIsVoid (isVoid.toLowerCase ().equals ("true"));
        }
		
		java.util.Date start = null;
		String start_date = request.getParameter ("search_start_date");
		if (start_date == null) start_date = "";
        if (!start_date.equals (""))
        {
			try
			{
				start = CoreTools.getDate (start_date);
			}
			catch (Exception e)
			{
				LogController.write (this, "Start date was invalid in request: "+start_date);
				return;
			}
        }
		
		java.util.Date end = null;
		String end_date = request.getParameter ("search_end_date");
		if (end_date == null) end_date = "";
        if (!end_date.equals (""))
        {
			try
			{
				end = CoreTools.getDate (end_date);
			}
			catch (Exception e)
			{
				LogController.write (this, "End date was invalid in request: "+end_date);
				return;
			}
        }
		
        SaleBean[] searchResults = SessionController.searchSalesRange (userSession, sale, start, end);
		
        userSession.setAttribute ("sale_search_result", searchResults);

        if (paymentType != null)
			userSession.setAttribute ("sale_search_payment_type", paymentType);
		
        if (totalDue != null)
			userSession.setAttribute ("sale_search_total_due", totalDue);
		
		if (isComplete != null)
			userSession.setAttribute ("sale_search_is_complete", isComplete);
		
		if (isVoid != null)
			userSession.setAttribute ("sale_search_is_void", isVoid);
		
		if (start_date != null)
			userSession.setAttribute ("sale_search_start_date", start_date);
		
		if (end_date != null)
			userSession.setAttribute ("sale_search_end_date", end_date);
		
        redirect ("search-sale.jsp", request, response);
    }
	
	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String serialized_sale = (String) request.getParameter ("temp_sale");
		SaleBean sale = null;

		if (serialized_sale == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");

			userSession.setAttribute ("sale_error", "Unable to revert sale, temporary data lost!");

			forward ("/create-sale.jsp", request, response);

			return;
		}
		else
		{
			sale = (SaleBean) CoreTools.deserializeBase64 (serialized_sale);
		}

		sale = SessionController.loadSale (userSession, sale);

		if (sale != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+sale.getTransactionNo ());
			
			userSession.setAttribute ("sale_load_result", sale);
			userSession.setAttribute ("employee_feedback", "Employee was reverted successfully.");

			forward ("/maintain-employee.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("employee_error", "Unable to revert employee from the database!");

			forward ("/search-employee.jsp", request, response);
		}
	}
	
    public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
        String transaction_no = (String) request.getParameter ("transaction_no");
        SaleBean sale = new SaleBean ();

		LogController.write (this, "[USER REQUEST] Performing load: "+transaction_no);
		
        try
        {
            sale.setTransactionNo (Integer.parseInt (transaction_no));
        }
        catch (Exception ex)
        {
            LogController.write (this, "Invalid sale number requested externally: " + transaction_no);
            // Maybe we should do something to show an error on the page?
            return;
        }

        sale = SessionController.loadSale (userSession, sale);

        if (sale != null)
        {
            userSession.setAttribute ("sale_load_result", sale);
			
            forward ("/maintain-sale.jsp", request, response);
        }
        else
        {
            userSession.setAttribute ("sale_load_error", ErrorCodes.LoadError);

            //forward ("/search-sale.jsp", request, response);
            forward ("/create-sale.jsp", request, response);

        }
    }

    public void performNewSale (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
		LogController.write (this, "[USER REQUEST] Performing new sale.");
		
        userSession.setAttribute ("sale_new_total_due", "0.00");
		userSession.setAttribute ("sale_new_total_tax", "0.00");
		userSession.setAttribute ("sale_new_discount", "0");
        userSession.setAttribute ("sale_new_payment", "0.00");
        userSession.setAttribute ("sale_new_employee_no", userSession.getEmployee ().getEmployeeNo ());

        forward ("create-sale.jsp", request, response);
    }

    public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
        String serialized_sale = (String) request.getParameter ("temp_sale");
		String serialized_new_sale = (String) request.getParameter ("temp_new_sale");
		
        SaleBean sale = null;
        ClientBean client = null;
        EmployeeBean employee = null;

        if (serialized_sale == null)
        {
			if (serialized_new_sale == null)
			{
				sale = new SaleBean ();
				client = new ClientBean ();
				client.setAddress (new AddressBean ());
				employee = new EmployeeBean ();
				sale.setClient (client);
				sale.setEmployee (employee);
			}
			else
			{
				sale = (SaleBean) CoreTools.deserializeBase64 (serialized_new_sale);
				client = sale.getClient ();
				employee = sale.getEmployee ();
			}
        }
        else
        {
            sale = (SaleBean) CoreTools.deserializeBase64 (serialized_sale);
            client = sale.getClient ();
            employee = sale.getEmployee ();
        }

        String[] products = request.getParameterValues ("products");
        Hashtable<ProductBean, Integer> hash = sale.getProductSold ();

        String[] services = request.getParameterValues ("services");
        Hashtable<ServiceBean, Integer> hash1 = sale.getServiceSold ();

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
                    int amount = Integer.parseInt (productinfo[1]);
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
                }
            }
        }

        sale.setProductSold (hash);
        hash1.clear ();

        if (services != null)
        {
            for (String service : services)
            {
                try
                {
                    ServiceBean sb = new ServiceBean ();
                    String[] serviceinfo = service.split (":");

                    sb.setServiceNo (Integer.parseInt (serviceinfo[0]));
                    int amount = Integer.parseInt (serviceinfo[1]);
                    sb = (ServiceBean) SessionController.loadService (userSession, sb);

                    while (hash1.contains (sb))
                    {
                        hash1.remove (sb);
                    }

                    hash1.remove (sb);
                    hash1.put (sb, amount);
                }
                catch (Exception e)
                {
                }
            }
        }

        sale.setServiceSold (hash1);

        boolean inputFailed = false;

        String firstName = request.getParameter ("first_name").trim ();
        if (firstName == null || firstName.length () < 1)
        {
            userSession.setAttribute ("sale_error_first_name", "");
            inputFailed = true;
        }
        else
        {
            client.setFirstName (firstName);
        }
        String lastName = request.getParameter ("last_name").trim ();
        if (lastName == null || lastName.length () < 1)
        {
            userSession.setAttribute ("sale_error_last_name", "");
            inputFailed = true;
        }
        else
        {
            client.setLastName (lastName);
        }
        
		String phoneNumber = request.getParameter ("phone_number").trim ();
        if (phoneNumber == null || phoneNumber.length () != 10)
        {
            userSession.setAttribute ("sale_error_phone_number", "");
            inputFailed = true;
        }
        else
        {
			if (CoreTools.containsOnlyNumbers(phoneNumber))
			{
				client.setPhoneNumber (phoneNumber);
			}
			else
			{
				userSession.setAttribute ("sale_error_phone_number", "");
				inputFailed = true;
			}
        }
		
        String employeeId = request.getParameter ("employee_no");
        try
        {
            employee.setEmployeeNo (Integer.parseInt (employeeId));
        }
        catch (Exception e)
        {
            userSession.setAttribute ("sale_error_employee_no", "");
            inputFailed = true;
        }

        String paymentType = request.getParameter ("payment_type");
        sale.setPaymentType (paymentType);

        String payment = request.getParameter ("payment");
        try
        {
            sale.setPayment (Double.parseDouble (payment));
        }
        catch (Exception e)
        {
            userSession.setAttribute ("sale_error_payment", "");
            inputFailed = true;
        }

        String totalDue = request.getParameter ("total_due");
        try
        {
            sale.setTotalDue (Double.parseDouble (totalDue));
        }
        catch (Exception e)
        {
            userSession.setAttribute ("sale_error_total_due", "");
            inputFailed = true;
        }
		
		String totalTax = request.getParameter ("total_tax");
        try
        {
            sale.setTotalTax (Double.parseDouble (totalTax));
        }
        catch (Exception e)
        {
            userSession.setAttribute ("sale_error_total_tax", "");
            inputFailed = true;
        }
		
		String discount = request.getParameter ("discount");
        try
        {
            sale.setDiscount (Integer.parseInt (discount));
        }
        catch (Exception e)
        {
            userSession.setAttribute ("sale_error_discount", "");
            inputFailed = true;
        }
		
        String isComplete = request.getParameter ("is_complete");
		try
		{
			sale.setIsComplete (Boolean.parseBoolean (isComplete));
		}
		catch (Exception e)
		{
			sale.setIsComplete (false);
		}
		
		String isVoid = request.getParameter ("is_void");
		try
		{
			sale.setIsVoid (Boolean.parseBoolean (isVoid));
		}
		catch (Exception e)
		{
			sale.setIsVoid (false);
		}
		
		boolean failed = false;
		
		// Now check some basics for the sale, did we get enough payment?
		if (sale.getPayment () < sale.getTotalDue ())
		{
			userSession.setAttribute ("sale_error", "You must provide enough payment to cover the total ammount due!");
			userSession.setAttribute ("sale_error_payment", "");
			
			failed = true;
		}
		else if (inputFailed)
        {
            userSession.setAttribute ("sale_error", "You have provided invalid input! Review the fields in red.");
			
			failed = true;
        }
		
		if (failed)
		{
			if (serialized_sale == null)
            {
				userSession.setAttribute ("temp_new_sale", sale);
				
                userSession.setAttribute ("sale_new_first_name", firstName);
                userSession.setAttribute ("sale_new_last_name", lastName);
                userSession.setAttribute ("sale_new_phone_number", phoneNumber);
                userSession.setAttribute ("sale_new_employee_no", employeeId);
                userSession.setAttribute ("sale_new_payment_type", paymentType);
                userSession.setAttribute ("sale_new_total_due", totalDue);
				userSession.setAttribute ("sale_new_total_tax", totalTax);
				userSession.setAttribute ("sale_new_discount", discount);
                userSession.setAttribute ("sale_new_payment", payment);
                userSession.setAttribute ("sale_new_is_complete", isComplete);
				userSession.setAttribute ("sale_new_is_void", isVoid);

                redirect ("create-sale.jsp", request, response);
            }
            else
            {
				userSession.setAttribute ("temp_sale", sale);
				
                redirect ("sale?sale_action=Load&transaction_no=" + sale.getTransactionNo (), request, response);
            }
			
			return;
		}
		
        if (SessionController.loadEmployee (userSession, employee) == null)
        {
            userSession.setAttribute ("sale_error", "The employee ID used is invalid! Review the fields in red.");
            userSession.setAttribute ("sale_error_employee_no", "");
			
            if (serialized_sale == null)
            {
				userSession.setAttribute ("temp_new_sale", sale);
				
                userSession.setAttribute ("sale_new_first_name", firstName);
                userSession.setAttribute ("sale_new_last_name", lastName);
                userSession.setAttribute ("sale_new_phone_number", phoneNumber);
                userSession.setAttribute ("sale_new_employee_no", employeeId);
                userSession.setAttribute ("sale_new_payment_type", paymentType);
                userSession.setAttribute ("sale_new_total_due", totalDue);
				userSession.setAttribute ("sale_new_total_tax", totalTax);
				userSession.setAttribute ("sale_new_discount", discount);
                userSession.setAttribute ("sale_new_payment", payment);
                userSession.setAttribute ("sale_new_is_complete", isComplete);
				userSession.setAttribute ("sale_new_is_void", isVoid);
				
                redirect ("create-sale.jsp", request, response);
            }
            else
            {
				userSession.setAttribute ("temp_sale", sale);
				
                redirect ("sale?sale_action=Load&transaction_no=" + sale.getTransactionNo (), request, response);
            }

            return;
        }

        if (SessionController.saveSale (userSession, sale))
        {
			LogController.write (this, "[USER REQUEST] Performing save: "+sale.getTransactionNo());
			
            userSession.setAttribute ("sale_feedback", "Sale was saved successfully.");

            userSession.removeAttribute ("temp_sale");

            redirect ("sale?sale_action=Load&transaction_no=" + sale.getTransactionNo (), request, response);
        }
        else
        {
            if (serialized_sale == null)
            {
                userSession.setAttribute ("sale_error", "Unable to save record to database! Contact system administrator.");
				
				userSession.setAttribute ("temp_ew_sale", sale);
				
                userSession.setAttribute ("sale_new_first_name", firstName);
                userSession.setAttribute ("sale_new_last_name", lastName);
                userSession.setAttribute ("sale_new_phone_number", phoneNumber);
                userSession.setAttribute ("sale_new_employee_no", employeeId);
                userSession.setAttribute ("sale_new_payment_type", paymentType);
                userSession.setAttribute ("sale_new_total_due", totalDue);
				userSession.setAttribute ("sale_new_total_tax", totalTax);
				userSession.setAttribute ("sale_new_discount", discount);
                userSession.setAttribute ("sale_new_payment", payment);
                userSession.setAttribute ("sale_new_is_complete", isComplete);
				userSession.setAttribute ("sale_new_is_void", isVoid);
				
                redirect ("create-sale.jsp", request, response);
            }
            else
            {
				userSession.setAttribute ("temp_sale", sale);
				
                userSession.setAttribute ("sale_error", "Unable to save record to database! Contact system administrator.");
				
                redirect ("sale?sale_action=Load&transaction_no=" + sale.getTransactionNo (), request, response);
            }
        }
    }
}
