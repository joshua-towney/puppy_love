

CREATE DATABASE puppy_love;

CREATE TABLE dogs (
    id SERIAL PRIMARY KEY,
    name TEXT,
    image_url TEXT,
    age INTEGER,
    location TEXT,
    likes TEXT,
    dislikes TEXT,
    bio VARCHAR(50),
    user_id INTEGER
);

INSERT INTO dogs (name, image_url, age, location, likes, dislikes, bio) VALUES ('Jimmy','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUTqmq9Pknq1-dkMQTBZ3SbIX4yDS45-zvRg&usqp=CAU',4,'Melbourne','Treats','Cats','I love walks');

INSERT INTO dogs (name, image_url, age, location, likes, dislikes, bio) VALUES ('Bethany','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUTqmq9Pknq1-dkMQTBZ3SbIX4yDS45-zvRg&usqp=CAU',7,'Sydney','Walks','Baths','Ruff Ruff!');

INSERT INTO dogs (name, image_url, age, location, likes, dislikes, bio) VALUES ('Bebop','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUTqmq9Pknq1-dkMQTBZ3SbIX4yDS45-zvRg&usqp=CAU',5,'Melbourne','Cuddles','Lizards','Am derp');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    email TEXT,
    password_digest TEXT
);

user_name = 'Frank The Tank'
email = 'woof@bark.com'
password = 'walkies'

user_name = 'Treat Yo Self'
email = 'treats@yesplease.com'
password = 'give'

CREATE TABLE user_comments (
    dog_id INTEGER,
    comment TEXT,
    user_name TEXT,
    user_id INTEGER
);
