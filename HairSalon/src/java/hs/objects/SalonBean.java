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
 * This bean holds information about the salon itself. It can be used
 * across the system to obtain information setup by management of the salon.
 * 
 * @author Horace Wan
 */
public class SalonBean extends DataBean implements Comparable
{
	/**
	 *  The tax rate that all sales use when taking payment.
	 */
	private Double taxRate;
	/**
	 * The list of schedule exceptions that should be used when excluding
	 * days from the scheduler.
	 */
	private ArrayList<ScheduleExceptionBean> exceptions = null;
	/**
	 *  An array of schedule entries for the salon.
	 */
	private ArrayList<ScheduleBean> schedules = null;
	/**
	 * The salon's name.
	 */
	private String name;
	/**
	 * The salon's first address line.
	 */
	private String address1;
	/**
	 * The salon's second address line.
	 */
	private String address2;
	/**
	 * The salon's city.
	 */
	private String city;
	/**
	 * The salon's province.
	 */
	private String province;
	/**
	 * The salon's country.
	 */
	private String country;
	/**
	 *  The salon's postal code
	 */
	private String postalCode;
	/**
	 *  The salon's phone number.
	 */
	private String phoneNumber;
	/**
	 *  The salon's e-mail address.
	 */
	private String email;
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
	 *  Default constructor for the salon bean.
	 */
	public SalonBean ()
	{
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

	public ArrayList<ScheduleExceptionBean> getExceptions ()
	{
		return exceptions;
	}

	public void setExceptions (ArrayList<ScheduleExceptionBean> exceptions)
	{
		this.exceptions = exceptions;
	}

	public ArrayList<ScheduleBean> getSchedules ()
	{
		return schedules;
	}

	public void setSchedules (ArrayList<ScheduleBean> schedules)
	{
		this.schedules = schedules;
	}

	public void setAddress1 (String address1)
	{
		this.address1 = address1;
	}

	public void setAddress2 (String address2)
	{
		this.address2 = address2;
	}

	public void setCity (String city)
	{
		this.city = city;
	}

	public void setCountry (String country)
	{
		this.country = country;
	}

	public void setProvince (String province)
	{
		this.province = province;
	}
	
	public void setEmail (String email)
	{
		this.email = email;
	}

	public void setName (String name)
	{
		this.name = name;
	}

	public void setPhoneNumber (String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	public void setPostalCode (String postalCode)
	{
		this.postalCode = postalCode;
	}

	public void setTaxRate (Double taxRate)
	{
		this.taxRate = taxRate;
	}

	public String getAddress1 ()
	{
		return address1;
	}

	public String getAddress2 ()
	{
		return address2;
	}

	public String getCity ()
	{
		return city;
	}

	public String getCountry ()
	{
		return country;
	}

	public String getProvince ()
	{
		return province;
	}
	
	public String getEmail ()
	{
		return email;
	}

	public String getName ()
	{
		return name;
	}

	public String getPhoneNumber ()
	{
		return phoneNumber;
	}

	public String getPostalCode ()
	{
		return postalCode;
	}

	public Double getTaxRate ()
	{
		return taxRate;
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

	public int compareTo (Object o)
	{
		return 0;
	}

	@Override
	public boolean equals (Object o)
	{
		return true;
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 19 * hash + (this.name != null ? this.name.hashCode () : 0);
		hash = 19 * hash + (this.phoneNumber != null ? this.phoneNumber.hashCode () : 0);
		return hash;
	}
}
