<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
	String paramYear= request.getParameter("paramYear");
	String paramMonth= request.getParameter("paramMonth");
	String paramLevel=request.getParameter("paramLevel");
	String paramParentKey=request.getParameter("paramParentKey");

/*
	out.print("paramYear"+paramYear+"<br>");
	out.print("paramMonth"+paramMonth+"<br>");
	out.print("paramArea"+paramArea+"<br>");
	out.print("paramParentKey"+paramParentKey+"<br>");
*/

String dataLevel="";
String[] amount_list_array;
String amount_list="";


	Query="CALL sp_profit_and_loss_list_per_level("+paramYear+","+paramMonth+","+paramLevel+","+paramParentKey+");";
	rs=st.executeQuery(Query);
	Integer i=0;
		dataLevel+="[";
	while(rs.next()){
		if(i==0){
		dataLevel+="{" ;
		dataLevel+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		
		//Loop for get value amount_list
		amount_list=rs.getString("amount_list");
		amount_list_array = amount_list.split(",");
		int j=2;
		Double amount_sum=0.0;
		Double amount_by_center=0.0;
		for(int l=0; l<amount_list_array.length; l++ ){
				amount_by_center=Double.parseDouble(amount_list_array[l]);
				dataLevel+="\"Field"+j+"\":\"<div class='textR'>"+numberFormatter.format(amount_by_center)+"</div>\",";
				amount_sum+=Double.parseDouble(amount_list_array[l]);
		j++;
		}
		//Loop for get value amount_list 
		
		dataLevel+="\"Field9\":\"<div class='textR'>"+numberFormatter.format(amount_sum)+"</div>\"";
		dataLevel+="}" ;
		}else{
		dataLevel+=",{" ;
		dataLevel+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";

		//Loop for get value amount_list 
		amount_list=rs.getString("amount_list");
		amount_list_array = amount_list.split(",");
		int k=2;
		Double amount_sum=0.0;
		Double amount_by_center=0.0;
		for(int m=0; m<amount_list_array.length;m++ ){
				amount_by_center=Double.parseDouble(amount_list_array[m]);
				dataLevel+="\"Field"+k+"\":\"<div class='textR'>"+numberFormatter.format(amount_by_center)+"</div>\",";
				amount_sum+=Double.parseDouble(amount_list_array[m]);
		k++;
		}
		//Loop for get value amount_list 

		dataLevel+="\"Field9\":\"<div class='textR'>"+numberFormatter.format(amount_sum)+"</div>\"";
		dataLevel+="}" ;
		}//if
i++;
}//while
dataLevel+="]";
out.print(dataLevel);
conn.close();
/*
	var $dataJ =[
                  {
			
					  Field0: "01",
                      Field1: "<div id='textL'>รายได้</div>",
					  Field2: "<div id='textR'> 3,304.14</div>",
                      Field3: " <div id='textR'>54.74</div> ",
					  Field4: "<div id='textR'>46.13</div>",
                      Field5: "<div id='textR'>71.57</div>",
					  Field6: " <div id='textR'>320.64<div>",
                      Field7: "<div id='textR'>6.05<div>",
					  Field8: " <div id='textR'>10.14<div>",
					  Field9: " <div id='textR'>3,813.44<div>"
                  }, {
					  Field0: "02",
                      Field1: "<div id='textL'>ค่าใช้จ่าย</div>",
					  Field2: "<div id='textR'>664.93 </div>",
                      Field3: " <div id='textR'>471.27</div> ",
					  Field4: "<div id='textR'>397.72</div>",
                      Field5: "<div id='textR'>498.28</div>",
					  Field6: " <div id='textR'>372.91<div>",
                      Field7: "<div id='textR'>150.52<div>",
					  Field8: " <div id='textR'>9.41<div>",
					  Field9: " <div id='textR'>2,565.04<div>"
                  }
				  
				  ]; 	
*/
%>