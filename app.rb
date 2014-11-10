require 'rubygems'
require 'sinatra'
require 'rubygems'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Task
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :completed_at, DateTime
end


get '/' do
  "I did it my way !"
end

get '/about' do
  erb :about
end

# Saisir une nouvelle tâche
get '/task/new' do
  erb :new
end

# Créer une nouvelle tâche
post '/task/create' do
  task = Task.new(:name => params[:name])
  if task.save
    status 201
    redirect '/task/' + task.id.to_s
  else
    status 412
    redirect '/tasks'
  end
end

# Afficher une tâche
get '/task/:id' do
  @task = Task.get(params[:id])
  erb :task
end

# Afficher toutes les tâches
get '/index' do
  @tasks = Task.all
  erb :index
end

# Modifier une tâche existante
get '/task/:id/edit' do
  @task = Task.get(params[:id])
  erb :edit
end

# Mettre à jour une tâche
put '/task/:id' do
  task = Task.get(params[:id])
  task.completed_at = params[:completed] ? Time.now : nil
  task.name = (params[:name])
  if task.save
    status 201
    redirect '/task/' + task.id.to_s
  else
    status 412
    redirect '/tasks'
  end
end

# Confirmer la suppression
get '/task/:id/delete' do
  @task = Task.get(params[:id])
  erb :delete
end

# Supprimer une tâche
delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect '/index'  
end

DataMapper.auto_upgrade!