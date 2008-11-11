<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
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
userSession.setNextPosition (SessionPositions.CreateClient);
String page_title = "New Client";
int recordNo = 0;

String error_string = (String) userSession.moveAttribute ("client_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="client">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/client_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Create new Client</font></b><br>
		    Provide the basic details of the supplier in order to create the new record. You do
		    not need to create client records manually, they are added automatically by the system.
		    <br><br>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Finish" name="client_action" class="StandardButton"/>
		    
		    <% if (error_string != null) { %>
		    <font color="red">
		    <%=error_string%>
		    </font>
		    <%  }%>
		</td>
	    </tr>
	</table>
    
	<table width="100%" border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="left" valign="top">
		    <table align="left" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/personal_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Personal Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("client_error_first_name") == null) { %>
			    <td align="right">First Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">First Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="first_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_first_name"))%>">
			    </font></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("client_error_last_name") == null) { %>
			    <td align="right">Last Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Last Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="last_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_last_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("client_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_phone_number"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("client_new_enabled"))%></td>
			</tr>
			
			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/address_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Address Details</b></u></td>
			</tr>
			<tr>
			    <td align="right">Address 1:</td>
			    <td align="left"><input type="text" name="address1" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_address1"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_address2"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_email"))%>"></td>
			</tr>
			<tr>
			    <td align="right">City:</td>
			    <td align="left"><input type="text" name="city" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_city"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Province:</td>
			    <td align="left"><input type="text" name="province" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_province"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Country:</td>
			    <td align="left"><input type="text" name="country" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_country"))%>"></td>
			</tr>
			<tr>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" size="6" value="<%=ServletHelper.display (userSession.moveAttribute ("client_new_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
