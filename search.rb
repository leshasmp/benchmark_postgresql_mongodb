require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

# Бенчмарк для полнотекстового поиска
text_search_benchmark = Benchmark.measure do
  result = pg_connection.exec_params("SELECT * FROM users WHERE data->>'email' LIKE '%user50%'")
  puts result.count
end

puts "Full-text search benchmark: #{text_search_benchmark.real}"

# Закрытие соединения
pg_connection.close

# Бенчмарк для полнотекстового поиска
text_search_benchmark = Benchmark.measure do
  users_collection = mongo_client[:users]
  result = users_collection.find(email: /user50/)
  puts result.count
end

puts "Full-text search benchmark: #{text_search_benchmark.real}"

# Закрытие соединения
mongo_client.close
