<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="hs.core.*" %>

<font face="Trebuchet MS" size="2">
    <div id="appointment_dialog_shell" class="DialogBox" style="width: 700px;height: 350px;"></div>
    
    <%@ include file="../dialogs/appointment-product-dialog.jsp" %>
    <%@ include file="../dialogs/appointment-service-dialog.jsp" %>
</font>

<script>
    document.getElementById("appointment_dialog_shell").style.left = (getScreenWidth() / 2) - 350 + "px";
    document.getElementById("appointment_dialog_shell").style.top = (getScreenHeight() / 2) - 175 + "px";
</script>

<script>
    function getDialogShell()
    {
        products = new Array();
        services = new Array();
        tax_percent = 0.0;
        function fillDialogShell(content)
        {
            document.getElementById("appointment_dialog_shell").innerHTML = "";
            setInnerHTML(document.getElementById("appointment_dialog_shell"),content);
        }
        var messager = new Ajaxer("text",null,fillDialogShell,null);
        var queryString="appointment_action=Load&";
        if(draggableDiv.appointmentId)
        {
            queryString+="appointment_no="+draggableDiv.appointmentId+"&";
            draggableDiv.appointmentId = undefined;
        }
        else
        {
            queryString += "employee_no="+employeeIDArray[getColumnId(previousFirstCell.id)]+"&";
            queryString+="date="+date+"&";
            queryString+="start_time="+getAppointmentStartTime()+"&";
            queryString+="end_time="+getAppointmentStartTime()+"&";
        }
        //alert(queryString);
        messager.request("appointment",queryString);   
    }
</script>
