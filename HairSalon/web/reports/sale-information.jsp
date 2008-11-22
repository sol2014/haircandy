<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.persistence.*" %>

<%-- Load the tag library files. --%>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- JSP Directives --%>
<%@ page errorPage="/report-error.jsp?from=sale-information.jsp" %>

<%!
    private String endDatePlus(String input, int num) {
        String newDate = null;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date date = df.parse(input);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            cal.add(Calendar.DATE, num);
            newDate = df.format(cal.getTime());
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return newDate;
    }

    private String getEmptyString(String input) {
        if (input == null) {
            return "";
        } else {
            return input;
        }
    }

    private String getDefaultDate(String input) {
        if (input == null || input.equals("")) {
            return "yyyy-mm-dd";
        } else {
            return input;
        }
    }

    private String getCurrencyFormat(String value) {
        double num = Double.parseDouble(value);
        DecimalFormat dcf = (DecimalFormat) NumberFormat.getCurrencyInstance();
        String formattedValue = dcf.format(num);
        return formattedValue;
    }

    private String trimTimeStamp(String value) {
        return value.substring(0, 11);
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
            Connection conn = null;
            ResultSet rs = null;
            int rsCount = 0;
            StringBuilder sb = null;
            String fName = request.getParameter("FirstName");
            String lName = request.getParameter("LastName");
            String beginDate = request.getParameter("BeginDate");
            String endDate = request.getParameter("EndDate");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale Information Report</title>
    </head>
    
    <script type="text/javascript">
        <!--
        function selectTextField() {
            document.QueryInput.FirstName.focus();
            hideOrDisplay();
        }
        
        function hideOrDisplay()
        {
            if(document.getElementById("DateType").value=="Single")
            {
                document.getElementById("from").style.display = "none";
                document.getElementById("EndDate").style.display = "none";
                document.getElementById("to").style.display = "none";
                document.getElementById("at").style.display = "inline";
            }
            else if(document.getElementById("DateType").value=="Multiple")
            {
                document.getElementById("from").style.display = "inline";
                document.getElementById("EndDate").style.display = "inline";
                document.getElementById("to").style.display = "inline";
                document.getElementById("at").style.display = "none";
            }
        }
        -->
    </script>
    
    <body onLoad=selectTextField()>
        <h3>Sale information report</h3>
        <h4>Date:  <taglib:datetime/> </h4>
       <form name="QueryInput" action="sale-information.jsp">
            Please select one of the following choice of search:
            <br/>
            <%if (request.getParameter("NameType").equals("client")) {%>
            <input type="radio" name="NameType" value="everyone" />Everyone &nbsp;&nbsp;
            <input type="radio" name="NameType" value="client" checked="checked" /> Client &nbsp;&nbsp;
            <input type="radio" name="NameType" value="employee" /> Employee <br/><br/>
            <%} else if (request.getParameter("NameType").equals("employee")) {%>
            <input type="radio" name="NameType" value="everyone" />Everyone &nbsp;&nbsp;
            <input type="radio" name="NameType" value="client" /> Client &nbsp;&nbsp;
            <input type="radio" name="NameType" value="employee" checked="checked" /> Employee <br/><br/>
            <%} else {%>
            <input type="radio" name="NameType" value="everyone" checked="checked" />Everyone &nbsp;&nbsp;
            <input type="radio" name="NameType" value="client" /> Client &nbsp;&nbsp;
            <input type="radio" name="NameType" value="employee" /> Employee <br/><br/>
            <%
                fName = null;
                lName = null;
            }%>
                                
            Please provide the person's first and/or last name <br/>
            if you select search by client or employee:<br/>
            First Name:&nbsp;<input type="text" value="<%=getEmptyString(fName)%>" size=20 name="FirstName" />&nbsp;
            Last Name:&nbsp;<input type="text" value="<%=getEmptyString(lName)%>" size=20 name="LastName" /><br/><br/>
            
            Date Type:&nbsp;
            <select id="DateType" name="DateType" onchange="hideOrDisplay()">
                
            <%if (request.getParameter("DateType").equals("Single")) {%>
                <option value="Multiple" >Multiple</option>
                <option value="Single" SELECTED>Single</option>
            <%}else if (request.getParameter("DateType").equals("Multiple")){%>
                <option value="Multiple" SELECTED>Multiple</option>
                <option value="Single" >Single</option>
            <%}%>
                
            </select>&nbsp;
            <span id="from">From:&nbsp;</span><span id="at">At:&nbsp;</span>
            <input id="BeginDate" type="text" value="<%=getDefaultDate(beginDate)%>" size=15  name="BeginDate" 
                   onclick="select()" />&nbsp;
            <span id="to">To:&nbsp;</span><input id="EndDate" type="text" value="<%=getDefaultDate(endDate)%>" size=15 name="EndDate" 
                                                 onclick="select()" /><br/><br/>
            <%
            if (beginDate == null || beginDate.equals("") || beginDate.equals("yyyy-mm-dd")) {
                beginDate = "1900-01-01";
            }
            if (endDate == null || endDate.equals("") || endDate.equals("yyyy-mm-dd")) {
                endDate = "2100-01-01";
            }
            if (request.getParameter("DateType").equals("Single")) {
                endDate = endDatePlus(beginDate, 1);
            }
            %>
  
            <input type="submit" value="Search" class="StandardButton" >&nbsp;&nbsp;&nbsp;
            <%--
            <input type="button" value="Reset Fields" onclick=""class="StandardButton" >
            --%><br/><br/>
            <div>
                <table border=1 width="700">
                <tr>
                    <td align="center" width="10%"><b>Transaction No</b></td>
                    <td align="center" width="10%"><b>Date</b></td>
                    <td align="center" width="20%"><b>Client Name</b></td>
                    <td align="center" width="20%"><b>Employee Name</b></td>                    
                    <td align="center" width="15%"><b>Payment Due</b></td>
                    <td align="center" width="10%"><b>Sale Tax</b></td>
                    <td align="center" width="15%"><b>Amount Paid</b></td>
                </tr>
            <%
            sb = new StringBuilder();
            sb.append(" SELECT sa.transaction_no, cl.first_name, ");
            sb.append(" cl.last_name, em.first_name, em.last_name, ");
            sb.append(" sa.payment_type, sa.total_due, sa.total_tax, ");
            sb.append(" sa.payment, sa.timestamp ");
            sb.append(" FROM Sale sa, Client cl, Employee em ");
            sb.append(" WHERE sa.client_no = cl.client_no ");
            sb.append(" AND sa.employee_no = em.employee_no ");
          
            if (request.getParameter("NameType").equals("client")) {
                if (!(fName == null) && !(fName.equals(""))) {
                    sb.append(" AND cl.first_name = '" + fName + "' ");
                }
                if (!(lName == null) && !(lName.equals(""))) {
                    sb.append(" AND cl.last_name = '" + lName + "' ");
                }
            } else if (request.getParameter("NameType").equals("employee")) {
                if (!(fName == null) && !(fName.equals(""))) {
                    sb.append(" AND em.first_name = '" + fName + "' ");
                }
                if (!(lName == null) && !(lName.equals(""))) {
                    sb.append(" AND em.last_name = '" + lName + "' ");
                }
            }
            sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
            sb.append(" ORDER BY sa.transaction_no; ");

            try {
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                PreparedStatement ps = conn.prepareStatement(sb.toString());

                int index = 1;  //index for ?
                
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
                index++;
                ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
                index++;
                rs = ps.executeQuery();
              
                while (rs.next()) {
                    rsCount++;
            %>
                    <tr>
                        <td align="center" width="10%">
                            <a href="transaction-details.jsp?id=<%=rs.getString("sa.transaction_no")%>" 
                               size=20 target="_blank"><%=rs.getString("sa.transaction_no")%></a></td>
                        <td align="center" width="10%"><%=trimTimeStamp(rs.getString("sa.timestamp"))%></td>
                        <td align="left" width="20%"><%=rs.getString("cl.first_name")%> <%=rs.getString("cl.last_name")%></td>
                        <td align="left" width="20%"><%=rs.getString("em.first_name")%> <%=rs.getString("em.last_name")%></td>
                        <td align="right" width="15%">
                            <%=getCurrencyFormat(rs.getString("sa.total_due"))%></td>
                        <td align="right" width="10%">
                            <%=getCurrencyFormat(rs.getString("sa.total_tax"))%></td>
                        <td align="right" width="15%">
                            <%=getCurrencyFormat(rs.getString("sa.payment"))%></td>
                    </tr>
            <%}
            } catch (Exception e) {
            } finally {
                if (conn != null) {
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }

                if (rs != null) {
                    rs.close();
                    rs = null;
                }                 
            }
  
            %>
                </table>
            </div><br/>
            <%if(rsCount==0){%>
            There is no result return!  Please try again.<br/>
            <%}else{%>
            There are <%=rsCount%> result(s) in the list.<br/>
            You can click on the transaction number to view the detail.<br/>
            <%}%>
           <br/>
<%
            String params = "?NameType="+request.getParameter("NameType")+
                            "&FirstName="+fName+"&LastName="+lName+
                            "&DateType="+request.getParameter("DateType")+
                            "&BeginDate="+beginDate+"&EndDate="+endDate;

            String excelURL = "sale-information-excel.jsp" + params;
            
            String printURL = "sale-information-print.jsp" + params;
%>
           <div> 
            <input type="button" value="Export Excel" class="StandardButton" 
                   onclick="window.open('<%=excelURL%>', '_blank');return false;" />&nbsp;&nbsp;&nbsp;           
            <input type="button" value="Print this page" class="StandardButton" 
                   onclick="window.open('<%=printURL%>', '_blank');return false;" />&nbsp;&nbsp;&nbsp;
            <input type="button" value="Back to Main" class="StandardButton" 
                   onclick="window.open('report-main-menu.jsp');return false;" /><br/>
            </div>
        </form>  
    
    </body> 
</html>   