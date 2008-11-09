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
 * The broker that provides the employee beans to/from the database.
 */
public class EmployeeBroker extends DatabaseBroker implements BrokerInterface
{
	private static EmployeeBroker instance = null;
	
	public static EmployeeBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new EmployeeBroker ();
		}
		
		return instance;
	}
	
	EmployeeBroker ()
	{
		
	}
	
	@Override
	public DataBean load (DataBean data)
	{
		EmployeeBean employee = (EmployeeBean) data;

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call LoadEmployee(?)}");

			// Check which search parameters this object provides

			if (employee.getEmployeeNo () != null)
			{
				statement.setInt (1, employee.getEmployeeNo ());
			}
			else
			{
				LogController.write (this, "Employee bean has no identification number!");
				return null;
			}

			// The first result set should be the record.
			ResultSet set = statement.executeQuery ();
			
			if (set.next ())
			{
				employee = (EmployeeBean) getBean (set);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Employee not loaded.");
				return null;
			}
			
			// Now load the services.
			
			employee.setServices (new ArrayList<ServiceBean> ());
			
			if (statement.getMoreResults ())
			{
				// Do we have another result set?
				ResultSet serviceResults = statement.getResultSet ();
				
				while (serviceResults.next ())
				{
					ServiceBean service = (ServiceBean)ServiceBroker.getInstance ().getBean (serviceResults);
					employee.getServices ().add (service);
					LogController.write (this, "Loaded a service into employee: "+service.getServiceNo());
				}
			}
			
			// Now load the exceptions
			
			employee.setAvailabilityExceptions (new ArrayList<AvailabilityExceptionBean> ());
			
			if (statement.getMoreResults ())
			{
				ResultSet exceptionResults = statement.getResultSet ();
				
				while (exceptionResults.next ())
				{
					AvailabilityExceptionBean exception = (AvailabilityExceptionBean)AvailabilityExceptionBroker.getInstance ().getBean (exceptionResults);
					employee.getAvailabilityExceptions ().add (exception);
					LogController.write (this, "Loaded a exception into employee: "+exception.getDate ().toString());
				}
			}
			
			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during load: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded employee bean: "+employee.getEmployeeNo ());
		
		return employee;
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		EmployeeBean employee = (EmployeeBean) data;
		AddressBean address = employee.getAddress();
		
		ArrayList<EmployeeBean> results = new ArrayList<EmployeeBean> ();
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = connection.prepareCall ("{call SearchEmployee(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			int index = 1;
			
			addToStatement (statement, employee.getEmployeeNo (), index++, Integer.class);
			addToStatement (statement, employee.getPassword (), index++, String.class);
			addToStatement (statement, employee.getFirstName (), index++, String.class);
			addToStatement (statement, employee.getLastName (), index++, String.class);
			addToStatement (statement, employee.getPhoneNumber (), index++, String.class);
			addToStatement (statement, employee.getRole (), index++, String.class);
			addToStatement (statement, address.getAddress1 (), index++, String.class);
			addToStatement (statement, address.getAddress2 (), index++, String.class);
			addToStatement (statement, address.getCity (), index++, String.class);
			addToStatement (statement, address.getProvince (), index++, String.class);
			addToStatement (statement, address.getCountry (), index++, String.class);
			addToStatement (statement, address.getPostalCode (), index++, String.class);
			addToStatement (statement, address.getEmail (), index++, String.class);
			addToStatement (statement, employee.getEnabled(), index++, Boolean.class);
			
			// The first result set should be the employee record.
			ResultSet set = statement.executeQuery ();

			while (set.next ())
			{
				results.add ((EmployeeBean) getBean (set));
			}

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found employee beans: " + results.size ());
		
		EmployeeBean[] ra = new EmployeeBean[results.size ()];
		return results.toArray (ra);
	}

	@Override
	public boolean commit (DataBean data)
	{
		EmployeeBean employee = (EmployeeBean) data;
		boolean result = true;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement statement = null;
			int index = 1;
			
			if (employee.getEmployeeNo () == null)
			{
				statement = connection.prepareCall ("{call CreateEmployee(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			}
			else
			{
				statement = connection.prepareCall ("{call UpdateEmployee(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
				statement.setInt (index++, employee.getEmployeeNo ());
			}
			
			statement.setInt (index++, employee.getAddress ().getAddressNo ());
			statement.setString (index++, employee.getPassword ());
			statement.setString (index++, employee.getFirstName ());
			statement.setString (index++, employee.getLastName ());
			statement.setString (index++, employee.getPhoneNumber ());
			statement.setString (index++, employee.getRole ());
			
			statement.setTime (index++, new java.sql.Time(employee.getMondayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getMondayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getTuesdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getTuesdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getWednesdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getWednesdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getThursdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getThursdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getFridayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getFridayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getSaturdayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getSaturdayEnd ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getSundayStart ().getTime()));
			statement.setTime (index++, new java.sql.Time(employee.getSundayEnd ().getTime()));
			
			statement.setBoolean (index++, employee.getEnabled ());
			
			int updated = 0;
			
			if (employee.getEmployeeNo () == null)
			{
				statement.registerOutParameter ("p_key", java.sql.Types.BIGINT);
				
				updated = statement.executeUpdate ();
				
				if (updated > 0)
					employee.setEmployeeNo (statement.getInt ("p_key"));
			}
			else
			{
				updated = statement.executeUpdate ();
			}
			
			if (updated == 0)
				result = false;
			else
				result = true;
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			result = false;
		}
		
		if (result)
		{
			// We have successfully saved the employee record. Now we will want to update the linking
			// table data.
			try
			{
				Connection connection = super.getConnection ();
				
				// Erase any existing services for this employee.
				CallableStatement statement = connection.prepareCall ("{call DeleteEmployeeServices(?)}");
				statement.setInt (1, employee.getEmployeeNo ());
				int updated = statement.executeUpdate ();
				
				if (updated < 1)
					LogController.write (this, "No services were removed during update.");
				else
					LogController.write (this, "Services were removed for update.");
				
				statement.close ();
				
				if (employee.getServices () != null || employee.getServices ().size () > 0)
				{
					// Commit all the services for the linking tables.
					for (ServiceBean service : employee.getServices())
					{
						statement = connection.prepareCall ("{call AddEmployeeService(?,?)}");
						statement.setInt (1, employee.getEmployeeNo ());
						statement.setInt (2, service.getServiceNo ());
						
						updated = statement.executeUpdate ();
						
						if (updated > 0)
						{
							LogController.write (this, "Added service ["+service.getServiceNo()+"] to employee record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add service ["+service.getServiceNo()+"] to employee.");
							result = false;
						}
						
						statement.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no services to store for this employee.");
				}
				
				super.returnConnection (connection);
			}
			catch (SQLException e2)
			{
				result = false;
			}
		}
		
		LogController.write (this, "Commit employee bean: "+employee.getEmployeeNo ());
		
		return result;
	}

	@Override
	public boolean delete (DataBean data)
	{
		EmployeeBean employee = (EmployeeBean) data;
		boolean result = false;
		
		try
		{
			if (employee.getEmployeeNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement statement = connection.prepareCall ("{call DeleteEmployee(?)}");
				
				statement.setInt (1, employee.getEmployeeNo ());
				
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
		EmployeeBean employee = new EmployeeBean ();

		employee.setEmployeeNo (result.getInt ("employee_no"));
		employee.setPassword (result.getString ("password"));
		employee.setRole (result.getString ("role"));
		employee.setFirstName (result.getString ("first_name"));
		employee.setLastName (result.getString ("last_name"));
		employee.setPhoneNumber (result.getString ("phone_number"));
		
		employee.setMondayStart (result.getTime ("monday_start"));
		employee.setMondayEnd (result.getTime ("monday_end"));
		employee.setTuesdayStart (result.getTime ("tuesday_start"));
		employee.setTuesdayEnd (result.getTime ("tuesday_end"));
		employee.setWednesdayStart (result.getTime ("wednesday_start"));
		employee.setWednesdayEnd (result.getTime ("wednesday_end"));
		employee.setThursdayStart (result.getTime ("thursday_start"));
		employee.setThursdayEnd (result.getTime ("thursday_end"));
		employee.setFridayStart (result.getTime ("friday_start"));
		employee.setFridayEnd (result.getTime ("friday_end"));
		employee.setSaturdayStart (result.getTime ("saturday_start"));
		employee.setSaturdayEnd (result.getTime ("saturday_end"));
		employee.setSundayStart (result.getTime ("sunday_start"));
		employee.setSundayEnd (result.getTime ("sunday_end"));
		
		employee.setEnabled (result.getBoolean ("enabled"));
		
		employee.setLoaded ();

		AddressBean address = new AddressBean ();

		address.setAddressNo (result.getInt ("address_no"));
		employee.setAddress (address);
		
		return employee;
	}
}
