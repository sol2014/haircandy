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

SimpleDateFormat tf = new SimpleDateFormat (CoreTools.AMPMFormat);
SimpleDateFormat df = new SimpleDateFormat (CoreTools.DateFormat);

SimpleDateFormat tf2 = new SimpleDateFormat (CoreTools.FullTimeFormat);
SimpleDateFormat df2 = new SimpleDateFormat (CoreTools.DateFormat);

String employeeNo = "";
if (appointment.getEmployee() != null && appointment.getEmployee().getEmployeeNo () != null)
	employeeNo = Integer.toString (appointment.getEmployee().getEmployeeNo());
%>
<!-- WILL DELETE FROM HERE -->
<html>
    <head>
	<meta http-equiv="Content-Language" content="en-us">
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	<link href="css/Main.css" rel="stylesheet" type="text/css">
	<link href="css/Scheduler.css" rel="stylesheet" type="text/css">
	<link href="css/Shadow.css" rel="stylesheet" type="text/css">
        <link href="css/Calendar.css" rel="stylesheet" type="text/css">
	<link href="css/epoch_styles.css" rel="stylesheet" type="text/css" />
	
	<script type="text/javascript" language="javascript" src="js/preferences-addin.js"></script>
        <script type="text/javascript" language="javascript" src="js/tools.js"></script>
        <script type="text/javascript" language="javascript" src="js/ajax.js"></script>
	<script type="text/javascript" language="javascript" src="js/epoch_classes.js"></script>
    </head>
    <body>
	
	<!-- WILL DELETE UNTIL HERE -->
	
	<div id="blackout" style="display:none; position: absolute;left: 0px; top: 0px; background-color: #000000;opacity: .5; filter: alpha(opacity=70); z-index: 1000;"></div>

<script>
    document.getElementById("blackout").style.width = getScreenWidth() + "px";
    document.getElementById("blackout").style.height = getScreenHeight() + "px";
</script>

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
	   
    }
    
    function doFinish ()
    {
	doSubmit();
    }
</script>

<font face="Trebuchet MS" size="1">
<div id="appointment_dialog" style="width: 700px;height: 400px;">
    <% LogController.write ("APPOINTMENT: "+appointment.getAppointmentNo()); %>
    <input type="hidden" id="app_no" value="<%=appointment.getAppointmentNo()%>">
    <input type="hidden" id="app_employee" value="<%=employeeNo%>">
    <input type="hidden" id="app_date" value="<%=df2.format(appointment.getDate())%>">
    <input type="hidden" id="app_start_time" value="<%=tf2.format (appointment.getStartTime())%>">
    <input type="hidden" id="app_end_time" value="<%=tf2.format (appointment.getEndTime())%>">
    
    <table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
            <td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Add Service</font></b></td>
            <td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
        </tr>
        <tr>
            <td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
            <td align="left" valign="top" width="100%">
                <div valign="top" style="height:350px; overflow:auto; overflow-y: auto; overflow-x: hidden;">
                    <table valign="top" border="1" width="100%" cellspacing="10" cellpadding="0">
                        <tr>
                            <td>
				<table>
				    <tr>
					<td>
				<% String firstName = null; %>
				<% String lastName = null; %>
				<% String phoneNumber = null; %>
				<% if (client != null) { %>
				    <% firstName = client.getFirstName (); lastName = client.getLastName(); phoneNumber = client.getPhoneNumber(); %>
				<% } %>
                                <table align="right" valign="top" border="0" cellpadding="0" width="250">
                                    <tr>
					<td align="right"><img border="0" src="/HairSalon/images/icons/small/client_white.gif" width="16" height="16"></td>
					<td align="left"><u><b>Client Details</b></u></td>
				    </tr>
				    <tr>
					<td align="right">First Name:</td>
					<td align="left"><input type="text" name="first_name" id="first_name" size="20" value="<%=CoreTools.display (firstName)%>"></td>
				    </tr>
				    <tr>
					
					<td align="right">Last Name:</td>
					
					<td align="left"><input type="text" name="last_name" id="last_name" size="20" value="<%=CoreTools.display (lastName)%>"></td>
				    </tr>
				    <tr>
					
					<td align="right"><div id="telephone_label">Telephone:</div></td>
					<td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=CoreTools.display (phoneNumber)%>">
					    <img style="cursor:pointer" align="absmiddle" src="images/icons/small/find_white.gif" onclick="findClient()" title="Find and load client from this phone number."/>
					    <img style="cursor:pointer" align="absmiddle" src="images/icons/small/personal_white.gif" onclick="setGuest()" title="Use a guest identity."/>
					</td>
				    </tr>
				    <tr>
					<td align="right">&nbsp;</td>
					<td align="left">&nbsp;</td>
				    </tr>
				    <tr>
                                        <td align="right"><img border="0" src="/HairSalon/images/icons/small/appointment_white.gif" width="16" height="16"></td>
                                        <td align="left"><u><b>Appointment Details</b></u></td>
                                    </tr>
				    <tr>
                                        <td align="right">Employee:</td>
					<td align="left"><b><%=appointment.getEmployee().getName()%></b></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Date:</td>
					<td align="left"><b><%=df.format (appointment.getDate())%></b></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Start Time:</td>
					<td align="left"><b><%=tf.format (appointment.getStartTime())%></b></td>
                                    </tr>
                                    <tr>
                                        <td align="right">End Time:</td>
                                        <td align="left"><b><%=tf.format (appointment.getEndTime())%></b></td>
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
					    <input type="button" onclick="doDelete()" id="deleteButton" value="Delete" class="StandardButton" /><br/>
					    <input type="button" onclick="doClose()" value="Close" class="StandardButton" />
					</td>
				    </tr>
				</table>
					</td>
				    </tr>
				</table>
                            </td>
                            
                            <td valign="top">
                                <table valign="top" height="100%" align="left" border="1" cellpadding="0" cellspacing="0">
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
    
    <%@ include file="../dialogs/appointment-service-dialog.jsp" %>
    <%@ include file="../dialogs/appointment-product-dialog.jsp" %>
</div>
</font>
</body>
</html>

<script>
    document.getElementById("appointment_dialog").style.left = (getScreenWidth() / 2) - 275 + "px";
    document.getElementById("appointment_dialog").style.top = (getScreenHeight() / 2) - 175 + "px";
</script>

<script language="javascript" src="js/appointment-addin.js"></script>
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
<script>refillProductsList();</script>
<script>refillServicesList();</script>
