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
String center=request.getParameter("center");

//String month = "11";
//String year = "2012";


//===================== Get Progress Bar 1===========================================

Query="CALL sp_budget_project_business_area_most_spending(";
Query += year +"," + month +",\""+center+"\");";
rs = st.executeQuery(Query);
String progressBar1 = "";

int i=0;

while(rs.next()){
	String spending_percent = rs.getString("spending_percent");
	String wbs_name = rs.getString("wbs_name"); 

	if(i>0){
		progressBar1 += ",";
	}
	progressBar1 += "{\"value\":"+spending_percent+"},{\"name\":\""+wbs_name+"\"}";
	i++;	
	
}if(i<10)
{
	for(;i<10;i++){
		if(i==0){
			progressBar1 += "{\"value\": 0},{\"name\":\"No data\"}";
		}else{
		progressBar1 += ",{\"value\": 0},{\"name\":\"No data\"}";
		}	
	}
}

//out.print(progressBar1+"<br>");

// ========================End Get Progress Bar 1================================

//===================== Get Progress Bar 2===========================================

Query="CALL sp_budget_project_business_area_least_spending(";
Query += year +"," + month +",\""+center+"\");";
rs = st.executeQuery(Query);
String progressBar2 = "";

i=0;
//ij=0;

while(rs.next()){
	String spending_percent = rs.getString("spending_percent");
	String wbs_name = rs.getString("wbs_name"); 

	if(i>0){
		progressBar2 += ",";
	}
	progressBar2 += "{\"value\":"+spending_percent+"},{\"name\":\""+wbs_name+"\"}";
	i++;	
//	ij++;
	
}if(i<10)
{
	for(;i<10;i++){
		if(i==0){
			progressBar2 += "{\"value\": 0},{\"name\":\"No data\"}";
		}else{
		progressBar2 += ",{\"value\": 0},{\"name\":\"No data\"}";
		}	
	}
}

out.print("[{\"temp\":3},{\"temp\":3},"+progressBar1+","+progressBar2+"]");
// ========================End Get Progress Bar 2================================
/*

out.print("[{\"series1\": [{\"name\": \"Project\",\"data\": [17.7, 16.7, 20, 23.5, 26.6, 26.6, 70, 80, 82, 89]}]},{\"category1\":[\"Project Z\", \"Project Y\", \"Project X\", \"Project W\", \"Project V\", \"Project U\", \"Project T\", \"Project S\", \"Project R\", \"Project Q\"]},{\"series2\": [{\"name\": \"Project\",\"data\":[89,85,80,75,70,68,66,65,63,30]}]} ,{\"category2\":[\"Project A\", \"Project B\", \"Project C\", \"Project D\", \"Project E\", \"Project F\", \"Project H\", \"Project I\", \"Project J\", \"Project K\"]} ]");*/
%>

