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
UserSession userSession = (UserSession) session.getAttribute("user_session");
%>

<html>
    <head>
	<meta http-equiv="Content-Language" content="en-us">
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	<title>HairSalon: First Time Setup</title>
	<link href="css/Main.css" rel="stylesheet" type="text/css">
	<link href="css/Scheduler.css" rel="stylesheet" type="text/css">
	<link href="css/Shadow.css" rel="stylesheet" type="text/css">
        <link href="css/Calendar.css" rel="stylesheet" type="text/css">
	<link href="css/epoch_styles.css" rel="stylesheet" type="text/css" />
	
	<script type="text/javascript" language="javascript" src="js/availability-addin.js"></script>
	<script type="text/javascript" language="javascript" src="js/password-addin.js"></script>
        <script type="text/javascript" language="javascript" src="js/tools.js"></script>
        <script type="text/javascript" language="javascript" src="js/ajax.js"></script>
	<script type="text/javascript" language="javascript" src="js/epoch_classes.js"></script>
    </head>
    
    <body class="SiteBody"> 
    
    <noscript>
    <meta http-equiv="refresh" content="2; URL=application">
    <center><b>You are using a browser that does not support JavaScript, or it is currently disabled!<br />You must turn on JavaScript in order to use this web application.</b><br />
    If your browser does not support JavaScript, you can upgrade to a newer browser,<br />such as <a href="http://www.microsoft.com/windows/downloads/ie/getitnow.mspx">Microsoft&reg; Internet Explorer 7</a> or <a href="http://www.mozilla.com/en-US/firefox/">Mozilla Firefox 3</a>.
    </noscript>

    <div id="MainFrame">
	<table border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
	    <tr>
		<td><img border="0" src="images/site_topleftshadow.gif" width="18" height="18"></td>
		<td width="100%" background="images/site_topshadow.gif"><img border="0" src="images/site_topshadow.gif" width="14" height="18"></td>
		<td><img border="0" src="images/site_toprightshadow.gif" width="18" height="18"></td>
	    </tr>
	    <tr>
		<td height="100%" background="images/site_leftshadow.gif"><img border="0" src="images/site_leftshadow.gif" width="18" height="32"></td>
		<td height="100%" width="100%">
		    <table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="2"><img border="0" src="images/site_topleft.gif" width="2" height="72"></td>
			    <td width="100%" background="images/site_top.gif">
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
				    <tr>
					<td><img border="0" src="images/site_logo.gif" width="306" height="72"></td>
					<td class="SiteHeaderImage" width="100%">&nbsp;</td>
				    </tr>
				</table>
			    </td>
			    <td width="2"><img border="0" src="images/site_topright.gif" width="2" height="72"></td>
			</tr>
			<tr>
			    <td background="images/site_left.gif"><img border="0" src="images/site_left.gif" width="2" height="13"></td>
			    <td height="100%" width="100%">
				<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
				    <tr>
					<td background="images/navigation/nav_header.gif" height="36">
					    <table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						    <td width=100%></td>
						    <td align="right" width="100%"></td>
						</tr>
					    </table>
					</td>
				    </tr>
				    <tr>
					<td >
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td>
							
							<table border="0" cellspacing="0" cellpadding="0">
							    <tr>
								<td><img border="0" src="images/shadow_topleft.gif" width="15" height="15"></td>
								<td background="images/shadow_top.gif" width="100%"><img border="0" src="images/shadow_top.gif" width="15" height="15"></td>
								<td><img border="0" src="images/shadow_topright.gif" width="15" height="15"></td>
							    </tr>
							    <tr>
								<td background="images/shadow_left.gif" height="100%"><img border="0" src="images/shadow_left.gif" width="15" height="15"></td>
								<td valign="top" align="left" width="100%" bgcolor="#FFFFFF">
								    <font face="Trebuchet MS" size="2">
								    <table width="95%" border="0" cellspacing="5" cellpadding="0">
									<tr>
									    <td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/setup_white.gif" width="48" height="48"></td>
									    <td align="left">
										<font size="4"><b>HairSalon: Scheduling & Management System</b></font><br/>
										<font size="3"><i>Welcome to First Time Setup</i></font>

										<p>This page will help you start up your new scheduling and management system for your hair salon! Please fill out the 
										four sections of the form below and you can get started.</p>

										<p><b><u>1. Salon Identification</u></b><br/>
										Your salon has some identification information that is useful for clients and employees. These values will be used throughout
										the application. You need to provide the address information of your salon so that clients will know where to find you 
										using the site.</p>

										<table border="0" cellpadding="0" cellspacing="3" width="260">
										    <tr>
											<% if (userSession.moveAttribute ("setup_salon_name") == null) { %>
											<td width="100px" align="right">Salon Name:</td>
											<% } else { %>
											<td align="right"><font color="red">Salon Name:</font></td>
											<% } %>
											<td width="100px" align="left"><input type="text" name="salon_name" value="" size="20"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_new_phone_number") == null) { %>
											<td width="100px" align="right"><div id="telephone_label">Telephone:</div></td>
											<% } else { %>
											<td width="100px" align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
											<% } %>
											<td align="left"><input type="text" name="phone_number" id="phone_number" onkeypress="return isNumberTyped (event)" onKeyUp="return checkTelephone(this)" size="10" value=""></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_email") == null) { %>
											<td width="95px" align="right">Email:</td>
											<% } else { %>
											<td width="95px" align="right"><font color="red">Email:</font></td>
											<% } %>
											<td align="left"><input type="text" name="email" value="" size="20"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_address1") == null) { %>
											<td width="95px" align="right">Address 1:</td>
											<% } else { %>
											<td width="95px" align="right"><font color="red">Address 1:</font></td>
											<% } %>
											<td align="left"><input type="text" name="address1" value="" size="20"></td>
										    </tr>
										    <tr>
											<td align="right">Address 2:</td>
											<td align="left"><input type="text" name="address2" value="" size="20"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_city") == null) { %>
											<td width="95px" align="right">City:</td>
											<% } else { %>
											<td width="95px" align="right"><font color="red">City:</font></td>
											<% } %>
											<td align="left"><input type="text" name="city" value="" size="15"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_province") == null) { %>
											<td width="95px" align="right">Province:</td>
											<% } else { %>
											<td width="95px" align="right"><font color="red">Province:</font></td>
											<% } %>
											<td align="left"><input type="text" name="province" value="" size="15"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_country") == null) { %>
											<td width="95px" align="right">Country:</td>
											<% } else { %>
											<td width="95px" align="right"><font color="red">Country:</font></td>
											<% } %>
											<td align="left"><input type="text" name="country" value="" size="15"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_postal_code") == null) { %>
											<td width="95px" align="right"><div id="postal_code_label">Postal Code:</div></td>
											<% } else { %>
											<td width="95px" align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
											<% } %>
											<td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="" size="6"><i>(ie. N4N4N4)</i></td>
										    </tr>
										</table>
										
										<p><b><u>2. Sales Tax</u></b><br/>
										The tax rate may be vary from place to place. Provide accurate values as your sales will use this information to calculate tax
										and bill your customers. Sales tax can still be modified by managers in the salon maintenance page.</p>
										
										<table border="0" cellpadding="0" cellspacing="3" width="260">
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_tax") == null) { %>
											<td width="96px" align="right">Tax Rate:</td>
											<% } else { %>
											<td width="96px" align="right"><font color="red">Tax Rate:</font></td>
											<% } %>
											<td align="left"><input type="text" name="tax" onkeypress="return isDecimalTyped (event)" style="text-align:right" value="" size="5"> %</td>
										    </tr>
										</table>
										
										<p><b><u>3. Business Hours</u></b><br/>
										This software has interfaces that will allow you to maintain your employee schedule and your client appointments. Provide the hours
										of operation of your salon. The employee and appointment schedules will be using these values to save data, and these hours will
										restrict client appointment bookings and employee schedule shifts. You may still modify these default settings later, as well
										as change the hours of any individual day if necessary.</p>
										
										<table border="0" cellpadding="0" cellspacing="3" width="260">
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_monday") == null) { %>
											<td align="right">Monday:</td>
											<% } else { %>
											<td align="right"><font color="red">Monday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_monday_check" value="monday"></td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_monday_start", null)%>

											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_monday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_tuesday") == null) { %>
											<td align="right">Tuesday:</td>
											<% } else { %>
											<td align="right"><font color="red">Tuesday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_tuesday_check" value="tuesday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_tuesday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_tuesday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_wednesday") == null) { %>
											<td align="right">Wednesday:</td>
											<% } else { %>
											<td align="right"><font color="red">Wednesday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_wednesday_check" value="wednesday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_wednesday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_wednesday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_thursday") == null) { %>
											<td align="right">Thursday:</td>
											<% } else { %>
											<td align="right"><font color="red">Thursday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_thursday_check" value="thursday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_thursday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_thursday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_friday") == null) { %>
											<td align="right">Friday:</td>
											<% } else { %>
											<td align="right"><font color="red">Friday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_friday_check" value="friday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_friday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_friday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_saturday") == null) { %>
											<td align="right">Satuday:</td>
											<% } else { %>
											<td align="right"><font color="red">Saturday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_saturday_check" value="saturday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_saturday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_saturday_end", null)%>
											</td>
										    </tr>

										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>

										    <tr>
											<% if (userSession.moveAttribute ("setup_error_sunday") == null) { %>
											<td align="right">Sunday:</td>
											<% } else { %>
											<td align="right"><font color="red">Sunday:</font></td>
											<% } %>
											<td nowrap="nowrap" align="left"><input type="checkbox" onclick="switchDayStatus(this, 'salon')" id="setup_sunday_check" value="sunday"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Open:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_sunday_start", null)%>
											</td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">Close:</td>
											<td nowrap="nowrap" align="left">
											    <%=ServletHelper.generateHourPicker ("setup_sunday_end", null)%>
											</td>
										    </tr>
										</table>
										
										<p><b><u>4. Manager Account</u></b><br/>
										Finally you will need to create the manager account that you will use to access the system as a Manager role. Once you
										have logged into this role, you can create as many other manager, stylist, or receptionist roles as you wish.</p>
										
										<table>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_first_name") == null) { %>
											<td align="right">First Name:</td>
											<% } else { %>
											<td align="right"><font color="red">First Name:</font></td>
											<% } %>
											<td align="left"><input type="text" name="first_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_first_name"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_last_name") == null) { %>
											<td align="right">Last Name:</td>
											<% } else { %>
											<td align="right"><font color="red">Last Name:</font></td>
											<% } %>
											<td align="left"><input type="text" name="last_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_last_name"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_manager_phone_number") == null) { %>
											<td align="right"><div id="manager_telephone_label">Telephone:</div></td>
											<% } else { %>
											<td align="right"><font color="red"><div id="manager_telephone_label">Telephone:</div></font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_phone_number" id="manager_phone_number" onkeypress="return isNumberTyped (event)" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_phone_number"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_manager_password") == null) { %>
											<td align="right">Password:</td>
											<% } else { %>
											<td align="right"><font color="red">Password:</font></td>
											<% } %>
											<td align="left"><input type="password" name="manager_password" size="15"></td>
										    </tr>
										    <tr>
											<td nowrap="nowrap" align="right">&nbsp;</td>
											<td nowrap="nowrap" align="left">&nbsp;</td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_address1") == null) { %>
											<td align="right">Address 1:</td>
											<% } else { %>
											<td align="right"><font color="red">Address 1:</font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_address1" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_address1"))%>"></td>
										    </tr>
										    <tr>
											<td align="right">Address 2:</td>
											<td align="left"><input type="text" name="manager_address2" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_address2"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_email") == null) { %>
											<td align="right">Email:</td>
											<% } else { %>
											<td align="right"><font color="red">Email:</font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_email" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_email"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_city") == null) { %>
											<td align="right">City:</td>
											<% } else { %>
											<td align="right"><font color="red">City:</font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_city" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_city"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_province") == null) { %>
											<td align="right">Province:</td>
											<% } else { %>
											<td align="right"><font color="red">Province:</font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_province" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_province"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_country") == null) { %>
											<td align="right">Country:</td>
											<% } else { %>
											<td align="right"><font color="red">Country:</font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_country" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_country"))%>"></td>
										    </tr>
										    <tr>
											<% if (userSession.moveAttribute ("setup_error_employee_postal_code") == null) { %>
											<td align="right"><div id="manager_postal_code_label">Postal Code:</div></td>
											<% } else { %>
											<td align="right"><font color="red"><div id="manager_postal_code_label">Postal Code:</div></font></td>
											<% } %>
											<td align="left"><input type="text" name="manager_postal_code" id="manager_postal_code" onKeyUp="return checkPostalCode(this)" size="6" value="<%=ServletHelper.display (userSession.moveAttribute ("setup_manager_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
										    </tr>
										</table>
										<br/>
										<p>Congratulations! You have provided all of the information that we need to get started! Please click the finish button to start using the application.</p>
										<input type="button" value="Finish" class="StandardButton">
										<br/><br/>
									    </td>
									</tr>
								    </table>
								    </font>
								</td>
								<td background="/HairSalon/images/shadow_right.gif" height="100%"><img border="0" src="/HairSalon/images/shadow_right.gif" width="15" height="15"></td>
							    </tr>
							    <tr>
								<td><img border="0" src="/HairSalon/images/shadow_bottomleft.gif" width="15" height="15"></td>
								<td background="/HairSalon/images/shadow_bottom.gif" width="100%"><img border="0" src="/HairSalon/images/shadow_bottom.gif" width="15" height="15"></td>
								<td><img border="0" src="/HairSalon/images/shadow_bottomright.gif" width="15" height="15"></td>
							    </tr>
							</table>
							
						    </td>
						</tr>
					    </table>
					</td>
				    </tr>
				</table>
			    </td>
			    <td background="/HairSalon/images/site_right.gif"><img border="0" src="/HairSalon/images/site_right.gif" width="2" height="9"></td>
			</tr>
			<tr>
			    <td><img border="0" src="/HairSalon/images/site_bottomleft.gif" width="2" height="2"></td>
			    <td background="/HairSalon/images/site_bottom.gif"><img border="0" src="/HairSalon/images/site_bottom.gif" width="10" height="2"></td>
			    <td><img border="0" src="/HairSalon/images/site_bottomright.gif" width="2" height="2"></td>
			</tr>
		    </table>
		</td>
		<td height="100%" background="/HairSalon/images/site_rightshadow.gif"><img border="0" src="/HairSalon/images/site_rightshadow.gif" width="18" height="18"></td>
	    </tr>
	    <tr>
		<td><img border="0" src="/HairSalon/images/site_bottomleftshadow.gif" width="18" height="18"></td>
		<td background="/HairSalon/images/site_bottomshadow.gif" width="100%"><img border="0" src="/HairSalon/images/site_bottomshadow.gif" width="26" height="18"></td>
		<td><img border="0" src="/HairSalon/images/site_bottomrightshadow.gif" width="18" height="18"></td>
	    </tr>
	</table>
	</div>
    </body>
</html>
