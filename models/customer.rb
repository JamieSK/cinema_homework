require_relative '../db/sql'

class Customer
  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save
    sql = 'INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id;'
    values = [@name, @funds]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def funds
    sql = 'SELECT funds FROM customers WHERE id = $1'
    SQL.run(sql, [@id])[0]['funds'].to_i
  end

  def self.find(id)
    sql = 'SELECT * FROM customers WHERE id = $1;'
    Customer.new(SQL.run(sql, [id])[0])
  end

  def update
    sql = 'UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;'
    values = [@name, @funds, @id]
    SQL.run(sql, values)
  end

  def pay(amount)
    @funds -= amount
    update
  end

  def delete
    sql = 'DELETE FROM customers WHERE id = $1;'
    SQL.run(sql, [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM customers;', [])
  end

  def films
    sql = 'SELECT films.* FROM tickets INNER JOIN films
      ON tickets.film_id = films.id WHERE customer_id = $1;'
    SQL.run(sql, [@id]).map { |film_hash| Film.new(film_hash) }
  end

  def number_of_tickets
    sql = 'SELECT COUNT(*) FROM tickets WHERE customer_id = $1;'
    SQL.run(sql, [@id])[0]['count'].to_i
  end
end
