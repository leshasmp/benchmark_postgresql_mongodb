require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

# # Создание тестовой таблицы и индекса
# pg_connection.exec('CREATE TABLE users (id SERIAL PRIMARY KEY, text TEXT)')
# pg_connection.exec('CREATE INDEX text_index ON users USING gin(to_tsvector(\'english\', text))')

# Вставка тестовых данных
1000.times do |i|
  pg_connection.exec_params('INSERT INTO users (text) VALUES ($1)', ["Some text for document #{i}"])
end

# Бенчмарк для полнотекстового поиска
text_search_benchmark = Benchmark.measure do
  1000.times do |i|
    query = "'document' & '0'"
    result = pg_connection.exec_params('SELECT * FROM users WHERE to_tsvector(\'english\', text) @@ to_tsquery(\'english\', $1)', [query])    
    puts "Search result for '#{query}': #{result.ntuples} rows found"
  end
end

puts "Full-text search benchmark: #{text_search_benchmark.real}"

# Закрытие соединения
pg_connection.close

# Вставка тестовых данных
# 1000.times do |i|
#   mongo_client[:users].insert_one({ text: "Some text for document #{i}" })
# end

# Бенчмарк для полнотекстового поиска
text_search_benchmark = Benchmark.measure do
  1000.times do |i|
    query = "document #{i}"
    result = mongo_client[:users].find({ '$text' => { '$search' => query } })
    puts "Search result for '#{query}': #{result.count} documents found"
  end
end

puts "Full-text search benchmark: #{text_search_benchmark.real}"

# Закрытие соединения
mongo_client.close
