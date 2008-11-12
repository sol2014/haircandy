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
import java.util.ArrayList;

public class SalonBroker extends DatabaseBroker implements BrokerInterface
{
	private static SalonBroker instance = null;
	
	public static SalonBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new SalonBroker ();
		}
		
		return instance;
	}
	
	SalonBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		SalonBean salon = (SalonBean) data;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadSalon()}");
			
			// The first result set should be the employee record.
			ResultSet set = statement.executeQuery ();

			if (set.next ())
			{
				salon = (SalonBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Salon not loaded.");
				super.returnConnection (connection);
				return null;
			}
			
			salon.setExceptions (new ArrayList<ScheduleExceptionBean>());
			
			if (statement.getMoreResults ())
			{
				// Do we have another result set?
				ResultSet exceptionResults = statement.getResultSet ();
				
				while (exceptionResults.next ())
				{
					ScheduleExceptionBean exception = (ScheduleExceptionBean)ScheduleExceptionBroker.getInstance ().getBean (exceptionResults);
					salon.getExceptions ().add (exception);
					LogController.write (this, "Added an exception to salon.");
				}
			}
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.toString ());
			sqlEx.printStackTrace();
			super.returnConnection (connection);
			return null;
		}
		
		if (connection != null)
			super.returnConnection (connection);
		
		LogController.write (this, "Loaded salon bean.");
		
		return salon;
	}
	
	@Override
	public DataBean[] search (DataBean data)
	{
		throw new UnsupportedOperationException ("Salon broker cannot search records.");
	}
	
	@Override
	public boolean commit (DataBean data)
	{
		SalonBean salon = (SalonBean) data;
		boolean result = false;
		Connection connection = null;
		
		try
		{
			connection = super.getConnection ();
			
			CallableStatement statement = connection.prepareCall ("{call UpdateSalon(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			int index = 1;
			
			statement.setString (index++, salon.getName ());
			statement.setString (index++, salon.getAddress1 ());
			statement.setString (index++, salon.getAddress2 ());
			statement.setString (index++, salon.getCity ());
			statement.setString (index++, salon.getProvince ());
			statement.setString (index++, salon.getCountry ());
			statement.setString (index++, salon.getPostalCode ());
			statement.setString (index++, salon.getPhoneNumber ());
			statement.setString (index++, salon.getEmail ());
			statement.setDouble (index++, salon.getTaxRate ());
			statement.setTime (index++, new java.sql.Time(salon.getMondayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getMondayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getTuesdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getTuesdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getWednesdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getWednesdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getThursdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getThursdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getFridayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getFridayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getSaturdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getSaturdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getSundayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(salon.getSundayEnd ().getTime()));
			
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
			LogController.write (this, "Commit salon bean.");
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		throw new UnsupportedOperationException ("Salon broker cannot delete records.");
	}

	@Override
	public boolean exists (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported yet.");
	}

	@Override
	public DataBean getBean (ResultSet result) throws SQLException
	{
		SalonBean salon = new SalonBean ();
		
		salon.setAddress1 (result.getString ("address1"));
		salon.setAddress2 (result.getString ("address2"));
		salon.setCity (result.getString ("city"));
		salon.setProvince (result.getString ("province"));
		salon.setCountry (result.getString ("country"));
		salon.setEmail (result.getString ("email"));
		salon.setName (result.getString ("name"));
		salon.setPhoneNumber (result.getString ("phone_number"));
		salon.setPostalCode (result.getString ("postal_code"));
		salon.setTaxRate (result.getDouble ("tax_rate"));
		salon.setMondayStart (result.getTime ("monday_start"));
		salon.setMondayEnd (result.getTime ("monday_end"));
		salon.setTuesdayStart (result.getTime ("tuesday_start"));
		salon.setTuesdayEnd (result.getTime ("tuesday_end"));
		salon.setWednesdayStart (result.getTime ("wednesday_start"));
		salon.setWednesdayEnd (result.getTime ("wednesday_end"));
		salon.setThursdayStart (result.getTime ("thursday_start"));
		salon.setThursdayEnd (result.getTime ("thursday_end"));
		salon.setFridayStart (result.getTime ("friday_start"));
		salon.setFridayEnd (result.getTime ("friday_end"));
		salon.setSaturdayStart (result.getTime ("saturday_start"));
		salon.setSaturdayEnd (result.getTime ("saturday_end"));
		salon.setSundayStart (result.getTime ("sunday_start"));
		salon.setSundayEnd (result.getTime ("sunday_end"));
		
		salon.setLoaded ();
		
		return salon;
	}
}
