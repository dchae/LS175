require 'sinatra'
require 'sinatra/reloader'

require 'tilt/erubis'

get '/' do
  @contents = File.readlines('data/toc.txt')
  @page_title = 'Home'
  erb :home #, locals: { page_title: "Page Title" }
end

get '/chapters/:number' do |n|
  @contents = File.readlines('data/toc.txt')
  @title = "Chapter #{n}: #{@contents[n.to_i - 1]}"
  @page_title = @title
  @chapter = File.read("data/chp#{n}.txt")

  erb :chapter
end

get '/show/:name' do |name|
  # name
  params[:name]
end

get /.+/ do
  '<h3>404 Page Not Found</h3>'
end
