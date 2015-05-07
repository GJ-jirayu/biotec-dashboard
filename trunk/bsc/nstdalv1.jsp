<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@ include file="../config.jsp"%>
<%! 
    String getColorBall(int position,String color,int id)
    {
		String ballScoll = "";
               if(position==1){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==2){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:"+color+"></div>";
                       ballScoll+="<div id="+id+"  class=ball style=background-color:#cccccc></div></div>";
               }else if(position==3){
                       ballScoll+="<div id=visualball style='margin-left:13px;margin-top:10px'><div id="+id+"  class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:#cccccc></div>";
                       ballScoll+="<div id="+id+"   class=ball style=background-color:"+color+"></div></div>";
               }
      return ballScoll;
    }
 %>
<% /*
	out.print("[{					  \"Field0\": \"2\",                      \"Field1\": \"Test\",                      \"Field3\": \"2\",					  \"Field4\": \"ล้านบาท\",                     \"Field5\": \"25\",					 \"Field5_1\":\"1,500 (ล้านบาท)\",					  					  \"Field6\": \"0.40\",                  \"Field7\": \"50\",	 \"Field7_1\": \"t\",	  \"Field9\": \"flsas\" }]"); */


//=================================== DataJ2 Start===============================================
String kpi_id = request.getParameter("kpi_id");   //Parameter to get query
String owner_id = request.getParameter("owner_id"); //Parameter to get query
String ParamYear  = request.getParameter("year");
String ParamMonth  = request.getParameter("month");
String ParamOrg  = request.getParameter("name");

Query="CALL sp_child_kpi_list(";
Query += ParamYear+"," + ParamMonth +",\""+ParamOrg+"\","+ owner_id  + "," +   kpi_id+")";
rs = st.executeQuery(Query);
String tableFun2 = "[";
int i=0;

while(rs.next()){
	if(i>0){
		tableFun2 += ",";
	}
	String kpi_code = rs.getString("krs.kpi_code");
	String lead_kpi = rs.getString("lead_kpi") ;
	tableFun2 += "{\"Field1\": \"<div class=tootip id="+(i+1000)+"><b>"+rs.getString("kpi_comment")+"</b></div><div class=kpiN id="+(i+1000)+">"+kpi_code+"</div>";
	tableFun2 += lead_kpi;
//	out.print("<div class=\"tootip\" id=\""+(i+1000)+"\"><b>"+rs.getString("kpi_comment")+"</b></div>");


	//=============Get Url with Details Button Start============
	String urlpage = rs.getString("url");
	if(urlpage == null || urlpage.equals(""))
	{
		tableFun2 +="";
	}
	else
	{
		tableFun2 +=" <a href="+urlpage+" target=_blank><button class=k-button>รายละเอียด</button></a> ";
	}
	tableFun2 += "\", ";

	//=============Get Url with Details Button End============
	String target_value = rs.getString("target_value");
	tableFun2 += "\"Field3\": \"";
	tableFun2 += "<div id=textR>"+ target_value +"</div> \",";

	String kpi_uom = rs.getString("kpi_uom");
	tableFun2 += "\"Field4\": \"";
	tableFun2 += kpi_uom + "\",";

	String kpi_weighting = rs.getString("kpi_weighting");
	tableFun2 += "\"Field5\": \"";
	tableFun2 +=  "<div id=textR>"+kpi_weighting +"</div> \",";

	String baseline = rs.getString("baseline") ;
	tableFun2 += "\"Field5_1\": \"";
	tableFun2 += baseline + "\",";

	String performance_value = rs.getString("performance_value") ;
	tableFun2 += "\"Field6\": \"";
	tableFun2 += "<div id=textR>"+ performance_value +"</div> \",";

//=================================Color Start=========================
	String performance_percentage = rs.getString("performance_percentage");

	Statement st1;
	ResultSet  rs1;
	String QueryColor = "";
	st1 = conn.createStatement();
	QueryColor="CALL sp_color_code(";
	QueryColor += performance_percentage+")";
	rs1 = st1.executeQuery(QueryColor);

	tableFun2 += "Field7: \"";
	tableFun2 += "<center><div id='target'><div id='percentage'>" + performance_percentage +"</div></div></center> ";
	while(rs1.next())
	{
		int positionBall =  rs1.getInt("color_order");
		String colorCode = rs1.getString("color_code");
					Statement st2;
			ResultSet  rs2;
			String QueryColorRange = "";
			st2 = conn.createStatement();
			QueryColorRange="CALL sp_color_range;";
			rs2 = st2.executeQuery(QueryColorRange);
			tableFun2 +="<div class=commentball id="+(i+3000)+">";
			while(rs2.next()){
					tableFun2 += rs2.getString("description")+"<br />";
				}
					tableFun2 +="</div>";

		tableFun2 += getColorBall(positionBall,colorCode,(i+3000));

	}
	tableFun2 += "\",";

	String kpi_wavg_score = rs.getString("kpi_wavg_score");
	tableFun2 += "Field7_1: \"";
	tableFun2 += "<div id=textR>"+ kpi_wavg_score +"</div> \",";

	//===============GraphLine Start=====================
	tableFun2 += "\"Field9\": \"<span class=inlinesparkline_sub>";
	
	//Statement st2;
	//ResultSet  rs2;
	String QueryGraph = "";
	String ChildKpiID = rs.getString("child_kpi_id");
	String Childowner_id = rs.getString("prk.child_owner_id");
	//out.print(Childowner_id+"<br>");
	//st2 = conn.createStatement();
	
	QueryGraph = "CALL sp_child_kpi_trend(";
	QueryGraph += ParamYear+"," + ParamMonth +","+Childowner_id+","+ChildKpiID+")";
	rs1 = st1.executeQuery(QueryGraph);
	while(rs1.next())
	{
				String value = rs1.getString("value_list");
				tableFun2 += ""+value+"";
	}
	tableFun2 += "</span>\"}";
	//===============GraphLine End=====================
	i++;
}
tableFun2 += "]";
tableFun2 = tableFun2.replace("\n","");
out.print(tableFun2);
				  %>