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
<%@page import="hs.persistence.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%
		Connection conn = null;
		ResultSet rs = null;
		StringBuilder sb = null;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product information report</title>
    </head>
    <body>
        <form action="product-information.jsp">
            <%
		String supplierNo = request.getParameter("SupplierNo");
		if (supplierNo == null) {
			supplierNo = "0";
		}
		sb = new StringBuilder();
		sb.append(" SELECT *  ");
		sb.append(" FROM supplier s ");
		sb.append(" WHERE s.enabled = true ");
		sb.append(" ORDER BY s.supplier_no; ");
            %>
            <div>
                <select name="SupplierNo">
                    <option value="0" >All</option>
                    <%
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
                                if (rs.getString("supplier_no").equals(supplierNo)) {
                    %>
                    <option value="<%=rs.getInt("supplier_no")%>" selected><%=rs.getString("supplier_name")%></option>
                    <%			} else {
                    %>
                    <option value="<%=rs.getInt("supplier_no")%>"><%=rs.getString("supplier_name")%></option>
                    <%
				}
			}

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
                </select>
                <input type="submit" value="Search">
            </div>
            <div>
                <table>
                    <tr>
                        <td>
                            Supplier Name
                        </td>
                        <td>
                            Phone Number
                        </td>
                        <td>
                            Product Name
                        </td>
                        <td>
                            Brand
                        </td>
                        <td>
                            Type
                        </td>
                        <td>
                            Quantity Per
                        </td>
                        <td>
                            Unit
                        </td>
                        <td>
                            Min Qty
                        </td>
                        <td>
                            Stock Qty
                        </td>
                        <td>
                            Price
                        </td>
                    </tr>
                    <%
		sb = new StringBuilder();
		sb.append(" SELECT product_name, brand, product_type, qty_per,  ");
		sb.append(" unit, min_level, stock_qty, price,  ");
		sb.append(" s.supplier_no, supplier_name, phone_number ");
		sb.append(" FROM product p, supplier s, supplierproduct sp ");
		sb.append(" WHERE 1 = 1 ");
                if ((!supplierNo.equals("")) && supplierNo != null && (!supplierNo.equals("0"))) {
			sb.append(" AND s.supplier_no = ?");
		}
		sb.append(" AND sp.supplier_no = s.supplier_no ");
		sb.append(" AND p.product_no = sp.product_no ");
		sb.append(" AND p.min_level>p.stock_qty AND p.enabled = false ");
		sb.append(" ORDER BY s.supplier_no; ");
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			if ((!supplierNo.equals("")) && supplierNo != null && (!supplierNo.equals("0"))) {
				ps.setInt(0, Integer.parseInt("supplierNo"));
			}
			rs = ps.executeQuery();
			while (rs.next()) {
                    %>
                    <tr>
                        <td><%=rs.getString("supplier_name")%></td>
                        <td><%=rs.getString("phone_number")%></td>
                        <td><%=rs.getString("product_name")%></td>
                        <td><%=rs.getString("brand")%></td>
                        <td><%=rs.getString("product_type")%></td>
                        <td><%=rs.getString("qty_per")%></td>
                        <td><%=rs.getString("unit")%></td>
                        <td><%=rs.getString("min_level")%></td>
                        <td><%=rs.getString("stock_qty")%></td>
                        <td><%=rs.getString("price")%></td>
                    </tr>
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
                </table>
            </div>
            <div>
                <input type="button" size=20 value="Export Excel"
                       onclick="window.open('product-information-excel.jsp?SupplierNo=<%=supplierNo%>', '_blank');" />&nbsp;&nbsp;&nbsp;
                <input type="button" size=20 value="Print this page"
                       onclick="window.print();return false;" />
            </div>
        </form>
    </body>
</html>
