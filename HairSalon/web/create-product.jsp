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
<%@page import="hairsalon.core.*" %>
<%@page import="hairsalon.objects.*" %>
<%@page import="hairsalon.presentation.*" %>
<%@page import="hairsalon.application.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
userSession.setNextPosition (SessionPositions.CreateProduct);
String page_title = "New Product";
int recordNo = 0;

String error_string = (String) userSession.moveAttribute ("product_error");
%>

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
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/product_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Create new Product</font></b><br>
		    Provide the basic details of the product in order to create the new record. You will have the
		    chance to provide more complex links after the record is saved into the database.
		    <br><br>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Finish" name="product_action" class="StandardButton"/>
		    
		    <% if (error_string != null) { %>
		    <font color="red">
		    <%=error_string%>
		    </font>
		    <%  }%>
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
			    <td align="left"><input type="text" name="product_name" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("product_new_product_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_brand") == null) { %>
			    <td align="right">Brand Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Brand Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="brand" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("product_new_brand"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Type:</td>
			    <td align="left"><select size="1" name="type"><%=CoreTools.generateProductTypeOptions ((String)userSession.moveAttribute ("product_new_type"), false)%></select></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_product_quantity") == null) { %>
			    <td nowrap="nowrap" align="right">Units Per Item:</td>
			    <% } else { %>
			    <td nowrap="nowrap" align="right"><font color="red">Units Per Item:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="product_quantity" id="product_quantity" onKeyUp="return calculateUnits()" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_new_product_quantity"))%>">
			    <select size="1" name="unit"><%=CoreTools.generateProductUnitOptions ((String) userSession.moveAttribute ("product_new_unit"), false)%></select></td>
			</tr>
			<tr>
			    <td align="right">Stocked Items:</td>
			    <td align="left"><b><input type="text" id="total_items" onKeyUp="return calculateUnits()" style="text-align:right" value="0.00" size="5">
				<input type="hidden" name="stock" id="stock" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_new_stock"))%>" style="text-align:right"></b></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_minimum_level") == null) { %>
			    <td nowrap="nowrap" align="right">Minimum:</td>
			    <% } else { %>
			    <td nowrap="nowrap" align="right"><font color="red">Minimum:</font></td>
			    <% } %>
			    <td align="left"><input type="text" id="minimum_items" onKeyUp="return calculateUnits()" size="5" style="text-align:right" value="" style="text-align:right">
			    <input type="hidden" name="minimum_level" id="minimum_level" style="text-align:right" value="<%=CoreTools.display ((String) userSession.moveAttribute ("product_new_minimum_level"))%>" size="5"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("product_error_price") == null) { %>
			    <td align="right">Item Price:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Item Price:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="price" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_new_price"))%>">$</td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=CoreTools.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("product_new_enabled"))%></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script>calculateItems ();</script>