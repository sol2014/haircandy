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
import java.util.*;

/**
 * The appointment servlet will handle all http requests that will deal with
 * manipulation and lookup of appointment information in the system.
 * 
 * @author Philippe Durand
 */
public class AppointmentServlet extends DispatcherServlet
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
		setActionAttribute ("appointment_action");
		addExternalAction ("Save", "performSave");
		addExternalAction ("QuickSave", "performQuickSave");
		addExternalAction ("Finish", "performSave");
		addExternalAction ("Delete", "performDelete");
		addExternalAction ("Load", "performLoad");
	}

	/**
	 * Allows the quick saving of a appointment by passing specific information
	 * like start/end time, employee and appointment number. This is used when
	 * the appointments are drag/dropped.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performQuickSave (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		PrintWriter pw = response.getWriter ();
		
		String appointment_no = request.getParameter ("appointment_no");
		String start_time = request.getParameter ("start_time");
		String end_time = request.getParameter ("end_time");
		String employee_no = request.getParameter ("employee_no");
		
		LogController.write (this, "[PAGE REQUEST] Performing quick save: "+appointment_no);
		
		AppointmentBean appointment = new AppointmentBean ();
		
		if (appointment_no != null)
		{
			try
			{
				appointment.setAppointmentNo (Integer.parseInt (appointment_no));
			}
			catch (Exception e)
			{
				// BAD DATA
				pw.write ("There was invalid data for appointment number.");
				pw.close();
				return;
			}
			
			appointment = SessionController.loadAppointment (userSession, appointment);
		}
		
		if (appointment == null)
		{
			LogController.write (this, "Cannot perform quicksave without a valid appointment number: "+appointment_no);
			return;
		}
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setAddress (new AddressBean ());
		
		try
		{
			employee.setEmployeeNo (Integer.parseInt (employee_no));
		}
		catch (Exception e)
		{
			// BAD DATA
			pw.write ("There was invalid data for employee number.");
			pw.close();
			return;
		}
		
		employee = SessionController.loadEmployee (userSession, employee);
		appointment.setEmployee (employee);
		
		try
		{
			appointment.setStartTime (CoreTools.getTime (start_time));
			appointment.setEndTime (CoreTools.getTime (end_time));
		}
		catch (Exception e)
		{
			// ERROR with data.
			pw.write ("There was invalid data for date and time information.");
			pw.close();
			return;
		}
		
		if (SessionController.saveAppointment (userSession, appointment))
		{
			LogController.write (this, "Quick save completed succesfully.");
		}
		else
		{
			LogController.write (this, "Unable to quick save appointment.");
		}
	}
	
	/**
	 * This action loads a appointment record from the system and sends it
	 * to the appointment details dialog box page.
	 * 
	 * @param userSession the user session that is performing the action.
	 * @param request the http request object related to the action.
	 * @param response the http response object related to the action.
	 * @throws javax.servlet.ServletException
	 * @throws java.io.IOException
	 */
	public void performLoad (UserSession userSession, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		PrintWriter pw = response.getWriter ();
		
		String appointment_no = request.getParameter ("appointment_no");
		String date = request.getParameter ("date");
		String start_time = request.getParameter ("start_time");
		String end_time = request.getParameter ("end_time");
		String employee_no = request.getParameter ("employee_no");
		
		LogController.write (this, "[PAGE REQUEST] Performing load: "+appointment_no);
		
		AppointmentBean appointment = new AppointmentBean ();
				
		if (appointment_no != null)
		{
			try
			{
				appointment.setAppointmentNo (Integer.parseInt (appointment_no));
			}
			catch (Exception e)
			{
				// BAD DATA
				pw.write ("There was invalid data for appointment number.");
				pw.close();
				return;
			}
			
			appointment = SessionController.loadAppointment (userSession, appointment);
		}
		else
		{
			EmployeeBean employee = new EmployeeBean ();
			employee.setAddress (new AddressBean ());
			
			try
			{
				employee.setEmployeeNo (Integer.parseInt (employee_no));
			}
			catch (Exception e)
			{
				// BAD DATA
				pw.write ("There was invalid data for employee number.");
				pw.close();
				return;
			}
			
			employee = SessionController.loadEmployee (userSession, employee);
			appointment.setEmployee (employee);
		}
		
		if (date != null && start_time != null && end_time != null)
		{
			try
			{
				appointment.setDate (CoreTools.getDate (date));
				appointment.setStartTime (CoreTools.getTime (start_time));
				appointment.setEndTime (CoreTools.getTime (end_time));
			}
			catch (Exception e)
			{
				// ERROR with data.
				pw.write ("There was invalid data for date and time information.");
				pw.close();
				return;
			}
		}
		
		request.setAttribute ("appointment_load_result", appointment);
		forward ("ajax/ajax-appointment-details.jsp", request, response);
	}

	/**
	 * This action will allow the deletion of an appointment by passing the
	 * appointment number as a parameter. No output is sent unless there
	 * is a problem.
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
		String appointmentNo = request.getParameter ("appointment_no");

		LogController.write (this, "[PAGE REQUEST] Performing delete: "+appointmentNo);
		
		AppointmentBean appointment = new AppointmentBean ();
		appointment.setAppointmentNo (Integer.parseInt (appointmentNo));
		response.setContentType ("text/html");
		response.setCharacterEncoding ("UTF-8");
		
		PrintWriter pw = response.getWriter ();
		if (SessionController.deleteAppointment (userSession, appointment))
		{
			pw.print (appointmentNo);
		}
		else
		{
			pw.print ("bad");
		}

		pw.close ();
	}

	/**
	 * Allows the full saving of an appointment either new or existing into
	 * the system. Success will notify the interface for visual updates.
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
		String appointmentNo = request.getParameter ("appointment_no");
		PrintWriter pw = response.getWriter ();
		
		LogController.write (this, "[USER REQUEST] Performing save: "+appointmentNo);
		
		if (appointmentNo.equals ("") || appointmentNo.equals ("null"))
		{
			appointmentNo = null;
		}
		
		String employeeNo = request.getParameter ("employee_no");
		String firstName = request.getParameter ("first_name");
		String lastName = request.getParameter ("last_name");
		String phoneNumber = request.getParameter ("phone_number");
		String dateString = request.getParameter ("date");
		String startString = request.getParameter ("start_time");
		String endString = request.getParameter ("end_time");

		// Set the beans and get the salon.
		AppointmentBean appointment = new AppointmentBean ();
		SalonBean salon = new SalonBean ();
		salon = SessionController.loadSalon (userSession, salon);
		
		ClientBean client = new ClientBean ();
		client.setPhoneNumber (phoneNumber);
		client.setAddress (new AddressBean ());
		
		ClientBean[] clients = SessionController.searchClients (userSession, client);
		
		for (ClientBean cycle : clients)
		{
			if (cycle.getPhoneNumber ().equals (phoneNumber))
			{
				client.setClientNo (cycle.getClientNo ());
				client.setEnabled (cycle.getEnabled ());
				client.setFirstName (cycle.getFirstName ());
				client.setLastName (cycle.getLastName ());
				client.setPhoneNumber (cycle.getPhoneNumber ());
				AddressBean address = SessionController.loadAddress (userSession, cycle.getAddress ());
				client.setAddress (address);
			}
		}
		
		if (client.getClientNo () == null)
		{
			client.setFirstName (firstName);
			client.setLastName (lastName);
			SessionController.saveClient (userSession, client);
		}
		
		EmployeeBean employee = new EmployeeBean ();
		employee.setEmployeeNo (Integer.parseInt (employeeNo));
		appointment.setEmployee (employee);
		
		String[] products = request.getParameterValues ("products");
        Hashtable<ProductBean, Integer> hash = appointment.getProducts ();
		
        String[] services = request.getParameterValues ("services");
        Hashtable<ServiceBean, Integer> hash1 = appointment.getServices ();

        hash.clear ();

        if (products != null)
        {
            for (String product : products)
            {
                try
                {
                    ProductBean pb = new ProductBean ();
                    String[] productinfo = product.split (":");

                    pb.setProductNo (Integer.parseInt (productinfo[0]));
                    int amount = Integer.parseInt (productinfo[1]);
                    pb = (ProductBean) SessionController.loadProduct (userSession, pb);

                    while (hash.contains (pb))
                    {
                        hash.remove (pb);
                    }

                    hash.remove (pb);
                    hash.put (pb, amount);
                }
                catch (Exception e)
                {
                }
            }
        }

        appointment.setProducts (hash);
        hash1.clear ();
		int duration = 0;
		
        if (services != null)
        {
            for (String service : services)
            {
                try
                {
                    ServiceBean sb = new ServiceBean ();
                    String[] serviceinfo = service.split (":");
					
                    sb.setServiceNo (Integer.parseInt (serviceinfo[0]));
                    int amount = Integer.parseInt (serviceinfo[1]);
                    sb = (ServiceBean) SessionController.loadService (userSession, sb);
                    while (hash1.contains (sb))
                    {
                        hash1.remove (sb);
                    }
					
                    hash1.remove (sb);
                    hash1.put (sb, amount);
					
					duration += sb.getDuration () * amount;
                }
                catch (Exception e)
                {
                }
            }
        }

        appointment.setServices (hash1);
		
		boolean inputFailed = false;
		
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

		if (appointmentNo != null)
		{
			appointment.setAppointmentNo (Integer.parseInt (appointmentNo));
		}
		
		appointment.setEmployee (employee);
		appointment.setClient (client);
		appointment.setDate (date);
		appointment.setStartTime (startTime);
		
		// Now we have to figure out the end time from the duration.
		try
		{
			Calendar calendar = Calendar.getInstance();
			calendar.setTime (startTime);
			calendar.add(Calendar.MINUTE,duration);
			appointment.setEndTime (calendar.getTime ());
		}
		catch (Exception e)
		{
			LogController.write (this, "Unable to calculate end time for appointment.");
			appointment.setEndTime (endTime);
		}
        
		// First check if we are within the limits of the day.
		ScheduleHoursBean hours = new ScheduleHoursBean ();
		hours.setDate (date);
		hours = SessionController.loadScheduleHours (userSession, hours);
		
		if (!hours.getEndTime().equals (appointment.getEndTime()) && CoreTools.isTimeBefore(hours.getEndTime(), appointment.getEndTime()))
		{
			// You cannot schedule the end time past the business hours.
			LogController.write (this, "You cannot book an appointment that ends after the business hours.");
			
			pw.print ("Booking outside business hours.");
			pw.close ();
			
			return;
		}
		
		Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions = SessionController.getAvailabilityExceptions(userSession, date);
		ArrayList<ScheduleExceptionBean> scheduleExceptions = SessionController.getScheduleExceptions(userSession, date);
		Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unavailables = SessionController.getUnavailable(userSession, date, availabilityExceptions, scheduleExceptions, hours);
		Hashtable<EmployeeBean, ArrayList<AppointmentBean>> appointments = SessionController.getAppointments(userSession, date, availabilityExceptions, scheduleExceptions);
		
		// If we are, then check to see if we are ending the appointment overtop of
		// unavailable time.
		for (EmployeeBean e : unavailables.keySet ())
		{
			if (e.getEmployeeNo ().equals (employee.getEmployeeNo ()))
			{
				for (ScheduleBean sch : unavailables.get (e))
				{
					
					// Now we want to know if the schedule entry finishes
					if ((!appointment.getEndTime().equals(sch.getStartTime()) && CoreTools.isTimeBefore (sch.getStartTime (), appointment.getEndTime ())) && (!appointment.getEndTime().equals(sch.getEndTime()) && CoreTools.isTimeBefore (appointment.getEndTime (), sch.getEndTime ())))
					{
						LogController.write (this, "You cannot book an appointment that ends within an unavailable block.");
						
						pw.print ("Appointment ends within a unavailable block.");
						pw.close ();

						return;
					}
				}
			}
		}
		
		// Then lastly, check to see if we are ending the appointment overtop of another
		// appointment (only if we are a client do we care about this one.
		if (userSession.isGuest ())
		{
			for (EmployeeBean e : appointments.keySet ())
			{
				if (e.getEmployeeNo ().equals (employee.getEmployeeNo ()))
				{
					for (AppointmentBean apb : appointments.get (e))
					{
						if ((!appointment.getEndTime().equals(apb.getStartTime()) && CoreTools.isTimeBefore (apb.getStartTime (), appointment.getEndTime ())) && (!appointment.getEndTime().equals(apb.getEndTime()) && CoreTools.isTimeBefore (appointment.getEndTime (), apb.getEndTime ())))
						{
							LogController.write (this, "Clients cannot book an appointment that ends within another appointment block.");

							pw.print ("Appointment ends within another appointment block.");
							pw.close ();

							return;
						}
					}
				}
			}
		}
		
		if (SessionController.saveAppointment (userSession, appointment))
		{
			LogController.write ("Save successfull.");
			response.setContentType ("text/html");
			response.setCharacterEncoding ("UTF-8");
			
			if (duration < 15)
				duration = 1;
			else
				duration = duration / 15;
			
			String sentstr = appointment.getAppointmentNo ()+":"+duration;
			
			pw.print (sentstr);
			pw.close ();
			
			LogController.write ("Save successfull, sent: "+sentstr);
		}
		else
		{
			LogController.write ("Save unsuccessfull.");
		}
	}
}
