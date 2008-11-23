<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%-- Setup page content type and import java libraries. --%>
<%@page contentType="application/vnd.ms-excel" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.persistence.*" %>

<%-- Load the tag library files. --%>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- JSP Directives --%>
<%@ page errorPage="/reports/report-error.jsp?from=sale-information-excel.jsp" %>

<%!
    /**
     * This class increment the end date from the begin date by number of
     * date specified by the user.
     *
     * @param input a string for the date value to be increment.
     * @param num an integer of number of date to be increment.
     * @return the incremented date.
     */
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

    /**
     * This class return a blank string if the string input is null.
     *
     * @param input a string of input value to be check.
     * @return the modify input value if necessary.
     */
    private String getEmptyString(String input) {
        if (input == null) {
            return "";
        } else {
            return input;
        }
    }

    /**
     * This class initialize the date string if it is null or blank.
     *
     * @param input a string for the date value to be check.
     * @return the modify date string if necessary.
     */
    private String getDefaultDate(String input) {
        if (input == null || input.equals("")) {
            return "yyyy-mm-dd";
        } else {
            return input;
        }
    }

    /**
     * This class modify the string value to a currency string value.
     *
     * @param input a string value to be modified to a currency string value.
     * @return the modified value.
     */
    private String getCurrencyFormat(String value) {
        double num = Double.parseDouble(value);
        DecimalFormat dcf = (DecimalFormat) NumberFormat.getCurrencyInstance();
        String formattedValue = dcf.format(num);
        return formattedValue;
    }

    /**
     * This class trims the time stamp value and return the date portion only.
     *
     * @param input a string time stamp value to be trimmed.
     * @return the modified value.
     */
    private String trimTimeStamp(String value) {
        return value.substring(0, 11);
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
            //Define Available
            Connection conn = null;     //SQL connector var.
            ResultSet rs = null;        //SQL result set var.
            int rsCount = 0;            //Result set row count.
            StringBuilder sb = null;    //String builder for SQL statement.

            //Helper Variables for parameter values.
            String fName = request.getParameter("FirstName");
            String lName = request.getParameter("LastName");
            String beginDate = request.getParameter("BeginDate");
            String endDate = request.getParameter("EndDate");
%>
<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale Information Report</title>
    </head>
    
    <%--Page Content--%>
    <body>
        <%--Report Header--%>
        <h3>Sale information report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        
        <%
            //Initial a filename.
            String filename = "export_sale_data.xls";
            //Setup the proper filename to be export.
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);

            //Modify begin date variable if no user input.
            if (beginDate == null || beginDate.equals("") || beginDate.equals("yyyy-mm-dd")) {
                beginDate = "1900-01-01";
            }
            //Modify end date variable if no user input.
            if (endDate == null || endDate.equals("") || endDate.equals("yyyy-mm-dd")) {
                endDate = "2100-01-01";
            }
            //Modify end date variable if user select a single date to query.
            if (request.getParameter("DateType").equals("Single")) {
                endDate = endDatePlus(beginDate, 1);
            }
        %>
        
        <div>
            <%--Table column headers.--%>
            <table border=1 width="700">
                <tr>
                    <td align="center" width="10%"><b>Transaction No</b></td>
                    <td align="center" width="10%"><b>Date</b></td>
                    <td align="center" width="25%"><b>Client Name</b></td>
                    <td align="center" width="25%"><b>Employee Name</b></td>                    
                    <td align="center" width="10%"><b>Payment Due</b></td>
                    <td align="center" width="10%"><b>Sale Tax</b></td>
                    <td align="center" width="10%"><b>Amount Paid</b></td>
                </tr>
                <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT sa.transaction_no, cl.first_name, ");
            sb.append(" cl.last_name, em.first_name, em.last_name, ");
            sb.append(" sa.payment_type, sa.total_due, sa.total_tax, ");
            sb.append(" sa.payment, sa.timestamp ");
            sb.append(" FROM Sale sa, Client cl, Employee em ");
            sb.append(" WHERE sa.client_no = cl.client_no ");
            sb.append(" AND sa.employee_no = em.employee_no ");

            //Insert SQL statement for search with client name.
            if (request.getParameter("NameType").equals("client")) {
                if (!(fName == null) && !(fName.equals(""))) {
                    sb.append(" AND cl.first_name = '" + fName + "' ");
                }
                if (!(lName == null) && !(lName.equals(""))) {
                    sb.append(" AND cl.last_name = '" + lName + "' ");
                }
            }//Insert SQL statement for search with employee name.
            else if (request.getParameter("NameType").equals("employee")) {
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
                //Create a connection to the database from the connection pool.
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());

                int index = 1;  //index for ? search field.

                //Create a time format for date object.
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
                index++;   //Increment to the next ? location
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
                index++;  //Increment to the next ? location
                rs = ps.executeQuery();  //Execute the query statement.

                //While there is a row of data from the result set.                              
                while (rs.next()) {
                    rsCount++;  //Increment the result set row count.
                %>
                <%--Table row elements.--%>
                <tr>
                    <td align="center" width="10%">
                        <a href="transaction-details.jsp?id=<%=rs.getString("sa.transaction_no")%>" 
                       size=20 target="_blank">
                       <%=rs.getString("sa.transaction_no")%></a></td>
                    <td align="center" width="10%">
                        <%=trimTimeStamp(rs.getString("sa.timestamp"))%></td>
                    <td align="left" width="25%">
                        <%=rs.getString("cl.first_name")%>&nbsp;
                        <%=rs.getString("cl.last_name")%></td>
                    <td align="left" width="25%">
                        <%=rs.getString("em.first_name")%>&nbsp;
                        <%=rs.getString("em.last_name")%></td>
                    <td align="right" width="10%">
                        <taglib:FormatTag format="currency">
                    <%=rs.getString("sa.total_due")%></taglib:FormatTag></td>
                    <td align="right" width="10%">
                        <taglib:FormatTag format="currency">
                    <%=rs.getString("sa.total_tax")%></taglib:FormatTag></td>
                    <td align="right" width="10%">
                        <taglib:FormatTag format="currency">
                    <%=rs.getString("sa.payment")%></taglib:FormatTag></td>
                </tr>
                <%}
            } catch (Exception e) {
            } finally {
                if (conn != null) {
                    //Return connection to the connection pool.
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }
                //Close and result the result set storage variable.
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            }
                %>
            </table>
        </div><br/>
        <%--Display the row count result.--%>
        <%if (rsCount == 0) {%>
        There is no result return!<br/>
        <%} else {%>
        There are <%=rsCount%> result(s) in the list.<br/>
        <%}%>
        <br/>    
    </body> 
</html>   