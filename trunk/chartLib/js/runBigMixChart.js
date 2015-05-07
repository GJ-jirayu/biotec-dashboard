function gup( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}

//alert(gup('head'));

var texthead = 'Sale Amount' ;
	//texthead = 'Sale growth(%) : Overall' ;
	texthead = gup('head') ;
var chart01 = 
	{
	"graphset":[
		{
			"type":"mixed",
			"background-color":"#FFFFFF #CCCCCC",
			"stacked":"1",
			"chart":{
				"margin":"50 10 100 40"
			},
			"title" : {
				"text" : texthead ,
				"background-color":"#3399FF #3366FF",
				"font-color":"#FFFFFF",
				"font-size": 18,
  				"font-family": "Verdana",
				
				"bevel": true,
				"bevel-distance": 4,
				"bevel-angle": 50,
				"bevel-blur-x": 5,
				"bevel-blur-y": 5,
				"bevel-color": "navy"

			},
			"legend":{
				"background-color": "#FFFFFF",
				"border-width": "2px",
				"border-color": "#4C77B6",
				"margin":"400 20 50 40",
					
				"layout":"1x",
						"width": 740,
				"item":{
					"font-color":"#000000",
					"font-size": 18,
  				"font-family": "Verdana"
				}
			},
			"scale-x":{
				"values":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],
				"guide":{
					"line-width": 1,
					"alpha": 1
				},
				"tick":{
					"line-width": 0
				},
				"item":{
					"font-color":"#42426F",
					"font-size": 22,
  					"font-family": "Verdana",
				}
			},
			"scale-y":{
				"values":"0:100:20",
				"labels":["0","20","40","60","80","100"],
				//"line-color": "#8B8B7A",
				"guide":{
					//"line-color": "#8B8B7A",
					"line-width": 1,
					"alpha": 1
				},
				"tick":{
					"line-width": 5//,
					//"line-color": "#8B8B7A"
				},
				"item":{
					"font-color":"#42426F",
					"font-size": 18,
  					"font-family": "Verdana",
				}
			},
				
			"series":[
			
				{
					"type":"bar",
					"values":[20,35,67,47,58,43,65,43,58,79,70,55],
					"text":"Actual 11",
					"background-color":"#000099 #0000FF",
					"stacked":0,
						"value-box" : {
						"type" : "max",
						"text" : "%v",  //%v
						"text-align" : "center",
						"background-color": "#3366FF",
						"bevel": true,
						"color": "white",
						"font-size": 14,
  						"font-family": "Verdana"
						},

					 "labels" : [
									{
										"text" : "Holiday Spike",
										"hook" : "node:plot=1,index=15,offset-x=17,offset-y=10",
										"background-color":"red",
										"color": "black",
										"border-width":5, 
										"border-color":"red",
										"bold": true
										
									},
									{
										"text" : "Nice Jump",
										"hook" : "node:plot=0,index=3,offset-y=-15",
										"background-color":"#369", 
										"border-width":5, 
										"border-color":"#369", 
										"border-radius":10,
										"color": "white"
									}
								],

				},
				{
					"type":"line",
					"values":[30,39,48,49,52,50,51,54,54,55,56,58],
					"text":"Actual 10",
					"scales":"scale-x,scale-y",
					"stacked":0,
					"line-color": "#00FF00",
					"marker":{
						"type": "cross",
						"size":3
					},
					"tooltip-text":"%v%"
				},
				{
					"type":"line",
					"values":[50,52,56,57,57,58,58,60,62,62,64,65],
					"text":"Target",
					"scales":"scale-x,scale-y",
					"line-color": "#FF3300",
					"stacked":0,
					"marker":{
						"type": "cross",
						"size":3,
						"background-color": "red",
						"border-color": "#4F81BD"
				},
					
				
				"tooltip-text":"%v%"
				}]
			}]


			

		};


 

function ShowPicture(id,Source) {
			if (Source=="1"){
			if (document.layers) document.layers[''+id+''].visibility = "show"
			else if (document.all) document.all[''+id+''].style.visibility = "visible"
			else if (document.getElementById) document.getElementById(''+id+'').style.visibility = "visible"
			}
			else
			if (Source=="0"){
			if (document.layers) document.layers[''+id+''].visibility = "hide"
			else if (document.all) document.all[''+id+''].style.visibility = "hidden"
			else if (document.getElementById) document.getElementById(''+id+'').style.visibility = "hidden"
			}

			msg = document.getElementById(''+id+'');
			var x = (window.innerWidth / 2) - (msg.offsetWidth / 2);
			var y = (window.offsetHeight / 2) - (msg.offsetHeight / 2);              
			msg.style.top = y;
			msg.style.left = x;
			// msg.style.display = "block";\

}


window.onload = function(){
	zingchart.render({
		id 				: 'showGraph',
		data 		    : chart01,
		width	 		: 800,
		height 			: 450
		
	});

}
