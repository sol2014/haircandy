<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.core.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Receptionist" />

<% Hashtable<ProductBean, Integer> searchResults = (Hashtable<ProductBean, Integer>)request.getAttribute("searchResults"); %>

<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
    <tr width="100%" align="left">
	<% if(searchResults == null || searchResults.size() == 0) { %>
	<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Products Included (None)</font></b></td>
	<% } else { %>
	<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Products Included (<%=searchResults.size()%>)</font></b></td>
	<% } %>
    </tr>
    <tr>
	<td>
	    <% if(searchResults == null || searchResults.size() == 0) { %>
	    <table width="100%" cellspacing="1" cellpadding="4" border="0">
		<tr align="right" valign="middle">
		    <td colspan="3" align="left" class="Row2"><b>There are no products included in this sale.</b></td>
		</tr>
	    </table>
	    <% } else { %>
	    <table width="100%" cellspacing="1" cellpadding="4" border="0">
		<tr align="right">
		    <td height="20" nowrap="nowrap" class="Row1"></td>
		    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
		    <td align="left" nowrap="nowrap" class="Row1"><b>Type</b></td>
		    <td nowrap="nowrap" class="Row1"><b>Quantity</b></td>
		    <td nowrap="nowrap" class="Row1"><b>Price</b></td>
		    <td nowrap="nowrap" class="Row1"><b>Sub-Total</b></td>
		    <td nowrap="nowrap" class="Row1"></td>
		</tr>
		<% for(ProductBean pb: searchResults.keySet ()) { %>
		<tr align="right" valign="middle">
		    <td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/product_white.gif" width="16" height="16" />&nbsp;</td>
		    <td align="left" class="Row2"><span class="SearchLink"><a href="product?product_action=Load&product_no=<%= pb.getProductNo ()%>" class="SearchLink"><%=ServletHelper.display (pb.getName ())%></a></span></td>
		    <td align="left" nowrap="nowrap" class="Row7"><%=ServletHelper.display (pb.getType())%></td>
		    <td nowrap="nowrap" class="Row7"><input type="text" size="4" onKeyUp="return calculateProductSubTotal()" id="sr_<%=ServletHelper.display(pb.getProductNo())%>" value="<%=ServletHelper.display(searchResults.get (pb))%>" style="text-align:right" /></td>
		    <td nowrap="nowrap" class="Row7"><%=ServletHelper.displayPrice (pb.getPrice ())%></td>
		    <td nowrap="nowrap" class="Row7"><b><div id="sub_total_product_<%=ServletHelper.display(pb.getProductNo())%>"><%=ServletHelper.displayPrice (pb.getPrice ())%></div></b></td>
		    <td nowrap="nowrap" class="Row7"><img style="cursor:pointer" src="/HairSalon/images/icons/small/remove_white.gif" onclick="deleteProduct('<%=ServletHelper.display(pb.getProductNo())%>')" title="Delete this product from the list." /></td>
		</tr>
		<% } %>
	    </table>
	    <% } %>
	</td>
    </tr>
</table>
<br />
<div align="right"><input type="button" onclick="showAddProduct()" value="Add Product" class="StandardButton"/></div>
<script>calculateProductSubTotal ()</script>