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
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
// Retrieve the UserSession object from the http session.
UserSession userSession = (UserSession) session.getAttribute("user_session");
EmployeeBean employee = userSession.getEmployee();

int recordNo = 0;

userSession.setCurrentPosition(SessionPositions.SchScheduler);
String page_title = "Employee Schedule";

Date date = CoreTools.getDate (request.getParameter("date"));

ScheduleHoursBean shb = new ScheduleHoursBean();
shb.setDate(date);
shb = SessionController.loadScheduleHours(userSession, shb);

EmployeeHoursBean ehb = new EmployeeHoursBean ();
ehb.setEmployeeNo (userSession.getEmployee().getEmployeeNo ());
ehb.setDate (date);
ehb = SessionController.loadEmployeeHours (userSession, ehb);

Date myStartTime = null;
Date myEndTime = null;

if (ehb != null)
{
    myStartTime = ehb.getStartTime ();
    myEndTime = ehb.getEndTime ();
}
else
{
    myStartTime = employee.getWeekdayStartTime (CoreTools.getWeekDay (date));
    myEndTime = employee.getWeekdayEndTime (CoreTools.getWeekDay (date));
}

Date startTime = shb.getStartTime();
Date endTime = shb.getEndTime();
%>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- Grab any feedback or erros that the servlet may want to show page --%>
<% String feedback_string = (String) userSession.moveAttribute("schedule_feedback");%>
<% String error_string = (String) userSession.moveAttribute("schedule_error");%>

<font face="Trebuchet MS" size="2">
    <div align="left" id="matrix"></div>
    <br/>
    <table>
	<tr>
	    <td align="right"><img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
	    <td align="left"><u><b>Change Today's Hours</b></u></td>
	</tr>
	<% if (userSession.getEmployee().getRole().equals("Manager")) {%>
	<tr>
	    <td align="right" nowrap="nowrap"><b>Salon Hours:</b></td>
	    <td width="100%" align="left" nowrap="nowrap" style="z-index: 1;">
	        <%=ServletHelper.generateHourPicker("start_time", startTime)%> to <%=ServletHelper.generateHourPicker("end_time", endTime)%> <input id="update_salon_hours_button" type="button" value="Update" onclick="updateSalonHours('<%=request.getParameter("date")%>')" title="This will update today's salon business hours.">
	    </td>
	</tr>
	<% }%>
	<tr>
	    <td align="right" nowrap="nowrap"><b>My Hours:</b></td>
	    <td width="100%" align="left" nowrap="nowrap">
		<%=ServletHelper.generateHourPicker("employee_start_time", myStartTime)%> to <%=ServletHelper.generateHourPicker("employee_end_time", myEndTime)%> <input id="update_employee_hours_button" type="button" value="Update" onclick="updateEmployeeHours(<%=employee.getEmployeeNo()%>,'<%=request.getParameter("date")%>')" title="This will update your availability hours for today.">
	    </td>
	</tr>
	<tr>
	    <td align="right" nowrap="nowrap"></td>
	    <td width="100%" align="left" nowrap="nowrap">
		<font color="red"><div id="hours_error"></div></font>
	    </td>
	</tr>
    </table>
</font>

<%@ include file="dialogs/schedule-dialog.jsp" %>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<div id="infoWindow" class="infoWindow" style="border-width: 2px; border-color: #CCC; border-style: solid; background-color: #fffccc; width: 80px; height:28px;">
    <font face="Trebuchet MS" size="1"><b>
    <div width="100%" align="center" id="infoStartTime"></div>
    <div width="100%" align="center" id="infoEndTime"></div>
    </b></font>
</div>

<script language="javascript" src="js/scheduler-managers-addin.js"></script>
<script language="javascript" src="js/time-addin.js"></script>

<script>
    function getMatrix()
    {
        function fillMatrix(content)
        {
            //document.getElementById("matrix").innerHTML = "";
            //setInnerHTML(document.getElementById("matrix"),content);
            set_innerHTML("matrix",content);
        }
        var messager = new Ajaxer("text",null,fillMatrix,null);
        var queryString="date=<%=request.getParameter("date")%>";
        if(draggableDiv.style.display!="block")
        {
            messager.request("ajax/ajax-sch-scheduler.jsp",queryString);
        }
    }
    getMatrix();
</script>

<script>disableSelection(document.body)</script>

<script>
    function repeat()
    {
        window.setTimeout(repeat, 60000, "JavaScript");
        getMatrix();
    }
</script>
<script>window.setTimeout(repeat, 60000, "JavaScript");</script>


<script>
    function goDate (date)
    {
	window.location = "app-scheduler-managers.jsp?date="+date;
    }
</script>
