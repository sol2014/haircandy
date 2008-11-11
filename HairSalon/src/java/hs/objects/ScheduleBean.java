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
public class ScheduleBean extends TimeSlotBean implements Comparator
{
    /**
     * The employee that the schedule belongs to.
     */
    private EmployeeBean employee;
    /**
     * The schedule identification number.
     */
    private Integer ScheduleNo;

    /**
     *  Default constructor for person object.
     */
    public ScheduleBean ()
    {
    }

    /**
     * Sets the schedule identification number.
     * @param ScheduleNo a string for the schedule identification number.
     */
    public void setScheduleNo (Integer ScheduleNo)
    {
        this.ScheduleNo = ScheduleNo;
    }


    /**
     * Sets the employee that the schedule belongs to.
     * @param employees an object for the employee that the schedule belongs to.
     */
    public void setEmployee (EmployeeBean employees)
    {
        this.employee = employees;
    }

    /**
     * Gets the schedule identification number.
     * @return a string for the schedule identification number.
     */
    public Integer getScheduleNo ()
    {
        return ScheduleNo;
    }

    /**
     * Gets the employee that the schedule belongs to.
     * @return an object for the employee that the schedule belongs to.
     */
    public EmployeeBean getEmployee ()
    {
        return employee;
    }

	
	public int compare (Object o1, Object o2)
	{
		ScheduleBean a1 = (ScheduleBean)o1;
		ScheduleBean a2 = (ScheduleBean)o2;
		
		return a1.getScheduleNo ().compareTo (a2.getScheduleNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ScheduleBean a = (ScheduleBean)o;
		
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