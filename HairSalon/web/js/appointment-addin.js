/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

var products = new Array();
var services = new Array();
var tax_percent = 0.0;

function setTaxPercent (percent)
{
    tax_percent = percent;
}

function finishDeleting(content)
{
    if(isNaN(content))
    {
        document.getElementById("operResult").innerHTML="<span style='color: red;'>"+content+"</span>";  
    }
    else
    {
        deleteAppointment(content);
    }
}

function operResultTable(content){
    var array = content.split(":");
    var appointmentNo = parseInt(array[0]);
    var duration = parseInt(array[1]);
    if(isNaN(appointmentNo)|| isNaN(duration))
    {
        document.getElementById("operResult").innerHTML="<span style='color: red;'>"+content+"</span>"; 
    }
    else
    {
        saveAppointment(appointmentNo, duration);
    }
}

function builtResultTable(content){
    showSecondaryBlackout(true);
    document.getElementById("appointment_product_dialog").style.display="block";
    document.getElementById("searchResult").innerHTML=content;
}

function builtServiceResultTable(content)
{
    showSecondaryBlackout(true);
    document.getElementById("appointment_service_dialog").style.display="block";
    document.getElementById("serviceResult").innerHTML=content;
}

function service (id, name, price, quantity, duration)
{
    this.id = id;
    this.name = escape(name);
    this.quantity = quantity;
    this.price = price;
    this.duration = duration;
}

function product (id, name, price, quantity)
{
    this.name = escape(name);
    this.id = id;
    this.quantity = quantity;
    this.price = price;
}

function addInitialService(id, name, price, quantity, duration)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        services.push(new service(id, name, price, quantity, duration));
    }
}

function addService(id, name, price, quantity, duration)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        if(!quantity)
        {
            quantity = 1;    
        }
        services.push(new service(id, name, price, quantity, duration));
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
        
        //document.getElementById("appointment_dialog_shell").style.left = (getScreenWidth() / 2) - (document.getElementById("appointment_dialog_shell").clientWidth / 2) + "px";
        //document.getElementById("appointment_dialog_shell").style.top = (getScreenHeight() / 2) - (document.getElementById("appointment_dialog_shell").clientHeight / 2) + "px";
    }
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="service_action=AppointmentServiceRefill&";
    for(var i = 0; i < services.length; i++)
    {
        var service = services[i];
        queryString+="id="+service.id+"&";
        queryString+="name="+unescape(service.name)+"&";
        if(document.getElementById("st_"+service.id))
        {
            service.quantity = document.getElementById("st_"+service.id).value;
        }
        queryString+="quantity="+service.quantity+"&";
    }
    
    messager.request("service",queryString);
}

function addInitialProduct (id, name, price, quantity)
{
    products.push (new product (id, name, price, quantity));
}

function refillProductsList ()
{
    document.getElementById ("productsList").style.display = "block";
    
    function refill(content){
        document.getElementById ("productsList").innerHTML = content;
        //document.getElementById("appointment_dialog_shell").style.left = (getScreenWidth() / 2) - (document.getElementById("appointment_dialog_shell").clientWidth / 2) + "px";
        //document.getElementById("appointment_dialog_shell").style.top = (getScreenHeight() / 2) - (document.getElementById("appointment_dialog_shell").clientHeight / 2) + "px";
    }
    
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="product_action=AppointmentProductRefill&";
    for(var i = 0; i < products.length; i++)
    {
        var product = products[i];
        queryString+="id="+product.id+"&";
        queryString+="name="+unescape(product.name)+"&";
        if(document.getElementById("sr_"+product.id))
        {
            product.quantity = document.getElementById("sr_"+product.id).value;
        }
        queryString+="quantity="+product.quantity+"&";
    }
    
    messager.request("product",queryString);
}


function addProduct (id, name, price, quantity)
{
    var index = findIndex (id);
    if (index == -1)
    {
        if(!quantity)
        {
            quantity = 1;    
        }
        products.push (new product (id, name, price, quantity));
        refillProductsList ();
    }
}

function deleteProduct (id)
{
    var index = findIndex (id);
    if (index != -1)
    {
        products.splice (index, 1);
        refillProductsList ();
    }
}

function findIndex(id){
    for(var i=0;i<products.length;i++){
        var product = products[i];
        if(product.id==id){
            return i;
        }
    }
    return -1;
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

function showAddProduct()
{
    showSecondaryBlackout(true);
    document.getElementById("searchResult").innerHTML="";
    document.getElementById("appointment_product_dialog").style.display="block";
    searchProducts();
}

function showAddService()
{
    showSecondaryBlackout(true);
    document.getElementById("serviceResult").innerHTML="";
    document.getElementById("appointment_service_dialog").style.display="block";
    searchServices();
}

function closeAddProduct()
{
    document.getElementById("appointment_product_dialog").style.display="none";
    showSecondaryBlackout(false);
}

function closeAddService()
{
    document.getElementById("appointment_service_dialog").style.display="none";
    showSecondaryBlackout(false);
}

function doSubmit()
{
    if(services.length==0)
    {
        document.getElementById("operResult").innerHTML="<span style='color: red;'>Must pick up at least one service</span>";
        return;
    }
    
    if(document.getElementById("first_name").value=="")
    {
        document.getElementById("first_name_label").innerHTML="<span style='color: red;'>First Name:</span>";
        document.getElementById("operResult").innerHTML="<span style='color: red;'>Must choose a first name</span>";
        return;
    }
    else
    {
        document.getElementById("first_name_label").innerHTML="First Name:";
    }
    
    if(document.getElementById("last_name").value=="")
    {
        document.getElementById("last_name_label").innerHTML="<span style='color: red;'>Last Name:</span>";
        document.getElementById("operResult").innerHTML="<span style='color: red;'>Must choose a last name</span>";
        return;
    }
    else
    {
        document.getElementById("last_name_label").innerHTML="Last Name:";
    }
    
    if(document.getElementById("phone_number").value=="")
    {
        document.getElementById("phone_number_label").innerHTML="<span style='color: red;'>Telephone:</span>";
        document.getElementById("operResult").innerHTML="<span style='color: red;'>Must choose a telephone number</span>";
        return;
    }
    else
    {
        document.getElementById("phone_number_label").innerHTML="Telephone:";
    }
    
    
    var productQuery = "";
    
    for(var i = 0; i < products.length; i++)
    {
        var product = products[i];
        product.quantity = document.getElementById("sr_"+product.id).value;   
        productQuery += "products="+product.id+":"+product.quantity+"&";
    }
    
    var serviceQuery = "";
    
    for(var j = 0; j < services.length; j++)
    {
        var service = services[j];
        service.quantity = document.getElementById("st_"+service.id).value;
        serviceQuery += "services="+service.id+":"+service.quantity+"&";
    }
    
    var ajax = new Ajaxer("text",null,operResultTable,null);
    var queryString="appointment_action=Save&";
    queryString+="appointment_no="+escape(document.getElementById("app_no").value)+"&";
    queryString+="first_name="+escape(document.getElementById("first_name").value)+"&";
    queryString+="last_name="+escape(document.getElementById("last_name").value)+"&";
    queryString+="phone_number="+escape(document.getElementById("phone_number").value)+"&";
    queryString+="employee_no="+escape(document.getElementById("app_employee").value)+"&";
    queryString+="start_time="+escape(document.getElementById("app_start_time").value)+"&";
    queryString+="end_time="+escape(document.getElementById("app_end_time").value)+"&";
    queryString+="date="+escape(document.getElementById("app_date").value)+"&";
    if (products.length > 0)
        queryString+=productQuery;
    if (services.length > 0)
        queryString+=serviceQuery;
    //alert(queryString);
    ajax.request("appointment",queryString);
}

function doFinish ()
{
    doSubmit();
}

function doDelete ()
{
    var ajax = new Ajaxer("text",null,finishDeleting,null);
    var queryString="appointment_action=Delete&";
    queryString+="appointment_no="+escape(document.getElementById("app_no").value)+"&";
    ajax.request("appointment",queryString);
}

function searchProducts(){
    var ajax = new Ajaxer("text",null,builtResultTable,null);
    var queryString="product_action=ProductSearch&";
    queryString+="product_name="+escape(document.getElementById("product_name").value)+"&";
    queryString+="brand="+escape(document.getElementById("brand").value)+"&";
    queryString+="product_type="+escape(document.getElementById("product_type").value);
    ajax.request("product",queryString);
}

function searchServices()
{
    var ajax = new Ajaxer("text",null,builtServiceResultTable,null);
    var queryString="service_action=ServiceSearch&";
    queryString+="service_name="+escape(document.getElementById("searchServiceName").value)+"&";
    ajax.request("service",queryString);
}

var startHour;
var startMin;

function setStartTime (hour, minutes)
{
    startHour = hour;
    startMin = minutes;
}

function calculateProductSubTotal ()
{
    for (var i = 0; i < products.length; i++)
    {
        products[i].quantity = document.getElementById ("sr_"+products[i].id).value;
        
        var total = products[i].quantity * products[i].price;
        
        var a = new ToFmt(total);
        document.getElementById("sub_total_product_"+products[i].id).innerHTML = "$"+a.fmtF(9,2);
    }
}

function calculateServiceSubTotal ()
{
    var bigTotal = 0;
    
    for (var i = 0; i < services.length; i++)
    {
        services[i].quantity = document.getElementById ("st_"+services[i].id).value;
        
        var total = services[i].quantity * services[i].duration;
        bigTotal += total;
        
        document.getElementById("sub_total_service_"+services[i].id).innerHTML = total+"m";
    }
    
    var totalMin = startMin + bigTotal;
    var leftHour = parseInt((totalMin/60)+startHour);
    var leftMin = totalMin%60;
    var ampm = "AM";
    
    if (leftHour > 12)
    {
        ampm = "PM";
        leftHour = leftHour - 12;
    }
    else if (leftHour == 12)
    {
        ampm = "PM";
    }
    
    document.getElementById("end_time_label").innerHTML = leftHour+":"+leftMin+" "+ampm;
}