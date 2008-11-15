<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
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
for (int i = startHour; i < endHour; i++)
{
    rowCount = rowCount + 4;
}
%>

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