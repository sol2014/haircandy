/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

function showAvailability(employee)
{
    // Fire off the request to pull the data.
    var ajax = new Ajaxer("text",null,doneObtainingAvailability,null);
    
    var queryString="employee_action=LoadAvailability&";
    queryString += "employee_no="+employee+"&";
    
    ajax.request("employee", queryString);
}

function applyAvailability(employee)
{
    alert ("starting to apply");
    
    var monday_start = getDayStartHour ("monday");
    var monday_end = getDayEndHour ("monday");
    var tuesday_start = getDayStartHour ("tuesday");
    var tuesday_end = getDayEndHour ("tuesday");
    var wednesday_start = getDayStartHour ("wednesday");
    var wednesday_end = getDayEndHour ("wednesday");
    var thursday_start = getDayStartHour ("thursday");
    var thursday_end = getDayEndHour ("thursday");
    var friday_start = getDayStartHour ("friday");
    var friday_end = getDayEndHour ("friday");
    var saturday_start = getDayStartHour ("saturday");
    var saturday_end = getDayEndHour ("saturday");
    var sunday_start = getDayStartHour ("sunday");
    var sunday_end = getDayEndHour ("sunday");
    
    alert ("done getting all the hours");
    
    // Fire off the request to pull the data.
    var ajax = new Ajaxer("text",null,doneApplyingAvailability,null);
    
    var queryString="employee_action=UpdateAvailability&";
    queryString += "employee_no="+employee+"&";
    
    queryString += "monday_start="+monday_start+"&";
    queryString += "monday_end="+monday_end+"&";
    queryString += "tuesday_start="+tuesday_start+"&";
    queryString += "tuesday_end="+tuesday_end+"&";
    queryString += "wednesday_start="+wednesday_start+"&";
    queryString += "wednesday_end="+wednesday_end+"&";
    queryString += "thursday_start="+thursday_start+"&";
    queryString += "thursday_end="+thursday_end+"&";
    queryString += "friday_start="+friday_start+"&";
    queryString += "friday_end="+friday_end+"&";
    queryString += "saturday_start="+saturday_start+"&";
    queryString += "saturday_end="+saturday_end+"&";
    queryString += "sunday_start="+sunday_start+"&";
    queryString += "sunday_end="+sunday_end+"&";
    
    ajax.request("employee", queryString);
}

function getDayStartHour (day)
{
    var start_hour = parseInt(document.getElementById ("availability_"+day+"_start_hour").value);
    var start_min = parseInt(document.getElementById ("availability_"+day+"_start_min").value);
    var start_ampm = document.getElementById ("availability_"+day+"_start_ampm").value;
    
    if (start_ampm != null && start_ampm == "PM")
    {
        if (start_hour != 12)
            start_hour += 12;
    }
    else
    {
        if (start_hour == 12)
            start_hour = 0;
    }
    
    return start_hour+":"+start_min;
}

function getDayEndHour (day)
{
    var end_hour = parseInt(document.getElementById ("availability_"+day+"_end_hour").value);
    var end_min = parseInt(document.getElementById ("availability_"+day+"_end_min").value);
    var end_ampm = document.getElementById ("availability_"+day+"_end_ampm").value;

    if (end_ampm != null && end_ampm == "PM")
    {
        if (end_hour != 12)
            end_hour += 12;
    }
    else
    {
        if (end_hour == 12)
            end_hour = 0;
    }

    return end_hour+":"+end_min;
}

function doneObtainingAvailability (content)
{
    // We are done getting the data, now lets render it.
    
    document.getElementById("availability_dialog_shell").innerHTML = "";
    setInnerHTML(document.getElementById("availability_dialog_shell"),content);
    
    updateDays ("availability");
    
    document.getElementById("blackout").style.display="block";
    document.getElementById("availability_dialog_shell").style.display="block";
    
    var screen_width = getScreenWidth () / 2;
    var screen_height = getScreenHeight () / 2;
    
    var dialog_width = document.getElementById("availability_dialog").style.width;
    var dialog_height = document.getElementById("availability_dialog").style.height;
    
    var dialog_w = parseInt (dialog_width.substring (0, dialog_width.length-2));
    var dialog_h = parseInt (dialog_height.substring (0, dialog_height.length-2));
    
    document.getElementById("availability_dialog_shell").style.left = (screen_width - (dialog_w / 2)) + "px";
    document.getElementById("availability_dialog_shell").style.top = (screen_height - (dialog_h / 2)) + "px";
}

function doneApplyingAvailability (content)
{
    if (content == "ok")
    {
        cancelAvailability();
    }
    else
    {
        // we have some errors back, split the string to find out what days went bad.
        document.getElementById ("availability_error").innerHTML = content;
    }
}
function cancelAvailability()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("availability_dialog_shell").style.display="none";
}
