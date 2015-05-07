<%@page contentType="text/html" pageEncoding="utf-8"%>
<!doctype html>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>
<%
//set variable
String V_Year = ""; // Values of Parameter Organization
String V_Month = ""; // Values of Parameter Sales Region
String V_Org = ""; // Values of Parameter Branch
//set variable

//Query Handler Organization start
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
	//insert code allow function start
	st = conn.createStatement();
		Query="CALL sp_center();";
		rs = st.executeQuery(Query);
		while(rs.next()){
		//out.println(rs.getString("center_name"));
		V_Org+="<option value="+rs.getString("center_name")+">"+rs.getString("center_name")+"</option>";
		}
	//insert code allow function end
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
//Query Handler Organization end
		String Query1 ="";
		ResultSet rs1;
		Statement st1;
		int i = 0;

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
<html>
    <head>
        <title>HR Dashboard</title>
		<!-- stylesheet load external-->
		<link href="../styles/kendo.common.min.css" rel="stylesheet">
		<link href="../styles/kendo.default.min.css" rel="stylesheet">
		<link href="../jqueryUI/css/cupertino/jquery-ui-1.8.21.custom.css" rel="stylesheet">
		 <link href="../styles/kendo.dataviz.min.css" rel="stylesheet">
		<!-- stylesheet load external-->

		<!-- javascript load external-->
        <script src="../js/jquery.min.js"></script>
		<script src="../js/kendo.all.min.js"></script>
		<script src="../js/kendo.dataviz.min.js"></script>
		<script type="text/javascript" src="../jqueryUI/js/jquery-ui-1.8.21.custom.min.js"></script>
	   <!-- javascript load external-->
	
	  <!-- stylesheet embed-->
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
			height:100px;
			background-image:url("images/loading.gif");
			background-repeat:no-repeat;
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
			#dialogBox{
			display:none;
			}

		</style>
		<style scoped>
				#Main-Panel{
					margin-bottom:2px;
					padding: 3px;
					border: 1px solid #dedede;
					-webkit-border-radius: 5px;
					-moz-border-radius: 5px;
					border-radius: 5px;
					text-align: left;
					min-height: 30px;
					width: 960px;
					position: relative;
					background:#008EC3 ;
					font-weight:bold;
					color:white;
				}
				#tabHr{
				width:960px;
				margin:auto;
				}
			</style>


	

	<script type="text/javascript">
	/*#### Tab search above top start ###*/
	$(document).ready(function(){
		//ปุ่ม Detail คลิ๊กเพื่อดูข้อมูลการ reject file จาก ETL
		$("#buttonDetail").live("click",function(){
			var htmlArchive="";
			$("#dialogBox").empty();
			$.ajax({
				url:'NPR_listfile.jsp',
				dataType:'html',
				success:function(data){
				var obj=eval("("+data+")");
				//สั่งวนลูปข้อมูลออกมาแสดง
					for(var iNum=0; iNum <obj.length; iNum++){
						htmlArchive+="<ul>";
						htmlArchive+="<li><a href='<%=request.getContextPath()%>/biotec-dashboard/archive/"+obj[iNum]+"'>"+obj[iNum]+"</a></li>";
						htmlArchive+="</ul>";
					}
			//นำข้อมูลที่ได้ไปวางไว้ภายใต้ Element #dialogBox
			$("#dialogBox").append(htmlArchive);
				}
			});
			//กำหนดค่าเริ่มต้นของ dialog box
			$("#dialogBox").dialog({
					width:500,
					modal: true,
					title:"Browse File",
					buttons:{
					"OK":function(){
					$(this).dialog("close");
						}
					},
					regend:{
					position:"buttom"
					}
					
					});
					//สั่งให้ dialogBox แสดงผล
					$("#dialogBox").show();

		});

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


	/*### Function Ajax Management Start###*/
	//ฟังก์ชั่นในการเรียกหน้า HR
	var includeHr_1 = function(){
		//AJAX1
				
				$.ajax({
					url:'hr.jsp',
					type:'get',
					dataType:'html',
					//catch:false,
					data:{"ParamMonth":$("#ParamMonthSubmit").val(),"ParamYear":$("#ParamYearSubmit").val(),"ParamOrg":$("#ParamOrgSubmit").val()},
					success:function(data){
						//ลบหน้าที่จำไว้ทั้งหมด
						$(".pageRemember").remove();
						//เพิ่ม element เพื่อระบุว่าปัจจุบันกำลังอยู่หน้า HR
						$("body").append("<input type='hidden' id='pageHr' class='pageRemember' name='pageHr' value='pageHr'>");
						//นำข้อมูลที่ได้มาวางใส่ไว้ที่ element #content1
						$("#content1").append(data);
					}
					
				});
				//AJAX1
	} 
//ฟังก์ชั่นในการเรียกหน้า NPR
	var includeNpr_2 = function(){
		$.ajax({
		url:'npr.jsp',
		type:'get',
		dataType:'html',
		data:{"ParamMonth":$("#ParamMonthSubmit").val(),"ParamYear":$("#ParamYearSubmit").val(),"ParamOrg":$("#ParamOrgSubmit").val()},
		success:function(data){
		//alert("hellodworld");
		$(".pageRemember").remove();
		$("body").append("<input type='hidden' id='pageNpr' class='pageRemember' name='pageNpr' value='pageNpr'>");
		$("#content2").append(data);

		
		$("#buttonDetail").remove();
		//เพิ่มปุ่ม buttonDetail
		$(".ui-tabs-nav").append("<input type='button' style='float:right;  margin-top:3px; '  id='buttonDetail' value='Detail'>");

		}
	});
	} 
	//ดักฟังเหตุการณ์การ CLICK ที่ tab 1
	$("a[href=#content1]").click(function(){
		$("#content1").empty();
		$("#content2").empty();
		$("#buttonDetail").remove();
		includeHr_1();
	});
//ดักฟังเหตุการณ์การ CLICK ที่ tab 2
	$("a[href=#content2]").click(function(){
		$("#content1").empty();
		$("#content2").empty();
		includeNpr_2();

	});

	/*### Function Ajax Management End###*/
	//ดักฟังเหตุการณ์ การ Submit 
		$("form#form_1").submit(function(){
			$("#content1").empty();
			$("#content2").empty();
			$("#contentMain").show();
			$("#tabHr").tabs();
			$(".ui-tabs-panel").css("padding","0px");
						$(".paramSubmit").remove();
						$("body").append("<input type='hidden' value='"+$("#ParamMonth").val()+"' name='ParamMonthSubmit' id='ParamMonthSubmit' class='paramSubmit'> ");
						$("body").append("<input type='hidden' value='"+$("#ParamYear").val()+"' name='ParamYearSubmit' id='ParamYearSubmit' class='paramSubmit'>");
						$("body").append("<input type='hidden' value='"+$("#ParamOrg").val()+"' name='ParamOrgSubmit' id='ParamOrgSubmit' class='paramSubmit'>");
						//ตรวจสอบว่าปัจจุบันกำลังอยู่ที่หน้าใด ถ้ายังไม่ได้กด tab ค่าเริ่มต้นจะเรียก tab1 มาแสดง
						if($("#pageHr").val()){
								$("a[href=#content1]").trigger("click");
						}else if($("#pageNpr").val()){
								$("a[href=#content2]").trigger("click");
						}else{
								$("a[href=#content1]").trigger("click");
						}
				return false;
		});
//สั่งให้เกิดกด submit เมื่อเปิดโปรแกรมครั้งแรก
$("form#form_1").trigger("submit");

	});
	</script>
    </head>
    <body>

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
					<select name="ParamOrg" id="ParamOrg">
						<%out.print(V_Org);%>
					</select>
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
		<!--### Management HR TAB ###-->
			<div id="tabHr"  >
				<ul >
						<li><a href="#content1">HR</a></li>
						<li><a href="#content2">NPR</a></li>
				</ul>
				<div id="content1"></div>
				<div id="content2"></div>
			</div>
<!--### Management HR TAB ###-->
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
	<div id="dialogBox">
	</div>
	<!--------------------------- Details End--------------------------->
	</body>
</html>