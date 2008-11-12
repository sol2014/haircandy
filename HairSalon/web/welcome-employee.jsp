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
<%@page import="hs.presentation.*" %>
<%@page import="hs.app.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession)session.getAttribute ("user_session");

SalonBean salon = SessionController.loadSalon (userSession, new SalonBean());

userSession.setCurrentPosition(SessionPositions.EmployeeWelcome);
String page_title = "Welcome Employee";
int recordNo = 0;
String error_string = (String) userSession.moveAttribute ("alert_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<script>
    var request;
    try {
        request = new XMLHttpRequest();
    } catch (trymicrosoft) {
        try {
            request = new ActiveXObject("Msxml2.XMLHTTP.5.0");
        } catch (othermicrosoft) {
            try {
                request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (failed) {
                request = false;
            }
        }
    }
    if(!request){
        alert("Oh my, are you using safari?Come on, use a normal browser like CMonkey");
    }
    
    function deleteAlert (element)
    {
	var queryString="alert_action=Delete&";
	queryString+="alert_no="+escape(element.id)+"&";
	request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        request.send(queryString);
    }
</script>

<font face="Trebuchet MS" size="2">
    <form onsubmit="deleteAlert()" method="POST" action="product">
    <table height="100%" width="100%" border="0" cellspacing="5" cellpadding="0">
	<tr>
	    <td align="left" valign="top">
	    <img border="0" src="/HairSalon/images/icons/big/welcome_white.gif" width="48" height="48"></td>
	    <td width="100%" align="left" valign="top"><b><font size="3">Welcome to: <%=salon.getName()%></font></b><br />
		<b>Telephone: </b><%=ServletHelper.displayPhoneNumber(salon.getPhoneNumber())%><br />
		<b>Address: </b><%=ServletHelper.display (salon.getAddress1())%>, <%=ServletHelper.display (salon.getAddress2())%><br />
		<b>City: </b><%=ServletHelper.display (salon.getCity ())%><br/><br/>
	    </td>
	</tr>
	<tr>
	    <td align="left" valign="top"></td>
	    <td align="left" valign="top">
		<font size="3"><b>System Alerts</b></font><br/>
    The alerts listed below are created by events that occur in the system that you need to be aware of.<br/>
    <br/>
    <% AlertBean[] alerts = SessionController.loadAlerts (userSession); %>
    
<% if (error_string != null) {%>
		    <font color="red"><%=ServletHelper.display (error_string)%></font>
		    <% }%>
		    
    <table align="left" width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
	<tr align="left">
	    <% if (alerts != null && alerts.length > 0) { %>
	    <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Alerts Generated (<%=alerts.length%>)</b></td>
	    <% } else { %>
	    <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Alerts Generated (None)</b></td>
	    <% }%>
	</tr>
	<tr>
	    <td>
		<table width="100%" cellspacing="1" cellpadding="4" border="0">
		    <% if (alerts == null || alerts.length < 1) { %>
		    <tr align="right" valign="middle">
			<td colspan="3" align="left" class="Row2"><b>There are currently no alerts.</b></td>
		    </tr>
		    <% } else { %>
		    <tr align="right">
			<td height="20" nowrap="nowrap" class="Row1"></td>
			<td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Message</b></td>
			<% if (userSession.getEmployee ().getRole ().equals ("Manager")) { %>
			<td height="20" nowrap="nowrap" class="Row1"></td>
			<% } %>
		    </tr>

		    <% for (AlertBean alert : alerts) { %>
		    <tr align="right" valign="middle">
			<td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/medium/<%=ServletHelper.displayAlertIcon (alert.getLevel())%>.gif" width="22" height="22" />&nbsp;</td>
			<td align="left" class="Row2"><span class="SearchLink"><a href="<%=ServletHelper.display (alert.getLink ())%>" class="SearchLink"><%=ServletHelper.display (alert.getMessage ())%></a></span></td>
			<% if (userSession.getEmployee ().getRole ().equals ("Manager")) { %>
			    <td nowrap="nowrap" class="Row7"><img style="cursor:pointer" id="<%=alert.getAlertNo ()%>" src="/HairSalon/images/icons/small/remove_white.gif" onclick="deleteAlert(this)" title="Delete this alert from the list." /></td>
			<% } %>
		    </tr>
		    <% }%>
		    <% }%>
		</table>
	    </td>
	</tr>
    </table>
	    </td>
	</tr>
    </table>
</form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>