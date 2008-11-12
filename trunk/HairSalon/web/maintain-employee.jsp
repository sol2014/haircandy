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
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute("user_session");

//Set the next page position for navigator
userSession.setNextPosition(SessionPositions.MaintainEmployee);

EmployeeBean employee = (EmployeeBean) userSession.moveAttribute ("temp_employee");
if (employee == null)
{
    employee = (EmployeeBean) userSession.moveAttribute("employee_load_result");
}

AddressBean address = employee.getAddress();
int recordNo = employee.getEmployeeNo ();

//Set the page title for header
String page_title = "Employee #" + employee.getEmployeeNo();

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute("employee_feedback");
String error_string = (String) userSession.moveAttribute("employee_error");
%>

<%-- Make sure to show the page header so that the header, navigation bar and menu show up --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<script type="text/javascript">
var dp_cal;
window.onload = function () {
	dp_cal  = new Epoch('epoch_popup','popup',document.getElementById('exceptionDate'));
};
</script>

<font face="Trebuchet MS" size="2">
    <form id="postForm" onsubmit="doSubmit()" method="POST" action="employee">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/employees_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Employee #<%=employee.getEmployeeNo ()%> - <%=employee.getName ()%></font></b><br>
		    Provide the basic details of the employee. You must also provide which services can be
		    performed by this employee if any, and any availability exceptions in effect.
		    <br><br>

		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64(employee);%>
		    <input type="hidden" name="temp_employee" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="employee_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="employee_action" class="StandardButton"/>
		    
		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) {%><font color="red"><%=ServletHelper.display(error_string)%></font><% }%>
		    <% if (feedback_string != null) {%><font color="green"><%=ServletHelper.display(feedback_string)%></font><% }%>
		</td>
	    </tr>
	</table>

	<table border="0" width="100%" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="right" valign="top">
		    <table align="right" border="0" cellpadding="0" width="250">
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
			    <td align="left"><input type="text" name="first_name" value="<%=ServletHelper.display(employee.getFirstName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_last_name") == null) { %>
			    <td align="right">Last Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Last Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="last_name" value="<%=ServletHelper.display(employee.getLastName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" value="<%=ServletHelper.display(employee.getPhoneNumber())%>" size="10"></td>
			</tr>
			<tr>
			    <td align="right">Role:</td>
			    <td align="left"><select size="1" name="role"><%=ServletHelper.generateUserRoleOptions (employee.getRole (), false)%></select></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_password") == null) { %>
			    <td align="right">Password:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Password:</font></td>
			    <% } %>
			    <td align="left"><input type="password" name="password" value="<%=ServletHelper.display(employee.getPassword())%>" size="15"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", Boolean.toString (employee.getEnabled ()))%></td>
			</tr>
			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/address_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Address Details</b></font></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_address1") == null) { %>
			    <td align="right">Address 1:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 1:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address1" value="<%=ServletHelper.display(address.getAddress1())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_address2") == null) { %>
			    <td align="right">Address 2:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 2:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address2" value="<%=ServletHelper.display(address.getAddress2())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_email") == null) { %>
			    <td align="right">Email:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Email:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="email" value="<%=ServletHelper.display(address.getEmail())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" value="<%=ServletHelper.display(address.getCity())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" value="<%=ServletHelper.display(address.getProvince())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" value="<%=ServletHelper.display(address.getCountry())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=ServletHelper.display(address.getPostalCode())%>" size="6"><i>(ex. N4N4N4)</i></td>
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
				<%=ServletHelper.generateHourPicker ("employee_monday_start", employee.getMondayStart())%>
				
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_monday_end", employee.getMondayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_tuesday_start", employee.getTuesdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_tuesday_end", employee.getTuesdayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_wednesday_start", employee.getWednesdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_wednesday_end", employee.getWednesdayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_thursday_start", employee.getThursdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_thursday_end", employee.getThursdayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_friday_start", employee.getFridayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_friday_end", employee.getFridayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_saturday_start", employee.getSaturdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_saturday_end", employee.getSaturdayEnd())%>
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
				<%=ServletHelper.generateHourPicker ("employee_sunday_start", employee.getSundayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("employee_sunday_end", employee.getSundayEnd())%>
			    </td>
			</tr>
		    </table>
		</td>

		<td valign="top" width="100%">
		    <table align="left" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
			    <td width="100%" align="left" valign="top">
				<div id="servicesList">
				    
				</div>
				<br />
			    </td>
			</tr>
			<tr>
			    <td width="100%" align="left" valign="top">
				<div id="exceptionsList">
				
				</div>
			    </td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
	
	<%@ include file="dialogs/employee-service-dialog.jsp" %>
	<%@ include file="dialogs/employee-exception-dialog.jsp" %>
    </form>
</font>

<%-- END PAGE CONTENT --%>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/employee-addin.js"></script>
<script language="javascript" src="js/time-addin.js"></script>

<script>
<% if (employee.getAvailabilityExceptions() != null && employee.getAvailabilityExceptions().size() > 0) {
                for (AvailabilityExceptionBean e : employee.getAvailabilityExceptions()) {%>
    addIntialException('<%=ServletHelper.display(e.getDate())%>','<%=ServletHelper.display(e.getReason())%>');
<%}
            }%>
            
<% if (employee.getServices() != null && employee.getServices().size() > 0) {
 for (ServiceBean service : employee.getServices()) {%>
 addIntialService('<%=ServletHelper.display(service.getServiceNo())%>','<%=ServletHelper.display(service.getName())%>');
<%}}%>
 </script>
 
  <script>
     updateDays ("employee");
 </script>
 
 <script>refillServicesList();</script>
 <script>refillExceptionsList();</script>