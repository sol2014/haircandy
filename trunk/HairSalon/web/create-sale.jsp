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
<%@page import="hs.app.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");
userSession.setCurrentPosition(SessionPositions.Sales);
String page_title = "Create Sale";
int recordNo = 0;

SalonBean salon = SessionController.loadSalon(userSession, new SalonBean());
SaleBean sale = (SaleBean) userSession.moveAttribute("temp_new_sale");
String error_string = (String) userSession.moveAttribute("sale_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<script>
    function setGuest ()
    {
	document.getElementById("first_name").value = "Guest";
	document.getElementById("last_name").value = "Guest";
	document.getElementById("phone_number").value = "0000000000";
    }

    function finished(firstName, lastName)
    {
	document.getElementById("first_name").value = firstName;
	document.getElementById("last_name").value = lastName;
    }

    function findClient ()
    {
	if (document.getElementById("phone_number") != null)
	{
	    var phoneNumber = document.getElementById("phone_number").value;
	    var messager = new Ajaxer();
	    var queryString="client_action=ClientLookup&";
	    queryString += "phone_number="+phoneNumber;
	    messager.request("client",queryString);
	}
    }

    function setTotalPayment ()
    {
	var total = getSaleTotal ();
	var a = new ToFmt (total);
	document.getElementById ("payment").value = a.fmtF(9,2).trim();
	calculateTotal ();
    }
</script>

<font face="Trebuchet MS" size="2">
    <form id="postForm" onsubmit="doSubmit()" method="POST" action="sale">
        <table border="0" cellspacing="5" cellpadding="0">
            <tr>
                <td align="Left" valign="top"><img border="0" src="/HairSalon/images/icons/big/sale_white.gif" width="48" height="48"></td>
                <td align="left"><b><font size="3">Create new Sale</font></b><br>
                    Sales can be created for clients who just simply need to purchase products 
                    and services from the salon without an appointment. Make sure to provide all
		    fields and verify information before finishing.
                    <br><br>
                    
                    <% if (sale != null) {%>
                    <%-- Here we we need to store the temporary record data --%>
                    <% String encodedBytes = CoreTools.serializeBase64(sale);%>
                    <input type="hidden" name="temp_new_sale" value="<%=encodedBytes%>"/>
                    <% }%>
                    
                    <%-- Now we want to add the button that will allow the user to save the entire record --%>
                    <input type="submit" value="Finish" name="sale_action" class="StandardButton"/>
                    <input type="submit" value="Search" name="sale_action" class="StandardButton"/>
		    
                    <% if (error_string != null) {%>
                    <font color="red">
                        <%=error_string%>
                    </font>
                    <%  }%>
                </td>
            </tr>
        </table>
        
        <table border="0" width="100%" cellspacing="10" cellpadding="0">
            <tr>
                <td align="right" valign="top">
                    <table align="right" border="0" cellpadding="0" width="250">
                        <tr>
                            <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/client_white.gif" width="16" height="16"></td>
                            <td nowrap="nowrap" align="left"><u><b>Client Details</b></u></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_first_name") == null) {%>
                            <td nowrap="nowrap" align="right">First Name:</td>
                            <% } else {%>
                            <td nowrap="nowrap" align="right"><font color="red">First Name:</font></td>
                            <% }%>
                            <td nowrap="nowrap" align="left"><input type="text" name="first_name" id="first_name" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_first_name"))%>"></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_last_name") == null) {%>
                            <td nowrap="nowrap" align="right">Last Name:</td>
                            <% } else {%>
                            <td nowrap="nowrap" align="right"><font color="red">Last Name:</font></td>
                            <% }%>
                            <td nowrap="nowrap" align="left"><input type="text" name="last_name" id="last_name" size="20" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_last_name"))%>"></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_phone_number") == null) {%>
                            <td nowrap="nowrap" align="right"><div id="telephone_label">Telephone:</div></td>
                            <% } else {%>
                            <td nowrap="nowrap" align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
                            <% }%>
                            <td nowrap="nowrap" align="left"><input type="text" name="phone_number" id="phone_number" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_phone_number"))%>">
                                <img style="cursor:pointer" align="absmiddle" src="images/icons/small/find_white.gif" onclick="findClient()" title="Find and load client from this phone number."/>
                                <img style="cursor:pointer" align="absmiddle" src="images/icons/small/personal_white.gif" onclick="setGuest()" title="Use a guest identity."/>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">&nbsp;</td>
                            <td nowrap="nowrap" align="left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right"><img border="0" src="/HairSalon/images/icons/small/sale_white.gif" width="16" height="16"></td>
                            <td nowrap="nowrap" align="left"><u><b>Sale Details</b></u></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_employee_no") == null) {%>
                            <td nowrap="nowrap" align="right">Employee ID:</td>
                            <% } else {%>
                            <td nowrap="nowrap" align="right"><font color="red">Employee ID:</font></td>
                            <% }%>
                            <td nowrap="nowrap" align="left"><input type="text" name="employee_no" size="6" style="text-align:right" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_employee_no"))%>"></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Sub-Total:</td>
                            <td nowrap="nowrap" align="left"><input type="text" name="total_due" readonly id="total_due" size="6" style="text-align:right" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_total_due"))%>">$</td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Tax (<%=salon.getTaxRate()%>%):</td>
                            <td nowrap="nowrap" align="left"><input type="text" name="total_tax" readonly id="total_tax" size="6" style="text-align:right" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_total_tax"))%>">$</td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Discount:</td>
                            <td nowrap="nowrap" align="left"><input type="text" name="discount" id="discount" size="3" onKeyUp="return calculateTotal()" style="text-align:right" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_discount"))%>">%</td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Discount:</td>
                            <td nowrap="nowrap" align="right"><b id="discount_label">$0.00</b></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Total:</td>
                            <td nowrap="nowrap" align="right"><b><u id="total_label">$0.00</u></b></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Change:</td>
                            <td nowrap="nowrap" align="right"><b id="change_label">$0.00</b></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_payment") == null) {%>
                            <td nowrap="nowrap" align="right">Payment:</td>
                            <% } else {%>
                            <td nowrap="nowrap" align="right"><font color="red">Payment:</font></td>
                            <% }%>
                            <td nowrap="nowrap" align="left"><input type="text" name="payment" id="payment" size="6" onKeyUp="return calculateTotal()" style="text-align:right" value="<%=ServletHelper.display(userSession.moveAttribute("sale_new_payment"))%>">$
                            &nbsp;<img style="cursor:pointer" align="absmiddle" src="images/icons/small/setfield_white.gif" onclick="setTotalPayment()" title="Use total as payment."/></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Payment Type:</td>
                            <td nowrap="nowrap" align="left"><select name="payment_type" size="1"><%=ServletHelper.generatePaymentTypeOptions((String) userSession.moveAttribute("sale_new_payment_type"), false)%></select></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="right">Complete:</td>
                            <td nowrap="nowrap" align="left"><%=ServletHelper.generateTrueFalseOptions("is_complete", (String) userSession.moveAttribute("sale_new_is_complete"))%></td>
                        </tr>
                    </table>
                </td>
                
                <td align="right" valign="top" width="100%">
                    <table align="left" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
                        <tr>
                            <td width="100%" align="left" valign="top">
                                <div id="productsList">
                                    
                                </div>
				<br />
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
        <%@ include file="dialogs/sale-product-dialog.jsp" %>
        <%@ include file="dialogs/sale-service-dialog.jsp" %>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/sale-addin.js"></script>
<script>
    setTaxPercent (<%=salon.getTaxRate()%>);
        <%
            if (sale != null) {
                Enumeration<ProductBean> pe = sale.getProductSold().keys();
                while (pe.hasMoreElements()) {
                    ProductBean pb = pe.nextElement();%>
                        addInitialProduct ('<%=pb.getProductNo()%>', '<%=pb.getName()%>', '<%=pb.getPrice()%>', '<%=sale.getProductSold().get(pb)%>');
        <% }%>
            
        <%
                Enumeration<ServiceBean> se = sale.getServiceSold().keys();
                while (se.hasMoreElements()) {
                    ServiceBean sb = se.nextElement();%>
                        addInitialService ('<%=sb.getServiceNo()%>', '<%=sb.getName()%>', '<%=sb.getPrice()%>', '<%=sale.getServiceSold().get(sb)%>');
        <% }
            }%>
</script>

<script>refillServicesList();</script>
<script>refillProductsList();</script>