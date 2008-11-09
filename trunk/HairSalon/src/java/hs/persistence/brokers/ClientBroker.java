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
 * The client bean broker to/from the database.
 * 
 * @author Nuha Bazara
 */
public class ClientBroker extends DatabaseBroker implements BrokerInterface
{
	private static ClientBroker instance = null;
	
	public static ClientBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ClientBroker ();
		}
		
		return instance;
	}
	
	ClientBroker ()
	{
		
	}

	@Override
	public DataBean load (DataBean data)
	{
		ClientBean client = (ClientBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadClient(?)}");

			// Check which search parameters this object provides

			if (client.getClientNo () != null)
			{
				statement.setInt (1, client.getClientNo ());
			}
			else
			{
				LogController.write (this, "Client bean has no identification number!");
				return null;
			}

			// The first result set should be the client record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				client = (ClientBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Client not loaded.");
				return null;
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded client bean: "+client.getClientNo ());
		
		return client;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		ClientBean client = (ClientBean) data;
		AddressBean address = client.getAddress();
		ArrayList<ClientBean> results = new ArrayList<ClientBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchClient(?,?,?,?,?,?,?,?,?,?,?)}");
			int index = 1;
			
			addToStatement (statement, client.getFirstName(), index++, String.class);
			addToStatement (statement, client.getLastName(), index++, String.class);
			addToStatement (statement, client.getPhoneNumber (), index++, String.class);
			addToStatement (statement, address.getAddress1 (), index++, String.class);
			addToStatement (statement, address.getAddress2 (), index++, String.class);
			addToStatement (statement, address.getCity (), index++, String.class);
			addToStatement (statement, address.getProvince (), index++, String.class);
			addToStatement (statement, address.getCountry (), index++, String.class);
			addToStatement (statement, address.getPostalCode (), index++, String.class);
			addToStatement (statement, address.getEmail (), index++, String.class);
			addToStatement (statement, client.getEnabled(), index++, Boolean.class);
			
			// The first result set should be the client record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((ClientBean) getBean (set));
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found client beans: "+results.size());
		
		ClientBean[] ra = new ClientBean[results.size ()];
		return results.toArray (ra);
	}

	@Override
	public boolean commit (DataBean data)
	{
		ClientBean client = (ClientBean) data;
		boolean result = false;
		
		try
		{
			Connection connection = super.getConnection ();

			if (client.getClientNo () == null)
			{
				CallableStatement statement = connection.prepareCall ("{call CreateClient(?,?,?,?,?,?)}");
				int index = 1;
				
				statement.setString (index++, client.getFirstName ());
				statement.setString (index++, client.getLastName ());
				statement.setInt (index++, client.getAddress ().getAddressNo ());
				statement.setString (index++, client.getPhoneNumber ());
				statement.setBoolean (index++, client.getEnabled ());
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
				
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
				{
					result = true;
					client.setClientNo (statement.getInt ("p_key"));
				}
				else
				{
					result = false;
				}
				
				super.returnConnection (connection);
			}
			else
			{
				CallableStatement statement = connection.prepareCall ("{call UpdateClient(?,?,?,?,?,?)}");
				int index = 1;
				
				statement.setInt (index++, client.getClientNo ());
				statement.setString (index++, client.getFirstName ());
				statement.setString (index++, client.getLastName ());
				statement.setInt (index++, client.getAddress ().getAddressNo ());
				statement.setString (index++, client.getPhoneNumber ());
				statement.setBoolean (index++, client.getEnabled ());
				
				int updated = statement.executeUpdate ();

				if (updated == 0)
					result = false;
				else
					result = true;
				
				super.returnConnection (connection);
			}
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL exception during commit: "+e.toString());
			result = false;
		}
		
		if (result)
			LogController.write (this, "Commit client bean: "+client.getClientNo());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		ClientBean client = (ClientBean) data;
		boolean result = false;
		
		try
		{
			if (client.getClientNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteClient(?)}");

				statement.setInt (1, client.getClientNo ());
				
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
			LogController.write (this, "Deleted client bean: "+client.getClientNo());
		
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
		ClientBean client = new ClientBean ();

		client.setClientNo (result.getInt ("client_no"));
		client.setFirstName (result.getString("first_name"));
		client.setLastName (result.getString ("last_name"));
		client.setPhoneNumber (result.getString ("phone_number"));
		client.setEnabled (result.getBoolean ("enabled"));
		
		client.setLoaded ();

		AddressBean address = new AddressBean ();
		address.setAddressNo (result.getInt ("address_no"));
		client.setAddress (address);
		
		return client;
	}
}