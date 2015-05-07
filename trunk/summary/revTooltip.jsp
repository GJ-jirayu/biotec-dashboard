<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%
String month=request.getParameter("month");
String year=request.getParameter("year");
//String month = "11";
//String year = "2012";

Query="CALL sp_executive_revenue_by_bsc(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);
	while(rs.next()){
		out.print(rs.getString("bsc_name_list"));
	}
%>