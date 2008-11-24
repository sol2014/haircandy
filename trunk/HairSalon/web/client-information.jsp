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
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="hs.persistence.*" %>

<%-- Load the tag library files. --%>
<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%
		UserSession userSession = (UserSession) session.getAttribute("user_session");

		userSession.setCurrentPosition(SessionPositions.Reports);

		String page_title = "Client information";
		int recordNo = 0;
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
<%@ include file="WEB-INF/jspf/header.jspf" %>
<%
//Define Available
		Connection conn = null;     //SQL connector var.

		ResultSet rs = null;        //SQL result set var.

		int rsCount = 0;            //Result set row count.

		StringBuilder sb = null;    //String builder for SQL statement.

//Helper Variables for parameter values.
		String queryType = request.getParameter("QueryType");
		if(queryType==null){
			queryType = "All";
		}
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
<%--Report Header--%>
<h3>Client Information Report</h3>
<%--Display the current date--%>
<h4>Date:  <taglib:datetime/> </h4>

<%--Form for user input to query the report desired by the user.--%>
<form name="QueryInput" action="client-information.jsp">
    Query type:&nbsp;
    <%--Radio buttons to select the query type to query the report.
                Initial call to select the proper radio button depend on 
                previous select, default selection is All.--%>
    <%
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
                   size=22 name="FirstName" /></td>
        </tr>
        <tr>
            <td align="right" >Last Name:</td>
            <td align="left">
                <input type="text" value="<%=getEmptyString(lName)%>" 
                   size=22 name="LastName" /></td>
        </tr>
        <tr align="right" >
            <td>Phone Number:</td>
            <td align="left">
                <input type="text" value="<%=getEmptyString(phoneNum)%>" 
                   size=15 name="PhoneNum" />&nbsp;Ex: 1234567890</td>
        </tr>
        <tr>
            <td align="right">Postal Code:</td>
            <td align="left">
                <input type="text" value="<%=getEmptyString(pCode)%>" 
                   size=8 name="PostalCode" />&nbsp;Ex: t2e3r3</td>
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
		//Initialize variable to store the SQL statement.   
		sb = new StringBuilder();
		//Store SQL statement for query.
		sb.append(" SELECT c.first_name, c.last_name, ");
		sb.append(" c.phone_number, a.address1, a.address2, ");
		sb.append(" a.city, a.province, a.country, ");
		sb.append(" a.postal_code, a.email ");
		sb.append(" FROM client c, address a ");
		sb.append(" WHERE c.address_no = a.address_no ");

		if (queryType.equals("Custom")) {
			/*Insert SQL statement when detected user input.*/
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
		}
		sb.append(" AND c.enabled = true ");
		sb.append(" ORDER BY client_no; ");

		try {
			//Create a connection to the database from the connection pool.
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			//Prepare the statement to query the database.
			PreparedStatement ps = conn.prepareStatement(sb.toString());
			int index = 1;  //index for ? search field.

			if (queryType.equals("Custom")) {
				/*Insert the value into the ? search field.*/
				if (fName != null) {
					ps.setString(index, fName);
					index++;  //Increment to the next ? location

				}
				if (lName != null) {
					ps.setString(index, lName);
					index++;  //Increment to the next ? location

				}
				if (phoneNum != null) {
					ps.setString(index, phoneNum);
					index++;  //Increment to the next ? location

				}
				if (pCode != null) {
					ps.setString(index, pCode);
					index++;  //Increment to the next ? location

				}
			}
			rs = ps.executeQuery();
			while (rs.next()) {
				rsCount++;  //Increment to the next ? location
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
				//Return connection to the connection pool.
				MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
			}

			if (rs != null) {
				//Close and result the result set storage variable.
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
		//Set the URL link parameters.
		String params = request.getQueryString();
		//Set the URL page name for the export excel.
		String excelURL = "reports/client-information-excel.jsp";
		if (params != null) {
			excelURL += "?" + params;
		}
		//Set the URL page name for the print report.
		String printURL = "reports/client-information-print.jsp";
		if (params != null) {
			printURL += "?" + params;
		}
    %>
    <%--Links for additional report commends.--%>
    <div>
        <%--Link for export report to an excel file.--%>
        <a href="<%=excelURL%>">Export To Excel</a>
        &nbsp;&nbsp;&nbsp;
        <%--Link  to send the report a printer.--%>
        <a href="<%=printURL%>" target="_blank">Print this page</a><br/>
    </div>
    <%--Calls javascript function to do the initial setup of the page.--%>
    <script>
        hideOrDisplay();
    </script>
</form>
<%@ include file="WEB-INF/jspf/footer.jspf" %>