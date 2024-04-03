require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

# Инкремент
# Исходное значение
initial_value = 0

# Количество итераций для инкремента
iterations = 1000

# Бенчмарк для PostgreSQL
pg_benchmark = Benchmark.measure do
  # Инкремент значения в цикле
  iterations.times do
    initial_value += 1
  end
end

puts "PostgreSQL benchmark: #{pg_benchmark.real}"

# Инкремент
# Исходное значение
initial_value = 0

# Количество итераций для инкремента
iterations = 1000

# Бенчмарк для MongoDB
mongo_benchmark = Benchmark.measure do
  # Инкремент значения в цикле
  iterations.times do
    initial_value += 1
  end
end

puts "MongoDB benchmark: #{mongo_benchmark.real}"

# Закрытие соединений
pg_connection.close
mongo_client.close
