/* innerhtml.js  
 * Copyright Ma Bingyao <andot@ujn.edu.cn>  
 * Version: 1.9  
 * LastModified: 2006-06-04  
 * This library is free.  You can redistribute it and/or modify it.  
 * http://www.coolcode.cn/?p=117  
 */   
   
var global_html_pool = [];   
var global_script_pool = [];   
var global_script_src_pool = [];   
var global_lock_pool = [];   
var innerhtml_lock = null;   
var document_buffer = "";   
   
function set_innerHTML(obj_id, html, time) {   
    if (innerhtml_lock == null) {   
        innerhtml_lock = obj_id;   
    }   
    else if (typeof(time) == "undefined") {   
        global_lock_pool[obj_id + "_html"] = html;   
        window.setTimeout("set_innerHTML('" + obj_id + "', global_lock_pool['" + obj_id + "_html']);", 10);   
        return;   
    }   
    else if (innerhtml_lock != obj_id) {   
        global_lock_pool[obj_id + "_html"] = html;   
        window.setTimeout("set_innerHTML('" + obj_id + "', global_lock_pool['" + obj_id + "_html'], " + time + ");", 10);   
        return;   
    }   
   
    function get_script_id() {   
        return "script_" + (new Date()).getTime().toString(36)   
          + Math.floor(Math.random() * 100000000).toString(36);   
    }   
   
    document_buffer = "";   
   
    document.write = function (str) {   
        document_buffer += str;   
    }   
    document.writeln = function (str) {   
        document_buffer += str + "\n";   
    }   
   
    global_html_pool = [];   
   
    var scripts = [];   
    html = html.split(/<\/script>/i);   
    for (var i = 0; i < html.length; i++) {   
        global_html_pool[i] = html[i].replace(/<script[\s\S]*$/ig, "");   
        scripts[i] = {text: '', src: '' };   
        scripts[i].text = html[i].substr(global_html_pool[i].length);   
        scripts[i].src = scripts[i].text.substr(0, scripts[i].text.indexOf('>') + 1);   
        scripts[i].src = scripts[i].src.match(/src\s*=\s*(\"([^\"]*)\"|\'([^\']*)\'|([^\s]*)[\s>])/i);  
        if (scripts[i].src) {  
            if (scripts[i].src[2]) {  
                scripts[i].src = scripts[i].src[2];  
            }  
            else if (scripts[i].src[3]) {  
                scripts[i].src = scripts[i].src[3];  
            }  
            else if (scripts[i].src[4]) {  
                scripts[i].src = scripts[i].src[4];  
            }  
            else {  
                scripts[i].src = "";  
            }  
            scripts[i].text = "";  
        }  
        else {  
            scripts[i].src = "";  
            scripts[i].text = scripts[i].text.substr(scripts[i].text.indexOf('>') + 1);  
            scripts[i].text = scripts[i].text.replace(/^\s*<\!--\s*/g, "");   
        }   
    }   
   
    var s;   
    if (typeof(time) == "undefined") {  
        s = 0;  
    }  
    else {  
        s = time;  
    }  
  
    var script, add_script, remove_script;  
  
    for (var i = 0; i < scripts.length; i++) {  
        var add_html = "document_buffer += global_html_pool[" + i + "];\n";  
        add_html += "document.getElementById('" + obj_id + "').innerHTML = document_buffer;\n";  
        script = document.createElement("script");  
        if (scripts[i].src) {  
            script.src = scripts[i].src;  
            if (typeof(global_script_src_pool[script.src]) == "undefined") {  
                global_script_src_pool[script.src] = true;  
                s += 2000;  
            }  
            else {  
                s += 10;  
            }  
        }  
        else {  
            script.text = scripts[i].text;  
            s += 10;  
        }  
        script.defer = true;  
        script.type =  "text/javascript";  
        script.id = get_script_id();  
        global_script_pool[script.id] = script;  
        add_script = add_html;  
        add_script += "document.getElementsByTagName('head').item(0)";   
        add_script += ".appendChild(global_script_pool['" + script.id + "']);\n";  
        window.setTimeout(add_script, s);  
        remove_script = "document.getElementsByTagName('head').item(0)";  
        remove_script += ".removeChild(document.getElementById('" + script.id + "'));\n";  
        remove_script += "delete global_script_pool['" + script.id + "'];\n";  
        window.setTimeout(remove_script, s + 10000);  
    }  
  
    var end_script = "if (document_buffer.match(/<\\/script>/i)) {\n";  
    end_script += "set_innerHTML('" + obj_id + "', document_buffer, " + s + ");\n";  
    end_script += "}\n";  
    end_script += "else {\n";  
    end_script += "document.getElementById('" + obj_id + "').innerHTML = document_buffer;\n";  
    end_script += "innerhtml_lock = null;\n";  
    end_script += "}";   
    window.setTimeout(end_script, s);   
}   




/*
 * 描述：跨浏览器的设置 innerHTML 方法
 * 允许插入的 HTML 代码中包含 script 和 style
 * 作者：kenxu <ken@ajaxwing.com>
 * 日期：2006-03-23
 * 参数：
 * el: 合法的 DOM 树中的节点
 * htmlCode: 合法的 HTML 代码
 * 经测试的浏览器：ie5+, firefox1.5+, opera8.5+
 */
var setInnerHTML = function (el, htmlCode) {
    var ua = navigator.userAgent.toLowerCase();
    if (ua.indexOf('msie') >= 0 && ua.indexOf('opera') < 0) {
        htmlCode = '<div style="display:none">for IE</div>' + htmlCode;
        htmlCode = htmlCode.replace(/<script([^>]*)>/gi, '<script$1 defer="defer">');
        el.innerHTML = htmlCode;
        el.removeChild(el.firstChild);
    }
    else {
        var el_next = el.nextSibling;
        var el_parent = el.parentNode;
        el_parent.removeChild(el);
        el.innerHTML = htmlCode;
        if (el_next) {
            el_parent.insertBefore(el, el_next)
        } else {
            el_parent.appendChild(el);
        }
    }
}

function isDecimalTyped (key)
{
    var code = (key.which) ? key.which : key.keyCode;
    
    if (code == 46)
        return true;
    
    if (code > 31 && (code < 48 || code > 57))
        return false;
    
    return true;
}

function isNumberTyped (key)
{
    var code = (key.which) ? key.which : key.keyCode;
    
    if (code > 31 && (code < 48 || code > 57))
        return false;
    
    return true;
}

function NoEnterKey(e)
{   
    if(!e)
    {
        e = window.event;
    }
    if(e.keyCode == 13) 
    { 
        e.returnValue = false; 
    }
}   
document.onkeypress = NoEnterKey;


function getScreenWidth()//function to get screen width
{
    var width = 0;
    if( typeof( window.innerWidth ) == 'number' )// not ie
    {
        width = window.innerWidth;
    }
    else 
        if( document.documentElement && document.documentElement.clientWidth )//ie 6 and newer 
    {
        width = document.documentElement.clientWidth;
    }
    else if( document.body && document.body.clientWidth )// ie 4
    {
        width = document.body.clientWidth;
    }
    return width;
}

function checkDateInput(id)
{
    var expression = /^(0?[1-9]|[12][0-9]|3[01])[- \/.](0?[1-9]|1[012])[- \/.](19|20)?\d\d$/;
    var value = document.getElementById(id).value;
    if(!expression.test(value)) 
    {
        return false;
    }
    return true;
}

function getScreenHeight()//function to get screen height
{
    var height = 0;
    if( typeof( window.innerHeight ) == 'number' )// not ie
    {
        height = window.innerHeight;
    }
    else 
        if( document.documentElement && document.documentElement.clientHeight )//ie 6 and newer 
    {
        height = document.documentElement.clientHeight;
    }
    else if( document.body && document.body.clientHeight )// ie 4
    {
        height = document.body.clientHeight;
    }
    return height;
}

function checkPostalCode (zip)
{
    if (zip.value.length < 1)
    {
        document.getElementById("postal_code_label").innerHTML = "Postal Code:";
	return;
    }
    var pattern = new RegExp("^[a-z]\\d[a-z]\\d[a-z]\\d$", "i");  
    
    if (pattern.test(zip.value))
    {
        document.getElementById("postal_code_label").innerHTML = "<font color=\"green\">Postal Code:</font>";
    }
    else
    {
        document.getElementById("postal_code_label").innerHTML = "<font color=\"red\">Postal Code:</font>";
    }
}

function checkTelephone (text)
{
    if (text.value.length < 1)
    {
        document.getElementById("telephone_label").innerHTML = "Telephone:";
	return;
    }
    
    var anum=/(^\d+$)|(^\d+\.\d+$)/
    var good = true;
    
    if (!anum.test(text.value))
    {
	good = false;
    }
    else
    {
        if (text.value.length != 10)
        {
            good = false;
        }
    }
    
    if (good == false)
    {
        document.getElementById("telephone_label").innerHTML = "<font color=\"red\">Telephone:</font>";
    }
    else
    {
        document.getElementById("telephone_label").innerHTML = "<font color=\"green\">Telephone:</font>";
    }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}; 

// JS Object: ToFmt 
// Author: David Mosley, E-mail: David.Mosley@fundp.ac.be or davmos@fcmail.com
// August 1998.
// Contains a limited set of formatting routines for
// use in JavaScript scripts.
// Feel free to use this code in your scripts. I would be grateful if you
// could keep this header intact. 
// Please let me know if you find the code useful.
// Please report any bugs you find or improvements you make to the script. 
// The code has been tested, but no guarantee can be made of it functioning
// correctly. Use is entirely at your own risk.
// 
// Summary of methods
// fmt00(): Tags leading zero onto numbers 0 - 9.
// Particularly useful for displaying results from Date methods.
//
// fmtF(w,d): formats in a style similar to Fortran's Fw.d, where w is the
// width of the field and d is the number of figures after the decimal
// point. 
// The result is aligned to the right of the field.  The default
// padding character is a space " ". This can be modified using the 
// setSpacer(string) method of ToFmt. 
// If the result will not fit in the field , the field will be returned
// containing w asterisks.
//
// fmtE(w,d): formats in a style similar to Fortran's Ew.d, where w is the
// width of the field and d is the number of figures after the decimal
// point. 
// The result is aligned to the right of the field.  The default
// padding character is a space " ". This can be modified using the 
// setSpacer(string) method of ToFmt. 
// If the result will not fit in the field , the field will be returned
// containing w asterisks.
//
// fmtI(w): formats in a style similar to Fortran's Iw, where w is the
// width of the field.
// Floating point values are truncated (rounded down) for integer
// representation.
// The result is aligned to the right of the field.  The default
// padding character is a space " ". This can be modified using the 
// setSpacer(string) method of ToFmt. 
// If the result will not fit in the field , the field will be returned
// containing w asterisks.

function ToFmt(x){
    this.x=x;
    this.fmt00 = fmt00;
    this.fmtF = fmtF;
    this.fmtE=fmtE;
    this.fmtI=fmtI;
    this.spacer=" ";
    this.setSpacer=setSpacer;
}

function fmt00(){
    // fmt00: Tags leading zero onto numbers 0 - 9.
    // Particularly useful for displaying results from Date methods.
    //
    if (parseInt(this.x) < 0) var neg = true;
    if (Math.abs(parseInt(this.x)) < 10){
        this.x = "0"+ Math.abs(this.x);
    }
    if (neg) this.x = "-"+this.x;
    return this.x;
}

function fmtF(w,d){

    // fmtF: formats in a style similar to Fortran's Fw.d, where w is the
    // width of the field and d is the number of figures after the decimal
    // point. 
    // The result is aligned to the right of the field.  The default
    // padding character is a space " ". This can be modified using the 
    // setSpacer(string) method of ToFmt. 
    // If the result will not fit in the field , the field will be returned
    // containing w asterisks.
    var width=w;
    var dpls=d;
    var lt1=false;
    var len=this.x.toString().length;
    var junk;
    var res="";
    // First check for valid format request
    if ( width < (dpls+2)){
        window.alert("Illegal format specified : w = " + d +
            " w = " + d +
            "\nUsage: [ToFmt].fmtF(w,d)" +
            "\nWidth (w) of field must be greater or equal to the number " +
            "\nof digits to the right of the decimal point (d) + 2");
        junk = filljunk(width);
        return junk;
    }
    // Work with absolute value
    var absx=Math.abs(this.x);
    // Nasty fix to deal with numbers < 1 and problems with leading zeros!
    if ((absx < 1) && (absx > 0)){
        lt1 = true;
        absx+=10;
    }
    // Get postion of decimal point
    var pt_pos = absx.toString().indexOf(".");
    if ( pt_pos == -1){
        res+= absx;
        res+= ".";
        for (var i = 0; i < dpls; i++){
            res += 0;
        }  
    }
    else{
        res = Math.round(absx * Math.pow(10,dpls));
        res=res.toString();
        if (res.length == 
            Math.round(Math.floor(absx * Math.pow(10,dpls))).toString().length){ 
            res = res.substring(0,pt_pos) + "." + 
                res.substring(pt_pos,res.length);
        }
        else{
            pt_pos++;
            res = res.substring(0,pt_pos) + "." + 
                res.substring(pt_pos,res.length);
        } 
        // Remove leading 1 from  numbers < 1 (Nasty fix!)
        if (lt1) {
            res=res.substring(1,res.length);
        }
    }
    // Final formatting statements
    // Reinsert - sign for negative numbers
    if (this.x < 0)res = "-"+res;
    // Check whether the result fits in the width of the field specified
    if (res.length > width){
        res=filljunk(width);
    }
    // If necessary, pad from the left with the spacer string
    else if (res.length < width){
        var res_bl="";
        for (var i = 0; i < (width - res.length); i++){
            res_bl += this.spacer ;
        } 
        res = res_bl + res;
    }
    return res;
}

function fmtE(w,d){

    // fmtE: formats in a style similar to Fortran's Ew.d, where w is the
    // width of the field and d is the number of figures after the decimal
    // point. 
    // The result is aligned to the right of the field.  The default
    // padding character is a space " ". This can be modified using the 
    // setSpacer(string) method of ToFmt. 
    // If the result will not fit in the field , the field will be returned
    // containing w asterisks.
    //
    var width=w;
    var dpls=d;
    var e="E+";
    var len=this.x.toString().length;
    var pow10;
    var xp10;
    var junk;
    var res="";
    // First check for valid format request
    if ( width < (dpls+5)){
        window.alert("Illegal format specified : w = " + d +
            " w = " + d +
            "\nUsage: [ToFmt].fmtE(w,d)" +
            "\nWidth (w) of field must be greater or equal to the number " +
            "\nof digits to the right of the decimal point (d) + 6");
        junk = filljunk(w);
        return junk;
    }
    // Work with absolute value
    var absx=Math.abs(this.x);
    // Get postion of decimal point
    var pt_pos = absx.toString().indexOf(".");
    // For x=0
    if (absx == 0){
        res +="0.";
        for (var i=0; i< dpls; i++){
            res += "0";
        }
        res  += "E+00";
    }
    // For abs(x) >= 1 
    else if (absx >= 1.0){
        pow10=1;
        xp10 = absx;
        while (xp10 >= 1.){
            pow10++;
            xp10 /= 10;
        }
        res = Math.round(xp10 * Math.pow(10,dpls));
        res=res.toString();
        if (res.length == 
            Math.round(Math.floor(xp10 * Math.pow(10,dpls))).toString().length){ 
            pow10--;
        }
        res = "0." + res.substring(0,dpls) + e + (new ToFmt(pow10)).fmt00();
    }
    // For abs(x) < 1
    else if (absx < 1.0){
        pow10=1;
        xp10 = absx;
        while (xp10 < 1.){
            pow10--;
            xp10 *= 10;
        }
        res = Math.round(xp10/10 * Math.pow(10,dpls));
        res=res.toString();
        if (res.length != 
            Math.round(Math.floor(xp10/10 * Math.pow(10,dpls))).toString().length){ 
            pow10++;
        }
        if (pow10 < 0) e = "E-";
        res = "0." + res.substring(0,dpls) + e + (new ToFmt(Math.abs(pow10))).fmt00();
    }
 
    if (this.x < 0)res = "-"+res;
    if (res.length > width){
        res=filljunk(width);
    }
    else if (res.length < width){
        var res_bl="";
        for (var i = 0; i < (width - res.length); i++){
            res_bl += this.spacer ;
        } 
        res = res_bl + res;
    }
    return res;
 
}

function fmtI(w){

    // fmtI: formats in a style similar to Fortran's Iw, where w is the
    // width of the field.
    // Floating point values are truncated (rounded down) for integer
    // representation.
    // The result is aligned to the right of the field.  The default
    // padding character is a space " ". This can be modified using the 
    // setSpacer(string) method of ToFmt. 
    // If the result will not fit in the field , the field will be returned
    // containing w asterisks.
    var width=w;
    var lt0=false;
    var len=this.x.toString().length;
    var junk;
    var res="";
    // Work with absolute value
    var absx = Math.abs(this.x);

    // Test for < 0
    if (parseInt(this.x) < 0){
        lt0 = true;
    }
    res = Math.round(Math.floor((absx))).toString();
    if (lt0){
        res = "-"+res;
    }
    if (res.length > width){
        res=filljunk(width);
    }
    else if (res.length < width){
        var res_bl="";
        for (var i = 0; i < (width - res.length); i++){
            res_bl += this.spacer ;
        } 
        res = res_bl + res;
    }
    return res;
}

function filljunk(lenf){
    // Fills field of length lenf with asterisks
    var str="";
    for (var i=0; i < lenf; i++){
        str +="*";
    }
    return str;
}

function setSpacer(spc){
    var spc;
    this.spacer=spc;
    return this.spacer;
}

function Hashtable(){
    this.clear = hashtable_clear;
    this.containsKey = hashtable_containsKey;
    this.containsValue = hashtable_containsValue;
    this.get = hashtable_get;
    this.isEmpty = hashtable_isEmpty;
    this.keys = hashtable_keys;
    this.put = hashtable_put;
    this.remove = hashtable_remove;
    this.size = hashtable_size;
    this.toString = hashtable_toString;
    this.values = hashtable_values;
    this.hashtable = new Array();
}

/*=======Private methods for internal use only========*/

function hashtable_clear(){
    this.hashtable = new Array();
}

function hashtable_containsKey(key){
    var exists = false;
    for (var i in this.hashtable) {
        if (i == key && this.hashtable[i] != null) {
            exists = true;
            break;
        }
    }
    return exists;
}

function hashtable_containsValue(value){
    var contains = false;
    if (value != null) {
        for (var i in this.hashtable) {
            if (this.hashtable[i] == value) {
                contains = true;
                break;
            }
        }
    }
    return contains;
}

function hashtable_get(key){
    return this.hashtable[key];
}

function hashtable_isEmpty(){
    return (parseInt(this.size()) == 0) ? true : false;
}

function hashtable_keys(){
    var keys = new Array();
    for (var i in this.hashtable) {
        if (this.hashtable[i] != null) 
            keys.push(i);
    }
    return keys;
}

function hashtable_put(key, value){
    if (key == null || value == null) {
        throw "NullPointerException {" + key + "},{" + value + "}";
    }else{
        this.hashtable[key] = value;
    }
}

function hashtable_remove(key){
    var rtn = this.hashtable[key];
    this.hashtable[key] = null;
    return rtn;
}

function hashtable_size(){
    var size = 0;
    for (var i in this.hashtable) {
        if (this.hashtable[i] != null) 
            size ++;
    }
    return size;
}

function hashtable_toString(){
    var result = "";
    for (var i in this.hashtable)
    {      
        if (this.hashtable[i] != null) 
            result += "{" + i + "},{" + this.hashtable[i] + "}\n";   
    }
    return result;
}

function hashtable_values(){
    var values = new Array();
    for (var i in this.hashtable) {
        if (this.hashtable[i] != null) 
            values.push(this.hashtable[i]);
    }
    return values;
}

