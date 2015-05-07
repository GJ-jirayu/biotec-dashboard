<%@page contentType="text/html" pageEncoding="utf-8"%>
<!doctype html>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("#0.00");
%>
<html>
    <head>
        <title>Finance Dashboard</title>
		<link href="../styles/kendo.common.min.css" rel="stylesheet">
		<link href="../styles/kendo.default.min.css" rel="stylesheet">
		<link href="../jqueryUI/css/cupertino/jquery-ui-1.8.21.custom.css" rel="stylesheet">
		<link href="../styles/kendo.dataviz.min.css" rel="stylesheet">
        <script src="../js/jquery.min.js"></script>
		<script src="../js/kendo.all.min.js"></script>
		<!--<script src="../js/kendo.dataviz.min.js"></script>-->
		<script type="text/javascript" src="../jqueryUI/js/jquery-ui-1.8.21.custom.min.js"></script>
		<style type="text/css">
			html,body {
				background-color: white;
				color:black;
				margin:0px;
				padding:0px;
				font-size:11px;
				font:Tahoma;
			}
			#Detail-Panel {
				position:absolute;
				top:80px;
				left:0px;
				border-radius: 5px;
				border: 1px solid #dedede;
			}
			#loading{
			display:none;
			color:black;
			width:50px;
			height:50px;
			background-image:url("../images/loading.gif");
			position:absolute ;
			position:center;
			z-index:5;
			}
			.inlinesparkline{
			width:100px;
			height:100px;
			}
			.contentMain{
			display:none;
			width:975px;
			margin:auto;
			}
		</style>
		<style scoped>
				#Main-Panel{
					padding: 3px;
					margin:0px;
					margin-bottom:2px;
					-webkit-border-radius: 5px;
					-moz-border-radius: 5px;
					border-radius: 5px;
					text-align: left;
					min-height: 30px;
					width: 970px;
					position: relative;
					background:#008EC3;
					font-weight:bold;
					color:white;
					font-size:12px;
				}
			</style>
	<%

		/*------------------- Set Variable --------------------*/

		String ParamYear = "";
		String ParamMonth = "";
		String ParamOrg = "";

		String V_Year = ""; // Values of Parameter Organization
		String V_Month = ""; // Values of Parameter Sales Region
		String V_Org = ""; // Values of Parameter Branch

		/*------------------- End Set Variable -------------------*/

		//###############Query Handler Organization start  ####################
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
	//insert code allow function start
	st = conn.createStatement();
		Query="CALL sp_business_area();";
		rs = st.executeQuery(Query);
		 
		while(rs.next()){
		//out.println(rs.getString("center_name"));
		V_Org+="<option value="+rs.getString("business_area")+">"+rs.getString("business_area")+"</option>";
		}
	//insert code allow function end
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
//############### Query Handler Organization end ###############

//############### Query Handler Year & Month start ###############
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
	//insert code allow function start
	st = conn.createStatement();
		/*------------------- Parameter Year & Month  -------------------*/
		rs = null;
		Query  = "SELECT Date_format(SYSDATE(),'%Y') as year_date,Date_format(SYSDATE(),'%m') as month_date;";
		rs = st.executeQuery(Query);
		rs.next();
		int	cYear =  Integer.parseInt(rs.getString("year_date"));
		int	cMonth = Integer.parseInt(rs.getString("month_date"))-1;
		if((cMonth+3) > 12) {
			cYear = cYear+1 ;
		}
		if((cMonth+3)%12!=0){
			cMonth = (cMonth+3)%12;
		}
		else{
			cMonth = 12;
		}
		Query="CALL sp_fiscal_year;";
		rs = st.executeQuery(Query);
		while(rs.next()){
			if( rs.getString("fiscal_year").equals(cYear+"")){
				V_Year += "<option value=\""+rs.getString("fiscal_year")+"\"  selected='selected'>"+rs.getString("buddhist_era_year")+"</option>";
			}
			else{
				V_Year += "<option value=\""+rs.getString("fiscal_year")+"\">"+rs.getString("buddhist_era_year")+"</option>";
			}
		}
		rs = null;
		Query="CALL sp_fiscal_month;";
		rs = st.executeQuery(Query);
		while(rs.next()){
			if(rs.getString("fiscal_month_no").equals(cMonth+"")){
				V_Month += "<option value=\""+rs.getString("fiscal_month_no")+"\"  selected='selected'>"+rs.getString("calendar_th_month_name")+"</option>";	
			}else{
				V_Month += "<option value=\""+rs.getString("fiscal_month_no")+"\">"+rs.getString("calendar_th_month_name")+"</option>";
			}				
		}
		// set select
	//insert code allow function end
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
//############### Query Handler Year & Month start ###############
	%>
	<script type="text/javascript">
	/*#### Tab search above top start ###*/
	$(document).ready(function(){
	
	/*#### Loading Start ###*/
		var $width=($('body').width()/2)-50;
		//console.log($width);
		$("#loading").css({"top":"250px","left":$width+"px"}).ajaxStart(function(){
		$(this).show();
		}).ajaxStop(function(){
		$(this).hide();
		});
	/*#### Loading End ###*/
	/*Config table suffer table*/
	var sufferTable = function(){
//#######################Menagement Tab Start ######################
		/*Remove  numberic  bottom tab*/
		$("ul.k-numeric li span").removeClass();
		$("ul.k-numeric li span").html("");
		/*Remove  numberic  bottom tab*/
		/*Header Bgcolor*/
		$("th.k-header").css({"background":"#008EC3 "});
		$(".k-grid-header").css({"background":"#008EC3 "});
		/*Header Bgcolor*/

		/*Footer Bgcolor*/
		$(".k-pager-wrap").css({"background":"#008EC3"});
		/*Footer Bgcolor*/
		
		}
var setFont = function(){
		/*Config font*/
		$(".k-draghandle").css({"font-size":"50%"}); 
		//$(".k-grid td").css({"padding":"0px"});
		$(".k-grid td").css({"padding-top":"0px","padding-bottom":"0px"});
		/*Config font*/
}
var setHeader= function(){
	//Set and Config Parameter Now!
	$(".k-header").css({"padding":"2px"});
}
//จัดการส่วนหัวตาราง Tab2
var setHeaderDateYear = function(paramYear,YearPrev){

	$(".k-grid-header-wrap table thead ").prepend("<tr><th></th><th style='border-bottom:1px solid white; border-left:1px solid white; color:white;'>รายการ</th><th colspan='3' style='border-bottom:1px solid white; border-left:1px solid white; color:white;'>ปี "+paramYear+"</th><th style='border-bottom:1px solid white; border-left:1px solid white; color:white;'>ปี "+YearPrev+"</th></tr>");
}
//#######################Menagement Tab End #######################

	  $("#ParamYear").kendoDropDownList();

	  $("#ParamMonth").kendoDropDownList();

	  $("#ParamOrg").kendoDropDownList();
   
	/*#### Tab search above top end ###*/

	/*#### jquery manage tab below start ###*/
	$( "#tabs" ).tabs();

	// ajax start 01

	$("[href=#content1]").click(function(){
		$(".pageRemember").remove();
		$("body").append("<input type='hidden' id='pageContent1' class='pageRemember' name='pageContent1' value='pageContent1'>");

	$.ajax({
		url:'sp_balance_sheet_list_by_center.jsp',
		type:'get',
		dataType:'html',
		data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramOrg':$('#domParamOrg').val()},
		success:function(data){

	$("#content1").empty();
	$("#content2").empty();
	$("#content3").empty();
	$("#content4").empty();

    $("#content1").append(data);
		//pieChart1();
		}
	});
	});
		// ajax end 01
		// ajax start 02
			$("[href=#content2]").click(function(){
				$(".pageRemember").remove();
				$("body").append("<input type='hidden' id='pageContent2' class='pageRemember' name='pageContent2' value='pageContent2'>");
			$.ajax({
				'url':'sp_profit_and_loss_list_by_center.jsp',
				'type':'get',
				'dataType':'html',
				data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramOrg':$("#domParamOrg").val()},
				success:function(data){
				$("#content1").empty();
				$("#content2").empty();
				$("#content3").empty();
				$("#content4").empty();			
				$("#content2").append(data);			
				//if data content is null will content is hidden
				if($(".textR").text()==""){
					$("#content2").empty();
				}

				$("#chart2").empty();
				sufferTable();
				setFont();
				setHeader();
		//เรียกฟังก์ชั่นจัดการส่วนหัวของตาราง Tab2
			var YearInt = parseInt($('#domParamYear').val())+543;
			var YearPrev =  parseInt($('#domParamYear').val())+542;
			setHeaderDateYear(YearInt,YearPrev);
				}
			});
			
			});

		// ajax end 02
		// ajax start 03

			$("[href=#content3]").click(function(){
		
				$(".pageRemember").remove();
				$("body").append("<input type='hidden' id='pageContent3' class='pageRemember' name='pageContent3' value='pageContent3'>");
			//alert("hello jquery");

			$.ajax({
				'url':'sp_balance_sheet_list.jsp',
				'type':'get',
				'dataType':'html',
				data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramOrg':$("#domParamOrg").val()},
				success:function(data){
				$("#content1").empty();
				$("#content2").empty();
				$("#content3").empty();
				$("#content4").empty();
				$("#content3").append(data);
				}
			});
			});
	$("[href=#content4]").click(function(){
		$(".pageRemember").remove();
		$("body").append("<input type='hidden' id='pageContent4' class='pageRemember' name='pageContent4' value='pageContent4'>");
	$.ajax({
		'url':'sp_profit_and_loss_list.jsp',
		'type':'get',
		'dataType':'html',
		data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramOrg':$("#domParamOrg").val()},
		success:function(data){
		$("#content2").empty();
		$("#content1").empty();
		$("#content3").empty();
		$("#content4").empty();
		$("#content4").append(data)
		sufferTable();
		setFont();
		setHeader();
		}
	});
	});
		$("form#form_1").live("submit",function(){
				$(".contentMain").show();
				$(".domParam").remove();
				$("body").append("<input type='hidden' name='domParamYear' id='domParamYear' class='domParam' value='"+$("#ParamYear").val()+"'>");
				$("body").append("<input type='hidden' name='domParamMonth' id='domParamMonth' class='domParam' value='"+$("#ParamMonth").val()+"'>");
				$("body").append("<input type='hidden' name='domParamOrg' id='domParamOrg' class='domParam' value='"+$("#ParamOrg").val()+"'>");

				if($("#pageContent1").val()){
					 $("[href=#content1]").trigger("click");
				}else if($("#pageContent2").val()){
					$("[href=#content2]").trigger("click");
				}else if($("#pageContent3").val()){
					$("[href=#content3]").trigger("click");
				}else if($("#pageContent4").val()){
					$("[href=#content4]").trigger("click");
				}else{
					$("[href=#content1]").trigger("click");
				}
			    return false;
		});
	//สั่งให้รันแสดงผลออกมาโดยไม่กดปุ่ม Submit
	$("form#form_1").trigger("submit");

	/*###  jQuery Config  Tab jQueryUi Start ###*/
	$(".ui-tabs-panel").css("padding","2px");
	/*###  jQuery Config End ###*/
	/*#### jquery manage Tab jQueryUi end ###*/
	});
/*###  function for kendo tootip Start ###*/
function tootipFormat(value,summ){
   var value1 = Math.floor(value);
   var value2 = Math.floor((value/summ)*100);
   return value1 + " , " + value2 + " %";
}
/*###  function for kendo tootip End ###*/
	</script>
    </head>
    <body>
	<!--------------------------- HEADER --------------------------->
	<div align="center">
		<div id="Main-Panel" class="k-content">
		<!--------------------------- Parameter --------------------------->
				<form method="GET" id="form_1">
				<table width=100%>
				<tr>
					<td><label for="ParamYear">ปีงบประมาณ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<select name="ParamYear" id="ParamYear" >
						<%out.print(V_Year);%>
					</select>
					</td>
					<td><label for="ParamMonth">เดือน :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<select name="ParamMonth" id="ParamMonth">
						<%out.print(V_Month);%>
					</select>
					</td>
					<td><label for="ParamOrg">ศูนย์ :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<select name="ParamOrg" id="ParamOrg" >
						<%out.print(V_Org);%>
					</select>
					</td>
					<td>
					<input type="submit"value="&nbsp;&nbsp;OK&nbsp;&nbsp;"  class="k-button" id="submit1" >
					</td>
				</tr>
				</table>
				</form>
		</div>
	</div>
	<!--------------------------- Details Start--------------------------->
	<div class="contentMain">
<!-- TAB MANAGEMENT START -->
		<div id="tabs">
			<ul>
				<li ><a href="#content1">งบแสดงฐานะการเงิน</a></li>
				<li ><a href="#content2">งบรายได้ค่าใช้จ่าย</a></li>
				<li ><a href="#content3">งบแสดงฐานะการเงินแยกศูนย์</a></li>
				<li ><a href="#content4">งบรายได้ค่าใช้จ่ายแยกศูนย์</a></li>
			</ul>
			<div id="content1"></div>
			<div id="content2"></div>
			<div id="content3"></div>
			<div id="content4"></div>
<br style="clear:both" />
</div>
<!-- TAB MANAGEMENT END -->
	</div>
	<div id="loading" >
				<br>
				<br>
				<br>
				<br>
				<span id="loading_span" style="margin-top:100px;">
					<b>Loading...</b>
				</span>
			</div>
	<!--------------------------- Details End--------------------------->
	</body>
</html>