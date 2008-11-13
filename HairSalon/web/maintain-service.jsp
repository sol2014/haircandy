<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
//Grab the UserSession object from the http session
UserSession userSession = (UserSession) session.getAttribute ("user_session");

//Set the next page position for navigator
userSession.setNextPosition (SessionPositions.MaintainService);

ServiceBean service = (ServiceBean) userSession.moveAttribute ("temp_service");
if (service == null)
{
    service = (ServiceBean) userSession.moveAttribute ("service_load_result");
}
Enumeration<ProductBean> pe = service.getProductUse ().keys ();
int recordNo = service.getServiceNo ();

//Set the page title for header
String page_title = "Service #" + service.getServiceNo ();

//Grab any feedback or errors that the servlet may want to show the page
String feedback_string = (String) userSession.moveAttribute ("service_feedback");
String error_string = (String) userSession.moveAttribute ("service_error");
%>

<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form id="post_form" onsubmit="doSubmit()" method="POST" action="service">
	<table border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/service_white.gif" width="48" height="48"></td>
		<td align="left"><b><font size="3">Maintain Service #<%=service.getServiceNo ()%> - <%=service.getName ()%></font></b><br>
		    Provide the basic details of the service. You must also provide which products that are consumed
		    by this service so that inventory can be maintained.
		    <br><br>

		    <%-- Here we we need to store the temporary record data --%>
		    <% String encodedBytes = CoreTools.serializeBase64 (service);%>
		    <input type="hidden" name="temp_service" value="<%=encodedBytes%>"/>

		    <%-- Now we want to add the button that will allow the user to save the entire record --%>
		    <input type="submit" value="Save" name="service_action" class="StandardButton"/>
		    <input type="submit" value="Revert" name="service_action" class="StandardButton"/>
		    
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
			    <td align="right"><img border="0" src="/HairSalon/images/icons/small/service_white.gif" width="16" height="16"></td>
			    <td align="left"><u><b>Service Details</b></u></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_name") == null) { %>
			    <td align="right">Name:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Name:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="firstfield" value="<%=service.getName ()%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_description") == null) { %>
			    <td align="right">Description:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Description:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="description" value="<%=service.getDescription ()%>" size="20"></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_duration") == null) { %>
			    <td align="right">Duration:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Duration:</font></td>
			    <% } %>
			    <td align="left"><%=ServletHelper.generateDurationPicker ("duration", service.getDuration ())%></td>
			</tr>
			<tr>
			    <% if (userSession.moveAttribute ("service_error_price") == null) { %>
			    <td align="right">Price:</td>
			    <% } else { %>
			    <td align="right"><font color="red">Price:</font></td>
			    <% } %>
			    <td align="left"><input type="text" name="price" style="text-align:right" onkeypress="return isDecimalTyped (event)" value="<%=ServletHelper.display(service.getPrice ())%>" size="5">$</td>
			</tr>
			<tr>
			    <td align="right">Enabled:</td>
			    <td align="left"><%=ServletHelper.generateTrueFalseOptions ("enabled", Boolean.toString(service.getEnabled ()))%></td>
			</tr>
		    </table>
		</td>

		<td width="100%" align="left" valign="top">
		    <div id="ajax_product_list">
			
		    </div>
		</td>
	    </tr>
	</table>

	<%@ include file="dialogs/service-product-dialog.jsp" %>

    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/service-addin.js"></script>
<script>
	<% pe = service.getProductUse ().keys ();
        while (pe.hasMoreElements ()) {
	ProductBean pb = pe.nextElement ();%>
            addInitialProduct ('<%=pb.getProductNo ()%>', '<%=pb.getName ()%>', '<%=pb.getPrice()%>', '<%=service.getProductUse ().get(pb)%>');
	<% } %>
</script>
<script>refillProductsList();</script>
