<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");

	String paramYear= request.getParameter("paramYear");
	String paramMonth= request.getParameter("paramMonth");
	String paramOrg= request.getParameter("paramOrg");

%>
<!-- Tab3 -->
<%
String $htmlTable2="";
String[] area_array;
Query="CALL sp_balance_sheet_list("+paramYear+","+paramMonth+");";
rs=st.executeQuery(Query);

			
$htmlTable2+="<table  id='finance_tb1'  width='100%' cellpadding='1px' cellspacing='1px' >";
	$htmlTable2+="<thead>";
// Loop while into tbody
String[] amount_array;
Double amount_sum=0.0;
Double amount_by_center=0.0;
Integer chkHead = 1;
	while(rs.next()){
		if(chkHead == 1){
		//tr#########################################1
		$htmlTable2+="<tr>";
			$htmlTable2+="<th width='300'>";
				$htmlTable2+="รายการ";
			$htmlTable2+="</th>";
			//######### Loop title Start ############
			area_array=rs.getString("area_list").split(",");
			for(int i=0; i<area_array.length; i++){
			$htmlTable2+="<th>";
				$htmlTable2+=area_array[i];
			$htmlTable2+="</th>";
			}
			//######### Loop title End ############

			$htmlTable2+="<th>";
				$htmlTable2+="รวม";
			$htmlTable2+="</th>";

			$htmlTable2+="</tr>";
			//tr#########################################1
			$htmlTable2+="</thead>";
			$htmlTable2+="<tbody>";
			chkHead = 0;
		}
		amount_array =rs.getString("amount_list").split(",");
		$htmlTable2+="<tr>";
			$htmlTable2+="<td><div class='level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+"</div></td>";
			for(int i=0; i < amount_array.length; i++){
				amount_by_center=Double.parseDouble(amount_array[i]);
				$htmlTable2+="<td>"+numberFormatter.format(amount_by_center)+"</td>";
				amount_sum+=Double.parseDouble(amount_array[i]);
			}		
			$htmlTable2+="<td>"+numberFormatter.format(amount_sum)+"</td>";
			
		$htmlTable2+="</tr>";
		amount_sum=0.0;
	}

// Loop while into tbody

	$htmlTable2+="</tbody>";
	$htmlTable2+="</table>";
	conn.close();
//sucessfully
%>
<div id="titleTop" style="text-align:right"> หน่วย : ล้านบาท </div>
<%
out.print($htmlTable2);
%>

<!-- Config Style-->
	<style type="text/css">
		#mainContent{
		width:auto;
		height:auto;
		}
		#mainContent #row1{
		width:985px;
		height:auto;
		}
		#mainContent #row1 #column1{
		width:auto;
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
		padding:5px;
		border-radius:5px;
		}

	</style>

	<style type="text/css">
	#pie1{
	padding:5px;
	}
	#pie2{
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

<script type="text/javascript">
	$(document).ready(function(){
		//#######################Menagement Tab1 Start ###############
		$("table#finance_tb1 thead tr  th").css({"background":"#008EC3  ","padding-left":"5px","padding-right":"5px","color":"white","padding":"2px"});
		//Set level1
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

	});

</script>
