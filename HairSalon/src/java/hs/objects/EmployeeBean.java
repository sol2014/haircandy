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

import hs.core.*;

/**
 * This class contains information or attutibe of an Employee object.  
 * This object represents an employee who works for the salon.
 * Upon creation of an instance of the following must be provided:
 *  
 * The password for the employee to login to the system, the service(s) this 
 * employee can provide, the salon(s) this employee belongs to, the role this
 * employee in the salon, the employee idenification number and any 
 * availability exception the employee may has.
 * 
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class EmployeeBean extends PersonBean implements Comparator
{
	/**
	 * The password this employee will use to log in to the system.
	 */
	private String password = null;
	/**
	 * This is a list of services this employee can provides for the client.
	 */
	private ArrayList<ServiceBean> services = new ArrayList<ServiceBean> ();
	/**
	 * The password this employee will use to log in to the system.
	 */
	private String role = null;
	/**
	 * An integer defines the person’s type in the system.
	 */
	private Integer employeeNo = null;
	private boolean enabled = true;

	public boolean getEnabled ()
	{
		return enabled;
	}

	public void setEnabled (boolean enabled)
	{
		this.enabled = enabled;
	}
	/**
	 * The address record attached to this employee.
	 */
	private AddressBean address = null;
	
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
	
	/**
	 * A list of availability exceptions  for the employee (such as birthday, 
	 * religious holidays, etc).
	 */
	private ArrayList<AvailabilityExceptionBean> availabilityExceptions = new ArrayList<AvailabilityExceptionBean> ();

	/**
	 *  Default constructor for person object.
	 */
	public EmployeeBean ()
	{
	}

	/**
	 * Sets the employee idenification number.
	 * @param employeeNo a String for the employee idenification number.
	 */
	public void setEmployeeNo (Integer employeeNo)
	{
		this.employeeNo = employeeNo;
	}

	/**
	 * Sets the password this employee will use to log in to the system.
	 * @param password a String for the password this employee will use to 
	 *                  log in to the system.
	 */
	public void setPassword (String password)
	{
		this.password = password;
	}

	/**
	 * Sets the number defines the person’s type in the system.
	 * @param role an integer to define the person’s type in the system.
	 */
	public void setRole (String role)
	{
		this.role = role;
	}
	
	public void setAddress (AddressBean address)
	{
		this.address = address;
	}
	
	/**
	 * Sets the service(s) employee can provides for the client.
	 * @param service an array of services object this employee can provides
	 *                  for the client.
	 */
	public void setServices (ArrayList<ServiceBean> services)
	{
		this.services = services;
	}

	/**
	 * Returns the service this employee can provides for the client.
	 * @return service an array of services object this employee can provides
	 *                  for the client.
	 */
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
				result = true;
		}
		
		return result;
	}
	
	public void addService (ServiceBean service)
	{
		if (!hasService (service))
			services.add (service);
	}
	
	public void removeService (ServiceBean service)
	{
		if (hasService (service))
		{
			ServiceBean toRemove = null;
			
			for (ServiceBean cycle : services)
			{
				if (cycle.getServiceNo ().equals (service.getServiceNo ()))
					toRemove = cycle;
			}
			
			services.remove (toRemove);
		}
	}
	
	/**
	 * Sets the availability exceptions for the employee .
	 * @param availabilityException an array of availability exceptions 
	 *                                  for the employee 
	 */
	public void setAvailabilityExceptions (ArrayList<AvailabilityExceptionBean> availabilityExceptions)
	{
		this.availabilityExceptions = availabilityExceptions;
	}
	
	/**
	 * Returns an array of availability exceptions for the employee.
	 * @return availabilityException an array of availability exceptions 
	 *                                  for the employee 
	 */
	public ArrayList<AvailabilityExceptionBean> getAvailabilityExceptions ()
	{
		return availabilityExceptions;
	}
	
	public boolean hasException (AvailabilityExceptionBean exception)
	{
		for (AvailabilityExceptionBean cycle : getAvailabilityExceptions())
		{
			if (cycle.getDate ().equals (exception.getDate ()))
				return true;
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
					toRemove = cycle;
			}
			
			availabilityExceptions.remove (toRemove);
		}
	}
	
	/**
	 * Returns the employee idenification number.
	 * @return employeeNo a String for the employee idenification number.
	 */
	public Integer getEmployeeNo ()
	{
		return employeeNo;
	}

	/**
	 * Returns password a String for the password this employee will use to 
	 *                  log in to the system.
	 * @return password a String for password a String for the password this 
	 *                      employee will use to log in to the system.
	 */
	public String getPassword ()
	{
		return password;
	}

	/**
	 * Returns an integer to define the person’s type in the system. 
	 * @return an integer to define the person’s type in the system. 
	 */
	public String getRole ()
	{
		return role;
	}
	
	public AddressBean getAddress ()
	{
		return address;
	}
	
	@Override
	public int compare (Object o1, Object o2)
	{
		EmployeeBean a1 = (EmployeeBean)o1;
		EmployeeBean a2 = (EmployeeBean)o2;
		
		return a1.getEmployeeNo ().compareTo (a2.getEmployeeNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		EmployeeBean a = (EmployeeBean)o;
		
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
