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
UserSession userSession = (UserSession) session.getAttribute ("user_session");
userSession.setNextPosition (SessionPositions.CreateService);
String page_title = "New Service";
int recordNo = 0;

String feedback_string = (String) userSession.moveAttribute ("service_feedback");
String error_string = (String) userSession.moveAttribute ("service_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form name="form" method="POST" action="service">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/service_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Create new Service</font></b><br>
		    Provide the basic details of the service in order to create the new record. You will have the
		    chance to provide more complex links after the record is saved into the database.
		    <br><br>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Finish" name="service_action" class="StandardButton"/>
		    
		    <% if (feedback_string != null) { %>
		    <font color="green">
		    <%=feedback_string%>
		    </font>
		    <%  }%>
		    <% if (error_string != null) { %>
		    <font color="red">
		    <%=error_string%>
		    </font>
		    <%  }%>
		</td>
	    </tr>
	</table>
	
	<table border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="right" valign="top">
		    <table align="right" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/service_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Service Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_name") == null) { %>
			    <td align="right">Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="firstfield" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("service_new_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_description") == null) { %>
			    <td align="right">Description:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Description:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="description" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("service_new_description"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_duration") == null) { %>
			    <td align="right">Duration:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Duration:</font></td>
			    <% } %>
			    <td align="left"><%=ServletHelper.generateDurationPicker ("duration", (Integer)userSession.moveAttribute ("service_new_duration"))%></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_price") == null) { %>
			    <td align="right">Price:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Price:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="price" size="5" style="text-align:right" onkeypress="return isDecimalTyped (event)" value="<%=ServletHelper.display (userSession.moveAttribute ("service_new_price"))%>">$</td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("service_new_enabled"))%></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
