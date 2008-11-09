/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Miyoung Han
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
 * The broker that provides the product beans to/from the database.
 * 
 * @author Miyoung Han
 */
public class ProductBroker extends DatabaseBroker implements BrokerInterface
{
	private static ProductBroker instance = null;
	
	public static ProductBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ProductBroker ();
		}
		
		return instance;
	}
	
	ProductBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		ProductBean product = (ProductBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadProduct(?)}");

			// Check which search parameters this object provides

			if (product.getProductNo () != null)
			{
				statement.setInt (1, product.getProductNo ());
			}
			else
			{
				LogController.write (this, "Product bean has no identification number!");
				return null;
			}

			// The first result set should be the employee record.
			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				product = (ProductBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Product not loaded.");
				return null;
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded product bean: "+product.getProductNo ());
		
		return product;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		ProductBean product = (ProductBean) data;
		ArrayList<ProductBean> results = new ArrayList<ProductBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchProduct(?,?,?,?,?,?,?,?,?)}");
			int index = 1;
			
			// Check which search parameters this object provides
			
			addToStatement (statement, product.getBrand(), index++, String.class);
			addToStatement (statement, product.getName(), index++, String.class);
			addToStatement (statement, product.getType(), index++, String.class);
			addToStatement (statement, product.getStockQty(), index++, Integer.class);
			addToStatement (statement, product.getMinLevel(), index++, Integer.class);
			addToStatement (statement, product.getQtyPer(), index++, Integer.class);
			addToStatement (statement, product.getPrice(), index++, Double.class);
			addToStatement (statement, product.getUnit(), index++, String.class);
			addToStatement (statement, product.getEnabled(), index++, Boolean.class);
			
			// The first result set should be the product record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((ProductBean) getBean (set));
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found product beans: "+results.size ());
		
		ProductBean[] ra = new ProductBean[results.size ()];
		return results.toArray (ra);
	}

	@Override
	public boolean commit (DataBean data)
	{
		ProductBean product = (ProductBean) data;
		boolean result = false;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;
			
			if (product.getProductNo () == null)
			{
				statement = connection.prepareCall ("{call CreateProduct(?,?,?,?,?,?,?,?,?,?)}");
			}
			else
			{
				statement = connection.prepareCall ("{call UpdateProduct(?,?,?,?,?,?,?,?,?,?)}");
				statement.setInt (index++, product.getProductNo ());
			}
			
			statement.setString (index++, product.getBrand ());
			statement.setString (index++, product.getName ());
			statement.setString (index++, product.getType ());
			statement.setInt (index++, product.getStockQty ());
			statement.setInt (index++, product.getMinLevel ());
			statement.setInt (index++, product.getQtyPer ());
			statement.setDouble (index++, product.getPrice ());
			statement.setString (index++, product.getUnit ());
			statement.setBoolean (index++, product.getEnabled ());
			
			if (product.getProductNo () == null)
			{
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
				
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
				{
					result = true;
					product.setProductNo (statement.getInt ("p_key"));
				}
				else
				{
					result = false;
				}
			}
			else
			{
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
				{
					result = true;
				}
				else
				{
					result = false;
				}
			}
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString ());
			result = false;
		}
		
		if (result)
			LogController.write (this, "Commit product bean: "+product.getProductNo ());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		ProductBean product = (ProductBean) data;
		boolean result = false;
		
		try
		{
			if (product.getProductNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteProduct(?)}");

				int updated = statement.executeUpdate ();
				
				if (updated > 0)
					result = true;
				else
					result = false;
				
				super.returnConnection (connection);
			}
			else
			{
				result = false;
			}
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		if (result)
			LogController.write (this, "Deleted product bean: "+product.getProductNo ());
		
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
		ProductBean product = new ProductBean ();

		product.setProductNo (result.getInt ("product_no"));
		product.setBrand (result.getString ("brand"));
		product.setName (result.getString ("product_name"));
		product.setType (result.getString ("product_type"));
		product.setStockQty (result.getInt ("stock_qty"));
		product.setMinLevel (result.getInt ("min_level"));
		product.setQtyPer (result.getInt ("qty_per"));
		product.setPrice (result.getDouble ("price"));
		product.setUnit (result.getString ("unit"));
		product.setEnabled (result.getBoolean ("enabled"));

		product.setLoaded ();

		return product;
	}
}

