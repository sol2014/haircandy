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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
  
<%-- Retrieve the UserSession object from the http session. --%>
<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
int recordNo = 0;
%>

<%-- Set the next page position for navigator. --%>
<% userSession.setCurrentPosition (SessionPositions.AppCalendar);%>

<%-- Set the title of the page. --%>
<% String page_title = "Appointments"; %>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- Grab any feedback or erros that the servlet may want to show page --%>
<% String feedback_string = (String) userSession.moveAttribute ("schedule_feedback"); %>
<% String error_string = (String) userSession.moveAttribute ("schedule_error"); %>

<script>
function goToCalendarDay (day)
{
    location.replace ("view-appointments.jsp?date="+day);
}

function highlightDay (day)
{
    document.getElementById(day).className = "CalendarCellSelected";
}

function unlightDay (day)
{
    document.getElementById(day).className = "CalendarCell";
}
</script>

<font face="Trebuchet MS" size="2">
    <div align="left" id="littleCal"></div>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/calendar.js"></script>
<script>
    var today = new Date();
    refreshCalender(today.getFullYear(),today.getMonth());
</script>