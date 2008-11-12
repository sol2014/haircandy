/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

var exceptions = new Array();

function exception(date,reason)
{
    this.date = date;
    this.reason = escape(reason);
}

function addException(date, reason)
{
    var index = findExceptionIndex(date, reason);
    if(index==-1)
    {
        exceptions.push(new exception(date, reason));
        refillExceptionsList();
    }
    closeAddException();
}

function addIntialException(date, reason)
{
    var index = findExceptionIndex(date, reason);
    if(index==-1)
    {
        exceptions.push(new exception(date, reason));
    }
}
    
function deleteException(date, reason)
{
    var index = findExceptionIndex(date, reason);
    if(index!=-1)
    {
        exceptions.splice(index, 1);
        refillExceptionsList();
    }
}

function refillExceptionsList()
{
    document.getElementById ("exceptionsList").style.display = "block";
    function refill(content)
    {
        document.getElementById ("exceptionsList").innerHTML = content;
    }
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="";
    for(var i = 0; i < exceptions.length; i++)
    {
        var exception = exceptions[i];
        queryString+="date="+exception.date+"&";
        queryString+="reason="+unescape(exception.reason)+"&";
    }
    messager.request("ajax/ajax-salonexception-delete.jsp",queryString);
}

function showAddException()
{
    showBlackout (true);
    document.getElementById("salon_exception_dialog").style.display="block";
}
        
function closeAddException()
{
    showBlackout (false);
    document.getElementById("salon_exception_dialog").style.display="none";
}
    
function createExceptionInput(date,reason)
{
    var form = document.getElementById("postForm");
    var input = document.createElement('input');
    input.value = date;
    input.type = 'hidden';
    input.name = "dates";
    form.appendChild(input);
    input = document.createElement('input');
    input.value = reason;
    input.type = 'hidden';
    input.name = "reasons";
    form.appendChild(input);
}

function doSubmit()
{
    for(var i=0;i<exceptions.length;i++)
    {
        var exception = exceptions[i];
        createExceptionInput(exception.date, unescape(exception.reason));
    }
}

function findExceptionIndex(date, reason)
{
    for(var i=0;i<exceptions.length;i++)
    {
        var exception = exceptions[i];
        if((exception.date==date)&&(exception.reason==escape(reason)))
        {
            return i;
        }
    }
    return -1;
}

