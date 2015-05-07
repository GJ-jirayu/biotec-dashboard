<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
%>
<%
String ParamYear  = request.getParameter("ParamYear");
String ParamMonth  = request.getParameter("ParamMonth");
String ParamOrg  = "NSTDA";
session.setAttribute( "Year", ParamYear);
session.setAttribute( "Month", ParamMonth);
%>
<%! 
    String getColorBall(int position,String color,int id)
    {
		String ballScoll = "";
               if(position==1){
                       ballScoll+="<div id=visualball style='margin-left:13px'><div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==2){
                       ballScoll+="<div id=visualball style='margin-left:13px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==3){
                       ballScoll+="<div id=visualball style='margin-left:13px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:"+color+"></div></div>";
               }
      return ballScoll;
    }
 %>
<%
//varible manage Decimal 
String  performanceNumber="";
String[] getDecimal;
String decimal1="";
String decimal2="";

String orgScore = "";

//**commented by siam.nak 2013/01/12**
//== Added by Thapanat.sop 2012/11/06		
//if(ParamMonth.equals("12"))
//{	orgScore ="คะแนนรวม 96.09 คะแนน";
//}else{
	Query="CALL sp_owner_wavg_score(";
	Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
	rs = st.executeQuery(Query);
	while(rs.next()){
		String ParamScore =  rs.getString("owner_wavg_score") ;
		orgScore ="คะแนนรวม " + ParamScore +" คะแนน";
	}
//} 	
//== Added by Thapanat.sop 2012/11/06	
//**commented by siam.nak 2013/01/12**
if(orgScore == null || orgScore.equals("")){
	orgScore = "คะแนนรวม 0  คะแนน";
}


//[BEGIN]
//**add filename by siam.nak 2013/01/12**
String orgFile = "";
Query="CALL sp_owner_file(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
if(rs.next()){
	orgFile = rs.getString("owner_filename").trim();
}
//**add filename by siam.nak 2013/01/12**
//[END]


Query="CALL sp_parent_kpi_list(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\")";
rs = st.executeQuery(Query);
String tableFun = "[";
int i=0;

while(rs.next()){
	if(i>0){
		tableFun += ",";
	}

	String perspective_code = rs.getString("krs.perspective_code");
	tableFun += "{Field1: \"";
	tableFun += perspective_code;
	tableFun += "\", ";

	String kpi_code = rs.getString("krs.kpi_code");
	String kpi = rs.getString("kpi") ;
	tableFun += "Field2: \"";
	tableFun += "<div class =kpiN id="+i+">"+kpi_code+"</div>"+kpi;
	out.print("<div class=tootip id="+i+"><b>"+rs.getString("kpi_comment")+"</b></div>");

	//[BEGIN]
	//**add filename by siam.nak 2013/01/13**
	String kpi_file = rs.getString("kpi_filename");
	if(kpi_file == null || kpi_file.equals("")){ kpi_file = ""; }
	else if(kpi_file.trim().length() > 0) kpi_file = " <a href='"+kpi_file+"' target='_blank'><button style='width:40px; height:20px; font-size:10px; display:inline; padding:0px; class='k-button'>File</button></a>";

	String kpi_url = rs.getString("kpi_url");
	if(kpi_url == null || kpi_url.equals("")){ kpi_url = ""; }
	else if(kpi_url.trim().length() > 0) kpi_url = " <a href='"+kpi_url+"' target='_blank'><button style='width:40px; height:20px; font-size:10px; display:inline; padding:0px; class='k-button'>URL</button></a>";
	//**add filename by siam.nak 2013/01/13**
	//[END]

	//=============Get Url with Details Button Start============
	// EDIT at 2013 MAR 06  BY  vasan.m@goingjesse   Solve tag <a>  Problem in IE9 Quirks Mode (equal IE6)  
	String urlpage = rs.getString("url");
	//out.print("["+urlpage+"]WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW") ;
	if(urlpage == null || urlpage.equals(""))
	{
		tableFun +=""+kpi_file+kpi_url;
	}
	else
	{
		//https://app2.biotec.or.th/dw/bsc_csv.asp?ks=KS2&yy=2011&mm=10&
		int CalendarMonth = (Integer.parseInt(ParamMonth)+9)%12;
		if (CalendarMonth==0){ CalendarMonth=12; } 
		String url = request.getContextPath()+"/csv/"+urlpage+"?kpicode="+kpi_code+"&year="+ParamYear+"&month="+ParamMonth;
		tableFun +="<button  style='width:40px; height:20px; font-size:10px; display:inline; padding:0px;' onclick=OpenUrl('"+url+"')>Detail</button>"+kpi_file+kpi_url;
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

	String performance_value = rs.getString("performance_value") ;
	tableFun += "Field6: \"";

	performance_value=performance_value.trim();
	if(performance_value.equals("")){
		performance_value="0";
	}
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
	tableFun += "<div id=textR>"+ performanceNumber +"</div> \",";
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
		tableFun += getColorBall(positionBall,colorCode,(i+1000));
	//	out.print(getColorBall(1,colorCode));
		
			Statement st2;
			ResultSet  rs2;
			String QueryColorRange = "";
			st2 = conn.createStatement();
			QueryColorRange="CALL sp_color_range;";
			rs2 = st2.executeQuery(QueryColorRange);
					out.print("<div class=tootip id="+(i+1000)+">");
				while(rs2.next()){
					out.print(rs2.getString("description")+"<br />");
				}
					out.print("</div>");
	}
	tableFun += "\"";
	tableFun += "}";
	
	//===============GraphLine End=====================
	i++;
}
tableFun += "]";
%>



	<style type="text/css">
		.ball{
       width:20px;
       height:20px;border-radius:100px; 
       float:left;
	}

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
	padding:0px;
	}
	#target #score{
	/*float:right;*/
	width:70px;
	display:block;
	padding:0px;
	text-align:center;
	}
	.content{
	width:100%
	}
	.content #table_content{
	float:left;
	width:645px;
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
	border-radius:3px;
	width:99%;
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
	background:#99ccff ;
	padding:2px;
	display:inline;
	border-radius:5px;
	margin:2px;
	}
			.tootip{
			width:auto;
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
			.buttonKpi{
				width:40px;
				height:20px;
				font-size:10px;
				display:inline;
				padding:0px;
			}
			a{
			text-decoration:none
			}
	</style>
	<script type="text/javascript">
	$(document).ready(function(){

	var ballRed  = "<div id='ballRed' class='ball' style='background-color:#e51e25; color:white;width:17px;height:17px; border-radius:100px; float:left;'></div>";
	var ballYellow  = "<div id='ballYellow' class='ball' style='background-color:yellow; color:white;width:17px;height:17px;float:left;border-radius:100px; border:1px solid #cccccc;'></div>";
	var ballGreen  = "<div id='ballGreen' class='ball' style='background-color:#8fbc01; color:white;width:17px;height:17px; float:left; border-radius:100px;border:1px solid #cccccc;'></div>";
	var ballGray  = "<div id='ballGray' class='ball' style='background-color:#cccccc; width:17px;height:17px;border-radius:100px; float:left;'></div>";

	
	var $titleJ =[
              {
                  field: "Field1",
				   width: 40
              },
              {
                  field: "Field2",
				  width: 180
			 },
              {
                  field: "Field3",
				  width: 50
			 },
              {
                  field: "Field4",
				  width:50
			 },
              {
                  field: "Field5",
				  width: 50
			 },
              {
                  field: "Field5_1",
				  width: 50
			 },
              
              {
                  field: "Field6",
				  width: 50
			 },
              {
                  field: "Field7",
				  width: 100
			 }];


	var $dataJ = <%=tableFun%>;
	var orgScore=  "<%=orgScore%>";

	//**add filename by siam.nak 2013/01/12**
	var orgFile = "<%=orgFile%>";
	if (orgFile.length > 0) orgFile = "<a orgFile='true' href='"+orgFile+"' target='_blank'><button style='width:40px; height:20px; font-size:10px; display:inline; padding:0px;'>File</button></a>";


	//CONTENT BY JSON END

	$("#grid").kendoGrid({
		theme:$(document).data("kendoSkin") || "blueOpal",
         height: 300,
		 scrollable: false,
         pageable: true,
         columns: $titleJ,
         dataSource: {
              data: $dataJ,
			  pageSize: 10
          }
		
      });
	  /*########## Table Content End ##########*/

		/*Header Bgcolor*/
		$("th.k-header").css({"background":"#99ccff "});
		$(".k-grid-header").css({"background":"#99ccff "});
		/*Header Bgcolor*/

		/*Footer Bgcolor*/
		$(".k-pager-wrap").css({"background":"#99ccff"});
		$('.k-pager-wrap').css({"padding":"0px"});
		/*Footer Bgcolor*/
		$(".k-grid td").css({"padding-top":"0px","padding-bottom":"0px"});
		$("ul.k-numeric li span").removeClass();
		$("ul.k-numeric li span").html("");
		$(".k-pager-wrap").html("<div id='right' style='text-align:right; padding-right:20px;'>"+orgFile+"<span style='font-weight:bold';>"+orgScore+"</span></div>" );
		$('.inlinesparkline').sparkline(); 
		$('.inlinebar').sparkline('html', {type: 'bullet',height: '30',width:'200', barColor: 'red'} );
	    $("th.k-header").click(function(){
		$('.inlinesparkline').sparkline(); 

	});
		//set Ball corner
		$(".ball").corner("0px");
	});


	//**add filename by siam.nak 2013/01/12**
	$("a[orgFile=true]").live("click",function(){
		window.open($(this).attr("href"),'orgFile');
	});
	function OpenUrl(url){
		window.open(url,"_blank");
	}
	</script>


 <!-- Define the HTML table, with rows, columns, and data -->

 <div id="table_title">
	
 </div>
 
 <div class="content">
 <div id="table_content">
 <table id="grid">
  <thead>
      <tr color="#99ccff ">
		  
          <th data-field="Field1" ><center>มุมมอง</center></th>
		  <th  data-field="Field2"><center>ตัวชี้วัด</center></th>
		  <th data-field="Field3"><center>เป้าหมาย</center></th>
		  <th data-field="Field4"><center>หน่วยนับ</center></th>
		  <th data-field="Field5"><center>น้ำหนัก</center></th>
		  <th data-field="Field5_1"><center>ข้อมูลฐาน</center></th>
		  <th data-field="Field6"><center>ผลงานสะสม</center></th>
		  <th data-field="Field7"><center>%เทียบเป้าหมาย</center></th>

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
	</tr>
  </tbody>
 </table>
 </div>
</div>



	