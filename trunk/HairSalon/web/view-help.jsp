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
<%@taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
  
<%-- Retrieve the UserSession object from the http session. --%>
<%
UserSession userSession = (UserSession) session.getAttribute ("user_session");
int recordNo = 0;
%>

<%-- Set the next page position for navigator. --%>
<% userSession.setCurrentPosition (SessionPositions.Help);%>

<%-- Set the title of the page. --%>
<% String page_title = "Help"; %>

<%-- Use the pre-set header file. --%>
<%@ include file="WEB-INF/jspf/header.jspf" %>

<font face="Trebuchet MS" size="2">
    <form method="POST" action="salon">
	<table align="left" border="0" cellspacing="5" cellpadding="0">
	    <tr>
		<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/help_white.gif" width="48" height="48"></td>
		<td align="left"><font size="3"><b>User Documentation</b></font><br>
		    Here will be the user docs ;)
		    <br><br>
		</td>
	    </tr>
	</table>
    </form>
</font>

<%@ include file="WEB-INF/jspf/footer.jspf" %>
