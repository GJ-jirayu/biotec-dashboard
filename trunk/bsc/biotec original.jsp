<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<% 
String ParamYear  = request.getParameter("ParamYear");
String ParamMonth  = request.getParameter("ParamMonth");
String ParamOrg  = request.getParameter("ParamOrg");
// convert to buddhism Year
Integer YearBY = (java.lang.Integer.parseInt(ParamYear))+543;

String titleStr = "";
if(ParamOrg.equals("NSTDA")){
	titleStr=" ผลการดำเนินงานสะสมของ นายทวีศักดิ์ กออนันตกูล ได้ 36.42 %&nbsp;&nbsp;  ";

}else if(ParamOrg.equals("BIOTEC")){
	titleStr=" ผลการดำเนินงานสะสมของ นายวีระศักดิ์ อุดมกิจเดชา ได้ 47.5%";

}else if(ParamOrg.equals("MTEC")){
titleStr=" ผลการดำเนินงานสะสมของ นายทวีศักดิ์ นายวีระศักดิ์ อุดมกิจเดชา 36.42 %  ";

}else if(ParamOrg.equals("NECTEC")){
titleStr=" ผลสำเร็จศูนย์พันธุวิศวกรรมและเทคโนโลยีชีวภาพได้ 36.42 คะแนน  ";

}else{
titleStr=" ผลสำเร็จศูนย์พันธุวิศวกรรมและเทคโนโลยีชีวภาพได้ 36.42 คะแนน  ";
//NANOTEC
}
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver = "com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";
String center_name="";
Connection conn= null;
Statement st;
ResultSet  rs;

Class.forName(Driver).newInstance();
conn = DriverManager.getConnection(connectionURL,User,Pass);

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
	.inlinesparkline{
	cursor:pointer;
	}
	.inlinesparkline_sub{
	cursor:pointer;
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
	$(document).ready(function(){

	var ballRed  = "<div id='ballRed'  class='ball' style='background-color:#e51e25; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballYellow  = "<div id='ballYellow'  class='ball' style='background-color:yellow; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballGreen  = "<div id='ballGreen'  class='ball' style='background-color:#8fbc01; width:20px;height:20px;border-radius:100px; float:left;'></div>";
	var ballGray  = "<div id='ballGray'  class='ball' style='background-color:#cccccc; width:20px;height:20px;border-radius:100px; float:left;'></div>";

	
	// TITLE BY JSON START
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


var $titleJ2 =[
              {
                  field: "Field1",
				  title:"Testตัวชีวัด",
				   width: 249
              },
              {
                  field: "Field3",
				  title:"เป้าหมาย",
				  width: 62
			 },
              {
                  field: "Field4",
				   title:"หน่วยวัด",
				  width:82
				
			
			 },
              {
                  field: "Field5",
				   title:"น้ำหนัก",
				 width:52
			
			 },
              {
                  field: "Field5_1",
				  title:"ข้อมูลฐาน",
				  width:82
					
				

			 },
             
              {
                  field: "Field6",
				   title:"ผลงานสะสม",
				  width:82
				 
			 },
              {
                  field: "Field7",
				   title:"%เทียบแผน",
				 width:103
				
			 },
              {
                  field: "Field7_1",
				   title:"% เฉลี่ยถ่วงน้ำหนัก",
				 width:83
		
				
			 },
              
              {
                  field: "Field9",
				  title:"แนวโน้ม",
			
				 
			 }];


	// TITLE BY JSON END
	//CONTENT BY JSON START 

//ST/ST/PA&FI/IM/IM/LG
//Lag/Lead:: KS1/KS1-A/KS5/KS7/KS7-B/KS9-A
/*
ตัวชี้วัด::
 การลงทุนด้าน ว และ ท ในภาคการผลิต ภาคบริการและภาคการผลิต ภาคบริการและภาคเกษตรกรรม
/มลูค่าผลกระทบต่อเศรษฐกิจและสังคมของประเทศที่เกิดจากการนำผลงานวิจัยไปใช้ประโยชน์
/สัดส่วนรายได้ต่อค่าใช้จ่ายทั้งหมด
/สัดส่วนบทบาทความวารสารารนานาชาติต่อคลาการวิจัย
/สัดส่วนทรัพย์สินทางปัญญาต่อบุคคลาการวิจัย
/ร้อยละความสำเร็จในการผลักดัน 9 กลยุทธ์ได้ตามแผน
น้ำหนัก:: 25/25/10/15/15/10
*/
//หนวยนับ::เท่าของการลงทุนปี54/เท่าของค่าใช้จ่าย/-/ฉบับ/100คน/ปี/ร้อยละ


	var $dataJ =[
                  {
                    
					  Field2: "<div class='kpiN'>KS1</div>สัดส่วนโครงการ RDDE/TT ที่มีการประเมินผลกระทบจากผลงานวิจัยต่อโครงการ RDD/TT ที่ดำเนินการทั้งหมด",

                      Field3: " <div id='textR'>0.15</div> ",
					  Field4: "-",
                      Field5: "<div id='textR'>25</div>",
					  Field5_1:"4,500 (ล้านบาท)",
				
					  Field6: " <div id='textR'>0.44  <br>2,000 <br>ล้านบาท<div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>10.10</div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,8,9,10</span> "
                     
					  
                     
                  },
                  {
                 
					  Field2: "<div class='kpiN'>KS5</div>ร้อยละความสำเร็จในการขับเคลื่อน Flagship- ผลิตภัณฑ์จากทรัพยากรชีวภาพ เพื่อการถ่ายทอดเชิงพาณิชย์ - เทคโนโลยี สวทช. นำไปเผยแพร่แก่ชุมชน ชึ่งก่อให้เกิดรายได้เพื่ม และเป็นชุมชนต้นแบบให้กับชุมชนอื่นๆ",
                    
					  Field3: "<div id='textR'>100</div>  ",
					  Field4: "ร้อยละ",
                      Field5: "<div id='textR'> 15</div>",
					  Field5_1:"1.07",
				
					  Field6: "<div id='textR'>1.13 <div>",
                      Field7: "<center><div id='target'><div id='percentage'>113%</div> <div id='score'>"+ballGray+""+ballGray+""+ballGreen+"</div></div></center>",
					  Field7_1:"<div id='textR'>11.30<div>",
					
					  Field9: "  <span class='inlinesparkline'>1,4,4,7,8,9,10</span>"
                  },
                  {
                   
					  Field2: "<div class='kpiN'>KS7</div>จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัยลิขสิทิธิ์/สิทธิประโยชน์และบริการเทคนิค/วิชาการ",
                      
					  Field3: "<div id='textR'>100</div>  ",
					  Field4: " ล้านบาท",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"15",
			
					  Field6: "<div id='textR'>4.30<div> ",
                      Field7: "<center><div id='target'><div id='percentage'>11%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					   Field7_1:"<div id='textR'>1.61<div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,8,9,10</span> "
                  },
                  {
                
					  Field2: " <div class='kpiN'>KS7-B</div>สัดส่วนรายได้ ต่อค่าใช้จ่าย(SBBU)",
                      
					  Field3: "<div id='textR'>0.69</div>  ",
					  Field4: "-",
                      Field5: "<div id='textR'>5</div> ",
					  Field5_1:"20",
					 
					  Field6: "<div id='textR'>5.00<div>",
                      Field7: " <center><div id='target'><div id='percentage'>25%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></cener>",
					  Field7_1:"<div id='textR'>3.75<div>",
					
					  Field9: " <span class='inlinesparkline'>1,4,4,7,8,9,10</span>"
                  },
                  {
                
					  Field2: "<div class='kpiN'>KS9-A</div> จัดการระบบการรับงานทุกประเภทโดยใช้ระบบคุณภาพตามมาตรฐาน ISO 9001",
                      
					  Field3: "<div id='textR'>สอดคล้องกับมาตรฐาน ISO 9001</div>  ",
					  Field4: "- ",
                      Field5: "<div id='textR'>10 </div>",
					  Field5_1:"-",
				
					  Field6: "<div id='textR'>36.00<div>",
                      Field7: " <center><div id='target'><div id='percentage'>36%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></cener>",
					  Field7_1:"<div id='textR'>3.60</div>",
					  
					  Field9: " <span class='inlinesparkline'>1,4,4,7,8,9,10</span>"
                  },
					
                  {
                  
					  
					  Field2: "<div class='kpiN'>KS1-A</div>สัดส่วน IC scoreต่อบุคคากรวิจัย</a> ",
               
					  Field3: "<div id='textR'>ไม่ต่ำกว่า 11.5</div> ",
					  Field4: " -",
                      Field5: " <div id='textR'>30</div>",
					  Field5_1:"9,290(ล้านบาท)",
					
					  Field6: "<div id='textR'>0.58</div>",
                      Field7: " <center><div id='target'><div id='percentage'>24%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					  Field7_1:"<div id='textR'>6.05</div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,8,9,10</span> "
				  }
				  
				  ]; 		
	


	var $dataJ2 =[
                  {
                      Field1: "<b>(BIOTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					 

                      Field3: "<div id='textR'>100</div> ",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					
					  Field6: " <div id='textR'>0.50</div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>8.01	</div>",
					
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
                  {
                      Field1: "<b>(MTEC) </b>Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
				

                      Field3: " <div id='textR'>100</div>",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>10</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  
					  Field6: "<div id='textR'>0.7 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.00</div>",
				
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NANOTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					

                      Field3: "  <div id='textR'>100</div>",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  
					  Field6: "<div id='textR'>0,5 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>7.01</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NECTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					

                      Field3: " <div id='textR'>100</div> ",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  
					  Field6: "<div id='textR'>0.6 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.03</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(BIOTEC)</b>Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>100 </div>",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					 
					  Field6: "<div id='textR'>0.7 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.04</div>",
					
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(MTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>129</div> ",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>20</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  
					  Field6: "<div id='textR'>0.8</div> ",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.30</div>",
					  
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NANOTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: "<div id='textR'>120</div>  ",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>25</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					
					  Field6: " <div id='textR'>0.6</div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.71</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NECTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>120 </div>",
					  Field4: "ล้านบาท",
                      Field5: "25",
					  Field5_1:"1,500 (ล้านบาท)",
					 
					  Field6: "<div id='textR'> 0.4 </div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.56</div>",
					  
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,8,9,10</span>"
                     
					  
                     
                  }
				  
				  ]; 
	//CONTENT BY JSON END

//console.log($dataJ2[0]["Field3"]);

$dataJ2[0]["Field3"];



	$("#grid").kendoGrid({
		
           height: 630,
	      //groupable: true,
         // scrollable: true,
          //sortable: true,
         // pageable: true,
		//  detailInit: detailInit,

		/*   dataBound: function() {
                            this.expandRow(this.tbody.find("tr.k-master-row").first());
                        },*/

          columns: $titleJ,
          dataSource: {
              data: $dataJ,
			  pageSize: 10
          }
		
      });



	  /*########## Table Content End ##########*/
			//SET SPARKLINE
		$('.inlinesparkline').sparkline(); 
		$('.inlinebar').sparkline('html', {type: 'bullet',height: '30',width:'200', barColor: 'red'} );
	    $("th.k-header , .k-minus").click(function(){
		//$('.inlinesparkline').sparkline(); 
		//$('.inlinesparkline').sparkline('html',{type:'line',width:'100'}); 

	});


		//#######################Menagement Table Start ######################


		//#######################Menagement Table End #######################

	

	 function detailInit(e) {

							$("<table bgcolor='#f5f5f5'><th></th></talbe>").kendoGrid({
								columns: $titleJ2,
								dataSource: {
								data: $dataJ2,
								pageSize: 8,
								
							}
							}).appendTo(e.detailCell);
			
						 $('.inlinesparkline_sub').sparkline(); 
						 /*Content Suffer Color Row*/
						 $("tr[data-uid]").css({"background-color":"#d7e4bd"});
						$(".k-alt").css({"background-color":"#dafbd1"});
						/*Content Suffer Suffer Color Row*/

				// REMOVE COLUMN START
			//	$("tr.k-detail-row td.k-hierarchy-cell").remove();
				// REMOVE COLUMN END
			
                } // End Function detailInit

		/*##########Function jQuery  add Deatail  result  End ########*/

		
		//#######################Menagement Tab Start ######################
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

		/*### management grid2 Start###*/
		var $title21=[{
			field:"Field21",
			width:100
		},{
			field:"Field22",
			width:200
		}];
		var $data21=[{
			
			Field21:"test21",
			Field22:"test content22"
		},{
			Field21:"2test21",
			Field22:"2test content22"
		}];
/*
		$("#grid2").kendoGrid({
			columns:$title21,
			dataSource:{
			data:$data21,
			pageSize:10
			}
		});
*/
		/*### Management grid2 End###*/
		//#######################Menagement Tab End #######################


	});

	

	</script>


 <!-- Define the HTML table, with rows, columns, and data -->


<div id="contentMain1">
	<div id="contentL">
	<img src="owner_picture/biotec.jpg">
	</div>
	<div id="contentR">
		<div id="contentDetail">
	ตัวชี้วัดผลสำเร็จศูนย์พันธุวิศวกรรมและเทคโนโลยีชีวภาพ<br>ประจำปีงบประมาณ  <%=YearBY%>
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
		  <th data-field="Field9"><center><b> กราฟ<br>ผลงานสะสม</b></center></th>

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
<table id="grid2"  width="100%">
	<thead >
		<tr>
			<th colspan="2"  style="text-align:left;">งานในหน้าที่ที่ใช้ Resource ของหน่วยงาน</th>
		</tr>
		<tr bgcolor="#33CC33">
			<th data-field="Field21" style="text-align:center;">ลำดับ</th>
			<th data-field="Field22" style="text-align:center;">งานที่ได้ร้บมอบมาย</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="text-align:center">1</td>
			<td>เป็นผู้นำในการผลักดันงานระดับ สวทช.<br />
	- ระบบสารสนเทศสนับสนุนการดำเนินงงานเชิงกลยุทธ์ และรองรับการทำงานของพนักงานได้จากทุกหน่วยงานในประเทศที่มีพนักงาน สวทช. ปฎิบัติ</td>

		</tr>

		<tr>
			<td style="text-align:center">2</td>
			<td>
			จัดทำ Business Continuity Plan(BCP) ของ สช.

			</td>

		</tr>

		<tr>
			<td style="text-align:center">3</td>
			<td>ขับเคลื่อน NSTDA Core Values ในเรื่อง S&T Excellence</td>

		</tr>
	</tbody>
</table>


<ol>ผลการดำเนินงานจากงานที่มอบหมาย(สะสม)
	<li>
 เป็นผู้นำในการผลักดันงานระดับ สวทช. <br>
-"ระบบสารสนเทศสนับสนุนการดำเนินงานเชิงกลยุทธ์ และรองรับการทำงานของพนักงานได้จากทุกหน่วยงานในประเทศที่มีพนักงาน สวทช. ปฏิบัติ" รายงานผลการดำเนินงานผ่าน Change A
	</li>
	<li>
จัดทำ Business Continuity Plan(BCP) ของศช.<br><br>
กิจกรรมในไตรมาส 1/2555: ศช. ขอให้ทุกหน่วยงานใน ศช (ฝ่ายวิจัยและฝ่ายสนับสนุน )
นำเนินการสำรวจประเมินผลกระทบความเสียหายที่เกิดจากสถานการณ์ น้ำท่วม และได้มีการทำรายงานสรุปผล และนำเสนอในการประชุมผู้บริหาร ศช. (24 ม.ค. 55)<br><br>

กิจกรรมในไตมาส 2/2555<br>
-ศช. ได้ดำเนินทุกหน่วยงานจัดทำแผนฉุกเฉินของฝ่าย / งาน และนำเสนอต่อผู้บังคับบัญชา ให้แล้วเสร็จภายในไตมาสที่ 2<br>
-ศช. ได้ดำเนินจัดทำแผนความต่อเนื่องทางธุรกิจ (BCP)ในกิจกรรมที่มีความสำเร็จและมีบทบาทต่อภาพรวม
<br>โดยมาบหมายให้มีหน่วยงานที่เป็นแกนหลักของระบบโครงสร้างพื้นฐาน<br>
ได้แก่ งานบริหารอาคารสถานที่งานความปลอดภัย งานบริการเครื่องมื่อวิทยาศาสตร์และฝ่าย MIS รับผิดชอบการจัดทำแผนร่วมงานต่างๆ ในกิจกรรมที่เกี่ยวข้องชึ่งขณะนี้ได้จัดทำ(ร่าง) แล้วเสร็จภายในไตมาส 2/2555 และได้นำเสนอ<br><br>

กจิกรรมในไตรมาส 3-4
ปรับรายละเอียดแผน BCP ที่พร้อมใช้งานได้เมื่อเกิดเหตุการณ์ไม่ปกติ<br><br>

	</li>
	<li>
ขับเคลื่อน NSTDA Core Values ในเรื่อง S&T Excellence<br>
- ผลักดันการสร้างและผลิตงานวิจัยโดยเน้นคุณภาพของงานวิจัยโดยมีการกระตุ้นและสนับสนุนให้มีการตีพิมพ์ผลงานในวารสารวิชาการระดับนานาชาติโดยให้ความสำคัญ
	</li>
</ol>



<br style="clear:both">



	