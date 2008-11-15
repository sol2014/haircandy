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
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.app.*" %>
<%@page import="hs.presentation.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>

<%
UserSession userSession = (UserSession) session.getAttribute("user_session");

int year = Integer.parseInt(request.getParameter("year"));
int month = Integer.parseInt(request.getParameter("month"));

Date date = CoreTools.getDate ("01/"+(month+1)+"/"+year);

Calendar calendar = Calendar.getInstance();
calendar.set(year, month, 1);

int firstWeekday = calendar.get(Calendar.DAY_OF_WEEK) - 1;
int dayIndex = 0;
int totalDays = CoreTools.getDaysInMonth(year, month);

ArrayList<CalendarDayStatus> calStatus = SessionController.getSchCalendarStatus (userSession, month, year);
%>

<font face="Trebuchet MS">
    <table>
	<tr>
	    <td align="left">
		<table border="0" cellspacing="5" cellpadding="0">
		    <tr>
			<td align="right" valign="top"><img border="0" src="/HairSalon/images/icons/big/schedule_white.gif" width="48" height="48"></td>
			<td align="left"><font size="3"><b>Schedule Calendar: <%=CoreTools.showDate (date, CoreTools.MonthYearFormat)%></b></font><br>
			    You may browse through the calendar and select a day that you would like to view 
			    the employee schedule for.
			</td>
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
	<tr>
	    <td>
		<table border="0" cellspacing="0" cellpadding="0">
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

<%
int maxRow = (firstWeekday + totalDays) / 7;

if ((firstWeekday + totalDays) % 7 == 0)
    maxRow--;

for (int row = 0; row < 6; row++)
{
    if (row > maxRow)
	break;
%>
				<tr>
<%
    for (int column = 0; column < 7; column++)
    {
	if ((firstWeekday <= dayIndex) && (dayIndex < totalDays + firstWeekday))
	{
	    String datestr = (dayIndex - firstWeekday + 1)+"/"+(month+1)+"/"+year;
	    CalendarDayStatus status = calStatus.get (dayIndex - firstWeekday);
	    
	    if (status.isHasExceptions ())
	    {
%>
				    <td id="<%=datestr%>" onmouseover="highlightDay('<%=datestr%>')" onmouseout="unlightDay('<%=datestr%>')" onclick="goToCalendarDay('<%=datestr%>')" class="CalendarCellException">
					<div valign="top" align="right"><font size="1"><%=ServletHelper.display (status.getExceptionLabel ())%></font></div>
<%
	    }
	    else if (status.isHasData ())
	    {
%>
				    <td id="<%=datestr%>" onmouseover="highlightDay('<%=datestr%>')" onmouseout="unlightDay('<%=datestr%>')" onclick="goToCalendarDay('<%=datestr%>')" class="CalendarCellValid">
<%
	    }
	    else
	    {
%>
				    <td id="<%=datestr%>" onmouseover="highlightDay('<%=datestr%>')" onmouseout="unlightDay('<%=datestr%>')" onclick="goToCalendarDay('<%=datestr%>')" class="CalendarCell">
<%
	    }
%>
					<span class="CellFont"><%=dayIndex - firstWeekday + 1%>&nbsp;</span>
<%
	}
	else
	{
%>
				    <td class="CalendarCellUnused">
<%
	}
%>
				    </td>
<%
	if (column != 6)
	{
%>
				    <td class="CalendarCellSeparator"><img src="/HairSalon/images/site_blank.gif"></td>
<%
        }

	dayIndex++;
}
%>
				</tr>
<%
}
%>
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
		<br/>&nbsp;<img src="/HairSalon/images/calendar/legend_white.gif">&nbsp;Unscheduled&nbsp;
		<img src="/HairSalon/images/calendar/legend_green.gif">&nbsp;Scheduled&nbsp;
		<img src="/HairSalon/images/calendar/legend_exception.gif">&nbsp;Exception&nbsp;
	    </td>
	</tr>
    </table>
</font>