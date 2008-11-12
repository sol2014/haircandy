/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

function showPassword(employee)
{
    document.getElementById ("old_password").value = "";
    document.getElementById ("new_password").value = "";
    document.getElementById ("repeat_password").value = "";
    
    document.getElementById ("new_label").innerHTML = "New Password:";
    document.getElementById ("repeat_label").innerHTML = "Repeat Password:";
    document.getElementById ("old_label").innerHTML = "Old Password:";
    
    showBlackout (true);
    document.getElementById("password_dialog").style.display="block";
    
    var screen_width = getScreenWidth () / 2;
    var screen_height = getScreenHeight () / 2;
    
    var dialog_width = document.getElementById("password_dialog").style.width;
    var dialog_height = document.getElementById("password_dialog").style.height;
    
    var dialog_w = parseInt (dialog_width.substring (0, dialog_width.length-2));
    var dialog_h = parseInt (dialog_height.substring (0, dialog_height.length-2));
    
    document.getElementById("password_dialog").style.left = (screen_width - (dialog_w / 2)) + "px";
    document.getElementById("password_dialog").style.top = (screen_height - 55 - (dialog_h / 2)) + "px";
}

function isValid(string)
{
    string=string.replace(/^\s+|\s+$/, '');
    
    alert (string.length);
    
    if (string.length == 0)
        return false;
    else if (string.length < 5)
        return false;
    else
        return true;
}

function applyPassword(employee)
{
    var old_password = document.getElementById("old_password").value;
    var new_password = document.getElementById("new_password").value;
    var repeat = document.getElementById ("repeat_password").value;
    var bad = false;
    
    if (!isValid (old_password))
    {
        alert ("old is invalid: "+old_password)
        document.getElementById ("old_label").innerHTML = "<font color=\"red\">Old Password:</font>";
        bad = true;
    }
    else
    {
        document.getElementById ("old_label").innerHTML = "Old Password:";
    }
    
    if (!isValid (repeat))
    {
        document.getElementById ("repeat_label").innerHTML = "<font color=\"red\">Repeat Password:</font>";
        bad = true;
    }
    else
    {
        document.getElementById ("repeat_label").innerHTML = "Repeat Password:";
    }
    
    if (!isValid (new_password))
    {
        document.getElementById ("new_label").innerHTML = "<font color=\"red\">New Password:</font>";
        bad = true;
    }
    else
    {
        document.getElementById ("new_label").innerHTML = "New Password:";
    }
    
    if (bad)
        return;
    
    if (repeat != new_password)
    {
        document.getElementById ("new_label").innerHTML = "<font color=\"red\">New Password:</font>";
        document.getElementById ("repeat_label").innerHTML = "<font color=\"red\">Repeat Password:</font>";
        bad = true;
    }
    else
    {
        document.getElementById ("new_label").innerHTML = "New Password:";
        document.getElementById ("repeat_label").innerHTML = "Repeat Password:";
    }
    if (bad)
        return;
    
    var ajax = new Ajaxer("text", null, doneApplyingPassword, null);
    var queryString="employee_action=UpdatePassword&";
    queryString += "employee_no=" + employee + "&";
    queryString += "old_password=" + old_password + "&";
    queryString += "new_password=" + new_password + "&";
    
    ajax.request("employee", queryString);
}

function doneApplyingPassword (content)
{
    if (content == "ok")
    {
        cancelPassword();
    }
    else
    {
        document.getElementById ("old_label").innerHTML = "<font color=\"red\">Old Password:</font>";
    }
}
function cancelPassword()
{
    showBlackout (false);
    document.getElementById("password_dialog").style.display="none";
}
