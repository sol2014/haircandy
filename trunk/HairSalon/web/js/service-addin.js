/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

function product (id, name, price, quantity)
{
    this.name = escape(name);
    this.id = id;
    this.price = price;
    this.quantity = quantity;
}

var serviceProducts = new Array();

function builtResultTable (content)
{
    document.getElementById("ajax_product_results").innerHTML=content;
}

var ajax = new Ajaxer("text",null,builtResultTable,null);

function addInitialProduct (id, name, price, quantity)
{
    serviceProducts.push (new product (id, name, price, quantity));
}

function refillProductsList ()
{
    document.getElementById ("ajax_product_list").style.display = "block";
    
    function refill(content){
        document.getElementById ("ajax_product_list").innerHTML = content;
    }
    
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="product_action=ServiceProductRefill&";
    for(var i = 0; i < serviceProducts.length; i++)
    {
        var product = serviceProducts[i];
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
        serviceProducts.push (new product (id, name, price, quantity));
        refillProductsList ();
    }
}

function deleteProduct (id)
{
    var index = findIndex (id);
    
    if (index != -1)
    {
        serviceProducts.splice (index, 1);
        refillProductsList ();
    }
}

function findIndex (id)
{
    for(var i = 0; i < serviceProducts.length; i++)
    {
        var product = serviceProducts[i];
        
        if (product.id == id)
        {
            return i;
        }
    }
    
    return -1;
}
function showAddProduct ()
{
    document.getElementById ("blackout").style.display = "block";
    document.getElementById ("service_product_dialog").style.display = "block";
    searchProducts();
}

function closeAddProduct ()
{
    document.getElementById ("blackout").style.display = "none";
    document.getElementById ("service_product_dialog").style.display = "none";
}

function searchProducts()
{
    var queryString="product_action=ProductSearch&";
    queryString+="product_name="+escape(document.getElementById("product_name").value)+"&";
    queryString+="brand="+escape(document.getElementById("brand").value)+"&";
    queryString+="product_type="+escape(document.getElementById("productType").value);
    ajax.request("product",queryString);
}

function doSubmit ()
{
    for(var i = 0; i < serviceProducts.length; i++)
    {
        var product = serviceProducts[i];
        product.quantity = document.getElementById("sr_"+product.id).value;
        
        createProductInput (product.id+":"+product.quantity);
    }
}

function createProductInput (value)
{
    var form = document.getElementById ("post_form");
    var input = document.createElement ('input');
    
    input.value = value;
    input.type = 'hidden';
    input.name = "products";
    
    form.appendChild (input);
}
