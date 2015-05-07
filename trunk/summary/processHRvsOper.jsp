<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%
String month=request.getParameter("month");
String year=request.getParameter("year");
String flag = request.getParameter("flag");
//String flag = "1";
//String month = "11";
//String year = "2012";

Query="CALL sp_personnel_expense_vs_operating_expense(";
Query += year +"," + month +","+flag+");";
rs = st.executeQuery(Query);
int i = 0;
float totalPieHR3 = 0;
String valuePieHR3 ="{\"value_piehr3\":[";

	while(rs.next()){
	if(i>0){
			valuePieHR3 += ",";
	}
		String typeName = rs.getString("typename");
		float expense = rs.getFloat("expense");
	
		valuePieHR3 += "{\"category\": \"";
		valuePieHR3 += typeName;
		valuePieHR3 += "\",";
		valuePieHR3 += "\"value\": ";
		valuePieHR3 += expense;
		valuePieHR3 += "}";
		totalPieHR3 = totalPieHR3 + expense;
		i++;
}
valuePieHR3 += "]}";

//out.print(valuePieHR3);
out.print("[{\"totalPieHR3\":\""+totalPieHR3+"\"},"+valuePieHR3+"]");
%>