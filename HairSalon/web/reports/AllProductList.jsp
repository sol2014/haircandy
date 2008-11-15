<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=AllProductList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<html>
	<head>
		<title>Product Order List</title>
		<jsp:include page="/reportJsp/subHeader.jsp" />
		<jsp:include page="/reportJsp/subPHeader.jsp" />
	</head>
	
<body>
	<font face="Arial">
	
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
		<td align="center" width="15%"><b>Phone Number</b></td>
		<td align="center" width="15%"><b>Product Name</b></td>
		<td align="center" width="15%"><b>Brand</b></td>
		<td align="center" width="10%"><b>Type</b></td>
		<td align="center" width="5%"><b>Quantity Per</b></td>
		<td align="center" width="5%"><b>Unit</b></td>
		<td align="center" width="5%"><b>Min Qty</b></td>
		<td align="center" width="5%"><b>Stock Qty</b></td>
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
	while((rowCount<sBean.getRowPerPage())&&sBean.nextRow()>0)
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
		<td align="right" width="10%"><taglib:FormatTag format="currency">
		${product.price}</taglib:FormatTag></td>
		
		</c:forEach>
	</tr>

<%
	}
	}
%>
	</table>
	
	<table align = "right">
	<c:if test="${sBean.currentPage eq sBean.totalPage}">		
	<tr>
		<td>
		<br/>Total of 
		<jsp:getProperty name="sBean" property="totalRow" /> item in the list.
		</td>
	</tr>
	</c:if>
	
	<c:if test="${sBean.totalPage>0}">	
	<tr>
		<td>
		<br/>Page ${sBean.currentPage} of 
		${sBean.totalPage}
		</td>
	</tr>
	</c:if>
	</table>
	
	<%-- Display the back and next links --%>
	<c:if test="${sBean.totalPage>1}">	
	<br/><br/><br/>
	<table align = "left">
	<tr>
		<c:if test="${sBean.currentPage>1}">
		<td>
		<c:choose>
			<c:when test="${startRow>(sBean.rowPerPage-1)}">
			<br/><a href="?start=${startRow-sBean.rowPerPage}">Back</a>
			</c:when>
		<c:otherwise>
			<br/><a href="?start=0">Back</a>
		</c:otherwise>
		</c:choose>
		</td>
		</c:if>
			
		<c:forEach var="pages" begin="1" end="${sBean.totalPage}" step="1" varStatus="num">
			<td><br />
			<a href="?start=${(num.count-1)*sBean.rowPerPage}">${num.count}</a></td>
		</c:forEach>

		<c:if test="${sBean.currentPage lt sBean.totalPage}">
				<td>
					<br/><a href="?start=${sBean.currentRow}">Next</a>
				</td>
		</c:if>
		
	</tr>
	</table>
	</c:if>
	
	<br/><br/><br/>

	<center><br/>
	<a href="PrPAllProductList.jsp?start=0" size=20 target="_blank">Print Report</a>&nbsp;
	<a href="ExPAllProductList.jsp?start=0" size=20 target="_blank">Export Excel</a>
	</center>

	</font>
</body>
</html>
	
