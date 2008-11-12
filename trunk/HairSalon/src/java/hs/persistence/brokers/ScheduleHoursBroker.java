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

import hs.core.*;
import hs.objects.*;
import hs.persistence.*;

/**
 * The broker that provides the schedulehours beans to/from the database.
 * 
 * @author Philippe Durand
 */
public class ScheduleHoursBroker extends DatabaseBroker implements BrokerInterface
{
	private static ScheduleHoursBroker instance = null;

	public static ScheduleHoursBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ScheduleHoursBroker ();
		}

		return instance;
	}

	ScheduleHoursBroker ()
	{
	}

	@Override
	public DataBean load (DataBean data)
	{
		ScheduleHoursBean schedulehours = (ScheduleHoursBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadScheduleHours(?)}");

			if (schedulehours.getDate () != null)
			{
				statement.setDate (1, new java.sql.Date (schedulehours.getDate ().getTime ()));
			}
			else
			{
				LogController.write (this, "Schedule hours bean has no identification number!");
				super.returnConnection (connection);
				return null;
			}

			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				schedulehours = (ScheduleHoursBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Schedule hours not loaded.");
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
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Loaded schedule hours bean: " + schedulehours.getDate ());

		return schedulehours;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported by this broker.");
	}

	@Override
	public boolean commit (DataBean data)
	{
		ScheduleHoursBean schedulehours = (ScheduleHoursBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;

			statement = connection.prepareCall ("{call UpdateScheduleHours(?,?,?)}");
			
			statement.setDate (index++, new java.sql.Date (schedulehours.getDate ().getTime ()));
			statement.setTime (index++, new java.sql.Time (schedulehours.getStartTime ().getTime ()));
			statement.setTime (index++, new java.sql.Time (schedulehours.getEndTime ().getTime ()));

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
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: " + e.toString ());
			e.printStackTrace ();
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		ScheduleHoursBean schedulehours = (ScheduleHoursBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			if (schedulehours.getDate () != null)
			{
				connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteScheduleHours(?)}");

				statement.setDate (1, new java.sql.Date (schedulehours.getDate ().getTime ()));

				int updated = statement.executeUpdate ();

				if (updated < 0)
				{
					result = false;
				}
				else
				{
					result = true;
				}
			}
			else
			{
				result = false;
			}
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: " + e.toString ());
			e.printStackTrace ();

			result = false;
		}

		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Deleted schedule hours bean: " + schedulehours.getDate ());
		
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
		ScheduleHoursBean schedulehours = new ScheduleHoursBean ();

		schedulehours.setDate (new java.util.Date (result.getDate ("date").getTime ()));
		schedulehours.setStartTime (new java.util.Date (result.getTime ("start_time").getTime ()));
		schedulehours.setEndTime (new java.util.Date (result.getTime ("end_time").getTime ()));

		schedulehours.setLoaded ();

		return schedulehours;
	}
}
