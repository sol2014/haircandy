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
<%@ page errorPage="/reports/report-error.jsp?from=employee-details.jsp" %>

<%!
    /**
     * This class modify the string value to a phone number format.
     *
     * @param input a string value to be modified to a phone number format.
     * @return the modified value.
     */
    private String getPhoneNumberFormat(String phone) {
        return "(" + phone.substring(0, 3) + ") " + phone.substring(3, 6) +
                "-" + phone.substring(6, 10);
    }

    /**
     * This class modifies the address string if it is null or blank.
     *
     * @param input a string for address to be modified.
     * @return the modified value.
     */
    private String getNotAvailable(String input) {
        if ((input == null) || (input.equals(""))) {
            return "Not Available";
        } else {
            return input;
        }
    }

    /**
     * This class modify the string value to a postal code format.
     *
     * @param input a string value to be modified to a postal code format.
     * @return the modified value.
     */
    private String getPostalCodeFormat(String postCode) {
        return postCode.substring(0, 3) + "-" + postCode.substring(3, 6);
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

            //Define Helper Variables
            String mondayStart = null;
            String tuesdayStart = null;
            String wednesdayStart = null;
            String thursdayStart = null;
            String fridayStart = null;
            String saturdayStart = null;
            String sundayStart = null;
            String mondayEnd = null;
            String tuesdayEnd = null;
            String wednesdayEnd = null;
            String thursdayEnd = null;
            String fridayEnd = null;
            String saturdayEnd = null;
            String sundayEnd = null;
%>

<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee Detail Information</title>
    </head>
    <body>
        <%--Page Content--%>
        <center>
        <%--Report Header--%>
        <h3>Employee Detail Information</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        </center>
        <div>
            <%--Table Employee Detail.--%>
            <table border="1" align="center" width="500"> 
                <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT * FROM employee em, address ad   ");
            sb.append(" WHERE em.employee_no = ? ");
            sb.append(" AND em.address_no = ad.address_no; ");

            try {
                //Create a connection to the database from the connection pool.
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                //Insert the employee number to the query statement.
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs = ps.executeQuery();  //Execute the query statement.
                //Populate the helper variables.
                if (rs.next()) {
                    mondayStart = rs.getString("monday_start");
                    tuesdayStart = rs.getString("tuesday_start");
                    wednesdayStart = rs.getString("wednesday_start");
                    thursdayStart = rs.getString("thursday_start");
                    fridayStart = rs.getString("friday_start");
                    saturdayStart = rs.getString("saturday_start");
                    sundayStart = rs.getString("sunday_start");
                    mondayEnd = rs.getString("monday_End");
                    tuesdayEnd = rs.getString("tuesday_End");
                    wednesdayEnd = rs.getString("wednesday_End");
                    thursdayEnd = rs.getString("thursday_End");
                    fridayEnd = rs.getString("friday_End");
                    saturdayEnd = rs.getString("saturday_End");
                    sundayEnd = rs.getString("sunday_End");
                %>
                <tr>
                    <td align="right">Employee Number</td>
                    <td align="left"><%=rs.getString("employee_no")%></td>
                </tr>
                <tr>
                    <td align="right">First name</td>
                    <td align="left"><%=rs.getString("first_name")%></td>
                </tr>
                <tr>
                    <td align="right">Last name</td>
                    <td align="left"><%=rs.getString("last_name")%></td>
                </tr>
                <tr>
                    <td align="right">Phone number</td>
                    <td align="left"><%=getPhoneNumberFormat(rs.getString("phone_number"))%></td>
                </tr>
                <tr>
                    <td align="right">Role</td>
                    <td align="left"><%=rs.getString("role")%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Address1</td>
                    <td width="70%" align="left"><%=getNotAvailable(rs.getString("ad.address1"))%>
                        <br/><%=rs.getString("ad.city")%>, <%=rs.getString("ad.province")%>, 
                    <br/><%=rs.getString("ad.country")%>, <%=getPostalCodeFormat(rs.getString("ad.postal_code"))%></td> 
                </tr>
                <tr>
                    <td width="30%" align="right">Address2</td>
                    <td width="70%" align="left"><%=getNotAvailable(rs.getString("ad.address2"))%>
                </tr>
                <tr>
                    <td align="right">E-mail</td>
                    <td align="left"><%=rs.getString("email")%></td>
                </tr>
                <%			}

            } catch (Exception e) {
            } finally {
                if (conn != null) {
                    //Create a connection to the database from the connection pool.
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }
                if (rs != null) {
                    //Close and result the result set storage variable.
                    rs.close();
                    rs = null;
                }
            }
                %>
            </table>
        </div><br/>
        <div>
            <%--Table availability column headers.--%>
            <table border="1" align="center" width="600">
                <tr>
                    <td colspan=8 align="center">Weekly Availability</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Mon</td>
                    <td>Tue</td>
                    <td>Wed</td>
                    <td>Thu</td>
                    <td>Fri</td>
                    <td>Sat</td>
                    <td>Sun</td>
                </tr>
                <%--Table availability row elements.--%>
                <tr>
                    <td>Start</td>
                    <td><%=mondayStart%></td>
                    <td><%=tuesdayStart%></td>
                    <td><%=wednesdayStart%></td>
                    <td><%=thursdayStart%></td>
                    <td><%=fridayStart%></td>
                    <td><%=saturdayStart%></td>
                    <td><%=sundayStart%></td>
                </tr>
                <tr>
                    <td>End</td>
                    <td><%=mondayEnd%></td>
                    <td><%=tuesdayEnd%></td>
                    <td><%=wednesdayEnd%></td>
                    <td><%=thursdayEnd%></td>
                    <td><%=fridayEnd%></td>
                    <td><%=saturdayEnd%></td>
                    <td><%=sundayEnd%></td>
                </tr>
            </table>
        </div><br/>
        <div>
            <%--Table service column headers.--%>
            <table border="1" align="center" width="500">
                <tr>
                    <td colspan=4 align="center">Service(s) Available</td>
                </tr>
                <tr>
                    <td>Name</td>
                    <td>Descritpion</td>
                    <td>Duration</td>
                    <td>Price</td>
                </tr>
                <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT s.name, s.description,    ");
            sb.append(" s.duration, s.price, s.enabled  ");
            sb.append(" FROM employee e, service s, employeeservice es ");
            sb.append(" WHERE e.employee_no = ?  ");
            sb.append(" AND e.employee_no = es.employee_no ");
            sb.append(" AND es.service_no = s.service_no  ");
            sb.append(" AND s.enabled = true  ");
            sb.append(" ORDER BY s.service_no; ");
            
            try {
                //Create a connection to the database from the connection pool.
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                //Insert the employee number to the query statement.
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs = ps.executeQuery();  //Execute the query statement.
                //Populate the table for services.
                while (rs.next()) {
                    rsCount++;
                %>
                <%--Table service row elements.--%>
                <tr>
                    <td><%=rs.getString("name")%></td>
                    <td><%=rs.getString("description")%></td>
                    <td><%=rs.getString("duration")%></td>
                    <td><%=rs.getString("price")%></td>
                </tr>
                <%			}
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
            </table>
        </div>
        <center>
        <%--Display the row count result.--%>
        <%if (rsCount == 0) {%>
        There is no result return!  Please try again.<br/>
        <%} else {%>
        There are <%=rsCount%> result(s) in the list.<br/>
        <%}%></center>
        <br/>
        <%--Input buttons for additional report commends.--%>
        <div>
            <center>
                <input type="button" size=20 value="Print this page"
                       onclick="window.print();return false;" />&nbsp;&nbsp;
                <input type="button" size=20 value="Close Window"
                       onclick="window.close();return false;" />
            </center>
        </div>
    </body>
</html>
