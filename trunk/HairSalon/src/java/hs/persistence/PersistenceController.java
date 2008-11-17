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

	/**
	 * Initializes the JDBC connection pool as well as connects all of the
	 * data beans with their respective persistence brokers.
	 * 
	 * @param url the JDBC database URL to use for the connection pool.
	 * @param username the username to use with the connection pool.
	 * @param password the password to use with the connection pool.
	 */
	public static void initialize (String url, String username, String password)
	{
		MultithreadedJDBCConnectionPool connectionPool = MultithreadedJDBCConnectionPool.getConnectionPool ("com.mysql.jdbc.Driver", url, username, password);

		LogController.write ("PersistenceController->Done initializing the database.");

		try
		{
			// Initialize all the brokers we use here.
			brokers.put (Class.forName ("hs.objects.AddressBean"), AddressBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.AppointmentBean"), AppointmentBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.AvailabilityExceptionBean"), AvailabilityExceptionBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.ClientBean"), ClientBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.EmployeeBean"), EmployeeBroker.getInstance ());
			brokers.put (Class.forName ("hs.objects.EmployeeHoursBean"), EmployeeHoursBroker.getInstance ());
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
	
	/**
	 * Performs any cleanup that must be done when shutting down.
	 */
	public static void shutdown ()
	{
		
	}

	/**
	 * Obtains the broker for the following data bean class type.
	 * 
	 * @param type the data bean type to use.
	 * @return the broker interface to use for this data bean type.
	 * @throws hs.persistence.BrokerNotFoundException
	 */
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

	/**
	 * Performs loading of any data bean.
	 * 
	 * @param data the data bean to load.
	 * @return the loaded data bean.
	 */
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

	/**
	 * Performs searching of data beans using data bean as criteria.
	 * 
	 * @param data the data bean to search with.
	 * @return the array of data beans that is found.
	 */
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

	/**
	 * Performs a check to see if the data bean exists in the database.
	 * 
	 * @param data the data bean to check for.
	 * @return whether the data bean exists in the database.
	 */
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

	/**
	 * Performs commit of a data bean to the database.
	 * 
	 * @param data the data bean to commit.
	 * @return whether the data bean was commit successfully.
	 */
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

	/**
	 * Performs deletion of a data bean from the database.
	 * 
	 * @param data the data bean to delete.
	 * @return whether the data bean was deleted or not.
	 */
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
