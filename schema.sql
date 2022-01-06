

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

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT
);