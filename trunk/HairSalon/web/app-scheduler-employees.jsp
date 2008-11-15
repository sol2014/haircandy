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
<taglib:ValidateEmployee minimum="Receptionist" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%-- Retrieve the UserSession object from the http session. --%>
<%
// Retrieve the UserSession object from the http session.
		UserSession userSession = (UserSession) session.getAttribute("user_session");
		int recordNo = 0;

		userSession.setCurrentPosition(SessionPositions.AppScheduler);
		String page_title = "Appointments";

		Date date = CoreTools.getDate(request.getParameter("date"));
%>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- Grab any feedback or erros that the servlet may want to show page --%>
<% String feedback_string = (String) userSession.moveAttribute("schedule_feedback");%>
<% String error_string = (String) userSession.moveAttribute("schedule_error");%>

<font face="Trebuchet MS" size="2">
    <div align="left" id="matrix"></div>
</font>


<%@ include file="dialogs/appointment-dialog.jsp" %>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
<div id="infoWindow" class="infoWindow" style="border-width: 2px; border-color: #CCC; border-style: solid; background-color: #ffffff; width: 80px; height:28px;">
    <font face="Trebuchet MS" size="1"><b>
    <div width="100%" align="center" id="infoStartTime"></div>
    <div width="100%" align="center" id="infoEndTime"></div>
    </b></font>
</div>

<script language="javascript" src="js/appointment-employees-addin.js"></script>
<script language="javascript" src="js/appointment-addin.js"></script>
<div id="justForReExecutue" style="display:none;"></div>
<script>
    function fillJS(content)
    {
        set_innerHTML("justForReExecutue",content);
        //setInnerHTML(document.getElementById("justForReExecutue"), content);
    }
    function fillHTML(content)
    {
        //set_innerHTML("matrix",content);
        //setInnerHTML(document.getElementById("matrix"), content);
        document.getElementById("matrix").innerHTML = content;
        requestJS();
    }
    function requestJS()
    {
        var messager = new Ajaxer("text",null,fillJS,null);
        var queryString="date=<%=request.getParameter("date")%>";
        messager.request("ajax/ajax-app-scheduler-js.jsp",queryString);
    }
    function getMatrix()
    {
        var messager = new Ajaxer("text",null,fillHTML,null);
        var queryString="date=<%=request.getParameter("date")%>";
        if(draggableDiv.style.display!="block")
        {
            messager.request("ajax/ajax-app-scheduler-html.jsp",queryString);
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