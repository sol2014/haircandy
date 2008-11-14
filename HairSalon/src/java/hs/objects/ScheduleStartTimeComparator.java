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

import java.util.*;

/**
 * The comparator used to sort schedule beans by start time.
 * 
 * @author Philippe Durand
 */
public class ScheduleStartTimeComparator implements Comparator<ScheduleBean>
{
	public int compare (ScheduleBean sb1, ScheduleBean sb2)
	{
		return sb1.getStartTime ().compareTo (sb2.getStartTime ());
	}
}
