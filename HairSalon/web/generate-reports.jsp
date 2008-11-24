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
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.presentation.tags.*" %>
<%@page import="java.util.*" %>
<%@page errorPage="/defaultError.jsp?from=index.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<taglib:ValidateEmployee minimum="Receptionist" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%-- Retrieve the UserSession object from the http session. --%>
<%
		UserSession userSession = (UserSession) session.getAttribute("user_session");
		int recordNo = 0;
%>

<%-- Set the next page position for navigator. --%>
<% userSession.setCurrentPosition(SessionPositions.Reports);%>

<%-- Set the title of the page. --%>
<% String page_title = "Reports";%>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<%-- Grab any feedback or erros that the servlet may want to show page --%>
<% String feedback_string = (String) userSession.moveAttribute("report_feedback");%>
<% String error_string = (String) userSession.moveAttribute("report_error");%>

<%-- PAGE CONTENT --%>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="salon">
        <table border="0" cellspacing="5" cellpadding="0">
            <tr>
                <td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/report_white.gif" width="48" height="48"></td>	    
                <td align="left"><font size="3"><b>Generate Reports</b><br>
                    A manager can generate and print various reports from the information in the database. You can also export reports to Microsoft Excel documents.
                    <br><br>
                    
                    <%-- Now we want to add the button that will allow the user to make reports --%>
                    <h3>Please choose one of the following report:</h3>
                    <p align="center">
                        <br/>
                        <a href="client-information.jsp?QueryType=All">Client Information</a><br/><br/>
                        <a href="employee-information.jsp">Employee Information</a><br/><br/>
                        <a href="product-order-list.jsp">Product Order List</a><br/><br/>
                        <a href="product-usage.jsp">Product Usage</a><br/><br/>
                        <a href="sale-information.jsp?NameType=everyone&FirstName=&LastName=&DateType=Multiple&BeginDate=yyyy-mm-dd&EndDate=yyyy-mm-dd">Sale Information</a><br/><br/>
                        <a href="service-usage.jsp">Service Usage</a><br/><br/>
                        <br/>
                    </p>
                    
                    <%-- This is the feedback section, any errors or messages should be displayed here --%>
                    <% if (error_string != null) {%><br><font color="red"><%=error_string%></font><% }%>
                    <% if (feedback_string != null) {%><br><font color="green"><%=feedback_string%></font><% }%>
                </td>
            </tr>
        </table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
