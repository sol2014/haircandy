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
 * This bean holds information about a schedule day's hours of operation. These
 * are created from the times specified in the salon bean, but can be modified
 * after they are originally created by the manager.
 * 
 * @author Horace Wan
 */
public class ScheduleHoursBean extends TimeSlotBean implements Comparable
{
	/**
	 *  Default constructor for schedule hours bean.
	 */
	public ScheduleHoursBean ()
	{
	}

	@Override
	public int compareTo (Object o)
	{
		ScheduleBean a = (ScheduleBean) o;

		return getDate ().compareTo (a.getDate ());
	}

	@Override
	public boolean equals (Object o)
	{
		ScheduleBean a = (ScheduleBean) o;

		return (a.getDate ().equals (this.getDate ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		return hash;
	}
}