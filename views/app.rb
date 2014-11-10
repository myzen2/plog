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

# Afficher une tâche
get '/task/:id' do
  @task = Task.get(params[:id])
  erb :task
end

DataMapper.auto_upgrade!