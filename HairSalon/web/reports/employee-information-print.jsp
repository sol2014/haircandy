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

<%!
	private String getPhoneNumberFormat(String phone) {
		return "(" + phone.substring(0, 3) + ") " + phone.substring(3, 6)
                        + "-" + phone.substring(6, 10);
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
%>

<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee Information Report</title>
    </head>
    <%--Page Content--%>
    <body>
        <%--Report Header--%>
        <h3>Employee Information Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>

        <div>
            <%--Table column headers.--%>
            <table border=1 width="600">
                <tr>
                    <td align="center" width="10%"><b>Employee Number</b></td>
                    <td align="center" width="20%"><b>First name</b></td>
                    <td align="center" width="20%"><b>Last name</b></td>
                    <td align="center" width="20%"><b>Phone number</b></td>
                    <td align="center" width="20%"><b>Role</b></td>
                </tr>
                <%
                //Initialize variable to store the SQL statement.
		sb = new StringBuilder();
                //Store SQL statement for query.                
		sb.append(" SELECT employee_no, first_name,  ");
		sb.append(" last_name, role, phone_number  ");
		sb.append(" FROM `employee` ");
		sb.append(" ORDER by employee_no; ");

		try {
                    //Create a connection to the database from the connection pool.
                    conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                    //Prepare the statement to query the database.
                    PreparedStatement ps = conn.prepareStatement(sb.toString());
                    rs = ps.executeQuery();  //Execute the query statement.
                    
                    //While there is a row of data from the result set.
                    while (rs.next()) {
                        rsCount++;  //Increment the result set row count.
                %>
                <%--Table row elements.--%>
                <tr>
                     <td align="right" width="10%"><%=rs.getString("employee_no")%></td>
                    <td align="left" width="20%"><%=rs.getString("first_name")%></td>
                    <td align="left" width="20%"><%=rs.getString("last_name")%></td>
                    <td align="left" width="20%"><%=getPhoneNumberFormat(rs.getString("phone_number"))%></td>
                    <td align="left" width="20%"><%=rs.getString("role")%></td>
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
        There is no result return!  Please try again.<br/>
        <%} else {%>
        There are <%=rsCount%> result(s) in the list.<br/>
        <%}%>
        <br/>
        <div>
    </body>
</html>
