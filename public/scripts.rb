puts "Desu"

@tasks = Element.id("tasks")

@number = 0;

def taskElement id,value
Element[%{
<div class="#{id}task task">
	<button>&#x2713;</button>
	<label>#{id}:</label>
	<span contenteditable="true">#{ value || "Nothing"}</span>
</div>
}]
end

def makeTask id,value
	e = taskElement id,value
	@tasks.append e
	
	span = e.find("span")
	span.on(:keypress) { |event|
		if(event.which == 13)
			span.blur
			false
		end
	}
	
	span.on(:blur) {
		if(span.text.empty?)
			e.remove
			HTTP.get "/remove/#{id}"
		end
		HTTP.get "/change/#{id}/#{span.text}"
	}
	
	butt = e.find("button");
	butt.on(:click) {
		e.remove
		HTTP.get "/remove/#{id}"
	}
end

Element.id("add").on(:click) do |event|
	makeTask @number,"Nothing"
	HTTP.get "/add/#{@number}"
	@number = @number+1;
end

Element.id("reload").on(:click) do |event|
	HTTP.get "/all" do |res|
		%x{#{@tasks}.empty()}
		res.json.each do |k,v|
			ki = k.to_i
			makeTask k,v
			@number = ki+1 if(ki > @number)
		end
	end
end

HTTP.get "/all" do |res|
	res.json.each do |k,v|
		ki = k.to_i
		makeTask k,v
		@number = ki+1 if(ki > @number)
	end
end