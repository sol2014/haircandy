<%-- JSP Directives --%>
<%@ page errorPage="defaultError.jsp?from=ClientRepMenu.jsp" %>

<%-- Load the  tag library files. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="taglib" uri="../WEB-INF/taglib.tld"%>

<jsp:useBean id="sBean" scope="session"
		class="hs.objects.SupplierBean" />
		
<jsp:useBean id="pBean" scope="session"
		class="hs.objects.ProductBean" />

<%-- Import Libraries --%>
<%@page import="java.util.*" %>

<html>
<head>
	<title>Client Report Menu</title>
	<jsp:include page="jsp/subHeader.jsp" />
	<jsp:include page="jsp/subCHeader.jsp" />
</head>
</html>