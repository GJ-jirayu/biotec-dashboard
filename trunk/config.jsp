
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%
String connectionURL="jdbc:mysql://10.226.202.114:3306/biotec_dwh";
String Driver="com.mysql.jdbc.Driver";
String User="root";
String Pass="bioteccockpit";
String Query="";

Connection conn=null;
ResultSet rs;
Statement st;

Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
st = conn.createStatement();

%>