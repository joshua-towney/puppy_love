require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'
require 'pry'
require 'cloudinary'
require_relative 'dog.rb'

enable :sessions

options = {
    cloud_name: 'durljsvrm',
    api_key: ENV['CLOUDINARY_API_KEY'],
    api_secret: ENV['CLOUDINARY_API_SECRET']
}

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
    #return OpenStruct.new(user)
    return user
end

def db_query(sql, params = [])
    conn = PG.connect(dbname: 'puppy_love')
    result = conn.exec_params(sql, params)
    conn.close
    return result
end

def find_user_by_id(id)
    db_query('SELECT * FROM users WHERE id = $1', [id])
end


get '/' do
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

    redirect '/login' unless logged_in?
    
    erb :new
end

get '/dogs/:id' do 
    
    dog_id = params['id']

    conn = PG.connect(dbname: 'puppy_love')
    sql = "SELECT * FROM dogs WHERE id = '#{dog_id}';"
    result = conn.exec(sql)
    dog = result[0]

    sql2 = "SELECT * FROM user_comments WHERE dog_id = '#{dog_id}'"
    result2 = conn.exec(sql2)
    comments = result2

    conn.close
    

    erb :show_dog, locals: {
        dog: dog,
        comments: comments
    }
end

post '/dogs' do

    file = params['image_url']['tempfile']

    result = Cloudinary::Uploader.upload(file, options)

    sql = "INSERT INTO dogs (name, image_url, age, location, likes, dislikes, bio, user_id) VALUES ('#{params['name']}', '#{result['url']}', '#{params['age']}', '#{params['location']}', '#{params['likes']}', '#{params['dislikes']}', '#{params['bio']}','#{session[:user_id]}');"

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

    if session[:user_id] != dog['user_id']
        redirect '/login'
    end
    
    erb :edit_dog_form, locals: {
        dog: dog
    }
end

put '/dogs/:id' do

    file = params['image_url']['tempfile']

    result = Cloudinary::Uploader.upload(file, options)
    
    conn = PG.connect(dbname: 'puppy_love')

    sql = "UPDATE dogs SET name = '#{params['name']}', image_url = '#{result['url']}', age = '#{params['age']}', location = '#{params['location']}', likes = '#{params['likes']}', dislikes = '#{params['dislikes']}', bio = '#{params['bio']}' WHERE id = #{params['id']};"

    conn.exec(sql)
    conn.close

    redirect "/dogs/#{params['id']}"

end

post '/dogs/:id' do

    conn = PG.connect(dbname: 'puppy_love')

    find_user_by_id(session[:user_id])

    sql = "INSERT INTO user_comments (dog_id, comment, user_id) VALUES (#{params['id']}, '#{params['comment']}', #{session[:user_id]});"

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
