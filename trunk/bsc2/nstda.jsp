<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
%>
<%! 
//ฟังก์ชั่นจัดการ ball score
    String getColorBall(int position,String color,int id)
    {
		String ballScoll = "";
               if(position==1){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==2){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==3){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:"+color+"></div></div>";
               }
      return ballScoll;
    }
 %>
<% 
String ParamYear  = request.getParameter("ParamYear");
String ParamMonth  = request.getParameter("ParamMonth");
String ParamOrg  = request.getParameter("ParamOrg");
Integer YearBY = (java.lang.Integer.parseInt(ParamYear))+543;
String titleStr = "";
String[] numStrSplit;

Query="CALL sp_owner_wavg_score(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
while(rs.next()){
	String ParamScore =  rs.getString("owner_wavg_score") ;
	titleStr="ผลสำเร็จ สำนักงานพัฒนาวิทยาศาสตร์และเทคโนโลยีแห่งชาติได้ " + ParamScore +" คะแนน";
}
//=================================== DataJ Start===============================================
//varible manage Decimal 
String  performanceNumber="";
String[] getDecimal;
String decimal1="";
String decimal2="";
//เรียก stored procedure เพื่อจัดรูปแบบข้อมูลให้อยู่ในรูป json นำ json ที่ได้เป็นค่าเริ่มต้นของ data grid
Query="CALL sp_parent_kpi_list(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
String tableFun = "[";
int i=0;
while(rs.next()){
	if(i>0)
		{
		tableFun += ",";
	}
	String OwnerID = rs.getString("owner_id") ;
	tableFun += "{Field0: \"";
	tableFun += OwnerID;
	tableFun += "\", ";

	String KpiID= rs.getString("kpi_id");
	tableFun += "Field0_1: \"";
	tableFun += KpiID;
	tableFun += "\", ";


	String perspective_code = rs.getString("krs.perspective_code");
	tableFun += "Field1: \"";
	tableFun += perspective_code;
	tableFun += "\", ";

	String kpi_code = rs.getString("krs.kpi_code");
	String kpi = rs.getString("kpi") ;
	tableFun += "Field2: \"";
	tableFun += "<div class =kpiN id="+i+">"+kpi_code+"</div>"+kpi;
	out.print("<div class=tootip id="+i+"><b>"+rs.getString("kpi_comment")+"</b></div>");
	//=============Get Url with Details Button Start============
	String urlpage = rs.getString("url");
	//ตรวจสอบ result ที่ query มาว่ามีข้อมูลจาด filed url มั้ยถ้ามีให้ทำการสร้าง element  button เพื่อ link ไปเปิดดูเอกสารปลายทาง
	if(urlpage == null || urlpage.equals(""))
	{
		tableFun +="";
	}
	else
	{
		int CalendarMonth = (Integer.parseInt(ParamMonth)+9)%12;
		if(CalendarMonth==0){CalendarMonth=12;}
		tableFun +=" <a href="+urlpage+"?ks="+kpi_code+"&yy="+ParamYear+"&mm="+CalendarMonth+" target=_blank><button class=k-button>Detail</button></a> ";
	}
	tableFun += "\", ";

	//=============Get Url with Details Button End============
	String target_value = rs.getString("target_value");
	tableFun += "Field3: \"";
	tableFun += "<div id=textR>"+ target_value +"</div> \",";

	String kpi_uom = rs.getString("kpi_uom");
	if(kpi_uom == null  ){  
		kpi_uom = ""; 
	}
	tableFun += "Field4: \"";
	tableFun += kpi_uom + "\",";

	String kpi_weighting = rs.getString("kpi_weighting");
	tableFun += "Field5: \"";
	tableFun +=  "<div id=textR>"+kpi_weighting +"</div> \",";

	String baseline = rs.getString("baseline") ;
	tableFun += "Field5_1: \"";
	tableFun += baseline + "\",";

	String performance_value = rs.getString("performance_value") ;
	
	tableFun += "Field6: \"";

	//tableFun += "<div id=textR>"+ performance_value +"</div> \",";
	performance_value=performance_value.trim();
	if(performance_value.equals("")){
		performance_value="0";
	}
	try{
	String performanceStr=numberFormatter.format(Double.parseDouble(performance_value));

	// management Decimal start
	//จัดการกับทศนิยม ถ้ามีทศนิยมมากว่า2ตำแหน่งให้แสดง2 ตำแหน่งถ้ามีทศนิยม1ตำแหน่งให้แสดง1ตำแหน่ง
	  String addDash=performanceStr.replace(".","-");
	  getDecimal = addDash.split("-");
	  //ตรวจสอบทศนิยมตำแหน่งที่2
	  decimal2 =getDecimal[1].substring(1);
	  //ถ้าเป็น 0 ไม่ให้แสดง
	  //ตัวอย่าง 10.10 ให้แสดงเป็น 10.1
	  if(decimal2.equals("0")){
	  decimal2="";
	  }else{
		  //ถ้าไม่ == 0 ให้แสดง
		  //ตัวอย่าง 10.11 ก็ให้แสดงเป็น 10.11
		 decimal2=getDecimal[1].substring(1);
	  }

	  //ตรวจสอบทศนิยมตำแหน่งที่1
	   decimal1 =getDecimal[1].substring(0,1);
			if(decimal1.equals("0")){
				decimal1="0";
			}else{
				 decimal1 =getDecimal[1].substring(0,1);
			}
	String numDecimal = decimal1+""+decimal2;
	//ตรวจสอบทศนิยมทั้งหมด ถ้ามีค่าเป็น 0 ไม่ต้องแสดงทศนิยม
	if(numDecimal.equals("0")){
		  performanceNumber=getDecimal[0];
	}else{
		  performanceNumber=getDecimal[0]+"."+decimal1+""+decimal2;
	}
	// management Decimal end
	performance_value = performanceNumber;
	}catch(NumberFormatException nfe){
		performance_value = performance_value;
	}
	tableFun += "<div id=textR>"+performance_value+"</div> \",";
//=================================Color Start=========================
//จัดการสีของ Ball Score
	String performance_percentage = rs.getString("performance_percentage");
	Statement st1;
	ResultSet  rs1;
	String QueryColor = "";
	st1 = conn.createStatement();
	QueryColor="CALL sp_color_code(";
	//ส่งค่า percentage ไปเพื่อนำไปหาค่าสี
	QueryColor += performance_percentage+")";
	rs1 = st1.executeQuery(QueryColor);
	tableFun += "Field7: \"";
	//ใส่ค่า percentage
	tableFun += "<center><div id='target'><div id='percentage'>" + performance_percentage +"</div></div></center> ";
	while(rs1.next())
	{
		int positionBall =  rs1.getInt("color_order");
		String colorCode = rs1.getString("color_code");
		//เรียกฟังก์ชั่น getColorBall เพื่อ return สีที่ได้จากการส่งค่า percentage
		tableFun += getColorBall(positionBall,colorCode,(i+20000));
	
			Statement st2;
			ResultSet  rs2;
			String QueryColorRange = "";
			st2 = conn.createStatement();
			QueryColorRange="CALL sp_color_range;";
			rs2 = st2.executeQuery(QueryColorRange);
			//ดึงค่าที่บอกรายละเอียด(comment)ของแต่ละสีออกมาเพื่อนำมาแสดงผลกับ tooltip(mouse hover)
					out.print("<div class=commentball id="+(i+20000)+">");
				while(rs2.next()){
					out.print(rs2.getString("description")+"<br />");
				}
					out.print("</div>");
	}

	tableFun += "\",";
	String kpi_wavg_score = rs.getString("kpi_wavg_score");
	tableFun += "Field7_1: \"";
	tableFun += "<div id=textR>"+ kpi_wavg_score +"</div> \",";

	//===============GraphLine Start=====================
	tableFun += "Field9: \"";
	//เรียก stored procedure เพื่อนำค่าสร้าง กราฟ sparkline
	String QueryGraph = "";
	QueryGraph = "CALL sp_parent_kpi_trend(";
	//out.print("KpiID"+KpiID);
	QueryGraph += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\","+KpiID+")";
	rs1 = st1.executeQuery(QueryGraph);
	while(rs1.next())
	{
				String value = rs1.getString("value_list");
				tableFun += "<span class=inlinesparkline>"
								+value
								+"</span>\"";
				tableFun += "}";
	}
	//===============GraphLine End=====================
	i++;
}
tableFun += "]";
//===================== DataJ  END ====================
%>

	<style type="text/css">
	#test{
	color:red;
	font-size:20px;
	font-weight:bold;
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
	.ball{
       width:20px;
       height:20px;border-radius:100px; 
       float:left;
	}
	.content{
	width:100%;
	margin:auto;
	}
	.content #table_content{
	float:left;
	width:100%;
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
	background:#dbeef3 ;
	border-radius:3px;
	width:100%;
	color:black;
	margin:0px;
	}
	#table_title  #title{
	padding:5px;
	font-weight:bold;
	font-size:14px;
	}
	#textR{
	/*background:red;*/
	text-align:right;
	padding-right:5px;
	}
	.kpiN{
	background:#CCCCCC;
	padding:5px;
	display:inline;
	border-radius:5px;
	margin:2px;
	}

				.tootip{
			width:200px;
			height:auto;
			position:absolute;
			z-index:10;
			background:white;
			display:none;
			border-radius:5px;
			border:1px solid #cccccc;
			cursor:pointer;
			padding:5px;
			}
			.commentball{
			width:200px;
			height:auto;
			position:absolute;
			z-index:10;
			background:white;
			display:none;
			border-radius:5px;
			border:1px solid #cccccc;
			cursor:pointer;
			padding:5px;
			}



/*###  Config file Header  Start###*/
#contentMain1{
	
	width:auto;
	height:auto;

	}
	#contentMain1 #contentL{
	
	width:200px;
	height:200px;
	float:left;
	}
	#contentMain1 #contentR{
	

	height:200px;
	float:right;
	}
	#contentMain1 #contentR #contentDetail{
	border:2px solid #cccccc;
	padding:20px;
	margin:auto;
	width:600px;
	margin-top:30px;
	height:40px;
	border-radius:10px;
	background-color:#008EC3 ;
	font-size:16px;
	font-weight:bold;
	text-align:center;
	color:white;
	}
/*### Config file   Header End###*/
	
	</style>

	<script type="text/javascript">
	$(document).ready(function(){

	// TITLE BY JSON START
	//กำหนดค่าเริ่มต้นของชื่อ column เพื่อเอาไว้อ้างอิงกับ datasource
	var $titleJ =[
              {
                  field: "Field1",
				   width: 55
              },
              {
                  field: "Field2",
				  width: 230
			 },
              {
                  field: "Field3",
				  width: 65
			 },
              {
                  field: "Field4",
				  width:80
			 },
              {
                  field: "Field5",
				  width: 55
			 },
              {
                  field: "Field5_1",
				  width: 80
			 },
             
              {
                  field: "Field6",
				  width: 85
			 },
              {
                  field: "Field7",
				  width: 100
			 },
              {
                  field: "Field7_1",
				  width: 80
			 },
              {
                  field: "Field9",
				 // width: 80
			 }];


var $titleJ2 =[
	
              {
                  field: "Field1",
				   width: 277
              },
              {
                  field: "Field3",
				  width:65
				 
			 },
              {
                  field: "Field4",
					 width:80
				
			
			 },
              {
                  field: "Field5",
				 width:55
			
			 },
              {
                  field: "Field5_1",
				 width:80
					
				

			 },
          
              {
                  field: "Field6",
				 width:85
				 
			 },
              {
                  field: "Field7",
				 width:100
				
			 },
              {
                  field: "Field7_1",
				 width:80
		
				
			 },
              
              {
                  field: "Field9",
			
				 
			 }];




	//CONTENT BY JSON START 
	//นำค่าที่ได้มาจากการ query แล้วจัดการให้อยู่ในรูปแบบ json ที่ได้จากด้านบนมาเก็บไว้ในตัวแปร $dataJ
	var $dataJ = <%=tableFun%>;

 /*Management Range mounse over Start*/
var tooltip = function(){
	  $(".kpiN").hover(function(e){
								  var $AX =  e.pageX+10;
								  var $AY = e.pageY+10;
								   var $pos = e.target.id;
								   var classT = ".tootip#"+$pos;
								   var classT_text = $(classT).text();
								   if($.trim(classT_text)!=""){
									$("#tooltip").hide().empty();
								  $("#tooltip").append(classT_text).css({"left":$AX+"px","top":$AY+"px"}).fadeIn();
								   }
							  },function(){
								  $("#tooltip").hide();			 
		  });
}
var ballScore = function(){

	  $(".ball").hover(function(e){
								  var $AX =  e.pageX+10;
								  var $AY = e.pageY+10;
								   var $pos = e.target.id;
								   var $classB = ".commentball#"+$pos;
								   var classB_html = $($classB).html();
								   if($.trim(classB_html)!=""){
								$("#tooltip").hide().empty();
								  $("#tooltip").append(classB_html).css({"left":$AX+"px","top":$AY+"px"}).fadeIn();
								   }
							  },function(){
								  $("#tooltip").hide().empty();
								 
		  });

}
	 /*Management Range mounse over End*/



	$("#grid").kendoGrid({
		   //ไม่กำหนดความสูง height จะเป็น auto
           //height: 500,
		  detailInit: detailInit,
          columns: $titleJ,//[{"filed":"Filed1",width:100},{"filed":"Filed2","width":200}]
          dataSource: {
              data: $dataJ,//[{"Filed1":"content1"},{"Filed2":"content2"}]
			// pageSize: 3,
			
          },
			  /*sortable: true,
                        pageable: {
                           refresh: true,
                           pageSizes: true
                 },*/
		
      });
	  /*########## Table Content End ##########*/
			//SET SPARKLINE
		$('.inlinesparkline').sparkline(); 
		$('.inlinebar').sparkline('html', {type: 'bullet',height: '30',width:'200', barColor: 'red'} );

	 function detailInit(e) {
		 $.ajax({
		 url:'nstdalv1.jsp',
		 type:'get',
		dataType:'html',
		data:{'year':<%=ParamYear%>,'month':<%=ParamMonth%>,'name':"<%=ParamOrg%>",'owner_id':e.data.Field0,'kpi_id':e.data.Field0_1},
		success:function(data){
							var tableFun2 = eval("(" + data + ")");
							$("<table bgcolor='#f5f5f5'><th></th></table>").kendoGrid({
								columns: $titleJ2,
								dataSource: {
								data: tableFun2,
								pageSize: 100,
							}
							}).appendTo(e.detailCell);
							$('.inlinesparkline_sub').sparkline(); 
							/*### Manage Tootip Start###*/
							tooltip();
							ballScore();
							/*### Manage Tootip Stop###*/
							//set corner object
						$(".ball").corner();
							
			 }
	 });
						 
						 /*Content Suffer Color Row*/
						$(".k-alt").css({"background-color":"#dbeef3"});
						/*Content Suffer Suffer Color Row*/
						

				// REMOVE COLUMN START
			//	$("tr.k-detail-row td.k-hierarchy-cell").remove();
				// REMOVE COLUMN END
			
                } // End Function detailInit
	
		/*##########Function jQuery  add Deatail  result  End ########*/

		
		//#######################Menagement Tab Start ######################

		/*Header Bgcolor*/
		$("th.k-header").css({"background":"#008EC3  "});
		$(".k-grid-header").css({"background":"#008EC3  "});
		//set font white
			$(".k-header").css({"color":"white"});
			$(".k-link").css({"color":"white"});
			
		
		/*Header Bgcolor*/
		/*Content Suffer Color Row*/
		$(".k-alt").css({"background":"#dbeef3"});
		/*Content Suffer Suffer Color Row*/
		/*Footer Bgcolor*/
		$(".k-pager-wrap").css({"background":"#008EC3 "});
		/*Footer Bgcolor*/
		//#######################Menagement Tab End #######################
		//set corner object
		$(".ball").corner();
	});
	</script>
 <!-- Define the HTML table, with rows, columns, and data -->
<div id="contentMain1">
	<div id="contentL">
	<img src="owner_picture/nstda.jpg">
	</div>
	<div id="contentR">
		<div id="contentDetail">
		<center>
ตัวชี้วัดผลสำเร็จสำนักงานพัฒนาวิทยาศาสตร์และเทคโนโลยีแห่งชาติ<br>
ประจำปีงบประมาณ <%=YearBY%> 
		</center>
		</div>
	</div>
</div>
 <div id="table_title" style="clear:both">
 
	<div id="title">

	<%
	out.print(titleStr);
	%>
	</div>
 </div>

 <div class="content">
 <div id="table_content">
 
 <table id="grid">
  <thead>
      <tr>
		  
          <th data-field="Field1" ><center><b>มุมมอง</b></center></th>
		  <th  data-field="Field2"><center><b>ตัวชี้วัด</center></th>
		  <th data-field="Field3"><center><b>เป้าหมาย</b></center></th>
		  <th data-field="Field4"><center><b>หน่วยนับ</b></center></th>
		  <th data-field="Field5"><center><b>น้ำหนัก</b></center></th>
		  <th data-field="Field5_1"><center><b>ข้อมูลฐาน</b></center></th>
		  <th data-field="Field6"><center><b>ผลงานสะสม</b></center></th>
		  <th data-field="Field7"><center><b>% เทียบ<br>เป้าหมาย</b></center></th>
		  <th data-field="Field7_1"><center><b>คะแนน<br>ถ่วงน้ำหนัก </b></center></th>
		  <th data-field="Field9"><center><b> กราฟคะแนน<br>ถ่วงน้ำหนัก</b></center></th>

	  </tr>
  </thead>
  <tbody>
      <tr>
          <td></td>
          <td></td>
		  <td></td>
          <td></td>
		  <td></td>
          <td></td>
		  <td></td>
          <td></td>
		  <td></td>
      	  <td></td>
	

</tr>

  </tbody>
 </table>

 </div>

</div>


<style>
	table#grid2 thead th{
	padding:5px;
	}
	table#grid2 thead tr th{
		text-align:left;
	}
	ol {
	font-weight:bold;
	}
	ol li{
	font-weight:normal;
	}
</style>
<script type="text/javascript">
$(document).ready(function(){
//จัดการตกแต่งตาราง
$("table#grid2 tbody tr td").css("padding","5px");
$("table#grid2 tbody tr:odd").css("background-color","#DBEEF3");
$("table#grid2 tbody tr:even").css("background","white");
//set corner object
//ให้คลาสที่ระบุเป็นวงกลม
$(".ball").corner();
});
</script>
<p>
</p>
 <div id="table_title" style="clear:both">
	<div id="title">
งานในหน้าที่ ที่ใช้ Resource ของหน่วยงาน
<!--<span class="inlinebar">4.5,5,5,5,5,5</span>-->
	</div>
 </div>

<table id="grid2"  width="100%">
	<thead >
		<tr bgcolor="#008EC3">
			<th data-field="Field21" style="text-align:center;color:white;">ลำดับ</th>
			<th data-field="Field22" style="text-align:center;color:white;">งานที่ได้รับมอบหมาย</th>
		</tr>
	</thead>
	<tbody>
	<%
	
	Query="CALL sp_owner_assignment(";
	Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
	rs = st.executeQuery(Query);
	while(rs.next()){
%>
		<tr>
			<td style="text-align:center"><%=rs.getString("assign_order")%></td> 
			<td><%=rs.getString("assign_desc")%></td>
		</tr>
<%}%>
	</tbody>
</table>
<div style="padding:5px;">
<b>ผลการดำเนินงานที่มอบหมาย(สะสม)</b>
</div>
<div style="padding:10px;">
<%
	Query="CALL sp_owner_comment(";
	Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
	rs = st.executeQuery(Query);
	while(rs.next()){
			//ใช้ replaceAll ค้นหาข้อมูลมี่ \n เจอแล้วเขียนทับให้เป็นค่า<br> ไม่งั้นโปรแกรมจะerror เมื่อ เจอ \n
			out.print(rs.getString("comment").replaceAll("\n","<br>")); 
	}
	conn.close();
%>
</div>
<br style="clear:both">



	