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

#get '/about' do
#  erb :about
#end
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

DataMapper.auto_upgrade!