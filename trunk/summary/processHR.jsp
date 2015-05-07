<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%
String month=request.getParameter("month");
String year=request.getParameter("year");
//String month = "11";
//String year = "2012";
//out.print(month);
//out.print(year);
//=====================Pie HR1==============

Query="CALL sp_emp_by_mission(";
Query += year +"," + month +");";
//out.print(ParamYear + ParamMonth);
rs = st.executeQuery(Query);
String resultSet = "";
int i = 0;
int j = 0;
int totalPieHR1 = 0;
String valuePieHR1 ="{\"value_piehr1\":[";
				//		 [ 
				//        {"category_center":["BIOTEC","MTEC","NECTEC","NANOTEC"]},
				//        {"series_center":[{"name":"IC Score","data":[0,0,0,0]},
				//        {"pie_sp_ic_score":[0,0,0,0]},
				//        {"sum_pie_sp_ic_score":0}
				//        ]
				// console.log(data[0]["category_center"]);
				 //   categories: [ "โครงการ" ," หน่วยงาน", "ครุภัณฑ์ ", "บุคลากร"]

	while(rs.next()){
	if(i>0){
			valuePieHR1 += ",";
	}
		String missionName = rs.getString("mission_name");
		int total = rs.getInt("total");
	
		valuePieHR1 += "{\"category\": \"";
		valuePieHR1 += missionName;
		valuePieHR1 += "\",";
		valuePieHR1 += "\"value\": ";
		valuePieHR1 += total;
		valuePieHR1 += "}";
		totalPieHR1 = totalPieHR1 + total;
		i++;
}
valuePieHR1 += "]}";

//==================End Pie HR 1==================

//============================ Pie HR 2============================

String centerQueryParam = "สวทช.";//????. ====================== Use This ===================================
//String centerQueryParam = "MTEC"; ///////////////////////// ++++++++++++++This For Test Query Only ! ! ! ! !+
Query="CALL sp_emp_by_job_family(";
Query += year +"," + month +",\""+centerQueryParam+"\");";
//out.print(ParamYear + ParamMonth);
rs = st.executeQuery(Query);
resultSet = "";
 i = 0;
int totalPieHR2 = 0;
String valuePieHR2 ="{\"value_piehr2\":[";
	while(rs.next()){
	if(i>0){
			valuePieHR2 += ",";
	}
		String jobFamilyName = rs.getString("job_family_name");
		int total = rs.getInt("total_employee");
	
		valuePieHR2 += "{\"category\": \"";
		valuePieHR2 += jobFamilyName;
		valuePieHR2 += "\",";
		valuePieHR2 += "\"value\": ";
		valuePieHR2 += total;
		valuePieHR2 += "}";
		totalPieHR2 = totalPieHR2 + total;
		i++;
}
valuePieHR2 += "]}";

//==================End Pie HR 2==================


Query="CALL sp_monthly_emp_turnover(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);
resultSet = "";
i = 0;

String valueLineHR3 ="{\"value_linehr3\":[";
String categoryLineHR3 = "{\"categorylinehr3\":[";
String[] categoryLineHR3Arr ;
	while(rs.next()){
		if(i==0){
			String category = rs.getString("month_list");
			categoryLineHR3Arr = category.split(",");
			for(j=0; j< categoryLineHR3Arr.length; j++){
				if(j>0)
				{	
					categoryLineHR3+=",";
				}
				categoryLineHR3 += "\""+categoryLineHR3Arr[j]+"\"";
			}//for
		}//if
	
		if(i>0){
			valueLineHR3 += ",";
		}
		String period = rs.getString("period");
		String data = rs.getString("percentage_list");
		

		valueLineHR3 += "{\"name\": \"";
		valueLineHR3 += period;
		valueLineHR3 += "\",";
		valueLineHR3 += "\"data\": [";
		valueLineHR3 += data;
		valueLineHR3 += "]}";
		i++;
	}
	valueLineHR3 += "]}";
	categoryLineHR3 += "]}";
//out.println(valueLineHR3);
//out.println(categoryLineHR3);
//================End Line Chart =========================
out.print("[{\"totalPieHR1\":"+totalPieHR1+"},"+valuePieHR1+",{\"totalPieHR2\":"+totalPieHR2+"},"+valuePieHR2+","+categoryLineHR3+","+valueLineHR3+"]");
//out.print("[{\"gauge1\":\""+percentG1+"\",\"plang1\":\""+sumPlanG1+"\",\"resultg1\":\""+sumResultG1+"\",\"gauge2\":\""+percentG2+"\",\"plang2\":\""+planG2+"\",\"resultg2\":\""+resultG2+"\"},"+seriesBarchart+","+categoryBarchart+"]");
%>