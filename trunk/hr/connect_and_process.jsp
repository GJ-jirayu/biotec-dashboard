<%@page contentType="text/html" pageEncoding="utf-8"%>
<!--<meta http-equiv="Content-type" content="text/html; charset=utf-8">-->
<%@page import="java.sql.*" %> 
<%@page import="java.io.*" %> 
<%@page import="java.lang.*"%> 
<%
/*
-- biotec_dwh --
Type: MYSQL
Server: 10.226.202.114
database: biotec_dwh
user: root
pass: bioteccockpit
*/
// Jsp  Server-side
String connectionURL="jdbc:mysql://localhost:3306/biotec_dwh";
String Driver = "com.mysql.jdbc.Driver";
String User="root";
String Pass="root";
String Query="";
String center_name="";
Connection conn= null;



Statement st;
ResultSet rs;

String center_th_shortname1="";
String shortname="";


/*
try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_center(2012,11);";
		rs = st.executeQuery(Query);

		center_th_shortname1+="[";
		Integer i =1 ;
		while(rs.next()){
		//                           [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		center_th_shortname1+="{category:";
	
		center_th_shortname1+= "\""+rs.getString("center_th_shortname") +"\"";
		center_th_shortname1+= ",value:10";
		center_th_shortname1+="}";
		}else{
		center_th_shortname1+=",{category:";
	
		center_th_shortname1+= "\""+rs.getString("center_th_shortname") +"\"";
		center_th_shortname1+= ",value:10";
		center_th_shortname1+="}";
		}
		
	i++;
		}
		center_th_shortname1+="]";
		//out.println(center_name);
		out.print(center_th_shortname1);
		conn.close();
	}
}
catch(Exception ex){
out.println("Error"+ex);
}
*/
//sp_emp_by_employ_type
/*
String sp_emp_by_employ_type ="";

String ParamYear="2012";
String ParamMonth="11";
String ParamOrg="\"ศอ.\"";

try{
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_employ_type("+ParamYear+","+ParamMonth+","+ParamOrg+");";
		rs = st.executeQuery(Query);
		sp_emp_by_employ_type+="[";
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sp_emp_by_employ_type+="{category:";
	
		sp_emp_by_employ_type+= "\""+rs.getString("employ_type") +"\"";
		sp_emp_by_employ_type+= ",value:"+rs.getString("total_employee") ;
		sp_emp_by_employ_type+="}";
		}else{
		sp_emp_by_employ_type+=",{category:";
	
		sp_emp_by_employ_type+= "\""+rs.getString("employ_type") +"\"";
		sp_emp_by_employ_type+= ",value:"+rs.getString("total_employee");
		sp_emp_by_employ_type+="}";
		}
		
	i++;
		}
		sp_emp_by_employ_type+="]";
		//out.println(center_name);
		out.println(sp_emp_by_employ_type);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error</font>"+ex);
}

*/


//sp_emp_by_education_level_group
/*
String sp_emp_by_education_level_group ="";
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_education_level_group(2012,11,\"ศจ.\");";
		rs = st.executeQuery(Query);
		sp_emp_by_education_level_group+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	
		sp_emp_by_education_level_group+="{category:";
	
		sp_emp_by_education_level_group+= "\""+rs.getString("education_level_group") +"\"";
		sp_emp_by_education_level_group+= ",value:"+rs.getString("total_employee") ;
		sp_emp_by_education_level_group+="}";
		}else{
		sp_emp_by_education_level_group+=",{category:";
	
		sp_emp_by_education_level_group+= "\""+rs.getString("education_level_group") +"\"";
		sp_emp_by_education_level_group+= ",value:"+rs.getString("total_employee");
		sp_emp_by_education_level_group+="}";
		}
		
	i++;
		}
		sp_emp_by_education_level_group+="]";
		out.println("-------------------------------------------------------");
		out.println("sp_emp_by_education_level_group"+sp_emp_by_education_level_group);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_education_level_group</font>"+ex);
}
*/


//############################  sp_emp_by_job_family  Start ############################ //
/*
String sp_emp_by_job_family ="";
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_job_family(2012,11,\"ศจ.\");";
		rs = st.executeQuery(Query);
		sp_emp_by_job_family+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	
		sp_emp_by_job_family+="{category:";
	
		sp_emp_by_job_family+= "\""+rs.getString("job_family") +"\"";
		sp_emp_by_job_family+= ",value:"+rs.getString("total_employee") ;
		sp_emp_by_job_family+="}";
		}else{
		sp_emp_by_job_family+=",{category:";
	
		sp_emp_by_job_family+= "\""+rs.getString("job_family") +"\"";
		sp_emp_by_job_family+= ",value:"+rs.getString("total_employee");
		sp_emp_by_job_family+="}";
		}
		
	i++;
		}
		sp_emp_by_job_family+="]";
		out.println("-------------------------------------------------------");
		out.println("sp_emp_by_job_family"+sp_emp_by_job_family);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_job_family</font>"+ex);
}
*/
//############################  sp_emp_by_job_family  End ############################ //



//############################  sp_emp_by_function_type  Start ############################ //
/*
String sp_emp_by_function_type ="";
Integer sum_emp_by_function_type=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_emp_by_function_type(2012,11,\"ศจ.\");";
		rs = st.executeQuery(Query);
		sp_emp_by_function_type+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sum_emp_by_function_type+=rs.getInt("total_employee") ;
		sp_emp_by_function_type+="{category:";
	
		sp_emp_by_function_type+= "\""+rs.getString("function_type") +"\"";
		sp_emp_by_function_type+= ",value:"+rs.getString("total_employee") ;
		sp_emp_by_function_type+="}";
		}else{
		sum_emp_by_function_type+=rs.getInt("total_employee") ;
		sp_emp_by_function_type+=",{category:";
		sp_emp_by_function_type+= "\""+rs.getString("function_type") +"\"";
		sp_emp_by_function_type+= ",value:"+rs.getString("total_employee");
		sp_emp_by_function_type+="}";
		}
		
	i++;
		}
		sp_emp_by_function_type+="]";
		out.println("-------------------------------------------------------");
		out.println("sp_emp_by_function_type"+sp_emp_by_function_type);
		out.println("sum_emp_by_function_type"+sum_emp_by_function_type);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_emp_by_function_type</font>"+ex);
}

//############################  sp_emp_by_function_type  End ############################ //

*/
//############################  sp_hr_expense  Start ############################ //
/*
String sp_hr_expense ="";
Integer sum_hr_expense=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_hr_expense(2012,11,\"สวทช\");";
		rs = st.executeQuery(Query);
		sp_hr_expense+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	  
		sp_hr_expense+="{category:";
	
		sp_hr_expense+= "\""+rs.getString("hr_group_name") +"\"";
		sp_hr_expense+= ",value:"+rs.getString("total_employee") ;
		sum_hr_expense+=rs.getInt("total_employee");
		sp_hr_expense+="}";
		}else{
		sp_hr_expense+=",{category:";
	
		sp_hr_expense+= "\""+rs.getString("hr_group_name") +"\"";
		sp_hr_expense+= ",value:"+rs.getString("total_employee");
		sp_hr_expense+="}";
		sum_hr_expense+=rs.getInt("total_employee");
		}
		
	i++;
		}
		sp_hr_expense+="]";
		out.println("-------------------------------------------------------");
		out.println("sum_hr_expense"+sum_hr_expense);
		out.println("sp_hr_expense"+sp_hr_expense);
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_hr_expense</font>"+ex);
}
*/
//############################  sp_hr_expense  End ############################ /
//                                                                           NPR                                                                           #
//############################ pie sp_npr_by_center  Start ######################### /
/*
String sp_npr_by_center ="";
Integer sum_npr_by_center=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_center(2012,11);";
		rs = st.executeQuery(Query);
		sp_npr_by_center+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
	  
		sp_npr_by_center+="{category:";
	
		sp_npr_by_center+= "\""+rs.getString("hr_group_name") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total_employee") ;
		sum_npr_by_center+=rs.getInt("total_employee");
		sp_npr_by_center+="}";
		}else{
		sp_npr_by_center+=",{category:";
	
		sp_npr_by_center+= "\""+rs.getString("hr_group_name") +"\"";
		sp_npr_by_center+= ",value:"+rs.getString("total_employee");
		sp_npr_by_center+="}";
		sum_npr_by_center+=rs.getInt("total_employee");
		}
		
	i++;
		}
		sp_npr_by_center+="]";
		out.println("-------------------------------------------------------");
		out.println("sum_npr_by_center"+sum_npr_by_center);
		out.println("sp_npr_by_center"+sp_npr_by_center);
		out.println("-------------------------------------------------------");
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_center</font>"+ex);
}
*/
//############################pie  sp_npr_by_center  End ############################ /

//############################bar  sp_npr_by_center_drilldown  Start ############################ /
/*
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
		Query="CALL sp_npr_by_center_drilldown(2012,11,'สวทช.')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_center_using+="[";
		series_job_center+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_center=rs.getString("npr_list");
				categoryAxis_npr_center_array=categoryAxis_npr_center.split(",");
				series_job_center+="{name:"+"\""+rs.getString("job_type")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_center_array.length; j++){
					if(j==0){
					categoryAxis_npr_center_using+="\""+categoryAxis_npr_center_array[j]+"\"";
					}else{
					categoryAxis_npr_center_using+=",\""+categoryAxis_npr_center_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_center+=",{name:"+"\""+rs.getString("job_type")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_center_using+="]";
	series_job_center+="]";
	
	//Success fully Start
	out.println(categoryAxis_npr_center_using+"<br>");
	out.println(series_job_center+"<br>");
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
/*
//############################bar  sp_npr_by_center  End ############################ /

//############################ pie sp_npr_by_type  Start ######################### /
/*
String sp_npr_by_type ="";
Integer sum_npr_by_type=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_type(2012,09);";
		rs = st.executeQuery(Query);
		sp_npr_by_type+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){

		sp_npr_by_type+="{category:";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",value:"+rs.getString("total_type") ;
		sum_npr_by_type+=rs.getInt("total_type");
		sp_npr_by_type+="}";

		}else{
		sp_npr_by_type+=",{category:";
		sp_npr_by_type+= "\""+rs.getString("npr_type") +"\"";
		sp_npr_by_type+= ",value:"+rs.getString("total_type");
		sp_npr_by_type+="}";
		sum_npr_by_type+=rs.getInt("total_type");
		}
		
	i++;
		}
		sp_npr_by_type+="]";
		out.println("-------------------------------------------------------");
		out.println("sum_npr_by_type"+sum_npr_by_type);
		out.println("sp_npr_by_type"+sp_npr_by_type);
		out.println("-------------------------------------------------------");
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_type</font>"+ex);
}
*/
//############################ pie sp_npr_by_type  End ############################ /

//############################bar  sp_npr_by_type_drilldown  Start ############################ /

String categoryAxis_npr_type = "";
String[] categoryAxis_npr_type_array;
String categoryAxis_npr_type_using="";

String series_job_type = "";
String series_job_type_array = "";
String series_job_type_using = "";

try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_type_drilldown(2012,11,'สวทช.','นักวิจัยร่วมวิจัย')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_type_using+="[";
		series_job_type+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_type=rs.getString("npr_list");
				categoryAxis_npr_type_array=categoryAxis_npr_type.split(",");
				series_job_type+="{name:"+"\""+rs.getString("npr_country_group")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_type_array.length; j++){
					//out.println(categoryAxis_npr_type_array[j]+"<br>");
					if(j==0){
					categoryAxis_npr_type_using+="\""+categoryAxis_npr_type_array[j]+"\"";
					}else{
					categoryAxis_npr_type_using+=",\""+categoryAxis_npr_type_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_type+=",{name:"+"\""+rs.getString("npr_country_group")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_type_using+="]";
	series_job_type+="]";
	
	//Success fully Start
	out.println(categoryAxis_npr_type_using+"<br>");
	out.println(series_job_type+"<br>");
	//Success fully Stop
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_type_drilldown</font>"+ex);
}

//############################bar  sp_npr_by_type_drilldown  End ############################ /

//############################ pie sp_npr_by_country_group  Start ######################### /
/*
String sp_npr_by_country_group ="";
Integer sum_npr_by_country_group=0;
try{
	//out.println("---------------------------------------------"+i);
Class.forName(Driver).newInstance();
conn=DriverManager.getConnection(connectionURL,User,Pass);
	if(!conn.isClosed()){
		st = conn.createStatement();
		Query="CALL sp_npr_by_country_group(2012,11);";
		rs = st.executeQuery(Query);
		sp_npr_by_country_group+="[";
		Integer i =1;
		while(rs.next()){
		//Format  [{category: "ศจ.",value: 10,color:"#6C2E9B" }]
		if(i==1){
		sp_npr_by_country_group+="{category:";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",value:"+rs.getString("total_employee") ;
		sum_npr_by_country_group+=rs.getInt("total_employee");
		sp_npr_by_country_group+="}";

		}else{
		sp_npr_by_country_group+=",{category:";
		sp_npr_by_country_group+= "\""+rs.getString("npr_country_group") +"\"";
		sp_npr_by_country_group+= ",value:"+rs.getString("total_employee");
		sp_npr_by_country_group+="}";
		sum_npr_by_country_group+=rs.getInt("total_employee");
		}
		
	i++;
		}
		sp_npr_by_country_group+="]";
		out.println("-------------------------------------------------------");
		out.println("sum_npr_by_country_group"+sum_npr_by_country_group);
		out.println("sp_npr_by_country_group"+sp_npr_by_country_group);
		out.println("-------------------------------------------------------");
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_country_group</font>"+ex);
}
*/
//############################pie  sp_npr_by_country_group  End ############################ /
//############################bar  sp_npr_by_country_group_drilldown  Start ############################ /
/*
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
		Query="CALL sp_npr_by_country_group_drilldown(2012,11,'สวทช.')";
		rs = st.executeQuery(Query);
		Integer i=0;
		categoryAxis_npr_country_group_using+="[";
		series_job_country_group+="[";
		while(rs.next()){
			if(i==0){
				categoryAxis_npr_country_group=rs.getString("working_range_list");
				categoryAxis_npr_country_group_array=categoryAxis_npr_country_group.split(",");
				series_job_country_group+="{name:"+"\""+rs.getString("npr_status")+"\","+"data:["+rs.getString("total_list")+"]}";
				for(int j=0; j< categoryAxis_npr_country_group_array.length; j++){
					if(j==0){
					categoryAxis_npr_country_group_using+="\""+categoryAxis_npr_country_group_array[j]+"\"";
					}else{
					categoryAxis_npr_country_group_using+=",\""+categoryAxis_npr_country_group_array[j]+"\"";
					}//if
				}//for
			}else{//if
			series_job_country_group+=",{name:"+"\""+rs.getString("npr_status")+"\","+"data:["+rs.getString("total_list")+"]}";
			}
		i++;
		}//while
	categoryAxis_npr_country_group_using+="]";
	series_job_country_group+="]";
	
	//Success fully Start
	out.println(categoryAxis_npr_country_group_using+"<br>");
	out.println(series_job_country_group+"<br>");
	//Success fully Stop
		conn.close();
	}
}
catch(Exception ex){
out.println("<font color='red'>Error sp_npr_by_country_group_drilldown</font>"+ex);
}
*/
//############################bar  sp_npr_by_country_group_drilldown  End ############################ /
%>
