<!-- Tab4 -->
<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
	String paramYear= request.getParameter("paramYear");
	String paramMonth= request.getParameter("paramMonth");
	String paramOrg=request.getParameter("paramOrg");



	String dataDefault="";
	Query="CALL sp_profit_and_loss_list_per_level("+paramYear+","+paramMonth+",2,null);";
	rs=st.executeQuery(Query);

	Integer i=0;
	String[] amount_list_array;
	String amount_list="";
	String[] area_array;
	String area_list="";

	dataDefault+="[";
	while(rs.next()){
		if(i==0){
		//header
		area_array=rs.getString("area_list").split(",");
		int h=2;
		for(int p=0; p < area_array.length;p++){
		area_list+="<th data-field=\"Field"+h+"\"><center><div class=\"fontTitle\">"+area_array[p]+"</div></center></th>";
		h++;
		}
		// end header
		dataDefault+="{" ;
		dataDefault+="account_key:"+rs.getString("account_key")+",";
		dataDefault+="Field1:\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		
		//Loop for get value amount_list
		amount_list=rs.getString("amount_list");
		amount_list_array = amount_list.split(",");

		int j=2;
		Double amount_sum=0.0;
		Double amount_by_center=0.0;
		for(int l=0; l<amount_list_array.length; l++ ){
			
				amount_by_center=Double.parseDouble(amount_list_array[l]);
				dataDefault+="Field"+j+":\"<div class='textR'>"+numberFormatter.format(amount_by_center)+"</div>\",";
				amount_sum+=Double.parseDouble(amount_list_array[l]);
		j++;
		}
		//Loop for get value amount_list 
		dataDefault+="Field9:\"<div class='textR'>"+numberFormatter.format(amount_sum)+"</div>\"";
		dataDefault+="}" ;
		}else{
		dataDefault+=",{" ;
		dataDefault+="account_key:"+rs.getString("account_key")+",";
		dataDefault+="Field1:\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";

		//Loop for get value amount_list 
		amount_list=rs.getString("amount_list");
		amount_list_array = amount_list.split(",");
		int k=2;
		Double amount_sum=0.0;
		Double amount_by_center=0.0;

		for(int m=0; m<amount_list_array.length;m++ ){
				amount_by_center=Double.parseDouble(amount_list_array[m]);
				dataDefault+="Field"+k+":\"<div class='textR'>"+numberFormatter.format(amount_by_center)+"</div>\",";
				amount_sum+=Double.parseDouble(amount_list_array[m]);
		k++;
		}
		//Loop for get value amount_list 
		//(amount_list_array.length)+1)
		dataDefault+="Field9:\"<div class='textR'>"+numberFormatter.format(amount_sum)+"</div>\"";
		dataDefault+="}" ;
		}//if
i++;
}//while
dataDefault+="]";
//out.print("dataDefault"+dataDefault);
%>
	<style type="text/css">
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
	}
	.content #table_content{
	float:left;
	width:100%
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
	.textR{
	/*background:red;*/
	text-align:right;
	padding-right:0px;
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
	width:100%;
	height:385px;
	float:left;
	}
	.boxContent #boxR{
	width:25%;
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
	.fontTitle{
	color:white;
	font-weight:bold;
	}
	.level8{
	padding-left:35px;
	}
	</style>
	<script type="text/javascript">
	$(document).ready(function(){
	var setFont = function(){
		$(".k-draghandle").css({"font-size":"50%"}); 
		$(".k-grid td").css({"padding-top":"0px","padding-bottom":"0px"});
		//$(".k-grid td").css({"padding":"0px"});

}
	// TITLE BY JSON START
	/*########## Table Content Start ##########*/
	var $titleJ =[
              {
                  field: "Field1",
				   width: 250
              },
              {
                  field: "Field2",
				  width: 80
			 },
              {
                  field: "Field3",
				  width: 80
			 },
              {
                  field: "Field4",
				  width:80
			 },
              {
                  field: "Field5",
				  width: 80
			 }, 
              {
                  field: "Field6",
				  width: 80
			 },
              {
                  field: "Field7",
				  width: 80
			 },
              {
                  field: "Field8",
				  width: 80
			 },
             {
                  field: "Field9",
			 } ];

var $titleJ2 =[
              {
                  field: "Field1",
				  width: 243
              },
              {
                  field: "Field2",
				    width: 80
			 },
              {
                  field: "Field3",
				    width: 80
			 },
              {
                  field: "Field4",
				    width: 80
			 },
              {
                  field: "Field5",
				    width: 80
			 },
              {
                  field: "Field6",
				    width: 80
			 },
              {
                  field: "Field7",
				    width: 80
			 },
              {
                  field: "Field8",
				    width: 80
			 },
              {
                  field: "Field9",
				    width: 105
			 }
           ];
var $titleJ3 =[
              {
                  field: "Field1",
				  width: 236
              },
              {
                  field: "Field2",
				    width: 80
			 },
              {
                  field: "Field3",
				    width: 80
			 },
              {
                  field: "Field4",
				    width: 80
			 },
              {
                  field: "Field5",
				    width: 80
			 },
              {
                  field: "Field6",
				    width: 80
			 },
              {
                  field: "Field7",
				    width: 80
			 },{
                  field: "Field8",
				    width: 80
			 },{
                  field: "Field9",
				    width: 105
			 }
           ];
var $titleJ4 =[
              {
                  field: "Field1",
				  width: 229
              },
              {
                  field: "Field2",
				    width: 80
			 },
              {
                  field: "Field3",
				    width: 80
			 },
              {
                  field: "Field4",
				    width: 80
			 },
              {
                  field: "Field5",
				    width: 80
			 },
              {
                  field: "Field6",
				    width: 80
			 },
              {
                  field: "Field7",
				    width: 80
			 },
              {
                  field: "Field8",
				    width: 80
			 },{
                  field: "Field9",
				    width: 105
			 }
           ];
var $titleJ5 =[
              {
                  field: "Field1",
				  width: 252
              },
              {
                  field: "Field2",
				    width: 80
			 },
              {
                  field: "Field3",
				    width: 80
			 },
              {
                  field: "Field4",
				    width: 80
			 },
              {
                  field: "Field5",
				    width: 80
			 },
              {
                  field: "Field6",
				    width: 80
			 },
              {
                  field: "Field7",
				    width: 80
			 },
              {
                  field: "Field8",
				    width: 80
			 },{
                  field: "Field9",
				    width: 105
			 }
           ];



	var $dataJ =<%=dataDefault%>; 
	//CONTENT BY JSON END

	$("#grid").kendoGrid({
		 theme:$(document).data("kendoSkin") || "metro",
          height: 550,
		  detailInit: detailInit2,
          columns: $titleJ,
          dataSource: {
              data: $dataJ,
			  pageSize: 10
          }
      });
	  /*########## Table Content End ##########*/
			
	 function detailInit2(e) {
		//alert(e.data.account_key);
		$.ajax({
					url:'sp_profit_and_loss_list_level.jsp',
					type:'get',
					dataType:'json',
					cache:false,
					data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramLevel':3,'paramParentKey':e.data.account_key},
					success:function(data){
						//console.log(data);
								 $("<table><th></th></table>").kendoGrid({
								detailInit: detailInit3,
								columns: $titleJ2,
								dataSource: {
								data: data,
								pageSize: 8
								}
								}).appendTo(e.detailCell);
								setFont();
							// REMOVE COLUMN START
								//$("tr.k-detail-row td.k-hierarchy-cell").remove();
							// REMOVE COLUMN END
						
					}//success
		});//ajax

					// REMOVE COLUMN START
						$(" tr.k-detail-row").each(function(){
							if($("td.k-hierarchy-cell",this).html()==""){
								$("td.k-hierarchy-cell",this).remove();
							}
						});
					// REMOVE COLUMN END

     } // End Function detailInit2

	  function detailInit3(e) {
		$.ajax({
					url:'sp_profit_and_loss_list_level.jsp',
					type:'get',
					dataType:'json',
					cache:false,
					data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramLevel':4,'paramParentKey':e.data.account_key},
					success:function(data){
								 $("<table><th></th></table>").kendoGrid({
								detailInit: detailInit4,
								columns: $titleJ3,
								dataSource: {
								data: data,
								pageSize: 8
								}
								}).appendTo(e.detailCell);
								setFont();

					}//success
		});//ajax

					// REMOVE COLUMN START
						$(" tr.k-detail-row").each(function(){
							if($("td.k-hierarchy-cell",this).html()==""){
								$("td.k-hierarchy-cell",this).remove();
							}
						});
					// REMOVE COLUMN END


	  }// End Function detailInit3
	   function detailInit4(e) {
		$.ajax({
					url:'sp_profit_and_loss_list_level.jsp',
					type:'get',
					dataType:'json',
					cache:false,
					data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramLevel':5,'paramParentKey':e.data.account_key},
					success:function(data){
								 $("<table><th></th></table>").kendoGrid({
								detailInit: detailInit5,
								columns: $titleJ4,
								dataSource: {
								data: data,
								pageSize: 8
								}
								}).appendTo(e.detailCell);
								setFont();

					}//success
		});//ajax

					// REMOVE COLUMN START
						$(" tr.k-detail-row").each(function(){
							if($("td.k-hierarchy-cell",this).html()==""){
								$("td.k-hierarchy-cell",this).remove();
							}
						});
					// REMOVE COLUMN END

	  }// End Function detailInit4
	  function detailInit5(e) {
		$.ajax({
					url:'sp_profit_and_loss_list_level.jsp',
					type:'get',
					dataType:'json',
					cache:false,
					data:{'paramYear':$('#domParamYear').val(),'paramMonth':$('#domParamMonth').val(),'paramLevel':6,'paramParentKey':e.data.account_key},
					success:function(data){
								 $("<table><th></th></table>").kendoGrid({
								columns: $titleJ5,
								dataSource: {
								data: data
								//pageSize: 30
								}
								}).appendTo(e.detailCell);
								setFont();
					
					}//success
		});//ajax

		// REMOVE COLUMN START
						$(" tr.k-detail-row").each(function(){
							if($("td.k-hierarchy-cell",this).html()==""){
								$("td.k-hierarchy-cell",this).remove();
							}
						});
					// REMOVE COLUMN END

	  }// End Function detailInit4


	});//document ready

		/*################# jQuery Start #############*/
		$(".k-icon").click(function(){
		if($(".k-minus").length!=0){
		}else{
		$(".k-detail-row").remove();//delete value pie old for add new value
		}
		});
		/*################# jQuery End #############*/
	</script>


 <!-- Define the HTML table, with rows, columns, and data -->
<div class="boxContent">
	<div id="boxL"><!-- boxL	 Start-->
	<div id="titleTop" style="text-align:right"> หน่วย : ล้านบาท </div>
	 <div class="content"><!-- Content	 Start-->
 <div id="table_content">
 <table id="grid">
  <thead>
      <tr>		  
		 <!--<th class="k-hierarchy-cell k-header"></th>-->
          <th  data-field="Field1" ><center><div class="fontTitle">รายการ </div></center></th>
		<!--
		  <th  data-field="Field2"><center><div class="fontTitle">สก.</div></center></th>		 
		  <th data-field="Field3"><center><div class="fontTitle">ศช.</div></center></th>
		  <th data-field="Field4"><center><div class="fontTitle">ศว.</div></center></th>
		  <th data-field="Field5"><center><div class="fontTitle">ศอ.</div></center></th>
		  <th data-field="Field6"><center><div class="fontTitle">ศจ.</div></center></th>
		  <th data-field="Field7"><center><div class="fontTitle">ศน.</div></center></th>
          <th data-field="Field8"><center><div class="fontTitle">ทุนประเดิม</div></center></th>
		-->
		<%=area_list%>
		  <th data-field="Field9"><center><div class="fontTitle">รวม</div></center></th>
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
</div><!-- Content	 End-->
	</div><!-- boxL	 End>-->
	<br style="clear:both">
</div>