<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="hs.core.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>

<%!
    private int getTotalDaysOfGivenMonth(int year, int month) {
        int[] daysInMonths = new int[]{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if (month == 1) {
            if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))) {
                return 28;
            } else {
                return 29;
            }
        } else {
            return daysInMonths[month];
        }
    }
%>

<%

// Now here I want to grab all the data about the schedule right now.

String yearS = request.getParameter("year");
String monthS = request.getParameter("month");
int year = Integer.parseInt(yearS);
int month = Integer.parseInt(monthS);

Date date2 = CoreTools.getDate ("01/"+(month+1)+"/"+year);
SimpleDateFormat sdf2 = new SimpleDateFormat(CoreTools.MonthYearFormat);

Calendar calendar = Calendar.getInstance();
calendar.set(year, month, 1);
int weekDayOfFirstDayOfTheGivenMonth = calendar.get(Calendar.DAY_OF_WEEK) - 1;
int dayIndexOfTheGivenMonth = 0;
int totalDaysOfGivenMonth = getTotalDaysOfGivenMonth(year, month);
%>

<font face="Trebuchet MS">
    <table>
	<tr>
	    <td align="left">
		<table border="0" cellspacing="5" cellpadding="0">
		    <tr>
			<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/schedule_white.gif" width="48" height="48"></td>
			<td align="left"><font size="3"><b>Appointment Calendar: <%=sdf2.format(date2)%></b></font><br>
			    You may browse through the calendar and select a day that you would like to view 
			    the employee schedule for.
			</td>
		    </tr>
		</table>
	    </td>
	</tr>
	<tr>
	    <td>
		<table align="left" valign="top" border="0" cellspacing="0" cellpadding="0">
		    <tr>
			<td class="CalendarTopLeft"></td>
			<td class="CalendarHeader">
			    <table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
				    <td class="CalendarColumn"><span class="HeaderFont">Sunday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Monday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Tuesday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Wednesday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Thursday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Friday</span></td>
				    <td class="CalendarHeaderSeparator"></td>
				    <td class="CalendarColumn"><span class="HeaderFont">Saturday</span></td>
				</tr>
			    </table>
			</td>
			<td class="CalendarTopRight"></td>
		    </tr>
		    <tr>
			<td class="CalendarLeft"></td>
			<td>
			    <table border="0" width="100%" cellspacing="0" cellpadding="0">
				<% int maxRow = (weekDayOfFirstDayOfTheGivenMonth + totalDaysOfGivenMonth) / 7; %>
				<% if ((weekDayOfFirstDayOfTheGivenMonth + totalDaysOfGivenMonth) % 7 == 0) maxRow--; %>
				
				<% for (int row = 0; row < 6; row++) { %>
				    <% if (row > maxRow) break; %>
				<tr>
				    <% for (int column = 0; column < 7; column++) { %>
					<% if ((weekDayOfFirstDayOfTheGivenMonth <= dayIndexOfTheGivenMonth) && (dayIndexOfTheGivenMonth < totalDaysOfGivenMonth + weekDayOfFirstDayOfTheGivenMonth)) { %>
					    <% String datestr = (dayIndexOfTheGivenMonth - weekDayOfFirstDayOfTheGivenMonth + 1)+"/"+(month+1)+"/"+year; %>
					    <% Date date = CoreTools.getDate (datestr); %>
					    
					    <td id="<%=datestr%>" onmouseover="highlightDay('<%=datestr%>')" onmouseout="unlightDay('<%=datestr%>')" onclick="goToCalendarDay('<%=datestr%>')" class="CalendarCell">
					    
					<span class="CellFont"><%=dayIndexOfTheGivenMonth - weekDayOfFirstDayOfTheGivenMonth + 1%>&nbsp;</span>
					    
					<% } else { %>
				    <td class="CalendarCellUnused">
					<% } %> 
				    </td>
				    <% if (column != 6) { %>
				    <td class="CalendarCellSeparator"><img src="/HairSalon/images/site_blank.gif"></td>
				    <% } %>
				    
				    <% dayIndexOfTheGivenMonth++; %>
				<% } %>
				</tr>
				<% }%>
			    </table>
			</td>
			<td class="CalendarRight"></td>
		    </tr>
		    <tr>
			<td class="CalendarBottomLeft"></td>
			<td class="CalendarBottom"></td>
			<td class="CalendarBottomRight"></td>
		    </tr>
		</table>
	    </td>
	</tr>
	<tr>
	    <td>
		<table align="left" valign="top" border="0" cellspacing="5" cellpadding="0">
		    <tr>
			<td align="center">
			    <input type="button" value="Last Year" name="LastYear" onclick="showPreviousYear(<%=year%>,<%=month%>)" class="StandardButton"/>
			</td>

			<td align="center">
			    <input type="button" value="Last Month" name="LastMonth" onclick="showPreviousMonth(<%=year%>,<%=month%>)" class="StandardButton"/>
			</td>

			<td align="center">
			    <input type="button" value="Next Month" name="NextMonth" onclick="showNextMonth(<%=year%>,<%=month%>)" class="StandardButton"/>
			</td>

			<td align="center">
			    <input type="button" value="Next Year" name="NextYear" onclick="showNextYear(<%=year%>,<%=month%>)" class="StandardButton"/>
			</td>
		    </tr>
		</table>
	    </td>
	</tr>
    </table>
</font>