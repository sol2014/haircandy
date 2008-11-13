<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Miyoung Han
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%-- Grab the UserSession object from the http session --%>
<% UserSession userSession = (UserSession) session.getAttribute ("user_session");%>

<%-- Set the next page position for navigator --%>
<% userSession.setNextPosition (SessionPositions.MaintainProduct);%>

<%-- Set the page title for header --%>
<% String page_title = "Maintain Product";%>

<%-- Grab the load result from the UsersSession --%>
<%
ProductBean product = (ProductBean) userSession.moveAttribute ("temp_product");
if (product == null)
{
    product = (ProductBean) userSession.moveAttribute ("product_load_result");
}
int recordNo = product.getProductNo ();
%>

<%-- Grab any feedback or errors that the servlet may want to show the page --%>
<% String feedback_string = (String) userSession.moveAttribute ("product_feedback");%>
<% String error_string = (String) userSession.moveAttribute ("product_error");%>

<%-- Make sure to show the page header so that the header, navigation bar and menu show up --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<script>
function calculateUnits()
{
    var totalItems = document.getElementById ("total_items").value;
    var minItems = document.getElementById ("minimum_items").value;
    var unitsPer = document.getElementById("product_quantity").value;
    var totalUnits = totalItems * unitsPer;
    var minUnits = minItems * unitsPer;
    
    var a = new ToFmt (totalUnits);
    document.getElementById("stock").value = a.fmt00 ();
    
    var a = new ToFmt (minUnits);
    document.getElementById("minimum_level").value = a.fmt00 ();
}
function calculateItems()
{
    var totalStock = document.getElementById("stock").value;
    var minStock = document.getElementById ("minimum_level").value;
    var unitsPer = document.getElementById("product_quantity").value;
    var totalItems = 0;
    var minItems = 0;
    
    if (totalStock > 0 && unitsPer > 0)
    {
	totalItems = totalStock / unitsPer;
    }
    
    if (minStock > 0 && unitsPer > 0)
    {
	minItems = minStock / unitsPer;
    }
    
    var a = new ToFmt (totalItems);
    document.getElementById ("total_items").value = a.fmtF (9,1).trim();
    
    var a = new ToFmt (minItems);
    document.getElementById ("minimum_items").value = a.fmtF (9,1).trim();
}
</script>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="product">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="left" valign="top"><img border="0" src="/HairSalon/images/icons/big/product_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Product #<%=product.getProductNo ()%> - <%=product.getName ()%></font></b><br>
		    Provide the basic details of the product, it will be able to be used by services, suppliers and
		    sales within the application. Product inventory is managed automatically, but can be edited manually as well.
		    <br><br>

		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64 (product);%>
		    <input type="hidden" name="temp_product" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="product_action" class="StandardButton">
		    <input type="submit" value="Revert" name="product_action" class="StandardButton"/>
		    
		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><font color="red"><%=ServletHelper.display (error_string)%></font><% } %>
		    <% if (feedback_string != null) { %><font color="green"><%=ServletHelper.display (feedback_string)%></font><% } %>
		</td>
	    </tr>
	</table>
	
	<table border="0" cellspacing="10" cellpadding="0">
	    <tr>
		<td align="right" valign="top">
		    <table align="right" border="0" cellpadding="0" width="250">
			<tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/product_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Product Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_product_name") == null) { %>
			    <td align="right">Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="product_name" value="<%=ServletHelper.display (product.getName ())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_brand") == null) { %>
			    <td align="right">Brand Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Brand Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="brand" value="<%=ServletHelper.display (product.getBrand ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Type:</td>
			    <td align="left"><select size="1" name="type"><%= ServletHelper.generateProductTypeOptions (product.getType().toString (), false)%></select></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_product_quantity") == null) { %>
			    <td nowrap="nowrap" align="right">Units Per Item:</td>
			    <% } else { %>
			    <td nowrap="nowrap" align="right"><font color="red">Units Per Item:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="product_quantity" id="product_quantity" onKeyUp="return calculateUnits()" style="text-align:right" value="<%=ServletHelper.display (product.getQtyPer ())%>" size="5">
			    <select size="1" name="unit"><%=ServletHelper.generateProductUnitOptions (product.getUnit().toString (), false)%></select></td>
			</tr>
			<tr>
			    <td align="right">Stocked Items:</td>
			    <td align="left">
				<input type="text" id="total_items" onkeypress="return isDecimalTyped (event)" onKeyUp="return calculateUnits()" style="text-align:right" value="0.0" size="5">
				<input type="hidden" name="stock" id="stock" style="text-align:right" value="<%=ServletHelper.display (product.getStockQty ())%>" size="5">
			    </td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_minimum_level") == null) { %>
			    <td nowrap="nowrap" align="right">Minimum:</td>
			    <% } else { %>
			    <td nowrap="nowrap" align="right"><font color="red">Minimum:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="minimum_items" id="minimum_items" onkeypress="return isDecimalTyped (event)" onKeyUp="return calculateUnits()" style="text-align:right" value="0.0" size="5">
			    <input type="hidden" name="minimum_level" id="minimum_level" style="text-align:right" value="<%=ServletHelper.display (product.getMinLevel ())%>" size="5"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_price") == null) { %>
			    <td align="right">Item Price:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Unit Price:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="price" onkeypress="return isDecimalTyped (event)" style="text-align:right" value="<%=ServletHelper.display(product.getPrice ())%>" size="5">$</td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", product.getEnabled().toString())%></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script>calculateItems();</script>