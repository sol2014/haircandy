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
 * The broker that provides the availabilityException beans to/from the database.
 * 
 * @author Miyoung Han
 */
public class ScheduleExceptionBroker extends DatabaseBroker implements BrokerInterface
{
	private static ScheduleExceptionBroker instance = null;
	
	public static ScheduleExceptionBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ScheduleExceptionBroker ();
		}
		
		return instance;
	}
	
	ScheduleExceptionBroker ()
	{
		
	}

	@Override
	public DataBean load (DataBean data)
	{
		ScheduleExceptionBean scheduleException = (ScheduleExceptionBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadScheduleException(?)}");

			// Check which search parameters this object provides

			if (scheduleException.getDate () != null)
			{
				statement.setDate (1, new java.sql.Date (scheduleException.getDate ().getTime ()));
			}
			else
			{
				LogController.write (this, "ScheduleException bean has no date!");
				super.returnConnection (connection);
				return null;
			}
			
			// The first result set should be the availabilityException record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				scheduleException = (ScheduleExceptionBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! ScheduleException not loaded.");
				super.returnConnection (connection);
				return null;
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during load: " + sqlEx.getMessage ());
			super.returnConnection (connection);
			return null;
		}
		catch (Exception e)
		{
			
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Loaded schedule exception bean: "+scheduleException.getDate ());
		
		return scheduleException;
	}
	
	public DataBean[] searchDateRange (DataBean data, java.util.Date start, java.util.Date end)
	{
		ScheduleExceptionBean scheduleException = (ScheduleExceptionBean) data;
		ArrayList<ScheduleExceptionBean> results = new ArrayList<ScheduleExceptionBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchScheduleExceptionRange(?,?)}");

			// Check which search parameters this object provides
			
			if (start == null)
			{
				statement.setNull (1, java.sql.Types.DATE);
			}
			else
			{
				statement.setDate (1, new java.sql.Date (start.getTime ()));
			}
			
			if (end == null)
			{
				statement.setNull (2, java.sql.Types.DATE);
			}
			else
			{
				statement.setDate (2, new java.sql.Date (end.getTime ()));
			}
			
			// The first result set should be the availabilityException record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((ScheduleExceptionBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		catch (Exception e)
		{
			
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Found schedule exception bean range of: "+results.size());
		
		ScheduleExceptionBean[] resultarray = new ScheduleExceptionBean[results.size ()];
		return results.toArray (resultarray);
	}
	
	@Override
	public DataBean[] search (DataBean data)
	{
		ScheduleExceptionBean scheduleException = (ScheduleExceptionBean) data;
		ArrayList<ScheduleExceptionBean> results = new ArrayList<ScheduleExceptionBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchScheduleException(?,?)}");

			// Check which search parameters this object provides
			
			if (scheduleException.getDate () == null)
			{
				statement.setNull (1, java.sql.Types.DATE);
			}
			else
			{
				statement.setDate (1, new java.sql.Date (scheduleException.getDate ().getTime ()));
			}
			
			if (scheduleException.getReason () == null)
			{
				statement.setNull (2, java.sql.Types.VARCHAR);
			}
			else
			{
				statement.setString (2, scheduleException.getReason ());
			}
			
			// The first result set should be the availabilityException record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((ScheduleExceptionBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		catch (Exception e)
		{
			
		}
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Found schedule exception beans: "+results.size());
		
		ScheduleExceptionBean[] resultarray = new ScheduleExceptionBean[results.size ()];
		return results.toArray (resultarray);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		ScheduleExceptionBean scheduleException = (ScheduleExceptionBean) data;
		boolean result = true;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();

			CallableStatement statement = connection.prepareCall ("{call CreateScheduleException(?,?)}");
			
			statement.setDate (1, new java.sql.Date (scheduleException.getDate ().getTime ()));
			statement.setString (2, scheduleException.getReason ());
			
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
		catch (Exception e)
		{
			
		}
		if (connection != null)
			super.returnConnection (connection);
		
		return result;
	}
	
	@Override
	public boolean delete (DataBean data)
	{
		ScheduleExceptionBean scheduleException = (ScheduleExceptionBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			
			if (scheduleException.getDate () == null)
			{
				// We are going to be deleting all of them.
				CallableStatement statement = connection.prepareCall ("{call DeleteScheduleExceptions()}");
				
				int updated = statement.executeUpdate ();
				
				if (updated > 0)
				{
					LogController.write (this, "Deleted all exceptions for the salon.");
					result = true;
				}
				else
				{
					LogController.write (this, "Was unable to delete all exceptions for the salon.");
					result = false;
				}
			}
			else
			{
				// We also have a date, so we are removing a specific one.
				CallableStatement statement = connection.prepareCall ("{call DeleteScheduleException(?)}");

				statement.setDate (1, new java.sql.Date (scheduleException.getDate ().getTime ()));

				int updated = statement.executeUpdate ();

				if (updated > 0)
				{
					LogController.write (this, "Deleted an exception for the salon.");
					result = true;
				}
				else
				{
					LogController.write (this, "Unable to delete the exception for the salon.");
					result = false;
				}
			}
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString());
			e.printStackTrace();
			
			result = false;
		}
		catch (Exception e)
		{
			
		}
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Deleted schedule exception bean: "+scheduleException.getDate ());
		
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
		ScheduleExceptionBean scheduleException = new ScheduleExceptionBean ();

		scheduleException.setDate (result.getDate ("date"));
		scheduleException.setReason (result.getString ("reason"));
		
		scheduleException.setLoaded ();
		
		return scheduleException;
	}
}
