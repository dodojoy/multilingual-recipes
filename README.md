# Sistema de Receitas com Tradução Automática

Este projeto integra a API TheMealDB com a API do Gemini para fornecer receitas em inglês com tradução automática para português brasileiro.

## Estrutura do Projeto

```
/recipes
├── api_client.rb      # Cliente para TheMealDB
├── db_connection.rb   # Conexão com PostgreSQL
├── gemini_api.rb      # Cliente para Gemini API
├── main.rb           # Ponto de entrada
├── prompts.rb        # Templates para Gemini
└── recipe.rb         # Modelo de receita
```

## APIs Utilizadas

### TheMealDB

- API pública de receitas culinárias
- Endpoint utilizado: `/random.php` para obter receitas aleatórias
- Fornece informações detalhadas como:
  - Nome da receita
  - Lista de ingredientes com medidas
  - Instruções de preparo
  - Imagem do prato

### Google Gemini

- API de IA para tradução contextual
- Modelo utilizado: `gemini-2.0-flash`
- Traduz receitas mantendo:
  - Formatação original
  - Medidas no formato original
  - Termos culinários adaptados para o português brasileiro

## Configuração do Banco de Dados

1. Configure as variáveis de ambiente no arquivo `.env`:

```bash
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
GEMINI_API_KEY=sua_chave_api
```

2. O sistema automaticamente:
   - Cria o banco `recipes` se não existir
   - Cria a tabela `recipes` com a estrutura necessária
   - Gerencia conexões usando a gem `pg`

## Como Usar

### Buscar e Salvar Nova Receita

```ruby
MealApi.save_new_random_recipe
```

### Listar Receitas (em inglês)

```ruby
MealApi.get_recipes_from_db
```

### Listar Receitas Traduzidas

```ruby
MealApi.get_recipes_from_db(true)
```

## Estrutura da Tradução

O sistema utiliza um prompt especializado para tradução culinária que:

- Mantém a estrutura original da receita
- Preserva as medidas no formato original
- Traduz ingredientes para termos comuns no Brasil
- Mantém a numeração e formatação das instruções

## Detalhes Técnicos

### Modelo de Dados

```ruby
Recipe
  - name: string
  - ingredients: string
  - instructions: string
  - image: string
```

### Banco de Dados

- PostgreSQL
- Tabela `recipes` com campos:
  - `id`: SERIAL PRIMARY KEY
  - `name`: VARCHAR(255)
  - `ingredients`: TEXT
  - `instructions`: TEXT
  - `image`: TEXT

### Fluxo de Dados

1. Busca receita aleatória do TheMealDB
2. Salva no banco PostgreSQL
3. Ao consultar, opcionalmente traduz usando Gemini
4. Exibe resultado formatado

## Dependências

- `httparty`: Requisições HTTP
- `pg`: Conexão PostgreSQL
- `dotenv`: Gerenciamento de variáveis de ambiente
- `json`: Manipulação de JSON

