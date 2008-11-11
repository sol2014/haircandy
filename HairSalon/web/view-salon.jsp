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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
// Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute("user_session");

// Set the next page position for navigator
userSession.setCurrentPosition(SessionPositions.Salon);

// Set the page title for header
String page_title = "Salon";
int recordNo = 0;

SalonBean salon = (SalonBean) userSession.moveAttribute ("temp_salon");
if (salon == null)
{
    salon = SessionController.loadSalon(userSession, new SalonBean());
}

// Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute("salon_feedback");
String error_string = (String) userSession.moveAttribute("salon_error");
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
    <form id="postForm" onsubmit="doSubmit()" method="POST" action="salon">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="left" valign="top"><img border="0" src="/HairSalon/images/icons/big/salon_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Salon Details</font></b><br>
		    The following settings will be used to identify the salon, but also limit the number of
		    employees in the schedule at any one time. Also the default hours of operation are also
		    set here, they will dictate when schedule entries and appointments can be booked.
		    <br><br>

		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64(salon);%>
		    <input type="hidden" name="temp_salon" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="salon_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="salon_action" class="StandardButton"/>

		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) {%><font color="red"><%=ServletHelper.display(error_string)%></font><% }%>
		    <% if (feedback_string != null) {%><font color="green"><%=ServletHelper.display(feedback_string)%></font><% }%>
		</td>
	    </tr>
	</table>

	<table border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="center" valign="top">
		    <table border="0" cellpadding="0" cellspacing="3" width="260">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/salon_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Salon Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_salon_name") == null) { %>
			    <td align="right">Salon Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Salon Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="salon_name" value="<%=ServletHelper.display(salon.getName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (salon.getPhoneNumber())%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_tax") == null) { %>
			    <td align="right">Tax Rate:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Tax Rate:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="tax" style="text-align:right" value="<%=ServletHelper.display(salon.getTaxRate())%>" size="5">%</td>
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
			    <% if (userSession.moveAttribute ("salon_error_address1") == null) { %>
			    <td align="right">Address 1:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 1:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address1" value="<%=ServletHelper.display(salon.getAddress1())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" value="<%=ServletHelper.display(salon.getAddress2())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_email") == null) { %>
			    <td align="right">Email:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Email:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="email" value="<%=ServletHelper.display(salon.getEmail())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" value="<%=ServletHelper.display(salon.getCity())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" value="<%=ServletHelper.display(salon.getProvince())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" value="<%=ServletHelper.display(salon.getCountry())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=ServletHelper.display(salon.getPostalCode())%>" size="6"><i>(ie. N4N4N4)</i></td>
			</tr>

			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>

			<tr>
			    <td nowrap="nowrap" align="right">
			    <img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
			    <td nowrap="nowrap" align="left"><b><u>Default Business Hours</u></b></td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_monday") == null) { %>
			    <td align="right">Monday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Monday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this)" id="monday_check" value="monday"></td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("monday_start", salon.getMondayStart())%>
				
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("monday_end", salon.getMondayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_tuesday") == null) { %>
			    <td align="right">Tuesday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Tuesday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="tuesday_check" value="tuesday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("tuesday_start", salon.getTuesdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("tuesday_end", salon.getTuesdayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_wednesday") == null) { %>
			    <td align="right">Wednesday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Wednesday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="wednesday_check" value="wednesday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("wednesday_start", salon.getWednesdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("wednesday_end", salon.getWednesdayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_thursday") == null) { %>
			    <td align="right">Thursday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Thursday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="thursday_check" value="thursday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("thursday_start", salon.getThursdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("thursday_end", salon.getThursdayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_friday") == null) { %>
			    <td align="right">Friday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Friday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="friday_check" value="friday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("friday_start", salon.getFridayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("friday_end", salon.getFridayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_saturday") == null) { %>
			    <td align="right">Satuday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Saturday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="saturday_check" value="saturday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("saturday_start", salon.getSaturdayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("saturday_end", salon.getSaturdayEnd())%>
			    </td>
			</tr>
			
			<tr>
			    <td nowrap="nowrap" align="right">&nbsp;</td>
			    <td nowrap="nowrap" align="left">&nbsp;</td>
			</tr>
			
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_sunday") == null) { %>
			    <td align="right">Sunday:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Sunday:</font></td>
			    <% } %>
			    <td nowrap="nowrap" align="left"><input type="checkbox" onChange="switchDayStatus(this)" id="sunday_check" value="sunday"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Open:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("sunday_start", salon.getSundayStart())%>
			    </td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Close:</td>
			    <td nowrap="nowrap" align="left">
				<%=ServletHelper.generateHourPicker ("sunday_end", salon.getSundayEnd())%>
			    </td>
			</tr>
		    </table>
		</td>

		<td width="100%" align="left" valign="top">
		    <div id="exceptionsList">
			
		    </div>
		</td>
	    </tr>
	</table>

	<%@ include file="dialogs/salon-exception-dialog.jsp" %>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/salon-addin.js"></script>
<script language="javascript" src="js/time-addin.js"></script>

<script>
<% if (salon.getExceptions() != null && salon.getExceptions().size() > 0) {
                for (ScheduleExceptionBean e : salon.getExceptions()) {%>
    addIntialException('<%=ServletHelper.display(e.getDate())%>','<%=ServletHelper.display(e.getReason())%>');
<%}
            }%>
 </script>
 
 <script>
     updateDays ();
 </script>
 
 <script>refillExceptionsList();</script>