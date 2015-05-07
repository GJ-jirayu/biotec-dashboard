<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%@ include file="../config.jsp"%>

<%
String ParamMonth = request.getParameter("ParamMonth");
String ParamYear = request.getParameter("ParamYear");
String ParamOrg = request.getParameter("ParamOrg");
//String ParamMonth = "10";
//String ParamYear = "2012";
//String ParamOrg = "สวทช.";

//out.println("it is parameter is send form ajax"+param1);
//############################ pie sp_npr_by_country_group  Start ######################### /

String sp_npr_by_country_group ="";
Integer sum_npr_by_country_group=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_country_group("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_npr_by_country_group+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sp_npr_by_country_group+="{\"category\":";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",\"value\":"+rs.getString("total") ;
		sum_npr_by_country_group+=rs.getInt("total");
		sp_npr_by_country_group+="}";

		}else{
		sp_npr_by_country_group+=",{\"category\":";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",\"value\":"+rs.getString("total");
		sp_npr_by_country_group+="}";
		sum_npr_by_country_group+=rs.getInt("total");
		}
		
	i++;
		}
		sp_npr_by_country_group+="]";
		//out.println("-------------------------------------------------------"+"<br>");
		//out.println("sum_npr_by_country_group"+sum_npr_by_country_group+"<br>");
		//out.println("sp_npr_by_country_group"+sp_npr_by_country_group+"<br>");
		//out.println("-------------------------------------------------------"+"<br>");
		conn.close();
	}
}
catch(Exception ex){
//out.println("<font color='red'>Error sp_npr_by_country_group</font>"+ex);
}
out.print("[{\"category_pie\":"+sp_npr_by_country_group+"},{\"sum_pie\":"+sum_npr_by_country_group+"}]");
//############################pie  sp_npr_by_country_group  End ############################ /

%>
