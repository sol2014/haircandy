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
import java.text.*;

/**
 * This class contains an abstract time slot in the schedule.
 * @author Horace Wan
 */
public abstract class TimeSlotBean extends DataBean
{
    /*
     * This is the date of the time slot. 
     */
    private Date date;
    /*
     * This is the start time of the time slot. 
     */
    private Date startTime;
    /*
     * This is the end time of the time slot. 
     */
    private Date endTime;

    /*
     * Default constructor for TimeSlot object. 
     */
    public TimeSlotBean ()
    {
    }
	
    /**
     * Return the date of the time slot.
     * @return the date of the time slot.
     */
    public Date getDate ()
    {
        return date;
    }

    /**
     * Return the end time of the time slot.
     * @return the end time of the time slot.
     */
    public Date getEndTime ()
    {
        return endTime;
    }

    /**
     * Return the start time of the time slot.
     * @return the start time of the time slot.
     */
    public Date getStartTime ()
    {
        return startTime;
    }

    /**
     * Set the date of the time slot.
     * @parm the date of the time slot.
     */
    public void setDate (Date date)
    {
        this.date = date;
    }

    /**
     * Set the end time of the time slot.
     * @parm the end time of the time slot.
     */
    public void setEndTime (Date endTime)
    {
        this.endTime = endTime;
    }

    /**
     * Set the start time of the time slot.
     * @parm the start time of the time slot.
     */
    public void setStartTime (Date startTime)
    {
        this.startTime = startTime;
    }
}