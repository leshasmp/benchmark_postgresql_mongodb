require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

# Бенчмарк для PostgreSQL
pg_benchmark = Benchmark.measure do
  # Запись данных
  1000.times do |i|
    user_data = { name: "User #{i}", age: rand(18..65), email: "user#{i}@example.com" }
    pg_connection.exec_params('INSERT INTO users (data) VALUES ($1)', [user_data.to_json])
  end
end

puts "PostgreSQL benchmark: #{pg_benchmark.real}"

# Бенчмарк для MongoDB
mongo_benchmark = Benchmark.measure do
  # Запись данных
  users_collection = mongo_client[:users]

  1000.times do |i|
    users_collection.insert_one(name: "User #{i}", age: rand(18..65), email: "user#{i}@example.com")
  end
end

puts "MongoDB benchmark: #{mongo_benchmark.real}"

# Закрытие соединений
pg_connection.close
# mongo_client.close
