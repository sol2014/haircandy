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
		ResultSet rs = null;
		StringBuilder sb = null;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Schedule information report</title>
    </head>
    <body>
        <form action="schedule-information.jsp">
            <%
		String employeeNo = request.getParameter("EmployeeNo");
		if (employeeNo == null) {
			employeeNo = "0";
		}
		String beginDate = request.getParameter("BeginDate");
		String endDate = request.getParameter("EndDate");
		sb = new StringBuilder();
		sb.append(" SELECT *  ");
		sb.append(" FROM employee e ");
		sb.append(" WHERE e.enabled = true ");
		sb.append(" ORDER BY e.employee_no; ");
            %>
            <div>
                <select name="EmployeeNo">
                    <option value="0" >All</option>
                    <%
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString("employee_no").equals(employeeNo)) {
                    %>
                    <option value="<%=rs.getInt("employee_no")%>" selected><%=rs.getString("first_name")%> <%=rs.getString("last_name")%></option>
                    <%			} else {
                    %>
                    <option value="<%=rs.getInt("employee_no")%>"><%=rs.getString("first_name")%> <%=rs.getString("last_name")%></option>
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
            <div>
                <table>
                    <tr>
                        <td>
                            First name
                        </td>
                        <td>
                            Last name
                        </td>
                        <td>
                            Date
                        </td>
                        <td>
                            Start Time
                        </td>
                        <td>
                            End Time
                        </td>
                    </tr>
                    <%
		sb = new StringBuilder();
		sb.append(" SELECT e.employee_no, e.first_name, e.last_name, ");
		sb.append(" sh.date, sh.start_time, sh.end_time ");
		sb.append(" FROM employee e, schedule sh ");
		sb.append(" WHERE e.employee_no = sh.employee_no ");
		if (!employeeNo.equals("0")) {
			sb.append(" AND e.employee_no = ? ");
		}
		sb.append(" AND sh.date BETWEEN ? AND ? ");
		sb.append(" ORDER BY sh.date; ");
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			int index = 1;
			if (!employeeNo.equals("0")) {
				ps.setInt(index, Integer.parseInt(employeeNo));
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
                        <td><%=rs.getString("first_name")%></td>
                        <td><%=rs.getString("last_name")%></td>
                        <td><%=rs.getString("date")%></td>
                        <td><%=rs.getString("start_time")%></td>
                        <td><%=rs.getString("end_time")%></td>
                    </tr>
                    <%			}

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
                <%--
                <input type="button" size=20 value="Export Excel"
                       onclick="window.open('schedule-information-excel.jsp?EmployeeNo=<%=employeeNo%>&BeginDate=<%=beginDate%>&EndDate=<%=endDate%>', '_blank');" />&nbsp;&nbsp;&nbsp;
                --%>
                <input type="button" size=20 value="Print this page"
                       onclick="window.print();return false;" />
            </div>
        </form>
    </body>
</html>
