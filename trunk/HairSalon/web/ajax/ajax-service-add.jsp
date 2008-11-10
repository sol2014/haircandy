<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.core.*" %>
<%@page import="hs.app.*" %>
<%@ page import="java.util.*" %>

<% 
ArrayList<ServiceBean> searchResults = (ArrayList<ServiceBean>) request.getAttribute("searchResults");%>

<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
    <tr align="left">
        <% if (searchResults != null && searchResults.size() > 0) {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (<%=searchResults.size()%>)</font></b></td>
        <% } else {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
        <% }%>
    </tr>
    <tr>
        <td>
            <table width="100%" cellspacing="1" cellpadding="4" border="0">
                <% if (searchResults == null || searchResults.size() < 1) { %>
                <tr align="right" valign="middle">
                    <td colspan="3" align="left" class="Row2"><b>The search generated no results.</b></td>
                </tr>
                <% } else { %>
                <tr align="right">
                    <td height="20" nowrap="nowrap" class="Row1"></td>
                    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
		    <td nowrap="nowrap" class="Row1">Duration</td>
		    <td nowrap="nowrap" class="Row1">Price</td>
                    <td nowrap="nowrap" class="Row1"></td>
                </tr>
                
		    <% for (ServiceBean service : searchResults) {%>
		    <tr align="right" valign="middle">
			<td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/result.gif" width="16" height="16" />&nbsp;</td>
			<td align="left" class="Row2"><%=CoreTools.display(service.getName())%></td>
			<td nowrap="nowrap" class="Row7"><%=CoreTools.display (service.getDuration())%>m</td>
			<td nowrap="nowrap" class="Row7"><%=CoreTools.displayPrice (service.getPrice ())%></td>
			<td nowrap="nowrap" class="Row7"><img style="cursor:pointer" src="images/icons/small/add_white.gif" onclick="addService('<%=CoreTools.display(service.getServiceNo())%>','<%=CoreTools.display(service.getName())%>','<%=CoreTools.display(service.getPrice())%>')" title="Add the service to the list." /></td>
		    </tr>
		    <% }%>
                <% }%>
            </table>
        </td>
    </tr>
</table>