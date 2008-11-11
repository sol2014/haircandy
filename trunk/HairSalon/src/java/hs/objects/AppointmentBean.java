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
 * This class contains information or attutibe of an appointment object.
 * This object represents an entry within the schedule.  Upon creation 
 * of an instance of the following must be provided:
 * 
 * The Client for this appointment, the Service(s) to be perform for this 
 * client and the product to be purchase after the appointment is complete.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class AppointmentBean extends TimeSlotBean
{
    /**
     * A key pair for the product(s) sold in this sale.
     */
    private Hashtable<ProductBean, Integer> products = new Hashtable<ProductBean, Integer> ();

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
;
    /**
     * A key pair for the service(s) performed in this sale.
     */
    private Hashtable<ServiceBean, Integer> services = new Hashtable<ServiceBean, Integer> ();;
	
    /**
     * The client associated with the appointment.
     */
    private ClientBean client;

	public EmployeeBean getEmployee ()
	{
		return employee;
	}

	public void setEmployee (EmployeeBean employee)
	{
		this.employee = employee;
	}
	private EmployeeBean employee;
    /**
     * The tag to show if the appointment is cancelled.
     */
    private Boolean isComplete = false;
    /**
     * The appointment identification number.
     */
    private Integer appointmentNo;

    /**
     *  Default constructor for person object.
     */
    public AppointmentBean ()
    {
    }

    /**
     * Returns the appointment identification number.
     * @return an integer for the appointment identification number.
     */
    public Integer getAppointmentNo ()
    {
        return appointmentNo;
    }

    /**
     * Returns the client associated with the appointment.
     * @return an Object for the client associated with the appointment.
     */
    public ClientBean getClient ()
    {
        return client;
    }

    /**
     * Returns a tag to show if the appointment is cancelled.
     * @return a tag to show if the appointment is cancelled.
     */
    public Boolean getIsComplete ()
    {
        return isComplete;
    }

    /**
     * Sets the the appointment identification number. 
     * @param appointmentNo an integer for the appointment identification 
     *                          number.
     */
    public void setAppointmentNo (Integer appointmentNo)
    {
        this.appointmentNo = appointmentNo;
    }

    /**
     * Sets the client associated with the appointment.
     * @param client an Object for the client associated with the appointment.
     */
    public void setClient (ClientBean client)
    {
        this.client = client;
    }

    /**
     * Sets the tag to show if the appointment is cancelled.
     * @param isCancelled a boolean tag to show if the appointment is 
     *              cancelled.
     */
    public void setIsComplete (Boolean isComplete)
    {
        this.isComplete = isComplete;
    }
	
	public int compare (Object o1, Object o2)
	{
		AppointmentBean a1 = (AppointmentBean)o1;
		AppointmentBean a2 = (AppointmentBean)o2;
		
		return a1.getAppointmentNo ().compareTo (a2.getAppointmentNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		AppointmentBean a = (AppointmentBean)o;
		
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
