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
 * This abstract bean holds information about a person in general.
 * 
 * @author Horace Wan
 */
public abstract class PersonBean extends DataBean implements Comparable
{
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
	 *  Default constructor for person bean.
	 */
	public PersonBean ()
	{
	}

	public void setFirstName (String firstName)
	{
		this.firstName = firstName;
	}

	public void setLastName (String lastName)
	{
		this.lastName = lastName;
	}

	public void setPhoneNumber (String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	public String getFirstName ()
	{
		return firstName;
	}

	public String getLastName ()
	{
		return lastName;
	}

	public String getPhoneNumber ()
	{
		return phoneNumber;
	}

	public String toString ()
	{
		return firstName + " " + lastName + " " + phoneNumber + "\n";
	}

	public String getName ()
	{
		return getLastName () + ", " + getFirstName ();
	}

	public int compareTo (Object o)
	{
		EmployeeBean a = (EmployeeBean) o;
		int i = 0;

		i += getFirstName ().compareTo (a.getFirstName ());
		i += getLastName ().compareTo (a.getLastName ());
		i += getPhoneNumber ().compareTo (a.getPhoneNumber ());

		return i;
	}

	@Override
	public boolean equals (Object o)
	{
		EmployeeBean a = (EmployeeBean) o;
		boolean result = true;

		if (result)
		{
			result = a.getFirstName ().equals (this.getFirstName ());
		}
		if (result)
		{
			result = a.getLastName ().equals (this.getLastName ());
		}
		if (result)
		{
			result = a.getPhoneNumber ().equals (this.getPhoneNumber ());
		}
		return result;
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 43 * hash + (this.firstName != null ? this.firstName.hashCode () : 0);
		hash = 43 * hash + (this.lastName != null ? this.lastName.hashCode () : 0);
		hash = 43 * hash + (this.phoneNumber != null ? this.phoneNumber.hashCode () : 0);
		return hash;
	}
}
