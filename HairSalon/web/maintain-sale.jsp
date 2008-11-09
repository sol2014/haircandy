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
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute ("user_session");

//Set the next page position for navigator
userSession.setNextPosition (SessionPositions.MaintainSale);

//Grab the load result from the UserSession
SaleBean sale = (SaleBean) userSession.moveAttribute ("temp_sale");
if (sale == null)
{
    sale = (SaleBean) userSession.moveAttribute ("sale_load_result");
}

ClientBean client = sale.getClient ();
//EmployeeBean employee = new EmployeeBean();
int employee = sale.getEmployee ().getEmployeeNo ();

//Set the page title for header
String page_title = "Sale #"+sale.getTransactionNo ();

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("sale_save_feedback");
String error_string = (String) userSession.moveAttribute ("sale_save_error");
%>

<%-- Make sure to show the page header so that the header, navigation bar and menu show up --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="sale">
	    <table border="0" cellspacing="5" cellpadding="0">
		<tr>
		    <td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/sale_white.gif" width="48" height="48"></td>
		    <td align="left"><b><font size="3">Maintain Sale #<%=sale.getTransactionNo ()%> - <%=sale.getPaymentType ()%></font></b><br>
			sale.
			<br><br>
			<%-- Here we we need to store the temporary record data --%>
			<% String encodedBytes = CoreTools.serializeBase64 (sale);%>
			<input type="hidden" name="temp_sale" value="<%=encodedBytes%>"/>

			<%-- Now we want to add the button that will allow the user to save the entire record --%>
			<input type="submit" value="Finish" name="sale_action" class="StandardButton"/>

			<%-- This is the feedback section, any errors or messages should be displayed here --%>
			<% if (error_string != null)
				{%>
			<font color="red"><%=CoreTools.display (error_string)%></font>
			<% }%>
			<% if (feedback_string != null)
				{%>
			<font color="green"><%=CoreTools.display (feedback_string)%></font>
			<% }%>
		    </td>
		</tr>
	    </table>

	    <table width="100%" border="0" cellspacing="10" cellpadding="0">
		<tr>
		    <td align="center" valign="top">
			<table border="0" cellpadding="0" cellspacing="3" width="225">
                            
                            <tr>
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/client_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Client Details</b></u></td>
			</tr>
			<tr>
			    <td align="right">First Name:</td>
			    <td align="left"><input type="text" name="clientFirstName" size="15" value="<%=CoreTools.display (client.getFirstName ())%>"></td>
			</tr>

			<tr>
			    <td align="right">Last Name:</td>
			    <td align="left"><input type="text" name="clientLastName" size="15" value="<%=CoreTools.display (client.getLastName ())%>"></td>
			</tr>

			<tr>
			    <td align="right"><div id="telephone_label">Telephone:</div></td>
			    <td align="left"><input type="text" name="clientPhonrNumber" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=CoreTools.display (client.getPhoneNumber ())%>"></td>
			</tr>
			    <tr>
				<td align="right"><img border="0" src="/HairSalon/images/icons/small/sale_white.gif" width="16" height="16"></td>
				<td align="left"><u><b>Sale Details</b></u></td>
			    </tr>
                            <tr>
                                <td align="right">Employee ID:</td>
                                <td align="left"><input type="text" name="employeeId" value="<%=CoreTools.display (sale.getEmployee ().getEmployeeNo ())%>" size="25"></td>

                            </tr>
			    <tr>
				 <td align="right">Payment Type:</td>
				 <td align="left"><input type="text" name="paymentType" value="<%=CoreTools.display (sale.getPaymentType ())%>" size="25"></td>
			    </tr>
			     <tr>
				 <td align="right">Payment:</td>
				 <td align="left"><input type="text" name="payment" 
										   value="<%=CoreTools.display (sale.getPayment())%>" size="25"></td>
			    </tr>
			    <tr>
				<td align="right">Total Due:</td>
				 <td align="left"><input type="text" name="totalDue" 
										   value="<%=CoreTools.display (sale.getTotalDue ())%>" size="25"></td>
			    </tr>
			    <tr>
				<td align="right">Is Complete:</td>
				<td align="left"><select size="1" name="enabled"><%=CoreTools.generateOptions ((String) userSession.getAttribute ("isComplete"), new String[] { "True", "False" })%></select></td>
			    </tr>
			</table>
		    </td>
		    
		    <td align="right" valign="top" width="100%">
		    <table align="right" valign="top" width="100%" cellspacing="10">
			<tr>
			    <td width="100%" align="left" valign="top">
				<div id="productsList">
				</div>
			    </td>
			</tr>
			<tr>
			    <td width="100%" align="left" valign="top">
				<div id="servicesList">
				    
				</div>
			    </td>
			</tr>
		    </table>
		</td>
	    </tr>
	</table>
	<%@ include file="dialogs/supplier-product-dialog.jsp" %>
	<%@ include file="dialogs/employee-service-dialog.jsp" %>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/sale-addin.js"></script>
<script>
	<%
	Enumeration<ProductBean> pe = sale.getProductSold ().keys ();
	while (pe.hasMoreElements ())
	{
	    ProductBean pb = pe.nextElement (); %>
            addInitialProduct ('<%=pb.getProductNo ()%>', '<%=pb.getName ()%>', '<%=sale.getProductSold ().get(pb)%>');
	<% } %>
	    
	<%
	Enumeration<ServiceBean> se = sale.getServiceSold ().keys ();
	while (se.hasMoreElements ())
	{
	    ServiceBean sb = se.nextElement (); %>
            addInitialService ('<%=sb.getServiceNo ()%>', '<%=sb.getName ()%>', '<%=sale.getServiceSold ().get(sb)%>');
	<% } %>
</script>
<script>refillProductsList();</script>
<script>refillServicesList();</script>