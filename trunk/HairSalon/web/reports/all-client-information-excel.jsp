<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@ page contentType="application/vnd.ms-excel" %>
<%@page import="java.sql.*" %>
<%@page import="hs.persistence.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>All client information report</title>
    </head>
    <body>
        <table>
            <tr>
                <td>
                    First name
                </td>
                <td>
                    Last name
                </td>
                <td>
                    Phone number
                </td>
                <td>
                    Address1
                </td>
                <td>
                    Address2
                </td>
                <td>
                    City
                </td>
                <td>
                    Province
                </td>
                <td>
                    Country
                </td>
                <td>
                    Postal-Code
                </td>
                <td>
                    E-mail
                </td>
            </tr>
            <%
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT first_name, last_name, phone_number,  ");
		sb.append(" address1, address2, city, province, country,  ");
		sb.append(" postal_code, email ");
		sb.append(" FROM client c, address a");
		sb.append(" WHERE c.address_no = a.address_no ");
		sb.append(" AND c.enabled = true ");
		sb.append(" ORDER BY client_no; ");
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
            %>
            <tr>
                <td><%=rs.getString("first_name")%></td>
                <td><%=rs.getString("last_name")%></td>
                <td><%=rs.getString("phone_number")%></td>
                <td><%=rs.getString("address1")%></td>
                <td><%=rs.getString("address2")%></td>
                <td><%=rs.getString("city")%></td>
                <td><%=rs.getString("province")%></td>
                <td><%=rs.getString("country")%></td>
                <td><%=rs.getString("postal_code")%></td>
                <td><%=rs.getString("email")%></td>
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
    </body>
</html>
