/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
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
import java.util.Hashtable;

/**
 *
 * @author Nuha Bazara
 */
public class AppointmentBroker extends DatabaseBroker implements BrokerInterface
{
	private static AppointmentBroker instance = null;
	
	public static AppointmentBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new AppointmentBroker ();
		}
		
		return instance;
	}
	
	AppointmentBroker ()
	{
		
	}
	
	public DataBean load (DataBean data)
	{
		AppointmentBean appointment = (AppointmentBean) data;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call LoadAppointment(?)}");

			if (appointment.getAppointmentNo () != null)
			{
				proc.setInt (1, appointment.getAppointmentNo ());
			}
			else
			{
				LogController.write (this, "Appointment bean has no identification number!");
				return null;
			}
			
			ResultSet result = proc.executeQuery ();
			
			if (result.next ())
			{
				appointment = (AppointmentBean) getBean (result);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Employee not loaded.");
				return null;
			}
			
			// Now load the services and products.
			
			appointment.setProducts (new Hashtable<ProductBean, Integer> ());
			appointment.setServices (new Hashtable<ServiceBean, Integer> ());

			if (proc.getMoreResults ())
			{
				// Do we have another result set
				ResultSet serviceResults = proc.getResultSet ();

				while (serviceResults.next ())
				{
					ServiceBean service = new ServiceBean ();
					service.setServiceNo (serviceResults.getInt ("service_no"));
					int amount = serviceResults.getInt ("amount");
					appointment.getServices ().put (service, amount);
					LogController.write (this, "Loaded a service into appointment: " + service.getServiceNo ());
				}
			}
			
			if (proc.getMoreResults ())
			{
				ResultSet productResult = proc.getResultSet ();

				while (productResult.next ())
				{
					ProductBean product = new ProductBean ();
					product.setProductNo (productResult.getInt ("product_no"));
					int amount = productResult.getInt ("amount");
					appointment.getProducts ().put (product, amount);
					LogController.write (this, "Loaded a product into appointment:" + product.getProductNo ());
				}
			}
			
			super.returnConnection (connection);
		}
		catch (SQLException e)
		{
			LogController.write (this, "Exception while loading appointment bean: "+appointment.getAppointmentNo ());
			return null;
		}
		
		LogController.write (this, "Loaded appointment bean: "+appointment.getAppointmentNo ());
		
		return appointment;
	}

	public DataBean[] search (DataBean data)
	{
		AppointmentBean appointment = (AppointmentBean) data;
		ArrayList<AppointmentBean> appointmentAL = new ArrayList<AppointmentBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call SearchAppointment(?,?,?,?,?,?)}");
			int index = 1;
			
			if (appointment.getClient () != null)
				addToStatement (proc, appointment.getClient ().getClientNo (), index++, Integer.class);
			else
				addToStatement (proc, null, index++, Integer.class);
			
			if (appointment.getEmployee () != null)
				addToStatement (proc, appointment.getEmployee ().getEmployeeNo (), index++, Integer.class);
			else
				addToStatement (proc, null, index++, Integer.class);
			
			if (appointment.getDate () == null)
				addToStatement (proc, null, index++, java.sql.Date.class);
			else
				addToStatement (proc, new java.sql.Date(appointment.getDate ().getTime()), index++, java.sql.Date.class);
			
			if (appointment.getStartTime () == null)
				addToStatement (proc, null, index++, java.sql.Time.class);
			else
				addToStatement (proc, new java.sql.Time(appointment.getStartTime().getTime ()), index++, java.sql.Time.class);
			
			if (appointment.getEndTime () == null)
				addToStatement (proc, null, index++, java.sql.Time.class);
			else
				addToStatement (proc, new java.sql.Time(appointment.getEndTime().getTime ()), index++, java.sql.Time.class);
			
			addToStatement (proc, appointment.getIsComplete (), index++, Boolean.class);
			
			ResultSet result = proc.executeQuery ();

			while (result.next ())
			{
				appointmentAL.add ((AppointmentBean) getBean (result));
			}

			super.returnConnection (connection);
		}
		catch (SQLException r)
		{
			LogController.write (this, "SQL Exception during search: " + r.getMessage ());
		}
		
		LogController.write (this, "Found appointment beans: "+appointmentAL.size());
		
		AppointmentBean[] appointementBean = new AppointmentBean[appointmentAL.size ()];
		return appointmentAL.toArray (appointementBean);
	}

	public DataBean getBean (ResultSet result) throws SQLException
	{
		AppointmentBean appointment = new AppointmentBean ();
        
        appointment.setAppointmentNo (result.getInt ("appointment_no"));
		appointment.setDate (new java.util.Date (result.getDate ("ap_date").getTime ()));
		appointment.setStartTime (new java.util.Date (result.getTime ("start_time").getTime ()));
		appointment.setEndTime (new java.util.Date (result.getTime("end_time").getTime ()));
		appointment.setIsComplete (result.getBoolean ("is_complete"));
		
		ClientBean client = new ClientBean ();
		client.setClientNo (result.getInt ("client_no"));
		appointment.setClient (client);
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setEmployeeNo (result.getInt ("employee_no"));
		appointment.setEmployee (employee);
		
		appointment.setLoaded ();
		
		return appointment;
	}

	public boolean commit (DataBean data)
	{
		AppointmentBean appointment = (AppointmentBean) data;
		boolean result = false;
		
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = null;
			int index = 1;
			
			if (appointment.getAppointmentNo () == null)
			{
				proc = connection.prepareCall ("{call CreateAppointment(?,?,?,?,?,?,?)}");
			}
			else
			{
				proc = connection.prepareCall ("{call UpdateAppointment(?,?,?,?,?,?,?)}");
				proc.setInt (index++, appointment.getAppointmentNo ());
			}
			
			proc.setInt (index++, appointment.getClient ().getClientNo ());
			proc.setInt (index++, appointment.getEmployee ().getEmployeeNo ());
			proc.setDate (index++, new java.sql.Date(appointment.getDate ().getTime()));
			proc.setTime (index++, new java.sql.Time(appointment.getStartTime ().getTime()));
			proc.setTime (index++, new java.sql.Time(appointment.getEndTime ().getTime()));
			proc.setBoolean (index++, appointment.getIsComplete ());
			
			if (appointment.getAppointmentNo () == null)
			{
				proc.registerOutParameter ("p_key", java.sql.Types.BIGINT);
			}
			
			int updated = proc.executeUpdate ();
			
			if (updated > 0)
			{
				result = true;
				if (appointment.getAppointmentNo () == null)
					appointment.setAppointmentNo (proc.getInt ("p_key"));
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
		{
			try
			{
				Connection connection = super.getConnection ();

				// Erase any existing products for this service.
				CallableStatement proc = connection.prepareCall ("{call DeleteAppointmentProducts(?)}");

				proc.setInt (1, appointment.getAppointmentNo ());
				int updated = proc.executeUpdate ();

				if (updated < 1)
				{
					LogController.write (this, "No products were removed during update.");
				}
				else
				{
					LogController.write (this, "Products were removed for update.");
				}
				proc.close ();

				if (appointment.getProducts () != null || appointment.getProducts ().size () > 0)
				{
					// Commit all the products for the linking tables.
					for (ProductBean product : appointment.getProducts ().keySet ())
					{
						proc = connection.prepareCall ("{call AddAppointmentProduct(?,?,?)}");
						proc.setInt (1, appointment.getAppointmentNo ());
						proc.setInt (2, product.getProductNo ());
						proc.setInt (3, appointment.getProducts ().get (product));

						updated = proc.executeUpdate ();

						if (updated > 0)
						{
							LogController.write (this, "Added product [" + product.getProductNo () + "] to appointment record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add product [" + product.getProductNo () + "] to appointment.");
							result = false;
						}

						proc.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no products to store for this appointment.");
				}

				CallableStatement proc1 = connection.prepareCall ("{call DeleteAppointmentServices(?)}");

				proc1.setInt (1, appointment.getAppointmentNo ());
				int updated1 = proc1.executeUpdate ();

				if (updated1 < 1)
				{
					LogController.write (this, "No services were removed during update.");
				}
				else
				{
					LogController.write (this, "Services were removed for update.");
				}
				proc1.close ();

				if (appointment.getServices () != null || appointment.getServices ().size () > 0)
				{
					// Commit all the products for the linking tables.
					for (ServiceBean service : appointment.getServices ().keySet ())
					{
						proc1 = connection.prepareCall ("{call AddAppointmentService(?,?,?)}");
						proc1.setInt (1, appointment.getAppointmentNo ());
						proc1.setInt (2, service.getServiceNo ());
						proc1.setInt (3, appointment.getServices ().get (service));
						
						updated1 = proc1.executeUpdate ();
						
						if (updated1 > 0)
						{
							LogController.write (this, "Added service [" + service.getServiceNo () + "] to appointment record.");
							result = true;
						}
						else
						{
							LogController.write (this, "Unable to add product [" + service.getServiceNo () + "] to appointment.");
							result = false;
						}

						proc1.close ();
					}
				}
				else
				{
					LogController.write (this, "There are no services to store for this appointment.");
				}

				super.returnConnection (connection);
			}
			catch (SQLException e2)
			{
				LogController.write (this, "There was an exception: " + e2.getMessage ());
				result = false;
			}
		}
		
		if (result)
			LogController.write (this, "Commit appointment bean: "+appointment.getAppointmentNo ());
		
		return result;
	}

	public boolean delete (DataBean data)
	{
		AppointmentBean appointment = (AppointmentBean) data;
		boolean result = false;
		
		if (appointment.getAppointmentNo () != null)
		{
			try
			{
				Connection connection = super.getConnection ();
				CallableStatement proc = connection.prepareCall ("{call DeleteAppointment(?)}");
				
				proc.setInt (1, appointment.getAppointmentNo ());
				
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
		}
		else
		{
			result = false;
		}
		
		if (result)
			LogController.write (this, "Deleted appointment bean: "+appointment.getAppointmentNo ());
		
		return result;
	}

	public boolean exists (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported yet.");
	}
}
