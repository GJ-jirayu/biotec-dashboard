<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>

<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");
String ParamWorkingRangelist = request.getParameter("ParamWorkingRangelist");
//out.println("it is parameter is send form ajax"+param1);


//############################bar  sp_npr_by_country_group_drilldown  Start ############################ /

String categoryAxis_npr_country_group = "";
String[] categoryAxis_npr_country_group_array;
String categoryAxis_npr_country_group_using="";

String series_job_country_group = "";
String series_job_country_group_array = "";
String series_job_country_group_using = "";


try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_country_group_drilldown("+ParamYear+","+ParamMonth+",'"+ParamOrg+"','"+ParamWorkingRangelist+"')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_country_group_using+="[";
		series_job_country_group+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_country_group=rs.getString("working_range_list");
				categoryAxis_npr_country_group_array=categoryAxis_npr_country_group.split(",");
				series_job_country_group+="{\"name\":"+"\""+rs.getString("npr_status")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_country_group_array.length; j++){
					if(j==0){
					categoryAxis_npr_country_group_using+="\""+categoryAxis_npr_country_group_array[j]+"\"";
					}else{
					categoryAxis_npr_country_group_using+=",\""+categoryAxis_npr_country_group_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_country_group+=",{\"name\":"+"\""+rs.getString("npr_status")+"\","+"\"data\":["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_country_group_using+="]";
	series_job_country_group+="]";
	
	//Success fully Start
		out.println("[{\"category\":"+categoryAxis_npr_country_group_using+"},{\"series\":"+series_job_country_group+"}]");
		//out.println("{\"series1\":"+series_job_country_group+"}");
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
out.println("<font color='red'>Error sp_npr_by_country_group_drilldown</font>"+ex);
}
//############################bar  sp_npr_by_country_group  End ############################ //

%>
