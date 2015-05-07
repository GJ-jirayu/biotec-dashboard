<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%
String paramYear = request.getParameter("paramYear");
String paramMonth = request.getParameter("paramMonth");
String ParamBusinessArea = request.getParameter("business_area");
String paramAccountKey = request.getParameter("account_key");

//############################bar  sp_balance_sheet_trend  Start ############################ /

String categoryAxis_sp_balance_sheet_trend = "";
String[] categoryAxis_sp_balance_sheet_trend_array;
String categoryAxis_sp_balance_sheet_trend_using="";
String series_sp_balance_sheet_trend = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_balance_sheet_trend("+paramYear+","+paramMonth+",'"+ParamBusinessArea+"',"+paramAccountKey+")";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_sp_balance_sheet_trend_using+="[";
		series_sp_balance_sheet_trend+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_sp_balance_sheet_trend=rs.getString("month_list");

				
				categoryAxis_sp_balance_sheet_trend_array=categoryAxis_sp_balance_sheet_trend.split(",");
				series_sp_balance_sheet_trend+="{\"name\":"+"\""+(rs.getInt("period")+543)+"\","+"\"data\":["+rs.getString("amount_list")+"]}";

				for(int j=0; j< categoryAxis_sp_balance_sheet_trend_array.length; j++){
					if(j==0){
					categoryAxis_sp_balance_sheet_trend_using+="\""+categoryAxis_sp_balance_sheet_trend_array[j]+"\"";
					}else{
					categoryAxis_sp_balance_sheet_trend_using+=",\""+categoryAxis_sp_balance_sheet_trend_array[j]+"\"";
					}//if
				}//for
			}else if(i==1){//if
			series_sp_balance_sheet_trend+=",{\"name\":"+"\""+(rs.getInt("period")+543)+"\","+"\"data\":["+rs.getString("amount_list")+"]}";
			}else{

series_sp_balance_sheet_trend+=",{\"type\":\"line\","+"\"data\":["+rs.getString("amount_list")+"],\"name\":\"Variance\",\"color\":\"GREEN\",\"axis\":\"Variance\"}";
			}
		i++;
		}//while
	categoryAxis_sp_balance_sheet_trend_using+="]";
	series_sp_balance_sheet_trend+="]";
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_balance_sheet_trend</font>"+ex);
}
//############################bar  sp_balance_sheet_trend  End ############################ //
out.print("[{\"series\":"+series_sp_balance_sheet_trend+"}]");//1
%>

