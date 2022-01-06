
def all_dogs()
    db_query('SELECT * FROM dogs ORDER BY name')
end

def create_dog(name, image_url, age, location, likes, dislikes, bio, user_id)
    sql = "INSERT into dogs (name, image_url, age, location, likes, dislikes, bio, user_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8);"
    db_query(sql, [name, image_url, age, location, likes, dislikes, bio, user_id])
end

def update_dog(name, image_url, age, location, likes, dislikes, bio, id)
    sql = "UPDATE dogs SET name = $1, image_url = $2, age = $3, location = $4, likes = $5, dislikes = $6, bio = $7 WHERE id = $8;"
    db_query(sql, [name, image_url, age, location, likes, dislikes, bio, id])
end

def delete_dog()
    db_query("DELETE FROM dogs WHERE id = params[id]")
end