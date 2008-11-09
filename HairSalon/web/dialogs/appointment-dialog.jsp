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

<div id="appointment_dialog_shell" class="DialogBox">
</div>

<script>
    function getDude()
    {
        function fillDude(content)
        {
            document.getElementById("appointment_dialog_shell").innerHTML = "";
            setInnerHTML(document.getElementById("appointment_dialog_shell"),content);
        }
        var messager = new Ajaxer("text",null,fillDude,null);
        var queryString="appointment_action=Load&";
        queryString += "employee_no="+employeeIDArray[getColumnId(previousFirstCell.id)]+"&";
        if(draggableDiv.appointmentNo)
        {
            queryString+="appointment_no="+draggableDiv.appointmentNo+"&";
        }
        else
        {
            queryString+="date="+date+"&";
            queryString+="start_time="+getAppointmentStartTime()+"&";
            queryString+="end_time="+getAppointmentStartTime()+"&";
        }
        
        messager.request("appointment",queryString);   
    }
</script>
