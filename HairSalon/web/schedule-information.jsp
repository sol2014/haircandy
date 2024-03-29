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

		String page_title = "Schedule information report";
		int recordNo = 0;
%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
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
     * This class trims the time value and return the date portion only.
     *
     * @param value a string time value to be trimmed.
     * @return the modified value.
     */
    private String trimTimeValue(String value) {
        return value.substring(0, 5);
    }
%>
<%
            //Define Available
            Connection conn = null;     //SQL connector var.                
            ResultSet rs = null;        //SQL result set var.                
            int rsCount = 0;            //Result set row count.                
            StringBuilder sb = null;    //String builder for SQL statement.
            
            //Helper Variables for parameter values.
            String employeeNo = request.getParameter("EmployeeNo");
            String beginDate = request.getParameter("BeginDate");
            String endDate = request.getParameter("EndDate");
%>
    <%--Javasript Functions.--%>
    <script type="text/javascript">
        <!--      
        /*
         *  This function to have the cursor start at the supplier name
         *  drop down box when called, Then call the hide or display function.
         **/
        function selectTextField() {
            document.QueryInput.EmployeeNo.focus();
        }
        -->
    </script>
        <%--Report Header--%>
        <h3>Schedule Information Report</h3>
        <%--Display the current date--%>
        <h4>Date:  <taglib:datetime/> </h4> 
        
        <form name="QueryInput" action="schedule-information.jsp">
            <%
                //Initialize employee number.
		if (employeeNo == null) {
			employeeNo = "0";
		}
                //Initialize variable to store the SQL statement.
		sb = new StringBuilder();
                //Store SQL statement for query.
		sb.append(" SELECT *  ");
		sb.append(" FROM employee e ");
		sb.append(" WHERE e.enabled = true ");
		sb.append(" ORDER BY e.employee_no; ");
            %>
            <div>
                <%--Drop down box to collect the employee number for query the 
                report. Javascript function called to select the proper 
                option, default selection is 0. --%>
                Select Employee:&nbsp;
                <select name="EmployeeNo">
                    <option value="0" >All</option>
                    <%
		try {
                    //Create a connection to the database from the connection pool.
                    conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                    //Prepare the statement to query the database.
                    PreparedStatement ps = conn.prepareStatement(sb.toString());
                    rs = ps.executeQuery();//Execute the query statement.

                    //Build the drop down list with the result set values.
                    while (rs.next()) {
                        //Check if the employee is previously selected.
                        if (rs.getString("employee_no").equals(employeeNo)) {
                %>
                <option value="<%=rs.getInt("employee_no")%>" selected>
                <%=rs.getString("first_name")%> <%=rs.getString("last_name")%></option>
                <% } else { %>
                <option value="<%=rs.getInt("employee_no")%>">
                <%=rs.getString("first_name")%> <%=rs.getString("last_name")%></option>
                <%
                        }
                    }

		} catch (Exception e) {
		} finally {
			if (conn != null) {
                            //Check if the service is previously selected.
                            MultithreadedJDBCConnectionPool.getConnectionPool().returnConnection(conn);
			}
			if (rs != null) {
                            //Close and result the result set storage variable.
                            rs.close();
                            rs = null;
			}
		}%>
            </select><br/><br/>
            
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
            
            Date range (yyyy-mm-dd to yyyy-mm-dd): <br/>
            From:&nbsp;<input onblur="changeDateFormat(this)" id="beginDate" type="text" value="<%=getEmptyString(beginDate)%>"
                              size=15 name="BeginDate">
            To:&nbsp;<input onblur="changeDateFormat(this)" id="endDate" type="text" value="<%=getEmptyString(endDate)%>" 
                            size=15 name="EndDate">&nbsp;&nbsp;
                <%
            //Reload the date value to the variable.
            beginDate = request.getParameter("BeginDate");
            endDate = request.getParameter("EndDate");
            
            //Modify begin date variable if no user input.
            if (beginDate == null || beginDate.equals("")) {
                    beginDate = "1900-01-01";
            }
            //Modify end date variable if no user input.
            if (endDate == null || endDate.equals("")) {
                    endDate = "2100-01-01";
            }
                %>
            <br/><br/><input type="submit" value="Search">
            </div>
            
            <div>          
            <%--Table column headers.--%>
            <table border=1 width="500">
                <tr>
                    <td align="center" width="40%"><b>Name</b></td>
                    <td align="center" width="20%"><b>Date</b></td>
                    <td align="center" width="20%"><b>Start Time</b></td>
                    <td align="center" width="20%"><b>End Time</b></td>  
                </tr>

                    <%
                //Initialize variable to store the SQL statement.
		sb = new StringBuilder();
                //Store SQL statement for query.
		sb.append(" SELECT e.employee_no, e.first_name, e.last_name, ");
		sb.append(" sh.date, sh.start_time, sh.end_time ");
		sb.append(" FROM employee e, schedule sh ");
		sb.append(" WHERE e.employee_no = sh.employee_no ");
                //If an individual employee is chosen, execute the statement.
                if ((!employeeNo.equals("")) && (employeeNo != null) && (!employeeNo.equals("0")))
                {
			sb.append(" AND e.employee_no = ? ");
		}
		sb.append(" AND sh.date BETWEEN ? AND ? ");
		sb.append(" ORDER BY sh.date; ");
                
		try {
                    //Create a connection to the database from the connection pool.
                    conn = MultithreadedJDBCConnectionPool.getConnectionPool().getConnection();
                    //Prepare the statement to query the database.
                    PreparedStatement ps = conn.prepareStatement(sb.toString());
                    int index = 1;  //index for ? search field.
                    //Insert the employee number to the query statement.
                    if ((!employeeNo.equals("")) && (employeeNo != null) && (!employeeNo.equals("0")))
                    {
                            ps.setInt(index, Integer.parseInt(employeeNo));
                            index++;
                    }
                    //Create a time format for date object.  
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    //set time stamp for begin date search field.
                    ps.setTimestamp(index, new Timestamp((df.parse(beginDate)).getTime()));
                    index++;    //Increment to the next ? location
                    //set time stamp for begin date search field.
                    ps.setTimestamp(index, new Timestamp((df.parse(endDate)).getTime()));
                    index++;  //Increment to the next ? location
                    rs = ps.executeQuery(); //Execute the query statement.
                    
                    //While there is a row of data from the result set.
                    while (rs.next()) {
                    rsCount++;
                    %>
                    <tr>
                        <td align="left" width="40%"><%=rs.getString("first_name")%>&nbsp;
                        <%=rs.getString("last_name")%></td>                       
                        <td align="right" width="20%"><%=rs.getString("date")%></td>
                        <td align="right" width="20%">
                            <%=trimTimeValue(rs.getString("start_time"))%></td>
                        <td align="right" width="20%">
                            <%=trimTimeValue(rs.getString("end_time"))%></td>
                    </tr>
                    <%			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
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
            </div>
            <%--Display the row count result.--%>
            <%if (rsCount == 0) {%>
            There is no result return!<br/>
            <%} else {%>
            There are <%=rsCount%> result(s) in the list.<br/>
            <%}%>
            <br/>
            <%
            //Set the URL link parameters.
            String params = request.getQueryString();
            //Set the URL page name for the export excel.
            String excelURL = "schedule-information-excel.jsp";
            if (params != null) {
                excelURL += "?" + params;
            }
            //Set the URL page name for the print report.
            String printURL = "schedule-information-print.jsp";
            if (params != null) {
                printURL += "?" + params;
            }
                
                 //Reset begin date value.
                if (beginDate.equals("1900-01-01")) {
			beginDate = "";
		}
                //Reset end date value.
                if (endDate.equals("2100-01-01")) {
			endDate = "";
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
                selectTextField();
            </script>

        </form>
        
<%@ include file="WEB-INF/jspf/footer.jspf" %>
<%-- -------------------------------------------------- --%>
<script type="text/javascript">
    var beginCal, endCal;
    beginCal  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
    endCal  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
</script>
