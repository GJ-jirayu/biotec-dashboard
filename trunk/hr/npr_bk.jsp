<%@page contentType="text/html" pageEncoding="utf-8"%>
<!--<meta http-equiv="Content-type" content="text/html; charset=utf-8">-->
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");
String Param_sp_center = "";

out.print("ParamMonth"+ParamMonth);
out.print("ParamYear"+ParamYear);
out.print("ParamOrg"+ParamOrg);

/*
-- biotec_dwh --
Type: MYSQL
Server: 10.226.202.114
database: biotec_dwh
user: root
pass: bioteccockpit
*/
// Jsp  Server-side
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver = "com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";
String center_name="";
Connection conn= null;

Statement st;
ResultSet rs;

String shortname="";
//############################ pie sp_npr_by_center  Start ######################### /
String sp_npr_by_center ="";
Integer sum_npr_by_center=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_center(2012,09);";
		rs = st.executeQuery(Query);
		sp_npr_by_center+="[";
		Integer i =1;

		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sp_npr_by_center+="{category:";
		sp_npr_by_center+= "\""+rs.getString("npr_center") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total") ;
		sum_npr_by_center+=rs.getInt("total");
		sp_npr_by_center+="}";
		}else{
		sp_npr_by_center+=",{category:";
		sp_npr_by_center+= "\""+rs.getString("npr_center") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total");
		sp_npr_by_center+="}";
		sum_npr_by_center+=rs.getInt("total");
		}
	i++;
		}
		sp_npr_by_center+="]";
		out.println("-------------------------------------------------------"+"<br>");
		out.println("sum_npr_by_center"+sum_npr_by_center+"<br>");
		out.println("sp_npr_by_center"+sp_npr_by_center+"<br>");
		out.println("-------------------------------------------------------"+"<br>");
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_center</font>"+ex);
}

//############################pie  sp_npr_by_center  End ############################ /
//############################bar  sp_npr_by_center_drilldown  Start ############################ /

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
		Query="CALL sp_npr_by_center_drilldown(2012,10,'สวทช.')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_center_using+="[";
		series_job_center+="[";
		while(rs.next()){
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
	
	//Success fully Start
	out.println(categoryAxis_npr_center_using+"<br>");
	out.println(series_job_center+"<br>");
	//Success fully Stop


		//num row start
		rs.last();
		int c = rs.getRow();
		//out.println("num_row"+c);
		rs.beforeFirst();
		//num row end

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
		Query="CALL sp_npr_by_type(2012,09);";
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
		out.println("-------------------------------------------------------"+"<br>");
		out.println("sum_npr_by_type"+sum_npr_by_type+"<br>");
		out.println("sp_npr_by_type"+sp_npr_by_type+"<br>");
		out.println("-------------------------------------------------------"+"<br>");
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
		Query="CALL sp_npr_by_type_drilldown(2012,11,'สวทช.')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_type_using+="[";
		series_job_type+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_type=rs.getString("npr_ist");
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
	
	//Success fully Start
	out.println(categoryAxis_npr_type_using+"<br>");
	out.println(series_job_type+"<br>");
	//Success fully Stop
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
		Query="CALL sp_npr_by_country_group(2012,09);";
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
		out.println("-------------------------------------------------------"+"<br>");
		out.println("sum_npr_by_country_group"+sum_npr_by_country_group+"<br>");
		out.println("sp_npr_by_country_group"+sp_npr_by_country_group+"<br>");
		out.println("-------------------------------------------------------"+"<br>");
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_country_group</font>"+ex);
}

//############################pie  sp_npr_by_country_group  End ############################ /
//############################bar  sp_npr_by_country_group_drilldown  Start ############################ /

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
		Query="CALL sp_npr_by_country_group_drilldown(2012,09,'NA.')";
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
	out.println(categoryAxis_npr_country_group_using+"<br>");
	out.println(series_job_country_group+"<br>");
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
    /*background: url("images/ui-bg_highlight-hard_100_f2f5f7_1x100.png") repeat-x scroll 50% top #F2F5F7;*/
    border: 1px solid #DDDDDD;
    color: #362B36;


}
.content  #row1 .box #head{
/*width:auto;
height:30px ;
background:#99ccff;
*/
   /*background: none repeat scroll 0 0 #DEEDF7;*/
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
$(document).ready(function(){

/*###  pie start ###*/

var pieChart= function(id_param,data_param,summ_param){

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
			seriesClick:checkBarType
	
			
		});
}


/*###  pie end ###*/

/*###  bar start ###*/
var barChart= function(id_param,categoryAxis_param,series_param){
//var categoryAxis_param = ["นักวิจัยร่วมวิจัย","นักวิจัยหลังปริญญาเอก","นักศึกษาร่วมวิจัย (โท/เอก)"];
	$(id_param).kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
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
                            type: "column",
							stack: true
                        },
                        series:series_param,
                        valueAxis: {
                            labels: {
                               // format: "{0}%"
							   format: "{0}"
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
                            format: "{0}%"
                        }
                    });
}
/*###  bar end ###*/
/*
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");
*/
function checkBarType(e){
	$.ajax({
		url:'sp_npr_by_center_drilldown.jsp',
		type:'get',
		dataType:'json',
		data:{'ParamMonth':<%=ParamMonth%>,'ParamYear':<%=ParamYear%>,'ParamOrg':e.category},
		success:function(data){
		alert(data);
		//Format
		 //categories: [ "เยี่ยมเยือน" ," แลกเปลี่ยน", "ร่วมวิจัย ", "Postdoc", "นักศึกษา"],
	
		var categoryAxis_npr_center=String(data[0]);
		var categoryAxis_npr_center_array=categoryAxis_npr_center.split(",");
		var categoryAxis_npr_center_array_using="";

		var series_job_center=String(data[1]);
		var series_job_center_array=series_job_center.split("|");
		var series_job_center_using="";
		
		var total_list=String(data[2]);
		var total_list_array=total_list.split("|");
		var total_list_using="";

		//alert(categoryAxis_npr_center_array.length);
		categoryAxis_npr_center_array_using+="[";
		series_job_center_using+="[";
		for(var j=0; j<categoryAxis_npr_center_array.length; j++){


				if(j==0){

				categoryAxis_npr_center_array_using+="\""+categoryAxis_npr_center_array[j]+"\"";
				
				}else{
				categoryAxis_npr_center_array_using+=",\""+categoryAxis_npr_center_array[j]+"\"";
				
				}
		}

		for(var k=0; k<series_job_center_array.length; k++){
		/*
		Format
		series: [{
						name: "Part Time",
						data: [0, 5, 5, 3, 10.20]
					}, {
						name: "Full Time",
						data: [3, 4, 6, 3,4]
					}]
	*/
				if(k==0){
				series_job_center_using+="{name:"+"\""+series_job_center_array[k]+"\",data:["+total_list_array[k]+"]}";
				}else{
				//series_job_center_using+=",{name:"+"\""+series_job_center_array[k]+"\"}";
				series_job_center_using+=",{name:"+"\""+series_job_center_array[k]+"\",data:["+total_list_array[k]+"]}";
				}
				
		}

		categoryAxis_npr_center_array_using+="]";
		series_job_center_using+="]";
		var tex1="";
		var tex2=String(series_job_center_using);
		console.log(categoryAxis_npr_center_array_using);
	   console.log(series_job_center_using);
		//tex11=["นักวิจัยร่วมวิจัย","นักวิจัยหลังปริญญาเอก","นักศึกษาร่วมวิจัย (โท/เอก)"];
		tex11="[\"นักวิจัยร่วมวิจัย\",\"นักวิจัยหลังปริญญาเอก\",\"นักศึกษาร่วมวิจัย (โท/เอก)\"]";
		tex12=categoryAxis_npr_center_array_using;
		alert(tex11+"\n"+categoryAxis_npr_center);
		barChart("#bar_sp_npr_by_center_drilldown",data,tex2);
		}
	});
}


/* Using PieChart*/

//pie_sp_npr_by_center
pieChart("#pie_sp_npr_by_center",<%=sp_npr_by_center%>,<%=sum_npr_by_center%>);
pieChart("#pie_sp_npr_by_type",<%=sp_npr_by_type%>,<%=sum_npr_by_type%>);
pieChart("#pie_sp_npr_by_country_group",<%=sp_npr_by_country_group%>,<%=sum_npr_by_country_group%>);
/* Using PieChart*/
//barChart("#bar_sp_npr_by_center_drilldown", <%=categoryAxis_npr_center_using%>, <%=series_job_center%> )	;
barChart("#bar_sp_npr_by_type_drilldown", <%=categoryAxis_npr_type_using%>, <%=series_job_type%>);
barChart("#bar_sp_npr_by_country_group_drilldown", <%=categoryAxis_npr_country_group_using%>, <%=series_job_country_group%>)	;
/* Using BarChart*/

/* Using BarChart*/


/*###  kendoui panalBar start  ###*/
$("#panelBar1").kendoPanelBar({
expandMode: "single",
animation: {
        // fade-out closing items over 1000 milliseconds
        close: {
            duration: 15000,
            effects: "fadeOut"
        },
       // fade-in and expand opening items over 500 milliseconds
       open: {
           duration: 5500,
           effects: "expandVertical fadeIn"
       }
	  }
});
$("#panelBar2").kendoPanelBar({
	expandMode:"single"
});

/*###  kendoui panalBar end  ###*/

/*###  kendoui barchart1 start  ###*/


/*###  kendoui barchart1 end  ###*/
	




//alert($("#panelBar2").length);

$("#panelBar2 .panel1").click(function(){


});
$("#panelBar2 .panel2").click(function(){


});
$("#panelBar2 .panel1").trigger("click");


/*### Config Tab Start ###*/


//$(".ui-tabs-panel").css({"padding":"0px"});


/* Tab2 Start*/

	

$("#tabHr1").tabs();
$("#tabHr1 ul li").css({"font-weight":"normal"});

$("a[href=#hrContent21]").trigger("click");

$("a[href=#hrContent21]").click(function(){

});

$("a[href=#hrContent22]").click(function(){

});




/*Tab2 End*/



/*### Config Tab End ###*/


});


//define function extenal jquery

function templateFormat(value,summ) {
   var value1 = Math.floor(value);
   var value2 = Math.floor((value/summ)*100);
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
												<div id="pie_sp_npr_by_center"></div>
												</td>
												
											</tr>
											<tr>
												<td>
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
												<td>
												<div id="pie_sp_npr_by_type"></div>
												</td>
												
											</tr>
												<td>
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
												<td>
												<div id="pie_sp_npr_by_country_group"></div>
												</td>
												
											</tr>
											<tr>
												<td>
												<div id="bar_sp_npr_by_country_group_drilldown"></div>
												</td>
											</tr>
									</table>
						</div>
				</div>
			
	</div>
</div>

<br style="clear:both">

