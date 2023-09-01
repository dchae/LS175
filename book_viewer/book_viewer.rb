require 'sinatra'
require 'sinatra/reloader'

require 'tilt/erubis'

before { @contents = File.readlines('data/toc.txt') }

helpers do
  def in_paragraphs(text)
    text
      .split(/\n{2,}/)
      .map
      .with_index do |par, i|
        "<p class='content-paragraph' id='paragraph-#{i + 1}'>#{par}</p>"
      end
      .join("\n")
  end
end

get '/' do
  @page_title = 'Home'

  erb :home #, locals: { page_title: "Page Title" }
end

get '/chapters/:number' do |n|
  pass if n.to_i > @contents.size

  @title = "Chapter #{n}: #{@contents[n.to_i - 1]}"
  @page_title = @title
  @chapter = File.read("data/chp#{n}.txt")

  erb :chapter
end

not_found do
  # "<h3>404 Page Not Found</h3><br><a href='/'>return home</a>"
  redirect '/'
end


def search_for(term)
  res = Hash.new { |h, k| h[k] = [] }
  return res unless term && term.size > 0

  # (1..@contents.size).filter do |n|
  #   /#{term.split.join('\s+')}/i =~
  #     @contents[n - 1] + ' ' + File.read("data/chp#{n}.txt")
  # end

  regex_term = term.split.join('\s+')

  (1..@contents.size).each_with_object(res) do |chp, results|
    to_search =
      [@contents[chp - 1]] + File.read("data/chp#{chp}.txt").split(/\n{2,}/)
    to_search.each_with_index do |par, par_num|
      if /#{regex_term}/i =~ par
        results[chp] << [
          par_num,
          par.gsub(/#{regex_term}/) do |phrase|
            "<strong>#{phrase}</strong>"
          end,
        ]
      end
    end
  end
end

get '/search' do
  @term = params[:query]
  @results = search_for(@term)

  erb :search
end
