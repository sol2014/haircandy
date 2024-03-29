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
userSession.setCurrentPosition(SessionPositions.SchScheduler);

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

EmployeeBean ebb = new EmployeeBean();
AddressBean ab = new AddressBean();
ebb.setAddress(ab);

EmployeeBean[] arrayEmployees = SessionController.searchEmployees(userSession, ebb);
ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean>();

for (int i = 0; i < arrayEmployees.length; i++) {
	employees.add(arrayEmployees[i]);
}
Collections.sort(employees, new EmployeeLastNameComparator());

ScheduleHoursBean shb = new ScheduleHoursBean();
shb.setDate(date);
shb = SessionController.loadScheduleHours(userSession, shb);

Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions = SessionController.getAvailabilityExceptions(userSession, date);
ArrayList<ScheduleExceptionBean> scheduleExceptions = SessionController.getScheduleExceptions(userSession, date);
Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedules = SessionController.getAllSchedule(userSession, date, availabilityExceptions, scheduleExceptions);
Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unmovableSchedules = SessionController.getUnmovableSchedule(userSession, date, schedules);
Hashtable<EmployeeBean, ArrayList<ScheduleBean>> movableSchedules = SessionController.getMovableSchedule(userSession, date, schedules);
Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unschedulables = SessionController.getUnschedulable(userSession, date, shb);

Date startTime = shb.getStartTime();
Date endTime = shb.getEndTime();
int startHour = CoreTools.getStartHour(startTime);
int endHour = CoreTools.getEndHour(endTime);
int rowCount = 0;
%>

<%!
	private String getCSSClass(UserSession userSession, int startHour, int row, EmployeeBean eb, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> movableSchedules, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unschedulables, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> unmovableSchedules) {
		if (unmovableSchedules != null) {
			ArrayList<ScheduleBean> sbs = null;
			for (EmployeeBean cycle : unmovableSchedules.keySet()) {
				if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
					sbs = unmovableSchedules.get(cycle);
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
					if (row >= startOffset && row < endOffset) {
						if (startOffset == endOffset - 1) {
							return "SchedulerCellSectionSingle_Booked";
						}
						if (row == startOffset) {
							return "SchedulerCellSectionTop_Booked";
						} else if (row == endOffset - 1) {
							return "SchedulerCellSectionBottom_Booked";
						} else {
							return "SchedulerCellSectionMiddle_Booked";
						}
					}
				}
			}
		}
		if (scheduleExceptions != null) {
			return "SchedulerCellSection_Unavailable";
		}
		if (availabilityExceptions != null) {
			for (EmployeeBean cycle : availabilityExceptions.keySet()) {
				if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
					return "SchedulerCellSection_Unavailable";
				}
			}
		}
		if (movableSchedules != null) {
			ArrayList<ScheduleBean> sbs = null;
			for (EmployeeBean cycle : movableSchedules.keySet()) {
				if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
					sbs = movableSchedules.get(cycle);
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
					if (row >= startOffset && row < endOffset) {
						if (startOffset == endOffset - 1) {
							if (userSession.getEmployee().getRole().equals("Manager")) {
								return "SchedulerCellSectionSingle";
							} else {
								return "SchedulerCellSectionSingle_Booked";
							}
						}
						if (row == startOffset) {
							if (userSession.getEmployee().getRole().equals("Manager")) {
								return "SchedulerCellSectionTop";
							} else {
								return "SchedulerCellSectionTop_Booked";
							}
						} else if (row == endOffset - 1) {
							if (userSession.getEmployee().getRole().equals("Manager")) {
								return "SchedulerCellSectionBottom";
							} else {
								return "SchedulerCellSectionBottom_Booked";
							}
						} else {
							if (userSession.getEmployee().getRole().equals("Manager")) {
								return "SchedulerCellSectionMiddle";
							} else {
								return "SchedulerCellSectionMiddle_Booked";
							}
						}
					}
				}
			}
		}
		if (unschedulables != null) {
			ArrayList<ScheduleBean> sbs = null;
			for (EmployeeBean cycle : unschedulables.keySet()) {
				if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
					sbs = unschedulables.get(cycle);
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
					if (row >= startOffset && row < endOffset) {
						return "SchedulerCellSection_Unavailable";
					}
				}
			}
		}
		return "SchedulerCellSection";
	}
%>

<table>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="5" cellpadding="0">
                <tr>
                    <td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/schedule_white.gif" width="48" height="48"></td>
                    <td align="left"><font size="3"><b>Employee Schedule: <%=CoreTools.showDate(date, CoreTools.DayMonthYearFormat)%></b></font><br>
                        You may either create, delete or move schedule entries for different employees. Some areas may be
                        darkened which means there are exceptions blocking those employee.
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
            <font size="3"><b>The salon is not open on this date.</b></font>
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
                                <td class="SchedulerTime"><span class="TimeFont"><%=CoreTools.getAMPMHour(i + 1)%>:00<%=CoreTools.getAMPM(i + 1)%></span></td>
                                
                                <% for (int j = 0; j < employees.size(); j++) {%>
                                <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <% for (int k = 0; k < 4; k++) {%>
                                        <tr>
                                            <td id="<%=rowCount + k%>^-^<%=j%>" onclick="cellSingleClickHandler(this)" ondblclick="cellDoubleClickHandler(this)" onmouseover="cellMouseOverHandler(event, this)" onmouseout="cellMouseOutHandler(event, this)"  onmousedown="cellMouseDownHandler(event, this)" class="<%=getCSSClass(userSession, startHour, rowCount + k, employees.get(j), movableSchedules, availabilityExceptions, scheduleExceptions, unschedulables, unmovableSchedules)%>"><img src="images/site_blank.gif"></td>
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
	    <br/>
	    &nbsp;<img src="/HairSalon/images/scheduler/legend_available.gif">&nbsp;Available&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_unavailable.gif">&nbsp;Unavailable&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_green.gif">&nbsp;Unlocked&nbsp;
	    <img src="/HairSalon/images/scheduler/legend_gray.gif">&nbsp;Locked&nbsp;
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
                        cells[cells.length] = new Cell("<%=i + ""%>^-^<%=j + ""%>", emptyState);
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
		if (movableSchedules != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<ScheduleBean> sbs = null;
				for (EmployeeBean cycle : movableSchedules.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						sbs = movableSchedules.get(cycle);
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
                        addIntialEntry(<%=duration%>,<%=startOffset%>,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>),<%=sbb.getScheduleNo()%>);
                    <%
					}
				}
			}
		}
    %>
</script>    
<script>
    <%
		if (unmovableSchedules != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<ScheduleBean> sbs = null;
				for (EmployeeBean cycle : unmovableSchedules.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						sbs = unmovableSchedules.get(cycle);
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
                        addUnmovableSchedulesIntialEntry(<%=duration%>,<%=startOffset%>,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>),<%=sbb.getScheduleNo()%>);
                    <%
					}
				}
			}
		}
    %>
</script> 
<script>
    <%
		if (availabilityExceptions != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<AvailabilityExceptionBean> aebs = null;
				for (EmployeeBean cycle : availabilityExceptions.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						aebs = availabilityExceptions.get(cycle);
					}
				}

				if (aebs != null) {
					int duration = (endHour - startHour + 1) * 4;
                    %>
                        addExceptionEntry(<%=duration%>,0,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>));
                    <%
				}
			}
		}
    %>
</script>    
<script>
    <%
		if (scheduleExceptions != null) {
			for (EmployeeBean eb : employees) {
				int duration = (endHour - startHour + 1) * 4;
                    %>
                        addExceptionEntry(<%=duration%>,0,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>));
                    <%
			}
		}
    %>
</script>
<script>
    <%
		if (unschedulables != null) {
			for (EmployeeBean eb : employees) {
				ArrayList<ScheduleBean> sbs = null;
				for (EmployeeBean cycle : unschedulables.keySet()) {
					if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
						sbs = unschedulables.get(cycle);
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
                        addExceptionEntry(<%=duration%>,<%=startOffset%>,getColumnIDFromEmployeeNo(<%=eb.getEmployeeNo()%>));
                    <%
					}
				}
			}
		}
    %>
</script>    
<script>//disableSelection(document.body)</script>