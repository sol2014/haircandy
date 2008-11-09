<%-- 
    Document   : excel.jsp
    Created on : 24-Oct-2008, 7:47:36 AM
    Author     : 353448
--%>

*_JSP Code_</strong<br />
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/struts-tiles" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-html" prefix="html" %>
<%@ taglib uri="/WEB-INF/connect" prefix="connect" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@page import="connect.app.util.Constants"%>
<%@page import="connect.app.util.ConnectConstant"%>

<style type="text/css">
<%--
<jsp:include page="/css/Report.css" />
--%>
</style>


<% String typeOfReport = (String)request.getParameter("typeOfReport");%>
<bean:define id="reportObj" name="dashBoardReportData" type="com.pwc.global.connect.app.vo.ReportVO" scope="request"/>
<bean:define id="entityMap" name="reportObj" property="entityMap" scope="page" type="Map" toScope="page"/>
<bean:define id="reportType" name="reportObj" property="reportType" scope="page" type="String" toScope="page"/>
<bean:define id="REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY" value="<%=Constants.REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY%>"/>
<bean:define id="REPORT_TYPE_MONTHLY_SUMMARY_TERRITORY" value="<%=Constants.REPORT_TYPE_MONTHLY_SUMMARY_TERRITORY%>"/>
<bean:define id="REPORT_TYPE_MONTHLY_SUMMARY_GLOBAL" value="<%=Constants.REPORT_TYPE_MONTHLY_SUMMARY_GLOBAL%>"/>
<bean:define id="REPORT_TYPE_WEEKLY_DASHBOARD_TERRITORY" value="<%=Constants.REPORT_TYPE_WEEKLY_DASHBOARD_TERRITORY%>"/>
<bean:define id="REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY" value="<%=Constants.REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY%>"/>
<bean:define id="REPORT_TYPE_BULLING_SUMMARY_INDIA" value="<%=Constants.REPORT_TYPE_BILLING_SUMMARY_INDIA%>"/>
<bean:define id="HEADCOUNT_BY_SERVICE_TEAM" value="<%=ConnectConstant.HEADCOUNT_BY_SERVICE_TEAM%>"/>
<bean:define id="REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY" value="<%=Constants.REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY%>"/>
<%
String tableWidth = "100%";
int noOfCol = reportObj.getNoOfColumn();
String colSpan = "4";
if (reportObj.getReportType().equals(Constants.REPORT_TYPE_MONTHLY_DASHBOARD_GLOBAL) || reportObj.getReportType().equals(Constants.REPORT_TYPE_MONTHLY_DASHBOARD_TERRITORY) || reportObj.getReportType().equals(Constants.REPORT_TYPE_WEEKLY_DASHBOARD_TERRITORY)) {
colSpan = "4";
} else if (reportObj.getReportType().equals(Constants.REPORT_TYPE_MONTHLY_SUMMARY_GLOBAL) || reportObj.getReportType().equals(Constants.REPORT_TYPE_MONTHLY_SUMMARY_TERRITORY)) {
colSpan = "14";
} else if (reportObj.getReportType().equals(Constants.REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY)) {
colSpan = noOfCol + 2 +"";
} else if (reportObj.getReportType().equals(Constants.REPORT_TYPE_BILLING_SUMMARY_INDIA)) {
colSpan = "3";
}
%>

<html:form action="reports" method="post" >
<p class="headerText" >
<bean:write name="reportObj" property="title"/>
</p>

<p> </p>
<logic:notPresent scope="request" parameter="export_type">

<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
<td align="right">
<a href="#" onclick="altSubmit(contextPath,'reports.do?method=excelReport&typeOfReport=<%=typeOfReport%>')" >
<html:image src="images/iconExcel.gif"/>
</a>
</td>
</tr>
</table>
</logic:notPresent>
<table width="100%" border="0" width="<%=tableWidth%>" cellspacing="0" cellpadding="0">
<tr>
<c:if test="${reportType == REPORT_TYPE_MONTHLY_SUMMARY_GLOBAL || reportType == REPORT_TYPE_MONTHLY_SUMMARY_TERRITORY || reportType == REPORT_TYPE_WEEKLY_DASHBOARD_TERRITORY}">
<td width="30%"> </td>
<td width="5%" class=tableheadersmallCenterAlign><bean:message key="dashBoardSummary.jan"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.feb"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.mar"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.apr"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.may"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.jun"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.jul"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.aug"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.sep"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.oct"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.nov"/></td>
<td width="5%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.dec"/></td>
<td width="10%" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.ytd08"/></td>
</c:if>
<c:if test="${reportType == REPORT_TYPE_WEEKLY_SUMMARY_TERRITORY}">
<td width="300"> </td>
<% for(int n=1; n<=noOfCol; n++ ) {%>
<td width="100" class=tableheadersmallCenterAlign>
<bean:message key="dashBoardSummary.week"/><%=n%>
</td>
<% } %>
<td width="100" class="tableheadersmallCenterAlign"><bean:message key="dashBoardSummary.ytd08"/></td>
</c:if>
<c:if test="${reportType == REPORT_TYPE_BULLING_SUMMARY_INDIA}">
<td width="80%" class="firstTableHeader"> </td>
<td width="10%" class="tableHeader"><bean:message key="dashBoardSummary.headCount"/></td>
<td width="10%" class="tableHeader"><bean:message key="dashBoardSummary.amount"/></td>
</c:if>
</tr>
<c:if test="${reportType != REPORT_TYPE_BULLING_SUMMARY_INDIA}">
<tr>
<td width="100%" colspan="<%=colSpan%>" class="tableHeaderLeftAlign">
<bean:message key="dashBoardSummary.resources"/>
</td>
</tr>
<%
Map resourcesMap = null;
if (entityMap != null) {
resourcesMap = (Map)entityMap.get(ConnectConstant.RESOURCE);
}
%>
<connect:dashBoardElement property="<%=resourcesMap%>" key="HEADCOUNT_BY_SERVICE_TEAM" styleClassEven="evenRow" styleClassOdd="oddRow" styleClassFirstLevelText="normalTextBold" styleClassFirstEvenCell="firstevenRow" styleClassFirstOddCell="firstoddRow" rowCounter="RowCounter" multiLevel="true" numberFormat="#0" reportType="Summary-Detail"/>
<tr>
<td colspan="<%=colSpan%>" >

</td>
</tr>
<tr>
<td colspan="<%=colSpan%>" class="tableHeaderLeftAlign"><bean:message key="dashBoardSummary.volume"/></td>
</tr>
<tr>
<td colspan="<%=colSpan%>">

</td>
</tr>
<tr>
<td colspan="<%=colSpan%>" class="tableHeaderLeftAlign"><bean:message key="dashBoardSummary.productivity"/></td>
</tr>
<tr>
<td colspan="<%=colSpan%>">

</td>
</tr>
<tr>
<td colspan="<%=colSpan%>" class="tableHeaderLeftAlign"><bean:message key="dashBoardSummary.quality"/></td>
</tr>
</c:if>
<c:if test="${reportType == REPORT_TYPE_BULLING_SUMMARY_INDIA}">
<%
Map levelMap = null;
if (entityMap != null) {
levelMap = (Map)entityMap.get(ConnectConstant.BY_LEVEL);
}%>
<% if (levelMap != null) {
%>
<connect:dashBoardElement property="<%=levelMap%>" key="<%=ConnectConstant.BY_LEVEL%>" styleClassEven="evenRow" styleClassOdd="oddRow" styleClassFirstLevelText="normalTextBold" styleClassFirstEvenCell="firstevenRow" styleClassFirstOddCell="firstoddRow" rowCounter="RowCounter" multiLevel="true" reportType="BillingSummary-India"/>
<% } %>
</c:if>
</table>

<p> </p>
<p>
<html:button property="back" styleClass="buttons" onclick="altSubmit(contextPath,'reports.do?method=reports')">
<bean:message key="dashBoard.back.button" />
</html:button>
</p>
</html:form>
<p> </p>