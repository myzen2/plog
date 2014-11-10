require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Task
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :completed_at, DateTime
end

DataMapper.auto_upgrade!
