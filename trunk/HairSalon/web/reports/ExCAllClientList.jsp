<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=ExCAllList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<%@ page contentType="application/vnd.ms-excel" %>

<html>
	<head>
		<title>Client List</title>
	</head>
	
<body>	
	<jsp:useBean id="cBean" scope="session"
		class="hs.objects.ClientBean" />
		
	<%-- Build table of products --%>
	<center>
		<font face="Trebuchet MS" size="3">
		<h3>Client List</h3>
		<h4>Date:  <taglib:datetime/> </h4><br>
		</font>
	</center>
	
	<font face="Trebuchet MS" size="3">

	<table border="1" align="center" width="600">
	
	<tr>
		<td align="center" width="10%"><b>First Name</b></td>
		<td align="center" width="10%"><b>Last Number</b></td>
		<td align="center" width="15%"><b>Phone Number</b></td>
		<td align="center" width="20%"><b>Address 1</b></td>
		<td align="center" width="10%"><b>Address 2</b></td>
		<td align="center" width="5%"><b>City</b></td>
		<td align="center" width="5%"><b>Province</b></td>
		<td align="center" width="5%"><b>Country</b></td>
		<td align="center" width="5%"><b>Postal Code</b></td>
		<td align="center" width="10%"><b>E-mail</b></td>
		<td align="center" width="5%"><b>Enable</b></td>
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
	if(cBean.populate()){
%>
	<c:if test="${!empty param.start}">		
		<jsp:setProperty name="cBean" property="startRow" param="start" />
	</c:if>
<%
	while(cBean.nextRow()>0)
	{
		rowCount++;
		
%>
	<tr>
		<td align="left" width="10%"><jsp:getProperty name="cBean" property="firstName"/></td>
		<td align="left" width="10%"><jsp:getProperty name="cBean" property="lastName"/></td>
		<td align="right" width="15%"><taglib:FormatTag format="phone">
		<jsp:getProperty name="cBean" property="phoneNumber"/>
		</taglib:FormatTag></td>
		<td align="left" width="20%">${cBean.address.address1}</td>
		<td align="left" width="10%">${cBean.address.address2}</td>
		<td align="left" width="5%">${cBean.address.city}</td>
		<td align="left" width="5%">${cBean.address.province}</td>
		<td align="left" width="5%">${cBean.address.country}</td>
		<td align="left" width="5%">${cBean.address.postalCode}</td>
		<td align="left" width="10%">${cBean.address.email}</td>
		<td align="left" width="5%"><jsp:getProperty name="cBean" property="enabled"/></td>	
	</tr>
<%
	}
	}
%>
	</table>
	
	<table align = "right">
	<c:if test="${cBean.currentPage eq cBean.totalPage}">		
	<tr>
		<td>
		<br/>Total of 
		<jsp:getProperty name="cBean" property="totalRow" /> item in the list.
		</td>
	</tr>
	</c:if>
	</table>
	
	</font>
</body>
</html>

	