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
 * This class contains information or attutibe of a schedule exception object.
 * This is an exception class for schedule.  Upon creation of an instance 
 * of the following must be provided:
 *  
 * The date and reason of the exception.
 *   
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class ScheduleExceptionBean extends DataBean implements Comparator
{
	/**
	 * The date of the schedule exception occurs.
	 */
	private Date date;
	/**
	 * The reason of the schedule exception occurs.
	 */
	private String reason;

	/**
	 *  Default constructor for person object.
	 */
	public ScheduleExceptionBean ()
	{
	}

	/** 
	 * Sets the date of the schedule exception occurs.
	 * @param date the date of the schedule exception occurs.
	 */
	public void setDate (Date date)
	{
		this.date = date;
	}

	/**
	 * Sets the reason of the schedule exception occurs.
	 * @param reason a string for the reason of the schedule exception occurs.
	 */
	public void setReason (String reason)
	{
		this.reason = reason;
	}

	/**
	 * Returns the date of the schedule exception occurs.
	 * @return the date of the schedule exception occurs.
	 */
	public Date getDate ()
	{
		return date;
	}

	/**
	 * Returns the reason of the schedule exception occurs.
	 * @return a string for the reason of the schedule exception occurs.
	 */
	public String getReason ()
	{
		return reason;
	}
	
	public int compare (Object o1, Object o2)
	{
		ScheduleExceptionBean a1 = (ScheduleExceptionBean)o1;
		ScheduleExceptionBean a2 = (ScheduleExceptionBean)o2;
		
		return a1.getDate ().compareTo (a2.getDate ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ScheduleExceptionBean a = (ScheduleExceptionBean)o;
		
		return (a.getDate ().equals (this.getDate ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 5;
		hash = 37 * hash + (this.date != null ? this.date.hashCode () : 0);
		return hash;
	}
}