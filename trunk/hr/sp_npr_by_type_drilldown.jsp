<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>

<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamNprlist = request.getParameter("ParamNprlist");

//############################bar  sp_npr_by_type_drilldown  Start ############################ /

String categoryAxis_npr_type = "";
String[] categoryAxis_npr_type_array;
String categoryAxis_npr_type_using="";

String series_job_type = "";
String series_job_type_array = "";
String series_job_type_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		//นักวิจัยหลังปริญญาเอก
		Query="CALL sp_npr_by_type_drilldown("+ParamYear+","+ParamMonth+",'"+ParamNprlist+"')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_type_using+="[";
		series_job_type+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_type=rs.getString("npr_list");
				categoryAxis_npr_type_array=categoryAxis_npr_type.split(",");
				series_job_type+="{\"name\":"+"\""+rs.getString("npr_country_group")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_type_array.length; j++){
					if(j==0){
					categoryAxis_npr_type_using+="\""+categoryAxis_npr_type_array[j]+"\"";
					}else{
					categoryAxis_npr_type_using+=",\""+categoryAxis_npr_type_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_type+=",{\"name\":"+"\""+rs.getString("npr_country_group")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_type_using+="]";
	series_job_type+="]";
	
	//Success fully Start
		out.println("[{\"category\":"+categoryAxis_npr_type_using+"},{\"series\":"+series_job_type+"}]");
		//out.println("{\"series1\":"+series_job_type+"}");
	//Success fully Stop

		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_type_drilldown</font>"+ex);
}
//############################bar  sp_npr_by_type  End ############################ //

%>
