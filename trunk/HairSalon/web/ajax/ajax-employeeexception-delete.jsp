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
<%@ page import="java.text.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />

<%
            ArrayList<AvailabilityExceptionBean> searchResults = new ArrayList<AvailabilityExceptionBean>();
            String[] dates = request.getParameterValues("date");
            String[] reasons = request.getParameterValues("reason");
            
            if (dates != null) {
                for (int i = 0; i < dates.length; i++) {
                    AvailabilityExceptionBean avb = new AvailabilityExceptionBean();
                    try {
                        avb.setDate(CoreTools.getDate (dates[i]));
                    } catch (Exception e) {
                    }
                    try {
                        avb.setReason(reasons[i]);
                    } catch (Exception e) {
                    }
                    searchResults.add(avb);
                }
            }
%>

<table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
    <tr align="left">
        <% if (searchResults != null && searchResults.size() > 0) {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Availability Exceptions (<%=searchResults.size()%>)</font></b></td>
        <% } else {%>
        <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Availability Exceptions (None)</font></b></td>
        <% }%>
    </tr>
    <tr>
        <td>
            <table width="100%" cellspacing="1" cellpadding="4" border="0">
                <% if (searchResults == null || searchResults.size() < 1) {%>
                <tr align="right" valign="middle">
                    <td colspan="3" align="left" class="Row2"><b>There are no availability exceptions for this employee.</b></td>
                </tr>
                <% } else {%>
                <tr align="right">
                    <td height="20" nowrap="nowrap" class="Row1"></td>
                    <td nowrap="nowrap" align="left" class="Row1"><b>Exception Date</b></td>
                    <td width="100%" align="left" nowrap="nowrap" class="Row1"><b>Reason</b></td>
		    <td nowrap="nowrap" class="Row1"></td>
                </tr>
                
                <% for (AvailabilityExceptionBean e : searchResults) {%>
                <tr align="right" valign="middle">
                    <td height="30" class="Row7" nowrap="nowrap">&nbsp;<img src="/HairSalon/images/icons/small/exception_white.gif" width="16" height="16" />&nbsp;</td>
                    <td align="left" class="Row2"><span class="SearchLink"><%=ServletHelper.display(e.getDate())%></span></td>
                    <td align="left" nowrap="nowrap" class="Row7"><%=ServletHelper.display(e.getReason ())%></td>
		    <td nowrap="nowrap" class="Row7"><img style="cursor:pointer" src="/HairSalon/images/icons/small/remove_white.gif" onclick="deleteException('<%=ServletHelper.display(e.getDate())%>','<%=ServletHelper.display(e.getReason())%>')" title="Delete this availability exception from the list." /></td>
                </tr>
                <% }%>
                <% }%>
            </table>
        </td>
    </tr>
</table>
<br />
<div align="right"><input type="button" onclick="showAddException()" value="Add Exception" class="StandardButton"/></div>