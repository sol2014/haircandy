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
		return "(" + phone.substring(0, 3) + ")" + phone.substring(3, 6) + "-" + phone.substring(6, 10);
	}

	private String getNotAvailable(String input) {
		if (input == null) {
			return "Not Available";
		} else {
			return input;
		}
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
                <%
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
                <%
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT * FROM employee e, address a   ");
		sb.append(" WHERE employee_no = ? ");
		sb.append(" AND e.address_no = a.address_no; ");
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			ps.setInt(1, Integer.parseInt(request.getParameter("id")));
			rs = ps.executeQuery();
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
                    <td align="right">Address1</td>
                    <td align="left"><%=getNotAvailable(rs.getString("address1"))%></td> 
                </tr>   
                <tr>
                    <td align="right">Address2</td>
                    <td align="left"><%=getNotAvailable(rs.getString("address2"))%></td>
                </tr>
                <tr>
                    <td align="right">City</td>
                    <td align="left"><%=rs.getString("city")%></td>
                </tr>
                <tr>
                    <td align="right">Province</td>
                    <td align="left"><%=rs.getString("province")%></td>
                </tr>
                <tr>
                    <td align="right">Country</td>
                    <td align="left"><%=rs.getString("country")%></td>
                </tr>
                <tr>
                    <td align="right">Postal Code</td>
                    <td align="left"><%=rs.getString("postal_code")%></td>
                </tr>
                <tr>
                    <td align="right">E-mail</td>
                    <td align="left"><%=rs.getString("email")%></td>
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
            <table>
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
        </div>
        <div>
            <table>
                <tr>
                    <td>
                        Service Name
                    </td>
                    <td>
                        Descritpion
                    </td>
                    <td>
                        Duration
                    </td>
                    <td>
                        Price
                    </td>
                </tr>
                <%
		sb = new StringBuilder();
		sb.append(" SELECT s.name, s.description,    ");
		sb.append(" s.duration, s.price, s.enabled  ");
		sb.append(" FROM employee e, service s, employeeservice es ");
                sb.append(" WHERE e.employee_no = ?  ");
                sb.append(" AND e.employee_no = es.employee_no ");
                sb.append(" AND es.service_no = s.service_no  ");
                sb.append(" AND s.enabled = true  ");
                sb.append(" ORDER BY s.service_no; ");
		conn = null;
		rs = null;
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			ps.setInt(1, Integer.parseInt(request.getParameter("id")));
			rs = ps.executeQuery();
			while (rs.next()) {
                %>
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
            <input type="button" size=20 value="Print this page"
                   onclick="window.print();return false;" />&nbsp;&nbsp;
            <input type="button" size=20 value="Close Window"
                   onclick="window.close();return false;" />
        </div>
    </body>
</html>
