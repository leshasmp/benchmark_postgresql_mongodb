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
    pg_connection.exec_params('INSERT INTO users (name, email) VALUES ($1, $2)', ["User #{i}", "user#{i}@example.com"])
  end
end

puts "PostgreSQL benchmark: #{pg_benchmark.real}"

# Бенчмарк для MongoDB
mongo_benchmark = Benchmark.measure do
  # Запись данных
  1000.times do |i|
    mongo_client[:users].insert_one(name: "User #{i}", email: "user#{i}@example.com")
  end
end

puts "MongoDB benchmark: #{mongo_benchmark.real}"

# Закрытие соединений
pg_connection.close
mongo_client.close
