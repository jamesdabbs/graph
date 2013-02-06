require 'sinatra'
require 'coffee-script'

require 'steffi'

get '/' do
  haml :index
end

get '/data.json' do
  Dir.chdir('data') do
    begin
      cmd = params[:graph].empty? ? 'famous :meredith' : params[:graph]
      Steffi::Graph.instance_eval(cmd).d3.to_json
    rescue => e
      { error:   true,
        type:    e.class,
        message: e.message }.to_json
    end
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
