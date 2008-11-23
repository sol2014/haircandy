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
<%@ page errorPage="/reports/report-error.jsp?from=client-information.jsp" %>

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
		double num = Double.parseDouble(input);
		DecimalFormat dcf = (DecimalFormat) NumberFormat.getCurrencyInstance();
		String formattedValue = dcf.format(num);
		return formattedValue;
	}

	/**
	 * This class modify the string value to a phone number format.
	 *
	 * @param input a string value to be modified to a phone number format.
	 * @return the modified value.
	 */
	private String getPhoneNumberFormat(String phone) {
		return "(" + phone.substring(0, 3) + ") " + phone.substring(3, 6) +
				"-" + phone.substring(6, 10);
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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
//Define vailables.
		Connection conn = null;     //SQL connector var.

		ResultSet rs = null;        //SQL result set var.

		int rsCount = 0;            //Result set row count.

		StringBuilder sb = null;    //String builder for SQL statement.

//Helper Variables for parameter values.
String fName = request.getParameter("FirstName");
String lName = request.getParameter("LastName");
String phoneNum = request.getParameter("PhoneNum");
String pCode = request.getParameter("PostalCode");
%>
<html>
    <%--Page Header--%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Client Information Report</title>
    </head>
    
    <%--Page Content--%>
    <body>
        <%--Report Header--%>
        <h3>Client Information Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        
        <div>
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
		//Store SQL statement for query.
		sb.append(" SELECT c.first_name, c.last_name, ");
		sb.append(" c.phone_number, a.address1, a.address2, ");
		sb.append(" a.city, a.province, a.country, ");
		sb.append(" a.postal_code, a.email ");
		sb.append(" FROM client c, address a ");
		sb.append(" WHERE c.address_no = a.address_no ");
		sb.append(" AND c.enabled = true ");
		sb.append(" ORDER BY client_no; ");

		try {
			//Create a connection to the database from the connection pool.
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			//Prepare the statement to query the database.
			PreparedStatement ps = conn.prepareStatement(sb.toString());
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
                    <%=getNotAvailable(rs.getString("city"))%></td>
                    <td align="left" width="5%">
                    <%=getNotAvailable(rs.getString("province"))%></td>
                    <td align="left" width="10%">
                    <%=getNotAvailable(rs.getString("country"))%></td>
                    <td align="center" width="5%">
                    <%=getNotAvailable(getPostalCodeFormat(rs.getString("postal_code")))%></td>
                    <td align="left" width="10%">
                    <%=getNotAvailable(rs.getString("email"))%></td>
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
        </div><br/>
        <%--Display the row count result.--%>
        <%if (rsCount == 0) {%>
        There is no result return!  Please try again.<br/>
        <%} else {%>
        There are <%=rsCount%> result(s) in the list.<br/>
        You can click on the transaction number to view the detail.<br/>
        <%}%>
        <br/>
        <%
		//Set the URL link parameters for the input buttons.
		String params = "";

		//Set the URL page name for the export excel input buttons.
		String excelURL = "client-information-excel.jsp" + params;
		//Set the URL page name for the print report input buttons.
		String printURL = "client-information-print.jsp" + params;
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
    </body>
</html>
