require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'pry'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Task
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :User, String
  property :completed_at, DateTime

 def completed?
    true if completed_at
  end

  def self.completed
    all(:completed_at.not => nil)
  end
  def link
    "<a href=\"task/#{self.id}\">#{self.name}</a>"
  end

end

# Créer une nouvelle tâche
post '/task/create' do
  task = Task.new(:name => params[:name])

  if task.save
    status 201
    redirect '/'
  else
    status 412
    redirect '/'
  end
end



# Modifier une tâche existante
get '/task/:id' do
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
    redirect '/'
  else
    status 412
    redirect '/'
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
  redirect '/'  
end

# Afficher toutes les tâches
get '/' do
  @tasks = Task.all
    erb :index
end

get '/about' do
  erb :about
end

DataMapper.auto_upgrade!
