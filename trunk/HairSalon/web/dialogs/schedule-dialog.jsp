<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<font face="Trebuchet MS" size="2">
<div id="dialog" class="DialogBox" style="width: 300px;height:150px;">
    <table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
            <td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Edit Schedule Entry</font></b></td>
            <td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
        </tr>
        <tr>
            <td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
            <td width="100%">
                    <table border="0" width="100%" cellspacing="10" cellpadding="0">
                        <tr>
                            <td align="right" valign="top">
                                <table align="left" valign="top" border="0" cellpadding="0" width="100%">
                                    <tr>
                                        <td align="right"><img border="0" src="/HairSalon/images/icons/small/schedule_white.gif" width="16" height="16"></td>
                                        <td align="left"><u><b>Schedule Details</b></u></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Employee:</td>
					<td align="left"><b><div id="sch_employee_name">Unknown</div></b></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Date:</td>
					<td align="left"><b><div id="sch_date">Unknown</div></b></td>
                                    </tr>
				    <tr>
                                        <td align="right">Start Time:</td>
					<td align="left"><b><div id="sch_start_time">Unknown</div></b></td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap" align="right">Shift Length:</td>
                                        <td nowrap="nowrap" align="left">
                                            <select id="hourDuration">
                                                <option value ="0">0</option>
                                                <option value ="1">1</option>
                                                <option value ="2">2</option>
                                                <option value ="3">3</option>
                                                <option value ="4">4</option>
                                                <option value ="5">5</option>
                                                <option value ="6">6</option>
                                                <option value ="7">7</option>
                                                <option value ="8">8</option>
                                                <option value ="9">9</option>
                                                <option value ="10">10</option>
                                                <option value ="11">11</option>
                                                <option value ="12">12</option>
                                            </select>
					    hour(s)&nbsp;
					    <select id="minuteDuration">
                                                <option value ="0">0</option>
                                                <option value ="15">15</option>
                                                <option value ="30">30</option>
                                                <option value ="45">45</option>
                                            </select>
					    minutes
                                        </td>
                                    </tr>
				    <tr>
                                        <td align="right">End Time:</td>
					<td align="left"><b><div id="sch_end_time">Unknown</div></b></td>
                                    </tr>
                                </table>
			    </td>
			</tr>
			    
			<tr>
			    <td>
                                <table border="0">
                                    <tr>
                                        <td nowrap="nowrap" align="center">
                                            <input type="button" value="Finish" onclick="getDuration()">
					    <input type="button" id="deleteButton" value="Delete" onclick="deleteSchedule()">
					    <input type="button" value="Close" onclick="closeDialog()">
					    <font color="red"><span id="errorMessage">&nbsp;</span></font>
                                        </td>
                                    </tr>
                                </table>
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
    document.getElementById("dialog").style.left = (getScreenWidth() / 2) - 150 + "px";
    document.getElementById("dialog").style.top = (getScreenHeight() / 2) - 80 + "px";
</script>
