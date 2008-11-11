/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

function showPreferences()
{
    document.getElementById("blackout").style.display="block";
    document.getElementById("preferences_dialog").style.display="block";
    
    var screen_width = getScreenWidth () / 2;
    var screen_height = getScreenHeight () / 2;
    
    var dialog_width = document.getElementById("preferences_dialog").style.width;
    var dialog_height = document.getElementById("preferences_dialog").style.height;
    
    var dialog_w = parseInt (dialog_width.substring (0, dialog_width.length-2));
    var dialog_h = parseInt (dialog_height.substring (0, dialog_height.length-2));
    
    document.getElementById("preferences_dialog").style.left = (screen_width - (dialog_w / 2)) + "px";
    document.getElementById("preferences_dialog").style.top = (screen_height - (dialog_h / 2)) + "px";
}

function closePreferences()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("preferences_dialog").style.display="none";
    
    // When we close the preferences, we need to save.
}
