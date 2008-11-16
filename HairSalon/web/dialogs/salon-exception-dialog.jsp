<div id="salon_exception_dialog" class="DialogBox" style="width: 250px;height: 125px;">
    <table bgcolor="#FFFFFF" height="125" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
            <td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Add Schedule Exception</font></b></td>
            <td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
        </tr>
        <tr>
            <td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
            <td height="100%" width="100%">
                
                <!-- CONTENT START -->
                
                <table height="100%" width="100%" border="0" cellspacing="10" cellpadding="0">
                    <tr>
                        <td height="100%" valign="top">
                            <table border="0" cellpadding="0">
                                <tr>
                                    <td align="right"><img border="0" src="/HairSalon/images/icons/small/exception_white.gif" width="16" height="16"></td>
                                    <td align="left"><u><b>Schedule Exception</b></u></td>
                                </tr>
                                <tr>
                                    <td id="lblDate" align="right">Date:</td>
                                    <td align="left"><input onKeyUp="checkExceptionFields()" type="text" id="exceptionDate" name="product_name" size="10">&nbsp;DD/MM/YYYY</td>
                                </tr>
                                <tr>
                                    <td id="lblReason" align="right">Reason:</td>
                                    <td align="left"><input onKeyUp="checkExceptionFields()" type="text" id="exceptionReason" name="brand" size="25"></td>
                                </tr>
                            </table>
                            <table cellpadding="10">
                                <tr>
                                    <td>
                                        <input type="button" id="btnAddException" disabled="true" onclick='addException(document.getElementById("exceptionDate").value,document.getElementById("exceptionReason").value)' value="Add" />
                                        <input type="button" onclick="closeAddException()" value="Close" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                
                <script>
                    function checkExceptionFields()
                    {
                        var goodDate = checkDateInput("exceptionDate");
                        var goodReason = (document.getElementById("exceptionReason").value!="");
                        if(!goodDate)
                        {
                            document.getElementById("lblDate").innerHTML="<font color='red'>Date:</font>";
                        }
                        else
                        {
                            document.getElementById("lblDate").innerHTML="<font color='green'>Date:</font>";   
                        }
                        if(!goodReason)
                        {
                            document.getElementById("lblReason").innerHTML="<font color='red'>Reason:</font>";
                        }
                        else
                        {
                            document.getElementById("lblReason").innerHTML="<font color='green'>Reason:</font>";
                        }
                        if(goodDate&&goodReason)
                        {
                            document.getElementById("btnAddException").disabled = false;
                        }
                    }
                </script>
                
                <!-- CONTENT END -->
                
            </td>
            <td height="100%" background="images/scheduler/scheduler_right.gif"></td>
        </tr>
        <tr>
            <td><img src="images/site_bottomleft.gif" width="2" height="2" /></td>
            <td width="100%" background="images/scheduler/scheduler_bottom.gif"><img src="images/scheduler/scheduler_bottom.gif" width="90" height="2" /></td>
            <td><img src="images/scheduler/scheduler_bottomright.gif" width="2" height="2" /></td>
        </tr>
    </table>
</div>

<script>
    document.getElementById("salon_exception_dialog").style.left = (getScreenWidth() / 2) - 125 + "px";
    document.getElementById("salon_exception_dialog").style.top = (getScreenHeight() / 2) - 63 + "px";
</script>