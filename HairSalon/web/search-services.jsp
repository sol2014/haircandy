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
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute ("user_session");

//Set the current page position for navigator
userSession.setCurrentPosition (SessionPositions.Services);

//Set the page title for header
String page_title = "Services";
int recordNo = 0;

// Grab the search result set if there is one in the UserSession
ServiceBean[] services = (ServiceBean[]) userSession.moveAttribute ("service_search_result");

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("service_feedback");
String error_string = (String) userSession.moveAttribute ("service_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form name="form" method="POST" action="service">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Services</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get list
		    of services that are in the salon database. A new service can also be created if needed.
		    <br><br>

		    <%-- Now we want to add the button that will allow the user to search --%>
		    <input type="submit" value="Search" name="service_action" class="StandardButton"/> 
		    <input type="reset" value="Clear Fields" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Service" name="service_action" class="StandardButton"/>

		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><br><font color="red"><%=error_string%></font><% } %>
		    <% if (feedback_string != null) { %><br><font color="green"><%=feedback_string%></font><% } %>
		</td>
	    </tr>
	</table>

	<table border="0" width="100%" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="right" valign="top">
		    <table align="right" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/service_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Service Details</b></u></td>
			</tr>
			<tr>
			    <td align="right">Name:</td>
			    <td align="left"><input type="text" name="firstfield" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("service_search_name"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Description:</td>
			    <td align="left"><input type="text" name="description" size="20" value="<%=ServletHelper.display (userSession.moveAttribute ("service_search_description"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("service_search_enabled"))%></td>
			</tr>
		    </table>
		</td>

		<%-- This is the auto-search that will do a basic empty search for convenience --%>
		<% if (services == null) {
			    ServiceBean emptySearch = new ServiceBean ();
			    services = SessionController.searchServices (userSession, emptySearch); } %>

		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (services != null && services.length > 0) { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=services.length%>)</b></td>
				<% } else { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</b></td>
				<% }%>
			    </tr>
			    <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (services == null || services.length < 1) { %>
					<tr align="right" valign="middle">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
					</tr>
					<% } else { %>
					<tr align="right">
					    <td height="20" nowrap="nowrap" class="Row1"></td>
					    <td nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Description</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Duration</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Price</b></td>
					</tr>

					<% for (ServiceBean service : services) { %>
					<tr align="right" valign="middle">
					    <td height="30" valign="top" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
					    <td align="left" valign="top" nowrap="nowrap" class="Row2"><span class="SearchLink"><a href="service?service_action=Load&service_no=<%= service.getServiceNo ()%>" class="SearchLink"><%= service.getName ()%></a></span></td>
					    <td align="left" valign="top" class="Row7"><%=ServletHelper.display (service.getDescription ())%></td>
					    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.display (service.getDuration ())%>m</td>
					    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.displayPrice (service.getPrice ())%></td>
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
