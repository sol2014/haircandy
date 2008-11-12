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
<%@page import="hs.presentation.tags.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<%
// Retrieve the UserSession object from the http session.
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setCurrentPosition(SessionPositions.AppScheduler);

Date date = CoreTools.getDate(request.getParameter("date"));

Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions = SessionController.getAvailabilityExceptions(userSession, date);
ArrayList<ScheduleExceptionBean> scheduleExceptions = SessionController.getScheduleExceptions(userSession, date);

// Now we need to find the salon hours for today, if none exist, create them.
ScheduleHoursBean shb = new ScheduleHoursBean ();
shb.setDate (date);
shb = SessionController.loadScheduleHours (userSession, shb);

Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unavailables = SessionController.getUnavailable(userSession, date, availabilityExceptions, scheduleExceptions, shb);
Hashtable<EmployeeBean, ArrayList<AppointmentBean>> appointments = SessionController.getAppointments(userSession, date, availabilityExceptions, scheduleExceptions);
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
                        You may either create, delete or move appointment entries for different employees. Some areas may be
                        darkened which means that the employee is not available for appointments.
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
			<input type="button" value="Last Week" name="LastWeek" onclick="" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Last Day" name="LastDay" onclick="" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Next Day" name="NextDay" onclick="" class="StandardButton"/>
		    </td>

		    <td align="center">
			<input type="button" value="Next Week" name="NextWeek" onclick="" class="StandardButton"/>
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
                                            <td id="<%=rowCount + k%>^-^<%=j%>" onclick="cellSingleClickHandler(this)" ondblclick="cellDoubleClickHandler(this)"  onmousedown="cellMouseDownHandler(event, this)" class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
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
            <% }%>
            <% }%>
        </td>
    </tr>
</table>
<script>
    rowCount = <%=rowCount%>;
    salonStartTime = '<%=startHour%>:00';
    date = '<%=request.getParameter("date")%>';
    appointments = new Array();
</script>
<script>
    cells = new Array();
    <%
		for (int i = 0; i < rowCount; i++) {
			for (int j = 0; j < employees.size(); j++) {
                    %>
                        cells[cells.length] = new Cell("<%=i + ""%>^-^<%=j + ""%>", "SchedulerCellSection", emptyState);
                    <%
			}
		}
    %>
</script>
<script>
    employeeIDArray = new Array();
    employeeNameArray = new Array();
    <%
		for (EmployeeBean eb : employees) {
            %>
                employeeIDArray.push(<%=eb.getEmployeeNo()%>);
                employeeNameArray.push('<%=eb.getFirstName()%>');
            <%
		}
    %>
</script>
<script>
    <%
		if (appointments != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<AppointmentBean> abs = null;
				for (EmployeeBean cycle : appointments.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						abs = appointments.get(cycle);
					}
				}

				if (abs != null) {
					for (AppointmentBean abb : abs) {
						int scheduleStartHour = CoreTools.getHour(abb.getStartTime());
						int scheduleStartMinutes = CoreTools.getMinutes(abb.getStartTime());
						int scheduleEndHour = CoreTools.getHour(abb.getEndTime());
						int scheduleEndMinutes = CoreTools.getMinutes(abb.getEndTime());
						int startOffset = (scheduleStartHour - startHour) * 4 + scheduleStartMinutes / 15;
						int endOffset = (scheduleEndHour - startHour) * 4 + scheduleEndMinutes / 15;
						int duration = endOffset - startOffset;
                    %>
                        addIntialAppointment(<%=duration%>,<%=startOffset%>,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>),<%=abb.getAppointmentNo()%>);
                    <%
					}
				}
			}
		}
    %>
</script>    
<script>
    <%
		if (unavailables != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<ScheduleBean> sbs = null;
				for (EmployeeBean cycle : unavailables.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						sbs = unavailables.get(cycle);
					}
				}

				if (sbs != null) {
					for (ScheduleBean sbb : sbs) {
						int scheduleStartHour = CoreTools.getHour(sbb.getStartTime());
						int scheduleStartMinutes = CoreTools.getMinutes(sbb.getStartTime());
						int scheduleEndHour = CoreTools.getHour(sbb.getEndTime());
						int scheduleEndMinutes = CoreTools.getMinutes(sbb.getEndTime());
						int startOffset = (scheduleStartHour - startHour) * 4 + scheduleStartMinutes / 15;
						int endOffset = (scheduleEndHour - startHour) * 4 + scheduleEndMinutes / 15;
						int duration = endOffset - startOffset;
                    %>
                        addUnavailableEntry(<%=duration%>,<%=startOffset%>,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>));
                    <%
					}
				}
			}
		}
    %>
</script>