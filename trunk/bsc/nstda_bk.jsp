  
<% 

String ParamYear  = request.getParameter("ParamYear");
String ParamMonth  = request.getParameter("ParamMonth");
String ParamOrg  = request.getParameter("ParamOrg");

String titleStr = "";
//out.print("{"+ParamYear+","+ParamMonth+","+ParamOrg+"}");
//out.print('{"0":"nong","1":"nuy","2":"TEST"}');
//out.print(ParamOrg);

//out.print(ParamOrg);
//out.print(ParamOrg.trim());

if(ParamOrg.equals("NSTDA")){
	
	titleStr=" ด้านวิจัยนโยบาย สารสนเทศและการสื่อสารองค์กรได้ 36.42%";

}else if(ParamOrg.equals("BIOTEC")){
	
	titleStr=" ผลการดำเนินงานสะสมของ นายวีระศักดิ์ อุดมกิจเดชา ได้ 47.5%";

}else if(ParamOrg.equals("MTEC")){
	
titleStr=" ผลการดำเนินงานสะสมของ นายทวีศักดิ์ นายวีระศักดิ์ อุดมกิจเดชา 36.42 %  ";


}else if(ParamOrg.equals("NECTEC")){
	
titleStr=" ผลการดำเนินงานสะสมของ นายทวีศักดิ์ นายพันธ์ศักดิ์ ศิริรัชตพงษ์ 36.42 %  ";


}else{
	

titleStr=" ผลการดำเนินงานสะสมของ  นายพันธ์ศักดิ์ ศิริรัชตพงษ์ 36.42 %  ";
//NANOTEC
}

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
	
	width:800px;
	height:200px;
	float:right;
	}
	#contentMain1 #contentR #contentDetail{
	border:2px solid #cccccc;
	padding:20px;
	margin:auto;
	width:500px;
	margin-top:30px;
	height:auto;
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

	var ballRed  = "<div id='ballRed' style='background-color:red; width:25px;height:25px;border-radius:100px; float:left;'>1</div>";
	var ballYellow  = "<div id='ballRed' style='background-color:yellow; width:25px;height:25px;border-radius:100px; float:left;'>2</div>";
	var ballGreen  = "<div id='ballRed' style='background-color:green; width:25px;height:25px;border-radius:100px; float:left;'>3</div>";
	var ballGray  = "<div id='ballRed' style='background-color:#cccccc; width:25px;height:25px;border-radius:100px; float:left;'></div>";

	// TITLE BY JSON START
	/*########## Table Content Start ##########*/
	var $titleJ =[
              {
                  field: "Field1",
				  title:"testtttt",
				   width: 50
              },
              {
                  field: "Field2",
				  width: 200
			 },
              {
                  field: "Field3",
				  width: 60
			 },
              {
                  field: "Field4",
				  width:80
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
                  field: "Field5_2",
				  width: 80
			 },
              {
                  field: "Field6",
				  width: 80
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
				  title:"Baseline",
				  width:82
					
				

			 },
              {
                  field: "Field5_2",
				   title:"Actual",
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
                      Field1: "ST",
					  Field2: "<div class='kpiN'>KS1</div>การลงทุนด้าน ว และ ท ในภาคการผลิต ภาคบริการและภาคการผลิต ภาคบริการและภาคเกษตรกรรม",

                      Field3: " <div id='textR'>1.1</div> ",
					  Field4: "เท่าของการลงทุนปี54",
                      Field5: "<div id='textR'>25</div>",
					  Field5_1:"4,500 (ล้านบาท)",
					  Field5_2:"2,000(ล้านบาท)",
					  Field6: " <div id='textR'>0.44<div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>10.10</div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,5,9,10</span> "
                     
					  
                     
                  },
                  {
                      Field1: "ST ",
					  
					  Field2: "<div class='kpiN'>KS1-A</div>มูลค่าผลกระทบต่อเศรษฐกิจและสังคมของประเทศที่เกิดจากการนำผลงานวิจัยไปใช้ประโยชน์ <a href='File/test.pdf' target='_blank'><button class='k-button'>รายละเอียด</button></a> ",
               
					  Field3: "<div id='textR'>2.4</div> ",
					  Field4: " เท่าของค่าใช้จ่าย",
                      Field5: " <div id='textR'>25</div>",
					  Field5_1:"9,290(ล้านบาท)",
					  Field5_2:"5,4000(ล้านบาท)",
					  Field6: "<div id='textR'>0.58</div>",
                      Field7: " <center><div id='target'><div id='percentage'>24%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					  Field7_1:"<div id='textR'>6.05</div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,5,9,10</span> "
				  },
                  {
                      Field1: "PA&FI ",
					  Field2: "<div class='kpiN'>KS5</div>สัดส่วนรายได้ต่อค่าใช้จ่ายทั้งหมด",
                    
					  Field3: "<div id='textR'>1</div>  ",
					  Field4: "-",
                      Field5: "<div id='textR'> 10</div>",
					  Field5_1:"1.07",
					  Field5_2:"1.13",
					  Field6: "<div id='textR'>1.13 <div>",
                      Field7: "<center><div id='target'><div id='percentage'>113%</div> <div id='score'>"+ballGray+""+ballGray+""+ballGreen+"</div></div></center>",
					  Field7_1:"<div id='textR'>11.30<div>",
					
					  Field9: "  <span class='inlinesparkline'>1,4,4,7,5,9,10</span>"
                  },
                  {
                      Field1: "IM ",
					  Field2: "<div class='kpiN'>KS7</div>สัดส่วนบทบาทความวารสารารนานาชาติต่อคลาการวิจัย ",
                      
					  Field3: "<div id='textR'>40</div>  ",
					  Field4: " ฉบับ/100 คน/ปี",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"36",
					  Field5_2:"4.3",
					  Field6: "<div id='textR'>4.3<div> ",
                      Field7: "<center><div id='target'><div id='percentage'>11%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					   Field7_1:"<div id='textR'>1.61<div>",
					 
					  Field9: " <span class='inlinesparkline'>1,4,4,7,5,9,10</span> "
                  },
                  {
                      Field1: "IM ",
					  Field2: " <div class='kpiN'>KS7-B</div>สัดส่วนทรัพย์สินทางปัญญาต่อบุคคลาการวิจัย",
                      
					  Field3: "<div id='textR'>20</div>  ",
					  Field4: "ฉบับ/100 คน/ปี",
                      Field5: "<div id='textR'>15</div> ",
					  Field5_1:"20",
					  Field5_2:"5",
					  Field6: "<div id='textR'>5<div>",
                      Field7: " <center><div id='target'><div id='percentage'>25%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></cener>",
					  Field7_1:"<div id='textR'>3.75<div>",
					
					  Field9: " <span class='inlinesparkline'>1,4,4,7,5,9,10</span>"
                  },
                  {
                      Field1: "LG ",
					  Field2: "<div class='kpiN'>KS9-A</div> ร้อยละความสำเร็จในการผลักดัน 9 กลยุทธ์ได้ตามแผน",
                      
					  Field3: "<div id='textR'>100</div>  ",
					  Field4: "ร้อยละ ",
                      Field5: "<div id='textR'>10 </div>",
					  Field5_1:"-",
					  Field5_2:"36",
					  Field6: "<div id='textR'>36<div>",
                      Field7: " <center><div id='target'><div id='percentage'>36%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></cener>",
					  Field7_1:"<div id='textR'>3.60</div>",
					  
					  Field9: " <span class='inlinesparkline'>1,4,4,7,5,9,10</span>"
                  }
				  
				  ]; 		
	


	var $dataJ2 =[
                  {
                      Field1: "<b>(BIOTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					 

                      Field3: "<div id='textR'>100</div> ",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"500 (ล้านบาท)",
					  Field6: " <div id='textR'>0.50</div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>8.01	</div>",
					
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
                  {
                      Field1: "<b>(MTEC) </b>Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
				

                      Field3: " <div id='textR'>100</div>",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>10</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'>0.7 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.00</div>",
				
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NANOTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					

                      Field3: "  <div id='textR'>100</div>",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'>0,5 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>7.01</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NECTEC)</b> Lead2 ร้อยละความสำเร็จในการส่งมอบ flagship",
					

                      Field3: " <div id='textR'>100</div> ",
					  Field4: "ร้อบละ",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'>0.6 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.03</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(BIOTEC)</b>Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>100 </div>",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>15</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'>0.7 </div>",
                      Field7: "<center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center>  ",
					 Field7_1:"<div id='textR'>8.04</div>",
					
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(MTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>129</div> ",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>20</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'>0.8</div> ",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.30</div>",
					  
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NANOTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: "<div id='textR'>120</div>  ",
					  Field4: "ล้านบาท",
                      Field5: "<div id='textR'>25</div>",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: " <div id='textR'>0.6</div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.71</div>",
					 
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  },
				   {
                      Field1: "<b>(NECTEC)</b> Lead4 จำนวนรายได้อุดหนุนการวิจัย รับจ้าง/ร่วมวิจัย ลิขสิทธิ์/สิทธิประโยชน์ และบริการเทคนิควิชาการ",
				

                      Field3: " <div id='textR'>120 </div>",
					  Field4: "ล้านบาท",
                      Field5: "25",
					  Field5_1:"1,500 (ล้านบาท)",
					  Field5_2:"800 (ล้านบาท)",
					  Field6: "<div id='textR'> 0.4 </div>",
                      Field7: " <center><div id='target'><div id='percentage'>40%</div> <div id='score'>"+ballRed+""+ballGray+""+ballGray+"</div></div></center> ",
					 Field7_1:"<div id='textR'>7.56</div>",
					  
					  Field9: "<span class='inlinesparkline_sub'>1,4,4,7,5,9,10</span>"
                     
					  
                     
                  }
				  
				  ]; 
	//CONTENT BY JSON END

console.log($dataJ2[0]["Field3"]);

$dataJ2[0]["Field3"];



	$("#grid").kendoGrid({
		
           height: 540,
	      //groupable: true,
          scrollable: true,
          sortable: true,
          pageable: true,
		  detailInit: detailInit,

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
		$('.inlinesparkline').sparkline(); 
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
						// $("tr[data-uid]").css({"background-color":"#d7e4bd"});
						$(".k-alt").css({"background-color":"#dbeef3"});
						/*Content Suffer Suffer Color Row*/

				// REMOVE COLUMN START
			//	$("tr.k-detail-row td.k-hierarchy-cell").remove();
				// REMOVE COLUMN END
			
                } // End Function detailInit

		/*##########Function jQuery  add Deatail  result  End ########*/

		
		//#######################Menagement Tab Start ######################
		/*Remove  numberic  bottom tab*/
		$("ul.k-numeric li span").removeClass();
		$("ul.k-numeric li span").html("");
		/*Remove  numberic  bottom tab*/
		/*Header Bgcolor*/
		$("th.k-header").css({"background-color":"#008EC3  "});
		$(".k-grid-header").css({"background-color":"#008EC3  "});
		/*Header Bgcolor*/
		/*Content Suffer Color Row*/
		//$(".k-master-row").css({"background-color":"#d7e4bd"});
	//	$("tr[data-uid]").css({"background-color":"#99ccff "});
		$(".k-alt").css({"background-color":"#dbeef3"});
		/*Content Suffer Suffer Color Row*/
		/*Footer Bgcolor*/
		$(".k-pager-wrap").css({"background-color":"#008EC3 "});
	
		/*Footer Bgcolor*/
		//#######################Menagement Tab End #######################
	});

	

	</script>


 <!-- Define the HTML table, with rows, columns, and data -->


<div id="contentMain1">
	<div id="contentL">
	<img src="images/chadamas.jpg">
	</div>
	<div id="contentR">
		<div id="contentDetail">
ตัวชี้วัดผลสำเร็จสายงานด้านวิจัยนโยบาย สารสนเทศและสื่อสารองค์กรประจำปีงบประมาณ 2555
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
		  
<!--<th class="k-hierarchy-cell k-header">&nbsp;</th>-->
          <th data-field="Field1" ><center><b>มุมมอง</b></center></th>
		  <th  data-field="Field2"><center><b>ตัวชี้วัด</center></th>
		 
		  <th data-field="Field3"><center><b>เป้าหมาย</b></center></th>
		  <th data-field="Field4"><center><b>หน่วยวัด</b></center></th>
		  <th data-field="Field5"><center><b>น้ำหนัก</b></center></th>
		  <th data-field="Field5_1"><center><b>Baseline</b></center></th>
		  <th data-field="Field5_2"><center><b>Actual</b></center></th>
		  <th data-field="Field6"><center><b>ผลงานสะสม</b></center></th>
		  <th data-field="Field7"><center><b>%เทียบแผน</b></center></th>
		  <th data-field="Field7_1"><center><b>% เฉลี่ย<br>ถ่วงน้ำหนัก</b></center></th>
		  <th data-field="Field9"><center><b> แนวโน้ม</b></center></th>

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
      	  <td></td>
	
      	  <td></td>
</tr>

  </tbody>
 </table>

 </div>

</div>
<br style="clear:both">



	