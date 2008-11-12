var monday = false;
var tuesday = false;
var wednesday = false;
var thursday = false;
var friday = false;
var saturday = false;
var sunday = false;

function updateDays ()
{
    updateDay ("monday");
    updateDay ("tuesday");
    updateDay ("wednesday");
    updateDay ("thursday");
    updateDay ("friday");
    updateDay ("saturday");
    updateDay ("sunday");
}

function updateDay (day)
{
    var hour1 = parseInt (document.getElementById (day+"_start_hour").value);
    var hour2 = parseInt (document.getElementById (day+"_end_hour").value);
    
    var min1 = parseInt (document.getElementById (day+"_start_min").value);
    var min2 = parseInt (document.getElementById (day+"_end_min").value);
    
    var ampm1 = document.getElementById (day+"_start_ampm").value;
    var ampm2 = document.getElementById (day+"_end_ampm").value;
    
    var enable = false;;
    
    if (ampm2.attr != ampm1.attr)
        enable = true;
    
    if (hour2 != hour1)
        enable = true;
    
    if (min1 != min2)
        enable = true;
    
    setDayStatus (day, enable);
}

function setDayStatus (day, enabled)
{
    document.getElementById (day+"_start_hour").disabled = !enabled;
    document.getElementById (day+"_start_min").disabled = !enabled;
    document.getElementById (day+"_start_ampm").disabled = !enabled;
    document.getElementById (day+"_end_hour").disabled = !enabled;
    document.getElementById (day+"_end_min").disabled = !enabled;
    document.getElementById (day+"_end_ampm").disabled = !enabled;
    
    if (enabled == false)
    {
        document.getElementById (day+"_start_hour").value = "0";
        document.getElementById (day+"_start_min").value = "00";
        document.getElementById (day+"_start_ampm").value = "AM";
        document.getElementById (day+"_end_hour").value = "0";
        document.getElementById (day+"_end_min").value = "00";
        document.getElementById (day+"_end_ampm").value = "AM";
    }
    
    document.getElementById (day+"_check").checked = enabled;
    
    if (day == "monday")
        monday = enabled;
    else if (day == "tuesday")
        tuesday = enabled;
    else if (day == "wednesday")
        wednesday = enabled;
    else if (day == "thursday")
        thursday = enabled;
    else if (day == "friday")
        friday = enabled;
    else if (day == "saturday")
        saturday = enabled;
    else if (day == "sunday")
        sunday = enabled;
}

function switchDayStatus (day)
{
    var enabled = true;
    
    if (day.value == "monday")
        enabled = !monday;
    else if (day.value == "tuesday")
        enabled = !tuesday;
    else if (day.value == "wednesday")
        enabled = !wednesday;
    else if (day.value == "thursday")
        enabled = !thursday;
    else if (day.value == "friday")
        enabled = !friday;
    else if (day.value == "saturday")
        enabled = !saturday;
    else if (day.value == "sunday")
        enabled = !sunday;
    
    setDayStatus (day.value, enabled);
}

function updatePage ()
{
    getMatrix();
}

function updateSalonHours ()
{
    var start_hour = parseInt(document.getElementById ("start_time_hour").value);
    var start_min = parseInt(document.getElementById ("start_time_min").value);
    var start_ampm = document.getElementById ("start_time_ampm").value;

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

    var start = start_hour+":"+start_min;

    var end_hour = parseInt(document.getElementById ("end_time_hour").value);
    var end_min = parseInt(document.getElementById ("end_time_min").value);
    var end_ampm = document.getElementById ("end_time_ampm").value;

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

    var end = end_hour+":"+end_min;

    var ajax = new Ajaxer("text",null,updatePage,null);
    var queryString="schedule_action=UpdateHours&";

    queryString+="date="+'<%=request.getParameter("date")%>'+"&";
    queryString+="start_time="+start+"&";
    queryString+="end_time="+end+"&";

    ajax.request("schedule", queryString);
}

function updateEmployeeHours (employee, date)
{
    var start_hour = parseInt(document.getElementById ("employee_start_time_hour").value);
    var start_min = parseInt(document.getElementById ("employee_start_time_min").value);
    var start_ampm = document.getElementById ("employee_start_time_ampm").value;

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

    var start = start_hour+":"+start_min;

    var end_hour = parseInt(document.getElementById ("employee_end_time_hour").value);
    var end_min = parseInt(document.getElementById ("employee_end_time_min").value);
    var end_ampm = document.getElementById ("employee_end_time_ampm").value;

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

    var end = end_hour+":"+end_min;

    var ajax = new Ajaxer("text",null,updatePage,null);
    var queryString="employee_action=UpdateHours&";

    queryString+="employee_no="+employee+"&";
    queryString+="date="+date+"&";
    queryString+="start_time="+start+"&";
    queryString+="end_time="+end+"&";

    ajax.request("employee", queryString);
}