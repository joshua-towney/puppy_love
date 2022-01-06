require 'pg'
require 'bcrypt'


puts 'creating dummy user...'


# email = 'woof@bark.com'
# password = 'walkies'
email = 'treats@yesplease.com'
password = 'give'


conn = PG.connect(dbname: 'puppy_love')

password_digest = BCrypt::Password.create(password)

sql = "INSERT INTO users (email, password_digest) VALUES ('#{email}','#{password_digest}');"
conn.exec(sql)
conn.close

puts 'done!'