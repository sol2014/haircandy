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
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
userSession.setCurrentPosition (SessionPositions.Login);
String page_title = "Login";

int recordNo = 0;

//Grab any errors that the servlet may want to show the page
String error_string = (String) userSession.moveAttribute ("login_error");

// testing for the Cookie
Cookie[] cookies = request.getCookies ();
String username = "", password = "";

for (Cookie cookie : cookies)
{
    LogController.write ("Cookie: " + cookie.getName ());
    if (cookie.getName ().equals ("USERNAME"))
    {
	// This is the username cookie
	username = cookie.getValue ();
    }
    else if (cookie.getName ().equals ("PASSWORD"))
    {
	try
	{
	    // Reading value from the cookie, decrypt.
	    if (cookie.getValue () != null)
	    {
		password = cookie.getValue ();
	    }
	    else
	    {
		password = "";
	    }
	    
	    LogController.write (this, "PASSWORD STRING: " + password);
	}
	catch (Exception e)
	{
	    LogController.write (this, "Cannot decode cookie data: " + cookie.getValue ());
	    password = "";
	}
    }
}
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="session">
	<table height="100%" width="100%" border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="left" valign="top"><img border="0" src="/HairSalon/images/icons/big/login_white.gif" width="48" height="48"></td>
		<td align="left" valign="top"><b><font size="3">Employee Login!</font></b><br>
			Employees of the hair salon must log into the system in order to
			    make changes to the information. If you are a hair salon employee please provide the
			    necessary credentials below. If you are having difficulty logging into the system,
		    please contact the system administrator!
		    <br /><br />
		    <table>
			<tr>
			    <td align="right">Employee ID:</td>
			    <td><input type="text" value="<%=CoreTools.display (username)%>" size="5" name="login_id" /></td>
			</tr>
			<tr>
			    <td align="right">Password:</td>
			    <td><input type="password" value="<%=CoreTools.display (password)%>" size="15" name="login_password" /></td>
			</tr>
		    </table>
		    <br />
		    <input type="submit" value="Login" name="session_action" class="StandardButton"/> 
		    <input type="reset" value="Clear" name="reset_button" class="StandardButton"/>
		    <br />
		    
		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><br><font color="red"><%=error_string%></font><% } %>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>