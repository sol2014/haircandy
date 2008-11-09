/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.core;

import java.util.*;

import hs.objects.*;

/**
 *
 * @author Philippe Durand
 */
public class UserSession
{
	private EmployeeBean employee;
	private boolean isAuthenticated;
	private Hashtable<String, Object> attributes = new Hashtable<String, Object> ();
	private ArrayList<SessionPositions> positions = new ArrayList<SessionPositions> ();
	private SessionPositions currentPosition = SessionPositions.None;
	
	/**
	 * The record number of the current record being edited by this session.
	 */
	private int currentRecordNo = 0;
	
	public UserSession (EmployeeBean employee)
	{
		LogController.write (this, "New employee user session created.");
		this.employee = employee;
	}
	
	public UserSession ()
	{
		LogController.write (this, "New guest user session created.");
		this.employee = null;
	}
	
	public boolean isGuest ()
	{
		return (employee == null);
	}
	
	public boolean isAuthenticated ()
	{
		return isAuthenticated;
	}
	
	public void setAuthenticated (boolean value)
	{
		isAuthenticated = value;
	}
	
	public EmployeeBean getEmployee ()
	{
		return employee;
	}
	
	public void setEmployee (EmployeeBean employee)
	{
		this.employee = employee;
	}
	
	public ArrayList<SessionPositions> getPositions ()
	{
		return positions;
	}
	
	public void setNextPosition (SessionPositions position)
	{
		if (!positions.contains (position))
		{
			positions.add (position);
		}
		else
		{
			// If it is contained, we want to rid ourselves of anyone after it.
			int index = positions.indexOf (position);
			for(SessionPositions toRemove : positions.subList (index+1, positions.size ()))
			{
				positions.remove (toRemove);
			}
		}
		
		currentPosition = position;
	}
	
	public void setCurrentPosition (SessionPositions position)
	{
		positions.clear ();
		positions.add (position);
		currentPosition = position;
	}
	
	public SessionPositions getCurrentPosition ()
	{
		return currentPosition;
	}
	
	public void setCurrentRecordNo (Integer no)
	{
		currentRecordNo = no;
	}
	
	public Integer getCurrentRecordNo ()
	{
		return currentRecordNo;
	}
	
	public void setAttribute (String key, Object value)
	{
		if (!attributes.containsKey (key))
			attributes.put (key, value);
		else
		{
			attributes.remove (key);
			attributes.put (key, value);
		}
	}
	
	public Object moveAttribute (String key)
	{
		Object value = getAttribute (key);
		
		removeAttribute (key);
		
		return value;
	}
	
	public Object getAttribute (String key)
	{
		return attributes.get (key);
	}
	
	public void removeAttribute (String key)
	{
		attributes.remove (key);
	}
	
	public void clearAttributes ()
	{
		attributes.clear ();
	}
}
