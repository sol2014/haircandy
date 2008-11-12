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
 * The broker that provides the address beans to/from the database.
 * 
 * @author Philippe Durand
 */
public class AddressBroker extends DatabaseBroker implements BrokerInterface
{
	private static AddressBroker instance = null;
	
	public static AddressBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new AddressBroker ();
		}
		
		return instance;
	}
	
	AddressBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		AddressBean address = (AddressBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadAddress(?)}");

			// Check which search parameters this object provides

			if (address.getAddressNo () != null)
			{
				statement.setInt (1, address.getAddressNo ());
			}
			else
			{
				LogController.write (this, "Address bean has no identification number!");
				
				super.returnConnection (connection);
				return null;
			}

			// The first result set should be the record.
			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				address = (AddressBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Address not loaded.");
				
				super.returnConnection (connection);
				return null;
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Loaded address bean: "+address.getAddressNo ());
		
		return address;
	}
	
	@Override
	public DataBean[] search (DataBean data)
	{
		AddressBean address = (AddressBean) data;
		ArrayList<AddressBean> results = new ArrayList<AddressBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchAddress(?,?,?,?,?,?)}");
			int index = 1;
			
			addToStatement (statement, address.getAddress1(), index++, String.class);
			addToStatement (statement, address.getAddress2(), index++, String.class);
			addToStatement (statement, address.getCity(), index++, String.class);
			addToStatement (statement, address.getProvince(), index++, String.class);
			addToStatement (statement, address.getCountry(), index++, String.class);
			addToStatement (statement, address.getPostalCode(), index++, String.class);
			addToStatement (statement, address.getEmail(), index++, String.class);
			
			// The first result set should be the employee record.
			ResultSet set = statement.executeQuery ();
			
			while (set.next ())
			{
				results.add ((AddressBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Found address beans: "+results.size());
		
		AddressBean[] ra = new AddressBean[results.size ()];
		return results.toArray (ra);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		AddressBean address = (AddressBean) data;
		boolean result = true;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			
			if (address.getAddressNo () == null)
			{
				CallableStatement statement = connection.prepareCall ("{call CreateAddress(?,?,?,?,?,?,?,?)}");
				
				statement.setString (1, address.getAddress1 ());
				statement.setString (2, address.getAddress2 ());
				statement.setString (3, address.getCity ());
				statement.setString (4, address.getProvince ());
				statement.setString (5, address.getCountry ());
				statement.setString (6, address.getPostalCode ());
				statement.setString (7, address.getEmail ());
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
				
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
				{
					address.setAddressNo (statement.getInt ("p_key"));
					result = true;
				}
				else
					result = false;
			}
			else
			{
				CallableStatement statement = connection.prepareCall ("{call UpdateAddress(?,?,?,?,?,?,?,?)}");
				
				statement.setInt (1, address.getAddressNo ());
				statement.setString (2, address.getAddress1 ());
				statement.setString (3, address.getAddress2 ());
				statement.setString (4, address.getCity ());
				statement.setString (5, address.getProvince ());
				statement.setString (6, address.getCountry ());
				statement.setString (7, address.getPostalCode ());
				statement.setString (8, address.getEmail ());
				
				int updated = statement.executeUpdate ();
				
				if (updated == 0)
					result = false;
				else
					result = true;
			}
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQLException: "+e.toString());
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Commit address bean: "+address.getAddressNo ());
		
		return result;
	}
	
	@Override
	public boolean delete (DataBean data)
	{
		AddressBean address = (AddressBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			if (address.getAddressNo () != null)
			{
				connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call UpdateAddress}");
				
				statement.setInt (1, address.getAddressNo ());
				
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
					result = true;
				else
					result = false;
			}
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Deleted address bean: "+address.getAddressNo ());
		
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
		AddressBean data = new AddressBean ();
		
        data.setAddressNo (result.getInt ("address_no"));
		data.setAddress1 (result.getString ("address1"));
		data.setAddress2 (result.getString ("address2"));
		data.setCity (result.getString ("city"));
		data.setProvince (result.getString ("province"));
		data.setCountry (result.getString ("country"));
		data.setPostalCode (result.getString ("postal_code"));
		data.setEmail (result.getString("email"));
		
		data.setLoaded ();
		
		return data;
	}
}
