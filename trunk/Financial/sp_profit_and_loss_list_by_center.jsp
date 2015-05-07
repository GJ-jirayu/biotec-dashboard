<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<!--- Tab2 -->
<%
	DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
	String paramYear= request.getParameter("paramYear");
	String paramMonth= request.getParameter("paramMonth");
	String paramMonthPerv= "";
	String paramMonthCurent= "";
	String paramOrg=request.getParameter("paramOrg");

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

	String dataDefault="";
	Query="CALL sp_profit_and_loss_list_by_center_per_level("+paramYear+","+paramMonth+",'"+paramOrg+"',2,null);";
	rs=st.executeQuery(Query);
	Integer i=0;
	dataDefault+="[";
	while(rs.next()){

Double GrowthPercentage=0.00;
Double pMonthAmt =0.0;
Double currentAmt=0.0;
Double Result=0.0;

		if(i==0){
		dataDefault+="{" ;
		dataDefault+="account_name:\""+rs.getString("account_name")+"\",";
		dataDefault+="account_key:"+rs.getString("account_key")+",";
		dataDefault+="Field1:\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataDefault+="Field2:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataDefault+="Field3:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";
			//คำนวณหาค่า Growth
			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");

			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}
			//

		dataDefault+="Field5:\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataDefault+="Field6:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataDefault+="}" ;
		}else{
		dataDefault+=",{" ;
		dataDefault+="account_name:\""+rs.getString("account_name")+"\",";
		dataDefault+="account_key:"+rs.getString("account_key")+",";
		dataDefault+="Field1:\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataDefault+="Field2:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataDefault+="Field3:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";
			//คำนวณหาค่า Growth
			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result =  currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}
			//
		dataDefault+="Field5:\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataDefault+="Field6:\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataDefault+="}" ;
		}
i++;
}//while

	dataDefault+="]";

%>

<!-- ####################################### Content tab2 Start ###################################-->

	<style type="text/css">
	#pieChart{
	padding:5px;
	}
	#pie5{
	padding:5px;
	}
	#pie6{
	padding:5px;
	}
	#target{
	width:auto;
	margin:auto;
	}
	#target #percentage{
	width:70px;
	}
	#target #score{
	width:auto;
	display:block;
	padding:5px;
	}
	.content{
	width:100%
	}
	.content #table_content{
	float:left;
	width:100%
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
	.textR{
	/*background:red;*/
	text-align:right;
	padding-right:0px;
	}
	.textL{
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
	width:74.5%;
	height:385px;
	float:left;
	}
	.boxContent #boxR{
	width:25%;
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
	.fontTitle{
	color:white;
	font-weight:bold;
	}
	.level8{
	padding-left:35px;

	}
	.clickable{
	cursor:pointer;
	}

	</style>
	<script type="text/javascript">
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
//เมื่อคลิ๊กที่ level 5 ไม่ให้แสดง pieChart
var clickLevelAgain5=function(){
	$("#boxR").hide();
}
//สามารถคลิ๊กดูข้อมูลของ level ย้อนหลังได้
var clickLevelAgain= function(levelElement){

	
				$(levelElement).live("click",function(){
				var id= $(this).attr('id');
				var account_name= $(this).text();

					var account_key = id.substring(11);
					var account_key_loop="";
					var account_key_sub_loop="";
					var dataLevel ="";
					var j=0;


					var titleText="{\"title\":\""+account_name+"\"}";
					dataLevel+="[";
					$(".parent_key"+account_key).each(function(){

						account_key_loop=this.id;
						account_key_sub_loop=account_key_loop.substring(11);
						var valueMonthParam = $(this).parent().parent().children('td').eq(3).text();
						var valueMonthParamNonComma =valueMonthParam.replace(",","");
						
						if(j==0){
							dataLevel+="{";
								dataLevel+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
							dataLevel+="}";
						}else{
							dataLevel+=",{";
								dataLevel+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
							dataLevel+="}";		
						}
						j++;
					});
					dataLevel+="]";
					var obj21=eval("("+dataLevel+")");
					var obj22=eval("("+titleText+")");
					//ถ้าเป็นข้อมูลว่าง pie chart ไม่แสดงผล
					if(dataLevel=="[]"){
					$("#boxR").show();
					}else{
					$("#boxR").show();
					pieChart(obj21,obj22);
					}
				//Step Call Level2

				});
	
}
	var setFont = function(){
		/*Config font*/
		$(".k-draghandle").css({"font-size":"50%"}); 
		//$(".k-grid td").css({"padding":"0px"});
		$(".k-grid td").css({"padding-top":"0px","padding-bottom":"0px"});
		/*Config font*/
}
	//#######################Graph Program Start#######################01

/*### Pie Start  ###*/		
var pieChart= function(paramValue,titleText,paramSum){
		
		$("#pieChart").show();
		$("#pieChart").kendoChart({
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
                            //explodeField: "explode"
                        }],

                        tooltip: {
                            visible: true,
							//template:"#= tootipFormat(value,"+paramSum+") #"
							template: "#= addCommas(value) #, #= kendo.format('{0:P}', percentage)#",
							//format: "N0"

                        },
			
			seriesDefaults: {
				/*labels: {
					visible: true,
					format: "{0}%"
				}*/
			},
			seriesClick: onSeriesClick,

			
		});
}//function pie chart end
/*### Pie End  ###*/
function onSeriesClick(e) { 
	var $account_key=e.dataItem['account_key'];
	//console.log($account_key);
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
					title:"งบรายได้ค่าใช้จ่าย",
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
                           // min: 0,
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



	//#######################Graph Program End#######################01

	/*########## Table Content Start ##########*/
	var $titleJ =[
              {
                  field: "Field1",
				   width: 150
              },
              {
                  field: "Field2",
				  width: 70
			 },
              {
                  field: "Field3",
				  width: 80
			 },
         
              {
                  field: "Field5",
				  width: 70
			 }, 
              {
                  field: "Field6",
				  width: 70
			 } ];


var $titleJ2 =[
			
              {
                  field: "Field1",
				   width: 230
              },

              {
                  field: "Field2",
				    width: 104
			 },
              {
                  field: "Field3",
				    width: 119
			 },
           
              {
                  field: "Field5",
				    width: 104
			 },
              {
                  field: "Field6",
					width: 100
			 }
           ];
	var $titleJ3 =[
              {
                  field: "Field1",
				   width: 223
              },
              {
                  field: "Field2",
				    width: 104
			 },
              {
                  field: "Field3",
				    width: 119
			 },
           
              {
                  field: "Field5",
				    width: 104
			 },
              {
                  field: "Field6",
					width: 100

			
			 }


           ];
var $titleJ4 =[
              {
                  field: "Field1",
				   width: 217
              },
              {
                  field: "Field2",
				    width: 104
			 },
              {
                  field: "Field3",
				    width: 119
			 },
           
              {
                  field: "Field5",
				    width: 104
			 },
              {
                  field: "Field6",
					width: 100

			
			 }


           ];

var $titleJ5 =[
              {
                  field: "Field1",
				   width: 240
              },
              {
                  field: "Field2",
				    width: 104
			 },
              {
                  field: "Field3",
				    width: 119
			 },
           
              {
                  field: "Field5",
				    width: 104
			 },
              {
                  field: "Field6",
					width: 100
			 }
           ];

	var $dataJ =<%=dataDefault%>; 		
	
	
	//CONTENT BY JSON END

	$("#grid").kendoGrid({
		theme:$(document).data("kendoSkin") || "metro",
          height: 550,
		  detailInit: detailInit2,
          columns: $titleJ, //[{ field: "Field1"},{field: "Field2"}]
          dataSource: {
              data: $dataJ //[{"Field0":"datavaule0"},{"Field1":"datavalue1"},{"Field2":"datavalue2"}]
          }
      });
	  /*########## Table Content End ##########*/

	  //#################### Manment Pie Chart #######################

		//Step1  Call Default 
		//	เรียก pie chart

var j=0;
var dataLevel1 ="";
var titleText="{\"title\":\"สัดส่วนงบรายได้ค่าใช้จ่าย\"}";
var account_key="";
dataLevel1+="[";
	$(".level2").each(function(){
		
	//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
	account_key=$(this).attr("id").substring(11);
	var valueMonthParam = $(this).parent().parent().children('td').eq(3).text();
	var valueMonthParamNonComma =valueMonthParam.replace(",","");
//alert(parseFloat(valueMonthParamNonComma));
	if(j==0){
	dataLevel1+="{";
		dataLevel1+="account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+parseFloat(valueMonthParamNonComma);
		//$("body").append("<input type='text'> name='domAccount_key"+J+"' id='domAccount_key"+J+"' class='account_key' value='"+$(this).text()+"' ");
	dataLevel1+="}";
	}else{
	dataLevel1+=",{";
		dataLevel1+="account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+parseFloat(valueMonthParamNonComma);
	dataLevel1+="}";	
	}
	j++;
	});
	dataLevel1+="]";
	//get is json same dataType in ajax
	//console.log(dataLevel1);
	var obj = eval ("(" + dataLevel1 + ")"); 
	var obj2=eval("("+titleText+")");

	$("#boxR").show();
//	pieChart(obj,obj2);
//Step1 Call Default

//#################### Manment Pie Chart #######################
			
	 function detailInit2(e) {
							//ผูกฟังก์ชั่น clickLevelAgain ให้สามารถคลิ๊กได้ย้อนหลัง
							clickLevelAgain(".level2");
							$(".k-minus").parent().next().addClass("clickable");
			
							//alert(e.data.account_name);
							//alert(e.data.account_name);
								
							$.ajax({
								url:'sp_profit_and_loss_list_by_center_level2.jsp',
								type:'get',
								dataType:'json',
								cache:false,
								data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramArea':$('#domParamOrg').val(),'paramParentKey':e.data.account_key},

								success:function(data){
									//console.log(data);

										   $("<table bgcolor='#f5f5f5'><th></th></table>").kendoGrid({
											detailInit: detailInit3,
											columns: $titleJ2,//[{ field: "Field1"},{field: "Field2"}]
											dataSource: {
											data: data //[{"Field1":"datavalue1"},{"Field2":"datavalue2"}]
											//pageSize: 8
											}
											}).appendTo(e.detailCell);
//new level2 end

//Step Call Level2

	var account_key = e.data.account_key;
	var account_key_loop="";
	var account_key_sub_loop="";
	var account_name = e.data.account_name;
	var dataLevel2 ="";
	var j=0;


	var titleText="{\"title\":\""+account_name+"\"}";
	//alert("titleText"+titleText);
	//console.log($(this).get());
	dataLevel2+="[";
	$(".parent_key"+account_key).each(function(){
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);

		var valueMonthParam = $(this).parent().parent().children('td').eq(3).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");

		if(j==0){
			dataLevel2+="{";
				dataLevel2+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel2+="}";
		}else{
			dataLevel2+=",{";
				dataLevel2+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel2+="}";		
		}
		j++;
	});
	dataLevel2+="]";
	//console.log(dataLevel2);
	 obj21=eval("("+dataLevel2+")");
	 obj22=eval("("+titleText+")");
	//console.log(obj2);
	$("#boxR").show();
	pieChart(obj21,obj22);

//Step Call Level2


								}//ajax
							});
								
				setFont();
			// REMOVE COLUMN START

				$(" tr.k-detail-row").each(function(){
					if($("td.k-hierarchy-cell",this).html()==""){
						$("td.k-hierarchy-cell",this).remove();
					}
				});

			// REMOVE COLUMN END
                } // End Function detailInit

			//Start detailInit3
				function detailInit3(e) {
					clickLevelAgain(".level3");
					$(".k-minus").parent().next().addClass("clickable");
					//alert(e.data.account_name);
					//alert(e.data.account_key);
						$.ajax({
								url:'sp_profit_and_loss_list_by_center_level3.jsp',
								type:'get',
								dataType:'json',
								cache:false,
								data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramArea':$('#domParamOrg').val(),'paramParentKey':e.data.account_key},
								success:function(data){

										   $("<table><th></th></table>").kendoGrid({
											detailInit: detailInit4,
											columns: $titleJ3,
											dataSource: {
											data: data
											//pageSize: 8
											}
											}).appendTo(e.detailCell);
//new level2 end
//Step Call Level3

	var account_key = e.data.account_key;
	var account_key_loop="";
	var account_key_sub_loop="";
	var account_name = e.data.account_name;
	var dataLevel3 ="";
	var j=0;
	var titleText="{\"title\":\""+account_name+"\"}";

	dataLevel3+="[";
	$(".parent_key"+account_key).each(function(){

		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);
		var valueMonthParam = $(this).parent().parent().children('td').eq(3).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");

		if(j==0){
			dataLevel3+="{";
				dataLevel3+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel3+="}";
		}else{
			dataLevel3+=",{";
				dataLevel3+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel3+="}";		
		}
		j++;
	});
	dataLevel3+="]";
	//console.log(dataLevel3);
	var obj=eval("("+dataLevel3+")");
	var obj2=eval("("+titleText+")");
	//console.log(obj2);
	$("#boxR").show();
	pieChart(obj,obj2);

//Step Call Level3

								}//success
							});//ajax
								
								//pieChart();
								
						
						 

				setFont();

			// REMOVE COLUMN START
				$(" tr.k-detail-row").each(function(){
					if($("td.k-hierarchy-cell",this).html()==""){
						$("td.k-hierarchy-cell",this).remove();
					}
				});
			// REMOVE COLUMN END

				}//end detailInit3
				//Start detailInit4
				function detailInit4(e) {
					
					clickLevelAgain(".level4");
					$(".k-minus").parent().next().addClass("clickable");
						$.ajax({
								url:'sp_profit_and_loss_list_by_center_level4.jsp',
								type:'get',
								dataType:'json',
								cache:false,
								data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramArea':$('#domParamOrg').val(),'paramParentKey':e.data.account_key},
								success:function(data){

										   $("<table><th></th></table>").kendoGrid({
											detailInit: detailInit5,
											columns: $titleJ4,
											dataSource: {
											data: data
											//pageSize: 8
											}
											}).appendTo(e.detailCell);
//new level2 end
//Step Call Level4

	var account_key = e.data.account_key;
	var account_key_loop="";
	var account_key_sub_loop="";
	var account_name = e.data.account_name;
	var dataLevel4 ="";
	var j=0;
	var titleText="{\"title\":\""+account_name+"\"}";

	dataLevel4+="[";
	$(".parent_key"+account_key).each(function(){
		
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);
		var valueMonthParam = $(this).parent().parent().children('td').eq(3).text();
		var valueMonthParamNonComma =valueMonthParam.replace(",","");
		if(j==0){
			dataLevel4+="{";
				dataLevel4+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel4+="}";
		}else{
			dataLevel4+=",{";
				dataLevel4+="account_key:"+account_key_sub_loop+",category:"+"\""+$(this).text()+"\",value:"+valueMonthParamNonComma;
			dataLevel4+="}";		
		}
		j++;
	});
	dataLevel4+="]";
	//console.log(dataLevel4);
	var obj=eval("("+dataLevel4+")");
	var obj2=eval("("+titleText+")");
	//console.log(obj2);
	$("#boxR").show();
	pieChart(obj,obj2);

//Step Call Level4

								}//success
							});//ajax
								
								//pieChart();
								
						
						 

				setFont();
			// REMOVE COLUMN START
				$(" tr.k-detail-row").each(function(){
					if($("td.k-hierarchy-cell",this).html()==""){
						$("td.k-hierarchy-cell",this).remove();
					}
				});
			// REMOVE COLUMN END

				}//end detailInit4

				//Start detailInit5
				function detailInit5(e) {
					clickLevelAgain5();
					//alert(e.data.account_name);
					//alert(e.data.account_key);
						$.ajax({
								url:'sp_profit_and_loss_list_by_center_level5.jsp',
								type:'get',
								dataType:'json',
								cache:false,
								data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramArea':$('#domParamOrg').val(),'paramParentKey':e.data.account_key},
								success:function(data){
									//console.log(data);
								//var $data_level2=  eval("(" + data + ")"); 
//new level2 start
										   $("<table><th></th></table>").kendoGrid({
											//detailInit: detailInit4,
											columns: $titleJ5,
											dataSource: {
											data: data
											//pageSize: 8
											}
											}).appendTo(e.detailCell);
//new level2 end
//Step Call Level5

	var account_key = e.data.account_key;
	var account_key_loop="";
	var account_key_sub_loop="";
	var account_name = e.data.account_name;
	var dataLevel5 ="";
	var dataLevel5_Sum="";
	var j=0;
	var titleText="{\"title\":\""+account_name+"\"}";
	//alert("titleText"+titleText);
	//console.log($(this).get());
	dataLevel5+="[";
	$(".parent_key"+account_key).each(function(){
		
		account_key_loop=this.id;
		account_key_sub_loop=account_key_loop.substring(11);

		if(j==0){
			dataLevel5+="{";
				dataLevel5+="account_key:"+account_key_sub_loop+",account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+parseFloat($(this).parent().parent().children('td').eq(3).text());
				dataLevel5_Sum+=parseInt($(this).parent().parent().children('td').eq(3).text());
			dataLevel5+="}";
		}else{
			dataLevel5+=",{";
				dataLevel5+="account_key:"+account_key_sub_loop+",account_key:"+account_key+",category:"+"\""+$(this).text()+"\",value:"+parseFloat($(this).parent().parent().children('td').eq(3).text());
				dataLevel5_Sum+=parseInt($(this).parent().parent().children('td').eq(3).text());
			dataLevel5+="}";		
		}
		j++;
	});
	dataLevel5+="]";

	//console.log(dataLevel5);
	//console.log(dataLevel5_Sum);

	var obj=eval("("+dataLevel5+")");
	var obj2=eval("("+titleText+")");
	//console.log(obj);
	$("#boxR").hide();
	pieChart(obj,obj2);

//Step Call Level5

								}//success
							});//ajax
								
								//pieChart();
								
						
						 

				setFont();
			// REMOVE COLUMN START
				$(" tr.k-detail-row").each(function(){
					if($("td.k-hierarchy-cell",this).html()==""){
						$("td.k-hierarchy-cell",this).remove();
					}
				});
			// REMOVE COLUMN END

				}//end detailInit5



	});

	//set add row management title year current and year perv

	//set add row management title year current and year perv


		/*################# jQuery Start #############*/

		$(".k-icon").click(function(){

	
		if($(".k-minus").length!=0){
			//$("#chart").hide();
			//$("#pieChart").hide();//pie
		//	$(".k-detail-row").remove(); //delete value pie old for add new value
		}else{
		
		//$("#chart").show();
		//$("#pieChart").show();//pie
		$(".k-detail-row").remove();//delete value pie old for add new value
		}
	
	});
		//$(". k-plus")
		/*################# jQuery End #############*/

function tootipFormat(value,summ){
		var value1 = Math.floor(value);
		var value2 = (Math.floor((value/summ)*100)).toFixed(2);
		return value1+" , " + value2+"%";
	}

	</script>
 <!-- Define the HTML table, with rows, columns, and data -->
<div class="boxContent">
	<div id="boxL"><!-- boxL	 Start-->
	<div id="titleTop" style="text-align:right"> หน่วย : ล้านบาท </div>
	 <div class="content"><!-- Content	 Start-->
 <div id="table_content">
 <!-- สร้างตารางGrid-->
 <table id="grid">
  <thead>
      <tr>
		 <!--<th class="k-hierarchy-cell k-header"></th>-->
          <th data-field="Field1" ><center><div class="fontTitle"> </div></center></th>
		  <%
			String paramCurentYearStrLastMonth=String.valueOf(paramCurentYearLastMonth);
			String paramCurentYearSubLastMonth=paramCurentYearStrLastMonth.substring(2);
			String paramCurentYearStr=String.valueOf(paramCurentYear);
			String paramCurentYearSub=paramCurentYearStr.substring(2);
		%>
		  <th data-field="Field2"><center><div class="fontTitle"><%=paramMonthPerv%> &nbsp; <%=paramCurentYearSubLastMonth%> </div></center></th>
		  <th data-field="Field3"><center><div class="fontTitle"><%=paramMonthCurent%> &nbsp; <%=paramCurentYearSub%> </div></center></th>		
		  <th data-field="Field5"><center><div class="fontTitle">%</div></center></th>
		  <%
		  String paramLastYearStr=String.valueOf(paramLastYear);
		  String paramLastYearSub=paramLastYearStr.substring(2);
		  %>
		  <th data-field="Field6"><center><div class="fontTitle"><%=paramMonthCurent%> &nbsp; <%=paramLastYearSub%> </div></center></th>
	  </tr>
  </thead>
  <tbody>
      <tr>
          <td></td>
          <td></td>
		  <td></td>
          <td></td>
		  <td></td>
</tr>

  </tbody>
 </table>

 </div>

</div><!-- Content	 End-->
	</div><!-- boxL	 End>-->
	<div id="boxR"><!-- boxR	 Start-->
	
	<div id="pieChart"><p></p></div>
	
	</div><!-- boxR	 End>-->
	<center>
	<div id="boxB"><!-- boxB	 Start-->
	
	<div id="chart"><p></p></div>
	
	</div><!-- boxB	 End>-->
	</center>
	<br style="clear:both">
</div>

<!-- ####################################### Content tab2 End ###################################-->