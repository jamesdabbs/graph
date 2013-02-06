require 'sinatra'
require 'coffee-script'

require 'steffi'

get '/' do
  haml :index
end

get '/data.json' do
  begin
    Steffi::Graph.instance_eval(params[:graph]).d3.to_json
  rescue => e
    { error:   true,
      type:    e.class,
      message: e.message }.to_json
  end
end

get '/app.js' do
  content_type "text/javascript"
  coffee :app
end

get '/public/:name.js' do |name|
  content_type "text/javascript"
  File.read "public/#{name}.js"
end
