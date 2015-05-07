<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" language="java" %>
<%@ page language="java" import="net.sf.json.JSONArray" %>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page language="java" import="com.google.gson.Gson" %>
<%@ include file="../config.jsp"%>
<%


if( request.getParameter("year") != null && request.getParameter("month") != null && request.getParameter("center") != null ){

try { 
//int year = 2012; int month = 12;
int year = Integer.parseInt(request.getParameter("year"));
int month = Integer.parseInt(request.getParameter("month"));
String center = request.getParameter("center");


conn=null;
st=null;
rs=null;

try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);

}catch(ClassNotFoundException cnfex){
cnfex.printStackTrace();

}

//ArrayList
ArrayList division = new ArrayList();
ArrayList IC_Score = new ArrayList();
ArrayList BSC_Score = new ArrayList();
ArrayList Emp_Score = new ArrayList();

// use
ArrayList category = new ArrayList();
category.add("IC_Score");
category.add("BSC_Score");
category.add("Emp_Score");
Hashtable serie1 = new Hashtable(); // have Name,Data
Hashtable serie2 = new Hashtable(); // have Name,Data
Hashtable serie3 = new Hashtable(); // have Name,Data
ArrayList series = new ArrayList();  // list of serie
Hashtable main = new Hashtable();
ArrayList ret = new ArrayList();


// Make sure you have the Gson JAR in your classpath
String sql = "call sp_ic_score_by_division_2("+year+","+month+","+center+")";
//String sql = "select 1 as IC_Score,2 as BSC_Score,3 as Emp_Score union select 2 as IC_Score,5 as BSC_Score,6 as Emp_Score";

try{
st = conn.createStatement();
rs = st.executeQuery(sql);
	while( rs.next() ){
		division.add('"'+rs.getString("division")+'"');	
		IC_Score.add(rs.getInt("IC_Score"));	
		BSC_Score.add(rs.getInt("BSC_Score"));	
		Emp_Score.add(rs.getInt("Emp_Score"));
	}	
	serie1.put("name","IC_Score");
	serie1.put("data",IC_Score);
	series.add(serie1);
	serie2.put("name","BSC_Score");
	serie2.put("data",BSC_Score);
	series.add(serie2);
	serie3.put("name","Emp_Score");
	serie3.put("data",Emp_Score);
	series.add(serie3);
	main.put("category",division.toString());
	main.put("series",series);
	ret.add(main);
}
catch(Exception e){out.print(e);
}
finally{

if(rs!=null) rs.close();
if(st!=null) st.close();
if(conn!=null) conn.close();
}

// echo json data
// (place it in the tomcat/classes directory)
Gson gson = new Gson();
String json = gson.toJson(ret);  
out.println(json);

}catch(Exception e){
	out.print(e);
}

}else{
	out.print("Get Parameters is invalid");
}
%>

