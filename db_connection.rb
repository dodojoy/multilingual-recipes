require 'pg'
require 'dotenv'
require_relative 'recipe'
Dotenv.load

class DatabaseConnection
  def self.setup
    begin
      conn = PG.connect(
        dbname: 'postgres',
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        host: 'localhost',
        port: 5432
      )

      result = conn.exec("SELECT 1 FROM pg_database WHERE datname = 'recipes'")
      
      if result.ntuples == 0
        conn.close
        
        conn = PG.connect(
          dbname: 'postgres',
          user: ENV['DB_USER'],
          password: ENV['DB_PASSWORD'],
          host: 'localhost',
          port: 5432
        )
        
        conn.exec("CREATE DATABASE recipes")
        puts "Banco de dados 'recipes' criado com sucesso!"
      end

      conn.close

      conn = PG.connect(
        dbname: 'recipes',
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        host: 'localhost',
        port: 5432
      )

      conn.exec("
        CREATE TABLE IF NOT EXISTS recipes (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          ingredients TEXT NOT NULL,
          instructions TEXT NOT NULL,
          image TEXT
        )
      ")

      conn
    rescue PG::Error => e
      puts "Erro: #{e.message}"
      nil
    end
  end

  def self.connection
    @connection ||= setup
  end

  def self.insert_recipe(name, ingredients, instructions, image)
    return unless connection

    begin
      connection.exec_params(
        "INSERT INTO recipes (name, ingredients, instructions, image) VALUES ($1, $2, $3, $4) RETURNING id;",
        [name, ingredients, instructions, image]
      )
      puts "Receita '#{name}' inserida com sucesso!"
    rescue PG::Error => e
      puts "Erro ao inserir receita: #{e.message}"
    end
  end

  def self.list_recipes
    return [] unless connection

    begin
      result = connection.exec("SELECT * FROM recipes ORDER BY id DESC LIMIT 5")
      
      result.map do |row|
        Recipe.new(
          row['name'],
          row['ingredients'],
          row['instructions'],
          row['image']
        )
      end
    rescue PG::Error => e
      puts "Erro ao listar receitas: #{e.message}"
      []
    end
  end
end

DatabaseConnection.setup