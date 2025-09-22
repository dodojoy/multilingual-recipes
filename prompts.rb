module Prompts
  module Recipe
    def self.translate_to_portuguese(name:, ingredients:, instructions:)
      <<~PROMPT
        You are a culinary translation expert. Please translate this recipe from English to Brazilian Portuguese.
        
        Recipe Structure:
        - Recipe Name: The title of the dish
        - Ingredients: List of ingredients with their measurements
        - Instructions: Step-by-step cooking directions
        
        Original Recipe:
        Recipe Name: #{name}
        
        Ingredients:
        #{ingredients.join("\n")}
        
        Instructions:
        #{instructions.join("\n")}
        
        Translation Rules:
        1. Keep measurements in their original format (do not convert units)
        2. Use formal Brazilian Portuguese
        3. Maintain the original formatting and numbering of instructions
        4. Translate ingredient names to common Brazilian cooking terms
        5. Keep section headers in Portuguese: "Nome da receita:", "Ingredientes:", "Instruções:"
        
        Please provide the translation following the exact same structure as above, starting with "Nome da receita:".
      PROMPT
    end
  end
end
