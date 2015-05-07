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

out.print("[{\"totalPieHR1\":"+totalPieHR1+"},"+valuePieHR1+"]");
//out.print("[{\"gauge1\":\""+percentG1+"\",\"plang1\":\""+sumPlanG1+"\",\"resultg1\":\""+sumResultG1+"\",\"gauge2\":\""+percentG2+"\",\"plang2\":\""+planG2+"\",\"resultg2\":\""+resultG2+"\"},"+seriesBarchart+","+categoryBarchart+"]");
%>