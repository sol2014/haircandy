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
<%@ page errorPage="/reports/report-error.jsp?from=transaction-details.jsp" %>

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
    //Define vailables.
    Connection conn = null;     //SQL connector var.
    ResultSet rs = null;        //SQL result set var.
    int rsCount = 0;            //Result set row count.
    Connection conn2 = null;    //SQL connector var.
    ResultSet rs2 = null;       //SQL result set var.
    int rsCount2 = 0;            //Result set row count.
    Connection conn3 = null;    //SQL connector var.
    ResultSet rs3 = null;       //SQL result set var.
    int rsCount3 = 0;            //Result set row count.
    StringBuilder sb = null;    //String builder for SQL statement.
%>

<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale Detail Information</title>
    </head>
    <body>
        <%--Page Content--%>
        <center>
            <h3>Transaction Detail report</h3>
            <h4>Date:  <taglib:datetime/> </h4>
        </center>
        
        <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT * FROM sale sa, ");
            sb.append(" client cl, employee em, ");
            sb.append(" address ad ");
            sb.append(" WHERE sa.transaction_no = ? ");
            sb.append(" AND sa.client_no = cl.client_no ");
            sb.append(" AND sa.employee_no = em.employee_no ");
            sb.append(" AND ad.address_no = cl.address_no ");

            try {
                //Create a connection to the database from the connection pool.
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                //Insert the employee number to the query statement.
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs = ps.executeQuery();  //Execute the query statement.
                //Populate the sale detail table if data exists.
                if (rs.next()) {
        %>
        <div>
            <%--Table transaction detail row elements.--%>
            <table border="1" align="center" width="500">
                <tr>
                    <td width="30%" align="right">Transaction Number</td>
                    <td width="70%" align="left"><%=rs.getString("sa.transaction_no")%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Date</td>
                    <td width="70%" align="left"><%=trimTimeStamp(rs.getString("sa.timestamp"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Total Due</td>
                    <td width="70%" align="left">
                    <%=getCurrencyFormat(rs.getString("sa.total_due"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Sale Tax</td>
                    <td width="70%" align="left">
                    <%=getCurrencyFormat(rs.getString("sa.total_tax"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Discount</td>
                    <td width="70%" align="left">
                    <%=getCurrencyFormat(rs.getString("sa.discount"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Payment</td>
                    <td width="70%" align="left">
                    <%=getCurrencyFormat(rs.getString("sa.payment"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">Payment Type</td>
                    <td width="70%" align="left">
                    <%=getCurrencyFormat(rs.getString("sa.payment"))%></td>
                </tr>
        </table><br/></div>
        
        <div>
            <%--Table client detail row elements.--%>
            <table border="1" align="center" width="500">
                <tr>
                    <td colspan=2 align="center">Client Detail</td>
                </tr>
                <tr>
                    <td width="30%" align="right">Client Name</td>
                    <td width="70%" align="left"><%=rs.getString("cl.first_name")%> <%=rs.getString("cl.last_name")%></td>
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
                    <td width="30%" align="right">Phone Number</td>
                    <td width="70%" align="left">
                    <%=getPhoneNumberFormat(rs.getString("cl.phone_number"))%></td>
                </tr>
                <tr>
                    <td width="30%" align="right">E-mail</td>
                    <td width="70%" align="left"><%=rs.getString("ad.email")%></td>
                </tr>
            </table>
        </div><br/>
        
        <div>
            <%--Table employee information row elements.--%>
            <table border="1" align="center" width="500">
                <tr>
                    <td width="30%" align="right">Employee Name</td>
                    <td width="70%" align="left"><%=rs.getString("em.first_name")%> <%=rs.getString("em.last_name")%></td>
                </tr>
            </table>   
        </div><br/>
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
        <div>
            <%--Table service detail row elements.--%>
            <table border="1" align="center" width="500">                
                <tr>
                    <td colspan=5 align="center">Service Detail</td>
                </tr>
                <tr>
                    <td width="10%" align="center">No.</td>
                    <td width="20%" align="center">Service Name</td>
                    <td width="40%" align="center">Description</td>
                    <td width="20%" align="center">Price</td>
                    <td width="10%" align="center">Amount</td>
                </tr>    
                <%
            //Initialize variable to store the SQL statement.
            StringBuilder sb2 = new StringBuilder();
            //Store SQL statement for query.
            sb2.append(" SELECT se.service_no, se.name,");
            sb2.append(" se.description, se.duration, se.price, ss.amount  ");
            sb2.append(" FROM sale sa, saleservice ss, service se  ");
            sb2.append(" WHERE sa.transaction_no = ? ");
            sb2.append(" AND ss.transaction_no = sa.transaction_no ");
            sb2.append(" AND se.service_no = ss.service_no ");
            sb2.append(" ORDER BY se.service_no ");

            try {
               //Create a connection to the database from the connection pool.
                conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps2 = conn2.prepareStatement(sb2.toString());
                //Insert the employee number to the query statement.
                ps2.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs2 = ps2.executeQuery();  //Execute the query statement.
                //Populate the table for service details.
                while (rs2.next()) {
                    rsCount2++;
                %>
                
                <tr>
                    <td width="10%" align="right"><%=rs2.getString("se.service_no")%></td>
                    <td width="20%" align="left" ><%=rs2.getString("se.name")%></td>
                    <td width="40%" align="left" ><%=rs2.getString("se.description")%></td>
                    <td width="20%" align="right">
                    <%=getCurrencyFormat(rs2.getString("se.price"))%></td>
                    <td width="10%" align="right"><%=rs2.getString("ss.amount")%></td>
                </tr>
                
                <%                }

            } catch (Exception e) {
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
            }%>
            </table>
        </div>
        <center>
        <%--Display the row count result.--%>
        <%if (rsCount2 == 0) {%>
        There is no result return!  Please try again.<br/>
        <%} else {%>
        There are <%=rsCount2%> result(s) in the list.<br/>
        <%}%></center>
        <br/>      
        <div>
            <%--Table product sold row elements.--%>
            <table border="1" align="center" width="500">                
                <tr>
                    <td colspan=7 align="center">Product Sold</td>
                </tr>
                <tr>
                    <td width="20%" align="center">Brand</td>
                    <td width="25%" align="center">Name</td>
                    <td width="10%" align="center">Type</td>
                    <td width="10%" align="center">Size</td>
                    <td width="15%" align="center">Price</td>
                    <td width="10%" align="center">Amount</td>
                </tr>    
                <%
            //Initialize variable to store the SQL statement.
            StringBuilder sb3 = new StringBuilder();
            //Store SQL statement for query.
            sb3.append(" SELECT pr.product_no, pr.brand, pr.product_name, ");
            sb3.append(" pr.product_type, pr.qty_per, pr.unit, ");
            sb3.append(" pr.price, sp.amount ");
            sb3.append(" FROM sale sa, saleproduct sp, product pr ");
            sb3.append(" WHERE sa.transaction_no = ? ");
            sb3.append(" AND pr.product_no = sp.product_no ");
            sb3.append(" AND sp.transaction_no = sa.transaction_no ");
            sb3.append(" ORDER BY pr.product_no ");

            try {
                //Create a connection to the database from the connection pool.
                conn3 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps3 = conn3.prepareStatement(sb3.toString());
                //Insert the employee number to the query statement.
                ps3.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs3 = ps3.executeQuery();  //Execute the query statement.
                //Populate the table for product sold.
                while (rs3.next()) {
                    rsCount3++;
                %>
                <tr>
                    <td width="25%" align="left" ><%=rs3.getString("pr.brand")%></td>
                    <td width="25%" align="left" ><%=rs3.getString("pr.product_name")%></td>
                    <td width="10%" align="left" ><%=rs3.getString("pr.product_type")%></td>
                    <td width="15%" align="right"><%=rs3.getString("pr.qty_per")%>&nbsp;<%=rs3.getString("pr.unit")%></td>
                    <td width="15%" align="right">
                    <%=getCurrencyFormat(rs3.getString("pr.price"))%></td>
                    <td width="10%" align="right"><%=rs3.getString("sp.amount")%></td>
                </tr>
                
                <%                }
            } catch (Exception e) {
            } finally {
                if (conn3 != null) {
                    //Return connection to the connection pool.
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn3);
                }
                if (rs3 != null) {
                    //Close and result the result set storage variable.
                    rs3.close();
                    rs3 = null;
                }
            }%>
            </table>
        </div>
        <center>
        <%--Display the row count result.--%>
        <%if (rsCount3 == 0) {%>
        There is no result return!  Please try again.<br/>
        <%} else {%>
        There are <%=rsCount3%> result(s) in the list.<br/>
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
