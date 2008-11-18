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

<%!
	private String getPhoneNumberFormat(String phone) {
                return "("+phone.substring(0, 3)+")"+phone.substring(3,6)+"-"+phone.substring(6,10);
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>All client information report</title>
    </head>
    <body>
        <div>
            <table>
                <tr>
                    <td>
                        Employee Number
                    </td>
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
                        Role
                    </td>
                </tr>
                <%
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT employee_no, first_name,  ");
		sb.append(" last_name, role, phone_number  ");
		sb.append(" FROM `employee` ");
		sb.append(" ORDER by employee_no; ");
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
                %>
                <tr>
                    <td><%=rs.getString("employee_no")%></td>
                    <td><%=rs.getString("first_name")%></td>
                    <td><%=rs.getString("last_name")%></td>
                    <td><%=getPhoneNumberFormat(rs.getString("phone_number"))%></td>
                    <td><%=rs.getString("role")%></td>
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
                   onclick="window.open('all-client-information-excel.jsp', '_blank');" />&nbsp;&nbsp;&nbsp;
            <input type="button" size=20 value="Print this page"
                   onclick="window.print();return false;" />
        </div>
    </body>
</html>
