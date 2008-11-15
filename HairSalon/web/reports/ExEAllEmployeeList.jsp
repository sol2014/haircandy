<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=ExEAllEmployeeList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<%@ page contentType="application/vnd.ms-excel" %>

<html>
	<head>
		<title>Employee List</title>
	</head>
	
<body>
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
	</table>
	
	</font>
</body>
</html>
