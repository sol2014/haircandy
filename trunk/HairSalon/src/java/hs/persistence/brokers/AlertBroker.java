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

public class AlertBroker extends DatabaseBroker implements BrokerInterface
{
	private static AlertBroker instance = null;
	
	public static AlertBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new AlertBroker ();
		}
		
		return instance;
	}
	
	AlertBroker ()
	{
		
	}

	@Override
	public DataBean load (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadAlert(?,?)}");

			// Check which search parameters this object provides

			if (alert.getType () != null)
			{
				statement.setString (1, alert.getType ());
			}
			else
			{
				LogController.write (this, "Alert bean has no identification type!");
				
				super.returnConnection (connection);
				return null;
			}
			
			if (alert.getRecordNo () != null)
			{
				statement.setInt (2, alert.getRecordNo ());
			}
			else
			{
				LogController.write (this, "Alert bean has no identification record!");
				super.returnConnection (connection);
				return null;
			}
			
			// The first result set should be the record.
			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				alert = (AlertBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Alert not loaded.");
				
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
		
		LogController.write (this, "Loaded alert bean: "+alert.getRecordNo ());
		
		return alert;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		ArrayList<AlertBean> results = new ArrayList<AlertBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call ListAlerts()}");
			
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((AlertBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Found alert beans: "+results.size());
		
		AlertBean[] resultarray = new AlertBean[results.size ()];
		return results.toArray (resultarray);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		boolean result = true;
		Connection connection = null;
		
		if (alert == null)
		{
			LogController.write(this, "Passed a null data bean to the alert broker.");
			return false;
		}
		
		try
		{
			connection = super.getConnection ();

			CallableStatement statement = connection.prepareCall ("{call CreateAlert(?,?,?,?,?,?,?)}");
			int index = 1;
			
			statement.setString (index++, alert.getType ());
			statement.setDate (index++, new java.sql.Date (alert.getDate ().getTime ()));
			statement.setString (index++, alert.getMessage ());
			statement.setString (index++, alert.getLink ());
			statement.setString (index++, alert.getLevel ());
			statement.setInt (index++, alert.getRecordNo ());
			statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
			
			int updated = statement.executeUpdate ();
			
			if (updated > 0)
				result = true;
			else
				result = false;
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString());
			e.printStackTrace ();
			
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Commit alert bean: "+alert.getAlertNo ());
		
		return result;
	}
	
	@Override
	public boolean delete (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			
			if (alert.getAlertNo () != null)
			{
				// We are going to be deleting all of them.
				CallableStatement statement = connection.prepareCall ("{call DeleteAlert(?)}");
				
				statement.setInt (1, alert.getAlertNo ());
				
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
			else
			{
				LogController.write (this, "Attempted to delete an alert with no ID.");
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
			LogController.write (this, "Deleted alert bean: "+alert.getAlertNo ());
		
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
		AlertBean alert = new AlertBean ();
		
		alert.setAlertNo (result.getInt ("alert_no"));
		alert.setType (result.getString ("alert_type"));
		alert.setDate (result.getDate ("date"));
		alert.setMessage (result.getString ("message"));
		alert.setLink (result.getString ("link"));
		alert.setLevel (result.getString ("level"));
		alert.setRecordNo (result.getInt ("record_no"));
		
		alert.setLoaded ();
		
		return alert;
	}
}
