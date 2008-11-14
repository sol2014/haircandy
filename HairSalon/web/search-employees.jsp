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
<%@page import="java.util.*" %>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute ("user_session");

//Set the current page position for navigator
userSession.setCurrentPosition (SessionPositions.Employees);

//Set the page title for header
String page_title = "Employees";
int recordNo = 0;

// Grab the search result set if there is one in the UserSession
EmployeeBean[] employees = (EmployeeBean[]) userSession.moveAttribute ("employee_search_result");

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("employee_search_feedback");
String error_string = (String) userSession.moveAttribute ("employee_search_error");
%>

<%-- Make sure to show the page header so that the header, navigation bar and menu show up --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="employee">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Employees</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get list
		    of employees that are in the salon database. A new employee can also be created if needed.
		    <br><br>

		    <%-- Now we want to add the button that will allow the user to search --%>
		    <input type="submit" value="Search" name="employee_action" class="StandardButton"/>
		    <input type="reset" value="Clear Fields" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Employee" name="employee_action" class="StandardButton"/>

		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><br><font color="red"><%=error_string%></font><% } %>
		    <% if (feedback_string != null) { %><br><font color="green"><%=feedback_string%></font><% } %>
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
			    <td align="right">First Name:</td>
			    <td align="left"><input type="text" name="first_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_first_name"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Last Name:</td>
			    <td align="left"><input type="text" name="last_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_last_name"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Telephone:</td>
			    <td align="left"><input type="text" name="phone_number" size="10" onkeypress="return isNumberTyped (event)" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_phone_number"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Role:</td>
			    <td align="left"><select size="1" name="role"><%=ServletHelper.generateUserRoleOptions ((String) userSession.moveAttribute ("employee_search_role"), true)%></select></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("employee_search_enabled"))%></td>
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
			    <td align="left"><input type="text" name="address1" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_address1"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_address2"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_email"))%>"></td>
			</tr>
			<tr>
			    <td align="right">City:</td>
			    <td align="left"><input type="text" name="city" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_city"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Province:</td>
			    <td align="left"><input type="text" name="province" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_province"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Country:</td>
			    <td align="left"><input type="text" name="country" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_country"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Postal Code:</td>
			    <td align="left"><input type="text" name="postal_code" size="6" value="<%=ServletHelper.display (userSession.moveAttribute ("employee_search_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>

		<%-- This is the auto-search that will do a basic empty search for convenience --%>
		<% if (employees == null) {
			    EmployeeBean emptySearch = new EmployeeBean ();
			    AddressBean emptyAddress = new AddressBean ();
			    emptySearch.setAddress (emptyAddress);
			    employees = SessionController.searchEmployees (userSession, emptySearch); } %>
		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (employees != null && employees.length > 0) { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=employees.length%>)</font></b></td>
				<% } else { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
				<% }%>
			    </tr>
			    <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (employees == null || employees.length < 1) { %>
					<tr align="right" valign="middle">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
					</tr>
					<% } else { %>
					<tr align="right">
					    <td height="20" nowrap="nowrap" class="Row1"></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
					    <td align="left" nowrap="nowrap" class="Row1"><b>Role</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Telephone</b></td>
					</tr>

					<% for (EmployeeBean employee : employees) { %>
					<tr align="right" valign="middle">
					    <td height="30" valign="top" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
					    <td align="left" valign="top" nowrap="nowrap" class="Row2"><span class="SearchLink"><a href="employee?employee_action=Load&employee_no=<%= employee.getEmployeeNo ()%>" class="SearchLink"><%= employee.getName ()%></a></span></td>
					    <td align="left" valign="top" nowrap="nowrap" class="Row7"><%= employee.getRole ()%></td>
					    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.displayPhoneNumber(employee.getPhoneNumber ())%></td>
					</tr>
					<% }%>
					<% }%>
				    </table>
				</td>
			    </tr>
			</table>
		    </div>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
