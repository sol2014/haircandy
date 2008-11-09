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
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");

userSession.setNextPosition (SessionPositions.MaintainClient);

ClientBean client = (ClientBean) userSession.moveAttribute ("temp_client");
if (client == null)
{
    client = (ClientBean) userSession.moveAttribute ("client_load_result");
}

AddressBean address = client.getAddress ();
int recordNo = client.getClientNo ();

String page_title = "Client #"+client.getClientNo();

// Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("client_feedback");
String error_string = (String) userSession.moveAttribute ("client_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="/HairSalon/client">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/client_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Client #<%=client.getClientNo ()%> - <%=client.getName ()%></font></b><br>
		    Provide the basic details of the client, they will be used when making sales or
		    booking appointments into the schedule. They are normally created automatically.
		    <br><br>
		    
		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64 (client);%>
		    <input type="hidden" name="temp_client" value="<%=encodedBytes%>"/>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="client_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="client_action" class="StandardButton"/>
		    
		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><font color="red"><%=CoreTools.display (error_string)%></font><% } %>
		    <% if (feedback_string != null) { %><font color="green"><%=CoreTools.display (feedback_string)%></font><% } %>
		</td>
	    </tr>
	</table>
	
	<table border="0" cellspacing="10" cellpadding="0">
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
			    <td align="left"><input type="text" name="first_name" value="<%=CoreTools.display (client.getFirstName ())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("client_error_last_name") == null) { %>
			    <td align="right">Last Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Last Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="last_name" value="<%=CoreTools.display (client.getLastName ())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("client_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" value="<%=CoreTools.display (client.getPhoneNumber ())%>" size="10"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=CoreTools.generateTrueFalseOptions ("enabled", Boolean.toString (client.getEnabled ()))%></td>
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
			    <td align="left"><input type="text" name="address1" value="<%=CoreTools.display (address.getAddress1 ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" value="<%=CoreTools.display (address.getAddress2 ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" value="<%=CoreTools.display (address.getEmail ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">City:</td>
			    <td align="left"><input type="text" name="city" value="<%=CoreTools.display (address.getCity ())%>" size="15"></td>
			</tr>
			<tr>
			    <td align="right">Province:</td>
			    <td align="left"><input type="text" name="province" value="<%=CoreTools.display (address.getProvince ())%>" size="15"></td>
			</tr>
			<tr>
			    <td align="right">Country:</td>
			    <td align="left"><input type="text" name="country" value="<%=CoreTools.display (address.getCountry ())%>" size="15"></td>
			</tr>
			<tr>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=CoreTools.display (address.getPostalCode ())%>" size="6"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
