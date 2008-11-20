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
		Connection conn2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		StringBuilder sb = null;
		StringBuilder sb2 = null;
%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Service Usage information report</title>
</head>
<body>
<form action="service-usage-information.jsp">
    <%
		String serviceNo = request.getParameter("ServiceNo");
		if (serviceNo == null) {
			serviceNo = "0";
		}
		String beginDate = request.getParameter("BeginDate");
		String endDate = request.getParameter("EndDate");
		sb = new StringBuilder();
		sb.append(" SELECT *  ");
		sb.append(" FROM service se ");
		sb.append(" WHERE se.enabled = true ");
		sb.append(" ORDER BY se.service_no; ");
    %>
    <div>
        <select name="ServiceNo">
            <option value="0" >All</option>
            <%
		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString("service_no").equals(serviceNo)) {
            %>
            <option value="<%=rs.getInt("service_no")%>"  selected><%=rs.getString("name")%></option>
            <%	} else {
            %>
            <option value="<%=rs.getInt("service_no")%>"><%=rs.getString("name")%> </option>
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
                Service Name
            </td>
            <td>
                Description
            </td>
            <td>
                Duration
            </td>
            <td>
                Total Usage
            </td>
        </tr>
        
        
        <%

		sb = new StringBuilder();
		sb.append(" SELECT sa.timestamp, se.service_no, se.name,");
		sb.append("  se.description, se.duration  ");
		sb.append(" FROM sale sa, saleservice ss, service se  ");
		sb.append(" WHERE se.service_no = ss.service_no ");
		if (!serviceNo.equals("0")) {
			sb.append(" AND se.service_no = ? ");
		}
		sb.append(" AND ss.transaction_no = sa.transaction_no ");
		sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
		sb.append(" ORDER BY sa.timestamp; ");

		try {
			conn2 = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn2.prepareStatement(sb.toString());
			int index = 1;
			if (!serviceNo.equals("0")) {
				ps.setInt(index, Integer.parseInt(serviceNo));
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
            <td><%=rs.getString("name")%></td>
            <td><%=rs.getString("description")%></td>
            <td><%=rs.getString("duration")%></td>
            <%
									sb2 = new StringBuilder();
									sb2.append(" SELECT COALESCE(SUM(ss.amount), 0) \"Total\" ");
									sb2.append(" FROM sale sa, saleservice ss, service se ");
									sb2.append(" WHERE se.service_no = ss.service_no ");
									sb2.append(" AND se.service_no = " + rs.getInt("service_no"));
									sb2.append(" AND ss.transaction_no = sa.transaction_no ");
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
        
        <input type="button" size=20 value="Print this page"
               onclick="window.print();return false;" />
    </div>
</form>
</body>
</html>

