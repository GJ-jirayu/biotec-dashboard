<%@page contentType="text/html" pageEncoding="utf-8"%>
<%@page import="java.text.DecimalFormat" %>
<%@ include file="../config.jsp"%>
<%!
public static float Round(double Rval, int Rpl) {
  float p = (float)Math.pow(10,Rpl);
  Rval = Rval * p;
  float tmp = Math.round(Rval);
  return (float)tmp/p;
  }
%>
<%
String month=request.getParameter("month");
String year=request.getParameter("year");
//String month = "11";
//String year = "2012";

Query="CALL sp_budget_by_type(";
Query += year +"," + month +");";
rs = st.executeQuery(Query);
String resultSet = "";
int i = 0;
double sumPlanG1 = 0;
double sumResultG1 = 0;
String seriesPlanBarchart ="{\"series_center\": [{ \"name\": \"แผน\",\"data\": [";
String seriesResultBarchart =",{ \"name\": \"ผล\",\"data\": [";
String seriesBarchart = "";
String categoryBarchart = "{\"category_center\":[";
			//		 [ 
				//        {"category_center":["BIOTEC","MTEC","NECTEC","NANOTEC"]},
				//        {"series_center":[{"name":"IC Score","data":[0,0,0,0]},
				//        {"pie_sp_ic_score":[0,0,0,0]},
				//        {"sum_pie_sp_ic_score":0}
				//        ]
				// console.log(data[0]["category_center"]);
				 //   categories: [ "โครงการ" ," หน่วยงาน", "ครุภัณฑ์ ", "บุคลากร"]

				                /*  series: [{
                            name: "แผน",
                            data: [1, 5, 5, 3]
                        }, {
                            name: "ผล",
                            data: [2,3, 4, 6]
                        }]*/
while(rs.next()){
	if(i>0){
			seriesPlanBarchart += ",";
			seriesResultBarchart += ",";
			categoryBarchart += ",";
	}
		double Plan = rs.getDouble("plan");
		double Result = rs.getDouble("result");

		//DecimalFormat priceFormatter = new DecimalFormat("#0.00");
		//String PlanFormat = priceFormatter.format(Plan);
		//String PlanResult = priceFormatter.format(Result);

		String Type = rs.getString("type");
		seriesPlanBarchart += Round(Plan,2);
		seriesResultBarchart += Round(Result,2);
		categoryBarchart += "\""+Type+"\"";
		sumPlanG1 = sumPlanG1 + Plan;
		sumResultG1 = sumResultG1 + Result;
		i++;
}
seriesPlanBarchart += "]}";
seriesResultBarchart +="]}]}";
categoryBarchart += "]}";
seriesBarchart =  seriesPlanBarchart+seriesResultBarchart;
double percentG1 = (sumResultG1/sumPlanG1)*100;

Query="CALL sp_construction_budget(";
Query += year +"," + month +");";
//out.print(ParamYear + ParamMonth);
rs = st.executeQuery(Query);
double planG2 =0;
double resultG2 = 0;
double percentG2 = 0;
i=0;
	while(rs.next()){
		planG2 = (rs.getDouble("plan")/1000000);
		resultG2 = (rs.getDouble("result")/1000000);
		percentG2 = (resultG2/planG2)*100;
		//out.print("{\"gauge2\":\""+sum+"\",\"plan\":\""+Plan+"\",\"result\":\""+Result+"\"}");
	}
	//out.println(seriesBarchart);
out.print("[{\"gauge2\":\""+percentG2+"\",\"plang2\":\""+planG2+"\",\"resultg2\":\""+resultG2+"\"}]");
%>
