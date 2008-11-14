<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
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
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setCurrentPosition(SessionPositions.Suppliers);
String page_title = "Clients";
int recordNo = 0;

SupplierBean[] suppliers = (SupplierBean[]) userSession.moveAttribute("supplier_search_result");

String feedback_string = (String) userSession.moveAttribute("supplier_search_feedback");
String error_string = (String) userSession.moveAttribute("supplier_error_feedback");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="supplier">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Suppliers</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get list
		    of suppliers that are in the salon database. A new supplier can also be created if needed.
		    <br><br>

		    <!-- here the buttons  -->
		    <input type="submit" value="Search" name="supplier_action" class="StandardButton"/>
		    <input type="reset" value="Clear Fields" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Supplier" name="supplier_action" class="StandardButton"/>

		    <% if (error_string != null) {%>
		    <font color="red">
			<%=error_string%>
		    </font>
		    <%  }%>
		    <% if (feedback_string != null) {%>
		    <font color="green">
			<%=feedback_string%>
		    </font>
		    <%}%>
		</td>
	    </tr>
	</table>

	<table width="100%" border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="right" valign="top">
		    <table align="right" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/supplier_white.gif" width="16" height="16"></td>
			    <td align="left"><u><font face="Trebuchet MS" size="2"><b>Supplier Details</b></u></td>
			</tr>
			<tr>
			    <td align="right">Name:</td>
			    <td align="left"><input type="text" name="name" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_name"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Description:</td>
			    <td align="left"><input type="text" name="description" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_description"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Telephone:</td>
			    <td align="left"><input type="text" name="phone_number" size="10" onkeypress="return isNumberTyped (event)" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_phone_number"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("supplier_search_enabled"))%></td>
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
			    <td align="left"><input type="text" name="address1" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_address1"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_address2"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_email"))%>"></td>
			</tr>
			<tr>
			    <td align="right">City:</td>
			    <td align="left"><input type="text" name="city" size="15" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_city"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Province:</td>
			    <td align="left"><input type="text" name="province" size="15" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_province"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Country:</td>
			    <td align="left"><input type="text" name="country" size="15" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_country"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Postal Code:</td>
			    <td align="left"><input type="text" name="postal_code" size="6" value="<%=ServletHelper.display(userSession.moveAttribute("supplier_search_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>
		<% if (suppliers == null) {
		    SupplierBean emptySearch = new SupplierBean();
		    AddressBean emptyAddress = new AddressBean();
		    emptySearch.setAddress(emptyAddress);
		    emptySearch.setEnabled (true);
		    suppliers = SessionController.searchSuppliers(userSession, emptySearch);
		}%>
		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (suppliers != null && suppliers.length > 0) {%>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=suppliers.length%>)</font></b></td>
				<% } else {%>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
				<% }%>
			    </tr>
			    <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (suppliers == null || suppliers.length < 1) {%>
					<tr align="right">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
					</tr>
					<% } else {%>
					<tr align="right">
					    <td nowrap="nowrap" class="Row1"></td>
					    <td nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Description</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Telephone</b></td>
					</tr>
					<% for (SupplierBean supplier : suppliers) {%>
					<tr align="right">
					    <td valign="top" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
					    <td align="left" valign="top" nowrap="nowrap" class="Row2"><span class="SearchLink"><a href="supplier?supplier_action=Load&supplier_no=<%= supplier.getSupplierNo()%>" class="SearchLink"><%= supplier.getName()%></a></span></td>
					    <td align="left" valign="top" class="Row7"><%=ServletHelper.display (supplier.getDescription ())%></td>
					    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.displayPhoneNumber(supplier.getPhoneNumber())%></td>
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
