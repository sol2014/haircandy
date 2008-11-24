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
<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="hs.persistence.*" %>

<%-- Load the tag library files. --%>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<%-- JSP Directives --%>
<%--<%@ page errorPage="/reports/report-error.jsp?from=client-information.jsp" %>--%>

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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Client Information Report</title>
    </head>
    
    <%--Javasript Functions.--%>
    <script type="text/javascript">
        /*
         * This function to either hide or display text and input text field
         * depend on the date type select.
         */
        function hideOrDisplay()
        {
            //For all query, hide the input field table.
            if(document.getElementById("QueryType").checked)
            {
                document.getElementById("SearchInput").style.display = "none";
            }//For custom query, show the input field table.
            else
            {
                document.getElementById("SearchInput").style.display = "inline";
            }
        }
        -->
    </script>    
    
    <%--Page Content--%>
    <body>
        <%--Report Header--%>
        <h3>Client Information Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4>
        
        <%--Form for user input to query the report desired by the user.--%>
        <form name="QueryInput" action="client-information.jsp">
            Query type:&nbsp;
            <%--Radio buttons to select the query type to query the report.
                Initial call to select the proper radio button depend on 
                previous select, default selection is all.--%>
            <%
		String queryType = request.getParameter("QueryType");
		if (queryType != null) {
            %>
            <%if (queryType.equals("All")) {%>
            <input id="QueryType" type="radio" name="QueryType" value="All" 
                   onclick="hideOrDisplay()" checked="checked" />All&nbsp;&nbsp;
            <input type="radio" name="QueryType" value="Custom" 
                   onclick="hideOrDisplay()"/>Custom&nbsp;&nbsp;
            <%} else if (queryType.equals("Custom")) {%>
            <input id="QueryType" type="radio" name="QueryType" value="All" 
                   onclick="hideOrDisplay()"/>All&nbsp;&nbsp;
            <input type="radio" name="QueryType" value="Custom" 
                   onclick="hideOrDisplay()" checked="checked" />Custom&nbsp;&nbsp;
            <%}
			} else {%>
            <input id="QueryType" type="radio" name="QueryType" value="All" 
                   onclick="hideOrDisplay()" checked="checked" />All&nbsp;&nbsp;
            <input type="radio" name="QueryType" value="Custom" 
                   onclick="hideOrDisplay()"/>Custom&nbsp;&nbsp;
            <%}%>
            <br/><br/>
            <%--Input text field to collect person's first and last name for 
            query the report.--%>
            <table id="SearchInput">
                <tr>
                    <td align="right" >First Name:</td>
                    <td align="left">
                        <input type="text" value="<%=getEmptyString(fName)%>" 
                           size=20 name="FirstName" /></td>
                </tr>
                <tr>
                    <td align="right" >Last Name:</td>
                    <td align="left">
                        <input type="text" value="<%=getEmptyString(lName)%>" 
                           size=20 name="LastName" /></td>
                </tr>
                <tr align="right" >
                    <td>Phone Number:</td>
                    <td align="left">
                        <input type="text" value="<%=getEmptyString(phoneNum)%>" 
                           size=20 name="PhoneNum" /></td>
                </tr>
                <tr>
                    <td align="right">Postal Code:</td>
                    <td align="left">
                        <input type="text" value="<%=getEmptyString(pCode)%>" 
                           size=8 name="PostalCode" /></td>
                </tr>
            </table><br/>
            
            <%--Search button to submit data.--%>
            <input type="submit" value="Search" class="StandardButton" >
            &nbsp;&nbsp;&nbsp;
            <%--Reset button to clear all input fields and reset all 
                list/buttons.--%>
            <%--
            <input type="button" value="Reset Fields" onclick=""class="StandardButton" >
            --%><br/><br/>        
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
			rs = ps.executeQuery();
			while (rs.next()) {
				rsCount++;
                    %>
                    <tr>
                        <td align="left" width="15%"><%=rs.getString("first_name")%>
                        &nbsp;<%=rs.getString("last_name")%></td>
                        <td align="left" width="10%"><%=getPhoneNumberFormat(rs.getString("phone_number"))%></td>
                        <td align="left" width="20%"><%=getNotAvailable(rs.getString("address1"))%></td>
                        <td align="left" width="15%"><%=getNotAvailable(rs.getString("address2"))%></td>
                        <td align="left" width="10%"><%=rs.getString("city")%></td>
                        <td align="left" width="5%"><%=rs.getString("province")%></td>
                        <td align="left" width="10%"><%=rs.getString("country")%></td>
                        <td align="center" width="5%"><%=getPostalCodeFormat(rs.getString("postal_code"))%></td>
                        <td align="left" width="10%"><%=rs.getString("email")%></td>
                    </tr>
                    <%	}

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
		String params = request.getQueryString();

		String excelURL = "client-information-excel.jsp";
		if (params != null) {
			excelURL += "?" + params;
		}
		String printURL = "client-information-print.jsp";
		if (params != null) {
			printURL += "?" + params;
		}
            %>
            <div> 
                <a href="<%=excelURL%>">excel</a>
                <input type="button" value="Export Excel" class="StandardButton" 
                       onclick="window.open('<%=excelURL%>', '_blank');return false;" />&nbsp;&nbsp;&nbsp;           
                <input type="button" value="Print this page" class="StandardButton" 
                       onclick="window.open('<%=printURL%>', '_blank');return false;" />&nbsp;&nbsp;&nbsp;
                <input type="button" value="Back to Main" class="StandardButton" 
                       onclick="window.open('report-main-menu.jsp');return false;" /><br/>
            </div>
            <script>
                hideOrDisplay();
            </script>
        </form>
    </body>
</html>
