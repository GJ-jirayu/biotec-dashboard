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

//===================================Start Pie Chart ===========================
Query="CALL sp_count_io_by_business_area(";
Query += year +"," + month +",\""+center+"\");";
rs = st.executeQuery(Query);
int i = 0;
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

out.print("[{\"totalPie\":"+totalPie+"},"+valuePie+"]");

%>

