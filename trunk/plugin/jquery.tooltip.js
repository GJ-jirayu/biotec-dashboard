jQuery.fn.tooltip = function(option){
	//alert("hello plugin");
	var optionDefault={
		//id:this.id,
		//txt:$(this).text(),
		txt:$("Empty String!"),
		color:"black"
	}
	var ex = jQuery.extend(optionDefault,option);

return	$(this).hover(function(e){
	var thisID = this.id;
	var $left = e.pageX+10;
	var $top = e.pageY+10;
	var classT = ".tootip#"+thisID;
		if($.trim($(classT).text())!=""){
			$(classT).css({"left":$left+"px","top":$top+"px"}).show();
		}
	},function(){
	$(".tootip").hide();
	});
	
}