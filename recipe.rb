class Recipe
  attr_accessor :name, :ingredients, :instructions, :image
  
  def initialize(name, ingredients, instructions, image)
    @name = name
    @ingredients = ingredients
    @instructions = instructions
    @image = image
  end
end