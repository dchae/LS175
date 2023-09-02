require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before { @users = YAML.load_file('users.yaml') }

helpers do
  def count_interests(users)
    users.values.sum { |v| v[:interests].size }
  end
end

get '/' do
  redirect '/users'
end

get '/users' do
  @page_title = 'Index'
  @header = 'User Index'

  erb :index
end

get '/users/:user' do |user|
  @page_title = user
  @header = user
  @user = user.to_sym

  erb :user
end

not_found { erb :not_found }
