require "sinatra"
require "sinatra/reloader"

require "tilt/erubis"

get "/" do
  @contents = File.readlines("data/toc.txt")
  @page_title = "Home"
  erb :home #, locals: { page_title: "Page Title" }
end

get "/chapter-1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @chapter= File.read("data/chp1.txt")

  erb :chapter
end

get /.+/ do
  "<h3>404 Page Not Found</h3>"
end