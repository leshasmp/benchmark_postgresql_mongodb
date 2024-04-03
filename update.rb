require 'benchmark'
require 'pg'
require 'mongo'

# Установка соединения с PostgreSQL
pg_connection = PG.connect(dbname: 'users_test', user: 'postgres', password: 'postgres', host: 'localhost')

# Установка соединения с MongoDB
mongo_client = Mongo::Client.new(['localhost:27017'], database: 'users_test')

pg_benchmark = Benchmark.measure do
  # Обновление данных
  pg_connection.exec('UPDATE users SET data = jsonb_set(data, \'{age}\', ((data->>\'age\')::int + 1)::text::jsonb) WHERE data->>\'age\' IS NOT NULL')
end

puts "PostgreSQL benchmark: #{pg_benchmark.real}"

mongo_benchmark = Benchmark.measure do
  # Обновление данных
  users_collection = mongo_client[:users]
  users_collection.update_many({ age: { '$exists': true } }, { '$inc': { age: 1 } })
end

puts "MongoDB benchmark: #{mongo_benchmark.real}"

# Закрытие соединений
pg_connection.close
mongo_client.close
