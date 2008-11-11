<div class="DialogBox" id="preferences_dialog" style="width:680px;height:240px">
    <table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	    <td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
	    <td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Account Preferences</font></b></td>
	    <td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
	</tr>
	<tr>
	    <td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
	    <td width="100%">
		
		<!-- CONTENT START -->
		
		<table border="0" cellspacing="10" cellpadding="0">
		    <tr>
			<td valign="top" align="left">
			    <table border="0" cellpadding="0">
				<tr>
				    <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/employee_white.gif" width="16" height="16"></td>
				    <td nowrap="nowrap" align="left"><b><u>Employee Details</u></b></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Full Name:</td>
				    <td nowrap="nowrap" align="left"><b><%=ServletHelper.display (userSession.getEmployee ().getName ())%></b> ID: <b><%=ServletHelper.display(userSession.getEmployee().getEmployeeNo ())%></b></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Telephone:</td>
				    <td nowrap="nowrap" align="left"><b><%=ServletHelper.displayPhoneNumber (userSession.getEmployee().getPhoneNumber())%></b></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">&nbsp;</td>
				    <td nowrap="nowrap" align="left">&nbsp;</td>
				</tr>
				<tr>
				    <td align="right"><img border="0" src="/HairSalon/images/icons/small/login_white.gif" width="16" height="16"></td>
				    <td align="left"><b><u>Password Change</u></b></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Old Password:</td>
				    <td align="left"><input type="password" name="old_password" size="15"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">New Password:</td>
				    <td align="left"><input type="password" name="new_password" size="15"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Repeat:</td>
				    <td align="left"><input type="password" name="repeat_password" size="15"></td>
				</tr>
				<tr>
				    <td colspan="2" width="100%" align="center"><br/><input type="button" onclick="closePreferences()" value="Finish" class="StandardButton"/></td>
				</tr>
			    </table>
			</td>
			<td valign="top" align="left">
			    <table border="0" cellpadding="0">
				<tr>
				    <td align="right"><img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
				    <td align="left"><b><u>Availability Hours</u></b></td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_monday") == null) { %>
				    <td align="right"><u>Monday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Monday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this)" id="monday_check" value="monday"></td>
				</tr>

				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("monday_start", userSession.getEmployee ().getMondayStart())%> Finish: <%=ServletHelper.generateHourPicker ("monday_end", userSession.getEmployee ().getMondayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_tuesday") == null) { %>
				    <td align="right"><u>Tuesday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Tuesday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="tuesday_check" value="tuesday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					 <%=ServletHelper.generateHourPicker ("tuesday_start", userSession.getEmployee ().getTuesdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("tuesday_end", userSession.getEmployee ().getTuesdayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_wednesday") == null) { %>
				    <td align="right"><u>Wednesday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Wednesday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="wednesday_check" value="wednesday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("wednesday_start", userSession.getEmployee ().getWednesdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("wednesday_end", userSession.getEmployee ().getWednesdayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_thursday") == null) { %>
				    <td align="right"><u>Thursday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Thursday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="thursday_check" value="thursday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("thursday_start", userSession.getEmployee ().getThursdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("thursday_end", userSession.getEmployee ().getThursdayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_friday") == null) { %>
				    <td align="right"><u>Friday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Friday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="friday_check" value="friday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("friday_start", userSession.getEmployee ().getFridayStart())%> Finish: <%=ServletHelper.generateHourPicker ("friday_end", userSession.getEmployee ().getFridayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_saturday") == null) { %>
				    <td align="right"><u>Satuday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Saturday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="saturday_check" value="saturday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("saturday_start", userSession.getEmployee ().getSaturdayStart())%> Finish: <%=ServletHelper.generateHourPicker ("saturday_end", userSession.getEmployee ().getSaturdayEnd())%>
				    </td>
				</tr>
				<tr>
				    <% if (userSession.moveAttribute ("employee_error_sunday") == null) { %>
				    <td align="right"><u>Sunday:</u></td>
				    <% } else { %>
				    <td align="right"><font color="red"><u>Sunday:</u></font></td>
				    <% } %>
				    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="sunday_check" value="sunday"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Start:</td>
				    <td nowrap="nowrap" align="left">
					<%=ServletHelper.generateHourPicker ("sunday_start", userSession.getEmployee ().getSundayStart())%> Finish: <%=ServletHelper.generateHourPicker ("sunday_end", userSession.getEmployee ().getSundayEnd())%>
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

<script language="javascript" src="js/time-addin.js"></script>

 <script>
     updateDays ();
 </script>
 
<script>
    
</script>