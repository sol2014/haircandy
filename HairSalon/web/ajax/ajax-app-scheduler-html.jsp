<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<%
// Retrieve the UserSession object from the http session.
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setCurrentPosition(SessionPositions.AppScheduler);

Date date = CoreTools.getDate(request.getParameter("date"));

Calendar calendar = Calendar.getInstance ();
calendar.setTime (date);
calendar.add (Calendar.DAY_OF_YEAR, 1);
Date nextDay = calendar.getTime ();
calendar.roll (Calendar.DAY_OF_YEAR, false);
calendar.roll (Calendar.DAY_OF_YEAR, false);
Date lastDay = calendar.getTime ();

calendar.setTime (date);

calendar.add (Calendar.WEEK_OF_YEAR, 1);
Date nextWeek = calendar.getTime ();
calendar.roll (Calendar.WEEK_OF_YEAR, false);
calendar.roll (Calendar.WEEK_OF_YEAR, false);
Date lastWeek = calendar.getTime ();

Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions = SessionController.getAvailabilityExceptions(userSession, date);
ArrayList<ScheduleExceptionBean> scheduleExceptions = SessionController.getScheduleExceptions(userSession, date);

// Now we need to find the salon hours for today, if none exist, create them.
ScheduleHoursBean shb = new ScheduleHoursBean ();
shb.setDate (date);
shb = SessionController.loadScheduleHours (userSession, shb);

Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unavailables = SessionController.getUnavailable (userSession, date, availabilityExceptions, scheduleExceptions, shb);
Hashtable<EmployeeBean, ArrayList<AppointmentBean>> appointments = SessionController.getAppointments (userSession, date, availabilityExceptions, scheduleExceptions);
ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean>();

for (EmployeeBean employee : unavailables.keySet()) {
	employees.add(SessionController.loadEmployee(userSession, employee));
}
Collections.sort(employees, new EmployeeLastNameComparator());

Date startTime = shb.getStartTime ();
Date endTime = shb.getEndTime ();
int startHour = CoreTools.getStartHour(startTime);
int endHour = CoreTools.getEndHour(endTime);
int rowCount = 0;
%>

<table>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="5" cellpadding="0">
                <tr>
                    <td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/appointment_white.gif" width="48" height="48"></td>
                    <td align="left"><font size="3"><b>Appointment Schedule: <%=CoreTools.showDate (date, CoreTools.DayMonthYearFormat)%></b></font><br>
                        <% if (userSession.isGuest()) { %>
			Double-click the available areas of the schedule in order to create an appointment with the salon. If you make
			a mistake, you will need to contact us to make changes so choose your appointment carefully. You cannot overlap
			appointments, however the employees can, so contact the salon for extra availability.
			<% } else { %>
			Double-click any appointment cell or available area to create, edit or delete the appointments in the schedule.
			You may overlap appointments, and you will be notified of these overlaps by the color in the legend below.
			<% } %>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
	    <table border="0" cellspacing="5" cellpadding="0">
		<tr>
		    <td align="center">
			<input type="button" value="Last Week" name="LastWeek" onclick="goDate('<%=CoreTools.showDate (lastWeek)%>')" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Last Day" name="LastDay" onclick="goDate('<%=CoreTools.showDate (lastDay)%>')" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Next Day" name="NextDay" onclick="goDate('<%=CoreTools.showDate (nextDay)%>')" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Next Week" name="NextWeek" onclick="goDate('<%=CoreTools.showDate (nextWeek)%>')" class="StandardButton"/>
		    </td>
		</tr>
	    </table>
            <% if (startTime.equals(endTime)) {%>
            <font size="3"><b>The salon is not taking any appointments on this date.</b></font>
            <% } else {%>
            <% if (employees.size() < 1) {%>
            <font size="3"><b>There are no scheduled employees to book appointments with on this date.</b></font>
            <% } else {%>
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="SchedulerTopLeft"></td>
                    <td class="SchedulerHeader">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="SchedulerTimeHeader">&nbsp;</td>
                                <% for (int i = 0; i < employees.size(); i++) {
		 EmployeeBean eb = employees.get(i);%>
                                <td class="SchedulerColumn"><span class="HeaderFont"><%=eb.getFirstName()%></span></td>
                                <% if (i != employees.size() - 1) {%>
                                <td class="SchedulerHeaderSeparator"></td>
                                <% }%>
                                <% }%>
                            </tr>
                        </table>
                    </td>
                    <td class="SchedulerTopRight"></td>
                </tr>
                <tr>
                    <td class="SchedulerLeft"></td>
                    <td>
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                            <% for (int i = startHour; i < endHour; i++) {%>
                            <tr>
                                <td class="SchedulerTime"><span class="TimeFont"><%=CoreTools.getAMPMHour(i+1)%>:00<%=CoreTools.getAMPM(i)%></span></td>
                                
                                <% for (int j = 0; j < employees.size(); j++) {%>
                                <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <% for (int k = 0; k < 4; k++) {%>
                                        <tr>
                                            <td id="<%=rowCount + k%>^-^<%=j%>" onclick="cellSingleClickHandler(this)" ondblclick="cellDoubleClickHandler(this)" onmouseover="cellMouseOverHandler(event, this)" onmouseout="cellMouseOutHandler(event, this)"  onmousedown="cellMouseDownHandler(event, this)" class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <% }%>
                                    </table>
                                </td>
                                <% if (j != employees.size() - 1) {%>
                                <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                <% }
	 }%></tr>
                            <% rowCount = rowCount + 4;
	 }%>
                        </table>
                    </td>
                    <td class="SchedulerRight"></td>
                </tr>
                <tr>
                    <td class="SchedulerBottomLeft"></td>
                    <td class="SchedulerBottom"></td>
                    <td class="SchedulerBottomRight"></td>
                </tr>
            </table>
	    <br/>&nbsp;<img src="/HairSalon/images/scheduler/legend_available.gif">&nbsp;Available&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_unavailable.gif">&nbsp;Unavailable&nbsp;
	    <% if (!userSession.isGuest()) { %>
	    <img src="/HairSalon/images/scheduler/legend_green.gif">&nbsp;Unlocked&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_yellow.gif">&nbsp;Overlap&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_red.gif">&nbsp;Double Overlap&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_gray.gif">&nbsp;Locked&nbsp;
	    <% } else { %>
	    <img src="/HairSalon/images/scheduler/legend_purple.gif">&nbsp;Appointment&nbsp;
	    <% } %>
            <% }%>
            <% }%>
        </td>
    </tr>
</table>
