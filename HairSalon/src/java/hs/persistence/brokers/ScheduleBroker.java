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
 * The broker that provides the schedule beans to/from the database.
 * 
 * @author Philippe Durand
 */
public class ScheduleBroker extends DatabaseBroker implements BrokerInterface
{
	private static ScheduleBroker instance = null;
	
	public static ScheduleBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new ScheduleBroker ();
		}
		
		return instance;
	}
	
	ScheduleBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		ScheduleBean schedule = (ScheduleBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadSchedule(?)}");

			// Check which search parameters this object provides

			if (schedule.getScheduleNo () != null)
			{
				statement.setInt (1, schedule.getScheduleNo ());
			}
			else
			{
				LogController.write (this, "Schedule bean has no identification number!");
				super.returnConnection (connection);
				return null;
			}

			// The first result set should be the record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				schedule = (ScheduleBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Schedule not loaded.");
				super.returnConnection (connection);
				return null;
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
			super.returnConnection (connection);
			return null;
		}

		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Loaded schedule bean: "+schedule.getScheduleNo ());
		
		return schedule;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		ScheduleBean schedule = (ScheduleBean) data;
		ArrayList<ScheduleBean> results = new ArrayList<ScheduleBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchSchedule(?,?,?,?)}");	
			int index = 1;
			
			if (schedule.getEmployee() == null)
				addToStatement (statement, null, index++, Integer.class);
			else
				addToStatement (statement, schedule.getEmployee().getEmployeeNo (), index++, Integer.class);
			
			if (schedule.getDate () == null)
			{
				addToStatement (statement, null, index++, java.sql.Date.class);
			}
			else
			{
				addToStatement (statement, new java.sql.Date (schedule.getDate ().getTime()), index++, java.sql.Date.class);
			}
			
			if (schedule.getStartTime() == null)
			{
				addToStatement (statement, null, index++, java.sql.Time.class);
			}
			else
			{
				addToStatement (statement, new java.sql.Time (schedule.getStartTime().getTime()), index++, java.sql.Time.class);
			}
			
			if (schedule.getEndTime () == null)
			{
				addToStatement (statement, null, index++, java.sql.Time.class);
			}
			else
			{
				addToStatement (statement, new java.sql.Time (schedule.getEndTime().getTime()), index++, java.sql.Time.class);
			}
			
			// The first result set should be the schedule record.
			ResultSet set = statement.executeQuery ();
			
			while (set.next ())
			{
				results.add ((ScheduleBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Found schedule beans: "+results.size());
		
		ScheduleBean[] ra = new ScheduleBean[results.size ()];
		return results.toArray (ra);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		ScheduleBean schedule = (ScheduleBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;
			
			if (schedule.getScheduleNo () == null)
			{
				statement = connection.prepareCall ("{call CreateSchedule(?,?,?,?,?)}");
			}
			else
			{
				statement = connection.prepareCall ("{call UpdateSchedule(?,?,?,?,?)}");
				statement.setInt (index++, schedule.getScheduleNo ());
			}
			
			statement.setInt (index++, schedule.getEmployee ().getEmployeeNo ());
			statement.setDate (index++, new java.sql.Date(schedule.getDate ().getTime()));
			statement.setTime (index++, new java.sql.Time(schedule.getStartTime ().getTime()));
			statement.setTime (index++, new java.sql.Time(schedule.getEndTime ().getTime()));

			if (schedule.getScheduleNo () == null)
			{
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
			}
			
			LogController.write ("Executing SQL: "+statement.toString());
			
			int updated = statement.executeUpdate ();

			if (updated > 0)
			{
				result = true;
				if (schedule.getScheduleNo () == null)
					schedule.setScheduleNo (statement.getInt ("p_key"));
			}
			else
			{
				result = false;
			}
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString ());
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
		ScheduleBean schedule = (ScheduleBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			if (schedule.getScheduleNo () != null)
			{
				connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteSchedule(?)}");
				
				statement.setInt (1, schedule.getScheduleNo ());
				
				int updated = statement.executeUpdate ();
				
				if (updated < 0)
					result = false;
				else
					result = true;
			}
			else
			{
				result = false;
			}
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
			LogController.write (this, "Deleted schedule bean: "+schedule.getScheduleNo ());
		
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
		ScheduleBean schedule = new ScheduleBean ();
	
		schedule.setScheduleNo (result.getInt ("schedule_no"));		
		schedule.setDate (new java.util.Date (result.getDate ("date").getTime ()));
		schedule.setStartTime (new java.util.Date (result.getTime ("start_time").getTime ()));
		schedule.setEndTime (new java.util.Date (result.getTime("end_time").getTime ()));
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setEmployeeNo (result.getInt("employee_no"));
		schedule.setEmployee (employee);		
		
		schedule.setLoaded ();

		return schedule;
	}
}
