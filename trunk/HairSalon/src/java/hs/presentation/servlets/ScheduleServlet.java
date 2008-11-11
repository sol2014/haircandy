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

public class ScheduleServlet extends DispatcherServlet
{
	@Override
	public void setupActionMethods () throws NoSuchMethodException
	{
		setActionAttribute ("schedule_action");
		addExternalAction ("Save", "performSave");
		addExternalAction ("Delete", "performDelete");
		addExternalAction ("UpdateHours", "performUpdateHours");
	}

	public void performUpdateHours (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
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
			LogController.write (this, "Attemped to update schedule hours with invalid data!");
			return;
		}
		
		LogController.write (this, "[USER REQUEST] Performing schedule hours update: "+CoreTools.showDate (shb.getDate()));
		
		if (!SessionController.saveScheduleHours (userSession, shb))
		{
			LogController.write (this, "Unable to save schedule hours.");
			return;
		}
		
		LogController.write (this, "Saved schedule hours successfully.");
	}
	
	public void performDelete (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String scheduleNo = request.getParameter ("schedule_no");

		LogController.write (this, "[USER REQUEST] Performing delete: "+scheduleNo);
		
		// Set the beans and get the salon.
		ScheduleBean schedule = new ScheduleBean ();
		schedule.setScheduleNo (Integer.parseInt (scheduleNo));
		response.setContentType ("text/html");
		response.setCharacterEncoding ("UTF-8");

		PrintWriter pw = response.getWriter ();
		if (SessionController.deleteSchedule (userSession, schedule))
		{
			pw.print ("it works");
			LogController.write ("Delete successfull.");
		}
		else
		{
			pw.print ("screwed");
			LogController.write ("Delete unsuccessfull.");
		}


		pw.close ();
	}

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