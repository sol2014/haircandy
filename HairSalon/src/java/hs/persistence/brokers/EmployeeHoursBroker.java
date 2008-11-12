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
 * The broker that provides the employee hours beans to/from the database.
 * 
 * @author Philippe Durand
 */
public class EmployeeHoursBroker extends DatabaseBroker implements BrokerInterface
{
	private static EmployeeHoursBroker instance = null;

	public static EmployeeHoursBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new EmployeeHoursBroker ();
		}

		return instance;
	}

	EmployeeHoursBroker ()
	{
	}

	@Override
	public DataBean load (DataBean data)
	{
		EmployeeHoursBean employeehours = (EmployeeHoursBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadEmployeeHours(?,?)}");
			int index = 1;
			
			if (employeehours.getEmployeeNo () != null)
			{
				statement.setInt (index++, employeehours.getEmployeeNo ());
			}
			else
			{
				LogController.write (this, "Employee hours bean has no identification employee!");
				return null;
			}
			
			if (employeehours.getDate () != null)
			{
				statement.setDate (index++, new java.sql.Date (employeehours.getDate ().getTime ()));
			}
			else
			{
				LogController.write (this, "Employee hours bean has no identification date!");
				return null;
			}

			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				employeehours = (EmployeeHoursBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Employee hours not loaded.");
				return null;
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during load: " + sqlEx.getMessage ());

			return null;
		}

		LogController.write (this, "Loaded employee hours bean: " + employeehours.getDate ());

		return employeehours;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported by this broker.");
	}

	@Override
	public boolean commit (DataBean data)
	{
		EmployeeHoursBean employeehours = (EmployeeHoursBean) data;
		boolean result = false;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;

			statement = connection.prepareCall ("{call UpdateEmployeeHours(?,?,?,?)}");
			
			statement.setInt (index++, employeehours.getEmployeeNo ());
			statement.setDate (index++, new java.sql.Date (employeehours.getDate ().getTime ()));
			statement.setTime (index++, new java.sql.Time (employeehours.getStartTime ().getTime ()));
			statement.setTime (index++, new java.sql.Time (employeehours.getEndTime ().getTime ()));

			int updated = statement.executeUpdate ();

			if (updated > 0)
			{
				result = true;
			}
			else
			{
				result = false;
			}
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: " + e.toString ());
			e.printStackTrace ();
			result = false;
		}

		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		EmployeeHoursBean employeehours = (EmployeeHoursBean) data;
		boolean result = false;

		try
		{
			if (employeehours.getDate () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteEmployeeHours(?,?)}");
				int index = 1;
				
				statement.setInt (index++, employeehours.getEmployeeNo ());
				statement.setDate (index++, new java.sql.Date (employeehours.getDate ().getTime ()));

				int updated = statement.executeUpdate ();

				if (updated < 0)
				{
					result = false;
				}
				else
				{
					result = true;
				}
				super.returnConnection (connection);
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

		if (result)
		{
			LogController.write (this, "Deleted schedule hours bean: " + employeehours.getDate ());
		}
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
		EmployeeHoursBean employeehours = new EmployeeHoursBean ();

		employeehours.setEmployeeNo (result.getInt ("employee_no"));
		employeehours.setDate (new java.util.Date (result.getDate ("date").getTime ()));
		employeehours.setStartTime (new java.util.Date (result.getTime ("start_time").getTime ()));
		employeehours.setEndTime (new java.util.Date (result.getTime ("end_time").getTime ()));

		employeehours.setLoaded ();

		return employeehours;
	}
}
