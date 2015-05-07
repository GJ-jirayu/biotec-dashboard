<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%@page import="java.text.DecimalFormat" %>
<%
	DecimalFormat numberFormatter = new DecimalFormat("###,###,##0.00");
	//DecimalFormat numberFormatter = new DecimalFormat("0.00");
	String paramYear= request.getParameter("paramYear");
	String paramMonth= request.getParameter("paramMonth");
	String paramArea=(request.getParameter("paramArea").trim());
	String paramParentKey=request.getParameter("paramParentKey");

/*
	out.print("paramYear"+paramYear+"<br>");
	out.print("paramMonth"+paramMonth+"<br>");
	out.print("paramArea"+paramArea+"<br>");
	out.print("paramParentKey"+paramParentKey+"<br>");
*/

String dataLevel3="";
	Query="CALL sp_profit_and_loss_list_by_center_per_level("+paramYear+","+paramMonth+",'"+paramArea+"',4,"+paramParentKey+");";
	rs=st.executeQuery(Query);
	Integer i=0;
	dataLevel3+="[";
	while(rs.next()){

		/*
		out.print("account_name"+rs.getString("account_name")+"<br>");
		out.print("account_key"+rs.getString("account_key")+"<br>");
		out.print("account_id"+rs.getString("account_id")+"<br>");
		out.print("level"+rs.getString("level")+"<br>");
		out.print("hlevel"+rs.getString("hlevel")+"<br>");
		out.print("pMonthAmt"+rs.getString("currentAmt")+"<br>");
		out.print("currentAmt"+rs.getString("pMonthAmt")+"<br>");
		out.print("pYearAmt"+rs.getString("pYearAmt")+"<br>");
		out.print("<br>-------------------------------------------------------------------<br>");
		*/
Double GrowthPercentage=0.00;
Double pMonthAmt =0.0;
Double currentAmt=0.0;
Double Result=0.0;
		if(i==0){
		dataLevel3+="{" ;

		dataLevel3+="\"account_name\":\""+rs.getString("account_name")+"\",";
		dataLevel3+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel3+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataLevel3+="\"Field2\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataLevel3+="\"Field3\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";

			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}


		dataLevel3+="\"Field5\":\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataLevel3+="\"Field6\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataLevel3+="}" ;
		}else{
		dataLevel3+=",{" ;
		dataLevel3+="\"account_name\":\""+rs.getString("account_name")+"\",";
		dataLevel3+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel3+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataLevel3+="\"Field2\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataLevel3+="\"Field3\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";

			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}

		dataLevel3+="\"Field5\":\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataLevel3+="\"Field6\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataLevel3+="}" ;
		}
i++;
}//while

	dataLevel3+="]";
	out.print(dataLevel3);
conn.close();
/*
var $dataJ21 =[
                  {
                      Field1: "เงินอุดหนุนจากรัฐบาล",
					  Field2: "<div id='textR'>1,391.88</div>",
                      Field3: "<div id='textR'> 1,279.12 </div>",
					
                      Field5: "<div id='textR'>8.82%</div>",
					  Field6: "<div id='textR'>1,440.10 </div>",
                  
                     
                  },{
                      Field1: "เงินอะดหนุนอื่น",
					  Field2: "<div id='textR'>2,391.88</div>",
                      Field3: " <div id='textR'>216.80 </div>",
					
                      Field5: "<div id='textR'>10.68%</div>",
					  Field6: "<div id='textR'>230.99 </div>",
                  }];
*/
%>