/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.persistence.brokers;

import java.sql.*;
import java.util.*;

import hs.core.*;
import hs.objects.*;
import hs.persistence.*;

/**
 * 
 * 
 * @author Nuha Bazara
 */
public class SaleBroker extends DatabaseBroker implements BrokerInterface
{
	private static SaleBroker instance = null;

	public static SaleBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new SaleBroker ();
		}

		return instance;
	}

	SaleBroker ()
	{
	}

	@Override
	public DataBean load (DataBean data)
	{
		SaleBean sale = (SaleBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call LoadSale(?)}");

			if (sale.getTransactionNo () != null)
			{
				proc.setInt (1, sale.getTransactionNo ());
			}
			else
			{
				LogController.write (this, "Sale bean has no identification number!");
				return null;
			}
			ResultSet result = proc.executeQuery ();
			if (result.next ())
			{
				sale = (SaleBean) getBean (result);
			}
			else
			{
				LogController.write (this, "There were no results for this load! sale not loaded.");
				return null;
			}

			// Now load the services.

			sale.setProductSold (new Hashtable<ProductBean, Integer> ());
			sale.setServiceSold (new Hashtable<ServiceBean, Integer> ());

			if (proc.getMoreResults ())
			{
				// Do we have another result set
				ResultSet serviceResults = proc.getResultSet ();

				while (serviceResults.next ())
				{
					ServiceBean service = new ServiceBean ();
					service.setServiceNo (serviceResults.getInt ("service_no"));
					int amount = serviceResults.getInt ("amount");
					sale.getServiceSold ().put (service, amount);
					LogController.write (this, "Loaded a service into sale: " + service.getServiceNo ());
				}
			}
			
			if (proc.getMoreResults ())
			{
				ResultSet productResult = proc.getResultSet ();

				while (productResult.next ())
				{
					ProductBean product = new ProductBean ();
					product.setProductNo (productResult.getInt ("product_no"));
					int amount = productResult.getInt ("amount");
					sale.getProductSold ().put (product, amount);
					LogController.write (this, "loaded a product into sale:" + product.getProductNo ());
				}
			}

			super.returnConnection (connection);

		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString());
			e.printStackTrace ();
			
			return null;
		}
		
		LogController.write (this, "Loaded sale bean: "+sale.getTransactionNo ());
		
		return sale;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		SaleBean sale = (SaleBean) data;
		ArrayList<SaleBean> saleAL = new ArrayList<SaleBean> ();
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call SearchSale(?,?,?,?,?,?,?,?)}");

			int index = 1;

			addToStatement (proc, sale.getClient (), index++, Object.class);
			addToStatement (proc, sale.getEmployee (), index++, Object.class);
			addToStatement (proc, sale.getPaymentType (), index++, String.class);
			addToStatement (proc, sale.getTotalDue (), index++, Double.class);
			addToStatement (proc, sale.getTotalTax (), index++, Double.class);
			addToStatement (proc, sale.getDiscount (), index++, Integer.class);
			addToStatement (proc, sale.getPayment (), index++, Double.class);
			addToStatement (proc, sale.getIsComplete (), index++, Boolean.class);


			ResultSet result = proc.executeQuery ();

			while (result.next ())
			{
				saleAL.add ((SaleBean) getBean (result));
			}

			super.returnConnection (connection);
		}
		catch (SQLException r)
		{
			LogController.write (this, "SQL Exception during search: " + r.getMessage ());
		}
		
		LogController.write (this, "Found sale beans: "+saleAL.size());
		
		SaleBean[] saleBean = new SaleBean[saleAL.size ()];
		return saleAL.toArray (saleBean);
	}

	@Override
	public boolean commit (DataBean data)
	{
		SaleBean sale = (SaleBean) data;
		boolean result = true;
		
		try
		{
			Connection connection = super.getConnection ();

			CallableStatement proc = null;
			int index = 1;

			if (sale.getTransactionNo () == null)
			{
				proc = connection.prepareCall ("{call CreateSale(?,?,?,?,?,?,?,?,?)}");
				
				proc.registerOutParameter ("p_key", java.sql.Types.BIGINT);
			}
			else
			{
				proc = connection.prepareCall ("{call UpdateSale(?,?,?,?,?,?,?,?,?)}");

				proc.setInt (index++, sale.getTransactionNo ());
			}
			
			addToStatement (proc, sale.getClient ().getClientNo (), index++, Integer.class);
			addToStatement (proc, sale.getEmployee ().getEmployeeNo (), index++, Integer.class);
			addToStatement (proc, sale.getPaymentType (), index++, String.class);
			addToStatement (proc, sale.getTotalDue (), index++, Double.class);
			addToStatement (proc, sale.getTotalTax (), index++, Double.class);
			addToStatement (proc, sale.getDiscount (), index++, Integer.class);
			addToStatement (proc, sale.getPayment (), index++, Double.class);
			addToStatement (proc, sale.getIsComplete (), index++, Boolean.class);
			
			int updated = proc.executeUpdate ();

			if (updated > 0)
			{
				result = true;

				if (sale.getTransactionNo () == null)
				{
					sale.setTransactionNo (proc.getInt ("p_key"));
				}
			}
			else
			{
				result = false;
			}

			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write ("SQL Exception:" + e.toString ());
			e.printStackTrace ();
			
			result = false;
		}


		if (result)
		{
			try
			{
				Connection connection = super.getConnection ();

				// Erase any existing products for this service.
				CallableStatement proc = connection.prepareCall ("{call DeleteSaleProducts(?)}");

				proc.setInt (1, sale.getTransactionNo ());
				int updated = proc.executeUpdate ();

				if (updated < 1)
				{
					LogController.write (this, "No products were removed during update.");
				}
				else
				{
					LogController.write (this, "Products were removed for update.");
				}
				proc.close ();

				if (sale.getProductSold () != null || sale.getProductSold ().size () > 0)
				{
					// Commit all the products for the linking tables.
					for (ProductBean product : sale.getProductSold ().keySet ())
					{
						proc = connection.prepareCall ("{call AddSaleProduct(?,?,?)}");
						proc.setInt (1, sale.getTransactionNo ());
						proc.setInt (2, product.getProductNo ());
						proc.setInt (3, sale.getProductSold ().get (product));

						updated = proc.executeUpdate ();

						if (updated > 0)
						{
							LogController.write (this, "Added product [" + product.getProductNo () + "] to sale record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add product [" + product.getProductNo () + "] to sale.");
							result = false;
						}

						proc.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no products to store for this sale.");
				}

				CallableStatement proc1 = connection.prepareCall ("{call DeleteSaleServices(?)}");

				proc1.setInt (1, sale.getTransactionNo ());
				int updated1 = proc1.executeUpdate ();

				if (updated1 < 1)
				{
					LogController.write (this, "No products were removed during update.");
				}
				else
				{
					LogController.write (this, "Products were removed for update.");
				}
				proc1.close ();

				if (sale.getServiceSold () != null || sale.getServiceSold ().size () > 0)
				{
					// Commit all the products for the linking tables.
					for (ServiceBean service : sale.getServiceSold ().keySet ())
					{
						proc1 = connection.prepareCall ("{call AddSaleService(?,?,?)}");
						proc1.setInt (1, sale.getTransactionNo ());
						proc1.setInt (2, service.getServiceNo ());
						proc1.setInt (3, sale.getServiceSold ().get (service));

						updated1 = proc1.executeUpdate ();


						if (updated1 > 0)
						{
							LogController.write (this, "Added service [" + service.getServiceNo () + "] to sale record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add product [" + service.getServiceNo () + "] to sale.");
							result = false;
						}

						proc1.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no services to store for this sale.");
				}

				super.returnConnection (connection);
			}
			catch (SQLException e2)
			{
				LogController.write (this, "There was an exception: " + e2.getMessage ());
				result = false;
			}
		}
		
		if (result)
			LogController.write (this, "Commit sale bean: "+sale.getTransactionNo ());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		SaleBean sale = (SaleBean) data;
		boolean result = false;
		
		if (sale.getTransactionNo () != null)
		{
			try
			{
				Connection connection = super.getConnection ();
				CallableStatement proc = connection.prepareCall ("{call DeleteSale(?)}");
				
				proc.setInt (1, sale.getTransactionNo ());
				
				int updated = proc.executeUpdate ();
				
				if (updated > 0)
					result = true;
				else
					result = false;
				
				super.returnConnection (connection);
			}
			catch (SQLException e)
			{
				LogController.write (this, "SQL Exception: "+e.toString ());
				e.printStackTrace ();
				
				result = false;
			}
		}
		else
		{
			result = false;
		}
		
		if (result)
			LogController.write (this, "Deleted sale bean: "+sale.getTransactionNo ());
		
		return result;
	}

	@Override
	public boolean exists (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported yet.");
	}

	@Override
	public DataBean getBean (ResultSet result) throws SQLException
	{
		SaleBean sale = new SaleBean ();

		sale.setTransactionNo (result.getInt ("transaction_no"));
		sale.setPaymentType (result.getString ("payment_type"));
		sale.setTotalDue (result.getDouble ("total_due"));
		sale.setTotalTax (result.getDouble ("total_tax"));
		sale.setDiscount (result.getInt ("discount"));
		sale.setPayment (result.getDouble ("payment"));
		sale.setIsComplete (result.getBoolean ("is_complete"));

		sale.setLoaded ();

		ClientBean clientBean = new ClientBean ();
		clientBean.setClientNo (result.getInt ("client_no"));
		sale.setClient (clientBean);

		EmployeeBean employeeBean = new EmployeeBean ();
		employeeBean.setEmployeeNo (result.getInt ("employee_no"));
		sale.setEmployee (employeeBean);

		return sale;
	}
}