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

public class AvailabilityExceptionBroker extends DatabaseBroker implements BrokerInterface
{
	private static AvailabilityExceptionBroker instance = null;
	
	public static AvailabilityExceptionBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new AvailabilityExceptionBroker ();
		}
		
		return instance;
	}
	
	AvailabilityExceptionBroker ()
	{
		
	}

	@Override
	public DataBean load (DataBean data)
	{
		AvailabilityExceptionBean availabilityException = (AvailabilityExceptionBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadAvailabilityException(?,?)}");

			// Check which search parameters this object provides

			if (availabilityException.getEmployeeNo () != null)
			{
				statement.setInt (1, availabilityException.getEmployeeNo ());
			}
			else
			{
				LogController.write (this, "AvailabilityException bean has no employee number!");
				super.returnConnection (connection);
				return null;
			}
			
			if (availabilityException.getDate () != null)
			{
				statement.setDate (2, (java.sql.Date)availabilityException.getDate ());
			}
			else
			{
				LogController.write (this, "AvailabilityException bean has no date!");
				super.returnConnection (connection);
				return null;
			}
			
			// The first result set should be the availabilityException record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				availabilityException = (AvailabilityExceptionBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! AvailabilityException not loaded.");
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
		
		LogController.write (this, "Loaded availability exception bean: "+availabilityException.getEmployeeNo ()+":"+availabilityException.getDate ());
		
		return availabilityException;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		AvailabilityExceptionBean availabilityException = (AvailabilityExceptionBean) data;
		ArrayList<AvailabilityExceptionBean> results = new ArrayList<AvailabilityExceptionBean> ();
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchAvailabilityException(?,?,?)}");
			int index = 1;
			
			// Check which search parameters this object provides
			
			if (availabilityException.getEmployeeNo () == null)
			{
				statement.setNull (index++, java.sql.Types.BIGINT);
			}
			else
			{
				statement.setInt (index++, availabilityException.getEmployeeNo ());
			}
			
			if (availabilityException.getDate () == null)
			{
				statement.setNull (index++, java.sql.Types.DATE);
			}
			else
			{
				statement.setDate (index++, new java.sql.Date (availabilityException.getDate ().getTime()));
			}
			
			if (availabilityException.getReason () == null)
			{
				statement.setNull (index++, java.sql.Types.VARCHAR);
			}
			else
			{
				statement.setString (index++, availabilityException.getReason ());
			}
			
			LogController.write ("SQL: "+statement.toString());
			
			// The first result set should be the availabilityException record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((AvailabilityExceptionBean) getBean (set));
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write ("Found availability exception beans: "+results.size());
		
		AvailabilityExceptionBean[] resultarray = new AvailabilityExceptionBean[results.size ()];
		return results.toArray (resultarray);
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		AvailabilityExceptionBean availabilityException = (AvailabilityExceptionBean) data;
		boolean result = true;
		Connection connection = null;
		
		if (availabilityException == null)
		{
			LogController.write(this, "Passed a null data bean to the availability exception broker.");
			return false;
		}
		
		try
		{
			connection = super.getConnection ();

			CallableStatement statement = connection.prepareCall ("{call CreateAvailabilityException(?,?,?)}");
			
			statement.setInt (1, availabilityException.getEmployeeNo ());
			statement.setDate (2, new java.sql.Date (availabilityException.getDate ().getTime ()));
			statement.setString (3, availabilityException.getReason ());
			
			int updated = statement.executeUpdate ();
			
			if (updated > 0)
				result = true;
			else
				result = false;
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Commit availability exception bean: "+availabilityException.getEmployeeNo ()+":"+availabilityException.getDate ());
		
		return result;
	}
	
	@Override
	public boolean delete (DataBean data)
	{
		AvailabilityExceptionBean availabilityException = (AvailabilityExceptionBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			
			if (availabilityException.getDate () == null)
			{
				if (availabilityException.getEmployeeNo () != null)
				{
					// We are going to be deleting all of them.
					CallableStatement statement = connection.prepareCall ("{call DeleteAvailabilityExceptions(?)}");
					
					statement.setInt (1, availabilityException.getEmployeeNo ());

					int updated = statement.executeUpdate ();

					if (updated > 0)
					{
						LogController.write (this, "Deleted all exceptions for this employee.");
						result = true;
					}
					else
					{
						LogController.write (this, "Was unable to delete all exceptions for employee.");
						result = false;
					}
				}
				else
				{
					LogController.write (this, "There is no employee number specified to delete exceptions.");
					super.returnConnection (connection);
					return false;
				}
			}
			else
			{
				// We also have a date, so we are removing a specific one.
				CallableStatement statement = connection.prepareCall ("{call DeleteAvailabilityException(?,?)}");

				statement.setInt (1, availabilityException.getEmployeeNo ());
				statement.setDate (2, new java.sql.Date (availabilityException.getDate ().getTime ()));

				int updated = statement.executeUpdate ();

				if (updated > 0)
				{
					LogController.write (this, "Deleted an exception for this employee.");
					result = true;
				}
				else
				{
					LogController.write (this, "Unable to delete the exception for this employee.");
					result = false;
				}
			}
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		if (result)
			LogController.write (this, "Deleted availability exception bean: "+availabilityException.getEmployeeNo ()+":"+availabilityException.getDate ());
		
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
		AvailabilityExceptionBean availabilityException = new AvailabilityExceptionBean ();

		availabilityException.setEmployeeNo (result.getInt ("employee_no"));
		availabilityException.setDate (result.getDate ("date"));
		availabilityException.setReason (result.getString ("reason"));
		
		availabilityException.setLoaded ();
		
		return availabilityException;
	}
}
