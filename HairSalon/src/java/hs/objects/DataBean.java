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

import java.io.Serializable;

/**
 * Defines the functionality that data beans should follow.
 * 
 * @author Philippe Durand
 */
public abstract class DataBean implements Serializable
{
	private boolean loaded = false;

	public boolean isLoaded ()
	{
		return loaded;
	}

	public void setLoaded ()
	{
		this.loaded = true;
	}
}
