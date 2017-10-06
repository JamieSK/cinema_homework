require_relative '../db/sql'

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save
    sell_ticket
    sql = 'INSERT INTO tickets (customer_id, film_id, screening_id) VALUES
      ($1, $2, $3) RETURNING id;'
    values = [@customer_id, @film_id, @screening_id]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def sell_ticket
    customer, screening, film = get_details
    ticket?(customer, screening, film)
    customer.pay(film.price)
  end

  def get_details
    customer = Customer.find(@customer_id)
    screening = Screening.find(@screening_id)
    film = Film.find(@film_id)
    [customer, screening, film]
  end

  def ticket?(customer, screening, film)
    raise TooPoorError if customer.funds < film.price

    tickets_sold = SQL.run('SELECT COUNT(*) FROM tickets
      WHERE screening_id = $1', [@screening_id])[0]['count'].to_i
    raise FilmOverflowError if tickets_sold >= screening.capacity
  end

  def update
    sql = 'UPDATE tickets SET (customer_id, film_id, screening_id) =
      ($1, $2, $3) WHERE id = $4;'
    values = [@customer_id, @film_id, @screening_id, @id]
    SQL.run(sql, values)
  end

  def delete
    SQL.run('DELETE FROM tickets WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM tickets;', [])
  end
end

class TooPoorError < StandardError
end
class FilmOverflowError < StandardError
end
