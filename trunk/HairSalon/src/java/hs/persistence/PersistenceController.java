/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.persistence;

import java.sql.*;
import java.util.*;

import hs.core.*;
import hs.objects.*;
import hs.persistence.brokers.*;

/**
 * The persistence control hub for all bean types. It can perform any kind of
 * persistence type request and it will use the appropriate broker based on
 * the databean type.
 * 
 * @author Philippe Durand
 */
public class PersistenceController
{
	private static Hashtable<Class, BrokerInterface> brokers = new Hashtable<Class, BrokerInterface> ();
	private static DataConnectionPool connectionPool;
	
	public static void initialize (String url, String username, String password)
	{
		DataConnectionPool connectionPool = DataConnectionPool.getInstance ();
		try
		{
			connectionPool.initialize (url, username, password);
		}
		catch (ClassNotFoundException cnfe)
		{
			LogController.write ("PersistenceController->ClassNotFoundException while initializing the manager");
			return;
		}
		catch (InstantiationException ie)
		{
			LogController.write ("PersistenceController->InstantiationException while initializing the manager");
			return;
		}
		catch (IllegalAccessException iae)
		{
			LogController.write ("PersistenceController->IllegalAccessException while initializing the manager");
			return;
		}
		catch (SQLException sqle)
		{
			LogController.write ("PersistenceController->SQLException while initializing the manager: " + sqle.getMessage ());
			return;
		}

		LogController.write ("PersistenceController->Done initializing the database.");

		try
		{
			// Initialize all the brokers we use here.
			brokers.put (Class.forName ("hs.objects.AddressBean"), AddressBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.AppointmentBean"), AppointmentBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.AvailabilityExceptionBean"), AvailabilityExceptionBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ClientBean"), ClientBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.EmployeeBean"), EmployeeBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ProductBean"), ProductBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.SaleBean"), SaleBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.SalonBean"), SalonBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ScheduleBean"), ScheduleBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ScheduleHoursBean"), ScheduleHoursBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ScheduleExceptionBean"), ScheduleExceptionBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ServiceBean"), ServiceBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.SupplierBean"), SupplierBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.AlertBean"), AlertBroker.getInstance ());
		}
		catch (ClassNotFoundException ex)
		{
			LogController.write ("PersistenceController->Class not found: " + ex.getMessage ());
			return;
		}
		
		LogController.write ("PersistenceController->Done registering the brokers.");
	}
	
	public static void shutdown ()
	{
		if (connectionPool != null)
		{
			connectionPool.closeConnections ();
			
			connectionPool.destroy ();
			
			connectionPool = null;
		}
	}

	private static BrokerInterface getBrokerForType (Class type) throws BrokerNotFoundException
	{
		if (brokers.containsKey (type))
		{
			return brokers.get (type);
		}
		else
		{
			String error = "PersistenceController->Unable to find broker with type: " + type.getCanonicalName ();
			LogController.write (error);
			throw new BrokerNotFoundException (error);
		}
	}

	public static DataBean load (DataBean data)
	{
		try
		{
			BrokerInterface broker = getBrokerForType (data.getClass ());
			return broker.load (data);
		}
		catch (BrokerNotFoundException ex)
		{
			return null;
		}
	}
	
	public static DataBean[] search (DataBean data)
	{
		try
		{
			BrokerInterface broker = getBrokerForType (data.getClass ());
			return broker.search (data);
		}
		catch (BrokerNotFoundException ex)
		{
			return null;
		}
	}

	public static boolean exists (DataBean data)
	{
		try
		{
			BrokerInterface broker = getBrokerForType (data.getClass ());
			return broker.exists (data);
		}
		catch (BrokerNotFoundException ex)
		{
			return false;
		}
	}

	public static boolean commit (DataBean data)
	{
		try
		{
			BrokerInterface broker = getBrokerForType (data.getClass ());
			return broker.commit (data);
		}
		catch (BrokerNotFoundException ex)
		{
			return false;
		}
	}

	public static boolean delete (DataBean data)
	{
		try
		{
			BrokerInterface broker = getBrokerForType (data.getClass ());
			return broker.delete (data);
		}
		catch (BrokerNotFoundException ex)
		{
			return false;
		}
	}
}
