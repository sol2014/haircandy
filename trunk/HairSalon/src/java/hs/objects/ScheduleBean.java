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

/**
 * This bean holds information about one schedule entry for the salon. A entry
 * is what allows appointments to be booked into the schedule. An employee can
 * have many schedule entries throughout the day (split-shifts).
 * 
 * @author Horace Wan
 */
public class ScheduleBean extends TimeSlotBean implements Comparable
{
	/**
	 * The employee that the schedule entry is for.
	 */
	private EmployeeBean employee;
	/**
	 * The schedule entry identification number.
	 */
	private Integer ScheduleNo;

	/**
	 *  Default constructor for person object.
	 */
	public ScheduleBean ()
	{
	}

	public void setScheduleNo (Integer ScheduleNo)
	{
		this.ScheduleNo = ScheduleNo;
	}

	public void setEmployee (EmployeeBean employees)
	{
		this.employee = employees;
	}

	public Integer getScheduleNo ()
	{
		return ScheduleNo;
	}

	public EmployeeBean getEmployee ()
	{
		return employee;
	}

	@Override
	public int compareTo (Object o)
	{
		ScheduleBean a = (ScheduleBean) o;

		return getScheduleNo ().compareTo (a.getScheduleNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		ScheduleBean a = (ScheduleBean) o;

		return (a.getScheduleNo ().equals (this.getScheduleNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 97 * hash + (this.ScheduleNo != null ? this.ScheduleNo.hashCode () : 0);
		return hash;
	}
}