function {0}(id, callback){
	var context = document.getElementById(id);
    this.callback = function() { return context[callback].apply(context, arguments) };
    this.run = function(){  	
        var elements = document.getElementsByTagName('a');
        for(var i = 0, length = elements.length; i < length; i++){
            var result = this.callback(elements[i].href);
            if(result != null)
                elements[i].href = result;
        }
    }
}
