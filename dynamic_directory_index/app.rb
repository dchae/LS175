require 'sinatra'
require "sinatra/reloader"

require "tilt/erubis"


get "/" do
  @descending = params["descending"] == "true"
  @sort_button = "Z-A"; @sort_button.reverse! if @descending

  dir = "public"
  @page_title = "Index"
  @public_index = Dir.children(dir).select { |f| File.file?("#{dir}/#{f}") }.sort
  @public_index.reverse! if @descending
  erb :index
end

get '/:filename' do |f|
  p f
  pass unless File.file?("public/#{f}")
  send_file f
end

get '*' do 
  erb :not_found
end