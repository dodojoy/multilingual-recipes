require_relative 'api_client'

puts "\n Buscando e salvando uma nova receita aleatória"
MealApi.save_new_random_recipe

puts "\n Listando receitas do banco de dados em português"
MealApi.get_recipes_from_db(true)