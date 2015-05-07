<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>
<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = "สวทช.";
String Param_sp_center = "";
String sub_ParamOrg = "";

// Jsp  Server-side
//############################ pie sp_npr_by_center  Start ######################### /
String sp_npr_by_center ="";
Integer sum_npr_by_center=0;
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		//เรียก store procedure เพื่อสร้าง json format สำหร้บ pie Chart sp_npr_by_center
		Query="CALL sp_npr_by_center("+ParamYear+","+ParamMonth+");";
		rs = st.executeQuery(Query);
		sp_npr_by_center+="[";
		Integer i =1;
		String color="";
		while(rs.next()){
		//กำหนดสีตามศูนย์
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(rs.getString("npr_center").equals("สก.")){
		color="#25a0da";
		}else if(rs.getString("npr_center").equals("ศช.")){
		color="#309b46";
		}else if(rs.getString("npr_center").equals("ศว.")){
		color="#dee92d";
		}else if(rs.getString("npr_center").equals("ศอ.")){
		color="#e62d32";
		}else if(rs.getString("npr_center").equals("ศน.")){
		color="#ff7110";
		}else if(rs.getString("npr_center").equals("ศจ.")){
		color="#6C2E9B";
		}
		if(i==1){
		sp_npr_by_center+="{category:";
		sp_npr_by_center+= "\""+rs.getString("npr_center") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total") ;
		sp_npr_by_center+= ",color:\""+color+"\"";
		sum_npr_by_center+=rs.getInt("total");
		sp_npr_by_center+="}";
		}else{
		sp_npr_by_center+=",{category:";
		sp_npr_by_center+= "\""+rs.getString("npr_center") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total");
		sp_npr_by_center+= ",color:\""+color+"\"";
		sp_npr_by_center+="}";
		sum_npr_by_center+=rs.getInt("total");
		}
	i++;
		}
		sp_npr_by_center+="]";
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_center</font>"+ex);
}

//############################pie  sp_npr_by_center  End ############################ /
//############################bar  sp_npr_by_center_drilldown  Start ############################ /
//สร้าง format json สำหรับ Bar Chart by_center_drilldown
String categoryAxis_npr_center = "";
String[] categoryAxis_npr_center_array;
String categoryAxis_npr_center_using="";

String series_job_center = "";
String series_job_center_array = "";
String series_job_center_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_center_drilldown("+ParamYear+","+ParamMonth+",'"+ParamOrg+"')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_center_using+="[";
		series_job_center+="[";
		while(rs.next()){
			//สร้าง json format เพื่อนำไปสร้าง Bar Chart
			//โดยมี format ดังนี้
			/*
			Category
			["นักวิจัยร่วมวิจัย","นักวิจัยหลังปริญญาเอก","นักวิจัยแลกเปลี่ยน","นักศึกษาร่วมวิจัย(โท/เอก)"]
			Series
			[{"name":"Fulltime","data":[0,5,0,0]},{"name":"Partime","data":[1,0,5,33]}]
			*/
			if(i==0){
				categoryAxis_npr_center=rs.getString("npr_list");
				categoryAxis_npr_center_array=categoryAxis_npr_center.split(",");
				series_job_center+="{name:"+"\""+rs.getString("job_type")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_center_array.length; j++){
					if(j==0){
					categoryAxis_npr_center_using+="\""+categoryAxis_npr_center_array[j]+"\"";
					}else{
					categoryAxis_npr_center_using+=",\""+categoryAxis_npr_center_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_center+=",{name:"+"\""+rs.getString("job_type")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_center_using+="]";
	series_job_center+="]";
	conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_center_drilldown</font>"+ex);
}

//############################bar  sp_npr_by_center  End ############################ /
//############################  pie sp_npr_by_type  Start ######################### /

String sp_npr_by_type ="";
Integer sum_npr_by_type=0;

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_type("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_npr_by_type+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){

		sp_npr_by_type+="{category:";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",value:"+rs.getString("total") ;
		sum_npr_by_type+=rs.getInt("total");
		sp_npr_by_type+="}";

		}else{
		sp_npr_by_type+=",{category:";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",value:"+rs.getString("total");
		sp_npr_by_type+="}";
		sum_npr_by_type+=rs.getInt("total");
		}
		
	i++;
		}
		sp_npr_by_type+="]";
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_type</font>"+ex);
}

//############################ pie sp_npr_by_type  End ############################ /
//############################bar  sp_npr_by_type_drilldown  Start ############################ /

String categoryAxis_npr_type = "";
String[] categoryAxis_npr_type_array;
String categoryAxis_npr_type_using="";

String series_job_type = "";
String series_job_type_array = "";
String series_job_type_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_type_drilldown("+ParamYear+","+ParamMonth+",'ALL')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_type_using+="[";
		series_job_type+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_type=rs.getString("npr_list");
				categoryAxis_npr_type_array=categoryAxis_npr_type.split(",");
				series_job_type+="{name:"+"\""+rs.getString("npr_country_group")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_type_array.length; j++){
					//out.println(categoryAxis_npr_type_array[j]+"<br>");
					if(j==0){
					categoryAxis_npr_type_using+="\""+categoryAxis_npr_type_array[j]+"\"";
					}else{
					categoryAxis_npr_type_using+=",\""+categoryAxis_npr_type_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_type+=",{name:"+"\""+rs.getString("npr_country_group")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_type_using+="]";
	series_job_type+="]";
	conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_type_drilldown</font>"+ex);
}

//############################bar  sp_npr_by_type_drilldown  End ############################ /

//############################ pie sp_npr_by_country_group  Start ######################### /

String sp_npr_by_country_group ="";
Integer sum_npr_by_country_group=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_country_group("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_npr_by_country_group+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sp_npr_by_country_group+="{category:";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",value:"+rs.getString("total") ;
		sum_npr_by_country_group+=rs.getInt("total");
		sp_npr_by_country_group+="}";

		}else{
		sp_npr_by_country_group+=",{category:";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",value:"+rs.getString("total");
		sp_npr_by_country_group+="}";
		sum_npr_by_country_group+=rs.getInt("total");
		}
		
	i++;
		}
		sp_npr_by_country_group+="]";
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_country_group</font>"+ex);
}

//############################pie  sp_npr_by_country_group  End ############################ /
//############################bar  sp_npr_by_country_group_drilldown  Start #################### /

String categoryAxis_npr_country_group = "";
String[] categoryAxis_npr_country_group_array;
String categoryAxis_npr_country_group_using="";

String series_job_country_group = "";
String series_job_country_group_array = "";
String series_job_country_group_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_country_group_drilldown("+ParamYear+","+ParamMonth+",'"+ParamOrg+"','ALL')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_country_group_using+="[";
		series_job_country_group+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_country_group=rs.getString("working_range_list");
				categoryAxis_npr_country_group_array=categoryAxis_npr_country_group.split(",");
				series_job_country_group+="{name:"+"\""+rs.getString("npr_status")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_country_group_array.length; j++){
					if(j==0){
					categoryAxis_npr_country_group_using+="\""+categoryAxis_npr_country_group_array[j]+"\"";
					}else{
					categoryAxis_npr_country_group_using+=",\""+categoryAxis_npr_country_group_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_country_group+=",{name:"+"\""+rs.getString("npr_status")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_country_group_using+="]";
	series_job_country_group+="]";
	
	//Success fully Start
	//out.println(categoryAxis_npr_country_group_using+"<br>");
	//out.println(series_job_country_group+"<br>");
	//Success fully Stop
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_country_group_drilldown</font>"+ex);
}

//############################bar  sp_npr_by_country_group_drilldown  End ############################ /

%>
<style>
.content{
width:960px;
height:auto;
/*background:red;*/
margin:auto;
}
.content  #row1{
width:960px;
height:auto
background:blue;
clear:both;


}
.content  #row1 .box{
width:313px;
height:550px;
float:left;
margin:2px;
border-radius:5px;
    border: 1px solid #DDDDDD;
    color: #362B36;
}
.content  #row1 .box #head{
    border-radius: 5px 5px 5px 5px;
    color: #2779AA;
    height: 26px;
    margin: 3px;
    padding: 5px;
    width: auto;
	background: url("images/ui-bg_highlight-soft_100_deedf7_1x100.png") repeat-x scroll  50% 50%  #DEEDF7;
    border: 1px solid #AED0EA;

}
.content  #row1 .box #head .title{
	padding:5px;
	text-align:center;
	
}
.content  #row1 .box #body{
width:auto;
height:200px;

}
.content #row2{
width:990px;
height:300px;

clear:both;


}


.content #row2 #boxL{
width:630px;
height:300px;
border:1 solid blue;

float:left;
}
.content #row2 #boxL #box{
width:308px;
height:300px;
float:left;
margin:2px;
border-radius:5px;
border:1px solid #cccccc;
}
.content #row2 #boxL #box #head{
width:auto;
height:30px ;
background:#cccccc;

}
.content #row2 #boxL #box  #head #title{
	padding:5px;
	text-align:center;
}



.content #row2 #boxL #box  #body{
width:auto;
height:270px;

}


.content #row2 #boxR{

width:630px;
height:300px;
border:1 solid blue;
float:left;

}
.content #row2 #boxR #box{
height:300px;
float:left;
margin:2px;
width:630px;
border-radius:5px;
border:1px solid #cccccc;
background:#EBEBEB;

}
.content #row2 #boxR #box #head{
width:auto;
height:30px ;
background:#cccccc;
}
.content #row2 #boxR #box #head #title{
	padding:5px;
	text-align:center;
}
.content #row2 #boxR  #box #body{
width:auto;
height:310px;
background:#ffffff;

}

</style>
<script type="text/javascript">
//ฟังก์ชันจัดการ Commas
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
var ParamOrg = "สวทช.";
/*###  pie center start ###*/
//ฟังก์ชันสร้าง pie chart 
var pieChartCenter= function(id_param,data_param,summ_param){
		$(id_param).kendoChart({
		 theme: $(document).data("kendoSkin") || "metro",
			title: {
				 text:""
			},
			legend: {
                            position: "bottom"
            },
			chartArea: {
			width: 310,
			height: 230,
			background: ""
			},
			series: [{
                            type: "pie",
                            data:data_param
                        }],
                        tooltip: {
                            visible: true,
							template:"#= templateFormat(value,"+summ_param+")#"
                        },
			
			seriesDefaults: {
				labels: {
					visible: false,
					format: "{0}%",
					
				}
			},
			//เมื่อเกิดเหตุการณ์ click ที่ pie ให้ไปทำงานต่อที่ฟังก์ชัน checkBarTypeCenter
			seriesClick:checkBarTypeCenter
	
			
		});
}


/*###  pie center end ###*/

/*###  pie type start ###*/

var pieChartByType= function(id_param,data_param,summ_param){

		$(id_param).kendoChart({
		 theme: $(document).data("kendoSkin") || "metro",
			title: {
				 text: ""
			},
			legend: {
                            position: "bottom"
            },
			chartArea: {
			width: 310,
			height: 230,
			background: ""
			},
			series: [{
                            type: "pie",
                            data:data_param
                        }],
                        tooltip: {
                            visible: true,
                           // format: "{0}%"
							template:"#= templateFormat(value,"+summ_param+")#"

                        },
			
			seriesDefaults: {
				labels: {
					visible: false,
					format: "{0}%",
					
				}
			},
			seriesClick:checkBarTypeByType
	
			
		});
}


/*###  pie type end ###*/
/*###  pie country_group start ###*/

var pieChartByCountryGroup= function(id_param,data_param,summ_param){

		$(id_param).kendoChart({
		 theme: $(document).data("kendoSkin") || "metro",
			title: {
				 text:""
			},
			legend: {
                            position: "bottom"
            },
			chartArea: {
			width: 310,
			height: 230,
			background: ""
			},
			series: [{
                            type: "pie",
                            data:data_param
                        }],
                        tooltip: {
                            visible: true,
                           // format: "{0}%"
							template:"#= templateFormat(value,"+summ_param+")#"

                        },
			
			seriesDefaults: {
				labels: {
					visible: false,
					format: "{0}%",
					
				}
			},
			seriesClick:checkBarTypeByCountryGroup
	
			
		});
}


/*###  pie country_group end ###*/

/*###  bar start ###*/
//ฟังก์ชัน barchart
var barChart= function(id_param,categoryAxis_param,series_param,title_param){
//var categoryAxis_param = ["นักวิจัยร่วมวิจัย","นักวิจัยหลังปริญญาเอก","นักศึกษาร่วมวิจัย (โท/เอก)"];
	$(id_param).kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text:title_param
                        },
						chartArea:{
						width:290,
						height:210,
						background: ""
						},

						
                        legend: {
                            position: "bottom"
                        },
                        seriesDefaults: {
							//bar chart แนวตั้ง
                            type: "column",
							stack: true
                        },
                        series:series_param,
                        valueAxis: {
                            labels: {
                               // format: "{0}%"
							   format: "{0}",
							   font:"10px Tahoma"
                            }
                        },
                        categoryAxis: {
                            categories:categoryAxis_param,
							labels:{
								font:"11px Tahoma"
								}
                        },
                        tooltip: {
                            visible: true,
                            format: "{0}"
                        }
                    });
}
//ฟังก์ชัน barchart แนวนอน
var barChartCenter= function(id_param,categoryAxis_param,series_param,title_param){
//var categoryAxis_param = ["นักวิจัยร่วมวิจัย","นักวิจัยหลังปริญญาเอก","นักศึกษาร่วมวิจัย (โท/เอก)"];
	$(id_param).kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text:title_param
                        },
						chartArea:{
						width:290,
						height:210,
						background: ""
						},
                        legend: {
                            position: "bottom"
                        },
                        seriesDefaults: {
							//bar chart แนวนอน
                            type: "bar",
							stack: true
                        },
                        series:series_param,
                        valueAxis: {
                            labels: {
							   format: "{0}",
							   font:"10px Tahoma"
                            }
                        },
                        categoryAxis: {
                            categories:categoryAxis_param,
							labels:{
								font:"11px Tahoma"
								}
                        },
                        tooltip: {
                            visible: true,
                            format: "{0}"
                        }
                    });
}

/*###  bar end ###*/
//จับเหตุการเมื่อมีการคลิ๊กที่ pie chart center
function checkBarTypeCenter(e){
		//รับ category ที่มีการคลิ๊กมาใช้งาน
		ParamOrg = e.category;
	// ==============================Pie 2 Change====================================
		$.ajax({
		url:'sp_npr_by_type.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':ParamOrg},
		success:function(data){
		$("#string_type_pie").empty();
		$("#string_type_pie").append(ParamOrg);
		pieChartByType("#pie_sp_npr_by_type",data[0]["category_pie"],data[1]["sum_pie"]);
		}
	});
	// ==============================Pie 3 Change====================================
		$.ajax({
		url:'sp_npr_by_country_group.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':ParamOrg},
		success:function(data){
		$("#string_country_pie").empty();
		$("#string_country_pie").append(ParamOrg);
		pieChartByCountryGroup("#pie_sp_npr_by_country_group",data[0]["category_pie"],data[1]["sum_pie"]);
		}
	});

	// ============================= Bar  1  Change ==================== 
	$.ajax({
		url:'sp_npr_by_center_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':ParamOrg},
		success:function(data){
		barChartCenter("#bar_sp_npr_by_center_drilldown",data[0]["category"],data[1]["series"],ParamOrg);
		}
	});
//======================== Change Bar 2 ===================
$.ajax({
		url:'sp_npr_by_type_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamNprlist':"ALL"},
		success:function(data){
		barChart("#bar_sp_npr_by_type_drilldown",data[0]["category"],data[1]["series"],"ทุกประเภท");
		}
	});
// =================================== Change Bar 3 ========================
	$.ajax({
		url:'sp_npr_by_country_group_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':ParamOrg,'ParamWorkingRangelist':"ALL"},
		success:function(data){
		barChart("#bar_sp_npr_by_country_group_drilldown",data[0]["category"],data[1]["series"],"ทุกสัญชาติ");
		}
	});


}//function
//จับเหตุการณ์เมื่อมีการคลิ๊กที่  pieChartByType ให้เปลี่ยนเฉพาะ bar chart ของตัวเอง
function checkBarTypeByType(e){
	$.ajax({
		url:'sp_npr_by_type_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamNprlist':e.category},
		success:function(data){
		barChart("#bar_sp_npr_by_type_drilldown",data[0]["category"],data[1]["series"],e.category);
		}
	});
}
//จับเหตุการณ์เมื่อมีการคลิ๊กที่  pieChartByCountryGroup ให้เปลี่ยนเฉพาะ bar chart ของตัวเอง
function checkBarTypeByCountryGroup(e){
	$.ajax({
		url:'sp_npr_by_country_group_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':ParamOrg,'ParamWorkingRangelist':e.category},
		success:function(data){
		barChart("#bar_sp_npr_by_country_group_drilldown",data[0]["category"],data[1]["series"],e.category);
		}
	});
}

/* Using PieChart start*/
pieChartCenter("#pie_sp_npr_by_center",<%=sp_npr_by_center%>,<%=sum_npr_by_center%>);
pieChartByType("#pie_sp_npr_by_type",<%=sp_npr_by_type%>,<%=sum_npr_by_type%>);
pieChartByCountryGroup("#pie_sp_npr_by_country_group",<%=sp_npr_by_country_group%>,<%=sum_npr_by_country_group%>);
/* Using PieChart end*/
/* Using BarChart start*/
barChartCenter("#bar_sp_npr_by_center_drilldown", <%=categoryAxis_npr_center_using%>, <%=series_job_center%>,'สวทช.' )	;
barChart("#bar_sp_npr_by_type_drilldown", <%=categoryAxis_npr_type_using%>, <%=series_job_type%>,'ทุกประเภท');
barChart("#bar_sp_npr_by_country_group_drilldown", <%=categoryAxis_npr_country_group_using%>, <%=series_job_country_group%>,'ทุกสัญชาติ');
/* Using BarChart end*/
});

function templateFormat(value,summ) {
   var value1 = addCommas(value);
   var value2 = ((value/summ)*100).toFixed(2);
   return value1 + " , " + value2 + " %";
}


</script>
<div class="content">
	<div id="row1">
				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วน NPR ตามศูนย์
							</div>
						</div>
						<div id="body">
									<table>
											<tr>
												<td>
												<font color="gray" size=3><center><%=ParamOrg%></center></font>
												<br>
												<div id="pie_sp_npr_by_center"></div>
												</td>
												
											</tr>
											<tr>
												<td><hr size=0 noshade color="gray">
												<div id="bar_sp_npr_by_center_drilldown"></div>
												</td>
											</tr>
									</table>
						</div>
				</div>
				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วน NPR ตามประเภท
							</div>
						</div>
						<div id="body">
								<table>
											<tr>
												<td align="center">
												<font color="gray" size=3><div id=string_type_pie><%out.print(ParamOrg);%></div></font>
												<br>
												<div id="pie_sp_npr_by_type"></div>
												</td>
												
											</tr>
												<td><hr size=0 noshade color="gray">
												<div id="bar_sp_npr_by_type_drilldown"></div>
												</td>
											<tr>

											</tr>
									</table>
						</div>
				</div>


				
				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วน NPR ตามสัญชาติ
							</div>
						</div>
						<div id="body">
								<table>
											<tr>
												<td align="center">
													<font color="gray" size=3><div id=string_country_pie><%out.print(ParamOrg);%></div></font>
													<br>
													<div id="pie_sp_npr_by_country_group"></div>
												</td>
												
											</tr>
											<tr>
												<td><hr size=0 noshade color="gray">
												<div id="bar_sp_npr_by_country_group_drilldown"></div>
												</td>
											</tr>
									</table>
						</div>
				</div>
			
	</div>
</div>

<br style="clear:both">
