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
<%@ page errorPage="/report-error.jsp?from=sale-information-print.jsp" %>

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
    
    <body>
	<form>
	<input type="button" value="Print this page" class="StandardButton" 
		onclick="window.print();return false;" />
		&nbsp;&nbsp;&nbsp;
	<input type="button" value="Close Window " class="StandardButton" 
		onclick="javascript:window.close();" />
	</form><br/>
        
        <h3>Sale information report</h3>
        <h4>Date:  <taglib:datetime/> </h4>
 
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
                rsCount++;
                rs = ps.executeQuery();
                
                while (rs.next()) {
            %>
                    <tr>
                        <td align="center" width="10%">
                            <a href="transaction-details.jsp?id=<%=rs.getString("sa.transaction_no")%>" 
                               size=20 target="_blank"><%=rs.getString("sa.transaction_no")%></a></td>
                        <td align="center" width="10%"><%=trimTimeStamp(rs.getString("sa.timestamp"))%></td>
                        <td align="left" width="25%"><%=rs.getString("cl.first_name")%> <%=rs.getString("cl.last_name")%></td>
                        <td align="left" width="25%"><%=rs.getString("em.first_name")%> <%=rs.getString("em.last_name")%></td>
                        <td align="right" width="10%"><taglib:FormatTag format="currency">
                            <%=rs.getString("sa.total_due")%></taglib:FormatTag></td>
                        <td align="right" width="10%"><taglib:FormatTag format="currency">
                            <%=rs.getString("sa.total_tax")%></taglib:FormatTag></td>
                        <td align="right" width="10%"><taglib:FormatTag format="currency">
                            <%=rs.getString("sa.payment")%></taglib:FormatTag></td>
                    </tr>
                    <%rsCount++;}

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
            There is no result return!<br/>
            <%}else{%>
            There are <%=rsCount%> result(s) in the list.<br/>
            <%}%>
           <br/>    
    </body> 
</html>   