/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.objects;

import java.util.Hashtable;

/**
 * This bean holds client appointment information and links the employee
 * with the client for a specific date. It also provides the services that
 * are scheduled to be performed during that time and how long this will take.
 * 
 * @author Horace Wan
 */
public class AppointmentBean extends TimeSlotBean implements Comparable
{
	/**
	 * A hashtable of the products to be sold after this appointment, and the quantity for each.
	 */
	private Hashtable<ProductBean, Integer> products = new Hashtable<ProductBean, Integer> ();
	/**
	 * A hashtable of the services to be performed during this appointment, and the quantity for each.
	 */
	private Hashtable<ServiceBean, Integer> services = new Hashtable<ServiceBean, Integer> ();
	/**
	 * The client that is coming in for this appointment.
	 */
	private ClientBean client = null;
	/**
	 * The employee that is to perform the services included in this appointment.
	 */
	private EmployeeBean employee = null;
	/**
	 * The flag of whether this appointment has been completed with a sale.
	 */
	private Boolean isComplete = false;
	/**
	 * The identification number of this appointment.
	 */
	private Integer appointmentNo = null;

	/**
	 *  Default constructor for appointment bean.
	 */
	public AppointmentBean ()
	{
	}

	public EmployeeBean getEmployee ()
	{
		return employee;
	}

	public void setEmployee (EmployeeBean employee)
	{
		this.employee = employee;
	}

	public Hashtable<ProductBean, Integer> getProducts ()
	{
		return products;
	}

	public void setProducts (Hashtable products)
	{
		this.products = products;
	}

	public Hashtable<ServiceBean, Integer> getServices ()
	{
		return services;
	}

	public void setServices (Hashtable services)
	{
		this.services = services;
	}

	public Integer getAppointmentNo ()
	{
		return appointmentNo;
	}

	public ClientBean getClient ()
	{
		return client;
	}

	public Boolean getIsComplete ()
	{
		return isComplete;
	}

	public void setAppointmentNo (Integer appointmentNo)
	{
		this.appointmentNo = appointmentNo;
	}

	public void setClient (ClientBean client)
	{
		this.client = client;
	}

	public void setIsComplete (Boolean isComplete)
	{
		this.isComplete = isComplete;
	}

	public int compareTo (Object o)
	{
		AppointmentBean a = (AppointmentBean) o;

		return getAppointmentNo ().compareTo (a.getAppointmentNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		AppointmentBean a = (AppointmentBean) o;

		return (a.getAppointmentNo ().equals (this.getAppointmentNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 41 * hash + (this.appointmentNo != null ? this.appointmentNo.hashCode () : 0);
		return hash;
	}
}
