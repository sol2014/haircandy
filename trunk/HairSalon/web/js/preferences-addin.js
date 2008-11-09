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
}

function closePreferences()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("preferences_dialog").style.display="none";
    
    // When we close the preferences, we need to save.
}
