<%@page contentType="text/html" pageEncoding="utf-8"%>
<!doctype html>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>

<html>
    <head>
        <title>R&D Dashboard</title>
		<link href="rd.css" rel ="stylesheet" type="text/css">
		<link href="../styles/kendo.common.min.css" rel="stylesheet">
		<link href="../styles/kendo.default.min.css" rel="stylesheet">
		<link href="../jqueryUI/css/cupertino/jquery-ui-1.8.21.custom.css" rel="stylesheet">
		 <link href="../styles/kendo.dataviz.min.css" rel="stylesheet">
		


        <script src="../js/jquery.min.js"></script>
		<script src="../js/kendo.all.min.js"></script>
		  <script src="../js/kendo.dataviz.min.js"></script>
		<script type="text/javascript" src="../jqueryUI/js/jquery-ui-1.8.21.custom.min.js"></script>
	
	<!-- Define CSS-->
		<style type="text/css">
			html,
			body {
				background-color: white;
				color:black;
				margin:0px;
				padding:0px;
				font-size:12px;
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
			background-image:url("images/loading.gif");
			position:absolute ;
			position:center;
			z-index:5;
			}
			.inlinesparkline{
			width:100px;
			height:100px;
			}
			#contentMain{
			display:none;
			}
		</style>
		<style scoped>
				#Main-Panel{
					/*border: 1px solid #dedede;*/
					-webkit-border-radius: 5px;
					-moz-border-radius: 5px;
					border-radius: 5px;
					text-align: left;
					padding:2px;
					margin:1px;
					width: 970px;
					position: relative;
					background:#008EC3 ;
					color:white;
					font-weight:bold;
				}
			</style>


	<%
	

		/*------------------- Set Variable -------------------*/

		String ParamYear = "";
		String ParamMonth = "";
		String ParamOrg = "";

		String V_Year = ""; // Values of Parameter Organization
		String V_Month = ""; // Values of Parameter Sales Region
		String V_Org = ""; // Values of Parameter Branch

//###############Query Handler Organization start  ####################
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
	//insert code allow function start
	st = conn.createStatement();
		Query="CALL sp_center();";
		rs = st.executeQuery(Query);
		 
		while(rs.next()){
		V_Org+="<option value="+rs.getString("center_name")+">"+rs.getString("center_name")+"</option>";
		}
	//insert code allow function end
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
//############### Query Handler Organization end ###############
		ResultSet rs1;
		Statement st1;
		int i=0;
		String Query1 ="";

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
		int	cMonth = Integer.parseInt(rs.getString("month_date"));
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
		$("#loading").css({"top":"250px","left":$width+"px"}).ajaxStart(function(){
		$(this).show();
		}).ajaxStop(function(){
		$(this).hide();
		});
		/*#### Loading End ###*/

	  $("#ParamYear").kendoDropDownList();

	  $("#ParamMonth").kendoDropDownList();

	  $("#ParamOrg").kendoDropDownList();
	
	/*### jQuery Funtions Start ###*/
	$("#form_1").submit(function(){
	
			$.ajax({
			url:'DefaultContent.jsp',
			type:'get',
			dataType:'json',
			data:{"ParamMonth":$("#ParamMonth").val(),"ParamYear":$("#ParamYear").val()},
			success:function(data){
				$(".domParam").remove();
				$("body").append("<input type='hidden' name='domParamCenter' class='domParam' id='domParamCenter' value='BIOTEC'>");
				$("body").append("<input type='hidden' name='domParamMonth' class='domParam' id='domParamMonth' value='"+$("#ParamMonth").val()+"'>");
				$("body").append("<input type='hidden' name='domParamYear' class='domParam' id='domParamYear' value='"+$("#ParamYear").val()+"'>");

			
				//console.log(data[0]["category_center"]);
				//console.log(data[1]["series_center"]);

				$("#divisionName").text($("#domParamCenter").val());
				OutputTypeOpenUrlHandle(parseInt($("#domParamYear").val()),parseInt($("#domParamMonth").val()),$("#domParamCenter").val(),'','');
				baChart_sp_ic_score_by_department('','');
				baChart_sp_ic_score_by_center(data[1]["series_center"],data[0]["category_center"]);
				pieChart_sp_ic_score_by_job_family(data[2]["pie_sp_ic_score"],data[3]["sum_pie_sp_ic_score"]);
				stackChart_sp_count_emp_all_vs_jf2000(data[6]["category_emp_all_vs_jf2000"],data[7]["series_emp_all_vs_jf2000"]);//1
				stackChart_sp_count_emp_by_job_grade(data[8]["category_emp_by_job_grade"],data[9]["series_emp_by_job_grade"]);//2
				stackChart_sp_ic_score_by_output_type(data[4]["category_by_output_type"],data[5]["series_by_output_type"]);//3
				AjaxTop20Content($("#ParamYear").val(),$("#ParamMonth").val());
				AjaxScoreByDivisionContent($("#ParamYear").val(),$("#ParamMonth").val(),'BIOTEC');
				$("#contentMain").show();
			}
			
			}); 
			return false;
	});

	/*### jQuery Funtions End ###*/

	/* ### Ajax to server Function ### */
	
function OutputTypeOpenUrlHandle(year,month,center,div,dept){

	$("#ic_score_open").unbind('click');
	$("#ic_score_open").click(function(){
		var url = "<%=request.getContextPath()%>/csv/csv_rd.jsp?year="+year+"&month="+month+"&center_en="+center+"&division_en="+div+"&department_en="+dept;
		window.open(url,"_blank");
	});
}	
function AjaxTop20Content(vYear,vMonth){
		$.ajax({
				url:'Top20Content.jsp',
				type:'get',
				dataType:'json',
				data:{'year': vYear, 'month': vMonth},
				success:function(data){
					baChart_sp_top20_ic_score(eval("("+data[0]['category']+")"),data[0]['series']);			
				}
			});
}	
function AjaxScoreByDivisionContent(vYear,vMonth,vCenter){
$.ajax({
				url:'ICScoreByDivisionContent.jsp',
				type:'get',
				dataType:'json',
				data:{'year': vYear, 'month': vMonth,'center': vCenter},
				success:function(data){
					baChart_sp_ic_score_by_division(data[0]['category'],data[0]['series']);	
				}
			});
}
function AjaxScoreByDepartmentContent(vYear,vMonth,vCenter,vDiv,vDept){
$.ajax({
				url:'ICScoreByDepartmentContent.jsp',
				type:'get',
				dataType:'json',
				data:{'year': $("#ParamYear").val(), 'month':$("#ParamMonth").val(),'center':vCenter,'division':vDiv,'department':vDept},
				success:function(data){
					baChart_sp_ic_score_by_department(data[0]['category'],data[0]['series']);	
				}
			});
}
	
	/* ### Ajax to server END ### */
	
	/*###  baChart_sp_ic_score_by_center  start ###*/
function  checkBarTypeCenter(e){
	$("#domParamCenter").remove();
	$("#departmentName").empty();
	$("#departmentName").append("(Lab)");
	$("body").append("<input type='hidden' name='domParamCenter' class='domParam' id='domParamCenter' value='"+e.category+"'>");
	
	$.ajax({
			url:'CenterContent.jsp',
			type:'get',
			dataType:'json',
			data:{"ParamMonth":$("#domParamMonth").val(),"ParamYear":$("#domParamYear").val(),"ParamCenter":e.category},
			success:function(data){
				//comment ไว้ตรวจสอบค่าที่ส่งมา และรับในรูปแบบ json
				/*
				console.log(data[0]["category_center"]);
				console.log(data[1]["series_center"]);

				console.log(data[2]["category_division"]);
				console.log(data[3]["series_division"]);

				//console.log(data[4]["category_top20_ic_score"]);
				//console.log(data[5]["series_top20_ic_score"]);

				console.log(data[4]["pie_sp_ic_score"]);
				console.log(data[5]["sum_pie_sp_ic_score"]);
				
				console.log(data[6]["category_by_output_type"]);
				console.log(data[7]["series_by_output_type"]);

				console.log(data[8]["category_emp_all_vs_jf2000"]);
				console.log(data[9]["series_emp_all_vs_jf2000"]);
				
				console.log(data[10]["category_emp_by_job_grade"]);
				console.log(data[11]["series_emp_by_job_grade"]);
*/
				$("#divisionName").text($("#domParamCenter").val());
				OutputTypeOpenUrlHandle(parseInt($("#domParamYear").val()),parseInt($("#domParamMonth").val()),$("#domParamCenter").val(),'','');
				baChart_sp_ic_score_by_department('','');
				//baChart_sp_ic_score_by_division(data[2]["category_division"],data[3]["series_division"]);
				pieChart_sp_ic_score_by_job_family(data[2]["pie_sp_ic_score"],data[3]["sum_pie_sp_ic_score"]);
				stackChart_sp_ic_score_by_output_type(data[4]["category_by_output_type"],data[5]["series_by_output_type"]);
				stackChart_sp_count_emp_all_vs_jf2000(data[6]["category_emp_all_vs_jf2000"],data[7]["series_emp_all_vs_jf2000"]);
				stackChart_sp_count_emp_by_job_grade(data[8]["category_emp_by_job_grade"],data[9]["series_emp_by_job_grade"]);
				AjaxScoreByDivisionContent($("#ParamYear").val(),$("#ParamMonth").val(),e.category);
				$("#contentMain").show();
				
			}
	});

}
//bar1
var baChart_sp_ic_score_by_center= function(seriesParam, categoryParam){
	$("#baChart_sp_ic_score_by_center").kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
						chartArea:{
						width:300,
						height:250
						},
                        legend: {
                            position: "top"
                        },
                        seriesDefaults: {
                            type: "column",
							stack: false
                        },
                        series:seriesParam,
						valueAxis: [{
								name: "one",
                            title: { text: "" },
                           // min: 0,
                           // max: 2000,
						   labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            }
						   
                        }, {
                            name: "two",
                            title: { text: "" },
                           // min: 0,
                            //max: 450
                        }],
                        categoryAxis: {
                            categories:categoryParam,
							axisCrossingValue: [0,100],

                        },
                        tooltip: {
                            visible: true,
                            format: "{0:N0}"

                        },
						seriesClick:checkBarTypeCenter
				
                    });


}
/*###  baChart_sp_ic_score_by_center  end ###*/
/*###  baChart_sp_ic_score_by_division  start ###*/
function checkBarTypeDivision(e){
	$.ajax({
			url:'DivisionContent.jsp',
			type:'get',
			dataType:'json',
			data:{"ParamMonth":$("#domParamMonth").val(),"ParamYear":$("#domParamYear").val(),'ParamCenter':$("#domParamCenter").val(),"ParamDivision":e.category},
			success:function(data){
			$("#domParamDivision").remove();
			$("body").append("<input type='hidden' name='domParamDivision' class='domParam' id='domParamDivision' value='"+e.category+"'>");
			//comment ไว้ตรวจสอบค่าที่ส่งมา และรับในรูปแบบ json
/*
				console.log(data[0]["category_center"]);
				console.log(data[1]["series_center"]);

				console.log(data[2]["category_division"]);
				console.log(data[3]["series_division"]);

				//console.log(data[4]["category_top20_ic_score"]);
				//console.log(data[5]["series_top20_ic_score"]);

				console.log(data[4]["pie_sp_ic_score"]);
				console.log(data[5]["sum_pie_sp_ic_score"]);
				
				console.log(data[6]["category_by_output_type"]);
				console.log(data[7]["series_by_output_type"]);

				console.log(data[8]["category_emp_all_vs_jf2000"]);
				console.log(data[9]["series_emp_all_vs_jf2000"]);
				
				console.log(data[10]["category_emp_by_job_grade"]);
				console.log(data[11]["series_emp_by_job_grade"]);

				console.log(data[12]["category_by_department"]);
				console.log(data[13]["series_by_department"]);
*/
				$("#departmentName").text($("#domParamDivision").val());
				OutputTypeOpenUrlHandle(parseInt($("#domParamYear").val()),parseInt($("#domParamMonth").val()),$("#domParamCenter").val(),$("#domParamDivision").val(),'');
				pieChart_sp_ic_score_by_job_family(data[2]["pie_sp_ic_score"],data[3]["sum_pie_sp_ic_score"]);
				stackChart_sp_ic_score_by_output_type(data[4]["category_by_output_type"],data[5]["series_by_output_type"]);
				stackChart_sp_count_emp_all_vs_jf2000(data[6]["category_emp_all_vs_jf2000"],data[7]["series_emp_all_vs_jf2000"]);
				stackChart_sp_count_emp_by_job_grade(data[8]["category_emp_by_job_grade"],data[9]["series_emp_by_job_grade"]);
				AjaxScoreByDepartmentContent($("#ParamYear").val(),$("#ParamMonth").val(),$("#domParamCenter").val(),e.category);
			}
	});

}
//bar 2
var baChart_sp_ic_score_by_division= function(categoryParam,seriesParam){
	$("#baChart_sp_ic_score_by_division").kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
						chartArea:{
						width:300,
						height:250
						},

						
                        legend: {
                            position: "top"
                        },
                        seriesDefaults: {
                            type: "column",
							stack: false
                        },
                        series:seriesParam,
                      valueAxis: [{
								name:"one",
                            title: { text: "" },
                            labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            }
							//min: 0,
                            //max: 600
                        }, {
                            name: "two",
                            title: { text: "" },
                           // min: 0,
                          //  max: 140
                        }],
                        categoryAxis: {
                            categories:categoryParam ,
							axisCrossingValue: [0,100],
							labels: {rotation : -90}
							
                        },
                        tooltip: {
                            visible: true,
                            format: "{0:N0}"
                        },
						seriesClick:checkBarTypeDivision
                    });
}

/*###  baChart_sp_ic_score_by_division  end ###*/
/*###  baChart_sp_ic_score_by_department  start ###*/
function checkBarTypeDepartment(e){
			$.ajax({
			url:'DepartmentContent.jsp',
			type:'get',
			dataType:'json',
			data:{"ParamMonth":$("#domParamMonth").val(),"ParamYear":$("#domParamYear").val(),"ParamCenter":$("#domParamCenter").val(),"ParamDivision":$("#domParamDivision").val(),"ParamDepartment":e.category},
			success:function(data){
			$("#domParamDepartment").remove();
			$("body").append("<input type='hidden' name='domParamDepartment' class='domParam' id='domParamDepartment' value='"+e.category+"'>");
			//comment ไว้ตรวจสอบค่าที่ส่งมา และรับในรูปแบบ json
/*
				console.log(data[0]["category_center"]);
				console.log(data[1]["series_center"]);

				console.log(data[2]["category_division"]);
				console.log(data[3]["series_division"]);

				//console.log(data[4]["category_top20_ic_score"]);
				//console.log(data[5]["series_top20_ic_score"]);

				console.log(data[4]["pie_sp_ic_score"]);
				console.log(data[5]["sum_pie_sp_ic_score"]);
				
				console.log(data[6]["category_by_output_type"]);
				console.log(data[7]["series_by_output_type"]);

				console.log(data[8]["category_emp_all_vs_jf2000"]);
				console.log(data[9]["series_emp_all_vs_jf2000"]);
				
				console.log(data[10]["category_emp_by_job_grade"]);
				console.log(data[11]["series_emp_by_job_grade"]);

				console.log(data[12]["category_by_department"]);
				console.log(data[13]["series_by_department"]);
*/
				OutputTypeOpenUrlHandle(parseInt($("#domParamYear").val()),parseInt($("#domParamMonth").val()),$("#domParamCenter").val(),$("#domParamDivision").val(),$("#domParamDepartment").val());
				pieChart_sp_ic_score_by_job_family(data[2]["pie_sp_ic_score"],data[3]["sum_pie_sp_ic_score"]);
				stackChart_sp_ic_score_by_output_type(data[4]["category_by_output_type"],data[5]["series_by_output_type"]);
				stackChart_sp_count_emp_all_vs_jf2000(data[6]["category_emp_all_vs_jf2000"],data[7]["series_emp_all_vs_jf2000"]);
				stackChart_sp_count_emp_by_job_grade(data[8]["category_emp_by_job_grade"],data[9]["series_emp_by_job_grade"]);
			}
			});
}
var baChart_sp_ic_score_by_department= function(categoryParam,seriesParam){
	$("#baChart_sp_ic_score_by_department").kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: "",
                        },
						chartArea:{
						width:300,
						height:250
						},
                        legend: {
                            position: "top"
                        },
                        seriesDefaults: {
                            type: "column",
							stack: false
                        },
                        series:seriesParam,
                       valueAxis: [{
								name: "one",
                            title: { text: "" },
							 labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            }
                         /*   min: 0,
                            max: 6*/
                        }, {
                            name: "two",
                            title: { text: "" },
                        /*    min: 0,
                            max: 6*/
                        }],
                        categoryAxis: {
                            categories:categoryParam,
							axisCrossingValue:[0,100],
							labels: {rotation : -90}
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        },
						seriesClick:checkBarTypeDepartment
						
                    });
	
}

/*###  baChart_sp_ic_score_by_department  end ###*/

/*###  stackChart_sp_top20_ic_score  start ###*/
var baChart_sp_top20_ic_score= function(categoryParam,seriesParam){
	$("#baChart_sp_top20_ic_score").kendoChart({
                        theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: "Top 20 IC Score"
                        },
						chartArea:{
						width:950,
						height:300
						},

						
                        legend: {
                            position: "top"
                        },
                        seriesDefaults: {
                            type: "column",
							stack: false
                        },
                        series: seriesParam,
                       valueAxis: [{
							name: "one",
                            title: { text: "" },
							 labels: {
                                template: "#= kendo.format('{0:N0}', value ) # "
                            }
                           // min: 0,
                           // max: 1400
                        }, {
                            name: "two",
                            title: { text: "" },
                            min: 0,
                            max: 140
                        }],
                        categoryAxis: {
							labels: {
                                rotation: -90
                            },
                            categories: categoryParam,
							axisCrossingValue: [0,100]
                        },

						
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        }
                    });
	
}

/*###  StackChart_sp_top20_ic_score  end ###*/
/*###  pieChart_sp_ic_score_by_job_family start ###*/
var pieChart_sp_ic_score_by_job_family= function(categoryParam,sum_pie_sp_ic_score){

		$("#pieChart_sp_ic_score_by_job_family").kendoChart({
			//theme: $(document).data("kendoSkin") || "metro",
			theme: $(document).data("kendoSkin") || "metro",
			title: {
				 text: ""
			},
			name:"9",
			plotArea:{
						background:""
			},
			legend: {
                            position: "right"
            },
			chartArea: {
			width: 310,
			height: 190
			},
			series: [{
                            type: "pie",

                            data:categoryParam
                        }],
                        tooltip: {
                            visible: true,
                         //  format: "{0}"
						   template: "${ value }, #= kendo.format('{0:P}', percentage)#"
						 //template: "#= templateFormat(value,"+sum_pie_sp_ic_score+") #"
                        },
			seriesDefaults: {
				labels: {
					visible: false,
					format: "{0}%"
				}
			},
			//seriesHover:onSeriesHover,
		});	
}

/*###  pieChart_sp_ic_score_by_job_family End ###*/
/*###  stackChart_sp_ic_score_by_output_type start ###*/



var stackChart_sp_ic_score_by_output_type= function(categoryParam,seriesParam){
// fix value to 3 chart  rowdata=4  name:value[1,2,3]  =>   rowdata=4 name:value[1] , rowdata=4 name:value[2] , rowdata=4 name:value[3]
// here how to alert value  => alert(seriesParam[0].data[0]);
var c1 = [];
var c2 = [];
var c3 = [];
for(var i = 0; i<seriesParam.length;i++){
	c1.push("{\"name\":\""+seriesParam[i].name+"\",\"data\":["+seriesParam[i].data[0]+"]}");
	c2.push("{\"name\":\""+seriesParam[i].name+"\",\"data\":["+seriesParam[i].data[1]+"]}");
	c3.push("{\"name\":\""+seriesParam[i].name+"\",\"data\":["+seriesParam[i].data[2]+"]}");
	//alert( $.parseJSON(c1));
}
		$("#stackChart_sp_ic_score_by_output_type").kendoChart({

			theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
                        legend: {
                            position: "top"
                        },
						chartArea:{
						width:270,
						height:90
						},
                        seriesDefaults: {
                            type: "bar",
                            stack: true
                        },
                        series: $.parseJSON("["+c1.join(",")+"]") ,
                        valueAxis: {
                            labels: {
                              //  format: "{0}%"
							  visible:false
                            }
                        },
                        categoryAxis: {
                            categories: [ categoryParam[0] ]
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        }
			//seriesHover:onSeriesHover,
		});
		// 2
		$("#stackChart_sp_ic_score_by_output_type_2").kendoChart({

			theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
                        legend: {
                            visible: false
                        },
						chartArea:{
						width:270,
						height:40
						},
                        seriesDefaults: {
                            type: "bar",
                            stack: true
                        },
                        series: $.parseJSON("["+c2.join(",")+"]"),
                        valueAxis: {
                            labels: {
                              //  format: "{0}%"
							  visible:false
                            }
                        },
                        categoryAxis: {
                            categories:[ categoryParam[1] ]
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        }
			//seriesHover:onSeriesHover,
				
		});
		//3
		$("#stackChart_sp_ic_score_by_output_type_3").kendoChart({

			theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
                        legend: {
                            visible: false 
                        },
						chartArea:{
						width:270,
						height:40
						},
                        seriesDefaults: {
                            type: "bar",
                            stack: true
                        },
                        series: $.parseJSON("["+c3.join(",")+"]"),
                        valueAxis: {
                            labels: {
                              //  format: "{0}%"
							  visible:false
                            }
                        },
                        categoryAxis: {
                            categories:[categoryParam[2] ]
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        }
						
			//seriesHover:onSeriesHover,
		});
}

/*###  stackChart_sp_count_emp_all_vs_jf2000 start ###*/
var stackChart_sp_count_emp_all_vs_jf2000= function(categoryParam,seriesParam){

		$("#stackChart_sp_count_emp_all_vs_jf2000").kendoChart({

			theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
                        legend: {
                           // position: "top"
							visible:false
                        },
						chartArea:{
						width:300,
						height:90
						},
                        seriesDefaults: {
                            type: "bar",
                            stack: true
                        },
                        series:seriesParam,
                        valueAxis: {
                            labels: {
                              //  format: "{0}%"
							  visible:false
                            }
                        },
                        categoryAxis: {
                            categories:categoryParam
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}"
                        }
			//seriesHover:onSeriesHover,

		});
}

/*###  stackChart_sp_count_emp_all_vs_jf2000 End ###*/
/*###  stackChart_sp_count_emp_by_job_grade start ###*/
var stackChart_sp_count_emp_by_job_grade= function(categoryParam,seriesParam){

		$("#stackChart_sp_count_emp_by_job_grade").kendoChart({

			theme: $(document).data("kendoSkin") || "metro",
                        title: {
                            text: ""
                        },
                        legend: {
                            position: "top",
							visible:false
                        },
						chartArea:{
						width:300,
						height:50
						},
                        seriesDefaults: {
                            type: "bar",
                            stack: true
                        },
                        series: seriesParam,
                        valueAxis: {
                            labels: {
                              //  format: "{0}%"
							  visible:false
                            }
                        },
                        categoryAxis: {
                            categories:categoryParam
                        },
                        tooltip: {
                            visible: true,
                             format: "{0:N0}",
							template: "#= series.name # ,  #= value #"
                        }
			//seriesHover:onSeriesHover,

		});	
}

/*###  stackChart_sp_count_emp_by_job_grade End ###*/
	$("form.#form_1 #submit1").trigger("click");

});

/*###  pieChart hr  Define start ###*/
function templateFormat(value,summ) {
   var value1 = Math.floor(value);
   var value2 = Math.floor((value/summ)*100);
   return value1 + " , " + value2 + " %";
}
/*### pieChart hr  Defind   end ###*/
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
					<select name="ParamMonth" id="ParamMonth" >
						<%out.print(V_Month);%>
					</select>
					</td>

					<td>
					</td>

					<td>
					<!--<button id="get" class="k-button" >&nbsp;&nbsp;OK&nbsp;&nbsp;</button>-->
					<input type="submit"value="&nbsp;&nbsp;OK&nbsp;&nbsp;"  class="k-button" id="submit1" >
					</td>
				</tr>
				</table>
				</form>
		
		
		</div>
	
	</div>
	<!--------------------------- Details Start--------------------------->


	<div id="contentMain">

<!-- TAB MANAGEMENT START -->
<div id="content">
		<div id="row1">
				<div id="column1">
						<div id="head1">
							<div id="title1">
						<!--<button>Up NC</button>-->
							IC Score Per NC
							</div>
						</div>
						<div id="content1">
								<div id="baChart_sp_ic_score_by_center"></div>
						</div>
				</div>
				<div id="column2">
						<div id="head2">
								<div id="title2">
									<div id="divisionName">BIOTEC(RU)</div>
							</div>
						</div>
						<div id="content2">
								<div id="baChart_sp_ic_score_by_division"></div>
						</div>
				</div>
				<div id="column3">
						<div id="head3">
							<div id="title3">
							
							<div id="departmentName">(Lab)</div>
							</div>
						</div>
						<div id="content3">
							<div id="baChart_sp_ic_score_by_department"></div>
						</div>
				</div>
		</div>
		<div id="row2">
				<div id="column21">
						<div class="head">
								<div class="title">
								 Employee(Count)
								</div>
						</div>
						<div class="content">
								<br/>
								<div id="stackChart_sp_count_emp_all_vs_jf2000"></div>
								<br/>
								<div id="stackChart_sp_count_emp_by_job_grade"></div>
						</div>
				</div>
				<div id="column22">
						<div class="head">
								<div class="title">
								 IC Score by OutpuType<a id="ic_score_open"  target="_blank" onclick="return fales;" ><button>Open</button></a>
								</div>
						</div>
						<div class="content">
								<div id="stackChart_sp_ic_score_by_output_type"></div>
								<div id="stackChart_sp_ic_score_by_output_type_2"></div>
								<div id="stackChart_sp_ic_score_by_output_type_3"></div>
						</div>
				</div>
				<div id="column23">
						<div class="head">
								<div class="title">
								IC Score by JobFamily
								</div>
						</div>
						<div class="content">
									<div id="pieChart_sp_ic_score_by_job_family">
									</div>
						</div>
				</div>
		</div>
		<div id="row3">
			<div id="baChart_sp_top20_ic_score"></div>
		</div>
</div>
<!-- TAB MANAGEMENT END -->

	</div>
	

	<!--------------------------- Details End--------------------------->
			<div id="loading" >
				<br>
				<br>
				<br>
				<br>
				<span id="loading_span" style="margin-top:100px;">
					<b>Loading...</b>
				</span>
			</div>
	</body>
</html>