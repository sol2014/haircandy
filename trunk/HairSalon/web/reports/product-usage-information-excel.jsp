<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="application/vnd.ms-excel" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="hs.persistence.*" %>

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
		Connection conn = null;
		Connection conn2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		StringBuilder sb = null;
		StringBuilder sb2 = null;
%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>product Usage information report</title>
</head>
<body>
<form action="product-usage-information.jsp">
    <%
		String productNo = request.getParameter("productNo");
		if (productNo == null) {
			productNo = "0";
		}
		String beginDate = request.getParameter("BeginDate");
		String endDate = request.getParameter("EndDate");
		sb = new StringBuilder();
		sb.append(" SELECT *  ");
		sb.append(" FROM product se ");
		sb.append(" WHERE se.enabled = true ");
		sb.append(" ORDER BY se.product_no; ");
    %>
    <div>
        <select name="productNo">
            <option value="0" >All</option>
            <%
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString("product_no").equals(productNo)) {
            %>
            <option value="<%=rs.getInt("product_no")%>"  selected><%=rs.getString("name")%></option>
            <%	} else {
            %>
            <option value="<%=rs.getInt("product_no")%>"><%=rs.getString("name")%> </option>
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
        <input type="text" value="<%=getEmptyString(beginDate)%>" name="BeginDate">
        <input type="text" value="<%=getEmptyString(endDate)%>" name="EndDate">
        <%
		if (beginDate == null || beginDate.equals("")) {
			beginDate = "1900-01-01";
		}
		if (endDate == null || endDate.equals("")) {
			endDate = "2100-01-01";
		}
        %>
        <input type="submit" value="Search">
    </div>
    <table>
        <tr>
            <td>
                Product Brand
            </td>
            <td>
                Product Sold
            </td>
            <td>
                Quantity Per
            </td>
            <td>
                Unit
            </td>
            <td>
                Price
            </td>
            <td>
                Total Sold
            </td>
        </tr>

        <%

		sb = new StringBuilder();
		sb.append(" SELECT DISTINCT sa.timestamp, pr.product_no, ");
		sb.append(" pr.brand, pr.product_name, pr.qty_per, ");
		sb.append(" pr.unit, pr.price, sp.amount ");
		sb.append(" FROM sale sa, saleproduct sp, product pr ");
		sb.append(" WHERE pr.product_no = sp.product_no ");
		if (!productNo.equals("0")) {
			sb.append(" AND pr.product_no = ? ");
		}
		sb.append(" AND sp.transaction_no = sa.transaction_no ");
		sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
		sb.append(" ORDER BY sa.timestamp; ");

		try {
			conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn2.prepareStatement(sb.toString());
			int index = 1;
			if (!productNo.equals("0")) {
				ps.setInt(index, Integer.parseInt(productNo));
				index++;
			}
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
			index++;
			ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
			index++;
			rs = ps.executeQuery();
			while (rs.next()) {
        %>
        <tr>
            <td><%=rs.getString("brand")%></td>
            <td><%=rs.getString("product_name")%></td>
            <td><%=rs.getString("qty_per")%></td>
		<td><%=rs.getString("unit")%></td>
		<td><%=rs.getString("price")%></td>
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
            <td><%=rs2.getString("Total")%></td>
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
    <div>
        <%
		if (beginDate.equals("1900-01-01")) {
			beginDate = "";
		}
		if (endDate.equals("2100-01-01")) {
			endDate = "";
		}
        %>
    </div>
</form>
</body>
</html>
