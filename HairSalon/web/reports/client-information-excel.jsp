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
<%@page import="java.sql.*" %>
<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.persistence.*" %>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<%
		response.setContentType("application/vnd.ms-excel; charset=utf-8");
		response.setHeader("Content-Disposition", "attachment;filename=export_client_data.xls");
%>
<%!
	/**
	 * This class return a blank string if the string input is null.
	 *
	 * @param input a string of input value to be check.
	 * @return the modify input value if necessary.
	 */
	private String getEmptyString(String input) {
		if (input == null) {
			return "";
		} else {
			return input;
		}
	}

	/**
	 * This class modifies the address string if it is null or blank.
	 *
	 * @param input a string for address to be modified.
	 * @return the modified value.
	 */
	private String getNotAvailable(String input) {
		if ((input == null) || (input.equals(""))) {
			return "Not Available";
		} else {
			return input;
		}
	}

	/**
	 * This class modify the string value to a currency string value.
	 *
	 * @param input a string value to be modified to a currency string value.
	 * @return the modified value.
	 */
	private String getCurrencyFormat(String input) {
		try {
			double num = Double.parseDouble(input);
			DecimalFormat dcf = (DecimalFormat) NumberFormat.getCurrencyInstance();
			String formattedValue = dcf.format(num);
			return formattedValue;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * This class modify the string value to a phone number format.
	 *
	 * @param input a string value to be modified to a phone number format.
	 * @return the modified value.
	 */
	private String getPhoneNumberFormat(String input) {
		try {
			return "(" + input.substring(0, 3) + ") " + input.substring(3, 6) +
					"-" + input.substring(6, 10);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * This class modify the string value to a postal code format.
	 *
	 * @param input a string value to be modified to a postal code format.
	 * @return the modified value.
	 */
	private String getPostalCodeFormat(String postCode) {
		try {
			return postCode.substring(0, 3) + "-" + postCode.substring(3, 6);
		} catch (Exception e) {
			return null;
		}
	}

%>

<%
//Define Available
		Connection conn = null;     //SQL connector var.

		ResultSet rs = null;        //SQL result set var.

		int rsCount = 0;            //Result set row count.

		StringBuilder sb = null;    //String builder for SQL statement.

//Helper Variables for parameter values.
		String fName = request.getParameter("FirstName");
		if (fName != null) {
			if (fName.equals("")) {
				fName = null;
			}
		}
		String lName = request.getParameter("LastName");
		if (lName != null) {
			if (lName.equals("")) {
				lName = null;
			}
		}
		String phoneNum = request.getParameter("PhoneNum");
		if (phoneNum != null) {
			if (phoneNum.equals("")) {
				phoneNum = null;
			}
		}
		String pCode = request.getParameter("PostalCode");
		if (pCode != null) {
			if (pCode.equals("")) {
				pCode = null;
			}
		}
%>
<html>
    <%--Page Header--%>
    <head>
        <title>Client Information Report</title>
    </head>
    <%--Page Content--%>
    <body>
        <%--Report Header--%>
        <h3>Client Information Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        <%--Table column headers.--%>
        <table border=1 width="900">
            <tr>
                <td align="center" width="15%"><b>Name</b></td>
                <td align="center" width="10%"><b>Phone number</b></td>
                <td align="center" width="20%"><b>Address1</b></td>
                <td align="center" width="15%"><b>Address2</b></td>
                <td align="center" width="10%"><b>City</b></td>
                <td align="center" width="5%"><b>Province</b></td>
                <td align="center" width="10%"><b>Country</b></td>
                <td align="center" width="5%"><b>Postal-Code</b></td>
                <td align="center" width="10%"><b>E-mail</b></td>
            </tr>
            <%
		//Initialize variable to store the SQL statement.
		sb = new StringBuilder();
		sb.append(" SELECT c.first_name, c.last_name, ");
		sb.append(" c.phone_number, a.address1, a.address2, ");
		sb.append(" a.city, a.province, a.country, ");
		sb.append(" a.postal_code, a.email ");
		sb.append(" FROM client c, address a ");
		sb.append(" WHERE c.address_no = a.address_no ");
		if (fName != null) {
			sb.append(" And c.first_name LIKE CONCAT('%', ? ,'%')");
		}
		if (lName != null) {
			sb.append(" And c.last_name LIKE CONCAT('%', ? ,'%')");
		}
		if (phoneNum != null) {
			sb.append(" And c.phone_number LIKE CONCAT('%', ? ,'%')");
		}
		if (pCode != null) {
			sb.append(" And a.postal_code LIKE CONCAT('%', ? ,'%')");
		}
		sb.append(" AND c.enabled = true ");
		sb.append(" ORDER BY client_no; ");

		try {
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			int index = 1;
			if (fName != null) {
				ps.setString(index, fName);
				index++;
			}
			if (lName != null) {
				ps.setString(index, lName);
				index++;
			}
			if (phoneNum != null) {
				ps.setString(index, phoneNum);
				index++;
			}
			if (pCode != null) {
				ps.setString(index, pCode);
				index++;
			}
			rs = ps.executeQuery();  //Execute the query statement.

			//While there is a row of data from the result set.
			while (rs.next()) {
				rsCount++;  //Increment the result set row count.
%>
            <tr>
                <td align="left" width="15%"><%=rs.getString("first_name")%>
                &nbsp;<%=rs.getString("last_name")%></td>
                <td align="left" width="10%">
                <%=getPhoneNumberFormat(rs.getString("phone_number"))%></td>
                <td align="left" width="20%">
                <%=getNotAvailable(rs.getString("address1"))%></td>
                <td align="left" width="15%">
                <%=getNotAvailable(rs.getString("address2"))%></td>
                <td align="left" width="10%">
                <%=rs.getString("city")%></td>
                <td align="left" width="5%">
                <%=rs.getString("province")%></td>
                <td align="left" width="10%">
                <%=rs.getString("country")%></td>
                <td align="center" width="5%">
                <%=getPostalCodeFormat(rs.getString("postal_code"))%></td>
                <td align="left" width="10%">
                <%=rs.getString("email")%></td>
            </tr>
            <%	}

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
    </body>
</html>
