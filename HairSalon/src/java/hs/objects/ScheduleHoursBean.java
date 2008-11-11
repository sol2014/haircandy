/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.objects;  //Group this class in folder %/hairsalon/objects/

import java.util.*;

/**
 * This class contains information or attutibe of a schedule object.
 * This class represents the employee schedule.  Upon creation of an 
 * instance of the following must be provided:
 *  
 * An array of employee, appointment and salon, and the schedule idenification
 * number.
 *   
 * The above attutibe can be obtain by the getter method.
 * 
 * A method to add an appointmnet to the Schedule is provided.
 * @author Horace Wan
 */
public class ScheduleHoursBean extends TimeSlotBean implements Comparator
{
    /**
     *  Default constructor for person object.
     */
    public ScheduleHoursBean ()
    {
    }
	
	public int compare (Object o1, Object o2)
	{
		ScheduleBean a1 = (ScheduleBean)o1;
		ScheduleBean a2 = (ScheduleBean)o2;
		
		return a1.getDate ().compareTo (a2.getDate ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ScheduleBean a = (ScheduleBean)o;
		
		return (a.getDate ().equals (this.getDate ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		return hash;
	}
}