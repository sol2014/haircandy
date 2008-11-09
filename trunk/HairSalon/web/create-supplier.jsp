<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hairsalon.core.*" %>
<%@page import="hairsalon.objects.*" %>
<%@page import="hairsalon.presentation.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setNextPosition(SessionPositions.CreateSupplier);

SupplierBean sb = new SupplierBean();
ArrayList<ProductBean> products = new ArrayList<ProductBean>();
sb.setProducts(products);
AddressBean ab = new AddressBean();
sb.setAddress(ab);
int recordNo = 0;

String page_title = "Create Supplier";

String error_string = (String) userSession.moveAttribute ("supplier_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="Post" action="supplier">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/supplier_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>Create new Supplier</b></font><br>
		    Provide the basic details of the supplier in order to create the new record. You will have the
		    chance to provide more complex links after the record is saved into the database.
		    <br><br>
		    
		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Finish" name="supplier_action" class="StandardButton"/>
		    
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
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/supplier_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Supplier Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_name") == null) { %>
			    <td align="right">Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="name" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_name"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_description") == null) { %>
			    <td align="right">Description:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Description:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="description" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_description"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_phone_number"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=CoreTools.generateTrueFalseOptions ("enabled", (String) userSession.moveAttribute ("supplier_new_enabled"))%></td>
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
			    <% if (userSession.moveAttribute ("supplier_error_address1") == null) { %>
			    <td align="right">Address 1:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Address 1:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="address1" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_address1"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_address2"))%>"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" size="20" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_email"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" size="15" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_city"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" size="15" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_province"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" size="15" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_country"))%>"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" size="6" value="<%=CoreTools.display (userSession.moveAttribute ("supplier_new_postal_code"))%>"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
