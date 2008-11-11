<div class="DialogBox" id="preferences_dialog" style="width: 475px;height: 250px;">
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
				    <td align="right"></td>
				    <td align="left">&nbsp;</td>
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
			    </table>
			</td>
			<td valign="top" align="left">
			    <table border="0" cellpadding="0">
				<tr>
				    <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
				    <td nowrap="nowrap" align="left"><b><u>Availability</u></b></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Monday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="monday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getMondayStart())%>"> to
				    <input type="text" name="monday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getMondayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Tuesday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="tuesday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getTuesdayStart())%>"> to
				    <input type="text" name="tuesday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getTuesdayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Wednesday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="wednesday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getWednesdayStart())%>"> to
				    <input type="text" name="wednesday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getWednesdayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Thursday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="thursday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getThursdayStart())%>"> to
				    <input type="text" name="thursday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getThursdayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Friday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="friday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getFridayStart())%>"> to
				    <input type="text" name="friday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getFridayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Saturday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="saturday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getSaturdayStart())%>"> to
				    <input type="text" name="saturday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getSaturdayEnd())%>"></td>
				</tr>
				<tr>
				    <td nowrap="nowrap" align="right">Sunday:</td>
				    <td nowrap="nowrap" align="left"><input type="text" name="sunday_start" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getSundayStart())%>"> to
				    <input type="text" name="sunday_end" size="5" value="<%=CoreTools.showTime(userSession.getEmployee().getSundayEnd())%>"></td>
				</tr>
			    </table>
			</td>
		    </tr>
		    <tr>
			<td colspan="2" align="center">
			    <input type="button" onclick="closePreferences()" value="Finish" class="StandardButton"/>
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

<script>
    document.getElementById("preferences_dialog").style.left = (getScreenWidth() / 2) - 225 + "px";
    document.getElementById("preferences_dialog").style.top = (getScreenHeight() / 2) - 125 + "px";
</script>