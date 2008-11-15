<%-- JSP Directives --%>
<%@ page errorPage="reports/defaultError.jsp?from=AllClientList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<html>
	<head>
		<title>Client List</title>
		<jsp:include page="reports/jsp/subHeader.jsp" />
		<jsp:include page="reports/jsp/subCHeader.jsp" />
	</head>
	
<body>
	<font face="Arial">
	
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
	if(cBean.populate())
	{
%>
	<c:if test="${!empty param.start}">		
		<jsp:setProperty name="cBean" property="startRow" param="start" />
	</c:if>
<%
	while((rowCount<cBean.getRowPerPage())&&cBean.nextRow()>0)
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
		<c:choose>
			<c:when test="${!empty cBean.address.address2}">
			<td align="left" width="10%">${cBean.address.address2}</td>
			</c:when>
		<c:otherwise>
			<td align="left" width="10%">N/A</td>
		</c:otherwise>
		</c:choose>
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
	
	<c:if test="${cBean.totalPage>0}">	
	<tr>
		<td>
		<br/>Page ${cBean.currentPage} of 
		${cBean.totalPage}
		</td>
	</tr>
	</c:if>
	</table>
	
	<%-- Display the back and next links --%>
	<c:if test="${cBean.totalPage>1}">	
	<br/><br/><br/>
	<table align = "left">
	<tr>
		<c:if test="${cBean.currentPage>1}">
		<td>
		<c:choose>
			<c:when test="${startRow>(cBean.rowPerPage-1)}">
			<br/><a href="?start=${startRow-cBean.rowPerPage}">Back</a>
			</c:when>
		<c:otherwise>
			<br/><a href="?start=0">Back</a>
		</c:otherwise>
		</c:choose>
		</td>
		</c:if>
			
		<c:forEach var="pages" begin="1" end="${cBean.totalPage}" step="1" varStatus="num">
			<td><br />
			<a href="?start=${(num.count-1)*cBean.rowPerPage}">${num.count}</a></td>
		</c:forEach>

		<c:if test="${cBean.currentPage lt cBean.totalPage}">
				<td>
					<br/><a href="?start=${cBean.currentRow}">Next</a>
				</td>
		</c:if>
		
	</tr>
	</table>
	</c:if>
	
	<br/><br/><br/>

	<center><br/>
	<a href="PrCAllClientList.jsp?start=0" size=20 target="_blank">Print Report</a>&nbsp;
	<a href="ExCAllClientList.jsp?start=0" size=20 target="_blank">Export Excel</a>
	</center>

	</font>
</body>
</html>
	
