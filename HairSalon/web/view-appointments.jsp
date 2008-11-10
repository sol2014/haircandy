<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.presentation.tags.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
   
<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <div align="left" id="matrix"></div>
</font>


<%@ include file="dialogs/appointment-dialog.jsp" %>

<%@ include file="WEB-INF/jspf/footer.jspf" %>

<script language="javascript" src="js/appointment.js"></script>
<script language="javascript" src="js/appointment-addin.js"></script>

<script>
    function getMatrix()
    {
        function fillMatrix(content)
        {
            document.getElementById("matrix").innerHTML = "";
            setInnerHTML(document.getElementById("matrix"),content);
        }
        var messager = new Ajaxer("text",null,fillMatrix,null);
        var queryString="date=<%=request.getParameter("date")%>";
        messager.request("ajax/ajax-app-scheduler.jsp",queryString);
    }
    getMatrix();
</script>

<script>disableSelection(document.body)</script>

<script>
    function repeat()
    {
        window.setTimeout(repeat, 10000, "JavaScript");
        getMatrix();
    }
</script>
<script>//window.setTimeout(repeat, 10000, "JavaScript");</script>