require 'sinatra'


get '/log' do
	@prénom = ''
	@nom = ''
	@log = ''
  erb :formulaire
end
get '/about' do
	erb :about
end