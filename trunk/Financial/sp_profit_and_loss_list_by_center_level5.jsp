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

String dataLevel5="";
	Query="CALL sp_profit_and_loss_list_by_center_per_level("+paramYear+","+paramMonth+",'"+paramArea+"',6,"+paramParentKey+");";
	rs=st.executeQuery(Query);
	Integer i=0;
	dataLevel5+="[";
	while(rs.next()){

		/*
		out.print("account_name"+rs.getString("account_name")+"<br>");
		out.print("account_key"+rs.getString("account_key")+"<br>");
		out.print("account_id"+rs.getString("account_id")+"<br>");
		out.print("level"+rs.getString("level")+"<br>");
		out.print("hlevel"+rs.getString("hlevel")+"<br>");
		out.print("pMonthAmt"+rs.getString("pMonthAmt")+"<br>");
		out.print("currentAmt"+rs.getString("currentAmt")+"<br>");
		out.print("pYearAmt"+rs.getString("pYearAmt")+"<br>");
		out.print("<br>-------------------------------------------------------------------<br>");
		*/
Double GrowthPercentage=0.00;
Double pMonthAmt =0.0;
Double currentAmt=0.0;
Double Result=0.0;
		if(i==0){
		dataLevel5+="{" ;

		dataLevel5+="\"account_name\":\""+rs.getString("account_name")+"\",";
		dataLevel5+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel5+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataLevel5+="\"Field2\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataLevel5+="\"Field3\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";

			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}

		dataLevel5+="\"Field5\":\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataLevel5+="\"Field6\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataLevel5+="}" ;
		}else{
		dataLevel5+=",{" ;
		dataLevel5+="\"account_name\":\""+rs.getString("account_name")+"\",";
		dataLevel5+="\"account_key\":"+rs.getString("account_key")+",";
		dataLevel5+="\"Field1\":\"<div class='textL level"+rs.getString("level") +" parent_key"+rs.getString("parent_key")+"'  id='account_key"+rs.getString("account_key")+" '>"+rs.getString("account_name")+" </div>\",";
		dataLevel5+="\"Field2\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pMonthAmt"))+"</div>\",";
		dataLevel5+="\"Field3\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("currentAmt"))+"</div>\",";

			pMonthAmt = rs.getDouble("pMonthAmt");
			currentAmt = rs.getDouble("currentAmt");
			if(currentAmt==0.0){
			GrowthPercentage=0.0;
			}else{
			Result = currentAmt-pMonthAmt;
			GrowthPercentage =(Result / pMonthAmt)* 100;
			}

		dataLevel5+="\"Field5\":\"<div class='textR'>"+numberFormatter.format(GrowthPercentage)+"%</div>\",";
		dataLevel5+="\"Field6\":\"<div class='textR'>"+numberFormatter.format(rs.getDouble("pYearAmt"))+"</div>\"";
		dataLevel5+="}" ;
		}
i++;
}//while

	dataLevel5+="]";
	out.print(dataLevel5);
conn.close();
%>