<style>

.ball{
       width:20px;
       height:20px;border-radius:100px; 
       float:left;
}
</style>

 <%! 
    String getColorBall(int position,String color)
    {
		String ballScoll = "";
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
      return ballScoll;
    }
    %>

    <%
    out.println("ballScoll = " + getColorBall(2,"#33ff23"));
    %>