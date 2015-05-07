<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" language="java" %>
<%@ page language="java" import="net.sf.json.JSONArray" %>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page language="java" import="com.google.gson.Gson" %>
<%@ include file="../config.jsp"%>
<%


if( request.getParameter("year") != null && request.getParameter("month") != null ){

try { 
//int year = 2012; int month = 12;
int year = Integer.parseInt(request.getParameter("year"));
int month = Integer.parseInt(request.getParameter("month"));

java.sql.Connection con;
java.sql.Statement s;
//java.sql.ResultSet rs;
java.sql.PreparedStatement pst;

con=null;
s=null;
pst=null;
rs=null;

try{
Class.forName(Driver).newInstance();
con=DriverManager.getConnection(connectionURL,User,Pass);

}catch(ClassNotFoundException cnfex){
cnfex.printStackTrace();
}
//ArrayList
ArrayList en_name = new ArrayList();
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
String sql = "call sp_top20_ic_score("+year+","+month+")";
//String sql = "select 1 as IC_Score,2 as BSC_Score,3 as Emp_Score union select 2 as IC_Score,5 as BSC_Score,6 as 'Employee(JF2000)'";
try{
s = con.createStatement();
rs = s.executeQuery(sql);
	while( rs.next() ){
		en_name.add('"'+rs.getString("en_name")+'"');	
		IC_Score.add(rs.getInt("IC_Score"));	
		BSC_Score.add(rs.getInt("BSC_Score"));	
		Emp_Score.add(rs.getInt("Employee(JF2000)"));
	}	
	serie1.put("name","IC_Score");
	serie1.put("axis","one");
	serie1.put("data",IC_Score);
	series.add(serie1);
	serie2.put("name","BSC_Score");
	serie2.put("axis","one");
	serie2.put("data",BSC_Score);
	series.add(serie2);
	serie3.put("name","Employee(JF2000)");
	serie3.put("axis","two");
	serie3.put("data",Emp_Score);
	series.add(serie3);
	main.put("category",en_name.toString());
	main.put("series",series);
	ret.add(main);
}
catch(Exception e){out.print(e);
}
finally{
/*if(!con.isClosed()){
con.close();
}
*/
//if(rs!=null) rs.close();
if(s!=null) s.close();
if(con!=null) con.close();
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

