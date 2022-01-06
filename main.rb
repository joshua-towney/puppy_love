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

    conn = PG.connect(dbname: 'puppy_love')
    sql = "SELECT * FROM dogs ORDER BY id"
    result = conn.exec(sql)
    conn.close
    
    erb :all_dogs, locals: {
        dogs: result
    }
end

get '/dogs/new' do
    
    erb :new
end

get '/dogs/:id' do 
    
    dog_id = params['id']

    conn = PG.connect(dbname: 'puppy_love')
    sql = "SELECT * FROM dogs WHERE id = '#{dog_id}';"
    result = conn.exec(sql)
    dog = result[0]

    conn.close

    erb :show_dog, locals: {
        dog: dog
    }
end

post '/dogs' do

    sql = "INSERT INTO dogs (name, image_url, age, location, likes, dislikes, bio) VALUES ('#{params['name']}', '#{params['image_url']}', '#{params['age']}', '#{params['location']}', '#{params['likes']}', '#{params['dislikes']}', '#{params['bio']}');"

    conn = PG.connect(dbname: 'puppy_love')
    conn.exec(sql)
    conn.close

    redirect '/dogs'

end

get '/dogs/:id/edit' do
    
    dog_id = params['id']

    conn = PG.connect(dbname: 'puppy_love')
    sql = "SELECT * FROM dogs WHERE id = '#{dog_id}';"
    result = conn.exec(sql)
    dog = result[0]

    conn.close
    
    erb :edit_dog_form, locals: {
        dog: dog
    }
end

put '/dogs/:id' do
    
    conn = PG.connect(dbname: 'puppy_love')

    sql = "UPDATE dogs SET name = '#{params['name']}', image_url = '#{params['image_url']}', age = '#{params['age']}', location = '#{params['location']}', likes = '#{params['likes']}', dislikes = '#{params['dislikes']}', bio = '#{params['bio']}' WHERE id = #{params['id']};"

    conn.exec(sql)
    conn.close

    redirect "/dogs/#{params['id']}"

end

delete '/dogs/:id' do

    sql = "DELETE FROM dogs WHERE id = #{params['id']}"
    conn = PG.connect(dbname: 'puppy_love')
    conn.exec(sql)
    conn.close

    redirect '/dogs'


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
