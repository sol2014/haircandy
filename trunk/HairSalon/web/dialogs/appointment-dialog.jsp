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
        //var queryString="date=<%=request.getParameter("date")%>";
        //messager.request("ajax/ajax-appointment-service-dialog.jsp",queryString);
    }
</script>

<script>
    document.getElementById("dude").style.left = (getScreenWidth() / 2) - 275 + "px";
    document.getElementById("dude").style.top = (getScreenHeight() / 2) - 175 + "px";
</script>