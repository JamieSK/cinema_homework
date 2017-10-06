require_relative '../db/sql'

class Screening
  attr_accessor :film_id, :showtime, :capacity
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @showtime = options['showtime']
    @capacity = options['capacity'].to_i
  end

  def save
    sql = 'INSERT INTO screenings (film_id, showtime, capacity) VALUES
      ($1, $2, $3) RETURNING id;'
    values = [@film_id, @showtime, @capacity]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def self.find(id)
    sql = 'SELECT * FROM screenings WHERE id = $1;'
    Screening.new(SQL.run(sql, [id])[0])
  end

  def update
    sql = 'UPDATE screenings SET (film_id, showtime, capacity) =
      ($1, $2, $3) WHERE id = $4;'
    values = [@film_id, @showtime, @capacity, @id]
    SQL.run(sql, values)
  end

  def delete
    SQL.run('DELETE FROM screenings WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM screenings;', [])
  end
end
