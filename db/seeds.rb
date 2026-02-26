# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Limpa os registros anteriores (opcional)
# Optional: clear previous records
Month.destroy_all

user = User.first

months_data = [
  {
    month: "January",
    year: 2026,
    overview: "Higher expenses due to property tax and school supplies. Food costs increased because of dining out during vacation."
  },
  {
    month: "February",
    year: 2026,
    overview: "More controlled spending. Reduced entertainment expenses and focused on saving. Credit card installments from January purchases were paid."
  },
  {
    month: "March",
    year: 2026,
    overview: "Medical expenses increased due to consultations and exams. Grocery spending remained average. Small investments were started this month."
  },
  {
    month: "April",
    year: 2026,
    overview: "Financially balanced month. No unexpected expenses. Fixed costs remained stable and electricity bill decreased slightly."
  },
  {
    month: "May",
    year: 2026,
    overview: "Extra expenses with car maintenance. Fuel costs were higher than usual due to short trips. Other categories remained under control."
  },
  {
    month: "June",
    year: 2026,
    overview: "Increased spending on restaurants and leisure activities. Purchased winter clothes. Budget remained within planned limits."
  },
  {
    month: "July",
    year: 2026,
    overview: "Higher expenses due to vacation travel. Flights, accommodation, and food significantly impacted the monthly budget."
  }
]

months_data.each do |data|
  Month.create!(
    month: data[:month],
    year: data[:year],
    overview: data[:overview],
    user: user
  )
end

puts "Months seed created successfully!"
