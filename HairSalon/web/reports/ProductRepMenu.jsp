<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=ProductRepMenu.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<jsp:useBean id="sBean" scope="session"
		class="hs.objects.SupplierBean" />
		
<jsp:useBean id="pBean" scope="session"
		class="hs.objects.ProductBean" />

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<html>
<head>
	<title>Product Report Menu</title>
	<jsp:include page="/reportJsp/subHeader.jsp" />
	<jsp:include page="/reportJsp/subPHeader.jsp" />
</head>

<%--	
<body>
	<form action="Report?action=showOrderList&supplier="${supplier}"">
	<br/>View Product Order List:<br/><br/>
		Please choose a supplier:
		<%if(sBean.popSupplierName()){ %> 
		<select name="supplier">
		<option value="All" SELECTED>All</option>
<%
	while(sBean.showSupplierName()>0)
	{	
%>
		<option value="${sBean.name}">${sBean.name}</option>
<%} %>
		</select>
<%} %>
	<input type="submit" value="Submit" />
	</form>
	</body>
 --%>
	 
</html>
