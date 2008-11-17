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
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.core.*" %>

<% 
    ProductBean[] searchResults = (ProductBean[])request.getAttribute("searchResults");
%>

<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
    <tr align="left">
	<% if (searchResults != null && searchResults.length > 0) { %>
	<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=searchResults.length%>)</font></b></td>
	<% } else { %>
	<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
	<% } %>
    </tr>
    <tr>
	<td>
	    <table width="100%" cellspacing="1" cellpadding="4" border="0">
		<% if (searchResults == null || searchResults.length < 1) { %>
		<tr align="right" valign="middle">
		    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
		</tr>
		<% } else { %>
		<tr align="right">
		    <td nowrap="nowrap" class="Row1"></td>
		    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
		    <td align="left" nowrap="nowrap" class="Row1"><b>Brand</b></td>
		    <td align="left" nowrap="nowrap" class="Row1"><b>Type</b></td>
		    <td align="left" nowrap="nowrap" class="Row1"><b>Price</b></td>
		    <td nowrap="nowrap" class="Row1"></td>
		</tr>

		<% for (ProductBean product : searchResults) { %>
		<tr align="right" valign="middle">
		    <td valign="top" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
		    <td align="left" valign="top" class="Row2"><%=ServletHelper.display (product.getName ())%></td>
		    <td align="left" valign="top" class="Row7"><%=ServletHelper.display (product.getBrand ())%></td>
		    <td align="left" valign="top" nowrap="nowrap" class="Row7"><%=ServletHelper.display (product.getType ())%></td>
		    <td align="left" valign="top" nowrap="nowrap" class="Row7"><%=ServletHelper.displayPrice (product.getPrice ())%></td>
		    <td nowrap="nowrap" valign="top" class="Row7"><img style="cursor:pointer" src="images/icons/small/add_white.gif" onclick="addProduct('<%=product.getProductNo ()%>','<%=product.getName ()%>','<%=product.getPrice()%>',1)" title="Add the product to the list." /></td>
		</tr>
		<% }%>
		<% }%>
	    </table>
	</td>
    </tr>
</table>
