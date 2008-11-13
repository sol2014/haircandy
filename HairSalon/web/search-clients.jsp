<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
userSession.setCurrentPosition (SessionPositions.Clients);
String page_title = "Clients";
int recordNo = 0;

ClientBean[] clients = (ClientBean[]) userSession.moveAttribute ("client_search_result");
String feedback_string = (String) userSession.moveAttribute ("client_search_feedback");
String error_string = (String) userSession.moveAttribute ("client_error_feedback");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="client">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Clients</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get list
		    of clients that are in the salon database. A new client can also be created if needed.
		    <br><br>

		    <!-- here the buttons  -->
		    <input type="submit" value="Search" name="client_action" class="StandardButton"/>
		    <input type="reset" value="Clear" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Client" name="client_action" class="StandardButton"/>

		    <% if (error_string != null) { %><font color="red"><%=error_string%></font><% } %>
		    <% if (feedback_string != null) { %><font color="green"><%=feedback_string%></font><% } %>
		</td>
	    </tr>
	</table>

	<table border="0" width="100%" cellspacing="10" cellpadding="0">
	    <tr>
		<td>
		    <div align="center">
			<table border="0" cellpadding="0" width="250">
			    <tr>
				<td align="right"><img border="0" src="/HairSalon/images/icons/small/personal_white.gif" width="16" height="16"></td>
				<td align="left"><u><b>Personal Details</b></u></td>
			    </tr>
			    <tr>
				<td align="right">First Name:</td>
				<td align="left"><input type="text" name="first_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_first_name"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Last Name:</td>
				<td align="left"><input type="text" name="last_name" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_last_name"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Telephone:</td>
				<td align="left"><input type="text" name="phone_number" size="10" onkeypress="return isNumberTyped (event)" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_phone_number"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Enabled:</td>
				<td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("client_search_enabled"))%></td>
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
				<td align="right">Address 1:</td>
				<td align="left"><input type="text" name="address1" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_address1"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Address 2:</td>
				<td align="left"><input type="text" name="address2" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_address2"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Email:</td>
				<td align="left"><input type="text" name="email" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_email"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">City:</td>
				<td align="left"><input type="text" name="city" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_city"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Province:</td>
				<td align="left"><input type="text" name="province" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_province"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Country:</td>
				<td align="left"><input type="text" name="country" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_country"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Postal Code:</td>
				<td align="left"><input type="text" name="postal_code" size="6" value="<%=ServletHelper.display (userSession.moveAttribute ("client_search_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			    </tr>
			</table>
		    </div>
		</td>
		<% if (clients == null) {
		    ClientBean emptySearch = new ClientBean ();
		    AddressBean emptyAddress = new AddressBean ();
		    emptySearch.setAddress (emptyAddress);
		    clients = SessionController.searchClients (userSession, emptySearch); } %>
		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (clients != null && clients.length > 0) { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=clients.length%>)</font></b></td>
				<% } else { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
				<% }%>
			    </tr>
			    <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (clients == null || clients.length < 1) { %>
					<tr align="right" valign="middle">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</font></b></td>
					</tr>
					<% } else { %>
					<tr align="right">
					    <td height="20" nowrap="nowrap" class="Row1"></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Telephone</b></td>
					</tr>
					    <% for (ClientBean client : clients) { %>
					    <tr align="right" valign="middle">
						<td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
						<td align="left" class="Row2"><span class="SearchLink"><a href="client?client_action=Load&client_no=<%= client.getClientNo ()%>" class="SearchLink"><%= client.getName ()%></a></span></td>
						<td nowrap="nowrap" class="Row7"><%=ServletHelper.displayPhoneNumber(client.getPhoneNumber ())%></td>
					    </tr>
					    <% }%>
					<% }%>
				    </table>
				</td>
			    </tr>
			</table>
		    </div>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
