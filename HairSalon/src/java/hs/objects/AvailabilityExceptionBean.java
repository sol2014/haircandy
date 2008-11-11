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
 * This bean holds the availability exceptions that an employee can create
 * for him/herself. They allow the employee to enforce restrictions for 
 * scheduling when the manager is creating the schedule.
 * 
 * @author Horace Wan
 */
public class AvailabilityExceptionBean extends DataBean implements Comparable
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
	
	/**
	 * Clones the information of the passed bean into this one.
	 * 
	 * @param exception the exception information to clone.
	 */
	public void clone (AvailabilityExceptionBean exception)
	{
		this.setDate (exception.getDate());
		this.setEmployeeNo (exception.getEmployeeNo());
		this.setReason (exception.getReason ());
	}
	
    public void setDate (Date date)
    {
        this.date = date;
    }

    public void setEmployeeNo (Integer employeeNo)
    {
        this.employeeNo = employeeNo;
    }
	
    public void setReason (String reason)
    {
        this.reason = reason;
    }
	
    public Date getDate ()
    {
        return date;
    }
	
    public Integer getEmployeeNo ()
    {
        return employeeNo;
    }
	
    public String getReason ()
    {
        return reason;
    }
	
	public int compareTo (Object o)
	{
		AvailabilityExceptionBean a = (AvailabilityExceptionBean)o;
		
		int result1 = getEmployeeNo ().compareTo (a.getEmployeeNo ());
		int result2 = getDate ().compareTo (a.getDate ());
		
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

	@Override
	public int hashCode ()
	{
		int hash = 5;
		hash = 19 * hash + (this.date != null ? this.date.hashCode () : 0);
		hash = 19 * hash + (this.employeeNo != null ? this.employeeNo.hashCode () : 0);
		return hash;
	}
}

