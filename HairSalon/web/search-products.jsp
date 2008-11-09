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
<%@page import="java.util.*" %>
<%@page import="hairsalon.core.*" %>
<%@page import="hairsalon.objects.*" %>
<%@page import="hairsalon.application.*" %>
<%@page import="hairsalon.presentation.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
// Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute ("user_session");

// Set the current page position for navigator
userSession.setCurrentPosition (SessionPositions.Products);

// Set the page title for header
String page_title = "Products";
int recordNo = 0;

// Grab the search result set if there is one in the UserSession
ProductBean[] products = (ProductBean[]) userSession.moveAttribute ("product_search_result");

// Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("product_search_feedback");
String error_string = (String) userSession.moveAttribute ("product_search_error");
%>

<%-- Make sure to show the page header so that the header, navigation bar and menu show up --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- PAGE CONTENT --%>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="product">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/search_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Search for Products</b></font><br>
		    Provide the search parameters you would like to use and then press the search button to get list
		    of products that are in the salon database. A new product can also be created if needed.
		    <br><br>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Search" name="product_action" class="StandardButton"/>
		    <input type="reset" value="Clear Fields" name="reset_button" class="StandardButton"/>
		    <input type="submit" value="New Product" name="product_action" class="StandardButton"/>

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
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/product_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Product Details</b></u></td>
			</tr>
			<tr>
			    <td align="right">Name:</td>
			    <td align="left"><input type="text" name="product_name" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_product_name"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Brand Name:</td>
			    <td align="left"><input type="text" name="brand" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_brand"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Type:</td>
			    <td align="left"><select size="1" name="type"><%= CoreTools.generateProductTypeOptions ((String) userSession.moveAttribute ("product_search_type"), true)%></select></td>			   
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Units Per Item:</td>
			    <td align="left"><input type="text" name="product_quantity" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_product_quantity"))%>">
			    <select size="1" name="unit"><%=CoreTools.generateProductUnitOptions ((String)userSession.moveAttribute("product_search_unit"), true)%></select></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Stocked Units:</td>
			    <td align="left"><input type="text" name="stock" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_stock"))%>"></td>
			</tr>			
			<tr>
			    <td nowrap="nowrap" align="right">Minimum:</td>
			    <td align="left"><input type="text" name="minimum_level" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_minimum_level"))%>"></td>
			</tr>
			<tr>
			    <td nowrap="nowrap" align="right">Item Price:</td>
			    <td align="left"><input type="text" name="price" size="5" style="text-align:right" value="<%=CoreTools.display (userSession.moveAttribute ("product_search_price"))%>">$</td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=CoreTools.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("product_search_enabled"))%></td>
			</tr>
		    </table>
		</td>
		<% if (products == null) {
			    ProductBean emptySearch = new ProductBean ();
			    products = SessionController.searchProducts (userSession, emptySearch); } %>
		<td valign="top" width="100%">
		    <div align="left">
			<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
			    <tr align="left">
				<% if (products != null && products.length > 0) { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=products.length%>)</b></td>
				<% } else { %>
				<td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</b></td>
				<% }%>
			    </tr>
			    <tr>
				<td>
				    <table width="100%" cellspacing="1" cellpadding="4" border="0">
					<% if (products == null || products.length < 1) { %>
					<tr align="right" valign="middle">
					    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
					</tr>
					<% } else { %>
					<tr align="right">
					    <td height="20" nowrap="nowrap" class="Row1"></td>
					    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Product Name</b></td>
					    <td align="left" nowrap="nowrap" class="Row1"><b>Brand</b></td>
					    <td align="left" nowrap="nowrap" class="Row1"><b>Type</b></td>
					    <td nowrap="nowrap" class="Row1"><b>Price</b></td>											
					</tr>

					<% for (ProductBean product : products) { %>
					<tr align="right" valign="middle">
					    <td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
					    <td align="left" nowrap="nowrap" class="Row2"><span class="SearchLink"><a href="product?product_action=Load&product_no=<%= product.getProductNo ()%>" class="SearchLink"><%= product.getName ()%></a></span></td>
					    <td align="left" nowrap="nowrap" class="Row7"><%=CoreTools.display(product.getBrand ())%></td>
					    <td align="left" nowrap="nowrap" class="Row7"><%=CoreTools.display(product.getType ())%></td>
					    <td nowrap="nowrap" class="Row7"><%=CoreTools.displayPrice(product.getPrice ())%></td>
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
