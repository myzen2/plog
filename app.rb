require 'sinatra'

get '/log' do
	prénom = ''
	nom = ''
	log = ''
  erb :formulaire

get '/about' do
	erb :about

end