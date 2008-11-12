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

function builtResultTable(content){
    document.getElementById("searchResult").innerHTML=content;
}

function product(id,name)
{
    this.name=escape(name);
    this.id=id;
}

function refillProductsList ()
{
    document.getElementById ("productsList").style.display = "block";
    
    function refill(content){
        document.getElementById ("productsList").innerHTML = content;
    }
    
    var messager = new Ajaxer("text",null,refill,null);
    var queryString="product_action=SupplierProductRefill&";
    for(var i = 0; i < products.length; i++)
    {
        var product = products[i];
        queryString+="id="+product.id+"&";
        queryString+="name="+unescape(product.name)+"&";
    }
    messager.request("product",queryString);
}


function addProduct(id,name){
    var index = findIndex(id);
    if(index==-1){
        products.push(new product(id, name));
        refillProductsList();
    }
}
        
function deleteProduct(id){
    var index = findIndex(id);
    if(index!=-1){
        products.splice(index, 1);
        refillProductsList();
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
        
function showAddProduct(){
    showBlackout (true);
    document.getElementById("supplier_product_dialog").style.display="block";
    searchProducts();
}
        
function closeAddProduct(){
    showBlackout (false);
    document.getElementById("supplier_product_dialog").style.display="none";
}

function doSubmit(){
    for(var i=0;i<products.length;i++){
        var product = products[i];
        createProductInput(product.id);
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
        
function searchProducts(){
    var ajax = new Ajaxer("text",null,builtResultTable,null);
    var queryString="product_action=ProductSearch&";
    queryString+="product_name="+escape(document.getElementById("productName").value)+"&";
    queryString+="brand="+escape(document.getElementById("brand").value)+"&";
    queryString+="product_type="+escape(document.getElementById("product_type").value);
    ajax.request("product",queryString);
}