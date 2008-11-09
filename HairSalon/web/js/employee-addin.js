/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

var services = new Array();
var exceptions = new Array();

function service(id, name)
{
    this.id = id;
    this.name = name;
}

function exception(date,reason)
{
    this.date = date;
    this.reason = reason;
}

function addIntialService(id, name)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        services.push(new service(id, name));
    }
}

function addService(id, name)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        services.push(new service(id, name));
        refillServicesList();
    }
}

function deleteService(id)
{
    var index = findServiceIndex(id);
    if(index!=-1)
    {
        services.splice(index, 1);
        refillServicesList();
    }
}

function refillServicesList()
{
    document.getElementById ("servicesList").style.display = "block";
    function refill(content)
    {
        document.getElementById ("servicesList").innerHTML = content;
    }
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="service_action=EmployeeServiceRefill&";
    for(var i = 0; i < services.length; i++)
    {
        var service = services[i];
        queryString+="id="+service.id+"&";
        queryString+="name="+service.name+"&";
    }
    messager.request("service",queryString);
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
        queryString+="reason="+exception.reason+"&";
    }
    messager.request("ajax/ajax-employeeexception-delete.jsp",queryString);
}

function showAddService()
{
    document.getElementById("blackout").style.display="block";
    document.getElementById("employee_service_dialog").style.display="block";
    document.getElementById("serviceResult").innerHTML="";
    searchServices ();
}
        
function closeAddService()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("employee_service_dialog").style.display="none";
}

function showAddException()
{
    document.getElementById("blackout").style.display="block";
    document.getElementById("employee_exception_dialog").style.display="block";
}
        
function closeAddException()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("employee_exception_dialog").style.display="none";
}

function createServiceInput(value)
{
    var form = document.getElementById("postForm");
    var input = document.createElement('input');
    input.value = value;
    input.type = 'hidden';
    input.name = "services";
    form.appendChild(input);
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
    for(var i=0;i<services.length;i++)
    {
        var service = services[i];
        createServiceInput(service.id);
    }
    for(var i=0;i<exceptions.length;i++)
    {
        var exception = exceptions[i];
        createExceptionInput(exception.date, exception.reason);
    }
}

function builtServiceResultTable(content)
{
    document.getElementById("serviceResult").innerHTML=content;
}

function searchServices()
{
    var ajax = new Ajaxer("text",null,builtServiceResultTable,null);
    var queryString="service_action=ServiceSearch&";
    queryString+="service_name="+escape(document.getElementById("searchServiceName").value)+"&";
    ajax.request("service",queryString);
}

function findServiceIndex(id)
{
    for(var i=0;i<services.length;i++)
    {
        var service = services[i];
        if(service.id==id)
        {
            return i;
        }
    }
    return -1;
}

function findExceptionIndex(date, reason)
{
    for(var i=0;i<exceptions.length;i++)
    {
        var exception = exceptions[i];
        if((exception.date==date)&&(exception.reason==reason))
        {
            return i;
        }
    }
    return -1;
}