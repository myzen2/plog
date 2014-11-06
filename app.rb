require 'sinatra'
require 'pry'


get '/formulaire' do
  erb :formulaire
end

get '/about' do
	erb :about
end

post '/formulaire' do
	@log = params[:log]
	redirect to '/about'
end


