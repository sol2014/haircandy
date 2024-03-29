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
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
userSession.setNextPosition (SessionPositions.CreateEmployee);
String page_title = "New Employee";
int recordNo = 0;

String error_string = (String) userSession.moveAttribute ("employee_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="employee">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/employees_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Create new Employee</font></b><br>
		    Provide the basic details of the employee in order to create the new record. You will have the
		    chance to provide more complex links after the record is saved into the database.
		    <br><br>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Finish" name="employee_action" class="StandardButton"/>
		    
		    <% if (error_string != null) { %>
		    <font color="red">
		    <%=error_string%>
		    </font>
		    <%  }%>
		</td>
	    </tr>
	</table>
	
	<table align="left" width="100%" border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="left" valign="top">
		    <table align="left" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/personal_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Personal Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_first_name") == null) { %>
			    <td align="right">First Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">First Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="first_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_first_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_last_name") == null) { %>
			    <td align="right">Last Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Last Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="last_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_last_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onkeypress="return isNumberTyped (event)" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_phone_number"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Role:</td>
			    <td align="left"><select size="1" name="role"><%=ServletHelper.generateUserRoleOptions ((String) userSession.moveAttribute ("employee_new_role"), false)%></select></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_password") == null) { %>
			    <td align="right">Password:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Password:</font></td>
			    <% } %>
			    <td align="left"><input type="password" name="password" size="15"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("employee_new_enabled"))%></td>
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
			    <% if (userSession.moveAttribute ("employee_error_address1") == null) { %>
			    <td align="right">Address 1:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 1:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address1" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_address1"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_address2"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_email") == null) { %>
			    <td align="right">Email:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Email:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="email" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_email"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_city"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_province"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_country"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" size="6" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_new_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			</tr>
			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
			    <td align="left"><b><u>Availability Hours</u></b></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_monday") == null) { %>
			    <td align="right">Monday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Monday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_monday_check" value="monday"></td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_monday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_monday_start")))%>
				
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_monday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_monday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_tuesday") == null) { %>
			    <td align="right">Tuesday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Tuesday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_tuesday_check" value="tuesday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_tuesday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_tuesday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_tuesday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_tuesday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_wednesday") == null) { %>
			    <td align="right">Wednesday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Wednesday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_wednesday_check" value="wednesday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_wednesday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_wednesday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_wednesday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_wednesday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_thursday") == null) { %>
			    <td align="right">Thursday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Thursday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_thursday_check" value="thursday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_thursday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_thursday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_thursday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_thursday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_friday") == null) { %>
			    <td align="right">Friday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Friday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_friday_check" value="friday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_friday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_friday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_friday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_friday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_saturday") == null) { %>
			    <td align="right">Satuday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Saturday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_saturday_check" value="saturday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_saturday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_saturday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_saturday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_saturday_end")))%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_sunday") == null) { %>
			    <td align="right">Sunday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Sunday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'employee')" id="employee_sunday_check" value="sunday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_sunday_start", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_sunday_start")))%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_sunday_end", CoreTools.getTime((String)userSession.moveAttribute ("employee_new_sunday_end")))%>
			    </td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

 <script>
     updateDays ("employee");
 </script>
 