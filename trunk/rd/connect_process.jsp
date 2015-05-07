<%@ include file="config.jsp"%>
<%
try{
	if(!conn.isClosed()){
	out.print("ok for connect database");
	Query = "";
	rs=st.executeQuery(Query);
	
	}

}
catch(Exception ex){
out.print("Error"+ex);
}
%>