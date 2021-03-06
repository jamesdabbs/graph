require 'sinatra'
require 'coffee-script'
require 'json'

require 'steffi'

def safe_eval cmd=''
  cmd = cmd.empty? ? 'famous meredith' : cmd
  method, *args = cmd.split ' '
  method = method.strip.to_sym
  if Steffi::Graph.methods(false).include?(method) && method != :dump
    args.map! { |a| Integer(a) rescue a }
    Steffi::Graph.send method, *args
  else
    raise "Unrecognized command: #{method}"
  end
end

get '/' do
  haml :index
end

get '/data.json' do
  Dir.chdir(File.expand_path '../data/', __FILE__) do
    begin
      safe_eval(params[:graph]).to_hash
    rescue => e
      { error:   true,
        type:    e.class,
        message: e.message }
    end.to_json
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
