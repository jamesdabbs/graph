require 'sinatra'
require 'coffee-script'
require 'json'

get '/' do
  haml :index
end

get '/data.json' do
  Dir.chdir(File.expand_path '../data/', __FILE__) do
    File.read params[:graph]
  end
end

get '/app.js' do
  content_type 'text/javascript'
  coffee :app
end

get '/public/:name.js' do |name|
  content_type 'text/javascript'
  File.read "public/#{name}.js"
end
