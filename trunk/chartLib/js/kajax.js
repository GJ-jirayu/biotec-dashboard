//alert('KA');

function newXmlHttp(){
var xmlhttp = false;

try{
xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
}catch(e){
try{
xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
}catch(e){
xmlhttp = false;
}
}

if(!xmlhttp && document.createElement){
xmlhttp = new XMLHttpRequest();
}
return xmlhttp;
}


function ajaxdata( url ){
var id = "td1";
//var url = "index.jsp"

xmlhttp = newXmlHttp();
xmlhttp.open("GET", url, false);
xmlhttp.send(null);

return xmlhttp.responseText;;
//document.getElementById("numtxt").innerHTML = xmlhttp.responseText;
}
