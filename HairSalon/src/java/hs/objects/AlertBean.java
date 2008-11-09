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
 * This class contains information or attutibe of an Availability
 * Exception object.  This object represents an exception class for 
 * employee’s availability.  Upon creation of an instance of the following 
 * must be provided:
 *  
 * The date, reason, start time and end time of the availability exception,
 * plus the employee information.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class AlertBean extends DataBean
{
    /**
     * The date of the availability exception occurs.
     */
    private Date date = null;
    /**
     * The reason the availability exception occurs.
     */
    private String message = null;
	
	private String type = null;

    private String link = null;
	
	private String level = null;
    
	private Integer recordNo = null;

	public Integer getRecordNo ()
	{
		return recordNo;
	}

	public void setRecordNo (Integer recordNo)
	{
		this.recordNo = recordNo;
	}

	public String getType ()
	{
		return type;
	}

	public void setType (String type)
	{
		this.type = type;
	}
	
	private Integer alertNo = null;

	public Integer getAlertNo ()
	{
		return alertNo;
	}

	public void setAlertNo (Integer alertNo)
	{
		this.alertNo = alertNo;
	}
	
    private Integer employeeNo = null;

	public Date getDate ()
	{
		return date;
	}

	public void setDate (Date date)
	{
		this.date = date;
	}

	public String getLevel ()
	{
		return level;
	}

	public void setLevel (String level)
	{
		this.level = level;
	}

	public String getLink ()
	{
		return link;
	}

	public void setLink (String link)
	{
		this.link = link;
	}

	public String getMessage ()
	{
		return message;
	}

	public void setMessage (String message)
	{
		this.message = message;
	}

    /**
     *  Default constructor for person object.
     */
    public AlertBean ()
    {
		
    }
	
	public int compare (Object o1, Object o2)
	{
		AlertBean a1 = (AlertBean)o1;
		AlertBean a2 = (AlertBean)o2;
		
		int result1 = a1.getAlertNo ().compareTo (a2.getAlertNo ());
		
		return (result1);
	}
	
	
	@Override
	public boolean equals (Object o)
	{
		AlertBean a = (AlertBean)o;
		
		boolean result1 = a.getAlertNo ().equals (this.getAlertNo ());
		
		return (result1);
	}
}

