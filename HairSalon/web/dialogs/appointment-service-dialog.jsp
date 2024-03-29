<div id="secondary_blackout" style="display:none; position: absolute;left: 0px; top: 0px; background-color: #000000;opacity: .5; filter: alpha(opacity=70); z-index: 3009;"></div>

<script>
    var screenHeight = getScreenHeight();
    var screenWidth = getScreenWidth();
	
    if (screenHeight > document.body.scrollHeight)
        document.getElementById("secondary_blackout").style.height = screenHeight + "px";
    else
        document.getElementById("secondary_blackout").style.height = document.body.scrollHeight + "px";
	
    if (screenWidth > document.body.scrollWidth)
        document.getElementById("secondary_blackout").style.width = screenWidth + "px";
    else
        document.getElementById("secondary_blackout").style.width = document.body.scrollWidth + "px";
    
    function showSecondaryBlackout(value)
    {
	if (value == true)
	    document.getElementById("secondary_blackout").style.display="block";
	else
	    document.getElementById("secondary_blackout").style.display="none";
    }
</script>

<div id="appointment_service_dialog" class="DialogBox" style="width: 600px;height: 400px; z-index:3010;">
     <table bgcolor="#FFFFFF" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	    <td><img src="images/scheduler/scheduler_topleft.gif" width="2" height="33" /></td>
	    <td align="center" width="100%" background="images/scheduler/scheduler_topheader.gif"><b><font color="#FFFFFF">Add Service</font></b></td>
	    <td><img src="images/scheduler/scheduler_topright.gif" width="2" height="33" /></td>
	</tr>
	<tr>
	    <td height="100%" background="images/scheduler/scheduler_left.gif"><img src="images/scheduler/scheduler_left.gif" width="2" height="32" /></td>
	    <td width="100%">
		<div style="height:400px; overflow:auto; overflow-y: scroll; overflow-x: hidden;">
		<table height="100%" width="98%" border="0" cellspacing="10" cellpadding="0">
		    <tr>
			<td colspan="2">
			    <table border="0" width="100%">
				<tr>
				    <td align="left" valign="top" width="100%">Click the add button beside services you want to add. You can filter the search results if necessary.</td>
				</tr>
			    </table> 
			</td>
		    </tr>
		    <tr height="100%">
			<td valign="top">
			    <table>
				<tr>
				    <td>
					<table border="0" cellpadding="0">
					    <tr>
						<td align="right"><img border="0" src="/HairSalon/images/icons/small/service_white.gif" width="16" height="16"></td>
						<td align="left"><u><b>Service Details</b></u></td>
					    </tr>
					    <tr>
						<td align="right">Name:</td>
						<td align="left"><input type="text" id="searchServiceName" name="searchServiceName" size="15"></td>
					    </tr>
					</table>
				    </td>
				</tr>
				<tr>
				    <td>
					<table width="100%" border="0" cellpadding="10">
					    <tr>
						<td align="center">
						    <input type="button" onclick="searchServices()" value="Search" class="StandardButton"/><br />
						    <input type="button" onclick="closeAddService()" value="Close" class="StandardButton"/>
						</td>
					    </tr>
					</table>
				    </td>
				</tr>
			    </table>
			</td>
			
			<td id="serviceResult" width="100%" align="left" valign="top">
			    <table width="100%" cellspacing="0" cellpadding="0" class="SearchLine">
				<tr align="left">
				    <td height="25" nowrap="nowrap" class="Row4"><b><font color="#FFFFFF">&nbsp;Search Results (None)</font></b></td>
				</tr>
				<tr>
				    <td>
					<table width="100%" cellspacing="1" cellpadding="4" border="0">
					    <tr align="center" valign="middle">
						<td height="30" class="Row7" nowrap="nowrap"></td>
						<td colspan="3" align="left" class="Row2"><b>Click search to obtain results.</b></td>
					    </tr>
					</table>
				    </td>
				</tr>
			    </table>
			</td>
		    </tr>
		</table>
		</div>
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
    document.getElementById("appointment_service_dialog").style.left = (getScreenWidth() / 2) - 300 + "px";
    document.getElementById("appointment_service_dialog").style.top = (getScreenHeight() / 2) - 200 + "px";
</script>