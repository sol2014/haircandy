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
<%@ page errorPage="/reports/report-error.jsp?from=product-usage.jsp" %>

<%!
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
            Connection conn = null;
            Connection conn2 = null;
            ResultSet rs = null;
            ResultSet rs2 = null;
            StringBuilder sb = null;
            StringBuilder sb2 = null;

//Helper Variables for parameter value. 
            String productNo = request.getParameter("productNo");
            String beginDate = request.getParameter("BeginDate");
            String endDate = request.getParameter("EndDate");
%>

<html>
<%--Page Header--%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Usage information report</title>
</head>

<%--Javasript Functions.--%>
<script type="text/javascript">
    <!--      
    
    /*
     *  This function to have the cursor start at the First Name 
     *  text field when called, Then call the hide or display function.
     **/
    function selectTextField() {
        document.QueryInput.productNo.focus();
    }
        
    -->
</script>

    <%--Page Content--%>
    <%--Calls javascript function to do the initial setup of the page.--%>
    <body onLoad=selectTextField()>
        <%--Report Header--%>
        <h3>Product Usage Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        
    <form name="QueryInput" action="product-usage.jsp">
    <%
            //Initialize product number.
            if (productNo == null) {
                productNo = "0";
            }
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT *  ");
            sb.append(" FROM product se ");
            sb.append(" WHERE se.enabled = true ");
            sb.append(" ORDER BY se.product_no; ");
    %>
    <div>
        <%--Drop down box to collect the product number for query the 
            report. Javascript function called to select the proper 
        option, default selection is 0. --%>                
        Select Product:&nbsp;
        <select name="productNo">
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
                    if (rs.getString("product_no").equals(productNo)) {
                    %>
                    <option value="<%=rs.getInt("product_no")%>"
                    selected><%=rs.getString("product_name")%></option>
                    <%	} else { %>
                    <option value="<%=rs.getInt("product_no")%>">
                    <%=rs.getString("product_name")%> </option>
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
            if (beginDate == null || beginDate.equals("")) {
                beginDate = "1900-01-01";
            }
            if (endDate == null || endDate.equals("")) {
                endDate = "2100-01-01";
            }
        %>
        <input type="submit" value="Search">
    </div><br/>
        <%--Table column headers.--%>
        <table border=1 width="700">
        <tr>
            <td align="center" width="30%"><b>Product Brand</b></td>
            <td align="center" width="30%"><b>Product Name</b></td>
            <td align="center" width="10%"><b>Size</b></td>
            <td align="center" width="15%"><b>Price</b></td>
            <td align="center" width="15%"><b>Total Sold</b></td>
        </tr>
        
        <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT DISTINCT sa.timestamp, pr.product_no, ");
            sb.append(" pr.brand, pr.product_name, pr.qty_per, ");
            sb.append(" pr.unit, pr.price, sp.amount ");
            sb.append(" FROM sale sa, saleproduct sp, product pr ");
            sb.append(" WHERE pr.product_no = sp.product_no ");
            //If an individual supplier is chosen, execute the statement.
            if ((!productNo.equals("")) && productNo != null && (!productNo.equals("0"))) {
                sb.append(" AND pr.product_no = ? ");
            }
            sb.append(" AND sp.transaction_no = sa.transaction_no ");
            sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
            sb.append(" ORDER BY sa.timestamp; ");

            try {
                //Create a connection to the database from the connection pool.
                conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn2.prepareStatement(sb.toString());
                int index = 1;  //index for ? search field.
                //Insert the product number to the query statement.
                if ((!productNo.equals("")) && productNo != null && (!productNo.equals("0"))) {
                    ps.setInt(index, Integer.parseInt(productNo));
                    index++;
                }

                //Create a time format for date object.
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
                index++;//Increment to the next ? location
                //set time stamp for begin date search field.
                ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
                index++;  //Increment to the next ? location
                rs = ps.executeQuery();  //Execute the query statement.
                
                //While there is a row of data from the result set.
                while (rs.next()) {
        %>
        <tr>
            <td align="left" width="30%"><%=rs.getString("brand")%></td>
            <td align="left" width="30%"><%=rs.getString("product_name")%></td>
            <td align="left" width="10%"><%=rs.getString("qty_per")%> <%=rs.getString("unit")%></td>
            <td align="right" width="15%"><%=rs.getString("price")%></td>
            <%
                sb2 = new StringBuilder();
                sb2.append(" SELECT COALESCE(SUM(sp.amount), 0) \"Total\" ");
                sb2.append(" FROM sale sa, saleproduct sp, product pr ");
                sb2.append(" WHERE sp.product_no = pr.product_no ");
                sb2.append(" AND sp.product_no = " + rs.getInt("product_no"));
                sb2.append(" AND sp.transaction_no = sa.transaction_no ");
                sb2.append(" AND sa.timestamp BETWEEN ? AND ?; ");

                try {
                    conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                    PreparedStatement ps2 = conn2.prepareStatement(sb2.toString());
                    int index2 = 1;
                    SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
                    ps2.setTimestamp(index2, new Timestamp((df2.parse(beginDate)).getTime()));
                    index2++;
                    ps2.setTimestamp(index2, new Timestamp((df2.parse(endDate)).getTime()));
                    index2++;
                    rs2 = ps2.executeQuery();
                    if (rs2.next()) {
            %>
            <td align="right" width="15%"><%=rs2.getString("Total")%></td>
            <%
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    } finally {
                        if (conn2 != null) {
                            MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn2);
                        }
                        if (rs2 != null) {
                            rs2.close();
                            rs2 = null;
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
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
        </tr>
    </table>
    </div>
    <%
            if (beginDate.equals("1900-01-01")) {
                beginDate = "";
            }
            if (endDate.equals("2100-01-01")) {
                endDate = "";
            }
    %>
    
    <%
            String params = "";

            String excelURL = "product-usage-excel.jsp" + params;

            String printURL = "product-usage-print.jsp" + params;
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

