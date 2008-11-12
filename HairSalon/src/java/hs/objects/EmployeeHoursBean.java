/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.objects;

/**
 * This bean holds information about an employees's available hours on days
 * that are already scheduled. These are created from the times specified in
 * the employee bean, but can be modified after they are originally created 
 * by the employee.
 * 
 * @author Philippe Durand
 */
public class EmployeeHoursBean extends TimeSlotBean implements Comparable
{
	/**
	 * The employee identification number this set of hours is for.
	 */
	private Integer employeeNo = null;
	
	/**
	 *  Default constructor for employee hours bean.
	 */
	public EmployeeHoursBean ()
	{
	}

	public Integer getEmployeeNo ()
	{
		return employeeNo;
	}

	public void setEmployeeNo (Integer employeeNo)
	{
		this.employeeNo = employeeNo;
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
		int hash = 5;
		hash = 59 * hash + (this.employeeNo != null ? this.employeeNo.hashCode () : 0);
		return hash;
	}
}