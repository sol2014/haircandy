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
import java.util.ArrayList;
import hs.core.*;
import hs.objects.*;
import hs.persistence.*;

/**
 * The broker that provides the availability beans to/from the database.
 * 
 * @author Nuha Bazara
 */
public class AvailabilityBroker extends DatabaseBroker implements BrokerInterface
{
	private static AvailabilityBroker instance = null;
	
	public static AvailabilityBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new AvailabilityBroker ();
		}
		
		return instance;
	}
	
	AvailabilityBroker ()
	{
		
	}
	
	@Override
	public DataBean[] search (DataBean data)
	{
		AvailabilityBean availability = (AvailabilityBean) data;
		ArrayList<AvailabilityBean> availabilityAL = new ArrayList<AvailabilityBean> ();
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call SearchAvaliability(?,?,?,?)}");
			
			if (availability.getStartTime () == null)
			{
				proc.setNull (3, java.sql.Types.DATE);
			}
			else
			{
				proc.setDate (3, (java.sql.Date) availability.getStartTime ());
			}
			
			if (availability.getEndTime () == null)
			{
				proc.setNull (4, java.sql.Types.DATE);
			}
			else
			{
				proc.setDate (4, (java.sql.Date) availability.getEndTime ());
			}
			
			ResultSet result = proc.executeQuery ();
			
			while (result.next ())
			{
				availabilityAL.add ((AvailabilityBean) getBean (result));
			}
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception during search: " + e.getMessage ());
		}
		
		LogController.write (this, "Found availability beans: "+availabilityAL.size());
		
		AvailabilityBean[] availabilityBean = new AvailabilityBean[availabilityAL.size ()];
		return availabilityAL.toArray (availabilityBean);
	}

	@Override
	public boolean commit (DataBean data)
	{
		AvailabilityBean availability = (AvailabilityBean) data;
		boolean result = false;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = null;
			int index = 1;
			
			if (availability.getEmployeeNo () == null)
			{
				proc = connection.prepareCall ("{call CreateAvailability(?,?,?,?)}");
			}
			else
			{
				proc = connection.prepareCall ("{call UpdateAvailability(?,?,?,?)}");
			}
			
			proc.setInt (index++, availability.getEmployeeNo ());
			proc.setInt (index++, availability.getDay ());
			proc.setDate (index++, (java.sql.Date) availability.getStartTime ());
			proc.setDate (index++, (java.sql.Date) availability.getEndTime ());
			
			int updated = proc.executeUpdate ();
			
			if (updated > 0)
				result = true;
			else
				result = false;
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		LogController.write (this, "Commit availability bean: "+availability.getEmployeeNo ()+":"+availability.getDay ());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		AvailabilityBean availability = (AvailabilityBean) data;
		boolean result = false;
		
		try
		{
			if (availability.getEmployeeNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement proc = connection.prepareCall ("{call DeleteAvailability(?,?)}");
				
				proc.setInt (1, availability.getEmployeeNo ());
				proc.setInt (2, availability.getDay ());
				
				int updated = proc.executeUpdate ();
				
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
			LogController.write (this, "Deleted availability bean: "+availability.getEmployeeNo ()+":"+availability.getDay ());
		
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
		AvailabilityBean availability = new AvailabilityBean ();

		availability.setDay (result.getInt ("day_of_week"));
		availability.setEmployeeNo (result.getInt ("employee_no"));
		availability.setStartTime (result.getDate ("availability_start_time"));
		availability.setEndTime (result.getDate ("availability_end_time"));
		
		availability.setLoaded ();
		
		return availability;
	}

	@Override
	public DataBean load (DataBean data)
	{
		AvailabilityBean availability = (AvailabilityBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call LoadAvailability(?,?)}");

			if (availability.getEmployeeNo () != null)
			{
				proc.setInt (1, availability.getEmployeeNo ());
			}
			else
			{
				LogController.write (this, "Availability bean has no employee!");
				return null;
			}

			if (availability.getDay () != null)
			{
				proc.setInt (2, availability.getDay ());
			}
			else
			{
				LogController.write (this, "Availability bean has no day value!");
				return null;
			}
			
			ResultSet result = proc.executeQuery ();

			if (result.next ())
			{
				availability = (AvailabilityBean) getBean (result);
			}
			else
			{
				LogController.write (this, "There were no results for this load! availability not loaded.");
				return null;
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded availability bean: "+availability.getEmployeeNo ()+":"+availability.getDay ());
		
		return availability;
	}
}
