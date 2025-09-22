require 'httparty'
require_relative 'recipe'
require_relative 'db_connection'
require_relative 'gemini_api'

class MealApi
  include HTTParty
  base_uri 'https://www.themealdb.com/api/json/v1/1'

  def self.fetch_random_from_api
    response = get('/random.php')
    
    if response.success?
      meal = response['meals'].first
      
      ingredients = []
      1.upto(20) do |i|
        ingredient = meal["strIngredient#{i}"]
        measure = meal["strMeasure#{i}"]
        
        if ingredient && !ingredient.empty?
          ingredients << "#{measure.strip} #{ingredient.strip}"
        end
      end

      Recipe.new(
        meal['strMeal'],
        ingredients.join(', '),
        meal['strInstructions'],
        meal['strMealThumb']
      )
    else
      raise "Erro ao buscar receita da API: #{response.code}"
    end
  end

  def self.save_new_random_recipe
    recipe = fetch_random_from_api
    DatabaseConnection.insert_recipe(
      recipe.name,
      recipe.ingredients,
      recipe.instructions,
      recipe.image
    )
    DatabaseConnection.list_recipes
  end

  def self.get_recipes_from_db(translate = false)
    recipes = DatabaseConnection.list_recipes
    
    recipes.each do |recipe|
      recipe_data = if translate
        GeminiApi.translate_to_portuguese(
          name: recipe.name,
          ingredients: recipe.ingredients.split(", "),
          instructions: recipe.instructions.split("\n")
        ) || { name: recipe.name, ingredients: recipe.ingredients.split(", "), instructions: recipe.instructions.split("\n") }
      else
        { name: recipe.name, ingredients: recipe.ingredients.split(", "), instructions: recipe.instructions.split("\n") }
      end

      headers = translate ? ["Ingredientes", "Instruções"] : ["Ingredients", "Instructions"]
      
      puts "\n#{recipe_data[:name]}\n"
      puts "\n#{headers[0]}:"
      puts recipe_data[:ingredients].join(", ")
      puts "\n#{headers[1]}:"
      puts recipe_data[:instructions].join("\n")
    end
  end
end