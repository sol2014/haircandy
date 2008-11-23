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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.persistence.*" %>

<%-- Load the tag library files. --%>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- JSP Directives --%>
<%@ page errorPage="/reports/report-error.jsp?from=service-usage.jsp" %>

<%!
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
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
            //Define variables
            Connection conn = null;     //SQL connector var.
            Connection conn2 = null;     //SQL connector var.
            ResultSet rs = null;        //SQL result set var.
            ResultSet rs2 = null;       //SQL result set var.
            StringBuilder sb = null;    //String builder for SQL statement.
            StringBuilder sb2 = null;   //String builder for SQL statement.
            int rsCount = 0;            //Result set row count.

            //Helper Variables for parameter value. 
            String serviceNo = request.getParameter("ServiceNo");
            String beginDate = request.getParameter("BeginDate");
            String endDate = request.getParameter("EndDate");
%>

<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Service Usage Report</title>
    </head>
    
    <%--Javasript Functions.--%>
    <script type="text/javascript">
        <!--      
        /*
         *  This function to have the cursor start at the supplier name
         *  drop down box when called, Then call the hide or display function.
         **/
        function selectTextField() {
            document.QueryInput.ServiceNo.focus();
        }

        -->
    </script>
    
    <%--Page Content--%>
    <%--Calls javascript function to do the initial setup of the page.--%>
    <body onLoad=selectTextField()>
        <%--Report Header--%>
        <h3>Service Usage Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4> 
        
        <form name="QueryInput" action="service-usage.jsp">
            <%
            //Initialize service number.
            if (serviceNo == null) {
                serviceNo = "0";
            }
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT *  ");
            sb.append(" FROM service se ");
            sb.append(" WHERE se.enabled = true ");
            sb.append(" ORDER BY se.service_no; ");
            %>
            <div>
                <%--Drop down box to collect the product number for query the 
                report. Javascript function called to select the proper 
                option, default selection is 0. --%>                
                Select Service:&nbsp;
                <select name="ServiceNo">
                    <option value="0" >All</option>
                    <%
            try {
                //Create a connection to the database from the connection pool.
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                rs = ps.executeQuery();  //Execute the query statement.

                //Build the drop down list with the result set values.
                while (rs.next()) {
                    //Check if the product is previously selected.
                    if (rs.getString("service_no").equals(serviceNo)) {
                    %>
                    <option value="<%=rs.getInt("service_no")%>"  
                            selected><%=rs.getString("name")%></option>
                    <%	} else {%>
                    <option value="<%=rs.getInt("service_no")%>">
                    <%=rs.getString("name")%> </option>
                    <%
                    }
                }
            } catch (Exception e) {
            } finally {

                if (conn != null) {
                    //Return connection to the connection pool.
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }
                if (rs != null) {
                    //Close and result the result set storage variable.
                    rs.close();
                    rs = null;
                }
            }
                    %>
            </select><br/><br/>
            Date range (yyyy-mm-dd to yyyy-mm-dd): <br/>
            From:&nbsp;<input type="text" value="<%=getEmptyString(beginDate)%>"
                              size=15 name="BeginDate">
            To:&nbsp;<input type="text" value="<%=getEmptyString(endDate)%>" 
                            size=15 name="EndDate">&nbsp;&nbsp;
                <%
            //Reload the date value to the variable.
            beginDate = request.getParameter("BeginDate");
            endDate = request.getParameter("EndDate");
            
            //Modify begin date variable if no user input.    
            if (beginDate == null || beginDate.equals("")) {
                beginDate = "1900-01-01";
            }
            //Modify end date variable if no user input.
            if (endDate == null || endDate.equals("")) {
                endDate = "2100-01-01";
            }
                %>
            <br/><br/><input type="submit" value="Search">
            </div>
            <div><br/>
            <%--Table column headers.--%>
            <table border=1 width="700">
                <tr>
                    <td align="center" width="30%"><b>Service Name</b></td>
                    <td align="center" width="30%"><b>Description</b></td>
                    <td align="center" width="10%"><b>Duration</b></td>
                    <td align="center" width="15%"><b>Price</b></td>
                    <td align="center" width="15%"><b>Total Usage</b></td>  
                </tr>                                    
                    <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT DISTINCT sa.timestamp, se.service_no, se.name,");
            sb.append("  se.description, se.duration, se.price  ");
            sb.append(" FROM sale sa, saleservice ss, service se  ");
            sb.append(" WHERE se.service_no = ss.service_no ");
            //If an individual service is chosen, execute the statement.
            if ((!serviceNo.equals("")) && (serviceNo != null) && (!serviceNo.equals("0")))
            {
                   sb.append(" AND se.service_no = ? ");
            }
            sb.append(" AND ss.transaction_no = sa.transaction_no ");
            sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
            sb.append(" ORDER BY sa.timestamp; ");

            try {
                //Create a connection to the database from the connection pool.
                conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn2.prepareStatement(sb.toString());
                int index = 1;  //index for ? search field.
                //Insert the product number to the query statement.
                 if ((!serviceNo.equals("")) && (serviceNo != null) && (!serviceNo.equals("0"))){
                    ps.setInt(index, Integer.parseInt(serviceNo));
                    index++;
                }
                 //Create a time format for date object.               
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
                index++;    //Increment to the next ? location
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
                index++;  //Increment to the next ? location
                rs = ps.executeQuery(); //Execute the query statement.
                
                //While there is a row of data from the result set.
                while (rs.next()) {
                    rsCount++;
                    %>
                    <tr>
                        <td align="left" width="30%"><%=rs.getString("name")%></td>
                        <td align="left" width="30%"><%=rs.getString("description")%></td>
                        <td align="right" width="10%"><%=rs.getString("duration")%></td>
                        <td align="right" width="15%"><taglib:FormatTag format="currency">
                        <%=rs.getString("price")%></taglib:FormatTag></td>
                        <%
                    //Initialize variable to store the SQL statement.
                    sb2 = new StringBuilder();
                    //Store SQL statement for query.
                    sb2.append(" SELECT COALESCE(SUM(ss.amount), 0) \"Total\" ");
                    sb2.append(" FROM sale sa, saleservice ss, service se ");
                    sb2.append(" WHERE se.service_no = ss.service_no ");
                    sb2.append(" AND se.service_no = " + rs.getInt("service_no"));
                    sb2.append(" AND ss.transaction_no = sa.transaction_no ");
                    sb2.append(" AND sa.timestamp BETWEEN ? AND ?; ");
                        
                    try {
                        //Create a connection to the database from the connection pool.
                        conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                        //Prepare the statement to query the database.
                        PreparedStatement ps2 = conn2.prepareStatement(sb2.toString());
                        int index2 = 1; //index for ? search field.
                    
                        //Create a time format for date object.
                        SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
                        //set time stamp for begin date search field.
                        ps2.setTimestamp(index2, new Timestamp((df2.parse(beginDate)).getTime()));
                        index2++;  //Increment to the next ? location
                        //set time stamp for begin date search field.
                        ps2.setTimestamp(index2, new Timestamp((df2.parse(endDate)).getTime()));
                        index2++;  //Increment to the next ? location
                        rs2 = ps2.executeQuery(); //Execute the query statement.
                        //Return a total of the product sold.
                        if (rs2.next()) {
                        %>
                        <td align="right" width="15%"><%=rs2.getString("Total")%></td>
                        <%
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    } finally {
                        if (conn2 != null) {
                            //Return connection to the connection pool.
                            MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn2);
                        }
                        if (rs2 != null) {
                            //Close and result the result set storage variable.
                            rs2.close();
                            rs2 = null;
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            } finally {
                if (conn != null) {
                    //Return connection to the connection pool.
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }
                if (rs != null) {
                    //Close and result the result set storage variable.
                    rs.close();
                    rs = null;
                }
            }
                        %>
                    </tr>
                </table>
            </div>
            <%--Display the row count result.--%>
            <%if (rsCount == 0) {%>
            There is no result return!<br/>
            <%} else {%>
            There are <%=rsCount%> result(s) in the list.<br/>
            <%}%>
            <br/>
            <%
            //Set the URL link parameters for the input buttons.
            String params = "?ServiceNo="+serviceNo+
                    "&BeginDate=" + beginDate + "&EndDate=" + endDate;
            //Set the URL page name for the export excel input buttons.  
            String excelURL = "service-usage-excel.jsp" + params;
            //Set the URL page name for the print report input buttons.   
            String printURL = "service-usage-print.jsp" + params;

            //Re-initialize the begin date value.
            if (beginDate.equals("1900-01-01")) {
                beginDate = "";
            }
            //Re-initialize the end date value.
            if (endDate.equals("2100-01-01")) {
                endDate = "";
            }
            %>
            <%--Input buttons for additional report commends.--%>
            <div>
                <%--Input button for export report to an excel file.--%>
                <input type="button" value="Export Excel" class="StandardButton" 
                       onclick="window.open('<%=excelURL%>', '_blank');return false;" />
                &nbsp;&nbsp;&nbsp;           
                <%--Input button to send the report a printer.--%>
                <input type="button" value="Print this page" class="StandardButton" 
                       onclick="window.open('<%=printURL%>', '_blank');return false;" />
                &nbsp;&nbsp;&nbsp;
                <%--Input button return user to the report main menu.--%>
                <input type="button" value="Back to Main" class="StandardButton" 
                       onclick="window.open('report-main-menu.jsp');return false;" />
                <br/>
            </div> 
        </form>
    </body>
</html>

