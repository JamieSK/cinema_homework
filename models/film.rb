require_relative '../db/sql'

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    sql = 'INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id;'
    values = [@title, @price]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def self.find(id)
    sql = 'SELECT * FROM films WHERE id = $1;'
    Film.new(SQL.run(sql, [id])[0])
  end

  def update
    sql = 'UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;'
    values = [@title, @price, @id]
    SQL.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM films WHERE id = $1'
    SQL.run(sql, [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM films;', [])
  end

  def customers
    sql = 'SELECT customers.* FROM tickets INNER JOIN customers
      ON customers.id = tickets.customer_id WHERE tickets.film_id = $1;'
    SQL.run(sql, [@id]).map { |customer_hash| Customer.new(customer_hash) }
  end

  def number_of_customers
    sql = 'SELECT COUNT(*) FROM tickets WHERE film_id = $1;'
    SQL.run(sql, [@id])[0]['count'].to_i
  end

  def most_popular_time
    sql = 'SELECT showtime, count(showtime) FROM screenings INNER JOIN tickets
      ON screening_id = screenings.id WHERE tickets.film_id = $1 GROUP BY
      showtime ORDER BY count DESC;'
    SQL.run(sql, [@id])[0]['showtime']
  end
end
