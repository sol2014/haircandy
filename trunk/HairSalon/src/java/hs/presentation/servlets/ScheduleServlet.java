/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.presentation.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import hs.core.*;
import hs.app.*;
import hs.objects.*;
import hs.presentation.*;
import java.util.Date;

/**
 * The schedule servlet will handle all http requests that will deal with
 * manipulation and lookup of schedule information in the system.
 * 
 * @author Philippe Durand
 */
public class ScheduleServlet extends DispatcherServlet
{
	/**
	 * Sets up defaults for action handling used by this servlet. See the
	 * DispatcherServlet for more details.
	 * 
	 * @throws java.lang.NoSuchMethodException
	 */
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("schedule_action");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Delete", "performDelete");
		addExternalAction ("UpdateHours", "performUpdateHours");
	}

	/**
	 * This action allows the user to update the hours for a schedule date
	 * in the system. Only managers have access to this interface.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performUpdateHours (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		PrintWriter pw = response.getWriter ();
		
		String date = request.getParameter ("date");
		String startTime = request.getParameter ("start_time");
		String endTime = request.getParameter ("end_time");
		
		ScheduleHoursBean shb = new ScheduleHoursBean ();
		
		try
		{
			shb.setDate (CoreTools.getDate (date));
			shb.setStartTime (CoreTools.getTime (startTime));
			shb.setEndTime (CoreTools.getTime (endTime));
		}
		catch (Exception e)
		{
			pw.write ("Internal Error! Contact system administrator!");
			LogController.write (this, "Attemped to update schedule hours with invalid data!");
			return;
		}
		
		LogController.write (this, "[USER REQUEST] Performing schedule hours update: "+CoreTools.showDate (shb.getDate()));
		
		if (!shb.getStartTime ().equals (shb.getEndTime ()) && !shb.getStartTime ().before (shb.getEndTime ()))
		{
			pw.write ("Start time must preceed end time.");
			LogController.write (this, "We cannot apply schedule hours unless start time occurs before end time.");
		}
		else
		{
			if (!SessionController.saveScheduleHours (userSession, shb))
			{
				LogController.write (this, "Unable to save schedule hours.");
				pw.write ("Invalid changes! Check the above schedule for existing schedule entries.");
			}
			else
			{
				LogController.write (this, "Saved schedule hours successfully.");
				pw.write ("");
			}
		}
	}
	
	/**
	 * This action allows the managers to delete employee schedule entries
	 * from the scheduler interface. Succcess or failure is sent to the
	 * schedule entry dialog box.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performDelete (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		PrintWriter pw = response.getWriter ();
		
		String scheduleNo = request.getParameter ("schedule_no");

		LogController.write (this, "[USER REQUEST] Performing delete: "+scheduleNo);
		
		// Set the beans and get the salon.
		ScheduleBean schedule = new ScheduleBean ();
		schedule.setScheduleNo (Integer.parseInt (scheduleNo));
		response.setContentType ("text/html");
		response.setCharacterEncoding ("UTF-8");

		if (SessionController.deleteSchedule (userSession, schedule))
		{
			pw.print ("good");
			LogController.write ("Delete successfull.");
		}
		else
		{
			pw.print ("bad");
			LogController.write ("Delete unsuccessfull.");
		}


		pw.close ();
	}

	/**
	 * This action allows the user to save a new or existing schedule entry
	 * into the system. Any errors about values will be sent back to the dialog.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		// Get all the parameters out.
		String scheduleNo = request.getParameter ("schedule_no");
		if (scheduleNo == "")
		{
			scheduleNo = null;
		}
		LogController.write (this, "[USER REQUEST] Performing save: "+scheduleNo);
		
		String employeeNo = request.getParameter ("employee_no");
		String dateString = request.getParameter ("date");
		String startString = request.getParameter ("start_time");
		String endString = request.getParameter ("end_time");

		// Set the beans and get the salon.
		ScheduleBean schedule = new ScheduleBean ();
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (userSession, salon);

		// Set the employee into the schedule entry.
		EmployeeBean employee = new EmployeeBean ();
		employee.setEmployeeNo (Integer.parseInt (employeeNo));

		Date date = null;
		try
		{
			date = CoreTools.getDate (dateString);
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to parse date received from requestor: " + dateString);
			return;
		}

		Date startTime = null;
		try
		{
			startTime = CoreTools.getTime (startString);
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to parse start time received from requestor: " + startString);
			return;
		}

		Date endTime = null;
		try
		{
			endTime = CoreTools.getTime (endString);
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to parse end time received from requestor: " + startString);
			return;
		}

		if (scheduleNo != null)
		{
			schedule.setScheduleNo (Integer.parseInt (scheduleNo));
		}
		schedule.setEmployee (employee);
		schedule.setDate (date);
		schedule.setStartTime (startTime);
		schedule.setEndTime (endTime);

		if (SessionController.saveSchedule (userSession, schedule))
		{
			LogController.write ("Save successfull.");
		}
		else
		{
			LogController.write ("Save unsuccessfull.");
		}
		response.setContentType ("text/html");
		response.setCharacterEncoding ("UTF-8");
		PrintWriter pw = response.getWriter ();
		pw.print (schedule.getScheduleNo ());
		pw.close ();
	}
}
