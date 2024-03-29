<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Receptionist" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");

userSession.setCurrentPosition (SessionPositions.Sales);

String page_title = "Sales";
int recordNo = 0;

SaleBean[] sales = (SaleBean[]) userSession.moveAttribute ("sale_search_result");

String feedback_string = (String) userSession.moveAttribute ("sale_search_feedback");

String error_string = (String) userSession.moveAttribute ("sale_search_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<script type="text/javascript">
var dp_cal;
window.onload = function () {
	dp_cal  = new Epoch('epoch_popup','popup',document.getElementById('search_start_date'));
	dp_cal  = new Epoch('epoch_popup','popup',document.getElementById('search_end_date'));
};
</script>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="sale">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Sales</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get a list
		    of sales that are in the salon database. A new sale can also be created if needed.
		    <br><br>
		    
		    <input type="submit" value="Search" name="sale_action" class="StandardButton"/>
		    <input type="reset" value="Clear Fields" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Sale" name="sale_action" class="StandardButton"/>

		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><br><font color="red"><%=error_string%></font><% } %>
		    <% if (feedback_string != null) { %><br><font color="green"><%=feedback_string%></font><% } %>
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
				<td align="left"><u><b>Sale Details</b></u></td>
			    </tr>
			    <tr>
				<td align="right">Start Date:</td>
				<td align="left"><input type="text" name="search_start_date" id="search_start_date" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("sale_search_start_date"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">End Date:</td>
				<td align="left"><input type="text" name="search_end_date" id="search_end_date" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("sale_search_end_date"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Payment Type:</td>
				<td align="left"><select name="search_payment_type" size="1"><%=ServletHelper.generatePaymentTypeOptions((String) userSession.moveAttribute("sale_search_payment_type"), true)%></select></td>
			    </tr>
			    <tr>
				<td align="right">Total Due:</td>
				<td align="left"><input type="text" name="search_total_due" size="15" value="<%=ServletHelper.display (userSession.moveAttribute ("sale_search_total_due"))%>"></td>
			    </tr>
			    <tr>
				<td align="right">Is Complete:</td>
				<% String isComplete = (String)userSession.moveAttribute ("sale_search_is_complete"); %>
				<td align="left"><%=ServletHelper.generateTrueFalseOptions("search_is_complete",  isComplete == null || isComplete.equals ("") ? "False" : ServletHelper.display (isComplete))%></td>
			    </tr>
			    <tr>
				<td align="right">Is Void:</td>
				<% String isVoid = (String)userSession.moveAttribute ("sale_search_is_void"); %>
				<td align="left"><%=ServletHelper.generateTrueFalseOptions("search_is_void", isVoid == null || isVoid.equals ("") ? "False" : ServletHelper.display (isVoid))%></td>
			    </tr>
			</table>
		    </div>
		</td>

		 <%-- This is the auto-search that will do a basic empty search for convenience --%>
		<% if (sales == null) {
			    SaleBean emptySearch = new SaleBean ();
			    emptySearch.setIsVoid (false);
			    emptySearch.setIsComplete (false);
			    EmployeeBean emptyEmployee = new EmployeeBean ();
			    emptySearch.setEmployee (emptyEmployee);

			    ClientBean emptyClient = new ClientBean();
			    emptySearch.setClient (emptyClient);

			    sales = SessionController.searchSales (userSession, emptySearch); } %>
		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (sales != null && sales.length > 0) { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=sales.length%>)</font></b></td>
				<% } else { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
				<% } %>
			    </tr>
			 <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (sales == null || sales.length < 1) { %>
					<tr align="center" valign="middle">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
					</tr>
					<% } else { %>
					<tr align="right">
					    <td nowrap="nowrap" class="Row1"></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1">Timestamp</td>
					    <td nowrap="nowrap" align="left" class="Row1">Payment Type</td>
					    <td nowrap="nowrap" class="Row1">Total</td>
					</tr>
					<% for (SaleBean sale : sales) { %>
					<tr align="right" valign="middle">
					    <td class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
					    <td align="left" nowrap="nowrap" class="Row2"><span class="SearchLink"><a href="sale?sale_action=Load&transaction_no=<%= sale.getTransactionNo ()%>" class="SearchLink"><%= CoreTools.showTime (sale.getTimestamp (), CoreTools.TimestampFormat)%></a></span></td>
					    <td align="left" nowrap="nowrap" class="Row2"><%= sale.getPaymentType ()%></td>
					    <td nowrap="nowrap" class="Row7"><%= sale.getPayment ()%></td>
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
