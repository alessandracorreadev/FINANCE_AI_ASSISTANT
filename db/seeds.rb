# db/seeds.rb

# Apaga tudo antes pra garantir idempotência
Message.destroy_all
Chat.destroy_all
Month.destroy_all
User.destroy_all

# Cria um usuário de exemplo
user = User.create!(
  email: "alejandro@example.com",
  password: "123456",
  name: "Alejandro"
)

# Meses do ano
month_names = %w[January February March April May June July August September October November December]

# Cria meses com financial_data
month_names.each_with_index do |month_name, index|
  income = rand(2000..5000)
  expenses = rand(1000..4000)

  # Categorias aleatórias
  categories = {
    rent: rand(500..1500),
    food: rand(200..800),
    transport: rand(50..300),
    utilities: rand(100..400),
    entertainment: rand(50..300)
  }

  # Ajusta para bater com total de despesas
  categories_total = categories.values.sum
  scale = expenses.to_f / categories_total
  categories.transform_values! { |v| (v * scale).round(2) }

  overview = "In #{month_name}, you earned $#{income} and spent $#{expenses}. Key expenses: #{categories.map { |k,v| "#{k}: $#{v}" }.join(", ")}."

  month = Month.create!(
    user: user,
    year: 2025,
    month: month_name,
    overview: overview,
    financial_data: {
      "income" => income,
      "expenses" => expenses,
      "categories" => categories
    }
  )

  # Cria um chat pro mês
  chat = month.chats.create!

  # Cria algumas mensagens exemplo
  chat.messages.create!(role: "user", content: "Hello AI, can you summarize my finances?")
  chat.messages.create!(role: "assistant", content: "Sure! You earned $#{income} and spent $#{expenses} with major expenses in rent and food.")
end

puts "Seed completo! Criados #{month_names.size} meses, com chats e mensagens para #{user.name}."
