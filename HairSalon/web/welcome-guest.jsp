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
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.objects.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<% UserSession userSession = (UserSession)session.getAttribute ("user_session"); %>
<% userSession.setCurrentPosition(SessionPositions.GuestWelcome); %>
<%
String page_title = "Welcome Guest";
int recordNo = 0;
%>

<%
if (userSession.isGuest ())
{
    // We want to check to see if we have a cookie in the request that
    // already logs in this user.
    Cookie[] cookies = request.getCookies ();
    String username = "", password = "";

    if(cookies != null)
    {
	for (Cookie cookie :cookies)
	{
	    if (cookie.getName ().equals ("USERNAME"))
	    {
		// This is the username cookie
		username = cookie.getValue ();
	    }
	    else if (cookie.getName().equals ("PASSWORD"))
	    {
		try
		{
		    if (cookie.getValue() != null)
			password = cookie.getValue();
		    else
			password = "";
		}
		catch (Exception e)
		{
		    LogController.write (this, "Cannot decode password from cookie: "+cookie.getValue());
		    password = "";
		}
	    }
	}
    }
}
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <table valign="top" border="0" cellspacing="5" cellpadding="0">
	<tr>
	    <td align="left" valign="top"><img border="0" src="/HairSalon/images/icons/big/welcome_white.gif" width="48" height="48"></td>
	    <td align="left" valign="top"><b><font size="3">Welcome to the Hair Salon!</font></b><br>
		    This system is a web interface that allows our clients 
			and employees to book service appointments into the schedule that is 
			maintained by the salon managers. It requires some basic client 
			information (like name and phone number) to allow booking of 
			appointments. As new clients are booked into the site, their information 
			is stored in our database for easy future bookings.<br>
			<br>
			The changes made to the schedule are done in real-time, so there are 
			some restrictions that will be enforced when clients are booking, that 
			may not be enforced for the receptionists of the salon. A waiting list 
			is available if you would prefer to get booked into a time slot that is 
	    not currently available.</td>
	</tr>
    </table>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
