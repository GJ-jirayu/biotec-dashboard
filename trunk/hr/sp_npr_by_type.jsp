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

//############################  pie sp_npr_by_type  Start ######################### /

String sp_npr_by_type ="";
Integer sum_npr_by_type=0;

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_type("+ParamYear+","+ParamMonth+",'"+ParamOrg+"');";
		rs = st.executeQuery(Query);
		sp_npr_by_type+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){

		sp_npr_by_type+="{\"category\":";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",\"value\":"+rs.getString("total") ;
		sum_npr_by_type+=rs.getInt("total");
		sp_npr_by_type+="}";

		}else{
		sp_npr_by_type+=",{\"category\":";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",\"value\":"+rs.getString("total");
		sp_npr_by_type+="}";
		sum_npr_by_type+=rs.getInt("total");
		}
		
	i++;
		}
		sp_npr_by_type+="]";
		//out.println("-------------------------------------------------------"+"<br>");
		//out.println("sum_npr_by_type"+sum_npr_by_type+"<br>");
		//out.println("sp_npr_by_type"+sp_npr_by_type+"<br>");
		//out.println("-------------------------------------------------------"+"<br>");
		conn.close();
	}
}
catch(Exception ex){
//out.println("<font color='red'>Error sp_npr_by_type</font>"+ex);
}

out.print("[{\"category_pie\":"+sp_npr_by_type+"},{\"sum_pie\":"+sum_npr_by_type+"}]");
//############################ pie sp_npr_by_type  End ############################ /

%>
