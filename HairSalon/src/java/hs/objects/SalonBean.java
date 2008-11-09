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
 * This class contains information or attutibe of a salon object.
 * Upon creation of an instance of the following must be provided:
 *  
 * The name, first and second line of address, city, country, postal code,
 * phone number, e-mail address of the salon, the salon idenification number,
 * the business hours, the provincial and federal tax rates, the schedule of 
 * the salon, the waiting list, the number of hair sation and the number of 
 * beauty station in the salon.  
 *   
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class SalonBean extends DataBean implements Comparator
{
	/**
	 *  The preset String length for each variables.
	 */
	public static final int ADDRESS_LENGTH = 25;
	public static final int NAME_LENGTH = 15;
	public static final int POSTALCODE_LENGTH = 6;
	public static final int PHONE_NUMBER_LENGTH = 10;
	public static final int EMAIL_LENGTH = 50;
	/**
	 *  The default tax rate the salon charges based on provincial and federal 
	 *  tax rates.
	 */
	private Double taxRate;
	private ArrayList<ScheduleExceptionBean> exceptions = null;

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

	/**
	 *  An array of schedule entries for the salon.
	 */
	private ArrayList<ScheduleBean> schedules = null;
	/**
	 *  The number of hair station in the salon.
	 */
	private Integer hairStations;
	/**
	 *  The number of beauty station in the salon.
	 */
	private Integer beautyStations;
	/**
	 *  The name of the salon.
	 */
	private String name;
	/**
	 *  The first line of a salon address.
	 */
	private String address1;
	/**
	 *  The second line of a salon address.
	 */
	private String address2;
	/**
	 *  The city which this salon locates.
	 */
	private String city;
	/**
	 *  The country which this salon locates.
	 */
	private String province;

	public String getProvince ()
	{
		return province;
	}

	public void setProvince (String province)
	{
		this.province = province;
	}
	private String country;
	/**
	 *  The postal code of the address.
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
	 *  Default constructor for salon object.
	 */
	public SalonBean ()
	{
	}

	/**
	 * Sets the 1st line of customer address.
	 * @param  address1 a string for the salon's 1st line of address.
	 */
	public void setAddress1 (String address1)
	{
		this.address1 = address1;
	}

	/**
	 * Sets the 2nd line of customer address.
	 * @param  address2 a string for the salon's 2nd line of address.
	 */
	public void setAddress2 (String address2)
	{
		this.address2 = address2;
	}

	/**
	 * Sets the number of beauty station in the salon.
	 * @param  beautyStation an integer of beauty station in the salon.
	 */
	public void setBeautyStations (Integer beautyStation)
	{
		this.beautyStations = beautyStation;
	}

	/**
	 * Sets the city which this salon locates.
	 * @param  city a string for the city which this salon locates.
	 */
	public void setCity (String city)
	{
		this.city = city;
	}

	/**
	 * Sets the country which this salon locates.
	 * @param  country a string for the country which this salon locates.
	 */
	public void setCountry (String country)
	{
		this.country = country;
	}

	/**
	 * Sets the salon's e-mail address.
	 * @param  email a string for the salon's e-mail address.
	 */
	public void setEmail (String email)
	{
		this.email = email;
	}

	/**
	 * Sets the number of hair station in the salon.
	 * @param  hairStation an integer of hair station in the salon.
	 */
	public void setHairStations (Integer hairStation)
	{
		this.hairStations = hairStation;
	}

	/**
	 * Sets the name of the salon.
	 * @param  name a string for the name of the salon.
	 */
	public void setName (String name)
	{
		this.name = name;
	}

	/**
	 * Sets the salon's phone number.
	 * @param  phoneNumber a string for the salon's phone number.
	 */
	public void setPhoneNumber (String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	/**
	 * Sets the salon's postal code.
	 * @param  postalCode a string for the salon's postal code.
	 */
	public void setPostalCode (String postalCode)
	{
		this.postalCode = postalCode;
	}

	/**
	 * Sets the default tax rate the salon charges based 
	 *              on provincial and federal tax rates.
	 * @param  taxRate a Double for default tax rate the salon charges based 
	 *              on provincial and federal tax rates.
	 */
	public void setTaxRate (Double taxRate)
	{
		this.taxRate = taxRate;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getAddress1 ()
	{
		return address1;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getAddress2 ()
	{
		return address2;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public Integer getBeautyStations ()
	{
		return beautyStations;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getCity ()
	{
		return city;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getCountry ()
	{
		return country;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getEmail ()
	{
		return email;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public Integer getHairStations ()
	{
		return hairStations;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getName ()
	{
		return name;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getPhoneNumber ()
	{
		return phoneNumber;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public String getPostalCode ()
	{
		return postalCode;
	}

	/**
	 * Returns the salon's 1st line of address.
	 * @return a string for the salon's 1st line of address.
	 */
	public Double getTaxRate ()
	{
		return taxRate;
	}

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
	
	/**
	 *  A toString method to print out the salon's information
	 *  @return a string of salon's information
	 */
	@Override
	public String toString ()  //NOT DONE
	{
		return taxRate + " " + name + " " + address1 + " " + address2 +
				" " + city + " " + country + " " + postalCode + " " +
				phoneNumber + " " + email + "\n";
	}

	public int compare (Object o1, Object o2)
	{
		return 0;
	}

	@Override
	public boolean equals (Object o)
	{
		return true;
	}
}

