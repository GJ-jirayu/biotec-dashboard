<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<!doctype html>
 <html>
    <head>
        <title>Budgeting Dashboard</title>
		<!-- load stylesheet from external-->
		<link href="budget.css" rel="stylesheet" type="text/css">
		<link href="../styles/kendo.common.min.css" rel="stylesheet">
		<link href="../styles/kendo.default.min.css" rel="stylesheet">
		<link href="../jqueryUI/css/cupertino/jquery-ui-1.8.21.custom.css" rel="stylesheet">
		 <link href="../styles/kendo.dataviz.min.css" rel="stylesheet">
		<!-- load javascript from external-->
        <script src="../js/jquery.min.js"></script>
		<script src="../js/kendo.all.min.js"></script>
		  <script src="../js/kendo.dataviz.min.js"></script>
		<script type="text/javascript" src="../jqueryUI/js/jquery-ui-1.8.21.custom.min.js"></script>
		<!-- stylesheet embed -->
		<style type="text/css">
			html,
			*{
			font-family:Tahoma;
			}
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
			#barChart1{
			top:-30px;
			}
			#titleTXT{
			position:relative;
			top:-45px;
			}

			.contentMain{
			display:none;
			width: 960px;
			margin:auto;
			}
			#tabs{
			display:none;
			width: 960px;
			margin:auto;
			
			}
			
		</style>
		<style scoped>
				#Main-Panel{
					margin:0px;
					margin-bottom:2px;
					padding: 3px;
					border: 1px solid #dedede;
					-webkit-border-radius: 5px;
					-moz-border-radius: 5px;
					border-radius: 5px;
					text-align: left;
					width:960px;
					position: relative;
					font-weight:bold;
					color:white;
					background-color:#008EC3 ;
				}
			</style>
	<%
String center_name="";
		/*------------------- Set Variable -------------------*/
		String ParamYear = "";
		String ParamMonth = "";
		String ParamOrg = "";

		String V_Year = ""; // Values of Parameter Organization
		String V_Month = ""; // Values of Parameter Sales Region
		String V_Org = ""; // Values of Parameter Branch
		int i = 0;

		/*------------------- End Set Variable -------------------*/

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
			//out.println("cMonth= "+cMonth+"<br>");
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
		//		------------------- End Parameter Year & Month -------------------*/
	
		//====================select1 query ============================
		String select1 ="";//"<option value=\"ALL\" >สวทช</option><option value=\"BIOTEC\" >ศช.</option>";

		Query="CALL sp_program_group;";
		rs = st.executeQuery(Query);
		i = 0;
		while(rs.next()){
			if(i==0){
				select1 += "<option value="+rs.getString("pg_code")+" selected='selected'>"+rs.getString("pg_name")+"</option>";
			}else{
				select1 += "<option value="+rs.getString("pg_code")+">"+rs.getString("pg_name")+"</option>";
			}
			i++;
		}

		String select2 ="";// "<option value=\"Food\" id=\"select21\">คลัสเตอร์อาหารและการเกษตร</option><option value=\"Uranium\" id=\"select22\">ยูเรเนียม</option>";

		///////////////===================================== Select2 Query ============================

		Query="select distinct cluster from dim_project_io_cctr where budget_type = 'project'  and grp_cluster = '01-Cluster' order by cluster";
		rs = st.executeQuery(Query);
		i = 0;
		while(rs.next()){
			if(i==0){
				select2 += "<option value="+rs.getString("cluster")+" selected='selected'>"+rs.getString("cluster")+"</option>";
			}else{
				select2 += "<option value="+rs.getString("cluster")+">"+rs.getString("cluster")+"</option>";
			}
			i++;
		}




	%>

	<script type="text/javascript">
//===================================== Function to add comma in decimal
//ฟังก์ชันจัดการใส่ commas
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
//==========================================end=====================

		var conURL = "<%=connectionURL%>";
		var pw = "<%=Pass%>";
		var ParamYear = "<%=ParamYear%>";
		var ParamMonth = "<%=ParamMonth%>";
		//var ParamOrg = "<%=ParamOrg%>";
		//ฟังก์ชันจัดการดึงค่า getParamจากการเหตุการณ์ "Chang" ใน tag <select>
		function getParamYear(value)
		{
			ParamYear = value;
		}

		function getParamMonth(value)
		{
			ParamMonth = value;
		}

		function getParamOrg(value)
		{
			ParamOrg = value;
		}

	$(document).ready(function(){
		
		/*#### Management by hidden value is no data ####*/
		
		//ซ่อนค่าที่มี Content ที่เท่ากับ "No data" ถ้ามีข้อมูลให้ทำการแสดงผลออกมา ของ Tab1
		//Table1
		var HiddenValueIsNull = function(){
			if($(".namePro111").text()=="No data"){
			$(".namePro111").parent().parent().parent().hide();
			}else{
			$(".namePro111").parent().parent().parent().show();
			}
			if($(".namePro112").text()=="No data"){
			$(".namePro112").parent().parent().parent().hide();
			}else{
			$(".namePro112").parent().parent().parent().show();
			}
			if($(".namePro113").text()=="No data"){
			$(".namePro113").parent().parent().parent().hide();
			}else{
			$(".namePro113").parent().parent().parent().show();
			}
			if($(".namePro114").text()=="No data"){
			$(".namePro114").parent().parent().parent().hide();
			}else{
			$(".namePro114").parent().parent().parent().show();
			}
			if($(".namePro115").text()=="No data"){
			$(".namePro115").parent().parent().parent().hide();
			}else{
			$(".namePro115").parent().parent().parent().show();
			}
			if($(".namePro116").text()=="No data"){
			$(".namePro116").parent().parent().parent().hide();
			}else{
			$(".namePro116").parent().parent().parent().show();
			}
			if($(".namePro117").text()=="No data"){
			$(".namePro117").parent().parent().parent().hide();
			}else{
			$(".namePro117").parent().parent().parent().show();
			}
			if($(".namePro118").text()=="No data"){
			$(".namePro118").parent().parent().parent().hide();
			}else{
			$(".namePro118").parent().parent().parent().show();
			}
			if($(".namePro119").text()=="No data"){
			$(".namePro119").parent().parent().parent().hide();
			}else{
			$(".namePro119").parent().parent().parent().show();
			}
			if($(".namePro1110").text()=="No data"){
			$(".namePro1110").parent().parent().parent().hide();
			}else{
			$(".namePro1110").parent().parent().parent().show();
			}
			

			//table2 
			if($(".namePro121").text()=="No data"){
			$(".namePro121").parent().parent().parent().hide();
			}else{
			$(".namePro121").parent().parent().parent().show();
			}
			if($(".namePro122").text()=="No data"){
			$(".namePro122").parent().parent().parent().hide();
			}else{
			$(".namePro122").parent().parent().parent().show();
			}
			if($(".namePro123").text()=="No data"){
			$(".namePro123").parent().parent().parent().hide();
			}else{
			$(".namePro123").parent().parent().parent().show();
			}
			if($(".namePro124").text()=="No data"){
			$(".namePro124").parent().parent().parent().hide();
			}else{
			$(".namePro124").parent().parent().parent().show();
			}
			if($(".namePro125").text()=="No data"){
			$(".namePro125").parent().parent().parent().hide();
			}else{
			$(".namePro125").parent().parent().parent().show();
			}
			if($(".namePro126").text()=="No data"){
			$(".namePro126").parent().parent().parent().hide();
			}else{
			$(".namePro126").parent().parent().parent().show();
			}
			if($(".namePro127").text()=="No data"){
			$(".namePro127").parent().parent().parent().hide();
			}else{
			$(".namePro127").parent().parent().parent().show();
			}
			if($(".namePro128").text()=="No data"){
			$(".namePro128").parent().parent().parent().hide();
			}else{
			$(".namePro128").parent().parent().parent().show();
			}
			if($(".namePro129").text()=="No data"){
			$(".namePro129").parent().parent().parent().hide();
			}else{
			$(".namePro129").parent().parent().parent().show();
			}
			if($(".namePro1210").text()=="No data"){
			$(".namePro1210").parent().parent().parent().hide();
			}else{
			$(".namePro1210").parent().parent().parent().show();
			}
		}
		//ซ่อนค่าที่มี Content ที่เท่ากับ "No data" ถ้ามีข้อมูลให้ทำการแสดงผลออกมา ของ Tab2
		var HiddenValueIsNull2 = function(){
			//Table1
			if($(".namePro211").text()=="No data"){
			$(".namePro211").parent().parent().parent().hide();
			}else{
			$(".namePro211").parent().parent().parent().show();
			}
			if($(".namePro212").text()=="No data"){
			$(".namePro212").parent().parent().parent().hide();
			}else{
			$(".namePro212").parent().parent().parent().show();
			}
			if($(".namePro213").text()=="No data"){
			$(".namePro213").parent().parent().parent().hide();
			}else{
			$(".namePro213").parent().parent().parent().show();
			}
			if($(".namePro214").text()=="No data"){
			$(".namePro214").parent().parent().parent().hide();
			}else{
			$(".namePro214").parent().parent().parent().show();
			}
			if($(".namePro215").text()=="No data"){
			$(".namePro215").parent().parent().parent().hide();
			}else{
			$(".namePro215").parent().parent().parent().show();
			}
			if($(".namePro216").text()=="No data"){
			$(".namePro216").parent().parent().parent().hide();
			}else{
			$(".namePro216").parent().parent().parent().show();
			}
			if($(".namePro217").text()=="No data"){
			$(".namePro217").parent().parent().parent().hide();
			}else{
			$(".namePro217").parent().parent().parent().show();
			}
			if($(".namePro218").text()=="No data"){
			$(".namePro218").parent().parent().parent().hide();
			}else{
			$(".namePro218").parent().parent().parent().show();
			}
			if($(".namePro219").text()=="No data"){
			$(".namePro219").parent().parent().parent().hide();
			}else{
			$(".namePro219").parent().parent().parent().show();
			}
			if($(".namePro2110").text()=="No data"){
			$(".namePro2110").parent().parent().parent().hide();
			}else{
			$(".namePro2110").parent().parent().parent().show();
			}
			
			//Table2
			if($(".namePro221").text()=="No data"){
			$(".namePro221").parent().parent().parent().hide();
			}else{
			$(".namePro221").parent().parent().parent().show();
			}
			if($(".namePro222").text()=="No data"){
			$(".namePro222").parent().parent().parent().hide();
			}else{
			$(".namePro222").parent().parent().parent().show();
			}
			if($(".namePro223").text()=="No data"){
			$(".namePro223").parent().parent().parent().hide();
			}else{
			$(".namePro223").parent().parent().parent().show();
			}
			if($(".namePro224").text()=="No data"){
			$(".namePro224").parent().parent().parent().hide();
			}else{
			$(".namePro224").parent().parent().parent().show();
			}
			if($(".namePro225").text()=="No data"){
			$(".namePro225").parent().parent().parent().hide();
			}else{
			$(".namePro225").parent().parent().parent().show();
			}
			if($(".namePro226").text()=="No data"){
			$(".namePro226").parent().parent().parent().hide();
			}else{
			$(".namePro226").parent().parent().parent().show();
			}
			if($(".namePro227").text()=="No data"){
			$(".namePro227").parent().parent().parent().hide();
			}else{
			$(".namePro227").parent().parent().parent().show();
			}
			if($(".namePro228").text()=="No data"){
			$(".namePro228").parent().parent().parent().hide();
			}else{
			$(".namePro228").parent().parent().parent().show();
			}
			if($(".namePro229").text()=="No data"){
			$(".namePro229").parent().parent().parent().hide();
			}else{
			$(".namePro229").parent().parent().parent().show();
			}
			if($(".namePro2210").text()=="No data"){
			$(".namePro2210").parent().parent().parent().hide();
			}else{
			$(".namePro2210").parent().parent().parent().show();
			}
		}
		//ซ่อนค่าที่มี Content ที่เท่ากับ "No data" ถ้ามีข้อมูลให้ทำการแสดงผลออกมา Tab3
		var HiddenValueIsNull3 = function(){
			//Table1
			if($(".namePro311").text()=="No data"){
			$(".namePro311").parent().parent().parent().hide();
			}else{
			$(".namePro311").parent().parent().parent().show();
			}
			if($(".namePro312").text()=="No data"){
			$(".namePro312").parent().parent().parent().hide();
			}else{
			$(".namePro312").parent().parent().parent().show();
			}
			if($(".namePro313").text()=="No data"){
			$(".namePro313").parent().parent().parent().hide();
			}else{
			$(".namePro313").parent().parent().parent().show();
			}
			if($(".namePro314").text()=="No data"){
			$(".namePro314").parent().parent().parent().hide();
			}else{
			$(".namePro314").parent().parent().parent().show();
			}
			if($(".namePro315").text()=="No data"){
			$(".namePro315").parent().parent().parent().hide();
			}else{
			$(".namePro315").parent().parent().parent().show();
			}
			if($(".namePro316").text()=="No data"){
			$(".namePro316").parent().parent().parent().hide();
			}else{
			$(".namePro316").parent().parent().parent().show();
			}
			if($(".namePro317").text()=="No data"){
			$(".namePro317").parent().parent().parent().hide();
			}else{
			$(".namePro317").parent().parent().parent().show();
			}
			if($(".namePro318").text()=="No data"){
			$(".namePro318").parent().parent().parent().hide();
			}else{
			$(".namePro318").parent().parent().parent().show();
			}
			if($(".namePro319").text()=="No data"){
			$(".namePro319").parent().parent().parent().hide();
			}else{
			$(".namePro319").parent().parent().parent().show();
			}
			if($(".namePro3110").text()=="No data"){
			$(".namePro3110").parent().parent().parent().hide();
			}else{
			$(".namePro3110").parent().parent().parent().show();
			}

			//Table2
			if($(".namePro321").text()=="No data"){
			$(".namePro321").parent().parent().parent().hide();
			}else{
			$(".namePro321").parent().parent().parent().show();
			}
			if($(".namePro322").text()=="No data"){
			$(".namePro322").parent().parent().parent().hide();
			}else{
			$(".namePro322").parent().parent().parent().show();
			}
			if($(".namePro323").text()=="No data"){
			$(".namePro323").parent().parent().parent().hide();
			}else{
			$(".namePro323").parent().parent().parent().show();
			}
			if($(".namePro324").text()=="No data"){
			$(".namePro324").parent().parent().parent().hide();
			}else{
			$(".namePro324").parent().parent().parent().show();
			}
			if($(".namePro325").text()=="No data"){
			$(".namePro325").parent().parent().parent().hide();
			}else{
			$(".namePro325").parent().parent().parent().show();
			}
			if($(".namePro326").text()=="No data"){
			$(".namePro326").parent().parent().parent().hide();
			}else{
			$(".namePro326").parent().parent().parent().show();
			}
			if($(".namePro327").text()=="No data"){
			$(".namePro327").parent().parent().parent().hide();
			}else{
			$(".namePro327").parent().parent().parent().show();
			}
			if($(".namePro328").text()=="No data"){
			$(".namePro328").parent().parent().parent().hide();
			}else{
			$(".namePro328").parent().parent().parent().show();
			}
			if($(".namePro329").text()=="No data"){
			$(".namePro329").parent().parent().parent().hide();
			}else{
			$(".namePro329").parent().parent().parent().show();
			}
			if($(".namePro3210").text()=="No data"){
			$(".namePro3210").parent().parent().parent().hide();
			}else{
			$(".namePro3210").parent().parent().parent().show();
			}
		}
//ซ่อนค่าที่มี Content ที่เท่ากับ "No data" ถ้ามีข้อมูลให้ทำการแสดงผลออกมา Tab4
		var HiddenValueIsNull4 = function(){
			//Table1
			if($(".namePro411").text()=="No data"){
			$(".namePro411").parent().parent().parent().hide();
			}else{
			$(".namePro411").parent().parent().parent().show();
			}
			if($(".namePro412").text()=="No data"){
			$(".namePro412").parent().parent().parent().hide();
			}else{
			$(".namePro412").parent().parent().parent().show();
			}
			if($(".namePro413").text()=="No data"){
			$(".namePro413").parent().parent().parent().hide();
			}else{
			$(".namePro413").parent().parent().parent().show();
			}
			if($(".namePro414").text()=="No data"){
			$(".namePro414").parent().parent().parent().hide();
			}else{
			$(".namePro414").parent().parent().parent().show();
			}
			if($(".namePro415").text()=="No data"){
			$(".namePro415").parent().parent().parent().hide();
			}else{
			$(".namePro415").parent().parent().parent().show();
			}
			if($(".namePro416").text()=="No data"){
			$(".namePro416").parent().parent().parent().hide();
			}else{
			$(".namePro416").parent().parent().parent().show();
			}
			if($(".namePro417").text()=="No data"){
			$(".namePro417").parent().parent().parent().hide();
			}else{
			$(".namePro417").parent().parent().parent().show();
			}
			if($(".namePro418").text()=="No data"){
			$(".namePro418").parent().parent().parent().hide();
			}else{
			$(".namePro418").parent().parent().parent().show();
			}
			if($(".namePro419").text()=="No data"){
			$(".namePro419").parent().parent().parent().hide();
			}else{
			$(".namePro419").parent().parent().parent().show();
			}
			if($(".namePro4110").text()=="No data"){
			$(".namePro4110").parent().parent().parent().hide();
			}else{
			$(".namePro4110").parent().parent().parent().show();
			}
			

			//Table2
			if($(".namePro421").text()=="No data"){
			$(".namePro421").parent().parent().parent().hide();
			}else{
			$(".namePro421").parent().parent().parent().show();
			}
			if($(".namePro422").text()=="No data"){
			$(".namePro422").parent().parent().parent().hide();
			}else{
			$(".namePro422").parent().parent().parent().show();
			}
			if($(".namePro423").text()=="No data"){
			$(".namePro423").parent().parent().parent().hide();
			}else{
			$(".namePro423").parent().parent().parent().show();
			}
			if($(".namePro424").text()=="No data"){
			$(".namePro424").parent().parent().parent().hide();
			}else{
			$(".namePro124").parent().parent().parent().show();
			}
			if($(".namePro425").text()=="No data"){
			$(".namePro425").parent().parent().parent().hide();
			}else{
			$(".namePro425").parent().parent().parent().show();
			}
			if($(".namePro426").text()=="No data"){
			$(".namePro426").parent().parent().parent().hide();
			}else{
			$(".namePro426").parent().parent().parent().show();
			}
			if($(".namePro427").text()=="No data"){
			$(".namePro427").parent().parent().parent().hide();
			}else{
			$(".namePro427").parent().parent().parent().show();
			}
			if($(".namePro428").text()=="No data"){
			$(".namePro428").parent().parent().parent().hide();
			}else{
			$(".namePro428").parent().parent().parent().show();
			}
			if($(".namePro429").text()=="No data"){
			$(".namePro429").parent().parent().parent().hide();
			}else{
			$(".namePro429").parent().parent().parent().show();
			}
			if($(".namePro4210").text()=="No data"){
			$(".namePro4210").parent().parent().parent().hide();
			}else{
			$(".namePro4210").parent().parent().parent().show();
			}
		}
		/*#### Management by hidden value is no data  end####*/

	  /*#### Loading Start ###*/
		var $width=($('body').width()/2)-50;
		$("#loading").css({"top":"250px","left":$width+"px"}).ajaxStart(function(){
		$(this).show();
		}).ajaxStop(function(){
		$(this).hide();
		});
		/*#### Loading End ###*/

	//ผูกเมธอด kendoDropDownList() ให้<select>เดือน <select>ปี
	  $("#ParamYear").kendoDropDownList();
	  $("#ParamMonth").kendoDropDownList();

 //ผูกเมธอด kendoDropDownList() ให้<select>#select1 <select>#select1
	var dropdownList1 = $("#select1").kendoDropDownList();
	var dropdownList2 =$("#select2").kendoDropDownList();

	/*### jQuery Funtions Start ###*/
	//สั่งทำงานเมื่อเกิดเหตุการณ์ submit
		$("form#form_1").submit(function(){
	//กรณีที่ใช้เมธอด .hide() แทนที่จะเป็น .empty() เนื่องจากเรากำหนด laout 
	//ทั้งหมดไว้หน้าแรกถ้า empty(ลบ)ไปจะทำให้ไม่สามารถแสดงผลได้
				$("#content1").hide();
				$("#content2").hide();
				$("#content3").hide();
				$("#content4").hide();
				$("#content5").hide();
				$("#tabs").show();
				//ลบตัวแปรที่ฝั่งไว้ใน Dom ที่เป็น parameter ที่เลือกไว้ตอน submit เพื่อเก็บค่าใหม่
				$(".paramSubmit").remove();
				//เก็บค่า parameter ฝั่งไว้ใน dom document เพื่อเอาไว้ใช้ตอนเรียก tab
				$("body").append("<input type='hidden' value='"+$("#ParamMonth").val()+"' name='ParamMonthSubmit' id='ParamMonthSubmit' class='paramSubmit'> ");
				$("body").append("<input type='hidden' value='"+$("#ParamYear").val()+"' name='ParamYearSubmit' id='ParamYearSubmit' class='paramSubmit'>");
				//ตรวจสอบว่าปัจจุบันอยู่หน้าอะไร ตอนกด submit ให้ tab แสดงหน้านั้น
				if($("#pageCon1").val()){
						$("a[href=#content1]").trigger("click");
				}else if($("#pageCon2").val()){
						$("a[href=#content2]").trigger("click");
				}else if($("#pageCon3").val()){
						$("a[href=#content3]").trigger("click");
				}else if($("#pageCon4").val()){
						$("a[href=#content4]").trigger("click");
				}else if($("#pageCon5").val()){
						$("a[href=#content5]").trigger("click");
				}else{
						$("a[href=#content1]").trigger("click");
						
				}

	return false;
	});
	//จัดการให้หน้าเริ่มต้นให้ทำการ submit ทันทีที่โหลดเพจ
	$("form#form_1").trigger("submit");
	
	//ดักเหตุการณ์การclick เพื่อเรียกฟังก์ชัน
	$("a[href=#content1]").click(function(){
			includeCon1();
	});

	$("a[href=#content2]").click(function(){
			includeCon2();
	});

		$("a[href=#content3]").click(function(){
			includeCon3();
	});

	$("a[href=#content4]").click(function(){
			includeCon4();
	});

	$("a[href=#content5]").click(function(){
			includeCon5();
	});

	/*### Main Content Start ###*/
	

	/*### Tabs Content Start ###*/
	//ดักเหตุการณ์การchange เพื่อเรียก ajax มาสร้าง Tag <select></select>
		$("#select1").change(function(){
				$.ajax({
				url:"content1.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"pg_code":$(this).val()},
				success:function(data){
					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];
					//เรียกฟังก์ชัน barchart เพื่อสร้าง Bar Chart ใหม่
					barChart1(serie1,category1);
					//เรียกฟังก์ชันจัดการสลับสีของ Table
					colorSufferRow();
						
					$("#contentL .projectHead1").empty();
					//ใส่ text ตัวหัว table
					$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+data[42]["active_category"]);
					$("#contentR .projectHead1").empty();
					//ใส่ content ภายใน table
					$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+data[42]["active_category"]);
					//ตรวจสอบค่าว่างถ้าค่าว่างไม่ต้องแสดง
					HiddenValueIsNull();
					//เรียก ฟังก์ชัน callProgressbar เพื่อสร้าง Progressbar

					//Tab1
					callProgressbar("111",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("112",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("113",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("114",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("115",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("116",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("117",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("118",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("119",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("1110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);

					//Tab2
					callProgressbar("121",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("122",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("123",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("124",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("125",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("126",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("127",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("128",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("129",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("1210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					HiddenValueIsNull();
				}
			});
		});

		$("#select2").change(function(){
				//alert($(this).val());
				$.ajax({
				url:"content2.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"cluster":$(this).val()},
				success:function(data){

					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];

					barChart21(serie1,category1);

					colorSufferRow();
				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+data[42]["active_category"]);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+data[42]["active_category"]);
					
					HiddenValueIsNull2();

					callProgressbar("211",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("212",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("213",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("214",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("215",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("216",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("217",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("218",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("219",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("2110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


					callProgressbar("221",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("222",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("223",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("224",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("225",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("226",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("227",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("228",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("229",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("2210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					
					HiddenValueIsNull2();
				}
			});
		});

//ฟังก์ชันสำหรับเรียก ajax content 1
	var includeCon1 = function(){
		var dropDown = $("#select1").data("kendoDropDownList");
		dropDown.select(0);				
			$.ajax({
				url:"content1.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonthSubmit").val(),"year":$("#ParamYearSubmit").val(),"pg_code":$("#select1").val()},
				success:function(data){
				$("#content1").hide();
				$("#content2").hide();
				$("#content3").hide();
				$("#content4").hide();
				$("#content5").hide();
				//ลบค่าหน้าปัจจุบัน
				$(".pageRemember").remove();
				//add element เพื่อเอาไว้กำหนดหน้าว่าปัจจุบันอยู่กำลังอยู่หน้าไหน
				$("body").append("<input type='hidden' id='pageCon1' class='pageRemember' name='pageCon1' value='pageCon1'>");

					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];
					//เรียกฟังก์ชัน barChart1 ให้ทำงาน
					barChart1(serie1,category1);

				/*### call function sufferRow  Start ###*/
				colorSufferRow();
				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+data[42]["active_category"]);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+data[42]["active_category"]);

				HiddenValueIsNull();

				callProgressbar("111",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
				callProgressbar("112",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
				callProgressbar("113",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
				callProgressbar("114",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
				callProgressbar("115",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
				callProgressbar("116",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
				callProgressbar("117",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
				callProgressbar("118",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
				callProgressbar("119",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
				callProgressbar("1110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


				callProgressbar("121",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
				callProgressbar("122",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
				callProgressbar("123",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
				callProgressbar("124",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
				callProgressbar("125",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
				callProgressbar("126",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
				callProgressbar("127",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
				callProgressbar("128",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
				callProgressbar("129",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
				callProgressbar("1210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);

				/*### call function sufferRow  End ###*/
		
				HiddenValueIsNull();
				$("#content1").fadeIn();
				}
			});
			return false;
	};
	//สั่งให้ทำงานเมื่อโหลดเพจขึ้นครั้งแรก
	includeCon1();
	var includeCon2 = function(){
			var dropDown = $("#select2").data("kendoDropDownList");
			dropDown.select(0);
			$.ajax({
				url:"content2.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"cluster":$("#select2").val()},
				success:function(data){

					$("#content1").hide();
					$("#content2").hide();
					$("#content3").hide();
					$("#content4").hide();
					$("#content5").hide();
					$(".pageRemember").remove();
					$("body").append("<input type='hidden' id='pageCon2' class='pageRemember' name='pageCon2' value='pageCon2'>");

					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];
					barChart21(serie1,category1);		
					colorSufferRow();

					$("#contentL .projectHead1").empty();
					$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+data[42]["active_category"]);
					$("#contentR .projectHead1").empty();
					$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+data[42]["active_category"]);
						
					HiddenValueIsNull2();

					callProgressbar("211",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("212",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("213",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("214",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("215",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("216",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("217",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("218",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("219",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("2110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


					callProgressbar("221",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("222",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("223",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("224",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("225",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("226",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("227",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("228",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("229",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("2210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);

					HiddenValueIsNull2();
					$("#content2").fadeIn();
				
				}
			});
			return false;
	};
	var includeCon3 = function(){
			$.ajax({
				url:"content3.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val()},
				success:function(data){
				HiddenValueIsNull3();
				$("#content1").hide();
				$("#content2").hide();
				$("#content3").hide();
				$("#content4").hide();
				$("#content5").hide();
				$(".pageRemember").remove();
				$("body").append("<input type='hidden' id='pageCon3' class='pageRemember' name='pageCon3' value='pageCon3'>");

					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];
					barChart31(serie1,category1);
					colorSufferRow();

					$("#contentL .projectHead1").empty();
					$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+data[42]["active_category"]);
					$("#contentR .projectHead1").empty();
					$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+data[42]["active_category"]);
					
					HiddenValueIsNull3();
					callProgressbar("311",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("312",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("313",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("314",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("315",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("316",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("317",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("318",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("319",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("3110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);

					callProgressbar("321",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("322",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("323",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("324",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("325",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("326",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("327",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("328",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("329",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("3210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					
					HiddenValueIsNull3();
					$("#content3").fadeIn();
			
				
				}
			});
			return false;
	};
	var includeCon4 = function(){
			$.ajax({
				url:"content4.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val()},
				success:function(data){
			
				$("#content1").hide();
				$("#content2").hide();
				$("#content3").hide();
				$("#content4").hide();
				$("#content5").hide();
				$(".pageRemember").remove();
				$("body").append("<input type='hidden' id='pageCon4' class='pageRemember' name='pageCon4' value='pageCon4'>");

					var serie1 = data[0]["series1"];
					var category1 = data[1]["category1"];
					barChart41(serie1,category1);
					colorSufferRow();
					$("#contentL .projectHead1").empty();
					$("#contentL .projectHead1").append("Top 10 Cost Center Most Spending of "+data[42]["active_category"]);
					$("#contentR .projectHead1").empty();
					$("#contentR .projectHead1").append("Top 10 Cost Center Least Spending of "+data[42]["active_category"]);

					HiddenValueIsNull4(); 
					callProgressbar("411",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("412",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("413",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("414",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("415",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("416",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("417",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("418",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("419",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("4110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);

					callProgressbar("421",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("422",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("423",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("424",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("425",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("426",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("427",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("428",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("429",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("4210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					HiddenValueIsNull4();
					$("#content4").fadeIn();
			
				
				}
			});
			return false;
	};

	var includeCon5 = function(){

			$.ajax({
				url:"content5.jsp",
				type:"get",
				dataType:"json",
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val()},
				success:function(data){
				$("#content1").hide();
				$("#content2").hide();
				$("#content3").hide();
				$("#content4").hide();
				$("#content5").hide();
				$(".pageRemember").remove();
				$("body").append("<input type='hidden' id='pageCon5' class='pageRemember' name='pageCon5' value='pageCon5'>");
				var serie1 = data[0]["series1"];
				var category1 = data[1]["category1"];
				barChart51(category1,serie1);
				var value = data[3]["value_pie"];
				var sum = data[2]["totalPie"];
			    var value_center = data[4]["active_category"];
				pieChart52(value,sum,value_center);
				$("#content5").fadeIn();
				}
			});
			return false;
	};

	
	$("#tabs").tabs();
	/*### Tabs Content End ###*/
    /*### barChart1 Start###*/
	//bar chart ตรง Tab ที่1
var barChart1 = function(seriesParam,categoryParam){
			$("#barChart1").kendoChart({
			theme: $(document).data("kendoSkin") || "metro",
			title: {
				 text: " "
			},
			chartArea: {
			height: 300,
			width:940
			 },
			legend: {
                            position: "right"
            },
			series: seriesParam,
			valueAxis: {
							// ie can not reading font-size
                           title: {text: "งบประมาณ(ล้านบาท)" , font:"14px Tahoma"},
							labels:{
						   font:"11px Tahoma",
						   template: "#= kendo.format('{0:N0}', value ) # "
						   }
                        },

			categoryAxis:{
				labels: {
					//ปรับค่าองศาในการแสดงผลของ legend
                                rotation: -45,
								font:"11px Tahoma"
                            },
			categories: categoryParam
					
			},
                        tooltip: {
                            visible: true,
							template: "#= addCommas(parseFloat(value).toFixed(2))# ล้านบาท"
                        }, seriesClick:funContent1

		});
}


	/*### barChart1 End ###*/
	// เรียกฟังก์ชัน funContent1 เมื่อคลิ๊ก ฺBarChartใน Tab1 เมื่อคลิ๊กแล้วก็จะส่ง parameter e มาเพื่อรับ e.category เสร็จแล้วแล้วส่งเข้าไปใน store procedure
	function funContent1(e){
			var category = e.category;
			$.ajax({
				url:'content1_1.jsp',
				type:'get',
				dataType:'json',
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"pg_code":$("#select1").val(),"spa":category},
				success:function(data){
				colorSufferRow();

				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+category);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+category);
				HiddenValueIsNull(); 
				callProgressbar("111",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
				callProgressbar("112",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
				callProgressbar("113",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
				callProgressbar("114",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
				callProgressbar("115",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
				callProgressbar("116",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
				callProgressbar("117",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
				callProgressbar("118",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
				callProgressbar("119",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
				callProgressbar("1110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


				callProgressbar("121",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
				callProgressbar("122",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
				callProgressbar("123",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
				callProgressbar("124",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
				callProgressbar("125",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
				callProgressbar("126",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
				callProgressbar("127",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
				callProgressbar("128",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
				callProgressbar("129",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
				callProgressbar("1210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
				HiddenValueIsNull(); 

					}
			});
}


	  /*### barChart21 Start###*/
	// barChart Tab2 หน้า2
var barChart21 = function(seriesParam,categoryParam){		
			$("#barChart21").kendoChart({
			theme:$(document).data("kendoSkin") || "metro",
			title: {
				 text: " "
			},
			chartArea: {
			height: 260,
			width:940
			 },
			legend: {
                            position: "right"
            },
			series: seriesParam,
			valueAxis: {
                            title: { text: "งบประมาณ(ล้านบาท)" ,font:"14px Tahoma"},
							labels:{ template: "#= kendo.format('{0:N0}', value ) # "}
                        },

			categoryAxis:{
			categories: categoryParam,
			
			},
                        tooltip: {
                            visible: true,
							template: "#= addCommas(parseFloat(value).toFixed(2))# ล้านบาท"
                        },
							seriesClick:funContent2
		});
}
	/*### barChart21 End ###*/
	//ดักจับ event การคลิ๊กที BarChart ของ Tab2 มาเรียกฟังก์ชัน funContent2 เพื่อเรียก ajax
	function funContent2(e){
			var category = e.category;
			$.ajax({
				url:'content2_1.jsp',
				type:'get',
				dataType:'json',
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"cluster":$("#select2").val(),"spa":category},

				success:function(data){
				colorSufferRow();
				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+category);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+category);
					try{
					HiddenValueIsNull2(); 
					callProgressbar("211",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("212",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("213",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("214",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("215",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("216",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("217",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("218",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("219",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("2110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);

					callProgressbar("221",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("222",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("223",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("224",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("225",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("226",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("227",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("228",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("229",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("2210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					HiddenValueIsNull2(); 
					}
					catch(err)
						{
						//console.log(err);
					}
					
					}
			});
}

	 
	

	/*### barChart31 Start###*/
	//ฺBar Chart ใน Tab3
var barChart31 = function(seriesParam,categoryParam){

			$("#barChart31").kendoChart({
			theme:$(document).data("kendoSkin") || "metro",
			title: {
				 text: " "
			},
			chartArea: {
			height: 260,
			width:940
			 },
			legend: {
                            position: "right"
            },
			series: seriesParam,
			
			valueAxis: {
                            title: { text: "งบประมาณ(ล้านบาท)" ,font:"14px Tahoma"},
							labels:{
							template: "#= kendo.format('{0:N0}', value ) # "
							}
                        },

			categoryAxis:{
			categories: categoryParam,//[ "สก.","ศช.","ศว.","ศอ.","ศจ.","ศน."],
			
			},
                        tooltip: {
                            visible: true,
							template: "#= addCommas(parseFloat(value).toFixed(2))# ล้านบาท"
                        },
						seriesClick:funContent3
		});
}
	/*### barChart31 End ###*/
//click event ใน barChart tab3 
function funContent3(e){
			var center = e.category;
			$.ajax({
				url:'content3_1.jsp',
				type:'get',
				dataType:'json',
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"center":center},

				success:function(data){

				colorSufferRow();
					
				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Project Most Spending of "+center);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Project Least Spending of "+center);
					HiddenValueIsNull3(); 
					callProgressbar("311",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("312",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("313",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("314",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("315",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("316",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("317",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("318",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("319",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("3110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


					callProgressbar("321",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("322",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("323",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("324",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("325",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("326",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("327",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("328",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("329",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("3210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					HiddenValueIsNull3(); 
					
				}
			});
}


	/*### barChart41 Start###*/
var barChart41 = function(seriesParam,categoryParam){
			$("#barChart41").kendoChart({
			theme:$(document).data("kendoSkin") || "metro",
			title: {
				 text: " "
			},
			chartArea: {
			height: 260,
			width:940
			 },
			legend: {
                            position: "right"
            },
			series: seriesParam,
			valueAxis: {
                            title: { text: "งบประมาณ(ล้านบาท)",font:"14px Tahoma" },
							labels:{ template: "#= kendo.format('{0:N0}', value ) # "}
                          /*  min: 0,
                            max: 1200
							*/
                        },

			categoryAxis:{
			categories: categoryParam, // [ "สก.","ศช.","ศว.","ศอ.","ศจ.","ศน."],
			
			},
                        tooltip: {
                            visible: true,
                           // format: "{0} ล้านบาท",
							template: "#= addCommas(parseFloat(value).toFixed(2))# ล้านบาท"
                        },
						seriesClick:funContent4
		});
}

function funContent4(e){
			var center = e.category;
			$.ajax({
				url:'content4_1.jsp',
				type:'get',
				dataType:'json',
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"center":center},

				success:function(data){
					colorSufferRow();
				$("#contentL .projectHead1").empty();
				$("#contentL .projectHead1").append("Top 10 Cost Center Most Spending of "+center);
				$("#contentR .projectHead1").empty();
				$("#contentR .projectHead1").append("Top 10 Cost Center Least Spending of "+center);
					HiddenValueIsNull4(); 
					callProgressbar("411",parseFloat(data[2]["value"]).toFixed(2),data[3]["name"]);
					callProgressbar("412",parseFloat(data[4]["value"]).toFixed(2),data[5]["name"]);
					callProgressbar("413",parseFloat(data[6]["value"]).toFixed(2),data[7]["name"]);
					callProgressbar("414",parseFloat(data[8]["value"]).toFixed(2),data[9]["name"]);
					callProgressbar("415",parseFloat(data[10]["value"]).toFixed(2),data[11]["name"]);
					callProgressbar("416",parseFloat(data[12]["value"]).toFixed(2),data[13]["name"]);
					callProgressbar("417",parseFloat(data[14]["value"]).toFixed(2),data[15]["name"]);
					callProgressbar("418",parseFloat(data[16]["value"]).toFixed(2),data[17]["name"]);
					callProgressbar("419",parseFloat(data[18]["value"]).toFixed(2),data[19]["name"]);
					callProgressbar("4110",parseFloat(data[20]["value"]).toFixed(2),data[21]["name"]);


					callProgressbar("421",parseFloat(data[22]["value"]).toFixed(2),data[23]["name"]);
					callProgressbar("422",parseFloat(data[24]["value"]).toFixed(2),data[25]["name"]);
					callProgressbar("423",parseFloat(data[26]["value"]).toFixed(2),data[27]["name"]);
					callProgressbar("424",parseFloat(data[28]["value"]).toFixed(2),data[29]["name"]);
					callProgressbar("425",parseFloat(data[30]["value"]).toFixed(2),data[31]["name"]);
					callProgressbar("426",parseFloat(data[32]["value"]).toFixed(2),data[33]["name"]);
					callProgressbar("427",parseFloat(data[34]["value"]).toFixed(2),data[35]["name"]);
					callProgressbar("428",parseFloat(data[36]["value"]).toFixed(2),data[37]["name"]);
					callProgressbar("429",parseFloat(data[38]["value"]).toFixed(2),data[39]["name"]);
					callProgressbar("4210",parseFloat(data[40]["value"]).toFixed(2),data[41]["name"]);
					HiddenValueIsNull4(); 
				}
			});
}

	/*### barChart41 End ###*/
	



	/*### barChart51 Start###*/
var barChart51 = function(categoryParam,seriesParam){
			$("#barChart51").kendoChart({	
			theme:$(document).data("kendoSkin") || "metro",
			title: {
				 text: " "
			},
			chartArea: {
			height: 300
			 },
			legend: {
                            position: "right"
            },
			series: seriesParam,
			valueAxis: {
                            title: { text: "งบประมาณ(ล้านบาท)" ,font:"14px Tahoma"},
							labels:{ template: "#= kendo.format('{0:N0}', value ) # "}
                
                        },

			categoryAxis:{
			categories: categoryParam,
			
			},
                        tooltip: {
                            visible: true,
                           // format: "{0} ล้านบาท",
							template: "#= addCommas(parseFloat(value).toFixed(2))# ล้านบาท"
                        },
						seriesClick:funContent5
		});
}
	/*### barChart51 End ###*/

	function funContent5(e){
			var center = e.category;
			$.ajax({
				url:'content5_1.jsp',
				type:'get',
				dataType:'json',
				data:{"month":$("#ParamMonth").val(),"year":$("#ParamYear").val(),"center":center},

				success:function(data){
					var sum = data[0]["totalPie"];
					var value = data[1]["value_pie"];
					//console.log(center);
					//เรียกฟังก์ชัน pieChart52 เพื่อสร้าง pieChart
					pieChart52(value,sum,center);
					}
			});
}

	  /*### barChart52Start###*/

var pieChart52 = function(valueParam,sumParam,center){
	var textIO = "สัดส่วนจำนวน IO ของ "+center;
			$("#pieChart52").kendoChart({
					theme:$(document).data("kendoSkin") || "metro",
					title: {
                            text: textIO,font:"14px Tahoma"
                        },
					
                        legend: {
                            position: "bottom"
                        },
                        chartArea: {
                            background: "",
							height:350
                        },
                        seriesDefaults: {
                            type: "pie"
                        },
                       series: [{
                            type: "pie",
                            data: valueParam
								/*[ {
                                category: "IO ที่ปิดแล้ว ",
                                value: 30
                            }, {
                                category: "IO ที่เหลืออยู่",
                                value: 70
                            }]*/
                        }],
                        valueAxis: {
                            labels: {
								visible: true,
                                format: "{0}%"
                            }
                        },
                        
                        tooltip: {
                            visible: true,
                           // format: "{0}%"
							 template: "#= templateFormat(value,"+sumParam+") #"
                        }
		});
}
	/*### pieChart52 End ###*/

	/*###  jQuery Config Start ###*/
	

	$(".ui-tabs-panel").css("padding","0px");

	/*###  jQuery Config End ###*/


	/*### jQuery Funtions End ###*/

	/*### Manage Table Start###*/
	var colorSufferRow = function(){
		//console.log($("table#top10Tbl"));
		
		$("table#top10Tbl tbody tr:odd").css({"background-color":"#dbeef3"});
		
	}

	/*### Manage Table End###*/

	/*### Set Manage  Progressbar###*/

	var callProgressbar=function($idChart,$value,$namePro){
			//alert($nameProgressbar);
			var bar = "#progressbar"+ $idChart;
			var percent = ".percentage .progressPer" + $idChart;
			var name = ".projectName .namePro" + $idChart;
			var value = parseInt($value) ;
				
			$(percent).empty();
			$(percent).append($value+"%");

			$(name).empty();
			$(name).append($namePro);

			$(bar).progressbar({
			value:value
			});

		$(".ui-corner-left").css({"background":"#008EC3 "});
		$(".value > .ui-corner-all").css("border-radius","0px");
		$(".ui-progressbar-value").css("border-radius","0px");
		$(".ui-progressbar").css("height","10px");
	}
	/*### Set Manage  Progressbar###*/
	});
//ฟังก์ชันจัดการ tooltip
function templateFormat(value,summ) {
   var value1 = addCommas(value.toFixed(2));
   var value2 = ((value/summ)*100).toFixed(2);
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
					<select name="ParamYear" id="ParamYear" onChange="getParamYear(this.value);">
						<%out.print(V_Year);%>
					</select>
					</td>

					<td><label for="ParamMonth">เดือน :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<select name="ParamMonth" id="ParamMonth" onChange="getParamMonth(this.value);">
						<%out.print(V_Month);%>
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


	<div id="contentMain">

<!-- TAB MANAGEMENT START -->
	<div id="tabs">
		<ul>
			<li><a href="#content1">งบโครงการ-แหล่งทุน</a></li>
			<li><a href="#content2">งบโครงการ-แหล่งทุน(คลัสเตอร์)</a></li>
			<li><a href="#content3">งบโครงการ-ผู้ดำเนินการ</a></li>
			<li><a href="#content4">งบหน่วยงาน</a></li>
			<li><a href="#content5">งบครุภัณฑ์-หน่วยงาน</a></li>
		</ul>
		<div id="content1">
						<!--This is Content 1 html =========================================================================-->
<div id="content">
	<div id="row1">
		<div id="column11">
				<div class="head">
						<div class="title">
							<table>
								<tr>
									<td>
									แหล่งทุน :
									</td>
									<td>
									<select id="select1" style="width:250px;">
									<%=select1%>
									</select>

									</td>
								</tr>
							</table>
						</div>
				</div>
				<div class="content">
				
						<div id="barChart1"></div>
						<div id="titleTXT">
							<center><b>แหล่งทุน</b></center><br>
						</div>
				</div>
		</div>
	</div>
	<div  id="row2">
		<div id="column21">
			<div id="row211">
				<div class="head">
					<!--<div class="title">
					
					</div>-->
				</div>
			</div>
			<div id="row212">
				<div class="content">
						<div id="contentL">
						
								<!--<div id="barChart2"></div>
								<div id="barChart12"></div>-->

								<table width="100%" id="top10Tbl" >
									<thead>
										<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Most Spending of </div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project</div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro111"></div></div></td>
											<td>
												<div class="projectValue">
														<div class="percentage">
															<div class="progressPer111">
																
															</div>
														</div>
														<div class="value">
															 <div id="progressbar111"></div>
														</div>
											  </div>
											</td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro112"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer112"></div>		
														</div>
														<div class="value">
															 <div id="progressbar112"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro113"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer113"></div>		
														</div>
														<div class="value">
															 <div id="progressbar113"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro114"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer114"></div>		
														</div>
														<div class="value">
															 <div id="progressbar114"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro115"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer115"></div>	
														</div>
														<div class="value">
															 <div id="progressbar115"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro116"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer116"></div>			
														</div>
														<div class="value">
															 <div id="progressbar116"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro117"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer117"></div>		
														</div>
														<div class="value">
															 <div id="progressbar117"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro118"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer118"></div>									
														</div>
														<div class="value">
															 <div id="progressbar118"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro119"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer119"></div>		
														</div>
														<div class="value">
															 <div id="progressbar119"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro1110"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer1110"></div>	
														</div>
														<div class="value">
															 <div id="progressbar1110"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>


						</div>
						<div id="contentR">
						
	
								<table width="100%" id="top10Tbl" >
									<thead>
									<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Least Spending</div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro121"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer121">
														</div>
														</div>
														<div class="value">
															 <div id="progressbar121"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro122"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer122"></div>									
														</div>
														<div class="value">
															 <div id="progressbar122"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro123"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer123"></div>									
														</div>
														<div class="value">
															 <div id="progressbar123"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro124"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer124"></div>	
														</div>
														<div class="value">
															 <div id="progressbar124"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro125"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer125"></div>
														</div>
														<div class="value">
															 <div id="progressbar125"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro126"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer126"></div>
														</div>
														<div class="value">
															 <div id="progressbar126"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro127"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer127"></div>
														</div>
														<div class="value">
															 <div id="progressbar127"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro128"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer128"></div>
														</div>
														<div class="value">
															 <div id="progressbar128"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro129"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer129"></div>
														</div>
														<div class="value">
															 <div id="progressbar129"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro1210"></div></div></td>
									<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer1210"></div>
														</div>
														<div class="value">
															 <div id="progressbar1210"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>
						</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- END=============================================================================================== -->
		</div>
		<div id="content2">
				<!--This is Content 2 html =========================================================================-->

		<div id="content">
	<div id="row1">
		<div id="column11">
				<div class="head">
						<div class="title">
							<table>
								<tr>
									<td>
									คลัสเตอร์ :
									</td>
									<td>
									<select id="select2"  style="width:300px;">
									<%=select2%>
									</select>
									</td>
								</tr>
							</table>
						</div>
				</div>
				<div class="content">
				
						<div id="barChart21"></div>
						<center><b>โปรแกรม</b></center><br>
				</div>
		</div>
	</div>
	<div  id="row2">
		<div id="column21">
			<div id="row211">
				<div class="head">
					<!--<div class="title">
					โปรแกรม
					</div>-->
				</div>
			</div>
			<div id="row212">
				<div class="content">
									<div id="contentL">
						
								<!--<div id="barChart2"></div>
								<div id="barChart12"></div>-->

								<table width="100%" id="top10Tbl" >
									<thead>
										<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Most Spending of </div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro211"></div></div></td>
											<td>
												<div class="projectValue">
														<div class="percentage">
															<div class="progressPer211">
																
															</div>
														</div>
														<div class="value">
															 <div id="progressbar211"></div>
														</div>
											  </div>
											</td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro212"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer212"></div>		
														</div>
														<div class="value">
															 <div id="progressbar212"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro213"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer213"></div>		
														</div>
														<div class="value">
															 <div id="progressbar213"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro214"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer214"></div>		
														</div>
														<div class="value">
															 <div id="progressbar214"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro215"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer215"></div>	
														</div>
														<div class="value">
															 <div id="progressbar215"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro216"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer216"></div>			
														</div>
														<div class="value">
															 <div id="progressbar216"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro217"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer217"></div>		
														</div>
														<div class="value">
															 <div id="progressbar217"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro218"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer218"></div>									
														</div>
														<div class="value">
															 <div id="progressbar218"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro219"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer219"></div>		
														</div>
														<div class="value">
															 <div id="progressbar219"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro2110"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer2110"></div>	
														</div>
														<div class="value">
															 <div id="progressbar2110"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>


						</div>
						<div id="contentR">
						
							<!--	<div id="barChart3"></div>
								<div id="barChart13"></div>-->
								<table width="100%" id="top10Tbl" >
									<thead>
									<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Least Spending</div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project  </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro221"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer221">
														</div>
														</div>
														<div class="value">
															 <div id="progressbar221"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro222"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer222"></div>									
														</div>
														<div class="value">
															 <div id="progressbar222"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro223"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer223"></div>									
														</div>
														<div class="value">
															 <div id="progressbar223"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro224"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer224"></div>	
														</div>
														<div class="value">
															 <div id="progressbar224"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro225"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer225"></div>
														</div>
														<div class="value">
															 <div id="progressbar225"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro226"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer226"></div>
														</div>
														<div class="value">
															 <div id="progressbar226"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro227"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer227"></div>
														</div>
														<div class="value">
															 <div id="progressbar227"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro228"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer228"></div>
														</div>
														<div class="value">
															 <div id="progressbar228"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro229"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer229"></div>
														</div>
														<div class="value">
															 <div id="progressbar229"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro2210"></div></div></td>
									<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer2210"></div>
														</div>
														<div class="value">
															 <div id="progressbar2210"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>
						</div>


						<!--
						<div id="contentL">
						
								<div id="barChart22"></div>
						</div>
						<div id="contentR">
						
								<div id="barChart23"></div>
						</div>
						-->
				</div>
			</div>
		</div>
	</div>
</div>
<!-- END =======================================================================================-->
		</div>
		<div id="content3">
				<!--This is Content 3 html ==================================================================-->
		<div id="content">
	<div id="row1"  style="height:295px;">
		<div id="column11">
				
				<div class="content">
				
						<div id="barChart31"></div>
						<center><b>ศูนย์</b></center><br>
				</div>
		</div>
	</div>
	<div  id="row2">
		<div id="column21">
			<div id="row211">
				<div class="head">
					<!--<div class="title">
					ศูนย์
					</div>-->
				</div>
			</div>
			<div id="row212">
				<div class="content">
							<div id="contentL">
						
								<!--<div id="barChart2"></div>
								<div id="barChart12"></div>-->

								<table width="100%" id="top10Tbl" >
									<thead>
										<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Most Spending of </div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project  </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro311"></div></div></td>
											<td>
												<div class="projectValue">
														<div class="percentage">
															<div class="progressPer311">
																
															</div>
														</div>
														<div class="value">
															 <div id="progressbar311"></div>
														</div>
											  </div>
											</td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro312"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer312"></div>		
														</div>
														<div class="value">
															 <div id="progressbar312"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro313"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer313"></div>		
														</div>
														<div class="value">
															 <div id="progressbar313"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro314"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer314"></div>		
														</div>
														<div class="value">
															 <div id="progressbar314"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro315"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer315"></div>	
														</div>
														<div class="value">
															 <div id="progressbar315"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro316"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer316"></div>			
														</div>
														<div class="value">
															 <div id="progressbar316"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro317"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer317"></div>		
														</div>
														<div class="value">
															 <div id="progressbar317"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro318"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer318"></div>									
														</div>
														<div class="value">
															 <div id="progressbar318"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro319"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer319"></div>		
														</div>
														<div class="value">
															 <div id="progressbar319"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro3110"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer3110"></div>	
														</div>
														<div class="value">
															 <div id="progressbar3110"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>


						</div>
						<div id="contentR">
						
					
								<table width="100%" id="top10Tbl" >
									<thead>
									<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Project Least Spending</div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Project  </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro321"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer321">
														</div>
														</div>
														<div class="value">
															 <div id="progressbar321"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro322"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer322"></div>									
														</div>
														<div class="value">
															 <div id="progressbar322"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro323"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer323"></div>									
														</div>
														<div class="value">
															 <div id="progressbar323"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro324"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer324"></div>	
														</div>
														<div class="value">
															 <div id="progressbar324"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro325"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer325"></div>
														</div>
														<div class="value">
															 <div id="progressbar325"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro326"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer326"></div>
														</div>
														<div class="value">
															 <div id="progressbar326"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro327"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer327"></div>
														</div>
														<div class="value">
															 <div id="progressbar327"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro328"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer328"></div>
														</div>
														<div class="value">
															 <div id="progressbar328"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro329"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer329"></div>
														</div>
														<div class="value">
															 <div id="progressbar329"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro3210"></div></div></td>
									<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer3210"></div>
														</div>
														<div class="value">
															 <div id="progressbar3210"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>
						</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- END -->
		</div>
		<div id="content4">
				<!--This is Content 4 html -->

		<div id="content">
	<div id="row1"  style="height:295px;">
		<div id="column11">
				<div class="content">
						<div id="barChart41"></div>
						<center><b>ศูนย์</b></center><br>
				</div>
		</div>
	</div>
	<div  id="row2" >
		<div id="column21">
			<div id="row211">
				<div class="head">
				</div>
			</div>
			<div id="row212">
				<div class="content">
							<div id="contentL">
						
								<!--<div id="barChart2"></div>
								<div id="barChart12"></div>-->

								<table width="100%" id="top10Tbl" >
									<thead>
										<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Cost Center Most Spending of </div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Cost Center  </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro411"></div></div></td>
											<td>
												<div class="projectValue">
														<div class="percentage">
															<div class="progressPer411">
																
															</div>
														</div>
														<div class="value">
															 <div id="progressbar411"></div>
														</div>
											  </div>
											</td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro412"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer412"></div>		
														</div>
														<div class="value">
															 <div id="progressbar412"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro413"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer413"></div>		
														</div>
														<div class="value">
															 <div id="progressbar413"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro414"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer414"></div>		
														</div>
														<div class="value">
															 <div id="progressbar414"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro415"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer415"></div>	
														</div>
														<div class="value">
															 <div id="progressbar415"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro416"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer416"></div>			
														</div>
														<div class="value">
															 <div id="progressbar416"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr >
											<td><div class="projectName"><div class="namePro417"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer417"></div>		
														</div>
														<div class="value">
															 <div id="progressbar417"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro418"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer418"></div>									
														</div>
														<div class="value">
															 <div id="progressbar418"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro419"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer419"></div>		
														</div>
														<div class="value">
															 <div id="progressbar419"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr class="RowData">
											<td><div class="projectName"><div class="namePro4110"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer4110"></div>	
														</div>
														<div class="value">
															 <div id="progressbar4110"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>


						</div>
						<div id="contentR">
						

								<table width="100%" id="top10Tbl" >
									<thead>
									<tr id="h1">
												<th colspan="2"><div class="projectHead1">Top 10 Cost Center Least Spending</div></th>
										</tr>
										<tr>
												<th  width="60%"><div class="projectHead">Cost Center </div></th>
												<th  width="40%"><div class="projectHead">% Remaining vs Plan</div></th>
										</tr>
									</thead>
									</tbody>
										<tr>
											<td><div class="projectName"><div class="namePro421"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer421">
														</div>
														</div>
														<div class="value">
															 <div id="progressbar421"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro422"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer422"></div>									
														</div>
														<div class="value">
															 <div id="progressbar422"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro423"></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer423"></div>									
														</div>
														<div class="value">
															 <div id="progressbar423"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro424"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer424"></div>	
														</div>
														<div class="value">
															 <div id="progressbar424"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro425"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer425"></div>
														</div>
														<div class="value">
															 <div id="progressbar425"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro426"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer426"></div>
														</div>
														<div class="value">
															 <div id="progressbar426"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro427"></div></div></td>
											<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer427"></div>
														</div>
														<div class="value">
															 <div id="progressbar427"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro428"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer428"></div>
														</div>
														<div class="value">
															 <div id="progressbar428"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro429"></div></div></td>
										<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer429"></div>
														</div>
														<div class="value">
															 <div id="progressbar429"></div>
														</div>
											  </div>

											  </td>
										</tr>
										<tr>
											<td><div class="projectName"><div class="namePro4210"></div></div></td>
									<td>
											<div class="projectValue">
														<div class="percentage">
														<div class="progressPer4210"></div>
														</div>
														<div class="value">
															 <div id="progressbar4210"></div>
														</div>
											  </div>

											  </td>
										</tr>
									</tbody>
								</table>
						</div>
			
				</div>
			</div>
		</div>
	</div>
</div>
<!-- END -->
		</div>
		<div id="content5">
		<!--This is Content 5 html -->
<div id="content">
	<div id="row1"  style="height:340px;">
		<div id="column11">
				<div class="content"  style="height:340px;" >
						<div id="barChart" style="float:left; width:50%;">
							<div id="barChart51"></div>
						</div>
						<div id="pieChart" style="float:right;width:50%;">
							<div id="pieChart52"></div>
						</div>

						<center><b>ศูนย์</b></center>
				</div>
		</div>
	</div>
	
</div>
<br style="clear:both">
<!-- END -->

		</div>
		<br style="clear:both">
	</div>


<!-- TAB MANAGEMENT END -->

	</div>


	<!--------------------------- Details End--------------------------->
	<!-- element loadding-->
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