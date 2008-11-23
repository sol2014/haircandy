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
<%@ page errorPage="/reports/report-error.jsp?from=product-order-list.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%
            //Define Available
            Connection conn = null;     //SQL connector var.
            ResultSet rs = null;        //SQL result set var.
            int rsCount = 0;            //Result set row count.
            StringBuilder sb = null;    //String builder for SQL statement.

            //Helper Variables for parameter value.                     
            String supplierNo = request.getParameter("SupplierNo");
%>
<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product information report</title>
    </head>
    
    <%--Javasript Functions.--%>
    <script type="text/javascript">
        <!--      
        /*
         *  This function to have the cursor start at the supplier name
         *  drop down box when called, Then call the hide or display function.
         **/
        function selectTextField() {
            document.QueryInput.SupplierNo.focus();
        }

        -->
    </script>
    
    <%--Page Content--%>
    <%--Calls javascript function to do the initial setup of the page.--%>
    <body onLoad=selectTextField()>
        <%--Report Header--%>
        <h3>Product Order List</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        
        <form name="QueryInput" action="product-order-list.jsp">
            <%
            //Initialize supplier number.
            if (supplierNo == null) {
                supplierNo = "0";
            }
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT *  ");
            sb.append(" FROM supplier s ");
            sb.append(" WHERE s.enabled = true ");
            sb.append(" ORDER BY s.supplier_no; ");
            %>
            
            <div>
            <%--Drop down box to collect the product number for query the 
                report. Javascript function called to select the proper 
                option, default selection is 0. --%>            
            Select Suppler:&nbsp;
            <select name="SupplierNo" >
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
                    //Check if the supplier is previously selected.
                    if (rs.getString("supplier_no").equals(supplierNo)) {
                    %>
                    <option value="<%=rs.getInt("supplier_no")%>" selected>
                    <%=rs.getString("supplier_name")%></option>
                    <%} else {
                    %>
                    <option value="<%=rs.getInt("supplier_no")%>">
                    <%=rs.getString("supplier_name")%></option>
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
                </select>&nbsp;&nbsp;
                <br/><br/><input type="submit" value="Search">
            </div><br/>
            <div>
                <%--Table column headers.--%>
                <table border=1 width="700">
                    <tr>
                        <td align="center" width="10%" ><b>Supplier Name</b></td>
                        <td align="center" width="10%" ><b>Phone Number</b></td>
                        <td align="center" width="20%" ><b>Product Name</b></td>
                        <td align="center" width="15%" ><b>Brand</b></td>
                        <td align="center" width="10%" ><b>Type</b></td>
                        <td align="center" width="5%" ><b>Size</b></td>
                        <td align="center" width="5%" ><b>Min Qty</b></td>
                        <td align="center" width="5%" ><b>Stock Qty</b></td>
                        <td align="center" width="10%" ><b>Price</b></td>
                    </tr>
                    <%
            //Initialize variable to store the SQL statement.
            sb = new StringBuilder();
            //Store SQL statement for query.
            sb.append(" SELECT product_name, brand, product_type, qty_per,  ");
            sb.append(" unit, min_level, stock_qty, price,  ");
            sb.append(" s.supplier_no, supplier_name, phone_number ");
            sb.append(" FROM product p, supplier s, supplierproduct sp ");
            sb.append(" WHERE 1 = 1 "); //Temp line to execute the WHERE CLAUSE.
            //If an individual supplier is chosen, execute the statement.
            if ((!supplierNo.equals("")) && supplierNo != null && (!supplierNo.equals("0"))) {
                sb.append(" AND s.supplier_no = ?");
            }
            sb.append(" AND sp.supplier_no = s.supplier_no ");
            sb.append(" AND p.product_no = sp.product_no ");
            sb.append(" AND p.min_level>p.stock_qty AND p.enabled = false ");
            sb.append(" ORDER BY s.supplier_no; ");
            try {
                 //Create a connection to the database from the connection pool.               
                conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                //Prepare the statement to query the database.
                PreparedStatement ps = conn.prepareStatement(sb.toString());
                
                int index = 1;  //index for ? search field.
                
                //Insert the supplier number to the query statement.
                if ((!supplierNo.equals("")) && supplierNo != null && (!supplierNo.equals("0"))) {
                    ps.setInt(index, Integer.parseInt(supplierNo));
                }
                rs = ps.executeQuery();  //Execute the query statement.
                
                //While there is a row of data from the result set.
                while (rs.next()) {
                    rsCount++;  //Increment the result set row count.
                    %>
                    <tr>
                        <td align="left" width="10%" ><%=rs.getString("supplier_name")%></td>
                        <td align="left" width="10%" ><taglib:FormatTag format="phone">
                        <%=rs.getString("phone_number")%></taglib:FormatTag></td>
                        <td align="left" width="20%" ><%=rs.getString("product_name")%></td>
                        <td align="left" width="15%" ><%=rs.getString("brand")%></td>
                        <td align="left" width="10%" ><%=rs.getString("product_type")%></td>
                        <td align="right" width="5%" >
                            <%=rs.getString("qty_per")%> <%=rs.getString("unit")%></td>
                        <td align="right" width="5%" ><%=rs.getString("min_level")%></td>
                        <td align="right" width="5%" ><%=rs.getString("stock_qty")%></td>
                        <td align="right" width="10%" >
                        <taglib:FormatTag format="currency"><%=rs.getString("price")%>
                        </taglib:FormatTag></td>
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
            </div>
           <%--Display the row count result.--%>
            <%if (rsCount == 0) {%>
            There is no result return!  Please try again.<br/>
            <%} else {%>
            There are <%=rsCount%> result(s) in the list.<br/>
            <%}%><br/>
            <%
            //Set the URL link parameters for the input buttons.
            String params = "?SupplierNo=" + supplierNo;

            //Set the URL page name for the export excel input buttons.
            String excelURL = "product-order-list-excel.jsp" + params;
           //Set the URL page name for the print report input buttons.
            String printURL = "product-order-list-print.jsp" + params;
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
