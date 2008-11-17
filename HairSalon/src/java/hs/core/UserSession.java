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
 * This class is used to hold all information about a specific user session that
 * is interacting with the system. Employee information, and application
 * position is stored within this object, as well as some functions to help
 * quickly identify the session.
 * 
 * @author Philippe Durand
 */
public class UserSession
{
	/**
	 * The employee that is logged into this session if any.
	 */
	private EmployeeBean employee;
	/**
	 * Whether this session has been authenticated to use the system's
	 * private functions.
	 */
	private boolean isAuthenticated;
	/**
	 * A list of attributes that are stored for this session only.
	 */
	private Hashtable<String, Object> attributes = new Hashtable<String, Object> ();
	/**
	 * A list of positions depicting the users current site activity.
	 */
	private ArrayList<SessionPositions> positions = new ArrayList<SessionPositions> ();
	/**
	 * The current position that the user is in the site.
	 */
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
	
	/**
	 * Obtains the entire session positions list.
	 * 
	 * @return the list of positions.
	 */
	public ArrayList<SessionPositions> getPositions ()
	{
		return positions;
	}
	
	/**
	 * Sets the next position in the list by appending it to the list.
	 * 
	 * @param position the position to add to the list.
	 */
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
	
	/**
	 * Clears all positions in the list and sets it to the specified position.
	 * 
	 * @param position the position to set as the new one.
	 */
	public void setCurrentPosition (SessionPositions position)
	{
		positions.clear ();
		positions.add (position);
		currentPosition = position;
	}
	
	/**
	 * Obtains the current position this session is in the application.
	 * 
	 * @return the current position.
	 */
	public SessionPositions getCurrentPosition ()
	{
		return currentPosition;
	}
	
	/**
	 * Sets the current record number that is being worked on by this user.
	 * 
	 * @param no the record number being worked on.
	 */
	public void setCurrentRecordNo (Integer no)
	{
		currentRecordNo = no;
	}
	
	/**
	 * Gets the current record number that the user is working on.
	 * 
	 * @return the record number the user is working on.
	 */
	public Integer getCurrentRecordNo ()
	{
		return currentRecordNo;
	}
	
	/**
	 * Allows the insertion of an attribute into the session.
	 * 
	 * @param key the key to use to file this attribute.
	 * @param value the attribute value to add.
	 */
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

	/**
	 * Removes and obtains the value based on the key specified.
	 * 
	 * @param key the key to look for in the attributes.
	 * @return the attribute value found and removed using the key.
	 */
	public Object moveAttribute (String key)
	{
		Object value = getAttribute (key);
		
		removeAttribute (key);
		
		return value;
	}
	
	/**
	 * Returns the attribute value based on the key provided.
	 * 
	 * @param key the key to obtain a value for.
	 * @return the value found using the key.
	 */
	public Object getAttribute (String key)
	{
		return attributes.get (key);
	}
	
	/**
	 * Allows the removal of an attribute from the list.
	 * 
	 * @param key the key to remove from the list.
	 */
	public void removeAttribute (String key)
	{
		attributes.remove (key);
	}
	
	/**
	 * Allows the clearing of all attributes in this session.
	 */
	public void clearAttributes ()
	{
		attributes.clear ();
	}
}
