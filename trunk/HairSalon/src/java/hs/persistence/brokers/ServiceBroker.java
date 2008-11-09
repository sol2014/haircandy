/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
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
 * The broker that provides the service beans to/from the database.
 * 
 * @author Miyoung Han
 */
public class ServiceBroker extends DatabaseBroker implements BrokerInterface
{
	private static ServiceBroker instance = null;
	
	public static ServiceBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ServiceBroker ();
		}
		
		return instance;
	}
	
	ServiceBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		ServiceBean service = (ServiceBean) data;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadService(?)}");

			// Check which search parameters this object provides

			if (service.getServiceNo () != null)
			{
				statement.setInt (1, service.getServiceNo ());
			}
			else
			{
				LogController.write (this, "Service bean has no identification number!");
				return null;
			}

			// The first result set should be the service record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				service = (ServiceBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Service not loaded.");
				return null;
			}
			
			// Now load the services.
			
			service.setProductUse (new Hashtable<ProductBean, Integer> ());
			
			if (statement.getMoreResults ())
			{
				// Do we have another result set?
				ResultSet productResults = statement.getResultSet ();
				
				while (productResults.next ())
				{
					ProductBean product = (ProductBean)ProductBroker.getInstance ().getBean (productResults);
					int amount = productResults.getInt ("amount");
					service.getProductUse ().put (product, amount);
					LogController.write (this, "Loaded a product into service: "+service.getServiceNo()+" amount: "+amount);
				}
			}
			
			
			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded service bean: "+service.getServiceNo ());
		
		return service;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		ServiceBean service = (ServiceBean) data;
		ArrayList<ServiceBean> results = new ArrayList<ServiceBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchService(?,?,?,?,?)}");
			int index = 1;
			
			addToStatement (statement, service.getName(), index++, String.class);
			addToStatement (statement, service.getDescription(), index++, String.class);
			addToStatement (statement, service.getDuration(), index++, Integer.class);
			addToStatement (statement, service.getPrice (), index++, Double.class);
			addToStatement (statement, service.getEnabled(), index++, Boolean.class);
			
			// The first result set should be the service record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((ServiceBean) getBean (set));
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found service beans: "+results.size());
		
		ServiceBean[] resultarray = new ServiceBean[results.size ()];
		return results.toArray (resultarray);
	}

	@Override
	public boolean commit (DataBean data)
	{
		ServiceBean service = (ServiceBean) data;
		boolean result = true;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;
			
			if (service.getServiceNo () == null)
			{
				statement = connection.prepareCall ("{call CreateService(?,?,?,?,?,?)}");
			}
			else
			{
				statement = connection.prepareCall ("{call UpdateService(?,?,?,?,?,?)}");
				statement.setInt (index++, service.getServiceNo ());
			}
			
			statement.setString (index++, service.getName ());
			statement.setString (index++, service.getDescription ());
			statement.setInt (index++, service.getDuration ());
			statement.setDouble (index++, service.getPrice ());
			statement.setBoolean (index++, service.getEnabled ());
			
			if (service.getServiceNo () == null)
			{
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
			}
			
			int updated = statement.executeUpdate ();
			
			if (updated > 0)
			{
				result = true;
				
				if (service.getServiceNo () == null)
					service.setServiceNo (statement.getInt ("p_key"));
			}
			else
			{
				result = false;
			}
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "Exception occured during save: "+e.toString ());
			result = false;
		}
		
		if (result)
		{
			// We have successfully saved the service record. Now we will want to update the linking
			// table data.
			try
			{
				Connection connection = super.getConnection ();
				
				// Erase any existing products for this service.
				CallableStatement statement = connection.prepareCall ("{call DeleteServiceProducts(?)}");
				statement.setInt (1, service.getServiceNo ());
				int updated = statement.executeUpdate ();
				
				if (updated < 1)
					LogController.write (this, "No products were removed during update.");
				else
					LogController.write (this, "Products were removed for update.");
				
				statement.close ();
				
				if (service.getProductUse () != null || service.getProductUse ().size () > 0)
				{
					// Commit all the products for the linking tables.
					for (ProductBean product : service.getProductUse ().keySet ())
					{
						statement = connection.prepareCall ("{call AddServiceProduct(?,?,?)}");
						statement.setInt (1, service.getServiceNo ());
						statement.setInt (2, product.getProductNo ());
						statement.setInt (3, service.getProductUse ().get (product));
						
						updated = statement.executeUpdate ();
						
						if (updated > 0)
						{
							LogController.write (this, "Added product ["+product.getProductNo()+"] to service record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add product ["+product.getProductNo()+"] to service.");
							result = false;
						}
						
						statement.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no products to store for this service.");
				}
				
				super.returnConnection (connection);
			}
			catch (SQLException e2)
			{
				LogController.write (this, "There was an exception: "+e2.getMessage ());
				result = false;
			}
		}
		
		if (result)
			LogController.write (this, "Commit service bean: "+service.getServiceNo ());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		ServiceBean service = (ServiceBean) data;
		boolean result = false;
		
		try
		{
			if (service.getServiceNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteService(?)}");

				statement.setInt (1, service.getServiceNo ());
				
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
			LogController.write (this, "Deleted service bean: "+service.getServiceNo());
		
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
		ServiceBean service = new ServiceBean ();
		
		service.setServiceNo (result.getInt ("service_no"));
		service.setName (result.getString ("name"));
		service.setDescription (result.getString ("description"));
		service.setDuration (result.getInt ("duration"));
		service.setPrice (result.getDouble ("price"));
		service.setEnabled (result.getBoolean ("enabled"));
		
		service.setLoaded ();
		
		return service;
	}
}

