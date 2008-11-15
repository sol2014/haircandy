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

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");
EmployeeBean employee = (EmployeeBean)userSession.moveAttribute ("employee_load_result");
%>

<font face="Trebuchet MS" size="2">
    <div id="availability_dialog" style="width:382px;height:451px">
	<table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
		<td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Change Availability</font></b></td>
		<td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
	    </tr>
	    <tr>
		<td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
		<td width="100%">

		    <!-- CONTENT START -->

		    <table valign="top" align="center" border="0" cellspacing="10" cellpadding="0">
			<tr>
			    <td valign="top" align="left">
				<table border="0" cellpadding="0">
				    <tr>
					<td colspan="2" align="left">Provide your work availability so that the managers can schedule shifts appropriately.</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_monday_check" value="monday"><b>Available on Monday</b></td>
				    </tr>

				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_monday_start", employee.getMondayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_monday_end", employee.getMondayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_tuesday_check" value="tuesday"><b>Available on Tuesday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					     <%=ServletHelper.generateHourPicker ("availability_tuesday_start", employee.getTuesdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_tuesday_end", employee.getTuesdayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_wednesday_check" value="wednesday"><b>Available on Wednesday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_wednesday_start", employee.getWednesdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_wednesday_end", employee.getWednesdayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_thursday_check" value="thursday"><b>Available on Thursday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_thursday_start", employee.getThursdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_thursday_end", employee.getThursdayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_friday_check" value="friday"><b>Available on Friday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_friday_start", employee.getFridayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_friday_end", employee.getFridayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_saturday_check" value="saturday"><b>Available on Saturday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_saturday_start", employee.getSaturdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_saturday_end", employee.getSaturdayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td align="right"></td>
					<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'availability')" id="availability_sunday_check" value="sunday"><b>Available on Sunday</b></td>
				    </tr>
				    <tr>
					<td nowrap="nowrap" align="right">Start:</td>
					<td nowrap="nowrap" align="left">
					    <%=ServletHelper.generateHourPicker ("availability_sunday_start", employee.getSundayStart())%> Finish: <%=ServletHelper.generateHourPicker ("availability_sunday_end", employee.getSundayEnd())%>
					</td>
				    </tr>
				    <tr>
					<td colspan="2" width="100%" align="center">
					    <div id="availability_error"></div><br/><input type="button" onclick="applyAvailability(<%=employee.getEmployeeNo ()%>)" value="Apply" class="StandardButton"/>
					    &nbsp;<input type="button" onclick="cancelAvailability ()" value="Cancel" class="StandardButton"/>
					</td>
				    </tr>
				</table>
			    </td>
			</tr>
		    </table>

		    <!-- CONTENT END -->

		</td>
		<td height="100%" background="images/scheduler/scheduler_right.gif"></td>
	    </tr>
	    <tr>
		<td><img src="images/site_bottomleft.gif" width="2" height="2" /></td>
		<td width="100%" background="images/scheduler/scheduler_bottom.gif"><img src="images/scheduler/scheduler_bottom.gif" width="90" height="2" /></td>
		<td><img src="images/scheduler/scheduler_bottomright.gif" width="2" height="2" /></td>
	    </tr>
	</table>
    </div>
</font>