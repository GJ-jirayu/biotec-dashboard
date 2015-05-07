<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>
<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");
String Param_sp_center = "";
String sp_emp_by_center="";
Integer sum_total_employee=0;
String shortname="";
String color="";

try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		//เรียก store procedure เพื่อสร้าง pie Chart
		Query="CALL sp_emp_by_center("+ParamYear+","+ParamMonth+");";
		rs = st.executeQuery(Query);
		Integer i =1 ;
		sp_emp_by_center+="[";
		while(rs.next()){
		//กำหนดสีตามศูนย์
		if(rs.getString("center_th_shortname").equals("สก.")){
		color="#25a0da";
		}else if(rs.getString("center_th_shortname").equals("ศช.")){
		color="#309b46";
		}else if(rs.getString("center_th_shortname").equals("ศว.")){
		color="#dee92d";
		}else if(rs.getString("center_th_shortname").equals("ศอ.")){
		color="#e62d32";
		}else if(rs.getString("center_th_shortname").equals("ศน.")){
		color="#ff7110";
		}else if(rs.getString("center_th_shortname").equals("ศจ.")){
		color="#6C2E9B";
		}
		
		if(i==1){
		//สร้าง json สำหรับ piechart มีรูปแบบดังนี้
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		sp_emp_by_center+="{category:";
		sp_emp_by_center+= "\""+rs.getString("center_th_shortname") +"\"";
		sp_emp_by_center+= ",value:"+rs.getString("total_employee") ;
		sp_emp_by_center+= ",color:\""+color+"\"";
		sum_total_employee+=rs.getInt("total_employee");
		sp_emp_by_center+="}";
		}else{
		sp_emp_by_center+=",{category:";
		sp_emp_by_center+= "\""+rs.getString("center_th_shortname") +"\"";
		sp_emp_by_center+= ",value:"+rs.getString("total_employee");
		sp_emp_by_center+= ",color:\""+color+"\"";
		sum_total_employee+=rs.getInt("total_employee");
		sp_emp_by_center+="}";
		}
		
	i++;
		}
		sp_emp_by_center+="]";
		//out.println("sum---"+sum_total_employee+"<br>");
		//out.println("sp_emp_by_center"+sp_emp_by_center);
		
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
//sp_emp_by_employ_type
String sp_emp_by_employ_type ="";
Integer sum_sp_emp_by_employ_type =0;
Integer j =1;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_employ_type("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		//Query="CALL sp_emp_by_employ_type(2012,11,'ศจ.');";
		rs = st.executeQuery(Query);
		sp_emp_by_employ_type+="[";
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(j==1){
		sp_emp_by_employ_type+="{category:";
		sp_emp_by_employ_type+= "\""+rs.getString("employ_type") +"\"";
		sp_emp_by_employ_type+= ",value:"+rs.getString("total_employee") ;
		sum_sp_emp_by_employ_type+=rs.getInt("total_employee");
		sp_emp_by_employ_type+="}";
		}else{
		sp_emp_by_employ_type+=",{category:";
		sp_emp_by_employ_type+= "\""+rs.getString("employ_type") +"\"";
		sp_emp_by_employ_type+= ",value:"+rs.getString("total_employee");
		sum_sp_emp_by_employ_type+=rs.getInt("total_employee");
		sp_emp_by_employ_type+="}";
		}
	j++;
		}
		sp_emp_by_employ_type+="]";
		//out.println(center_name);
		//out.println("sp_emp_by_employ_type"+sp_emp_by_employ_type);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error</font>"+ex);
}



//sp_emp_by_education_level_group
String sp_emp_by_education_level_group ="";
Integer sum_sp_emp_by_education_level_group=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_education_level_group("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_emp_by_education_level_group+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
	
		if(i==1){
	
		sp_emp_by_education_level_group+="{category:";
	
		sp_emp_by_education_level_group+= "\""+rs.getString("education_level_group") +"\"";
		sp_emp_by_education_level_group+= ",value:"+rs.getString("total_employee") ;
		sum_sp_emp_by_education_level_group+=rs.getInt("total_employee");
		sp_emp_by_education_level_group+="}";
		}else{
		sp_emp_by_education_level_group+=",{category:";
	
		sp_emp_by_education_level_group+= "\""+rs.getString("education_level_group") +"\"";
		sp_emp_by_education_level_group+= ",value:"+rs.getString("total_employee");
		sum_sp_emp_by_education_level_group+=rs.getInt("total_employee");
		sp_emp_by_education_level_group+="}";
		}
		
	i++;
		}
		sp_emp_by_education_level_group+="]";
		//out.println("sum--"+sum_sp_emp_by_education_level_group+"<br>");
		//out.println("sp_emp_by_education_level_group"+sp_emp_by_education_level_group);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_education_level_group</font>"+ex);
}


//############################  sp_emp_by_job_family  Start ############################ //
String sp_emp_by_job_family ="";
Integer sum_sp_emp_by_job_family =0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_job_family("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_emp_by_job_family+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	
		sp_emp_by_job_family+="{category:";
	
		sp_emp_by_job_family+= "\""+rs.getString("job_family_name") +"\"";
		sp_emp_by_job_family+= ",value:"+rs.getString("total_employee") ;
		sum_sp_emp_by_job_family+=rs.getInt("total_employee") ;
		sp_emp_by_job_family+="}";
		}else{
		sp_emp_by_job_family+=",{category:";
	
		sp_emp_by_job_family+= "\""+rs.getString("job_family_name") +"\"";
		sp_emp_by_job_family+= ",value:"+rs.getString("total_employee");
		sum_sp_emp_by_job_family+=rs.getInt("total_employee") ;
		sp_emp_by_job_family+="}";
		}
		
	i++;
		}
		sp_emp_by_job_family+="]";
		//out.println("-------------------------------------------------------");
		//out.println("sp_emp_by_job_family"+sp_emp_by_job_family);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_job_family</font>"+ex);
}
//############################  sp_emp_by_job_family  End ############################ //


//############################  sp_emp_by_function_type  Start ############################ //

String sp_emp_by_function_type ="";
Integer sum_sp_emp_by_function_type=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_function_type("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_emp_by_function_type+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	
		sp_emp_by_function_type+="{category:";
	
		sp_emp_by_function_type+= "\""+rs.getString("function_type") +"\"";
		sp_emp_by_function_type+= ",value:"+rs.getString("total_employee") ;
		sum_sp_emp_by_function_type+=rs.getInt("total_employee") ;
		sp_emp_by_function_type+="}";
		}else{
		sp_emp_by_function_type+=",{category:";
	
		sp_emp_by_function_type+= "\""+rs.getString("function_type") +"\"";
		sp_emp_by_function_type+= ",value:"+rs.getString("total_employee");
		sum_sp_emp_by_function_type+=rs.getInt("total_employee") ;
	
		sp_emp_by_function_type+="}";
		}
		
	i++;
		}
		sp_emp_by_function_type+="]";
		//out.println("-------------------------------------------------------");
		//out.println("sp_emp_by_function_type"+sp_emp_by_function_type);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_function_type</font>"+ex);
}

//############################  sp_emp_by_function_type  End ############################ //

//############################  sp_hr_expense  Start ############################ //

String sp_hr_expense ="";
Integer sum_sp_hr_expense=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_hr_expense("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_hr_expense+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	
		sp_hr_expense+="{category:";
	
		sp_hr_expense+= "\""+rs.getString("hr_group_name") +"\"";
		sp_hr_expense+= ",value:"+rs.getString("finance_amount") ;
		sum_sp_hr_expense+=rs.getInt("finance_amount") ;
		sp_hr_expense+="}";
		}else{
		sp_hr_expense+=",{category:";
	
		sp_hr_expense+= "\""+rs.getString("hr_group_name") +"\"";
		sp_hr_expense+= ",value:"+rs.getString("finance_amount");
		sum_sp_hr_expense+=rs.getInt("finance_amount") ;
		sp_hr_expense+="}";
		}
		
	i++;
		}
		sp_hr_expense+="]";
		//out.println("-------------------------------------------------------");
		//out.println("sp_hr_expense"+sp_hr_expense);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_hr_expense</font>"+ex);
}

//############################  sp_hr_expense  End ############################ //

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
width:314px;
height:270px;
float:left;
margin:2px;

border-radius:5px;
   /* background: url("images/ui-bg_highlight-hard_100_f2f5f7_1x100.png") repeat-x scroll 50% top #ffffff;*/
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
	background:url("images/ui-bg_highlight-soft_100_deedf7_1x100.png") repeat-x scroll  50% 50%  #DEEDF7;
    border: 1px solid #AED0EA;

}
.content  #row1 .box #head .title{
	padding:5px;
	text-align:center;
	
}
.content  #row1 .box #body{
width:auto;
height:250px;

}
.content #row2{
width:1000px;
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
#tabHr1{
height:250px;
}
#pie1{
 top: -10px;
  left: -20px;
}
#pie11{
 top: -10px;
  left: -20px;
}
</style>

<script type="text/javascript">
//ฟังก์ชั่นจัดการCommas
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
/*###  pie start ###*/

var pieChart= function(id_param,data_param,summ_param){

		var templateFormat;
		//ทำการตรวจสอบ id_param ว่าเป็นของ pie Chart ตัวไหนถ้าเป็น #pie_hr_expense ตอน hover ให้ไปเรียกฟังก์ชั่น
		//templateFormat2 ถ้าไม่ใช่ให้เรียกฟังก์ชั่น templateFormat
		if( id_param == "#pie_hr_expense"){ templateFormat = "#= templateFormat2(value,"+summ_param+")#"; }
		else { templateFormat =  "#= templateFormat(value,"+summ_param+")#"; }
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
							template:templateFormat
                        },
			
			seriesDefaults: {
				labels: {
					visible: false,
					format: "{0}%",
					
				}
			}

		});
}

/*###  pie end ###*/

/* Using PieChart*/
//เรียกฟังก์ชัน piechart พร้อมส่ง parameter
pieChart("#pie_emp_by_center",<%=sp_emp_by_center%>,<%=sum_total_employee%>);
pieChart("#pie_emp_by_employ_type",<%=sp_emp_by_employ_type%>,<%=sum_sp_emp_by_employ_type%>);
pieChart("#pie_emp_by_education_level_group",<%=sp_emp_by_education_level_group%>,<%=sum_sp_emp_by_education_level_group%>);
pieChart("#pie_emp_by_job_family",<%=sp_emp_by_job_family%>,<%=sum_sp_emp_by_job_family%>);
pieChart("#pie_emp_by_function_type",<%=sp_emp_by_function_type%>,<%=sum_sp_emp_by_function_type%>);
pieChart("#pie_hr_expense",<%=sp_hr_expense%>,<%=sum_sp_hr_expense%>);
/* Using PieChart*/

/* Tab2 Start*/
$("#tabHr1.ui-tabs-panel ").css({"padding":"0px"});
$("#tabHr1.ui-widget-content").css({"border":"0px"});
/*Tab2 End*/

/*### Config Tab End ###*/
});

//ฟังก์ชั่นสำหรับ tooltip
function templateFormat(value,summ) {
   var value1 = addCommas(value);
   var value2 = ((value/summ)*100).toFixed(2);
   return value1 + " , " + value2 + " %";
}
//ฟังก์ชั่นสำหรับ tooltip มีหน่วยเป็น "ล้านบาท"
function templateFormat2(value,summ) {
   var value1 = addCommas(value.toFixed(2));
   var value2 = ((value/summ)*100).toFixed(2);
   return value1 +" ล้านบาท  , " + value2 + " %";
}

</script>
<div class="content">
	<div id="row1">

				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วนพนักงานแยกตามศูนย์
							</div>
						</div>
						<div id="body">
									<div id="pie_emp_by_center"></div>
						</div>
				</div>
				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วนพนักงานตามประเภทการจ้าง
							</div>
						</div>
						<div id="body">
								<div id="pie_emp_by_employ_type"></div>
						</div>
				</div>
				<div class="box">
						<div id="head">
							<div class="title">
							สัดส่วนพนักงานตามระดับการศึกษา
							</div>
						</div>
						<div id="body">
							<div id="pie_emp_by_education_level_group"></div>
						</div>
				</div>
				<div class="box">
						<div id="head">
								<div class="title">
								สัดส่วนพนักงานตามกลุ่มตำแหน่ง
								</div>
						</div>
						<div id="body">
								<div id="pie_emp_by_job_family"></div>
						</div>
				</div>

				<div class="box">
						<div id="head">
								<div class="title">
								สัดส่วนพนักงานตามหน้าที่
								</div>
						</div>
						<div id="body">
								<div id="pie_emp_by_function_type"></div>
						</div>
				</div>

				<div class="box">
						<div id="head">
								<div class="title">
								สัดส่วนค่าใช้จ่ายบุคลากร
								</div>
						</div>
						<div id="body">
								<div id="pie_hr_expense"></div>
						</div>
				</div>
	</div>
	
</div>

</ul>
<br style="clear:both">

