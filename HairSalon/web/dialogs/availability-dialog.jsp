<%@ taglib prefix="taglib" uri="/WEB-INF/taglib.tld"%>
<taglib:ValidateEmployee minimum="Manager" />
<div id="availability_dialog_shell" class="DialogBox">
</div>

<script language="javascript" src="js/time-addin.js"></script>
 
<script>
    document.getElementById("availability_dialog_shell").style.left = (getScreenWidth() / 2) - (document.getElementById("availability_dialog_shell").clientWidth / 2) + "px";
    document.getElementById("availability_dialog_shell").style.top = (getScreenHeight() / 2) - ((document.getElementById("availability_dialog_shell").clientHeight / 2))  + "px";
</script>