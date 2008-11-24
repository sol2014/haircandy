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

		String page_title = "Product information report";
		int recordNo = 0;
%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<%!
	/**
	 * This class increment the end date from the begin date by number of
	 * date specified by the user.
	 *
	 * @param input a string for the date value to be increment.
	 * @param num an integer of number of date to be increment.
	 * @return the incremented date.
	 */
	private String endDatePlus(String input, int num) {
		String newDate = null;
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date date = df.parse(input);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.DATE, num);
			newDate = df.format(cal.getTime());
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return newDate;
	}

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
	 * This class initialize the date string if it is null or blank.
	 *
	 * @param input a string for the date value to be check.
	 * @return the modify date string if necessary.
	 */
	private String getDefaultDate(String input) {
		if (input == null || input.equals("")) {
			return "yyyy-mm-dd";
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
	private String getCurrencyFormat(String value) {
		double num = Double.parseDouble(value);
		DecimalFormat dcf = (DecimalFormat) NumberFormat.getCurrencyInstance();
		String formattedValue = dcf.format(num);
		return formattedValue;
	}

	/**
	 * This class trims the time stamp value and return the date portion only.
	 *
	 * @param input a string time stamp value to be trimmed.
	 * @return the modified value.
	 */
	private String trimTimeStamp(String value) {
		return value.substring(0, 11);
	}
%>
<%
//Define vailables
		Connection conn = null;     //SQL connector var.

		ResultSet rs = null;        //SQL result set var.

		int rsCount = 0;            //Result set row count.

		StringBuilder sb = null;    //String builder for SQL statement.

//Helper Variables for parameter values.
		String fName = request.getParameter("FirstName");
		String lName = request.getParameter("LastName");
		String beginDate = request.getParameter("BeginDate");
		String endDate = request.getParameter("EndDate");
%>  
<%--Javasript Functions.--%>
<script type="text/javascript">
    <!--      
    
    /*
     *  This function to have the cursor start at the First Name 
     *  text field when called, Then call the hide or display function.
     **/
    function selectTextField() {
        document.QueryInput.FirstName.focus();
        hideOrDisplay();
    }
        
    /*
     * This function to either hide or display text and input text field
     * depend on the date type select.
     */
    function hideOrDisplay()
    {
        //For single date type, hide the text and then enddate text field.
        if(document.getElementById("DateType").value=="Single")
        {
            document.getElementById("from").style.display = "none";
            document.getElementById("EndDate").style.display = "none";
            document.getElementById("to").style.display = "none";
            document.getElementById("at").style.display = "inline";
        }//For multiple date type, hide the text and show enddate text field.
        else if(document.getElementById("DateType").value=="Multiple")
        {
            document.getElementById("from").style.display = "inline";
            document.getElementById("EndDate").style.display = "inline";
            document.getElementById("to").style.display = "inline";
            document.getElementById("at").style.display = "none";
        }
    }
    -->
</script>
<%--Report Header--%>
<h3>Sale information report</h3>
<%--Display the current date--%>
<h4>Date:  <taglib:datetime/> </h4>

<%--Form for user input to query the report desired by the user.--%>
<form name="QueryInput" action="sale-information.jsp">
    Please select one of the following choice of search:
    <br/>
    <%--Radio buttons to select the person type to query the report.
                Initial call to select the proper radio button depend on 
                previous select, default selection is everyone.--%>
    <%if (request.getParameter("NameType").equals("client")) {%>
    <input type="radio" name="NameType" value="everyone" />
    Everyone &nbsp;&nbsp;
    <input type="radio" name="NameType" value="client" 
           checked="checked" /> Client &nbsp;&nbsp;
    <input type="radio" name="NameType" value="employee" /> 
    Employee <br/><br/>
    <%} else if (request.getParameter("NameType").equals("employee")) {%>
    <input type="radio" name="NameType" value="everyone" />
    Everyone &nbsp;&nbsp;
    <input type="radio" name="NameType" value="client" />
    Client &nbsp;&nbsp;
    <input type="radio" name="NameType" value="employee" 
           checked="checked" />Employee <br/><br/>
    <%} else {%>
    <input type="radio" name="NameType" value="everyone" 
           checked="checked" />Everyone &nbsp;&nbsp;
    <input type="radio" name="NameType" value="client" />
    Client &nbsp;&nbsp;
    <input type="radio" name="NameType" value="employee" />
    Employee <br/><br/>
    <%
	//Initialize helper variables.
	fName = null;
	lName = null;
}%>
    
    <%--Input text field to collect person's first and last name for 
    query the report.--%>
    Please provide the person's first and/or last name <br/>
    if you select search by client or employee:<br/>
    First Name:&nbsp;
    <input type="text" value="<%=getEmptyString(fName)%>" 
           size=20 name="FirstName" />&nbsp;
    Last Name:&nbsp;
    <input type="text" value="<%=getEmptyString(lName)%>" 
           size=20 name="LastName" /><br/><br/>
    
    <%--Drop down box to collect the date type for query the report.
                Javascript function called to display the proper text and 
    input text field, default selection is single. --%>
    Date Type:&nbsp;
    <select id="DateType" name="DateType" onchange="hideOrDisplay()">
        <%--Initial call to select the select the drop down box element 
                    previous select, default is single.--%>
        <%if (request.getParameter("DateType").equals("Single")) {%>
        <option value="Multiple" >Multiple</option>
        <option value="Single" SELECTED>Single</option>
        <%} else if (request.getParameter("DateType").equals("Multiple")) {%>
        <option value="Multiple" SELECTED>Multiple</option>
        <option value="Single" >Single</option>
        <%}%>

<%-- -------------------------------------------------- --%>
	<script>
            var current;
            function changeDateFormat(object)
            {
                current=object;
                window.setTimeout(resetDateFormat, 500, "JavaScript");
                return true;
            }
            function resetDateFormat()
            {
                try
                {
                    var array = current.value.split("/");
                    var dd = array[0];
                    var mm = array[1];
                    var yyyy = array[2];
                    current.value=yyyy+"-"+mm+"-"+dd;
                }
                catch(e)
                {
                }
            }
        </script>
        
        <%--Input text fields for start and end date information.--%>    
    </select>&nbsp;
    <span id="from">From:&nbsp;</span><span id="at">At:&nbsp;</span>
    <input onblur="changeDateFormat(this)" id="beginDate" type="text" 
           value="<%=getDefaultDate(beginDate)%>" size=15  name="BeginDate" 
           onclick="select()" />&nbsp;
    <span id="to">To:&nbsp;</span><input id="endDate" onblur="changeDateFormat(this)" type="text" 
                                         value="<%=getDefaultDate(endDate)%>" size=15 name="EndDate"
                                         onclick="select()" /><br/><br/>
    
    <%
		//Modify begin date variable if no user input.
		if (beginDate == null || beginDate.equals("") || beginDate.equals("yyyy-mm-dd")) {
			beginDate = "1900-01-01";
		}
		//Modify end date variable if no user input.
		if (endDate == null || endDate.equals("") || endDate.equals("yyyy-mm-dd")) {
			endDate = "2100-01-01";
		}
		//Modify end date variable if user select a single date to query.
		if (request.getParameter("DateType").equals("Single")) {
			endDate = endDatePlus(beginDate, 1);
		}
    %>
    
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
        <table border=1 width="700">
            <tr>
                <td align="center" width="10%"><b>Transaction No</b></td>
                <td align="center" width="10%"><b>Date</b></td>
                <td align="center" width="20%"><b>Client Name</b></td>
                <td align="center" width="20%"><b>Employee Name</b></td>                    
                <td align="center" width="15%"><b>Payment Due</b></td>
                <td align="center" width="10%"><b>Sale Tax</b></td>
                <td align="center" width="15%"><b>Amount Paid</b></td>
            </tr>
            <%
		//Initialize variable to store the SQL statement.
		sb = new StringBuilder();
		//Store SQL statement for query.
		sb.append(" SELECT sa.transaction_no, cl.first_name, ");
		sb.append(" cl.last_name, em.first_name, em.last_name, ");
		sb.append(" sa.payment_type, sa.total_due, sa.total_tax, ");
		sb.append(" sa.payment, sa.timestamp ");
		sb.append(" FROM Sale sa, Client cl, Employee em ");
		sb.append(" WHERE sa.client_no = cl.client_no ");
		sb.append(" AND sa.employee_no = em.employee_no ");

		//Insert SQL statement for search with client name.
		if (request.getParameter("NameType").equals("client")) {
			if (!(fName == null) && !(fName.equals(""))) {
				sb.append(" AND cl.first_name = '" + fName + "' ");
			}
			if (!(lName == null) && !(lName.equals(""))) {
				sb.append(" AND cl.last_name = '" + lName + "' ");
			}
		}//Insert SQL statement for search with employee name.
		else if (request.getParameter("NameType").equals("employee")) {
			if (!(fName == null) && !(fName.equals(""))) {
				sb.append(" AND em.first_name = '" + fName + "' ");
			}
			if (!(lName == null) && !(lName.equals(""))) {
				sb.append(" AND em.last_name = '" + lName + "' ");
			}
		}
		sb.append(" AND sa.timestamp BETWEEN ? AND ? ");
		sb.append(" ORDER BY sa.transaction_no; ");

		try {
			//Create a connection to the database from the connection pool.
			conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
			//Prepare the statement to query the database.
			PreparedStatement ps = conn.prepareStatement(sb.toString());

			int index = 1;  //index for ? search field.

			//Create a time format for date object.
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			//set time stamp for begin date search field.
			ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
			index++;  //Increment to the next ? location
			//set time stamp for begin date search field.

			ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
			index++;  //Increment to the next ? location

			rs = ps.executeQuery();  //Execute the query statement.

			//While there is a row of data from the result set.
			while (rs.next()) {
				rsCount++;  //Increment the result set row count.
%>
            <%--Table row elements.--%>
            <tr>
                <td align="center" width="10%">
                    <a href="reports/transaction-details.jsp?id=<%=rs.getString("sa.transaction_no")%>" 
                   size=20 target="_blank"><%=rs.getString("sa.transaction_no")%></a></td>
                <td align="center" width="10%">
                <%=trimTimeStamp(rs.getString("sa.timestamp"))%></td>
                <td align="left" width="20%">
                    <%=rs.getString("cl.first_name")%>&nbsp;
                <%=rs.getString("cl.last_name")%></td>
                <td align="left" width="20%">
                    <%=rs.getString("em.first_name")%>&nbsp;
                <%=rs.getString("em.last_name")%></td>
                <td align="right" width="15%">
                    <%=getCurrencyFormat(rs.getString("sa.total_due"))%>
                </td>
                <td align="right" width="10%">
                    <%=getCurrencyFormat(rs.getString("sa.total_tax"))%>
                </td>
                <td align="right" width="15%">
                    <%=getCurrencyFormat(rs.getString("sa.payment"))%>
                </td>
            </tr>
            <%}
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
    </div>
    <%--Display the row count result.--%>
    <%if (rsCount == 0) {%>
    There is no result return!  Please try again.<br/>
    <%} else {%>
    There are <%=rsCount%> result(s) in the list.<br/>
    Click the transaction number to view the detail.<br/>
    <br/><%}%>
    <%
		//Set the URL link parameters for the input buttons.
		String params = "?NameType=" + request.getParameter("NameType") +
				"&FirstName=" + fName + "&LastName=" + lName +
				"&DateType=" + request.getParameter("DateType") +
				"&BeginDate=" + beginDate + "&EndDate=" + endDate;

		//Set the URL page name for the export excel input buttons.
		String excelURL = "reports/sale-information-excel.jsp" + params;
		//Set the URL page name for the print report input buttons.
		String printURL = "reports/sale-information-print.jsp" + params;
    %>
    <%--Links for additional report commends.--%>
    <div>
        <%--Link for export report to an excel file.--%>
        <a href="<%=excelURL%>">Export To Excel</a>
        &nbsp;&nbsp;&nbsp;
        <%--Link  to send the report a printer.--%>
        <a href="<%=printURL%>" target="_blank">Print this page</a><br/>
    </div>
</form>   
<script>
    selectTextField();
</script>
<%@ include file="WEB-INF/jspf/footer.jspf" %>

<%-- -------------------------------------------------- --%>
<script type="text/javascript">
    var beginCal, endCal;
    beginCal  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
    endCal  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
</script>