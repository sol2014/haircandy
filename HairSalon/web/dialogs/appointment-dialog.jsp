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

<div id="dude" class="DialogBox" style="width: 550px;height: 350px;">
</div>

<script>
    function getDude()
    {
        function fillDude(content)
        {
            document.getElementById("dude").innerHTML = "";
            setInnerHTML(document.getElementById("dude"),content);
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
        alert(queryString);
        messager.request("appointment",queryString);   
    }
</script>

<script>
    document.getElementById("dude").style.left = (getScreenWidth() / 2) - 275 + "px";
    document.getElementById("dude").style.top = (getScreenHeight() / 2) - 175 + "px";
</script>