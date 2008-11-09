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

import java.util.Comparator;

/**
 * This class contains information or attutibe of a person object.
 * Upon creation of an instance of the following must be provided:
 *  
 * Customer's first name, last name, address includes city and country, 
 * postal code, phone number and active status.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public abstract class PersonBean extends DataBean implements Comparator
{
	/**
	 *  The preset String length for each variables.
	 */
	public static final int NAME_LENGTH = 15;
	public static final int PHONE_NUMBER_LENGTH = 10;
	/**
	 *  The person's first name.
	 */
	private String firstName;
	/**
	 *  The person's last name.
	 */
	private String lastName;
	/**
	 *  The person's phone number.
	 */
	private String phoneNumber;

	/**
	 *  Default constructor for person object.
	 */
	public PersonBean ()
	{
	}

	/**
	 *  Set the person's first name.
	 *  @param  firstName a string for the person's first name.
	 */
	public void setFirstName (String firstName)
	{
		this.firstName = firstName;
	}

	/**
	 *  Set the person's last name.
	 *  @param  lastName a string for the person's last name.
	 */
	public void setLastName (String lastName)
	{
		this.lastName = lastName;
	}

	/**
	 *  Set the person's phone number.
	 *  @param  phoneNumber a string for the person's phone number.
	 */
	public void setPhoneNumber (String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	/**
	 *  get the person's first name.
	 *  @return a string for the person's first name.
	 */
	public String getFirstName ()
	{
		return firstName;
	}

	/**
	 *  get the person's last name.
	 *  @return a string for the person's last name.
	 */
	public String getLastName ()
	{
		return lastName;
	}

	/**
	 *  get the person's phone number.
	 *  @return a string for the person's phone number.
	 */
	public String getPhoneNumber ()
	{
		return phoneNumber;
	}

	/**
	 *  A toString method to print out the person's information
	 *  @return a string of person's information
	 */
	public String toString ()
	{
		return firstName + " " + lastName + " " + phoneNumber + "\n";
	}

	public String getName ()
	{
		return getLastName () + ", " + getFirstName ();
	}
	
	public int compare (Object o1, Object o2)
	{
		EmployeeBean a1 = (EmployeeBean)o1;
		EmployeeBean a2 = (EmployeeBean)o2;
		int i = 0;
		
		i += a1.getFirstName().compareTo (a2.getFirstName());
		i += a1.getLastName ().compareTo (a2.getLastName ());
		i += a1.getPhoneNumber ().compareTo (a2.getPhoneNumber ());
		
		return i;
	}
	
	@Override
	public boolean equals (Object o)
	{
		EmployeeBean a = (EmployeeBean)o;
		boolean result = true;
		
		if (result)
			result = a.getFirstName ().equals (this.getFirstName ());
		
		if (result)
			result = a.getLastName ().equals (this.getLastName ());
		
		if (result)
			result = a.getPhoneNumber ().equals (this.getPhoneNumber ());
		
		return result;
	}
}
