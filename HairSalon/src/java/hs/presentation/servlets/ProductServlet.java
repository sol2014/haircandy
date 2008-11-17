/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Miyoung Han
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.presentation.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.objects.*;
import hs.app.*;
import hs.presentation.*;
import java.util.ArrayList;
import java.util.Hashtable;

/**
 * Product presentation servlet that deals with searching, maintaining and
 * creating product record requests from the user.
 * 
 * @author Miyoung Han
 */
public class ProductServlet extends DispatcherServlet
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
		setActionAttribute ("product_action");
		
		// Ajax actions
		addExternalAction ("ProductSearch", "performProductSearch");
		addExternalAction ("SupplierProductRefill", "performSupplierProductRefill");
		addExternalAction ("ServiceProductRefill", "performServiceProductRefill");
		addExternalAction ("SaleProductRefill", "performSaleProductRefill");
		addExternalAction ("AppointmentProductRefill", "performAppointmentProductRefill");
		
		// User actions
		addExternalAction ("Search", "performSearch");
		addExternalAction ("New Product", "performNewProduct");
		addExternalAction ("Load", "performLoad");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Finish", "performSave");
		addExternalAction ("Revert", "performRevert");
	}

	public void performAppointmentProductRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing appointment product refill.");
		
		Hashtable<ProductBean, Integer> searchResults = new Hashtable<ProductBean, Integer> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		String[] quantitys = request.getParameterValues ("quantity");
		
		if (names != null && quantitys != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ProductBean pb = new ProductBean ();
				pb.setProductNo (Integer.parseInt (ids[i]));
				pb = SessionController.loadProduct (userSession, pb);
				searchResults.put (pb, Integer.parseInt (quantitys[i]));
			}
		}
		
		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-appointmentproduct-delete.jsp", request, response);
	}

	public void performSaleProductRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing sale product refill.");
		
		Hashtable<ProductBean, Integer> searchResults = new Hashtable<ProductBean, Integer> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		String[] quantitys = request.getParameterValues ("quantity");
		
		if (names != null && quantitys != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ProductBean pb = new ProductBean ();
				pb.setProductNo (Integer.parseInt (ids[i]));
				pb = SessionController.loadProduct (userSession, pb);
				searchResults.put (pb, Integer.parseInt (quantitys[i]));
			}
		}
		
		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-saleproduct-delete.jsp", request, response);
	}

	public void performServiceProductRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing service product refill.");
		
		Hashtable<ProductBean, Integer> searchResults = new Hashtable<ProductBean, Integer> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		String[] quantitys = request.getParameterValues ("quantity");
		
		if (names != null && quantitys != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ProductBean pb = new ProductBean ();
				pb.setProductNo (Integer.parseInt (ids[i]));
				pb = SessionController.loadProduct (userSession, pb);
				searchResults.put (pb, Integer.parseInt (quantitys[i]));
			}
		}
		
		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-serviceproduct-delete.jsp", request, response);
	}

	public void performSupplierProductRefill (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing supplier product refill.");
		
		ArrayList<ProductBean> searchResults = new ArrayList<ProductBean> ();
		String[] ids = request.getParameterValues ("id");
		String[] names = request.getParameterValues ("name");
		
		if (names != null && ids != null)
		{
			for (int i = 0; i < names.length; i++)
			{
				ProductBean pb = new ProductBean ();
				pb.setProductNo (Integer.parseInt (ids[i]));
				pb = SessionController.loadProduct (userSession, pb);
				searchResults.add (pb);
			}
		}
		
		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-supplierproduct-delete.jsp", request, response);
	}

	public void performProductSearch (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		LogController.write (this, "[USER REQUEST] Performing product search.");
		
		ProductBean product = new ProductBean ();
		
		String productName = request.getParameter ("product_name");
		if (!productName.equals (""))
		{
			product.setName (productName);
		}

		String brand = request.getParameter ("brand");
		if (!brand.equals (""))
		{
			product.setBrand (brand);
		}

		String type = request.getParameter ("product_type");
		if (!type.equals ("") && !type.equals ("None"))
		{
			product.setType (type);
		}

		product.setEnabled (true);
		
		ProductBean[] searchResults = SessionController.searchProducts (userSession, product);
		request.setAttribute ("searchResults", searchResults);
		forward ("ajax/ajax-product-add.jsp", request, response);
	}

	/**
	 * Used to search for product records and then show the results to the
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
		
		ProductBean product = new ProductBean ();

		String productName = request.getParameter ("product_name");
		if (!productName.equals (""))
		{
			product.setName (productName);
		}

		String brand = request.getParameter ("brand");
		if (!brand.equals (""))
		{
			product.setBrand (brand);
		}

		String type = request.getParameter ("type");
		if (!type.equals ("") && !type.equals ("None"))
		{
			product.setType (type);
		}

		String stock = request.getParameter ("stock");
		if (!stock.equals (""))
		{
			product.setStockQty (Integer.parseInt (stock));
		}

		String minimumLevel = request.getParameter ("minimum_level");
		if (!minimumLevel.equals (""))
		{
			product.setMinLevel (Integer.parseInt (minimumLevel));
		}

		String productQuantity = request.getParameter ("product_quantity");
		if (!productQuantity.equals (""))
		{
			product.setQtyPer (Integer.parseInt (productQuantity));
		}

		String price = request.getParameter ("price");
		if (!price.equals (""))
		{
			product.setPrice (Double.parseDouble (price));
		}

		String unit = request.getParameter ("unit");
		if (!unit.equals ("") && !unit.equals ("None"))
		{
			product.setUnit (unit);
		}

		String used = request.getParameter ("enabled");
		if (!used.equals ("") && !used.equals ("None"))
		{
			product.setEnabled (Boolean.parseBoolean (used));
		}

		ProductBean[] searchResults = SessionController.searchProducts (userSession, product);

		userSession.setAttribute ("product_search_result", searchResults);

		// We also need to keep track of all the search parameters we used, to show back on page.
		userSession.setAttribute ("product_search_product_name", productName);
		userSession.setAttribute ("product_search_brand", brand);
		userSession.setAttribute ("product_search_type", type);
		userSession.setAttribute ("product_search_stock", stock);
		userSession.setAttribute ("product_search_minimum_level", minimumLevel);
		userSession.setAttribute ("product_search_product_quantity", productQuantity);
		userSession.setAttribute ("product_search_price", price);
		userSession.setAttribute ("product_search_unit", unit);
		userSession.setAttribute ("product_search_enabled", used);

		redirect ("search-products.jsp", request, response);
	}
	
	public void performRevert (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		String serialized_product = (String) request.getParameter ("temp_product");
		ProductBean product = null;

		if (serialized_product == null)
		{
			LogController.write (this, "Revert can only work when using the temporary bean system.");
			
			userSession.setAttribute ("product_error", "Unable to revert client, temporary data lost!");

			forward ("/search-product.jsp", request, response);
			
			return;
		}
		else
		{
			product = (ProductBean) CoreTools.deserializeBase64 (serialized_product);
		}
		
		product = SessionController.loadProduct (userSession, product);

		if (product != null)
		{
			LogController.write (this, "[USER REQUEST] Performing revert: "+product.getProductNo());
			
			userSession.setAttribute ("product_load_result", product);
			userSession.setAttribute ("product_feedback", "Product was reverted successfully.");
			
			forward ("/maintain-product.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("product_error", "Unable to revert product from the database!");

			forward ("/search-product.jsp", request, response);
		}
	}
	
	public void performNewProduct (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		redirect ("create-product.jsp", request, response);
	}

	/**
	 * Loads the product record from the database and show the information
	 * in a product maintenance page.
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
		String product_no = (String) request.getParameter ("product_no");
		ProductBean product = new ProductBean ();

		try
		{
			product.setProductNo (Integer.parseInt (product_no));
		}
		catch (Exception ex)
		{
			LogController.write (this, "Invalid product number requested externally: " + product_no);
			// Maybe we should do something to show an error on the page?
			return;
		}

		product = SessionController.loadProduct (userSession, product);

		if (product != null)
		{
			LogController.write (this, "[USER REQUEST] Performing load: "+product.getProductNo());
			
			userSession.setAttribute ("product_load_result", product);

			forward ("/maintain-product.jsp", request, response);
		}
		else
		{
			userSession.setAttribute ("product_error", "Unable to load from database! Contact system administrator.");

			forward ("/search-products.jsp", request, response);
		}
	}

	/**
	 * Saves the product details into the database.
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
		// We want to grab the temporary bean data
		String serialized_product = (String) request.getParameter ("temp_product");
		ProductBean product = null;

		if (serialized_product == null)
		{
			product = new ProductBean ();
		}
		else
		{
			product = (ProductBean) CoreTools.deserializeBase64 (serialized_product);
		}
		
		boolean inputFailed = false;
		
		String productName = request.getParameter ("product_name").trim ();
		if (productName == null || productName.length () < 1)
		{
			userSession.setAttribute ("product_error_product_name", "");
			inputFailed = true;
		}
		else product.setName (productName);
		
		String brand = request.getParameter ("brand").trim ();
		if (brand == null || brand.length () < 1)
		{
			userSession.setAttribute ("product_error_brand", "");
			inputFailed = true;
		}
		else product.setBrand (brand);
		
		String type = request.getParameter ("type");
		product.setType (type);
		
		String stock = request.getParameter ("stock");
		try
		{
			product.setStockQty (Integer.parseInt (stock));
		}
		catch(Exception e)
		{
			userSession.setAttribute ("product_error_stock", "");
			inputFailed = true;
		}
		
		String minimumLevel = request.getParameter ("minimum_level");
		try
		{
			product.setMinLevel (Integer.parseInt (minimumLevel));
			LogController.write ("SETTING MIN LEVEL: "+minimumLevel);
		}
		catch(Exception e)
		{
			userSession.setAttribute ("product_error_minimum_level", "");
			inputFailed = true;
		}
		
		String productQuantity = request.getParameter ("product_quantity");
		try
		{
			product.setQtyPer (Integer.parseInt (productQuantity));
		}
		catch(Exception e)
		{
			userSession.setAttribute ("product_error_product_quantity", "");
			inputFailed = true;
		}
		
		String price = request.getParameter ("price");
		try
		{
			product.setPrice (Double.parseDouble (price));
		}
		catch(Exception e)
		{
			userSession.setAttribute ("product_error_price", "");
			inputFailed = true;
		}
		
		String unit = request.getParameter ("unit");
		product.setUnit (unit);
		
		String used = request.getParameter ("enabled");
		product.setEnabled (Boolean.parseBoolean (used));
		
		if (inputFailed)
		{
			userSession.setAttribute ("product_error", "You have provided invalid input! Review the fields in red.");
			
			if (serialized_product == null)
			{
				userSession.setAttribute ("product_new_product_name", productName);
				userSession.setAttribute ("product_new_brand", brand);
				userSession.setAttribute ("product_new_type", type);
				userSession.setAttribute ("product_new_stock", stock);
				userSession.setAttribute ("product_new_minimum_level", minimumLevel);
				userSession.setAttribute ("product_new_product_quantity", productQuantity);
				userSession.setAttribute ("product_new_price", price);
				userSession.setAttribute ("product_new_unit", unit);
				userSession.setAttribute ("product_new_enabled", used);
				
				redirect ("create-product.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("temp_product", product);

				redirect ("product?product_action=Load&product_no=" + product.getProductNo (), request, response);
			}
			
			return;
		}
		
		// Save the delays and then reload the results back to the maintain page.
		if (SessionController.saveProduct (userSession, product))
		{
			LogController.write (this, "[USER REQUEST] Performing save: "+product.getProductNo());
			
			userSession.setAttribute ("product_feedback", "Product was saved successfully.");
			
			// We are doing a final save here, lets make sure we have no temp data left.
			userSession.removeAttribute ("temp_product");
			
			redirect ("product?product_action=Load&product_no=" + product.getProductNo (), request, response);
		}
		else
		{
			if (serialized_product == null)
			{
				userSession.setAttribute ("product_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("product_new_product_name", productName);
				userSession.setAttribute ("product_new_brand", brand);
				userSession.setAttribute ("product_new_type", type);
				userSession.setAttribute ("product_new_stock", stock);
				userSession.setAttribute ("product_new_minimum_level", minimumLevel);
				userSession.setAttribute ("product_new_product_quantity", productQuantity);
				userSession.setAttribute ("product_new_price", price);
				userSession.setAttribute ("product_new_unit", unit);
				userSession.setAttribute ("product_new_enabled", used);

				redirect ("create-product.jsp", request, response);
			}
			else
			{
				userSession.setAttribute ("product_error", "Unable to save record to database! Contact system administrator.");

				userSession.setAttribute ("temp_product", product);

				redirect ("product?product_action=Load&product_no=" + product.getProductNo (), request, response);
			}
		}
	}
}
