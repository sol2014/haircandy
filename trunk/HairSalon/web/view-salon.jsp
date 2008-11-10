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
		<td align="left"><b><font size="3">Maintain Salon Information</font></b><br>
		    Many of these settings will affect the way the application treats the scheduling and the user interaction when certain limits are reached. Also, sales transactions will use the tax percentage
			set by the manager and cannot be overriden by employees. Business hours will be observed when allowing a manager to maintain the
		    schedule.
		    <br><br>

		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64(salon);%>
		    <input type="hidden" name="temp_salon" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="salon_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="salon_action" class="StandardButton"/>

		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) {%><font color="red"><%=CoreTools.display(error_string)%></font><% }%>
		    <% if (feedback_string != null) {%><font color="green"><%=CoreTools.display(feedback_string)%></font><% }%>
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
			    <td align="left"><input type="text" name="salon_name" value="<%=CoreTools.display(salon.getName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=CoreTools.display (salon.getPhoneNumber())%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_tax") == null) { %>
			    <td align="right">Tax Rate:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Tax Rate:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="tax" style="text-align:right" value="<%=CoreTools.display(salon.getTaxRate())%>" size="5">%</td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_hair_stations") == null) { %>
			    <td align="right">Hair Stations:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Hair Stations:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="hair_stations" style="text-align:right" value="<%=CoreTools.display(salon.getHairStations())%>" size="5"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_beauty_stations") == null) { %>
			    <td align="right">Beauty Stations:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Beauty Stations:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="beauty_stations" style="text-align:right" value="<%=CoreTools.display(salon.getBeautyStations())%>" size="5"></td>
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
			    <td align="left"><input type="text" name="address1" value="<%=CoreTools.display(salon.getAddress1())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" value="<%=CoreTools.display(salon.getAddress2())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_email") == null) { %>
			    <td align="right">Email:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Email:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="email" value="<%=CoreTools.display(salon.getEmail())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" value="<%=CoreTools.display(salon.getCity())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" value="<%=CoreTools.display(salon.getProvince())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" value="<%=CoreTools.display(salon.getCountry())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("salon_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=CoreTools.display(salon.getPostalCode())%>" size="6"><i>(ie. N4N4N4)</i></td>
			</tr>

			<tr>
			    <td align="right">&nbsp;</td>
			    <td align="left">&nbsp;</td>
			</tr>

			<tr>
			    <td align="right">
			    <img border="0" src="/HairSalon/images/icons/small/availability_white.gif" width="16" height="16"></td>
			    <td align="left"><b><u>Business Hours</u></b></td>
			</tr>
			<tr>
			    <td align="right">Monday:</td>
			    <td align="left"><input type="text" name="monday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getMondayStart())%>"> to
			    <input type="text" name="monday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getMondayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Tuesday:</td>
			    <td align="left"><input type="text" name="tuesday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getTuesdayStart())%>"> to
			    <input type="text" name="tuesday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getTuesdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Wednesday:</td>
			    <td align="left"><input type="text" name="wednesday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getWednesdayStart())%>"> to
			    <input type="text" name="wednesday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getWednesdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Thursday:</td>
			    <td align="left"><input type="text" name="thursday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getThursdayStart())%>"> to
			    <input type="text" name="thursday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getThursdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Friday:</td>
			    <td align="left"><input type="text" name="friday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getFridayStart())%>"> to
			    <input type="text" name="friday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getFridayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Saturday:</td>
			    <td align="left"><input type="text" name="saturday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getSaturdayStart())%>"> to
			    <input type="text" name="saturday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getSaturdayEnd())%>"></td>
			</tr>
			<tr>
			    <td align="right">Sunday:</td>
			    <td align="left"><input type="text" name="sunday_start" size="5" value="<%=CoreTools.showMilitaryTime(salon.getSundayStart())%>"> to
			    <input type="text" name="sunday_end" size="5" value="<%=CoreTools.showMilitaryTime(salon.getSundayEnd())%>"></td>
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
<script>
<% if (salon.getExceptions() != null && salon.getExceptions().size() > 0) {
                for (ScheduleExceptionBean e : salon.getExceptions()) {%>
    addIntialException('<%=CoreTools.display(e.getDate())%>','<%=CoreTools.display(e.getReason())%>');
<%}
            }%>
 </script>
 <script>refillExceptionsList();</script>