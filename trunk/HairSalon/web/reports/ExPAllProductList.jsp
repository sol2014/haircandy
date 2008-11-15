<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=ExPAllProductList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<%@ page contentType="application/vnd.ms-excel" %>

<html>
	<head>
		<title>Product Order List</title>
	</head>
	
<body>
	<jsp:useBean id="sBean" scope="session"
		class="hs.objects.SupplierBean" />
		
	<%-- Build table of products --%>
	<center>
		<font face="Trebuchet MS" size="3">
		<h3>Report Order List</h3>
		<h4>Date:  <taglib:datetime/> </h4><br>
		</font>
	</center>
	
	<font face="Trebuchet MS" size="3">
	<table border="1" align="center" width="600">
	
	<tr>
		<td align="center" width="10%"><b>Name</b></td>
		<td align="center" width="10%"><b>Phone Number</b></td>
		<td align="center" width="10%"><b>Product Name</b></td>
		<td align="center" width="10%"><b>Brand</b></td>
		<td align="center" width="10%"><b>Type</b></td>
		<td align="center" width="10%"><b>Quantity Per</b></td>
		<td align="center" width="10%"><b>Unit</b></td>
		<td align="center" width="10%"><b>Min Qty</b></td>
		<td align="center" width="10%"><b>Stock Qty</b></td>
		<td align="center" width="10%"><b>Price</b></td>
	</tr>
	
	<%-- A var. for the current row# to start in this page. --%>
	<c:set var="startRow" value="0" scope="request" />
	<c:set var="attribute" value="" scope="request" />

<%
	int rowCount=0;  //Row count for this page.

	/* 
	 * If the result set was populated successfully, convert each
	 * item in the list into a bean.
	 */
	if(sBean.populate()){
%>
	<c:if test="${!empty param.start}">		
		<jsp:setProperty name="sBean" property="startRow" param="start" />
	</c:if>
<%
	while(sBean.nextRow()>0)
	{
		rowCount++;
		
%>
	<tr>
		<td align="left" width="10%"><jsp:getProperty name="sBean" property="name"/></td>
		<td align="right" width="15%"><taglib:FormatTag format="phone">
		<jsp:getProperty name="sBean" property="phoneNumber"/>
		</taglib:FormatTag></td>
		<c:forEach items="${sBean.products}" var="product">
		<td align="left" width="15%">${product.name}</td>
		<td align="left" width="15%">${product.brand}</td>
		<td align="left" width="10%">${product.type}</td>
		<td align="right" width="5%">${product.qtyPer}</td>
		<td align="left" width="5%">${product.unit}</td>
		<td align="right" width="5%">${product.minLevel}</td>
		<td align="right" width="5%">${product.stockQty}</td>
		<td align="right" width="15%"><taglib:FormatTag format="currency">
		${product.price}</taglib:FormatTag></td>
		</c:forEach>
	</tr>

<%
	}
	}
%>
	</table>

	<table align = "right">		
	<tr>
		<td>
		<br/>Total of 
		<jsp:getProperty name="sBean" property="totalRow" /> item in the list.
		</td>
	</tr>
	</table>
	
	</font>
</body>
</html>
