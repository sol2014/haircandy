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
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Receptionist" />

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
int recordNo = sale.getTransactionNo ();

ClientBean client = sale.getClient ();
//EmployeeBean employee = new EmployeeBean();
int employee = sale.getEmployee ().getEmployeeNo ();

//Set the page title for header
String page_title = "Sale #"+sale.getTransactionNo ();

SalonBean salon = SessionController.loadSalon(userSession, new SalonBean());

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("sale_save_feedback");
String error_string = (String) userSession.moveAttribute ("sale_save_error");
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
                <td align="left"><b><font size="3">Maintain Sale #<%=sale.getTransactionNo ()%> - <%=sale.getPaymentType ()%></font></b><br>
                    Sales can be maintained after they are created in case we need to do refunds or make changes to products and services
		    that were sold. You can also deleted if it is to be cancelled completely.
                    <br><br>
                    
                    <% if (sale != null) {%>
                    <%-- Here we we need to store the temporary record data --%>
                    <% String encodedBytes = CoreTools.serializeBase64(sale);%>
                    <input type="hidden" name="temp_sale" value="<%=encodedBytes%>"/>
                    <% }%>
                    
                    <%-- Now we want to add the button that will allow the user to save the entire record --%>
                    <input type="submit" value="Save" name="sale_action" class="StandardButton"/>
                    <input type="submit" value="Revert" name="sale_action" class="StandardButton"/>
		    
                    <% if (error_string != null) {%>
		    <font color="red"><%=ServletHelper.display (error_string)%></font>
		    <% }%>
		    <% if (feedback_string != null)
			    {%>
		    <font color="green"><%=ServletHelper.display (feedback_string)%></font>
		    <% }%>
                </td>
            </tr>
        </table>
        
        <table border="0" width="100%" cellspacing="10" cellpadding="0">
            <tr>
                <td align="right" valign="top">
                    <table align="right" border="0" cellpadding="0" width="250">
                        <tr>
                            <td align="right"><img border="0" src="/HairSalon/images/icons/small/client_white.gif" width="16" height="16"></td>
                            <td align="left"><u><b>Client Details</b></u></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_first_name") == null) {%>
                            <td align="right">First Name:</td>
                            <% } else {%>
                            <td align="right"><font color="red">First Name:</font></td>
                            <% }%>
                            <td align="left"><input type="text" name="first_name" id="first_name" size="20" value="<%=ServletHelper.display (client.getFirstName ())%>"></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_last_name") == null) {%>
                            <td align="right">Last Name:</td>
                            <% } else {%>
                            <td align="right"><font color="red">Last Name:</font></td>
                            <% }%>
                            <td align="left"><input type="text" name="last_name" id="last_name" size="20" value="<%=ServletHelper.display (client.getLastName ())%>"></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_phone_number") == null) {%>
                            <td align="right"><div id="telephone_label">Telephone:</div></td>
                            <% } else {%>
                            <td align="right"><font color="red"><div id="telephone_label">Telephone:</div></font></td>
                            <% }%>
                            <td align="left"><input type="text" name="phone_number" id="phone_number" onkeypress="return isNumberTyped (event)" onKeyUp="return checkTelephone(this)" size="10" value="<%=ServletHelper.display (client.getPhoneNumber ())%>">
                                <img style="cursor:pointer" align="absmiddle" src="images/icons/small/find_white.gif" onclick="findClient()" title="Find and load client from this phone number."/>
                                <img style="cursor:pointer" align="absmiddle" src="images/icons/small/personal_white.gif" onclick="setGuest()" title="Use a guest identity."/>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">&nbsp;</td>
                            <td align="left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><img border="0" src="/HairSalon/images/icons/small/sale_white.gif" width="16" height="16"></td>
                            <td align="left"><u><b>Sale Details</b></u></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_employee_no") == null) {%>
                            <td align="right">Employee ID:</td>
                            <% } else {%>
                            <td align="right"><font color="red">Employee ID:</font></td>
                            <% }%>
                            <td align="left"><input type="text" name="employee_no" size="6" onkeypress="return isNumberTyped (event)" style="text-align:right" value="<%=ServletHelper.display (sale.getEmployee ().getEmployeeNo ())%>"></td>
                        </tr>
                        <tr>
                            <td align="right">Sub-Total:</td>
                            <td align="left"><input type="text" name="total_due" readonly id="total_due" size="6" style="text-align:right" value="<%=ServletHelper.display (sale.getTotalDue ())%>">$</td>
                        </tr>
                        <tr>
                            <td align="right">Tax (<%=salon.getTaxRate()%>%):</td>
                            <td align="left"><input type="text" name="total_tax" readonly id="total_tax" size="6" style="text-align:right" value="<%=ServletHelper.display (sale.getTotalTax ())%>">$</td>
                        </tr>
                        <tr>
                            <td align="right">Discount:</td>
                            <td align="left"><input type="text" name="discount" id="discount" onkeypress="return isNumberTyped (event)" size="3" onKeyUp="return calculateTotal()" style="text-align:right" value="<%=ServletHelper.display (sale.getDiscount ())%>">%</td>
                        </tr>
                        <tr>
                            <td align="right">Discount:</td>
                            <td width="50" align="right"><b><div id="discount_label">$0.00</div></b></td>
                        </tr>
                        <tr>
                            <td align="right">Total:</td>
                            <td width="50" align="right"><b><u><div id="total_label">$0.00</div></u></b></td>
                        </tr>
                        <tr>
                            <td align="right">Change:</td>
                            <td width="50" align="right"><b><div id="change_label">$0.00</div></b></td>
                        </tr>
                        <tr>
                            <% if (userSession.moveAttribute("sale_error_payment") == null) {%>
                            <td align="right">Payment:</td>
                            <% } else {%>
                            <td align="right"><font color="red">Payment:</font></td>
                            <% }%>
                            <td align="left"><input type="text" name="payment" id="payment" size="6" onkeypress="return isDecimalTyped (event)" onKeyUp="return calculateTotal()" style="text-align:right" value="<%=ServletHelper.display (sale.getPayment())%>">$
                            &nbsp;<img style="cursor:pointer" align="absmiddle" src="images/icons/small/setfield_white.gif" onclick="setTotalPayment()" title="Use total as payment."/></td>
                        </tr>
                        <tr>
                            <td align="right">Payment Type:</td>
                            <td align="left"><select name="payment_type" size="1"><%=ServletHelper.generatePaymentTypeOptions(ServletHelper.display (sale.getPaymentType ()), false)%></select></td>
                        </tr>
                        <tr>
                            <td align="right">Complete:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions("is_complete", Boolean.toString (sale.getIsComplete ()))%></td>
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