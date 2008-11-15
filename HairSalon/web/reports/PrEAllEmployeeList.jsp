<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=PrEAllEmployeeList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<html>
	<head>
		<title>Employee List</title>
	</head>
	
<body>
	<font face="Arial">
	
	<jsp:useBean id="eBean" scope="session"
		class="hs.objects.EmployeeBean" />
		
	<%-- Build table of products --%>
	<center>
	<form><input type="button" value=" Print this page "
		onclick="window.print();return false;" /></form><br/>

		<font face="Trebuchet MS" size="3">
		<h3>Employee List Report</h3>
		<h4>Date:  <taglib:datetime/> </h4><br>
		</font>
	</center>
	
	<font face="Trebuchet MS" size="3">

	<table border="1" align="center" width="600">
	
	<tr>
		<td align="center" width="10%"><b>Employee Num.</b></td>
		<td align="center" width="20%"><b>First Name</b></td>
		<td align="center" width="20%"><b>Last Name</b></td>
		<td align="center" width="20%"><b>Phone Num.</b></td>
		<td align="center" width="10%"><b>Role</b></td>
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
	if(eBean.popEmpList()){
%>
	<c:if test="${!empty param.start}">		
		<jsp:setProperty name="eBean" property="startRow" param="start" />
	</c:if>
<%
	while(eBean.nextRowEmpL()>0)
	{
		rowCount++;
		
%>
	<tr>
		<td align="right" width="10%">
		<jsp:getProperty name="eBean" property="employeeNo"/></td>
		<td align="left" width="20%">
		<jsp:getProperty name="eBean" property="firstName"/></td>
		<td align="left" width="20%">
		<jsp:getProperty name="eBean" property="lastName"/></td>
		<td align="left" width="20%"><taglib:FormatTag format="phone">
		<jsp:getProperty name="eBean" property="phoneNumber"/>
		</taglib:FormatTag></td>
		<td align="left" width="10%">
		<jsp:getProperty name="eBean" property="role"/></td>
	</tr>

<%
	}
	}
%>
	</table>
	
	<table align = "right">
	<c:if test="${eBean.currentPage eq eBean.totalPage}">		
	<tr>
		<td>
		<br/>Total of 
		<jsp:getProperty name="eBean" property="totalRow" /> item in the list.
		</td>
	</tr>
	</c:if>
	
	<c:if test="${eBean.totalPage>0}">	
	<tr>
		<td>
		<br/>Page ${eBean.currentPage} of 
		${eBean.totalPage}
		</td>
	</tr>
	</c:if>
	</table>
	
	<%-- Display the back and next links --%>
	<c:if test="${eBean.totalPage>1}">	
	<br/><br/><br/>
	<table align = "left">
	<tr>
		<c:if test="${eBean.currentPage>1}">
		<td>
		<c:choose>
			<c:when test="${startRow>(eBean.rowPerPage-1)}">
			<br/><a href="?start=${startRow-eBean.rowPerPage}">Back</a>
			</c:when>
		<c:otherwise>
			<br/><a href="?start=0">Back</a>
		</c:otherwise>
		</c:choose>
		</td>
		</c:if>
			
		<c:forEach var="pages" begin="1" end="${eBean.totalPage}" step="1" varStatus="num">
			<td><br />
			<a href="?start=${(num.count-1)*eBean.rowPerPage}">${num.count}</a></td>
		</c:forEach>

		<c:if test="${eBean.currentPage lt eBean.totalPage}">
				<td>
					<br/><a href="?start=${eBean.currentRow}">Next</a>
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
