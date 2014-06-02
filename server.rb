require 'pry'
require 'shotgun'
require 'sinatra'
require 'pg'

#####  Connection to database #####
def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

  yield(connection)

  ensure
    connection.close
  end
end



get '/recipes' do
  query = "SELECT recipes.name FROM recipes
           ORDER BY recipes.name ASC;"

  recipe_name = db_connection do |conn|
    conn.exec(query)
  end
  @recipes = recipe_name.to_a

  erb :index
end

get '/recipes/:recipe' do
  recipe = params[:recipe]
  query = "SELECT recipes.name AS name, recipes.description AS description, recipes.instructions AS instructions, ingredients.name AS ingredients FROM recipes
           JOIN ingredients ON recipes.id = ingredients.recipe_id
           WHERE recipes.name = '#{params[:recipe]}';"

  recipe_name = db_connection do |conn|
    conn.exec(query)
  end
  @recipes = recipe_name.to_a

  erb :show
end
