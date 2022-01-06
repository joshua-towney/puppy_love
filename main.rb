require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'
require 'pry'
require_relative 'dog.rb'

def logged_in?()
    if session[:user_id]
        return true
    else
        return false
    end
end

def current_user()
    conn = PG.connect(dbname: 'puppy_love')
    sql = "SELECT * FROM users WHERE id = #{session[:user_id]};"
    result = conn.exec(sql)
    user = result[0]
    conn.close
    return OpenStruct.new(user)
end

def db_query(sql, params = [])
    conn.PG.connect(dbname: 'puppy_love')
    result = conn.exec_params(sql, params)
    conn.close
    return result
end

def find_user_by_id(id)
    db_query('SELECT * FROM users WHERE id = $1', [id])
end

get '/' do
    'home'

    erb :index
end

get '/dogs' do 
    
    erb :all_dogs
end

get '/dogs/new' do
    
    erb :new
end

get '/dogs/:id' do 
    "Single dog" 
end

post '/dogs' do
end

get '/dogs/:id/edit' do
    "Edit dog details" 
end

put '/dogs/:id' do
end

delete '/dogs/:id' do
end

get '/login' do
    erb :login
end

post '/session' do

  email = params["email"]
  password = params["password"]

  conn = PG.connect(dbname: 'puppy_love')
  sql = "SELECT * from users WHERE email = '#{email}';"
  result = conn.exec(sql) 
  conn.close

  if result.count > 0 && BCrypt::Password.new(result[0]['password_digest']) == password 
   
    session[:user_id] = result[0]['id'] 

    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
    session[:user_id] = nil
    redirect '/login'
end
