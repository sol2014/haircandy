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

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Date date = sdf.parse(request.getParameter("date"));
            sdf = new SimpleDateFormat("EEEEEEEEE, MMMMMMMMM d, yyyy");

            EmployeeBean ebb = new EmployeeBean();
            AddressBean ab = new AddressBean();
            ebb.setAddress(ab);

            EmployeeBean[] arrayEmployees = SessionController.searchEmployees(userSession, ebb);
            ArrayList<EmployeeBean> employees = new ArrayList<EmployeeBean>();

            for (int i = 0; i < arrayEmployees.length; i++) {
                employees.add(arrayEmployees[i]);
            }

            Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions = SessionController.getAvailabilityExceptions(userSession, date);
            ArrayList<ScheduleExceptionBean> scheduleExceptions = SessionController.getScheduleExceptions(userSession, date);
            Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedules = SessionController.getSchedule(userSession, date, availabilityExceptions, scheduleExceptions);

            SalonBean sb = SessionController.loadSalon(userSession, new SalonBean());
            int weekDay = CoreTools.getWeekDay(date);
            Date startTime = sb.getWeekdayStartTime(weekDay);
            Date endTime = sb.getWeekdayEndTime(weekDay);
            int startHour = CoreTools.getStartHour(startTime);
            int endHour = CoreTools.getEndHour(endTime);
            int rowCount = 0;
%>

<%!
    private String getCSSClass(int startHour, int row, EmployeeBean eb, Hashtable<EmployeeBean, ArrayList<ScheduleBean>> schedules, Hashtable<EmployeeBean, ArrayList<AvailabilityExceptionBean>> availabilityExceptions, ArrayList<ScheduleExceptionBean> scheduleExceptions) {
        if (scheduleExceptions != null) {
            return "SchedulerCellSectionMiddle_Stone";
        }
        if (availabilityExceptions != null) {
            for (EmployeeBean cycle : availabilityExceptions.keySet()) {
                if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
                    return "SchedulerCellSectionMiddle_Stone";
                }
            }
        }
        if (schedules != null) {
            ArrayList<ScheduleBean> sbs = null;
            for (EmployeeBean cycle : schedules.keySet()) {
                if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
                    sbs = schedules.get(cycle);
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
                            return "SchedulerCellSectionSingle";
                        }
                        if (row == startOffset) {
                            return "SchedulerCellSectionTop";
                        } else if (row == endOffset - 1) {
                            return "SchedulerCellSectionBottom";
                        } else {
                            return "SchedulerCellSectionMiddle";
                        }
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
                    <td align="left"><font size="3"><b>Employee Schedule: <%=sdf.format(date)%></b></font><br>
                        You may either create, delete or move schedule entries for different employees. Some areas may be
                        darkened which means there are exceptions blocking those employee.
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
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
                            <% for (int i = startHour; i <= endHour; i++) {%>
                            <tr>
                                <td class="SchedulerTime"><span class="TimeFont"><%=CoreTools.getAMPMHour(i)%>:00<%=CoreTools.getAMPM(i)%></span></td>
                                
                                <% for (int j = 0; j < employees.size(); j++) {%>
                                <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <% for (int k = 0; k < 4; k++) {%>
                                        <tr>
                                            <td id="<%=rowCount + k%>^-^<%=j%>" onclick="cellSingleClickHandler(this)" ondblclick="cellDoubleClickHandler(this)"  onmousedown="cellMouseDownHandler(event, this)" class="<%=getCSSClass(startHour, rowCount + k, employees.get(j), schedules, availabilityExceptions, scheduleExceptions)%>"><img src="images/site_blank.gif"></td>
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
        </td>
    </tr>
    <tr>
        <td>
            <table align="left" valign="top" border="0" cellspacing="5" cellpadding="0">
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
        </td>
    </tr>
</table>
<script language="javascript" src="js/scheduler.js"></script>
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
            if (schedules != null) {
                for (EmployeeBean eb : employees) {
                    ArrayList<ScheduleBean> sbs = null;
                    for (EmployeeBean cycle : schedules.keySet()) {
                        if (cycle.getEmployeeNo().equals(eb.getEmployeeNo())) {
                            sbs = schedules.get(cycle);
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
<script>//disableSelection(document.body)</script>