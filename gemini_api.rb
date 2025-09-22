require 'httparty'
require 'json'
require_relative 'prompts'

class GeminiApi
  def self.generate_response(prompt)
    response = HTTParty.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
      headers: {
        'X-goog-api-key' => ENV['GEMINI_API_KEY'],
        'Content-Type' => 'application/json'
      },
      body: {
        contents: [
          {
            parts: [
              {
                text: prompt
              }
            ]
          }
        ]
      }.to_json
    )
    
    if response.success?
      response.parsed_response['candidates'][0]['content']['parts'][0]['text']
    else
      puts "\n[ERRO] Falha na chamada da API: #{response.code}"
      nil
    end
  end

  def self.translate_to_portuguese(name:, ingredients:, instructions:)
    prompt = Prompts::Recipe.translate_to_portuguese(
      name: name,
      ingredients: ingredients,
      instructions: instructions
    )
    
    response = generate_response(prompt)
    return nil if response.nil?
    
    parse_translation(response)
  end

  private

  def self.parse_translation(response)
    sections = response.split(/Nome da receita:|Ingredientes:|Instruções:/).reject(&:empty?)
    
    {
      name: sections[0].strip,
      ingredients: sections[1].strip.split("\n").map(&:strip).reject(&:empty?),
      instructions: sections[2].strip.split("\n").map(&:strip).reject(&:empty?)
    }
  end
end