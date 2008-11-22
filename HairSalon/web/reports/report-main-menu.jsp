<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/html4/loose.dtd">
 
<%-- JSP Directives --%>
<%@ page errorPage="/report-error.jsp?from=report-main-menu.jsp" %>
 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Report</title>
</head>
<body>
	<h3 align="center">Please choose one of the following report:</h3>
	<p align="center">
            <br/>
            <a href="client-information.jsp">Client Information</a><br/><br/>
            <a href="employee-information.jsp">Employee Information</a><br/><br/>
            <a href="product-order-list.jsp">Product Order List</a><br/><br/>
            <a href="product-usage.jsp">Product Usage</a><br/><br/>
            <a href="sale-information.jsp?NameType=everyone&FirstName=&LastName=&DateType=Multiple&BeginDate=yyyy-mm-dd&EndDate=yyyy-mm-dd">Sale Information</a><br/><br/>
            <a href="service-usage.jsp">Service Usage</a><br/><br/>
            <br/>
	</p>
</body>
</html>