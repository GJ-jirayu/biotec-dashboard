<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver = "com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";
String center_name="";
Connection conn= null;
Statement st;
ResultSet rs;
Class.forName(Driver).newInstance();
conn = DriverManager.getConnection(connectionURL,User,Pass);
%>