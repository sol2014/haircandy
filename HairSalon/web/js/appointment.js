/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */


var ratio;//used to indicate how long the draggable div should be shown
var heightUnit;// = document.getElementById("00").offsetHeight; used to indicate the height unit
var widthUnit;//used to indicate the width unit
var clickedArea;//used to indicate which area section the user is clicked on the draggable div
var leftMouseOffset;//used to save the current left mouse offset
var topMouseOffset;//used to save the current top moust offset
var doDrag = false;//used to indicate if the div is currently draggable or not
var draggableDiv = document.createElement('DIV');//used as draggable div
var emptyClass = "SchedulerCellSection";//used to indicate the empty cell's class name
var bookingHeadClass = "SchedulerCellSectionTop";//used to indicate the booking head cell's class name
var bookingTailClass = "SchedulerCellSectionBottom";//used to indicate the booking tail cell's class name
var bookingBodyClass = "SchedulerCellSectionMiddle";//used to indicate the booking body cell's class name
var bookingComboClass = "SchedulerCellSectionSingle";//used to indicate the booking combo cell's class name
var bookedHeadClass = "SchedulerCellSectionTop_Booked";//used to indicate the booked head cell's class name
var bookedTailClass = "SchedulerCellSectionBottom_Booked";//used to indicate the booked tail cell's class name
var bookedBodyClass = "SchedulerCellSectionMiddle_Booked";//used to indicate the booked body cell's class name
var bookedComboClass = "SchedulerCellSectionSingle_Booked";//used to indicate the booked combo cell's class name
var emptyState = "empty";//used to indicate the cell element in the cells array's empty state
var bookingState = "booking";//used to indicate the cell element in the cells array's booking state
var bookedState = "booked";//used to indicate the cell element in the cells array's booked state
var rowCount;//used to indicate the largest row number, needs to be initilized by jsp
var previousFirstCell;//used to indicate the before moving first cell's id
var previousLastCell;//used to indicate the before moving last cell's id
var draggableClass = "draggable";
draggableDiv.className = draggableClass;
document.body.appendChild(draggableDiv);
var cells = new Array();//cells array that holds all cells' information
//cells[cells.length] = new Cell("00", "empty"); needs to be initialized in jsp
var appointments = new Array();//array that holds all the appointments' information

function addService(serviceId, duration)//function used to change the draggable div's size based on the service time
{
    ratio = duration;
    if(ratio != 0)
    {
        draggableDiv.style.height = heightUnit * ratio;
    }
    var appointmentCells = new Array();
    var start = getRowId(previousFirstCell.id);
    var end = parseInt(start) + parseInt(ratio);
    var ok = true;
    if(end > rowCount)
    {
        ok = false;
    }
    if(isUsed(start, end, getColumnId(previousFirstCell.id)))
    {
        ok = false;
    }
    if(isBooked(start, end, getColumnId(previousFirstCell.id)))
    {
        ok = false;
    }
    var add;
    if(ok)//save the current position
    {
        previousLastCell=document.getElementById(end-1);
        for(var j = start; j < end; j++)
        {
            add  = findCell(j+"^-^"+getColumnId(previousFirstCell.id));
            if(j == start)//appointment start
            {
                document.getElementById(add.id).className = bookingHeadClass;
            }
            else if(j == end - 1)//appointment tail
            {
                document.getElementById(add.id).className = bookingTailClass;
            }
            else//appointment body
            {
                document.getElementById(add.id).className = bookingBodyClass;
            }
            if(start == end -1)//only one cell
            {
                document.getElementById(add.id).className = bookingComboClass;
            }
            add.state = bookingState;
            appointmentCells.push(add.id);
        }
        appointmentCells.serviceId=serviceId;
        appointments.push(appointmentCells);
        closeDialog();
    }
}

function getNumberValue(string)//function used to get the actual number of value of height or width without 'px'
{
    var number = string.substring(0, string.length -2);
    return parseInt(number);
}

function getAbsoluteMousePositions(e)//function to get the absolute mouse position including when the page has been scrolled
{
    if(!e)//ie
    {
        e = window.event;//ie
    }
    if(e.pageX || e.pageY)//firefox
    {
        return {absoluteLeft:e.pageX,absoluteTop:e.pageY};
    }
    else//ie
    {
        return {absoluteLeft:e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft) - document.documentElement.clientLeft,absoluteTop:e.clientY + (document.documentElement.scrollTop ||  document.body.scrollTop) - document.documentElement.clientTop};
    }
}

function getAbsolutePositions(object)//function to get the absolute position of selected div using recursive way
{
    var left = object.offsetLeft;
    var top = object.offsetTop;
    while(object.offsetParent!=null) //recursive way to get the absolute location value
    {
        var parent = object.offsetParent;
        left = left + parent.offsetLeft;
        top = top + parent.offsetTop;
        object = parent;
    }
    return {absoluteLeft:left, absoluteTop:top};
}

function closeDialog()
{
    document.getElementById("blackout").style.display="none";
    document.getElementById("appointment_dialog").style.display="none";
}

function cellRealSingleClickHandler(element)
{
    if (typeof(element.postponement) != "undefined")
    {
        element.postponement = undefined;
        element.doRealOneClick = undefined;
    }
}

function cellSingleClickHandler(element)//function to deal with single click
{
    if (typeof(element.delay) != "undefined")
    {
        window.clearTimeout(element.delay);
        element.delay = undefined;
        element.doRealMouseDown = undefined;
        eval("element.doRealOneClick = function () { cellRealSingleClickHandler(element); }");
        var waitTime = 300;//0.3 second
        if (typeof(element.postponement) == "undefined")
        {
            element.postponement = window.setTimeout(element.doRealOneClick, waitTime, "JavaScript");
        }
    }
}

function cellDoubleClickHandler(element)//function to deal with double click
{
    if (typeof(element.postponement) != "undefined")
    {
        window.clearTimeout(element.postponement);
        element.postponement = undefined;
        element.doRealOneClick = undefined;
        var cell = findCell(element.id);
        if(cell.state == emptyState)
        {
            document.getElementById("blackout").style.display="block";
            document.getElementById("appointment_dialog").style.display="block";
            previousFirstCell = document.getElementById(element.id);
        } 
    }
}

function cellRealMouseDownHandler(element)
{
    var cell = findCell(element.id);
    var index;
    if(cell.state == bookingState)//booking, allows moving
    {
        var appointment;
        for(var i = 0; i < appointments.length; i++)//loop to find the appointment array the element belongs to in appointments array
        {
            appointment = appointments[i];
            var find = false;
            for(var j = 0; j < appointment.length; j++)
            {
                if(appointment[j] == element.id)
                {
                    index = i;
                    find = true;
                    break;
                }
            }
            if(find)
            {
                break;
            }
        }
        previousFirstCell = document.getElementById(appointment[0]);
        previousLastCell = document.getElementById(appointment[appointment.length-1]);
        for(var k = 0; k < appointment.length; k++)
        {
            if(appointment[k] == element.id)
            {
                clickedArea = k;
            }
            findCell(appointment[k]).state = emptyState;//reset the cell's state back to empty
            document.getElementById(appointment[k]).className = emptyClass;//reset the td's class back to empty
        }
        appointments.splice(index, 1);//remove the selected appointment
        draggableDiv.serviceId = appointment.serviceId;
        ratio = appointment.length;
        draggableDiv.style.height = heightUnit * ratio+"px";
        draggableDiv.style.width = widthUnit+"px";
        var elementPositions = getAbsolutePositions(previousFirstCell);
        var mousePositions = element.mousePositions;
        leftMouseOffset = mousePositions.absoluteLeft - elementPositions.absoluteLeft;
        topMouseOffset = mousePositions.absoluteTop - elementPositions.absoluteTop;
        draggableDiv.style.left = elementPositions.absoluteLeft+"px";
        draggableDiv.style.top = elementPositions.absoluteTop+"px";
        draggableDiv.style.display = "block";
        doDrag = true;
    }
}

function cellMouseDownHandler(e, element)//function to deal with the mouse down event on cells inside the scheduler table, that remove the appoint from the array and reset all the tds' class back to empty if its state is booking and allow draggable div to drag
{
    if(!e)
    {
        e = window.event;
    }
    eval("element.doRealMouseDown = function () { cellRealMouseDownHandler(element); }");
    var waitTime = 200;//0.2 second
    element.mousePositions = getAbsoluteMousePositions(e);
    element.delay = window.setTimeout(element.doRealMouseDown, waitTime, "JavaScript");
}

function mouseMoveHandler(e)//function that deals with move move event and reset the draggable's location if it is currently draggable
{
    if(!e)
    {
        e = window.event;
    }
    if(doDrag)
    {
        var mousePositions = getAbsoluteMousePositions(e);
        draggableDiv.style.left = (mousePositions.absoluteLeft - leftMouseOffset)+"px";
        draggableDiv.style.top = (mousePositions.absoluteTop - topMouseOffset)+"px";
    }
    if (window.event) 
    {
        return false;//ie
    }
    else
    {
        e.preventDefault();//firefox
        return true;
    }
}

function mouseUpHandler(e)//function to deal with mouse up event, hide draggable div and add appointment if everything is ok
{
    if(!e)
    {
        e = window.event;
    }
    if(doDrag)
    {
        doDrag = false;
        var mousePositions = getAbsoluteMousePositions(e);
        var find = false;
        for(var i = 0; i < cells.length; i++)
        {
            var cell = cells[i];
            if((parseInt(mousePositions.absoluteLeft) >= parseInt(cell.absoluteLeft-1))&&(parseInt(mousePositions.absoluteTop) >= parseInt(cell.absoluteTop))&&(parseInt(mousePositions.absoluteLeft) < parseInt(cell.absoluteLeft+1) + parseInt(cell.offsetWidth))&&(parseInt(mousePositions.absoluteTop) < parseInt(cell.absoluteTop) + parseInt(cell.offsetHeight)))
            {
                var appointmentCells = new Array();
                var start = parseInt(getRowId(cell.id)) - parseInt(clickedArea);
                var end = parseInt(getRowId(cell.id)) - parseInt(clickedArea) + parseInt(ratio);
                var ok = true;
                if(start < 0)
                {
                    ok = false;
                }
                if(end > rowCount)
                {
                    ok = false;
                }
                if(isUsed(start, end, getColumnId(cell.id)))
                {
                    ok = false;
                }
                if(isBooked(start, end, getColumnId(cell.id)))
                {
                    ok = false;
                }
                var add;
                if(ok)//save the current position
                {
                    for(var j = start; j < end; j++)
                    {
                        add  = findCell(j+"^-^"+getColumnId(cell.id));
                        if(j == start)//appointment start
                        {
                            document.getElementById(add.id).className = bookingHeadClass;
                        }
                        else if(j == end - 1)//appointment tail
                        {
                            document.getElementById(add.id).className = bookingTailClass;
                        }
                        else//appointment body
                        {
                            document.getElementById(add.id).className = bookingBodyClass;
                        }
                        if(start == end -1)//only one cell
                        {
                            document.getElementById(add.id).className = bookingComboClass;
                        }
                        add.state = bookingState;
                        appointmentCells.push(add.id);
                    }
                }
                else//move back to the original position
                {
                    var startRow = getRowId(previousFirstCell.id);
                    var endRow = getRowId(previousLastCell.id);
                    var column = getColumnId(previousFirstCell.id);
                    for(var k = startRow; k <= endRow; k++)
                    {
                        add  = findCell(k+"^-^"+column);
                        if(k == startRow)//appointment start
                        {
                            document.getElementById(add.id).className = bookingHeadClass;
                        }
                        else if(k == endRow)//appointment tail
                        {
                            document.getElementById(add.id).className = bookingTailClass;
                        }
                        else//appointment body
                        {
                            document.getElementById(add.id).className = bookingBodyClass;
                        }
                        if(startRow == endRow)//only one cell
                        {
                            document.getElementById(add.id).className = bookingComboClass;
                        }
                        add.state = bookingState;
                        appointmentCells.push(add.id);
                    }
                }
                appointmentCells.serviceId = draggableDiv.serviceId;
                appointments.push(appointmentCells);
                find = true;
                break;
            }
        }
        if(!find)
        {

        }
        draggableDiv.style.display = "none";
    }
    return false;
}

document.onmousemove = mouseMoveHandler; 
document.onmouseup = mouseUpHandler;

function disableSelection(targetElement)//function that disable selection while the draggable div is moving
{
    if (typeof targetElement.onselectstart!="undefined")
    {
        targetElement.onselectstart=function()
        {
            return false;
        };
    }
    else if (typeof targetElement.style.MozUserSelect!="undefined")
    {
        targetElement.style.MozUserSelect="none";
    }
    else
    {
        targetElement.onmousedown=function()
        {
            return false;
        };
    }
    targetElement.style.cursor = "default";
}

function getRowId(id)//function to get the row number from a given cell id
{
    var rowid = id.split("^-^")[0];
    return rowid;
}

function getColumnId(id)//function to get the column number from a given cell id
{
    var columnid = id.split("^-^")[1];
    return columnid;
}

function Cell(id, stateCssClass, state)//cell prototype
{
    if(navigator.userAgent.indexOf("MSIE")>0)//ie
    {
    } 
    if(navigator.userAgent.indexOf("Firefox")>0)//firefox
    {
    } 
    if(navigator.userAgent.indexOf("Safari")>0)//safari
    {
    }  
    if(navigator.userAgent.indexOf("Camino")>0)//camino
    {
    } 
    if(navigator.userAgent.indexOf("Gecko/")>0)//gecko
    {
    }
    this.id = id;
    var positions = getAbsolutePositions(document.getElementById(id));
    this.absoluteLeft = positions.absoluteLeft;
    this.absoluteTop = positions.absoluteTop;
    this.offsetWidth = document.getElementById(id).offsetWidth;
    this.offsetHeight = document.getElementById(id).offsetHeight;
    if(!heightUnit)
    {
        heightUnit = this.offsetHeight;
    }
    if(!widthUnit)
    {
        widthUnit = this.offsetWidth;
    }
    this.state = state;
    document.getElementById(id).className = stateCssClass;
}

function isUsed(startRow, endRow, col)//function that checks to see if the any cells in the range has been used by another appointment
{
    for(var i=0; i<appointments.length;i++)
    {
        var appointment = appointments[i];
        for(var j=0;j<appointment.length;j++)
        {
            var row = getRowId(appointment[j]);
            var column = getColumnId(appointment[j]);
            for(var k=startRow;k<endRow;k++)
            {
                if(k==row&&column==col)
                {
                    return true;
                }
            }
        }
    }
    return false;
}

function isBooked(startRow, endRow, col)//function to check if any cells in the range was booked
{
    for(var i=startRow; i<endRow;i++)
    {
        var cell = findCell(i+"^-^"+col);
        if(cell!=-1)
        {
            if(cell.state == bookedState)
            {
                return true;
            }
        }
    }
    return false;
}

function findCell(id)//function to return the correct cell based on id
{
    for(var i = 0; i<cells.length;i++)
    {
        var cell = cells[i];
        if(cell.id == id)
        {
            return cell;
        }
    }
    return -1;
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