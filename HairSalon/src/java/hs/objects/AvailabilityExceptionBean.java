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

import java.util.*;

/**
 * This class contains information or attutibe of an Availability
 * Exception object.  This object represents an exception class for 
 * employee’s availability.  Upon creation of an instance of the following 
 * must be provided:
 *  
 * The date, reason, start time and end time of the availability exception,
 * plus the employee information.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class AvailabilityExceptionBean extends DataBean
{
    /**
     * The date of the availability exception occurs.
     */
    private Date date = null;
    /**
     * The reason the availability exception occurs.
     */
    private String reason = null;
    /**
     * The employee this availability exception is entered for.
     */
    private Integer employeeNo = null;

    /**
     *  Default constructor for person object.
     */
    public AvailabilityExceptionBean ()
    {
    }
	
	public void clone (AvailabilityExceptionBean exception)
	{
		this.setDate (exception.getDate());
		this.setEmployeeNo (exception.getEmployeeNo());
		this.setReason (exception.getReason ());
	}
	
    /**
     * Sets the date of the availability exception occurs.
     * @param date the date of the availability exception occurs.
     */
    public void setDate (Date date)
    {
        this.date = date;
    }

    /**
     * Sets the employee this availability exception is entered for.
     * @param employee an Object for the employee this availability exception 
     *                  is entered for.
     */
    public void setEmployeeNo (Integer employeeNo)
    {
        this.employeeNo = employeeNo;
    }

    /**
     * Sets the reason the availability exception occurs.
     * @param reason a string for the reason the availability exception occurs.
     */
    public void setReason (String reason)
    {
        this.reason = reason;
    }
	
    /**
     * Returns the date of the availability exception occurs.
     * @return the date of the availability exception occurs.
     */
    public Date getDate ()
    {
        return date;
    }

    /**
     * Returns the employee this availability exception is entered for.
     * @return an Object for the employee this availability exception is 
     *              entered for.
     */
    public Integer getEmployeeNo ()
    {
        return employeeNo;
    }

    /**
     * Returns the reason the availability exception occurs.
     * @return a string for the reason the availability exception occurs.
     */
    public String getReason ()
    {
        return reason;
    }
	
	public int compare (Object o1, Object o2)
	{
		AvailabilityExceptionBean a1 = (AvailabilityExceptionBean)o1;
		AvailabilityExceptionBean a2 = (AvailabilityExceptionBean)o2;
		
		int result1 = a1.getEmployeeNo ().compareTo (a2.getEmployeeNo ());
		int result2 = a1.getDate ().compareTo (a2.getDate ());
		
		return (result1 - result2);
	}
	
	@Override
	public boolean equals (Object o)
	{
		AvailabilityExceptionBean a = (AvailabilityExceptionBean)o;
		
		boolean result1 = a.getEmployeeNo ().equals (this.getEmployeeNo ());
		boolean result2 = a.getDate ().equals (this.getDate ());
		
		return (result1 && result2);
	}
}

