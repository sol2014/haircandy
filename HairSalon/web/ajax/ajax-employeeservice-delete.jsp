<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.core.*" %>
<%@ page import="java.util.*" %>

<% ArrayList<ServiceBean> searchResults = (ArrayList<ServiceBean>) request.getAttribute("searchResults");%>

<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
    <tr align="left">
        <% if (searchResults != null && searchResults.size() > 0) {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Provided Services (<%=searchResults.size()%>)</font></b></td>
        <% } else {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Provided Services (None)</font></b></td>
        <% }%>
    </tr>
    <tr>
        <td>
            <table width="100%" cellspacing="1" cellpadding="4" border="0">
                <% if (searchResults == null || searchResults.size() < 1) {%>
                <tr align="right" valign="middle">
                    <td colspan="3" align="left" class="Row2"><b>There are no services provided by this employee.</b></td>
                </tr>
                <% } else {%>
                <tr align="right">
                    <td nowrap="nowrap" class="Row1"></td>
                    <td width="100%" nowrap="nowrap" align="left" class="Row1"><b>Name</b></td>
		    <td nowrap="nowrap" class="Row1"><b>Duration</b></td>
		    <td nowrap="nowrap" class="Row1"><b>Price</b></td>
                    <td nowrap="nowrap" class="Row1"></td>
                </tr>
                
                <% for (ServiceBean service : searchResults) {%>
                <tr align="right" valign="middle">
                    <td valign="top" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/service_white.gif" width="16" height="16" />&nbsp;</td>
                    <td align="left" valign="top" class="Row2"><span class="SearchLink"><a href="service?service_action=Load&service_no=<%= service.getServiceNo()%>" class="SearchLink"><%=ServletHelper.display(service.getName())%></a></span></td>
		    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.display(service.getDuration ())%>min</td>
		    <td nowrap="nowrap" valign="top" class="Row7"><%=ServletHelper.displayPrice (service.getPrice ())%></td>
                    <td nowrap="nowrap" valign="top" class="Row7"><img style="cursor:pointer" src="images/icons/small/remove_white.gif" onclick="deleteService('<%=ServletHelper.display(service.getServiceNo())%>')" title="Delete this service from the list." /></td>
                </tr>
                <% }%>
                <% }%>
            </table>
        </td>
    </tr>
</table>
<br />
<div align="right"><input type="button" onclick="showAddService()" value="Add Service" class="StandardButton"/></div>