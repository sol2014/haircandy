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
<%@ page errorPage="/report-error.jsp?from=transaction-details.jsp" %>

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

    private String getPhoneNumberFormat(String phone) {
        return "(" + phone.substring(0, 3) + ") " + phone.substring(3, 6) +
                "-" + phone.substring(6, 10);
    }

    private String getNotAvailable(String input) {
        if ((input == null) || (input.equals(""))) {
            return "Not Available";
        } else {
            return input;
        }
    }

    private String getPostalCodeFormat(String postCode) {
        return postCode.substring(0, 3) + "-" + postCode.substring(3, 6);
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale Detail Information</title>
    </head>
    <body>
        <center>
            <h3>Transaction Detail report</h3>
            <h4>Date:  <taglib:datetime/> </h4>
        </center>
        
        <%
            StringBuilder sb = new StringBuilder();
            sb.append(" SELECT * FROM sale sa, ");
            sb.append(" client cl, employee em, ");
            sb.append(" address ad ");
            sb.append(" WHERE sa.transaction_no = ? ");
            sb.append(" AND sa.client_no = cl.client_no ");
            sb.append(" AND sa.employee_no = em.employee_no ");
            sb.append(" AND ad.address_no = cl.address_no ");
            Connection conn = null;
            ResultSet rs = null;
            try {
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs = ps.executeQuery();
                if (rs.next()) {
        %>
        <div>
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
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
                }
                if (rs != null) {
                    rs.close();
                    rs = null;
                }
            }
        %>
        <div>
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

            StringBuilder sb2 = new StringBuilder();
            sb2.append(" SELECT se.service_no, se.name,");
            sb2.append(" se.description, se.duration, se.price, ss.amount  ");
            sb2.append(" FROM sale sa, saleservice ss, service se  ");
            sb2.append(" WHERE sa.transaction_no = ? ");
            sb2.append(" AND ss.transaction_no = sa.transaction_no ");
            sb2.append(" AND se.service_no = ss.service_no ");
            sb2.append(" ORDER BY se.service_no ");

            Connection conn2 = null;
            ResultSet rs2 = null;
            try {
                conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                PreparedStatement ps2 = conn2.prepareStatement(sb2.toString());
                ps2.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs2 = ps2.executeQuery();
                while (rs2.next()) {
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
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn2);
                }
                if (rs2 != null) {
                    rs2.close();
                    rs2 = null;
                }
            }%>
            </table>
        </div><br/>
        
        <div>
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

            StringBuilder sb3 = new StringBuilder();
            sb3.append(" SELECT pr.product_no, pr.brand, pr.product_name, ");
            sb3.append(" pr.product_type, pr.qty_per, pr.unit, ");
            sb3.append(" pr.price, sp.amount ");
            sb3.append(" FROM sale sa, saleproduct sp, product pr ");
            sb3.append(" WHERE sa.transaction_no = ? ");
            sb3.append(" AND pr.product_no = sp.product_no ");
            sb3.append(" AND sp.transaction_no = sa.transaction_no ");
            sb3.append(" ORDER BY pr.product_no ");

            Connection conn3 = null;
            ResultSet rs3 = null;
            try {
                conn3 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                PreparedStatement ps3 = conn3.prepareStatement(sb3.toString());
                ps3.setInt(1, Integer.parseInt(request.getParameter("id")));
                rs3 = ps3.executeQuery();
                while (rs3.next()) {
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
                    MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn3);
                }
                if (rs3 != null) {
                    rs3.close();
                    rs3 = null;
                }
            }%>
            </table>
        </div><br/>

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
