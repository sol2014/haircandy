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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
// Retrieve the UserSession object from the http session.
UserSession userSession = (UserSession) session.getAttribute("user_session");
int recordNo = 0;

userSession.setCurrentPosition(SessionPositions.SchScheduler);
String page_title = "Employee Schedule";

Date date = CoreTools.getDate (request.getParameter("date"));
%>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- Grab any feedback or erros that the servlet may want to show page --%>
<% String feedback_string = (String) userSession.moveAttribute("schedule_feedback");%>
<% String error_string = (String) userSession.moveAttribute("schedule_error");%>

<font face="Trebuchet MS" size="2">
    <div align="left" id="matrix"></div>
    
</font>

<%@ include file="dialogs/schedule-dialog.jsp" %>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/scheduler-managers-addin.js"></script>

<script>
    function updatePage ()
    {
        getMatrix();
    }
    
    function updateHours ()
    {
        var start_hour = parseInt(document.getElementById ("start_time_hour").value);
        var start_min = parseInt(document.getElementById ("start_time_min").value);
        var start_ampm = document.getElementById ("start_time_ampm").value;
        
        if (start_ampm != null && start_ampm == "PM")
        {
            if (start_hour != 12)
                start_hour += 12;
        }
        else
        {
            if (start_hour == 12)
                start_hour = 0;
        }
        
        var start = start_hour+":"+start_min;
        
        var end_hour = parseInt(document.getElementById ("end_time_hour").value);
        var end_min = parseInt(document.getElementById ("end_time_min").value);
        var end_ampm = document.getElementById ("end_time_ampm").value;
        
        if (end_ampm != null && end_ampm == "PM")
        {
            if (end_hour != 12)
                end_hour += 12;
        }
        else
        {
            if (end_hour == 12)
                end_hour = 0;
        }
        
        var end = end_hour+":"+end_min;
        
        var ajax = new Ajaxer("text",null,updatePage,null);
        var queryString="schedule_action=UpdateHours&";
        
        queryString+="date="+'<%=request.getParameter("date")%>'+"&";
        queryString+="start_time="+start+"&";
        queryString+="end_time="+end+"&";
        
        alert (queryString);
        
        ajax.request("schedule", queryString);
    }
</script>

<script>
    function getMatrix()
    {
        function fillMatrix(content)
        {
            //document.getElementById("matrix").innerHTML = "";
            setInnerHTML(document.getElementById("matrix"),content);
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
        window.setTimeout(repeat, 10000, "JavaScript");
        getMatrix();
    }
</script>
<script>window.setTimeout(repeat, 10000, "JavaScript");</script>