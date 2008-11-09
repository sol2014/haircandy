/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

function Ajaxer(handlerType, processHandler, textHandler, xmlHandler)
{
    var request;
    try {
        request = new XMLHttpRequest();
    } catch (trymicrosoft) {
        try {
            request = new ActiveXObject("Msxml2.XMLHTTP.5.0");
        } catch (othermicrosoft) {
            try {
                request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (failed) {
                request = false;
            }
        }
    }
    if(!request){
        alert("Oh my, are you using safari?Come on, use a normal browser like CMonkey");
    }
    function xmlProcess() {
        if (request.readyState == 4){
            if (request.status == 200){
                try{
                    var xml = request.responseXML.documentElement;
                    xmlHandler(xml);
                }
                catch(e){     
                }
            }
        }
        else{
            if(processHandler)
            {
                processHandler();
            }
        }
    }
    function textProcess(){
        if (request.readyState == 4){
            if (request.status == 200){
                try{
                    var text=request.responseText;
                    textHandler(text);
                }
                catch(e){   
                }
            }
        }else{
            if(processHandler)
            {
                processHandler();
            }
        }
    }
    function executionProcess(){
        if (request.readyState == 4){
            if (request.status == 200){
                try{
                    eval(request.responseText);
                }
                catch(e){
                }
            }
        }else{
            if(processHandler)
            {
                processHandler();
            }
        }
    }
    function sendRequest(page, queryString){
        var url = escape(page)+"?random="+Math.random();
        request.open("Post", url, true);
        if(!handlerType){
            request.onreadystatechange = executionProcess;
        }
        else if(handlerType=="text"){
            request.onreadystatechange = textProcess;
        }
        else if(handlerType=="xml"){
            request.onreadystatechange = xmlProcess;
        }
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        request.send(queryString);
    }
    this.request=sendRequest;
}