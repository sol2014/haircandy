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
 * This class contains an abstract time slot used for schedule entries and
 * other similar data.
 * 
 * @author Horace Wan
 */
public abstract class TimeSlotBean extends DataBean implements Comparable
{
	/*
	 * This is the date of the time slot. 
	 */
	private Date date;
	/*
	 * This is the start of the time slot. 
	 */
	private Date startTime;
	/*
	 * This is the end of the time slot. 
	 */
	private Date endTime;

	/*
	 * Default constructor for the timeslot bean.
	 */
	public TimeSlotBean ()
	{
	}

	public Date getDate ()
	{
		return date;
	}

	public Date getEndTime ()
	{
		return endTime;
	}

	public Date getStartTime ()
	{
		return startTime;
	}

	public void setDate (Date date)
	{
		this.date = date;
	}

	public void setEndTime (Date endTime)
	{
		this.endTime = endTime;
	}

	public void setStartTime (Date startTime)
	{
		this.startTime = startTime;
	}

	public int compareTo (Object o)
	{
		TimeSlotBean a = (TimeSlotBean) o;
		int result = 0;

		result += getDate ().compareTo (a.getDate ());
		result += getStartTime ().compareTo (a.getStartTime ());
		result += getEndTime ().compareTo (a.getEndTime ());

		return result;
	}

	@Override
	public boolean equals (Object o)
	{
		TimeSlotBean a = (TimeSlotBean) o;
		boolean result = false;
		result = a.getDate ().equals (this.getDate ());
		result = a.getStartTime ().equals (this.getStartTime ());
		result = a.getEndTime ().equals (this.getEndTime ());
		return (result);
	}

	@Override
	public int hashCode ()
	{
		int hash = 5;
		hash = 79 * hash + (this.date != null ? this.date.hashCode () : 0);
		hash = 79 * hash + (this.startTime != null ? this.startTime.hashCode () : 0);
		hash = 79 * hash + (this.endTime != null ? this.endTime.hashCode () : 0);
		return hash;
	}
}