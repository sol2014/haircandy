<%-- 
    Document   : SampleReport
    Created on : 27-Oct-2008, 9:33:06 AM
    Author     : 353448
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="java.util.*" %>

<%@ page import="hairsalon.application.*"%>
<%@ page import="hairsalon.core.*"%>
<%@ page import="hairsalon.objects.*"%>
<%@ page import="hairsalon.presentation.*"%>
<%@ page import="hairsalon.persistence.*"%>

<%
    String typeOfReport = (String)request.getParameter("typeOfReport");
    int numOfCol = Integer.parseInt(request.getParameter("numOfCol"));
%>

<style type="text/css">
    <%--
<jsp:include page="/css/Report.css" />
    --%>
</style>

<html>
    <head>
        <title>Sample Report</title>
    </head>
    <body>
        <jsp:useBean id="productBean" class="hairsalon.object.ProductBean" />
        
        <center>
            <h1>Sample Product Report</h1>
            <br /><br />
            <table cellpadding="<%=numOfCol%>">
                <tr>
                    <th>
                </tr>
                
                
                
                <tr>
                    <jsp:getProperty name="productBean" property="name" />
                </tr>
            </table>
        </center>
    </body>
</html>
