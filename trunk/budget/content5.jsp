<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%!
public static float Round(double Rval, int Rpl) {
  float p = (float)Math.pow(10,Rpl);
  Rval = Rval * p;
  float tmp = Math.round(Rval);
  return (float)tmp/p;
  }
%>
<%

String month=request.getParameter("month");
String year=request.getParameter("year");

//String month = "11";
//String year = "2012";

Query="CALL sp_budget_io_business_area(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);

String seriesBarchart ="{\"series1\": [";
String categoryBarchart = "{\"category1\":[";
String[] categoryBarchartArr;
String categoryGetPieBar ="" ;
String test = "";

int i = 0;
int j=0;

	while(rs.next()){
		String typeName = rs.getString("typename");
		String value_list = rs.getString("value_list"); 
		String area_list = rs.getString("area_list");
		if(i>0){
			seriesBarchart += ",";
		}
		if(i==0)
		{
				categoryBarchartArr = area_list.split(",");
				categoryGetPieBar = categoryBarchartArr[0];
		       for(j=0; j< categoryBarchartArr.length; j++){
				   if(j>0)
				   {	
						categoryBarchart+=",";
				   }
						categoryBarchart += "\""+categoryBarchartArr[j]+"\"";
			   }//for
		}//if
		seriesBarchart += "{\"name\":\"";
		seriesBarchart += typeName;
		seriesBarchart += "\",\"data\":[";
		seriesBarchart += value_list;
		seriesBarchart += "]}";

		i++;

	}//while
	seriesBarchart +="]}";
	categoryBarchart +="]}";
	//out.print(seriesBarchart+categoryBarchart);
//=======================================End BarChart ============
//===================================Start Pie Chart ===========================
categoryGetPieBar = "ALL";
Query="CALL sp_count_io_by_business_area(";
Query += year +"," + month +",\""+categoryGetPieBar+"\");";
rs = st.executeQuery(Query);
i = 0;
float totalPie = 0;
String valuePie ="{\"value_pie\":[";

	while(rs.next()){
	if(i>0){
			valuePie += ",";
	}
		String category = rs.getString("name");
		float count_io = rs.getInt("count_io");
	
		valuePie += "{\"category\": \"";
		valuePie += category;
		valuePie += "\",";
		valuePie += "\"value\": ";
		valuePie += count_io;
		valuePie += "}";
		totalPie = totalPie + count_io;
		i++;
}
valuePie += "]}";

out.print("["+seriesBarchart+","+categoryBarchart+",{\"totalPie\":"+totalPie+"},"+valuePie+",{\"active_category\":\""+categoryGetPieBar+"\"}]");
/*
//[{"series_center": [{ "name": "แผน","data": [1881.4,0.0,67.46,0.0]},{ "name": "ผล","data": [1341.58,0.0,184.98,0.0]}]},{"category_center":["???????","????????","????????????","???????"]}]
out.print("[ {\"serieChart\":[{ \"name\": \"แผน\",	\"data\": [270,90,100,80,110,30] } , { \"name\": \"ผูกพัน\",\"data\": [90,30,30,40,30,10] } , {\"name\": \"เบิกจ่าย\",       \"data\": [70,40,30,40,30,10]}]},{\"category\":[ \"สก.\",\"ศช.\",\"ศว.\",\"ศอ.\",\"ศจ.\",\"ศน.\"]},{\"value\":[{\"category\": \"IO ที่ปิดแล้ว \",\"value\": 30 }, { \"category\": \"IO ที่เหลืออยู่\", \"value\": 70}]},{\"sumVal\":\"100\"}]");*/
%>
