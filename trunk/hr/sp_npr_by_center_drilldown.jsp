<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>

<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");


//############################bar  sp_npr_by_center_drilldown  Start ############################ /

String categoryAxis_npr_center = "";
String[] categoryAxis_npr_center_array;
String categoryAxis_npr_center_using="";

String series_job_center = "";
String series_job_center_array = "";
String series_job_center_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_center_drilldown("+ParamYear+","+ParamMonth+",'"+ParamOrg+"')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_center_using+="[";
		series_job_center+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_center=rs.getString("npr_list");
				categoryAxis_npr_center_array=categoryAxis_npr_center.split(",");
				series_job_center+="{\"name\":"+"\""+rs.getString("job_type")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_center_array.length; j++){
					if(j==0){
					categoryAxis_npr_center_using+="\""+categoryAxis_npr_center_array[j]+"\"";
					}else{
					categoryAxis_npr_center_using+=",\""+categoryAxis_npr_center_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_center+=",{\"name\":"+"\""+rs.getString("job_type")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_center_using+="]";
	series_job_center+="]";
	
	//Success fully Start
		out.println("[{\"category\":"+categoryAxis_npr_center_using+"},{\"series\":"+series_job_center+"}]");
		//out.println("{\"series1\":"+series_job_center+"}");
	//Success fully Stop


		//num row start
		rs.last();
		int c = rs.getRow();
		//out.println("num_row"+c);
		rs.beforeFirst();
		//num row end

		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_center_drilldown</font>"+ex);
}
//############################bar  sp_npr_by_center  End ############################ //

%>
