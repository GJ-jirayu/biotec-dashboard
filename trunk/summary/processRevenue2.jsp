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

Query="CALL sp_executive_revenue_vs_plan(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);
String resultSet = "";

int i = 0;
double planG3 =0;
double revenueG3 = 0;
double percentG3 = 0;
while(rs.next()){
		planG3 = rs.getDouble("plan");
		revenueG3 = rs.getDouble("revenue");
		percentG3 = rs.getDouble("revenue_vs_plan");
}

Query="CALL sp_executive_revenue_by_bsc(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);
resultSet = "";
i = 0;

String valueBarRevenue2 ="{\"value_barrevenue2\":[";
String categoryBarRevenue2 = "{\"categorybarrevenue2\":[";
//String mouseHoverBarRevenue2 = "{\"tooltip_barrevenue2\":";
	while(rs.next()){
		if(i==0){
			String category = rs.getString("bsc_id_list");
			categoryBarRevenue2 += category;
		}
		if(i>0){
			valueBarRevenue2 += ",";
		}
		String name = "รายได้แบ่งตามประเภท(ล้านบาท)";
		String data = rs.getString("revenue_list");

		valueBarRevenue2 += "{\"name\": \"";
		valueBarRevenue2 += name;
		valueBarRevenue2 += "\",";
		valueBarRevenue2 += "\"data\": [";
		valueBarRevenue2 += data;
		valueBarRevenue2 += "]}";
		i++;
	}
	valueBarRevenue2 += "]}";
	categoryBarRevenue2 += "]}";
//out.println(valueBarRevenue2);
//out.println(categoryBarRevenue2);

out.print("["+valueBarRevenue2+","+categoryBarRevenue2+"]");
%>
