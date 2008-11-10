/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
  
function refreshCalender(year, month)
{
    function reFill(content)
    {
        document.getElementById ("littleCal").innerHTML = content;
    }
    function onProcessing()
    {
        //document.getElementById ("littleCal").innerHTML = "wtf<div style='height:550px;'><img id='weird'></div>";
        //document.getElementById("weird").src = "/HairSalon/images/icons/medium/ajax-loader.gif?weird="+ new Date().getTime();
    }
    var messager = new Ajaxer("text",onProcessing,reFill,null);
    var queryString="";
    queryString+="year="+year+"&";
    queryString+="month="+month+"&";
    messager.request("ajax/ajax-app-clientcalendar.jsp",queryString);
}

function showPreviousYear(year, month)
{
    year--;
    refreshCalender(year, month);
}

function showNextYear(year, month)
{
    year++;
    refreshCalender(year, month);
}

function showPreviousMonth(year, month)
{
    if(month == 0)
    {
        month = 11;
        year--;
    }
    else
    {
        month--;
    }
    refreshCalender(year, month);
}

function showNextMonth(year, month)
{
    if(month == 11)
    {
        month = 0;
        year++;
    }
    else
    {
        month++;
    }
    refreshCalender(year, month);
}