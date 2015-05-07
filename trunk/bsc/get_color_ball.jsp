<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver="com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";

Connection conn=null;
ResultSet rs;
Statement st;

Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
st = conn.createStatement();

%>
<% 
out.print("hello world jsp");

%>
<style>

.ball{
	width:20px;
	height:20px;border-radius:100px; 
	float:left;
}
</style>
<script src="http://code.jquery.com/jquery-1.8.1.js"></script>
<script>
	$(document).ready(function(){
	var ballScoll="";
	var getColorBall = function(position,color){
		if(position==1){
			ballScoll+="<div id=\"ball1\"  class=\"ball\" style=\"background-color:"+color+"\"></div>";
			ballScoll+="<div id=\"ball2\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";
			ballScoll+="<div id=\"ball3\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";

		}else if(position==2){
			ballScoll+="<div id=\"ball1\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";
			ballScoll+="<div id=\"ball2\"  class=\"ball\" style=\"background-color:"+color+"\"></div>";
			ballScoll+="<div id=\"ball3\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";
		}else if(position==3){
			ballScoll+="<div id=\"ball1\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";
			ballScoll+="<div id=\"ball2\"  class=\"ball\" style=\"background-color:#cccccc\"></div>";
			ballScoll+="<div id=\"ball3\"  class=\"ball\" style=\"background-color:"+color+"\"></div>";
		}
	}

	getColorBall(1,"#f1f1f1");
	});
</script>
<div id="ball1"  class="ball" style="background-color:#f1f1f1"></div><div id="ball2"  class="ball" style="background-color:#cccccc"></div><div id="ball3"  class="ball" style="background-color:#cccccc"></div>