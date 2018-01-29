<%@page import="javax.mail.Session"%>
<%@page import="com.facekeeper.dto.MessageDTO"%>
<%@page import="java.awt.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="com.facekeeper.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mytechnopal.*" %>
<%@ page import="com.mytechnopal.dto.*" %>
<%@ page import="com.mytechnopal.util.*" %>
<%@ page import="com.mytechnopal.webcontrol.*" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title><%=SettingsUtil.OWNER_CODE.equalsIgnoreCase(SettingsUtil.OWNER_CODE_FK)?"Demo":SettingsUtil.OWNER_CODE%> - FaceKeeper</title>
	<script src="common/jquery-latest.js"></script>
	<script type="text/javascript" src="common/webcam/webcam.js"></script>
	<script type="text/javascript" src="common/technopal/general.js"></script>
	<!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.4 -->
    <link href="common/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />s
	<jsp:include flush="true" page="css.jsp"></jsp:include>
</head>

<body>
<div id="myCamera" style="display:none"></div>
<input type="hidden" id="txtGroupNum" value="1" />
<%
if(SettingsUtil.OWNER_CODE.equalsIgnoreCase(SettingsUtil.OWNER_CODE_FK)) {
%>
    <input class="form-control input-sm text-right" type="text" maxlength="11" placeholder="Input your CP# here. eg 09181234567 and press enter. FaceKeeper recommend to use Firefox browser." id="txtRFID" onkeypress="executeTap(event, this.value)">
    <script>
	    function executeTap(e, val) {
	        if(e.keyCode === 13) {
	        	e.preventDefault(); // Ensure it is only this code that runs
	           	tap(val, document.getElementById("txtGroupNum").value);
	        }
	    }
	</script>
<%
}
else {
%>
	<input type="hidden" id="txtRFID" />
<%	
}
%>
<div class="container" style="margin-top: 15px;" >
	<div class="col-sm-6 pull-left no-padding" style="height:87%;overflow:hidden;position: relative;">
		<div class="" style="width:107%;height:100%; padding-right:8%;overflow:hidden;">
			<div id='pict2' class='container col-sm-12 text-center'></div>
			<div id='pict3' class='container col-sm-12 text-center'></div>
			<div id='pict4' class='container col-sm-12 text-center'></div>
		</div>
	</div>
	<div id='pict1' class="col-sm-6 pull-right"></div>
</div>

<div class="footer navbar-fixed-bottom" style="background:<%=SettingsUtil.OWNER_PRIMARY_COLOR%>">
	<marquee>
		<h1 style="color:white;">
		<%
		if(SettingsUtil.OWNER_CODE.equalsIgnoreCase(SettingsUtil.OWNER_CODE_FK)) {
		%>
			FaceKeeper Demo Version Powered by Technopal Software. For inquiries please email mytechnopal@gmail.com.
		<%	
		}
		else {
		%>
			<%=SettingsUtil.OWNER_CODE%> FaceKeeper Powered by Technopal Software <span id="message"></span>
		<%
		}
		%>
		</h1>
	</marquee>	
</div>	

<script>
Webcam.set({
	width: 320,
	height: 250,
	image_format: 'jpg',
	jpeg_quality: 90,
});
Webcam.attach('#myCamera');
</script>

<script>
function showAlert(msg, duration) {
	 var el = document.createElement("div");
	<%--  if(msg.substring(0, 14) =="Double Topped!") {
		 el.setAttribute("style","text-align:center;position:absolute;top:75%;left:45%;padding:30px 60px;border-radius:10px;background-color:<%=SettingsUtil.OWNER_PRIMARY_COLOR%>;box-shadow: 2px 3px 3px 1px rgba(0, 0, 0, 0.2);font-weight:600;color:white; opacity:0.8;");
	 } else { --%>
	el.setAttribute("style","text-align:center;position:absolute;top:75%;left:70%;padding:20px 50px;border-radius:10px;background-color:<%=SettingsUtil.OWNER_PRIMARY_COLOR%>;box-shadow: 2px 3px 3px 1px rgba(0, 0, 0, 0.2);font-weight:600;color:white; opacity:0.8;");
	 //}
	 el.innerHTML = "<h4>" + msg + "</h4>";
	 setTimeout(function() {
	 	el.parentNode.removeChild(el);
	 	}, duration);
	 document.body.appendChild(el);
}

function tap() {
	if(<%=SettingsUtil.OWNER_CODE.equalsIgnoreCase(SettingsUtil.OWNER_CODE_FK)%>) {
		if(isValidCPNumber($('#txtRFID').val())) {
			displayFace();
		}
		else {
			showAlert("Cellphone number is invalid", 5000);
		}
	}
	else {
		displayFace();
	} 
}

function displayFace() {
	if($('#txtRFID').val().length == 0) {
		showAlert("RFID is Empty", 5000);
	}
	else if($('#txtRFID').val().length < 10) {
		showAlert("RFID is Invalid", 5000);
	}
	else {
		Webcam.snap(function(dataUri) {
			$.ajax({
		    	url: 'AjaxController',
		    	data: {
		    		rfid: $('#txtRFID').val().substring(0, 10),
		    		groupNum: $('#txtGroupNum').val(),
		    		pict: dataUri
		    	},
		    	method: 'POST',
		    	dataType: 'JSON',
		    	success: function(response) {
		    		if(response.errMsg) {
		    			showAlert(response.errMsg, 5000);
		    		}
		    		else {
		    			$("#txtGroupNum").val(response.nextGroupNum);
			    		$("#pict4").html($("#pict3").html());
				    	$("#pict3").html($("#pict2").html());
				    	$("#pict2").html($("#pict1").html());
				    	$("#pict1").html(getHTMLStr(response.isIn, response.timeInPict, response.profilePict, response.firstName, response.lastName, response.timestamp));
		    		}
		    	}
			});	
		});
	}
	$('#txtRFID').val("");
}

function getHTMLStr(isIn, timeInPict, profilePict, firstName, lastName, timestamp) {
	inOutStr = "OUT";
	inOutClass = "is_out";
	if(isIn) {
		inOutStr = "IN";
		inOutClass = "is_in";
	}
	return "<div class='pict_base'>"
			+ "		<div class='face_log'>"
			+ "			<img id='face_log' src='" +  timeInPict +"'>"
			+ "		</div>"
			+ "		<div class='bottom_part'>"
			+ "			<div class='avatar'>"
			+ "				<img id='avatar' src='" + profilePict +"'>"
			+ "			</div>"
			+ "			<div class='details'>"
			+ "   			<p class='firstname'>" + firstName + "</p>"
			+ "   			<p class='lastname'>" + lastName + "</p>"
			+ "   			<p class='timestamp'>" + timestamp + "</p>"
			+ "			</div>"
			+ "		</div>"
			+ "		<div class='" + inOutClass + "'>" + inOutStr + "</div>"
			+ "</div>";
}

<%
if(!SettingsUtil.OWNER_CODE.equalsIgnoreCase(SettingsUtil.OWNER_CODE_FK)) {
%>
	$(document).on('keyup', function(e){
		if(e.keyCode == 13) {
			tap();
		}
		else {
			$("#txtRFID").val($("#txtRFID").val() + String.fromCharCode(e.keyCode));
		}
	})
<%
}
%>
</script>

<script type="text/javascript">

//<span id="message"></span>
var message1 = "";
var message2 = "";
var message3 = "";
var message4 = "";

var timeVariable1 = 0;
var timeVariable2 = 0;
var timeVariable3 = 0;
var timeVariable4 = 0;

var ajaxSwitchValueComparator = 0;

	$(document).ready(function(){
		ajax();
		tick();
	})

	function ajax(){
		message = $('#message').val();
		$.ajax({
			type:'POST',
			data:{message: message},
			url:'MainController',
			success: function(result){
				var messags = result.length;
				console.log("legnth of the message: "+ messags);
				message1 = result;
				timeVariable1 = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				var messag = result.length; var tim = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				//console.log("Setting Value Ajax message1 count: " + messag+ " / timeVariable1: " + tim);
			}
		})
	}

	function ajax1(){
		message = $('#message').val();
		$.ajax({
			type:'POST',
			data:{message: message},
			url:'MainController',
			success: function(result){
				message2 = result;
				timeVariable2 = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				var messag = result.length; var tim = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				//console.log("Setting Value Ajax message1 count: " + messag+ " / timeVariable1: " + tim);
			}
		})
	}
	
	function ajax2(){
		message = $('#message').val();
		$.ajax({
			type:'POST',
			data:{message: message},
			url:'MainController',
			success: function(result){
				message3 = result;
				timeVariable3 = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				var messag = result.length; var tim = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				//console.log("Setting Value Ajax message1 count: " + messag+ " / timeVariable1: " + tim);
			}
		})
	}

	function ajax3(){
		message = $('#message').val();
		$.ajax({
			type:'POST',
			data:{message: message},
			url:'MainController',
			success: function(result){
				message4 = result; //1C
				timeVariable4 = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				var messag = result.length; var tim = ((Math.round(result.length/<%=MessageDTO.DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND %>)*1000)+<%=MessageDTO.DEFAULT_TIME %>);
				//console.log("Setting Value Ajax message1 count: " + messag+ " / timeVariable1: " + tim);
			}
		})
	}

	function tick() {
		setTimeout(function() {
			$('#message').html(message1);
			ajax1()
			tick2();
		},parseInt(<%=MessageDTO.DEFAULT_TIME %>, 10)+1);
	}

	function tick2() {
		setTimeout(function() {
			$('#message').html(message2);
			ajax2();
			tick3();
		},timeVariable1);//timeVariable1
	}

	function tick3() {
		setTimeout(function() {
			$('#message').html(message3);
			ajax3();
			tick4();
		},timeVariable2);
	}

	function tick4() {
		setTimeout(function() {
			$('#message').html(message4);
			ajax();
			tick5();
		},timeVariable3);
	}

	function tick5() {
		setTimeout(function() {
			$('#message').html(message1);
			ajax1();
			tick2();
		},timeVariable4);
	}
</script>
<!-- Bootstrap 3.3.2 JS -->
<script src="common/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
</body>
</html>