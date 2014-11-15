require 'sinatra'
require 'data_mapper'
require 'pry'
require 'rubygems'
require 'better_errors'



DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/plog.db")


class Log
include DataMapper::Resource
property :id, Serial
property :author, Text
property :message, Text
property :created_at, DateTime
end



DataMapper.finalize

get '/nouveau' do
  @logs = Log.all(:order => [ :id.desc], :limit => 20)
  erb :nouveau
end

post '/nouveau' do
  @log = Log.create(
  :author => params[:author],
  :message => params[:message], :created_at => Time.now)
redirect '/nouveau'
end

# page d'accueil
get '/accueil' do
  erb :accueil
end

get '/' do
  redirect '/accueil'
end

#supprimer un message
get '/delete/:id' do
  @log = Log.first(:id => params[:id])
  erb :delete
end

delete '/delete/:id' do
  if params.has_key?("ok")
  log = Log.first(:id => params[:id])
  log.destroy
  redirect '/nouveau'
else
  redirect '/nouveau'
  end
end

#Modifier un message
get '/modify/:id' do
  @log = Log.first(:id => params[:id])
  erb :modify
end

post '/modify/:id' do
  log = Log.first(:id => params[:id])
  log.update(
  :message => params[:message], :created_at => Time.now) 
  redirect '/nouveau'
end

# Page visiteur
get '/visiteur' do
  @logs = Log.all(:order => [ :id.desc], :limit => 10)
  erb :visiteur
end

#identification
set :username, 'emma'
set :password, 'naouelle'
set :token, 'emmanaouelle'

get '/identification' do
  erb :identification
end

post '/identification' do
  if params['username'] == settings.username && params['password'] == settings.password
  response.set_cookie(settings.username,settings.token)
  redirect '/nouveau'
  elsif params['username'] != settings.username && params['password'] != settings.password
  "code utilisateur ou mot de passe incorrect"
  elsif redirect '/identification'
  else
  redirect '/nouveau'
  end
end

get '/logout' do
  response.set_cookie(settings.username, false) ;
  redirect '/'
end

DataMapper.auto_upgrade!