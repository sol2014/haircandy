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
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.presentation.tags.*" %>
<%@page import="java.util.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setNextPosition(SessionPositions.MaintainSupplier);

SupplierBean sb = (SupplierBean) userSession.moveAttribute ("temp_supplier");
if (sb == null)
{
    sb = (SupplierBean) userSession.moveAttribute("supplier_load_result");
}

int recordNo = sb.getSupplierNo ();

String page_title = "Supplier #" + sb.getSupplierNo ();;

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("supplier_feedback");
String error_string = (String) userSession.moveAttribute ("supplier_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form id="postForm" onsubmit="doSubmit()" method="Post" action="supplier">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/supplier_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Supplier #<%=sb.getSupplierNo ()%> - <%=sb.getName ()%></font></b><br>
		    Provide the basic details of the supplier. You must also provide which products are purchased 
		    from the supplier so that orders can be generated automatically.
		    <br><br>
		    
		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64 (sb);%>
		    <input type="hidden" name="temp_supplier" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="supplier_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="supplier_action" class="StandardButton"/>
		    
		    <%-- This is the feedback section, any errors or messages should be displayed here --%>
		    <% if (error_string != null) { %><font color="red"><%=ServletHelper.display (error_string)%></font><% } %>
		    <% if (feedback_string != null) { %><font color="green"><%=ServletHelper.display (feedback_string)%></font><% } %>
		</td>
	    </tr>
	</table>

	<table width="100%" border="0" cellspacing="10" cellpadding="0">
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
			    <td align="left"><input type="text" name="name" value="<%=ServletHelper.display(sb.getName())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_description") == null) { %>
			    <td align="right">Description:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Description:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="description" value="<%=ServletHelper.display(sb.getDescription())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_phone_number") == null) { %>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="phone_number" id="phone_number" onkeypress="return isNumberTyped (event)" onKeyUp="return checkTelephone(this)" value="<%=ServletHelper.display(sb.getPhoneNumber())%>" size="10"></td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", Boolean.toString (sb.getEnabled ()))%></td>
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
			    <td align="left"><input type="text" name="address1" value="<%=ServletHelper.display (sb.getAddress().getAddress1 ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Address 2:</td>
			    <td align="left"><input type="text" name="address2" value="<%=ServletHelper.display (sb.getAddress().getAddress2 ())%>" size="20"></td>
			</tr>
			<tr>
			    <td align="right">Email:</td>
			    <td align="left"><input type="text" name="email" value="<%=ServletHelper.display (sb.getAddress().getEmail ())%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_city") == null) { %>
			    <td align="right">City:</td>
			    <% } else { %>
			    <td align="right"><font color="red">City:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="city" value="<%=ServletHelper.display (sb.getAddress().getCity ())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_province") == null) { %>
			    <td align="right">Province:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Province:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="province" value="<%=ServletHelper.display (sb.getAddress().getProvince ())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_country") == null) { %>
			    <td align="right">Country:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Country:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="country" value="<%=ServletHelper.display (sb.getAddress().getCountry ())%>" size="15"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("supplier_error_postal_code") == null) { %>
			    <td align="right"><div id="postal_code_label">Postal Code:</div></td>
			    <% } else { %>
			    <td align="right"><font color="red"><div id="postal_code_label">Postal Code:</div></font></td>
			    <% } %>
			    <td align="left"><input type="text" name="postal_code" id="postal_code" onKeyUp="return checkPostalCode(this)" value="<%=ServletHelper.display (sb.getAddress().getPostalCode ())%>" size="6"><i>(ie. N4N4N4)</i></td>
			</tr>
		    </table>
		</td>

		<td width="100%" align="left" valign="top">
		    <div id="productsList">
			
		    </div>
		</td>
	    </tr>
	</table>

	<%@ include file="dialogs/supplier-product-dialog.jsp" %>

    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/supplier-addin.js"></script>
<script>
    <%
            if (sb.getProducts() != null) {
                for (ProductBean pb : sb.getProducts()) {
            %>
                products.push(new product(<%=ServletHelper.display(pb.getProductNo())%>,"<%=ServletHelper.display(pb.getName())%>"));
            <%            }
            }
    %>        
</script>
<script>refillProductsList();</script>