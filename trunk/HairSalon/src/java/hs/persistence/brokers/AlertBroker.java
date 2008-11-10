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
		throw new UnsupportedOperationException ("Not supported by this broker.");
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		ArrayList<AlertBean> results = new ArrayList<AlertBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call ListAlerts()}");
			
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((AlertBean) getBean (set));
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found alert beans: "+results.size());
		
		AlertBean[] resultarray = new AlertBean[results.size ()];
		return results.toArray (resultarray);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		boolean result = true;
		
		if (alert == null)
		{
			LogController.write(this, "Passed a null data bean to the alert broker.");
			return false;
		}
		
		try
		{
			Connection connection = super.getConnection ();

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
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString());
			e.printStackTrace ();
			
			result = false;
		}
		
		if (result)
			LogController.write (this, "Commit alert bean: "+alert.getAlertNo ());
		
		return result;
	}
	
	@Override
	public boolean delete (DataBean data)
	{
		AlertBean alert = (AlertBean) data;
		boolean result = false;
		
		try
		{
			Connection connection = super.getConnection ();
			
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
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			result = false;
		}
		
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