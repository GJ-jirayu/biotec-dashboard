<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
%>
<%! 
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

Query="CALL sp_owner_wavg_score(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
while(rs.next()){
	String ParamScore =  rs.getString("owner_wavg_score") ;
	titleStr="ผลสำเร็จ ศูนย์พันธุวิศวกรรมและเทคโนโลยีชีวภาพแห่งชาติได้ " + ParamScore +" คะแนน";
}

String  performanceNumber="";
String[] getDecimal;
String decimal1="";
String decimal2="";

Query="CALL sp_parent_kpi_list(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
String tableFun = "[";
String tootipBody = "";
int i=0;

while(rs.next()){
	if(i>0){
		tableFun += ",";
	}
	String kpi_code = rs.getString("kpi_code");
	String kpi = rs.getString("kpi") ;
	tableFun += "{Field2: \"";
	tableFun += "<div class =kpiN id="+i+" title="+rs.getString("kpi_comment")+">"+kpi_code+"</div>"+kpi;
	out.print("<div class=tootip id="+i+"><b>"+rs.getString("kpi_comment")+"</b></div>");
	//=============Get Url with Details Button Start============
	String urlpage = rs.getString("url");
	if(urlpage == null || urlpage.equals(""))
	{
		tableFun +="";
	}
	else
	{
		tableFun +=" <a href="+urlpage+"?ks="+kpi_code+"&yy="+ParamYear+"&mm="+ParamMonth+" target=_blank><button class=k-button>Detail</button></a> ";
	}
	tableFun += "\", ";
	//=============Get Url with Details Button End============
	String target_value = rs.getString("target_value");
	tableFun += "Field3: \"";
	tableFun += "<div id=textR>"+ target_value +"</div> \",";

	String kpi_uom = rs.getString("kpi_uom");
	tableFun += "Field4: \"";
	tableFun += kpi_uom + "\",";

	String kpi_weighting = rs.getString("kpi_weighting");
	tableFun += "Field5: \"";
	tableFun +=  "<div id=textR>"+kpi_weighting +"</div> \",";

	String baseline = rs.getString("baseline") ;
	tableFun += "Field5_1: \"";
	tableFun += baseline + "\",";

	tableFun += "Field6: \"";

	String performance_value = rs.getString("performance_value") ;
	performance_value=performance_value.trim();
	if(performance_value.equals("")){
		performance_value="0";
	}
	try{
	String performanceStr=numberFormatter.format(Double.parseDouble(performance_value));

	// management Decimal start
	  String addDash=performanceStr.replace(".","-");
	  getDecimal = addDash.split("-");
	  decimal2 =getDecimal[1].substring(1);
	  if(decimal2.equals("0")){
	  decimal2="";
	  }else{
		 decimal2=getDecimal[1].substring(1);
	  }
	   decimal1 =getDecimal[1].substring(0,1);
			if(decimal1.equals("0")){
				decimal1="0";
			}else{
				 decimal1 =getDecimal[1].substring(0,1);
			}
	String numDecimal = decimal1+""+decimal2;
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
	tableFun += "<div id=textR>"+ performance_value +"</div> \",";
//=================================Color Start=========================
	String performance_percentage = rs.getString("performance_percentage");
	Statement st1;
	ResultSet  rs1;
	String QueryColor = "";
	st1 = conn.createStatement();
	QueryColor="CALL sp_color_code(";
	QueryColor += performance_percentage+")";
	rs1 = st1.executeQuery(QueryColor);
	tableFun += "Field7: \"";
	tableFun += "<center><div id='target'><div id='percentage'>" + performance_percentage +"</div></div></center> ";
	while(rs1.next())
	{
		int positionBall =  rs1.getInt("color_order");
		String colorCode = rs1.getString("color_code");
		tableFun += getColorBall(positionBall,colorCode,(i+20000));
		
			Statement st2;
			ResultSet  rs2;
			String QueryColorRange = "";
			st2 = conn.createStatement();
			QueryColorRange="CALL sp_color_range;";
			rs2 = st2.executeQuery(QueryColorRange);
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
	String QueryGraph = "";
	String KpiID= rs.getString("kpi_id");
	QueryGraph = "CALL sp_parent_kpi_trend(";
	QueryGraph += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\","+KpiID+")";
	rs1 = st1.executeQuery(QueryGraph);
	while(rs1.next())
	{
				String value = rs1.getString("value_list");
				tableFun += "<div class=inlinesparkline>"+value+"</div>\"";
				tableFun += "}";
	}
	//===============GraphLine End=====================
	i++;
}
tableFun += "]";


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
	width:70px;
	}
	#target #score{
	width:auto;
	display:block;
	padding:5px;
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
	.ball{
       width:20px;
       height:20px;border-radius:100px; 
       float:left;
	}



	#table_title{
	background:#dafbd1;
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
	z-index:1000;
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
	border:2px solid #DAFBD1;
	padding:20px;
	margin:auto;
	width:600px;
	margin-top:30px;
	height:40px;
	border-radius:10px;
	background-color:#63f763;
	font-size:16px;
	font-weight:bold;
	text-align:center;
	}
/*### Config file   Header End###*/
	</style>
	<script type="text/javascript">
	var ballRed  = "<div id='ballRed'  class='ball' style='background-color:#e51e25; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballYellow  = "<div id='ballYellow'  class='ball' style='background-color:yellow; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballGreen  = "<div id='ballGreen'  class='ball' style='background-color:#8fbc01; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballGray  = "<div id='ballGray'  class='ball' style='background-color:#cccccc; width:20px;height:20px;border-radius:100px; float:left;'></div>";

	/*########## Table Content Start ##########*/
	var $titleJ =[
            
              {
                  field: "Field2",
				  width: 240
			 },
              {
                  field: "Field3",
				  width: 60
			 },
              {
                  field: "Field4",
				  width:60
			 },
              {
                  field: "Field5",
				  width: 50
			 },
              {
                  field: "Field5_1",
				  width: 80
			 },
            
              {
                  field: "Field6",
				  width: 80
			 },
              {
                  field: "Field7",
				  width: 90
			 },
              {
                  field: "Field7_1",
				  width: 80
			 },
              {
                  field: "Field9",
				  width: 80
			 }];



	var $dataJ = <%=tableFun%>;

	$("#grid").kendoGrid({
		
           //height: 630,
          columns: $titleJ,
          dataSource: {
              data: $dataJ,
			  pageSize: 100
          }
		
      });

	  /*########## Table Content End ##########*/
			//SET SPARKLINE
		$('.inlinesparkline').sparkline(); 
		$('.inlinebar').sparkline('html', {type: 'bullet',height: '30',width:'200', barColor: 'red'} );
	    $("th.k-header , .k-minus").click(function(){

	});
		
		//#######################Menagement Tab Start ######################
		/*Remove  numberic  bottom tab*/
		$("ul.k-numeric li span").removeClass();
		$("ul.k-numeric li span").html("");
		/*Remove  numberic  bottom tab*/

		/*Header Bgcolor*/
		$("th.k-header").css({"background":"#33cc33 "});
		$(".k-grid-header").css({"background":"#33cc33 "});
		/*Header Bgcolor*/

		/*Content Suffer Color Row*/
		 $("tr[data-uid]").css({"background":"#d7e4bd"});
		$(".k-alt").css({"background":"#dafbd1"});
		/*Content Suffer Suffer Color Row*/

		/*Footer Bgcolor*/
		$(".k-pager-wrap").css({"background":"#33cc33"});
		/*Footer Bgcolor*/

		//set font white
			$(".k-header").css({"color":"white"});
		//set font white

		//#######################Menagement Tab End #######################
	</script>


 <!-- Define the HTML table, with rows, columns, and data -->


<div id="contentMain1">
	<div id="contentL">
	<img src="owner_picture/biotec.jpg">
	</div>
	<div id="contentR">
		<div id="contentDetail">
	ตัวชี้วัดผลสำเร็จศูนย์พันธุวิศวกรรมและเทคโนโลยีชีวภาพแห่งชาติ<br>ประจำปีงบประมาณ  <%=YearBY%>
		</div>
	</div>
</div>





 <div id="table_title" style="clear:both">
 
	<div id="title">

	<%
	out.print(titleStr);
	%>
<!--<span class="inlinebar">4.5,5,5,5,5,5</span>-->

	</div>
 </div>

 <div class="content">
 <div id="table_content">
 
 <table id="grid">
  <thead>
      <tr>
		  
<!--<th class="k-hierarchy-cell k-header">&nbsp;</th>
          <th data-field="Field1" ><center><b>มุมมอง</b></center></th>-->
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


	//alert("hello wold");
	//console.log($("table#grid2 tbody tr:odd").get());
$("table#grid2 tbody tr td").css("padding","5px");
$("table#grid2 tbody tr:odd").css("background-color","#d7e4bd");
$("table#grid2 tbody tr:even").css("background","#dafbd1");


//set corner object
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
		<tr bgcolor="#33CC33">
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
			out.print(rs.getString("comment").replaceAll("\n","<br>")); 

	
	}
	conn.close();
%>
</div>
<!--<div class="commentKPI"></div>
<br style="clear:both">



	