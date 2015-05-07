<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<!--- Tab1 -->
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
String paramYear= request.getParameter("paramYear");
String paramMonth= request.getParameter("paramMonth");
String paramMonthPerv= "";
String paramMonthCurent= "";
String paramOrg= request.getParameter("paramOrg");
Integer paramYearInt =Integer.parseInt(paramYear);
Integer paramLastYear = 0;
Integer paramCurentYear = 0;
Integer paramCurentYearLastMonth = 0;
Integer paramMonthInt = Integer.parseInt(paramMonth);
	if ((paramMonthInt-4)>0){ // month > 'Jan'
		paramCurentYearLastMonth=paramYearInt+543;
		paramCurentYear=paramYearInt+543;
		paramLastYear = paramYearInt+542;
	}
	else if((paramMonthInt-4)==0){ //  month  = 'Jan'
		paramCurentYearLastMonth=paramYearInt+542;
		paramCurentYear=paramYearInt+543;
		paramLastYear = paramYearInt+542;
	}
	else{	 // month < 'Jan'
		paramCurentYearLastMonth=paramYearInt+542;
		paramCurentYear=paramYearInt+542;
		paramLastYear = paramYearInt+541;
	}

	 if(paramMonth.equals("1")){
	paramMonthCurent="ต.ค.";
	paramMonthPerv="ก.ย.";

	}else if(paramMonth.equals("2")){
	paramMonthCurent="พ.ย.";
	paramMonthPerv="ต.ค.";
	
	
	}else if(paramMonth.equals("3")){
	paramMonthCurent="ธ.ค.";
	paramMonthPerv="พ.ย.";
	
	}else if(paramMonth.equals("4")){
	paramMonthCurent="ม.ค.";
	paramMonthPerv="ธ.ค.";
	
	}else if(paramMonth.equals("5")){
	paramMonthPerv="ม.ค.";
	paramMonthCurent="ก.พ.";
	}else if(paramMonth.equals("6")){
	paramMonthCurent="มี.ค.";
	paramMonthPerv="ก.พ.";
	
	}else if(paramMonth.equals("7")){
	paramMonthCurent="เม.ษ.";
	paramMonthPerv="มี.ค";
	
	}else if(paramMonth.equals("8")){
	paramMonthCurent="พ.ค.";
	paramMonthPerv="เม.ษ.";
	
	}else if(paramMonth.equals("9")){
	paramMonthCurent="มิ.ย.";
	paramMonthPerv="พ.ค.";
	
	}else if(paramMonth.equals("10")){
	paramMonthCurent="ก.ค.";
	paramMonthPerv="มิ.ย.";
	
	}else if(paramMonth.equals("11")){
	paramMonthCurent="ส.ค.";
	paramMonthPerv="ก.ค.";
	
	}else if(paramMonth.equals("12")){
	paramMonthCurent="ก.ย.";
	paramMonthPerv="ส.ค.";
	
	}
%>
<!-- Config Style-->
	<style type="text/css">
		#mainContent{
		/*border:1px solid #cccccc;*/
		width:auto;
		height:auto;
		}
		#mainContent #row1{
		width:985px;
		height:auto;
		}
		#mainContent #row1 #column1{
		width:700px;
		height:auto;
		background:white;
		float:left;
		}
		#mainContent #row1 #column2{
		width:280px;
		height:auto;
		background:white;
		float:left;
		margin-left:2px;
		}
		#mainContent #row1 #contentL{
		margin-top:10px;
		border:1px solid #dbeef3;
		position:fixed;
		/*background-color:red;*/
		padding:5px;
		border-radius:5px;
		}
		.level2,.level3,.level4{
		cursor:pointer;
		}

	#pie{
	padding:5px;
	}

	#target{
	width:auto;
	margin:auto;
	}
	#target #percentage{
/*	float:left;*/
	width:70px;
	}
	#target #score{
	/*float:right;*/
	width:auto;
	display:block;
	padding:5px;
	}
	.content{
	width:100%
	}
	.content #table_content{
	float:left;
	width:99%
	}
	.content #graph_content{
	float:right;
	width:35%;
	height:auto;
	background-color:#CFCFCF;
	background-image:url("images/highlight.png");
	border-radius:10px;
	}
	.chart-wrapper{
	background-image:url("images/chart-wrapper.png");
	background-color:#CFCFCF;
	}
	#head_graph{
	/*background-color:#CFCFCF;*/
	}
	#table_title{
	background:#CFCFCF;
	border-radius:10px;
	width:99%;
	color:black;
	margin:2px;
	}
	#table_title  #title{

	padding:15px;
	padding-top:20px;
	font-weight:bold;
	font-size:16px;

	}
	#textR{
	/*background:red;*/
	text-align:right;
	padding-right:5px;
	}
	#textL{
	/*background:red;*/
	text-align:left;
	padding-left:5px;
	}
	#kpiN{
	background:#CCCCCC;
	padding:5px;
	display:inline;
	border-radius:5px;
	margin:2px;
	}
	.inlinesparkline{
	cursor:pointer;
	}

	.boxContent{
	width:100%;
	height:550px;
/*	background:#cccccc;*/
	
	}
	.boxContent #boxL{
	/*background:#ffccff;*/
	width:74.8%;
	height:350px;
	float:left;
	}
	.boxContent #boxR{
	/*background:blue;*/
	width:20%;
	height:350px;
	float:right;
	border:1px solid #cccccc;
	border-radius:5px;

	}
	.boxContent #boxB{
	/*background:yellow;*/
	width:100%;
	height:auto;
	clear:both;
	position:center;
	}
	</style>
<!-- Config  Sytle-->
<script>
function addCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}
$(document).ready(function(){
	//#######################Menagement Tab1 Start ######################
		$("table#finance_tb1 thead tr  th").css({"background":"#99ccff  ","padding-left":"5px","padding-right":"5px","color":"black","padding":"2px"});
		$("table#finance_tb1 tbody tr  td .level2").css({"text-align":"left"});
		$("table#finance_tb1 tbody tr  td .level2").parent().nextAll().andSelf().css({"text-align":"right","background":"#99ccff ","font-weight":"bold"});
		$("table#finance_tb1 thead tr:eq(0) th").css({"background":"#008EC3 ","padding-left":"5px","padding-right":"5px","color":"white","padding":"2px"});
		$("table#finance_tb1 thead tr:eq(1) th").css({"background":"#008EC3 ","padding-left":"5px","padding-right":"5px","color":"white","padding":"2px"});
		$(".level3").css({"font-weight":"bold","padding-left":"10px"});
		$(".level3").parent().nextAll().andSelf().css({"background":"#a9e4f4 "});
		$(".level3").parent().nextAll().css({"text-align":"right","font-weight":"bold","background":"#a9e4f4 "});
		$(".level4").css({"padding-left":"20px"});
		$(".level4").parent().nextAll().css({"text-align":"right"});
		$(".level5").css({"padding-left":"30px"});
		$(".level5").parent().nextAll().css({"text-align":"right"});
		$(".level6").css({"padding-left":"40px"});
		$(".level6").parent().nextAll().css({"text-align":"right"});
		$(".level7").css({"padding-left":"50px"});
		$(".level7").parent().nextAll().css({"text-align":"right"});
		$("table#finance_tb1 tbody tr:odd").css({"background":"#ecf8fb"});
		$(".summary").parent().nextAll().andSelf().css({"background":"#99ccff","padding":"5px"});
//#######################Menagement Tab1 Start ######################

//#######################Graph Program Start#######################01

var pieChart= function(paramValue,titleText,paramSum){
		$("#pie").show();
		$("#pie").kendoChart({
			theme:$(document).data("kendoSkin") || "metro",
			chartArea:{
			width:240,
			height:300
			},
			title: {
				 text: titleText['title'],
				font:"14px Tahoma"
			},
			legend: {
                            position: "bottom"
            },

			dataSource: {
                            data: paramValue
                        },
                        series: [{
                            type: "pie",
                            field: "value",
                            categoryField: "category",
                        }],
                        tooltip: {
                            visible: true,
							template: "#= addCommas(value) #, #= kendo.format('{0:P}', percentage)#",
                        },
			seriesDefaults: {
			},
			seriesClick: onSeriesClick
		});
}//function pie chart end

function onSeriesClick(e) { 
	var $account_key=e.dataItem['account_key'];
	var $category = e.category;
	$.ajax({
		url:'sp_balance_sheet_trend.jsp',
		type:'get',
		dataType:'json',
		data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'business_area': $('#domParamOrg').val(),'account_key':$account_key},
			success:function(data){

					barChart(data[0]['series'],$category);
					var $width=$("body").width()-100;

					$("#boxB").dialog({
					width:650,
					modal: true,
					title:"งบแสดงฐานะการเงิน",
					buttons:{
					"OK":function(){
					$(this).dialog("close");
						}
					},
					regend:{
					position:"buttom"
					}
					
					});
		
			}//susscess
	});//ajax

}//funciton
//call Function PieChart 

//call Function BarChart 
var barChart = function(seriesParam,titleParam){

			$("#chart").kendoChart({
			theme:$(document).data("kendoSkin") || "metro",
			title: {
				 text:titleParam
			},
			chartArea: {
			height: 300,
			width:600
			 },
			legend: {
                            position: "bottom"
            },

			series: seriesParam,
			valueAxis: [{
                            title: { text: "" },
							labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            },
                          //  min: 0,
                           // max: 8000
                        }, {
                            name: "Variance",
                            title: { text: "%Variance" },
							labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            },
                            min: 0,
                            max: 5
                        }],

			categoryAxis:{
			 categories: [" ต.ค."," พ.ย."," ธ.ค."," ม.ค."," ก.พ."," มี.ค."," เม.ย."," พ.ค."," มิ.ย."," ก.ค."," ส.ค."," ก.ย."],
			axisCrossingValue: [0,100]
			}
		});
}//function line BarChart end

//Step1  Call Default
var j=0;
var dataLevel2 ="";
var titleText="{\"title\":\"สัดส่วนสินทรัพย์\"}";
var account_key="";
var Sum=0;
dataLevel2+="[";
	$(".level2").each(function(){
	account_key=$(this).attr("id").substring(11);
	var valueMonthParam = $(this).parent().parent().children('td').eq(2).text();
	var valueMonthParamNonComma =valueMonthParam.replace(",","");
	if(j==0){
	dataLevel2+="{";
		dataLevel2+="account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
		Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
	dataLevel2+="}";
	}else{
	dataLevel2+=",{";
			dataLevel2+="account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
	dataLevel2+="}";	
	}
	j++;
	});
	dataLevel2+="]";
	//get is json same dataType in ajax
	var obj = eval ("(" + dataLevel2 + ")"); 
	var obj2=eval("("+titleText+")");
	pieChart(obj,obj2,Sum);
//Step1 Call Default

//Step Call Level2
$(".level2").click(function(e){
	var account_key = this.id;
	var account_key_sub=account_key.substring(11);
	var account_key_loop="";
	var account_key_sub_loop="";
	var dataLevel2 ="";
	var Sum=0;
	var j=0;

	var titleText="{\"title\":\""+$(this).text()+"\"}";

	dataLevel2+="[";
	$(".parent_key"+account_key_sub).each(function(){
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);
		var valueMonthParam = $(this).parent().parent().children('td').eq(2).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");
		if(j==0){
			dataLevel2+="{";
				dataLevel2+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel2+="}";
		}else{
			dataLevel2+=",{";
				dataLevel2+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel2+="}";
		}
		j++;
	});
	dataLevel2+="]";
	var obj=eval("("+dataLevel2+")");
	var obj2=eval("("+titleText+")");
	pieChart(obj,obj2,Sum);
});
//Step Call Level2


//Step Call Level3
$(".level3").click(function(e){
	var account_key = this.id
	var account_key_sub=account_key.substring(11);
	var account_key_loop="";
	var account_key_sub_loop="";
	var Sum=0;
	var titleText="{\"title\":\""+$(this).text()+"\"}";
	var dataLevel3 ="";
	var j=0;
	dataLevel3+="[";
	$(".parent_key"+account_key_sub).each(function(){
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);
		var valueMonthParam = $(this).parent().parent().children('td').eq(2).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");
		if(j==0){
			dataLevel3+="{";
				dataLevel3+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel3+="}";
		}else{
			dataLevel3+=",{";
				dataLevel3+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;	
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel3+="}";
		}
		j++;
	});
	dataLevel3+="]";

	var obj=eval("("+dataLevel3+")");
	var obj2=eval("("+titleText+")");
	pieChart(obj,obj2,Sum);
});
//Step Call Level3

//Step Call Level4
$(".level4").click(function(e){
	var account_key = this.id
	var account_key_sub=account_key.substring(11);
	var account_key_loop="";
	var account_key_sub_loop="";
	var Sum=0;
	//alert(varaccount_key);
	var titleText="{\"title\":\""+$(this).text()+"\"}";
	var dataLevel4 ="";
	var j=0;
	dataLevel4+="[";
	$(".parent_key"+account_key_sub).each(function(){
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);
		var valueMonthParam = $(this).parent().parent().children('td').eq(2).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");
		if(j==0){
			dataLevel4+="{";
				dataLevel4+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel4+="}";
		}else{
			dataLevel4+=",{";
				dataLevel4+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;	
				Sum+=parseFloat($(this).parent().parent().children('td').eq(2).text());
			dataLevel4+="}";
		}
		j++;
	});
	dataLevel4+="]";

	var obj=eval("("+dataLevel4+")");
	var obj2=eval("("+titleText+")");
	pieChart(obj,obj2,Sum);
});
//Step Call Level4
//#######################Graph Program End#######################01
/*### jQuery Request Ghaph End ###*/
	// Add commas
	function addCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

});
</script>
<%
String $htmlTable1="";
Query="CALL sp_balance_sheet_list_by_center("+paramYear+","+paramMonth+",'"+paramOrg+"');";
rs=st.executeQuery(Query);
$htmlTable1+="<table  id='finance_tb1'  width='700' cellpadding='1px' cellspacing='1px' >";
	$htmlTable1+="<thead>";
//tr#########################################1
		$htmlTable1+="<tr>";
			$htmlTable1+="<th width='300'>";
				$htmlTable1+="รายการ";
			$htmlTable1+="</th>";

			$htmlTable1+="<th  colspan='3'>";
				$htmlTable1+="ปี "+(paramYearInt+543);
			$htmlTable1+="</th>";

			$htmlTable1+="<th>";
				$htmlTable1+="ปี "+(paramYearInt+542);
			$htmlTable1+="</th>";

		$htmlTable1+="</tr>";
//tr#########################################1

//tr#########################################2
	$htmlTable1+="<tr>";
		$htmlTable1+="<th  width='200'>";
			$htmlTable1+="";
		$htmlTable1+="</th>";

		$htmlTable1+="<th>";
			String paramCurentYearStr1=String.valueOf(paramCurentYearLastMonth);
			String paramCurentYearSub1=paramCurentYearStr1.substring(2);
			$htmlTable1+=paramMonthPerv+" "+paramCurentYearSub1;
		$htmlTable1+="</th>";

		$htmlTable1+="<th>";
			String paramCurentYearStr=String.valueOf(paramCurentYear);
			String paramCurentYearSub=paramCurentYearStr.substring(2);
			$htmlTable1+=paramMonthCurent+""+paramCurentYearSub;
		$htmlTable1+="</th>";

		$htmlTable1+="<th>";
			$htmlTable1+="%";
		$htmlTable1+="</th>";

		$htmlTable1+="<th>";
			String paramLastYearStr=String.valueOf(paramLastYear);
			String paramLastYearSub=paramLastYearStr.substring(2);
			$htmlTable1+=paramMonthCurent+" "+paramLastYearSub;
		$htmlTable1+="</th>";

	$htmlTable1+="</tr>";
//tr#########################################2
	$htmlTable1+="</thead>";

	$htmlTable1+="<tbody>";

// Loop while into tbody
Double GrowthPercentage=0.00;
Double pMonthAmt =0.00;
Double currentAmt=0.00;
Double Result=0.00;

	while(rs.next()){
		$htmlTable1+="<tr>";
			$htmlTable1+="<td><div class='level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+"</div></td>";
			$htmlTable1+="<td>";
				$htmlTable1+=numberFormatter.format(rs.getDouble("pMonthAmt"));
			$htmlTable1+="</td>";

			$htmlTable1+="<td>";
				$htmlTable1+=numberFormatter.format(rs.getDouble("currentAmt"));
			$htmlTable1+="</td>";

			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}
			//GrowthPercentage= isNaN(GrowthPercentage)? 0.00: GrowthPercentage;

			$htmlTable1+="<td>"+numberFormatter.format(GrowthPercentage)+"%</td>";
			$htmlTable1+="<td>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</td>";
		$htmlTable1+="</tr>";
		
	}

// Loop while into tbody

	$htmlTable1+="</tbody>";
	$htmlTable1+="</table>";
	conn.close();

//sucessfully

%>
<div id="mainContent">
	<div id="row1">
			<div id="column1">
			<div id="titleTop" style="text-align:right"> หน่วย : ล้านบาท</div>
						<%=$htmlTable1%>
			</div>
			<div id="column2">
				<div id="contentL">	
					<div id="pie"></div>
				</div>
		   </div>
	</div>
</div>

	<!-- boxB	 Start-->
	<div id="boxB">
		<span style="text-align:right; display:none" id="explan">หน่วย : ล้านบาท</span>
			<div id="chart" ></div>
	</div>
	<br style="clear:both">

