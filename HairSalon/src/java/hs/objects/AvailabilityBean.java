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
 * This class contains information or attutibe of the availability of an 
 * Employee.  Upon creation of an instance of the following must be provided:
 * 
 * The day of the week the employee is available, employee this availability 
 * entry is for, the start and end time of the availability.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class AvailabilityBean extends DataBean
{
	public final static int MONDAY = 0;
	public final static int TUESDAY = 1;
	public final static int WEDNESDAY = 2;
	public final static int THURSDAY = 3;
	public final static int FRIDAY = 4;
	public final static int SATURDAY = 5;
	public final static int SUNDAY = 6;
	
    /**
     * The day of the week the employee is available.
     */
    
    private Integer day;
    /**
     * The employee this availability entry is for.
     */
    private Integer employeeNo;
    /*
     * This is the start time of the availability. 
     */
    private Date startTime;
    /*
     * This is the end time of the availability. 
     */
    private Date endTime;

    /**
     *  Default constructor for person object.
     */
    public AvailabilityBean ()
    {
		
    }
	
	public void clone (AvailabilityBean bean)
	{
		this.setDay (bean.getDay ());
		this.setEmployeeNo (bean.getEmployeeNo ());
		this.setStartTime (bean.getStartTime ());
		this.setEndTime (bean.getEndTime ());
	}
	
    /**
     * Sets the day the employee is available.
     * @param  day an integer of the day the employee is available.
     */
    public void setDay (Integer day)
    {
        this.day = day;
    }

    /**
     * Sets the employee this availability entry is for.
     * @param  employee an Object for the employee this availability 
     *                      entry is for.
     */
    public void setEmployeeNo (Integer employeeNo)
    {
        this.employeeNo = employeeNo;
    }

    /**
     * Sets the end time of the availability.
     * @param  endTime a time for the end time of the availability. 
     */
    public void setEndTime (Date endTime)
    {
        this.endTime = endTime;
    }

    /**
     * Sets the start time of the availability.
     * @param  startTime a time for the start time of the availability. 
     */
    public void setStartTime (Date startTime)
    {
        this.startTime = startTime;
    }

    /**
     * Returns the day the employee is available.
     * @return an integer of the day the employee is available.
     */
    public Integer getDay ()
    {
        return day;
    }

    /**
     * Returns the employee this availability entry is for.
     * @return an Object of the employee this availability entry is for.
     */
    public Integer getEmployeeNo ()
    {
        return employeeNo;
    }

    /**
     * Returns the the end time of the availability. 
     * @return a time for the the end time of the availability. 
     */
    public Date getEndTime ()
    {
        return endTime;
    }

    /**
     * Returns the the start time of the availability. 
     * @return a time for the the start time of the availability. 
     */
    public Date getStartTime ()
    {
        return startTime;
    }
	
	public int compare (Object o1, Object o2)
	{
		AvailabilityBean a1 = (AvailabilityBean)o1;
		AvailabilityBean a2 = (AvailabilityBean)o2;
		
		int result1 = a1.getEmployeeNo ().compareTo (a2.getEmployeeNo ());
		int result2 = a1.getDay ().compareTo (a2.getDay ());
		
		return (result1 - result2);
	}
	
	@Override
	public boolean equals (Object o)
	{
		AvailabilityBean a = (AvailabilityBean)o;
		
		boolean result1 = a.getEmployeeNo ().equals (this.getEmployeeNo ());
		boolean result2 = a.getDay ().equals (this.getDay ());
		
		return (result1 && result2);
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 61 * hash + (this.day != null ? this.day.hashCode () : 0);
		hash = 61 * hash + (this.employeeNo != null ? this.employeeNo.hashCode () : 0);
		return hash;
	}
}
