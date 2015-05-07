<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ page import="java.util.StringTokenizer"%>
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
String pg_code = request.getParameter("pg_code");

//String month = "11";
//String year = "2012";
//String pg_code ="1";

Query="CALL sp_budget_project_program_group(";
Query += year +"," + month +",\""+pg_code+"\");";
rs = st.executeQuery(Query);

String seriesBarchart ="{\"series1\": [";
String categoryBarchart = "{\"category1\":[";
String[] categoryBarchartArr;
String categoryGetProgressBar ="" ;
String[] valueBarchartArr;
String test = "";

int i = 0;
int j=0;

	while(rs.next()){
		String typeName = rs.getString("typename");
		String value_list = rs.getString("value_list"); 
		String spa_list = rs.getString("spa_list");
		if(i>0){
			seriesBarchart += ",";
		}
		if(i==0)
		{
			// Split Category
				categoryBarchartArr = spa_list.split(",");
				categoryGetProgressBar = categoryBarchartArr[0];
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

/////////====================================END Barchart1======================

//===================== Get Progress Bar 1===========================================
//if(pg_code.equals("ALL")){
	categoryGetProgressBar ="ALL";
//	out.print(categoryGetProgressBar);
//}
Query="CALL sp_budget_project_program_group_most_spending(";
Query += year +"," + month +",\""+pg_code+"\",\""+categoryGetProgressBar+"\");";
rs = st.executeQuery(Query);
String progressBar1 = "";
i=0;
int lengthProgressBar1 = 0;
while(rs.next()){
	String spending_percent = rs.getString("spending_percent");
	String wbs_name = rs.getString("wbs_name"); 

	if(i>0){
		progressBar1 += ",";
	}
	progressBar1 += "{\"value\":"+spending_percent+"},{\"name\":\""+wbs_name+"\"}";
	i++;	
	lengthProgressBar1++;
	
}

if(i<10)
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

Query="CALL sp_budget_project_program_group_least_spending(";
Query += year +"," + month +",\""+pg_code+"\",\""+categoryGetProgressBar+"\");";
rs = st.executeQuery(Query);
String progressBar2 = "";
int lengthProgressBar2 = 0;
i=0;
while(rs.next()){
	String spending_percent = rs.getString("spending_percent");
	String wbs_name = rs.getString("wbs_name"); 

	if(i>0){
		progressBar2 += ",";
	}
	progressBar2 += "{\"value\":"+spending_percent+"},{\"name\":\""+wbs_name+"\"}";
	i++;	
	lengthProgressBar2++;
}

if(i<10)
{
	for(;i<10;i++){
		if(i==0){
			progressBar2 += "{\"value\": 0},{\"name\":\"No data\"}";
		}else{
		progressBar2 += ",{\"value\": 0},{\"name\":\"No data\"}";
		}	
	}
}

//out.println(lengthProgressBar1);
//out.println(lengthProgressBar2);
//out.print("["+seriesBarchart+","+categoryBarchart+",{\"lengthProgressBar1\":"+lengthProgressBar1+"}"+",{\"lengthProgressBar2\":"+lengthProgressBar2+"},"+progressBar1+","+progressBar2+"]");
out.print("["+seriesBarchart+","+categoryBarchart+","+progressBar1+","+progressBar2+",{\"active_category\":\""+categoryGetProgressBar+"\"}]");

// ========================End Get Progress Bar 2================================
%>

