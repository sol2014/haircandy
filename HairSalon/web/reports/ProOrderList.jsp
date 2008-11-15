<%-- JSP Directives --%>
<%@ page errorPage="/defaultError.jsp?from=ProOrderList.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<jsp:useBean id="sBean" scope="session"
		class="hs.objects.ReOrderListBean" />

<html>
	<head>
		<title>Product Report List</title>
		<jsp:include page="/reportJsp/subHeader.jsp" />
		<jsp:include page="/reportJsp/subPHeader.jsp" />
	</head>
	
	<body>
		<select name="supplier">
			
		</select>
	</body>
</html>