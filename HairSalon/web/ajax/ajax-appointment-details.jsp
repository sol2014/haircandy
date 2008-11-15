<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.application.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.presentation.tags.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<%
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute("user_session");

//Grab the load result from the UserSession
AppointmentBean appointment = (AppointmentBean) userSession.moveAttribute("temp_appointment");
if (appointment == null)
{
    appointment = (AppointmentBean) request.getAttribute("appointment_load_result");
    
    if (appointment == null)
    {
	appointment = new AppointmentBean ();
	appointment.setClient (new ClientBean ());
	appointment.setEmployee (new EmployeeBean());
    }
}

ClientBean client = appointment.getClient();
EmployeeBean employee = appointment.getEmployee();

String employeeNo = "";
if (appointment.getEmployee() != null && appointment.getEmployee().getEmployeeNo () != null)
	employeeNo = Integer.toString (appointment.getEmployee().getEmployeeNo());
%>
<!-- WILL DELETE FROM HERE -->

<script>
    function setGuest ()
    {
	document.getElementById("first_name").value = "Guest";
	document.getElementById("last_name").value = "Guest";
	document.getElementById("phone_number").value = "0000000000";
    }

    function finished(firstName, lastName)
    {
	document.getElementById("first_name").value = firstName;
	document.getElementById("last_name").value = lastName;
    }

    function findClient ()
    {
	if (document.getElementById("phone_number") != null)
	{
	    var phoneNumber = document.getElementById("phone_number").value;
	    var messager = new Ajaxer();
	    var queryString="client_action=ClientLookup&";
	    queryString += "phone_number="+phoneNumber;
	    messager.request("client",queryString);
	}
    }
    
    function doClose ()
    {
	showBlackout (false);
        document.getElementById("appointment_dialog_shell").style.display="none";
    }
    
</script>

<font face="Trebuchet MS" size="2">
    <div id="appointment_dialog">
	<% LogController.write ("APPOINTMENT: "+appointment.getAppointmentNo()); %>
	<input type="hidden" id="app_no" value="<%=appointment.getAppointmentNo()%>">
	<input type="hidden" id="app_employee" value="<%=employeeNo%>">
	<input type="hidden" id="app_date" value="<%=CoreTools.showDate (appointment.getDate(), CoreTools.DateFormat)%>">
	<input type="hidden" id="app_start_time" value="<%=CoreTools.showTime (appointment.getStartTime(), CoreTools.TimeFormat)%>">
	<input type="hidden" id="app_end_time" value="<%=CoreTools.showTime (appointment.getEndTime(), CoreTools.TimeFormat)%>">

	<table id="dialog_table" bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
		<td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Edit Appointment Entry</font></b></td>
		<td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
	    </tr>
	    <tr>
		<td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
		<td align="left" valign="top" width="100%">
		    <div valign="top" style="overflow:auto; overflow-y: auto; overflow-x: hidden;">
			<table valign="top" border="0" width="100%" cellspacing="10" cellpadding="0">
			    <tr>
				<td valign="top">
				    <table>
					<tr>
					    <td>
				    <% String firstName = null; %>
				    <% String lastName = null; %>
				    <% String phoneNumber = null; %>
				    <% if (client != null) { %>
					<% firstName = client.getFirstName (); lastName = client.getLastName(); phoneNumber = client.getPhoneNumber(); %>
				    <% } %>
				    <table align="right" valign="top" border="0" cellpadding="0">
					<tr>
					    <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/client_white.gif" width="16" height="16"></td>
					    <td nowrap="nowrap" align="left"><u><b>Client Details</b></u></td>
					</tr>
					<tr>
					    <td id="first_name_label" nowrap="nowrap" align="right">First Name:</td>
					    <td nowrap="nowrap" align="left"><input type="text" name="first_name" id="first_name" size="20" value="<%=ServletHelper.display (firstName)%>"></td>
					</tr>
					<tr>

					    <td id="last_name_label" nowrap="nowrap" align="right">Last Name:</td>
					    <td nowrap="nowrap" align="left"><input type="text" name="last_name" id="last_name" size="20" value="<%=ServletHelper.display (lastName)%>"></td>
					</tr>
					<tr>

					    <td id="phone_number_label" nowrap="nowrap" align="right"><div id="telephone_label">Telephone:</div></td>
					    <td nowrap="nowrap" align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (phoneNumber)%>">
						<img style="cursor:pointer" align="absmiddle" src="images/icons/small/find_white.gif" onclick="findClient()" title="Find and load client from this phone number."/>
						<img style="cursor:pointer" align="absmiddle" src="images/icons/small/personal_white.gif" onclick="setGuest()" title="Use a guest identity."/>
					    </td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right">&nbsp;</td>
					    <td nowrap="nowrap" align="left">&nbsp;</td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/appointment_white.gif" width="16" height="16"></td>
					    <td nowrap="nowrap" align="left"><u><b>Appointment Details</b></u></td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right">Employee:</td>
					    <td nowrap="nowrap" align="left"><b><%=appointment.getEmployee().getFirstName()%></b></td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right">Date:</td>
					    <td nowrap="nowrap" align="left"><b><%=CoreTools.showDate (appointment.getDate(), CoreTools.DateFormat)%></b></td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right">Start Time:</td>
					    <td nowrap="nowrap" align="left"><b><%=CoreTools.showTime (appointment.getStartTime(), CoreTools.AMPMFormat)%></b></td>
					</tr>
					<tr>
					    <td nowrap="nowrap" align="right">End Time:</td>
					    <td nowrap="nowrap" align="left"><b><%=CoreTools.showTime (appointment.getEndTime(), CoreTools.AMPMFormat)%></b></td>
					</tr>
				    </table>
				    </td>
				    </tr>
				    <tr>
					<td>
				    <table align="center">
					<tr>
					    <td>
						<input type="button" onclick="doFinish()" value="Finish" class="StandardButton" /><br/>
                                                <% 
                                                if (appointment.getAppointmentNo() != null)
                                                {
                                                    %> 
                                                    <input type="button" onclick="doDelete()" id="deleteButton" value="Delete" class="StandardButton" /><br/>
                                                    <%
						}
                                                %>
						<input type="button" onclick="doClose()" value="Close" class="StandardButton" /><br/>
						<div id="operResult"></div>
					    </td>
					</tr>
				    </table>
					    </td>
					</tr>
				    </table>
				</td>

				<td valign="top" width="100%">
				    <table valign="top" width="100%" height="100%" align="left" border="0" cellpadding="0" cellspacing="0">
					<tr>
					    <td width="100%" align="left" valign="top">
						<div id="servicesList">

						</div>
						<br />
					    </td>
					</tr>
					<tr>
					    <td width="100%" align="left" valign="top">
						<div id="productsList">

						</div>
					    </td>
					</tr>
				    </table>
				</td>
			    </tr>
			</table>
		    </div>
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
        <%
            Enumeration<ProductBean> pe = appointment.getProducts().keys();
            while (pe.hasMoreElements()) {
                ProductBean pb = pe.nextElement();%>
                    addInitialProduct ('<%=pb.getProductNo()%>', '<%=pb.getName()%>', '<%=pb.getPrice()%>', '<%=appointment.getProducts().get(pb)%>');
        <% }%>
            
        <%
            Enumeration<ServiceBean> se = appointment.getServices().keys();
            while (se.hasMoreElements()) {
                ServiceBean sb = se.nextElement();%>
                    addInitialService ('<%=sb.getServiceNo()%>', '<%=sb.getName()%>', '<%=sb.getPrice()%>','<%=appointment.getServices().get(sb)%>');
        <% }%>
</script>
<script>window.setTimeout(refillProductsList, 500, "JavaScript");</script>
<script>window.setTimeout(refillServicesList, 500, "JavaScript");</script>