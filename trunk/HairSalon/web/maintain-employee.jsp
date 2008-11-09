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
		    <% if (error_string != null) {%><font color="red"><%=CoreTools.display(error_string)%></font><% }%>
		    <% if (feedback_string != null) {%><font color="green"><%=CoreTools.display(feedback_string)%></font><% }%>
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
			    <td align="left"><input type="text" name="first_name" value="<%=CoreTools.display(employee.getFirstName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_last_name") == null) { %>
			    <td align="right">Last Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Last Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="last_name" value="<%=CoreTools.display(employee.getLastName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" value="<%=CoreTools.display(employee.getPhoneNumber())%>" size="10"></td>
			</tr>
			<tr>
			    <td align="right">Role:</td>
			    <td align="left"><select size="1" name="role"><%=CoreTools.generateUserRoleOptions (employee.getRole (), false)%></select></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_password") == null) { %>
			    <td align="right">Password:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Password:</font></td>
			    <% } %>
			    <td align="left"><input type="password" name="password" value="<%=CoreTools.display(employee.getPassword())%>" size="15"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=CoreTools.generateTrueFalseOptions ("enabled", Boolean.toString (employee.getEnabled ()))%></td>
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
			    <td align="left"><input type="text" name="address1" value="<%=CoreTools.display(address.getAddress1())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_address2") == null) { %>
			    <td align="right">Address 2:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 2:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address2" value="<%=CoreTools.display(address.getAddress2())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_email") == null) { %>
			    <td align="right">Email:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Email:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="email" value="<%=CoreTools.display(address.getEmail())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" value="<%=CoreTools.display(address.getCity())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" value="<%=CoreTools.display(address.getProvince())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" value="<%=CoreTools.display(address.getCountry())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("employee_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=CoreTools.display(address.getPostalCode())%>" size="6"><i>(ex. N4N4N4)</i></td>
			</tr>
			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
			    <td align="left"><b><u>Availability</u></b></td>
			</tr>
			<tr>
			    <td align="right">Monday:</td>
			    <td align="left"><input type="text" name="monday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getMondayStart())%>"> to
			    <input type="text" name="monday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getMondayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Tuesday:</td>
			    <td align="left"><input type="text" name="tuesday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getTuesdayStart())%>"> to
			    <input type="text" name="tuesday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getTuesdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Wednesday:</td>
			    <td align="left"><input type="text" name="wednesday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getWednesdayStart())%>"> to
			    <input type="text" name="wednesday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getWednesdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Thursday:</td>
			    <td align="left"><input type="text" name="thursday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getThursdayStart())%>"> to
			    <input type="text" name="thursday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getThursdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Friday:</td>
			    <td align="left"><input type="text" name="friday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getFridayStart())%>"> to
			    <input type="text" name="friday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getFridayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Saturday:</td>
			    <td align="left"><input type="text" name="saturday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getSaturdayStart())%>"> to
			    <input type="text" name="saturday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getSaturdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Sunday:</td>
			    <td align="left"><input type="text" name="sunday_start" size="5" value="<%=CoreTools.showMilitaryTime(employee.getSundayStart())%>"> to
			    <input type="text" name="sunday_end" size="5" value="<%=CoreTools.showMilitaryTime(employee.getSundayEnd())%>"></td>
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
<script>
<% if (employee.getAvailabilityExceptions() != null && employee.getAvailabilityExceptions().size() > 0) {
                for (AvailabilityExceptionBean e : employee.getAvailabilityExceptions()) {%>
    addIntialException('<%=CoreTools.display(e.getDate())%>','<%=CoreTools.display(e.getReason())%>');
<%}
            }%>
            
<% if (employee.getServices() != null && employee.getServices().size() > 0) {
 for (ServiceBean service : employee.getServices()) {%>
 addIntialService('<%=CoreTools.display(service.getServiceNo())%>','<%=CoreTools.display(service.getName())%>');
<%}}%>
 </script>
 <script>refillServicesList();</script>
 <script>refillExceptionsList();</script>