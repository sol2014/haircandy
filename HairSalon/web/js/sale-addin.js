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
var sale_total = 0.00;

function setTaxPercent (percent)
{
    tax_percent = percent;
}

function getSaleTotal ()
{
    return sale_total;
}

function builtResultTable(content){
    document.getElementById("searchResult").innerHTML=content;
}

function builtServiceResultTable(content)
{
    document.getElementById("serviceResult").innerHTML=content;
}

function service(id, name, price, quantity)
{
    this.id = id;
    this.name = escape(name);
    this.quantity = quantity;
    this.price = price;
}

function product (id, name, price, quantity)
{
    this.name = escape(name);
    this.id = id;
    this.quantity = quantity;
    this.price = price;
}

function addInitialService(id, name, price, quantity)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        services.push(new service(id, name, price, quantity));
    }
}

function addService(id, name, price, quantity)
{
    var index = findServiceIndex(id);
    if(index==-1)
    {
        if(!quantity)
        {
            quantity = 1;    
        }
        services.push(new service(id, name, price, quantity));
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
    var queryString="service_action=SaleServiceRefill&";
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
        queryString+="price="+service.price+"&";
    }
    
    messager.request("service",queryString);
    
    calculateTotal ();
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
    }
    
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="product_action=SaleProductRefill&";
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
        queryString+="price="+product.price+"&";
    }
    
    messager.request("product",queryString);
    
    calculateTotal ();
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

function calculateProductSubTotal ()
{
    for (var i = 0; i < products.length; i++)
    {
        products[i].quantity = document.getElementById ("sr_"+products[i].id).value;
        
        var total = products[i].quantity * products[i].price;
        
        var a = new ToFmt(total);
        document.getElementById("sub_total_product_"+products[i].id).innerHTML = "$"+a.fmtF(9,2);
    }
    
    calculateTotal ();
}

function calculateServiceSubTotal ()
{
    for (var i = 0; i < services.length; i++)
    {
        services[i].quantity = document.getElementById ("st_"+services[i].id).value;
        
        var total = services[i].quantity * services[i].price;
        
        var a = new ToFmt(total);
        document.getElementById("sub_total_service_"+services[i].id).innerHTML = "$"+a.fmtF(9,2);
    }
    
    calculateTotal ();
}

function calculateTotal ()
{
    var total = 0.00;
    var tax = 0.00;
    var discount = document.getElementById ("discount").value;
    
    for (var i = 0; i < products.length; i++)
    {
        total = (products[i].price * products[i].quantity) + total;
    }
    
    for (var i = 0; i < services.length; i++)
    {
        total = (services[i].price * services[i].quantity) + total;
    }
    
    tax = total * tax_percent;
    
    discount = total*(discount/100);
    
    sale_total = total+tax-discount;
    
    var a = new ToFmt(total);
    document.getElementById ("total_due").value = a.fmtF(9,2);
    var a = new ToFmt(tax);
    document.getElementById ("total_tax").value = a.fmtF(9,2);
    
    var a = new ToFmt(discount-(discount*2));
    document.getElementById ("discount_label").innerHTML = "$"+a.fmtF(9,2).trim();
    
    var a = new ToFmt(sale_total);
    document.getElementById ("total_label").innerHTML = "$"+a.fmtF(9,2).trim();
    
    var payment = document.getElementById("payment").value;
    var a = new ToFmt(payment - sale_total);
    document.getElementById ("change_label").innerHTML = "$"+a.fmtF(9,2).trim();
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

function showAddProduct(){
    showBlackout (true);
    document.getElementById("sale_product_dialog").style.display="block";
    document.getElementById("searchResult").innerHTML="";
    searchProducts();
}

function showAddService(){
    showBlackout (true);
    document.getElementById("sale_service_dialog").style.display="block";
    document.getElementById("searchResult").innerHTML="";
    searchServices();
}

function closeAddProduct(){
    showBlackout (false);
    document.getElementById("sale_product_dialog").style.display="none";
}

function closeAddService(){
    showBlackout (false);
    document.getElementById("sale_service_dialog").style.display="none";
}

function doSubmit(){
    for(var i = 0; i < products.length; i++)
    {
        var product = products[i];
        product.quantity = document.getElementById("sr_"+product.id).value;   
        createProductInput (product.id+":"+product.quantity);
    }
    for(var i=0;i<services.length;i++)
    {
        var service = services[i];
        service.quantity = document.getElementById("st_"+service.id).value;
        createServiceInput(service.id+":"+service.quantity);
    }
}
        
function createProductInput(value){
    var form = document.getElementById("postForm");
    var input = document.createElement('input');
    input.value = value;
    input.type = 'hidden';
    input.name = "products";
    form.appendChild(input);
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