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
var overlapHeadClass = "SchedulerCellSectionTop_Overlap";//used to indicate overlap head cell's class name
var overlapTailClass = "SchedulerCellSectionBottom_Overlap";//used to indicate overlap tail cell's class name
var overlapBodyClass = "SchedulerCellSectionMiddle_Overlap";//used to indicate overlap body cell's class name
var overlapComboClass = "SchedulerCellSectionSingle_Overlap";//used to indicate overlap combo cell's class name
var overlapTwiceHeadClass = "SchedulerCellSectionTop_OverlapTwice";//used to indicate overlap twice head cell's class name
var overlapTwiceTailClass = "SchedulerCellSectionBottom_OverlapTwice";//used to indicate overlap twice tail cell's class name
var overlapTwiceBodyClass = "SchedulerCellSectionMiddle_OverlapTwice";//used to indicate overlap twice body cell's class name
var overlapTwiceComboClass = "SchedulerCellSectionSingle_OverlapTwice";//used to indicate overlap twice combo cell's class name
var bookedHeadClass = "SchedulerCellSectionTop_Booked";//used to indicate the booked head cell's class name
var bookedTailClass = "SchedulerCellSectionBottom_Booked";//used to indicate the booked tail cell's class name
var bookedBodyClass = "SchedulerCellSectionMiddle_Booked";//used to indicate the booked body cell's class name
var bookedComboClass = "SchedulerCellSectionSingle_Booked";//used to indicate the booked combo cell's class name
var exceptionClass = "SchedulerCellSection_Unavailable";//used to indicate the exception cell's class name
var emptyState = "empty";//used to indicate the cell element in the cells array's empty state
var bookingState = "booking";//used to indicate the cell element in the cells array's booking state
var bookedState = "booked";//used to indicate the cell element in the cells array's booked state
var rowCount;//used to indicate the largest row number, needs to be initilized by jsp
var previousFirstCell;//used to indicate the before moving first cell's id
var previousLastCell;//used to indicate the before moving last cell's id
var draggableClass = "draggable";
var salonStartTime;//used to indicate the salon's start time
var date;//used to indicate the date
var employeeIDArray;//used to indicate the employee's id array
var employeeNameArray;//used to indicate the employee's name array
draggableDiv.className = draggableClass;
document.body.appendChild(draggableDiv);
var cells = new Array();//cells array that holds all cells' information
//cells[cells.length] = new Cell("00", "empty"); needs to be initialized in jsp
var appointments = new Array();//array that holds all the appointments' information

function getColumnIDFromEmployeeNo(id)
{
    for(var i = 0;i<employeeIDArray.length;i++)
    {
        if(employeeIDArray[i]+""==id+"")
        {
            return i;
        }
    }
    return -1;
}

function addIntialAppointment(duration, row, column, appointmentId)//function used to add entry on page load
{
    ratio = duration;
    var appointmentCells = new Array();
    var start = row;
    var end = parseInt(start) + parseInt(ratio);
    var ok = true;
    if(end > rowCount)
    {
        ok = false;
    }
    if(isBooked(start, end, column))
    {
        ok = false;
    }
    var add;
    if(ok)//save the current position
    {
        for(var j = start; j < end; j++)
        {
            add  = findCell(j+"^-^"+column);
            var previousAppointmentIndex = isCellUsed(add.id);
            if(previousAppointmentIndex!=-1)//cell used by other appointment
            {
                var secondPreviousAppointmentIndex = isCellOverlapped(add.id, previousAppointmentIndex);
                if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
                {
                    if(j == start)//appointment start
                    {
                        document.getElementById(add.id).className = overlapTwiceHeadClass;
                    }
                    else if(j == end - 1)//appointment tail
                    {
                        document.getElementById(add.id).className = overlapTwiceTailClass;
                    }
                    else//appointment body
                    {
                        document.getElementById(add.id).className = overlapTwiceBodyClass;
                    }
                    if(start == end -1)//only one cell
                    {
                        document.getElementById(add.id).className = overlapTwiceComboClass;
                    }
                }
                else
                {
                    if(j == start)//appointment start
                    {
                        document.getElementById(add.id).className = overlapHeadClass;
                    }
                    else if(j == end - 1)//appointment tail
                    {
                        document.getElementById(add.id).className = overlapTailClass;
                    }
                    else//appointment body
                    {
                        document.getElementById(add.id).className = overlapBodyClass;
                    }
                    if(start == end -1)//only one cell
                    {
                        document.getElementById(add.id).className = overlapComboClass;
                    }
                }
            }
            else//not used by other appointments
            {
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
            }
            add.state = bookingState;
            appointmentCells.push(add.id);
        }
        appointmentCells.appointmentId=appointmentId;
        appointments.push(appointmentCells);
    }
}

function addUnavailableEntry(duration, row, column)//function used to add entry on page load
{
    ratio = duration;
    var start = row;
    var end = parseInt(start) + parseInt(ratio);
    for(var j = start; j < end; j++)
    {
        var cell = findCell(j+"^-^"+column);
        cell.state = bookedState;
        document.getElementById(cell.id).className = exceptionClass;
    }
}

function findAppointmentIndex(appointmentId)
{
    for(var i = 0; i<appointments.length;i++)
    {
        var appointment = appointments[i];
        if(appointment.appointmentId+""==appointmentId+"")
        {
            return i;
        }
    }
    return false;
}

function saveAppointment(appointmentId, duration)
{
    var index = findAppointmentIndex(appointmentId);
    if(!isNaN(index))
    {
        removeAppointment(index);
    }
    addAppointment(appointmentId, duration);
}

function deleteAppointment(appointmentId)
{
    var index = findAppointmentIndex(appointmentId);
    if(index)
    {
        removeAppointment(index);
    }
}

function removeAppointment(index)
{
    appointments.splice(index, 1);//remove the selected appointment
    for(var k = 0; k < appointment.length; k++)
    {
        var previousAppointmentIndex = isCellUsed(appointment[k]);
        if(previousAppointmentIndex!=-1)//cell used by other appointment
        {
            findCell(appointment[k]).state = bookingState;//reset the cell's state back to booking
            var previousAppointment = appointments[previousAppointmentIndex];
            var firstRow = getRowId(previousAppointment[0]);
            var lastRow = getRowId(previousAppointment[previousAppointment.length-1]);
            var currentRow = getRowId(appointment[k]);
            var secondPreviousAppointmentIndex = isCellOverlapped(appointment[k], previousAppointmentIndex);
            if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
            {
                var thirdPreviousAppointmentIndex = isCellOverlappedTwice(appointment[k],previousAppointmentIndex,secondPreviousAppointmentIndex);
                if(thirdPreviousAppointmentIndex!=-1)//the cell was previously overlap at least twice
                {
                    if(currentRow == firstRow)
                    {
                        document.getElementById(appointment[k]).className = overlapTwiceHeadClass;;//reset the td's class back to overlap head
                    }
                    else if (currentRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = overlapTwiceTailClass;;//reset the td's class back to overlap tail    
                    }
                    else
                    {
                        document.getElementById(appointment[k]).className = overlapTwiceBodyClass;;//reset the td's class back to overlap body  
                    }
                    if(firstRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = overlapTwiceComboClass;;//reset the td's class back to overlap combo
                    }
                }
                else
                {
                    if(currentRow == firstRow)
                    {
                        document.getElementById(appointment[k]).className = overlapHeadClass;;//reset the td's class back to overlap head
                    }
                    else if (currentRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = overlapTailClass;;//reset the td's class back to overlap tail    
                    }
                    else
                    {
                        document.getElementById(appointment[k]).className = overlapBodyClass;;//reset the td's class back to overlap body  
                    }
                    if(firstRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = overlapComboClass;;//reset the td's class back to overlap combo
                    }       
                }
            }
            else//the cell was not previously overlap
            {
                if(currentRow == firstRow)
                {
                    document.getElementById(appointment[k]).className = bookingHeadClass;;//reset the td's class back to booking head
                }
                else if (currentRow == lastRow)
                {
                    document.getElementById(appointment[k]).className = bookingTailClass;;//reset the td's class back to booking tail    
                }
                else
                {
                    document.getElementById(appointment[k]).className = bookingBodyClass;;//reset the td's class back to booking body  
                }
                if(firstRow == lastRow)
                {
                    document.getElementById(appointment[k]).className = bookingComboClass;;//reset the td's class back to booking combo
                } 
            }
        }
        else//not used
        {
            findCell(appointment[k]).state = emptyState;//reset the cell's state back to empty
            document.getElementById(appointment[k]).className = emptyClass;//reset the td's class back to empty
        }
    }
}

function addAppointment(appointmentId, duration)//function used to change the draggable div's size based on the service time
{
    ratio = duration;
    var appointmentCells = new Array();
    var start = getRowId(previousFirstCell.id);
    var end = parseInt(start) + parseInt(ratio);
    var ok = true;
    if(end > rowCount)
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
            var previousAppointmentIndex = isCellUsed(add.id);
            if(previousAppointmentIndex!=-1)//cell used by other appointment
            {
                var secondPreviousAppointmentIndex = isCellOverlapped(add.id, previousAppointmentIndex);
                if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
                {
                    if(j == start)//appointment start
                    {
                        document.getElementById(add.id).className = overlapTwiceHeadClass;
                    }
                    else if(j == end - 1)//appointment tail
                    {
                        document.getElementById(add.id).className = overlapTwiceTailClass;
                    }
                    else//appointment body
                    {
                        document.getElementById(add.id).className = overlapTwiceBodyClass;
                    }
                    if(start == end -1)//only one cell
                    {
                        document.getElementById(add.id).className = overlapTwiceComboClass;
                    }
                }
                else
                {
                    if(j == start)//appointment start
                    {
                        document.getElementById(add.id).className = overlapHeadClass;
                    }
                    else if(j == end - 1)//appointment tail
                    {
                        document.getElementById(add.id).className = overlapTailClass;
                    }
                    else//appointment body
                    {
                        document.getElementById(add.id).className = overlapBodyClass;
                    }
                    if(start == end -1)//only one cell
                    {
                        document.getElementById(add.id).className = overlapComboClass;
                    }
                }
            }
            else//not used by other appointments
            {
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
            }
            add.state = bookingState;
            appointmentCells.push(add.id);
        }
        appointmentCells.appointmentId=appointmentId;
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
    document.getElementById("appointment_dialog_shell").style.display="none";
}

function getAppointmentStartTime()
{
    var row = getRowId(previousFirstCell.id);
    var hour = parseInt(salonStartTime) + parseInt((row-row%4)/4);
    var minutes = row%4;
    switch (minutes)
    {
        case 1:
            minutes="15";
            break;
        case 2:
            minutes="30";
            break;
        case 3:
            minutes="45"
            break;
        default:
            minutes="00";
    }
    //alert(hour+":"+minutes);
    return hour+":"+minutes;
}

function getTimeFromRow(row)
{
    var hour = parseInt(salonStartTime) + parseInt((row-row%4)/4);
    var minutes = row%4;
    switch (minutes)
    {
        case 1:
            minutes="15";
            break;
        case 2:
            minutes="30";
            break;
        case 3:
            minutes="45"
            break;
        default:
            minutes="00";
    }
    return hour+":"+minutes;
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
        if(cell.state == emptyState||cell.state == bookingState)
        {
            document.getElementById("blackout").style.display="block";
            document.getElementById("appointment_dialog_shell").style.display="block";
            previousFirstCell = document.getElementById(element.id);
            var appointmentId = getCellAppointmentId(element.id);
            if(appointmentId!=-1)
            {
                draggableDiv.appointmentId=appointmentId;
            }
            getDialogShell();
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
        for(var i = appointments.length -1; i >=0; i--)//loop to find the appointment array the element belongs to in appointments array
        {
            appointment = appointments[i];
            var find = false;
            for(var j = appointment.length -1; j >=0; j--)
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
        appointments.splice(index, 1);//remove the selected appointment
        draggableDiv.appointmentId = appointment.appointmentId;
        for(var k = 0; k < appointment.length; k++)
        {
            if(appointment[k] == element.id)
            {
                clickedArea = k;
            }
            var previousAppointmentIndex = isCellUsed(appointment[k]);
            if(previousAppointmentIndex!=-1)//cell used by other appointment
            {
                findCell(appointment[k]).state = bookingState;//reset the cell's state back to booking
                var previousAppointment = appointments[previousAppointmentIndex];
                var firstRow = getRowId(previousAppointment[0]);
                var lastRow = getRowId(previousAppointment[previousAppointment.length-1]);
                var currentRow = getRowId(appointment[k]);
                var secondPreviousAppointmentIndex = isCellOverlapped(appointment[k], previousAppointmentIndex);
                if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
                {
                    var thirdPreviousAppointmentIndex = isCellOverlappedTwice(appointment[k],previousAppointmentIndex,secondPreviousAppointmentIndex);
                    if(thirdPreviousAppointmentIndex!=-1)//the cell was previously overlap at least twice
                    {
                        if(currentRow == firstRow)
                        {
                            document.getElementById(appointment[k]).className = overlapTwiceHeadClass;;//reset the td's class back to overlap head
                        }
                        else if (currentRow == lastRow)
                        {
                            document.getElementById(appointment[k]).className = overlapTwiceTailClass;;//reset the td's class back to overlap tail    
                        }
                        else
                        {
                            document.getElementById(appointment[k]).className = overlapTwiceBodyClass;;//reset the td's class back to overlap body  
                        }
                        if(firstRow == lastRow)
                        {
                            document.getElementById(appointment[k]).className = overlapTwiceComboClass;;//reset the td's class back to overlap combo
                        }
                    }
                    else
                    {
                        if(currentRow == firstRow)
                        {
                            document.getElementById(appointment[k]).className = overlapHeadClass;;//reset the td's class back to overlap head
                        }
                        else if (currentRow == lastRow)
                        {
                            document.getElementById(appointment[k]).className = overlapTailClass;;//reset the td's class back to overlap tail    
                        }
                        else
                        {
                            document.getElementById(appointment[k]).className = overlapBodyClass;;//reset the td's class back to overlap body  
                        }
                        if(firstRow == lastRow)
                        {
                            document.getElementById(appointment[k]).className = overlapComboClass;;//reset the td's class back to overlap combo
                        }       
                    }
                }
                else//the cell was not previously overlap
                {
                    if(currentRow == firstRow)
                    {
                        document.getElementById(appointment[k]).className = bookingHeadClass;;//reset the td's class back to booking head
                    }
                    else if (currentRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = bookingTailClass;;//reset the td's class back to booking tail    
                    }
                    else
                    {
                        document.getElementById(appointment[k]).className = bookingBodyClass;;//reset the td's class back to booking body  
                    }
                    if(firstRow == lastRow)
                    {
                        document.getElementById(appointment[k]).className = bookingComboClass;;//reset the td's class back to booking combo
                    } 
                }
            }
            else//not used
            {
                findCell(appointment[k]).state = emptyState;//reset the cell's state back to empty
                document.getElementById(appointment[k]).className = emptyClass;//reset the td's class back to empty
            }
        }
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
                appointmentCells.rowStart = start;
                appointmentCells.rowEnd = end;
                appointmentCells.column = getColumnId(cell.id);
                var ok = true;
                if(start < 0)
                {
                    ok = false;
                }
                if(end > rowCount)
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
                        var previousAppointmentIndex = isCellUsed(add.id);
                        if(previousAppointmentIndex!=-1)//cell used by other appointment
                        {
                            var secondPreviousAppointmentIndex = isCellOverlapped(add.id, previousAppointmentIndex);
                            if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
                            {
                                if(j == start)//appointment start
                                {
                                    document.getElementById(add.id).className = overlapTwiceHeadClass;
                                }
                                else if(j == end - 1)//appointment tail
                                {
                                    document.getElementById(add.id).className = overlapTwiceTailClass;
                                }
                                else//appointment body
                                {
                                    document.getElementById(add.id).className = overlapTwiceBodyClass;
                                }
                                if(start == end -1)//only one cell
                                {
                                    document.getElementById(add.id).className = overlapTwiceComboClass;
                                }
                            }
                            else
                            {
                                if(j == start)//appointment start
                                {
                                    document.getElementById(add.id).className = overlapHeadClass;
                                }
                                else if(j == end - 1)//appointment tail
                                {
                                    document.getElementById(add.id).className = overlapTailClass;
                                }
                                else//appointment body
                                {
                                    document.getElementById(add.id).className = overlapBodyClass;
                                }
                                if(start == end -1)//only one cell
                                {
                                    document.getElementById(add.id).className = overlapComboClass;
                                }
                            }
                        }
                        else//not used by other appointments
                        {
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
                    appointmentCells.rowStart = startRow;
                    appointmentCells.rowEnd = endRow;
                    appointmentCells.column = column;
                    for(var k = startRow; k <= endRow; k++)
                    {
                        add  = findCell(k+"^-^"+column);
                        var previousAppointmentIndex = isCellUsed(add.id);
                        if(previousAppointmentIndex!=-1)//cell used by other appointment
                        {
                            var secondPreviousAppointmentIndex = isCellOverlapped(add.id, previousAppointmentIndex);
                            if(secondPreviousAppointmentIndex!=-1)//the cell was previously overlap
                            {
                                if(k == startRow)//appointment start
                                {
                                    document.getElementById(add.id).className = overlapTwiceHeadClass;
                                }
                                else if(k == endRow)//appointment tail
                                {
                                    document.getElementById(add.id).className = overlapTwiceTailClass;
                                }
                                else//appointment body
                                {
                                    document.getElementById(add.id).className = overlapTwiceBodyClass;
                                }
                                if(startRow == endRow)//only one cell
                                {
                                    document.getElementById(add.id).className = overlapTwiceComboClass;
                                }
                            }
                            else
                            {
                                if(k == startRow)//appointment start
                                {
                                    document.getElementById(add.id).className = overlapHeadClass;
                                }
                                else if(k == endRow)//appointment tail
                                {
                                    document.getElementById(add.id).className = overlapTailClass;
                                }
                                else//appointment body
                                {
                                    document.getElementById(add.id).className = overlapBodyClass;
                                }
                                if(startRow == endRow)//only one cell
                                {
                                    document.getElementById(add.id).className = overlapComboClass;
                                }
                            }
                        }
                        else//not used by other appointments
                        {
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
                        }
                        add.state = bookingState;
                        appointmentCells.push(add.id);
                    }
                }
                appointmentCells.appointmentId = draggableDiv.appointmentId;
                appointments.push(appointmentCells);
                updateAppointmentPosition(appointmentCells.appointmentId,appointmentCells.rowStart,appointmentCells.rowEnd, appointmentCells.column);
                find = true;
                break;
            }
        }
        if(!find)
        {

        }
        draggableDiv.style.display = "none";
    }
}

function updateAppointmentPosition(appointmentId,rowStart,rowEnd,column)
{
    var ajax = new Ajaxer("text",null,null,null);
    var queryString="appointment_action=QuickSave&";
    queryString+="appointment_no="+appointmentId+"&";
    queryString+="employee_no="+employeeIDArray[column]+"&";
    queryString+="start_time="+getTimeFromRow(rowStart)+"&";
    queryString+="end_time="+getTimeFromRow(rowEnd)+"&";
    //alert(queryString);
    ajax.request("appointment",queryString);
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
    return parseInt(rowid);
}

function getColumnId(id)//function to get the column number from a given cell id
{
    var columnid = id.split("^-^")[1];
    return parseInt(columnid);
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

function isCellUsed(id)//function that checks to see if the any cells in the range has been used by another appointment
{
    for(var i=appointments.length -1; i>=0;i--)
    {
        var appointment = appointments[i];
        for(var j=0;j<appointment.length;j++)
        {
            if(appointment[j]==id)
            {
                return i;
            }
        }
    }
    return -1;
}

function getCellAppointmentId(id)
{
    var index = isCellUsed(id);
    if(index!=-1)
    {
        return appointments[index].appointmentId;
    }
    else
    {
        return -1;
    }
}

function isCellOverlapped(id, firstAppointmentIndex)
{
    for(var i=appointments.length -1; i>=0;i--)
    {
        if(i==firstAppointmentIndex)
        {
            continue;
        }
        var appointment = appointments[i];
        for(var j=appointment.length -1;j>=0;j--)
        {
            if(appointment[j]==id)
            {
                return i;
            }
        }
    }
    return -1;
}

function isCellOverlappedTwice(id, firstAppointmentIndex, secondAppointmentIndex)
{
    for(var i=appointments.length -1; i>=0;i--)
    {
        if(i==firstAppointmentIndex)
        {
            continue;
        }
        if(i==secondAppointmentIndex)
        {
            continue;
        }
        var appointment = appointments[i];
        for(var j=appointment.length -1;j>=0;j--)
        {
            if(appointment[j]==id)
            {
                return i;
            }
        }
    }
    return -1;
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