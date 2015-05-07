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
String cluster = request.getParameter("cluster");
String spa = request.getParameter("spa");

//String month = "11";
//String year = "2012";


//===================== Get Progress Bar 1===========================================


Query="CALL sp_budget_project_cluster_most_spending(";
Query += year +"," + month +",\""+cluster+"\",\""+spa+"\");";
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
	
	}
if(i<10)
{
	for(;i<10;i++){
		progressBar1 += ",{\"value\": 0},{\"name\":\"No data\"}";
	//	out.print(i+"<br>");
	}
}

//out.print(progressBar1+"<br>");

// ========================End Get Progress Bar 1================================

//===================== Get Progress Bar 2===========================================

Query="CALL sp_budget_project_cluster_least_spending(";
Query += year +"," + month +",\""+cluster+"\",\""+spa+"\");";
rs = st.executeQuery(Query);
String progressBar2 = "";

i=0;

while(rs.next()){
	String spending_percent = rs.getString("spending_percent");
	String wbs_name = rs.getString("wbs_name"); 

	if(i>0)
	{
		progressBar2 += ",";
	}
	progressBar2 += "{\"value\":"+spending_percent+"},{\"name\":\""+wbs_name+"\"}";
	i++;	
}
	//out.print(progressBar2+"<br>");
	if(i<10)
	{
		for(;i<10;i++){
			progressBar2 += ",{\"value\": 0},{\"name\":\"No data\"}";
		}
	}

out.print("[{\"temp\":3},{\"temp\":3},"+progressBar1+","+progressBar2+"]");

// ========================End Get Progress Bar 2================================
%>

