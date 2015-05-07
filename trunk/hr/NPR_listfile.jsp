<%@page import="java.io.*" %> 
<%@page import="java.util.*" %> 
<%@ page language="java" import="net.sf.json.JSONArray" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- ฟังก์ชั่น Browse file บน server-->
        <%!  public void GetDirectory(String a_Path, Vector a_files, Vector a_folders) {
                File l_Directory = new File(a_Path);
                File[] l_files = l_Directory.listFiles();

                for (int c = 0; c < l_files.length; c++) {
                    if (l_files[c].isDirectory()) {
                        a_folders.add(l_files[c].getName());
                    } else {
                        a_files.add(l_files[c].getName());
                    }
                }
            }
        %> 
        <%
            Vector l_Files = new Vector(), l_Folders = new Vector();
			String LPath = "D:\\biserver-ce-3.8.0\\biserver-ce\\tomcat\\webapps\\pentaho\\biotec-dashboard\\archive";
            GetDirectory(LPath, l_Files, l_Folders);
			JSONArray arrayObj = new JSONArray();
			String filename = "";
            for (int a = 0; a < l_Files.size(); a++) {
				 filename = l_Files.elementAt(a).toString().replace(" ", "_");
				 arrayObj.add(filename);
            }
			out.println(arrayObj);
      
        %> 