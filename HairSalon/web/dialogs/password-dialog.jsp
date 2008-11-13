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
EmployeeBean employee2 = (EmployeeBean)userSession.getEmployee();
%>

<font face="Trebuchet MS" size="2">
    <div class="DialogBox" id="password_dialog" style="width:252px;height:144px">
	<table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
		<td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Change Password</font></b></td>
		<td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
	    </tr>
	    <tr>
		<td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
		<td width="100%">
		    <table valign="top" border="0" cellspacing="10" cellpadding="0">
			<tr>
			    <td colspan="2" align="left">Provide the old/current password, then provide a new password of at least 5 characters, twice.</td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right"><div id="old_label">Old Password:</div></td>
			    <td align="left"><input type="password" id="old_password" size="15"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right"><div id="new_label">New Password:</div></td>
			    <td align="left"><input type="password" id="new_password" size="15"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right"><div id="repeat_label">Repeat:</div></td>
			    <td align="left"><input type="password" id="repeat_password" size="15"></td>
			</tr>
			<tr>
			    <td colspan="2" width="100%" align="center">
				<br/><input type="button" onclick="applyPassword(<%=employee2.getEmployeeNo ()%>)" value="Apply" class="StandardButton"/>&nbsp;
				<input type="button" onclick="cancelPassword()" value="Cancel" class="StandardButton"/>
			    </td>
			</tr>
		    </table>
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

<script>
    document.getElementById("password_dialog").style.left = (getScreenWidth() / 2) - (document.getElementById("password_dialog").clientWidth / 2) + "px";
    document.getElementById("password_dialog").style.top = (getScreenHeight() / 2) - ((document.getElementById("password_dialog").clientHeight / 2)-200)  + "px";
</script>