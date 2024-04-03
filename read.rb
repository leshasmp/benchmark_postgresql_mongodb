require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

# Бенчмарк для PostgreSQL
pg_benchmark = Benchmark.measure do
  # Чтение данных
  pg_connection.exec('SELECT * FROM users').each do |row|
    puts row
  end
end

puts "PostgreSQL benchmark: #{pg_benchmark.real}"

# # Бенчмарк для MongoDB
mongo_benchmark = Benchmark.measure do
  # Чтение данных
  mongo_client[:users].find.each do |doc|
    puts doc
  end
end

puts "MongoDB benchmark: #{mongo_benchmark.real}"

# Закрытие соединений
pg_connection.close
mongo_client.close
