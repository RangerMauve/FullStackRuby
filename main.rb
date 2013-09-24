require "sinatra"
require "opal/jquery"
require "json"

set :port, 80
set :bind, '0.0.0.0'

get "/" do
	redirect "/main.html"
end

opal_lib = Opal::Builder.build('opal')
get "/opal.js" do
	content_type "text/javascript"
	opal_lib
end

opal_jquery_lib = Opal::Builder.build("opal-jquery")
get "/opal-jquery.js" do
	content_type "text/javascript"
	opal_jquery_lib
end

get "/scripts.js" do
	content_type "text/javascript"
	raw_script = File.read("./public/scripts.rb")
	parsed_script = Opal.parse(raw_script);
	parsed_script
end

messages = Hash.new

get "/all" do
	content_type :json
	messages.to_json
end

get "/add/:id" do |id|
	messages[id]="Nothing"
	true
end

get "/remove/:id" do |id|
	messages.delete id
	true
end

get "/change/:id/:to" do |id,to|
	messages[id]=to;
	true
end