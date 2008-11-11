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
 * This bean holds information about employees who are created by managers
 * and can then login to the system and book appointments or view the schedule.
 * 
 * @author Horace Wan
 */
public class EmployeeBean extends PersonBean implements Comparable
{
	/**
	 * The password this employee will use to log into the system.
	 */
	private String password = null;
	/**
	 * The list of services that this employee can provide the clients.
	 */
	private ArrayList<ServiceBean> services = new ArrayList<ServiceBean> ();
	/**
	 * The role that decides the employee's access to functionality in the system.
	 */
	private String role = null;
	/**
	 * The identification number of the employee.
	 */
	private Integer employeeNo = null;
	/**
	 * The flag used to enable or disable the employee in the system.
	 */
	private boolean enabled = true;
	/**
	 * The address bean attached to this employee.
	 */
	private AddressBean address = null;
	/**
	 * A list of availability exceptions that this employee has in effect.
	 */
	private ArrayList<AvailabilityExceptionBean> availabilityExceptions = new ArrayList<AvailabilityExceptionBean> ();
	private Date mondayStart = null;
	private Date mondayEnd = null;
	private Date tuesdayStart = null;
	private Date tuesdayEnd = null;
	private Date wednesdayStart = null;
	private Date wednesdayEnd = null;
	private Date thursdayStart = null;
	private Date thursdayEnd = null;
	private Date fridayStart = null;
	private Date fridayEnd = null;
	private Date saturdayStart = null;
	private Date saturdayEnd = null;
	private Date sundayStart = null;
	private Date sundayEnd = null;

	/**
	 *  Default constructor for the employee bean.
	 */
	public EmployeeBean ()
	{
	}

	public boolean getEnabled ()
	{
		return enabled;
	}

	public void setEnabled (boolean enabled)
	{
		this.enabled = enabled;
	}

	public Date getFridayEnd ()
	{
		return fridayEnd;
	}

	public void setFridayEnd (Date fridayEnd)
	{
		this.fridayEnd = fridayEnd;
	}

	public Date getFridayStart ()
	{
		return fridayStart;
	}

	public void setFridayStart (Date fridayStart)
	{
		this.fridayStart = fridayStart;
	}

	public Date getMondayEnd ()
	{
		return mondayEnd;
	}

	public void setMondayEnd (Date mondayEnd)
	{
		this.mondayEnd = mondayEnd;
	}

	public Date getMondayStart ()
	{
		return mondayStart;
	}

	public void setMondayStart (Date mondayStart)
	{
		this.mondayStart = mondayStart;
	}

	public Date getSaturdayEnd ()
	{
		return saturdayEnd;
	}

	public void setSaturdayEnd (Date saturdayEnd)
	{
		this.saturdayEnd = saturdayEnd;
	}

	public Date getSaturdayStart ()
	{
		return saturdayStart;
	}

	public void setSaturdayStart (Date saturdayStart)
	{
		this.saturdayStart = saturdayStart;
	}

	public Date getSundayEnd ()
	{
		return sundayEnd;
	}

	public void setSundayEnd (Date sundayEnd)
	{
		this.sundayEnd = sundayEnd;
	}

	public Date getSundayStart ()
	{
		return sundayStart;
	}

	public void setSundayStart (Date sundayStart)
	{
		this.sundayStart = sundayStart;
	}

	public Date getThursdayEnd ()
	{
		return thursdayEnd;
	}

	public void setThursdayEnd (Date thursdayEnd)
	{
		this.thursdayEnd = thursdayEnd;
	}

	public Date getThursdayStart ()
	{
		return thursdayStart;
	}

	public void setThursdayStart (Date thursdayStart)
	{
		this.thursdayStart = thursdayStart;
	}

	public Date getTuesdayEnd ()
	{
		return tuesdayEnd;
	}

	public void setTuesdayEnd (Date tuesdayEnd)
	{
		this.tuesdayEnd = tuesdayEnd;
	}

	public Date getTuesdayStart ()
	{
		return tuesdayStart;
	}

	public void setTuesdayStart (Date tuesdayStart)
	{
		this.tuesdayStart = tuesdayStart;
	}

	public Date getWednesdayEnd ()
	{
		return wednesdayEnd;
	}

	public void setWednesdayEnd (Date wednesdayEnd)
	{
		this.wednesdayEnd = wednesdayEnd;
	}

	public Date getWednesdayStart ()
	{
		return wednesdayStart;
	}

	public void setWednesdayStart (Date wednesdayStart)
	{
		this.wednesdayStart = wednesdayStart;
	}

	public void setEmployeeNo (Integer employeeNo)
	{
		this.employeeNo = employeeNo;
	}

	public void setPassword (String password)
	{
		this.password = password;
	}

	public void setRole (String role)
	{
		this.role = role;
	}

	public void setAddress (AddressBean address)
	{
		this.address = address;
	}

	public void setServices (ArrayList<ServiceBean> services)
	{
		this.services = services;
	}

	public ArrayList<ServiceBean> getServices ()
	{
		return services;
	}

	public boolean hasService (ServiceBean service)
	{
		boolean result = false;

		for (ServiceBean cycle : services)
		{
			if (service.getServiceNo ().equals (cycle.getServiceNo ()))
			{
				result = true;
			}
		}

		return result;
	}

	public void addService (ServiceBean service)
	{
		if (!hasService (service))
		{
			services.add (service);
		}
	}

	public void removeService (ServiceBean service)
	{
		if (hasService (service))
		{
			ServiceBean toRemove = null;

			for (ServiceBean cycle : services)
			{
				if (cycle.getServiceNo ().equals (service.getServiceNo ()))
				{
					toRemove = cycle;
				}
			}

			services.remove (toRemove);
		}
	}

	public void setAvailabilityExceptions (ArrayList<AvailabilityExceptionBean> availabilityExceptions)
	{
		this.availabilityExceptions = availabilityExceptions;
	}

	public ArrayList<AvailabilityExceptionBean> getAvailabilityExceptions ()
	{
		return availabilityExceptions;
	}

	public boolean hasException (AvailabilityExceptionBean exception)
	{
		for (AvailabilityExceptionBean cycle : getAvailabilityExceptions ())
		{
			if (cycle.getDate ().equals (exception.getDate ()))
			{
				return true;
			}
		}

		return false;
	}

	public void removeException (AvailabilityExceptionBean exception)
	{
		if (hasException (exception))
		{
			AvailabilityExceptionBean toRemove = null;

			for (AvailabilityExceptionBean cycle : availabilityExceptions)
			{
				if (cycle.getDate ().equals (exception.getDate ()))
				{
					toRemove = cycle;
				}
			}

			availabilityExceptions.remove (toRemove);
		}
	}

	public Integer getEmployeeNo ()
	{
		return employeeNo;
	}

	public String getPassword ()
	{
		return password;
	}

	public String getRole ()
	{
		return role;
	}

	public AddressBean getAddress ()
	{
		return address;
	}
	
	/**
	 * Used to obtain the start time for a specified weekday.
	 * @param weekDay the weekday integer from 0 - 6
	 * @return the date of the weekday's start time.
	 */
	public Date getWeekdayStartTime (int weekDay)
	{
		Date startTime;
		switch (weekDay)
		{
			case 2:
				startTime = getMondayStart ();
				break;
			case 3:
				startTime = getTuesdayStart ();
				break;
			case 4:
				startTime = getWednesdayStart ();
				break;
			case 5:
				startTime = getThursdayStart ();
				break;
			case 6:
				startTime = getFridayStart ();
				break;
			case 7:
				startTime = getSaturdayStart ();
				break;
			case 1:
				startTime = getSundayStart ();
				break;
			default:
				startTime = null;
				break;
		}
		return startTime;
	}

	/**
	 * Used to obtain the end time for a specified weekday.
	 * @param weekDay the weekday integer from 0 - 6
	 * @return the date of the weekday's end time.
	 */
	public Date getWeekdayEndTime (int weekDay)
	{
		Date endTime;
		switch (weekDay)
		{
			case 2:
				endTime = getMondayEnd ();
				break;
			case 3:
				endTime = getTuesdayEnd ();
				break;
			case 4:
				endTime = getWednesdayEnd ();
				break;
			case 5:
				endTime = getThursdayEnd ();
				break;
			case 6:
				endTime = getFridayEnd ();
				break;
			case 7:
				endTime = getSaturdayEnd ();
				break;
			case 1:
				endTime = getSundayEnd ();
				break;
			default:
				endTime = null;
				break;
		}
		return endTime;
	}
	
	@Override
	public int compareTo (Object o)
	{
		EmployeeBean a = (EmployeeBean) o;

		return getEmployeeNo ().compareTo (a.getEmployeeNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		EmployeeBean a = (EmployeeBean) o;

		return (a.getEmployeeNo ().equals (this.getEmployeeNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 3;
		hash = 67 * hash + (this.employeeNo != null ? this.employeeNo.hashCode () : 0);
		return hash;
	}
}
