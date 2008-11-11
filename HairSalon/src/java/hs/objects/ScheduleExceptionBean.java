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
 * This bean holds schedule exceptions for the whole salon. These are usually
 * holidays, or special event days the business holds yearly.
 * 
 * @author Horace Wan
 */
public class ScheduleExceptionBean extends DataBean implements Comparable
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
	 *  Default constructor for the schedule exception bean.
	 */
	public ScheduleExceptionBean ()
	{
	}

	public void setDate (Date date)
	{
		this.date = date;
	}

	public void setReason (String reason)
	{
		this.reason = reason;
	}

	public Date getDate ()
	{
		return date;
	}

	public String getReason ()
	{
		return reason;
	}

	public int compareTo (Object o)
	{
		ScheduleExceptionBean a = (ScheduleExceptionBean) o;

		return getDate ().compareTo (a.getDate ());
	}

	@Override
	public boolean equals (Object o)
	{
		ScheduleExceptionBean a = (ScheduleExceptionBean) o;

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