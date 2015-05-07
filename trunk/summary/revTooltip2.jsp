<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%
String bsc_id=request.getParameter("bsc_id");
//String bsc_id= "2";
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver = "com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";
String center_name="";
Connection conn= null;
Class.forName(Driver).newInstance();
conn = DriverManager.getConnection(connectionURL,User,Pass);

Statement st;
ResultSet  rs;
st = conn.createStatement();
Query="select distinct bsc_rev_name from dim_gl where bsc_rev_id="+bsc_id+";";
rs = st.executeQuery(Query);
String tooltip = "";
while(rs.next()){
		tooltip = rs.getString("bsc_rev_name");
}
out.print(tooltip);
//out.print("get");

%>