<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>
<%@page import="hs.objects.*" %>
<%@page import="hs.presentation.*" %>
<%@page import="java.util.*" %>

<div>
    <font face="Trebuchet MS" size="2">
	<table align="center" border="0" cellspacing="10" cellpadding="0">
            <tr>
                <td align="center"><b><font size="4">Wednessday, January 28th, 2008</font></b></td>
            </tr>
            <tr>
                <td>
                    <table align="center" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="SchedulerTopLeft"></td>
                            <td class="SchedulerHeader">
                            <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="SchedulerTimeHeader">&nbsp;</td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Mary</span></td>
                                    <td class="SchedulerHeaderSeparator"></td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Geoff</span></td>
                                    <td class="SchedulerHeaderSeparator"></td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Patrick</span></td>
                                    <td class="SchedulerHeaderSeparator"></td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Karima</span></td>
                                    <td class="SchedulerHeaderSeparator"></td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Jill</span></td>
                                    <td class="SchedulerHeaderSeparator"></td>
                                    <td class="SchedulerColumn"><span class="HeaderFont">Sarah</span></td>
                                </tr>
                            </table>
                            </td>
                            <td class="SchedulerTopRight"></td>
                        </tr>
                        <tr>
                            <td class="SchedulerLeft"></td>
                            <td>
                            <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="SchedulerTime"><span class="TimeFont">10:00am</span></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSectionSingle"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSectionTop"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSectionMiddle"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSectionBottom"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SchedulerTime"><span class="TimeFont">11:00am</span></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SchedulerTime"><span class="TimeFont">12:00pm</span></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SchedulerTime"><span class="TimeFont">1:00pm</span></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SchedulerTime"><span class="TimeFont">2:00pm</span></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                    <td class="SchedulerCellSeparator"><img src="images/site_blank.gif"></td>
                                    <td class="SchedulerCell" style="text-align: center; vertical-align: middle">
                                    <table border="0" width="100%" cellspacing="0" cellpadding="0" height="100%">
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                        <tr>
                                            <td class="SchedulerCellSection"><img src="images/site_blank.gif"></td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                            </table>
                            </td>
                            <td class="SchedulerRight"></td>
                        </tr>
                        <tr>
                            <td class="SchedulerBottomLeft"></td>
                            <td class="SchedulerBottom"></td>
                            <td class="SchedulerBottomRight"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" width="100%" cellspacing="5" cellpadding="0">
                        <tr>
                            <td align="center">
                                <input type="button" value="Last Week" name="LastWeek" style="height: 25px; width: 100px">
                            </td>
                            <td align="center">
                                <input type="button" value="Last Day" name="LastDay" style="height: 25px; width: 100px">
                            </td>
                            <td align="center">
                                <input type="button" value="Next Day" name="NextDay" style="height: 25px; width: 100px">
                            </td>
                            <td align="center">
                                <input type="button" value="Next Week" name="NextWeek" style="height: 25px; width: 100px">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </font>
</div>