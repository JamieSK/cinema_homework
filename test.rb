require 'minitest/autorun'
require 'minitest/rg'

require_relative 'models/customer'
require_relative 'models/film'
require_relative 'models/screening'
require_relative 'models/ticket'
require_relative 'seeds'


class CinemaTest < MiniTest::Test
  def setup
    Ticket.delete_all
    Screening.delete_all
    Customer.delete_all
    Film.delete_all

    @customer1 = Customer.new ({
      'name' => 'Jim',
      'funds' => 1
      })
    @customer1.save
    @customer2 = Customer.new ({
      'name' => 'Lisa',
      'funds' => 200
      })
    @customer2.save
    @customer3 = Customer.new ({
      'name' => 'Penelope',
      'funds' => 300
      })
    @customer3.save
    @customer4 = Customer.new ({
      'name' => 'Ralph',
      'funds' => 400
      })
    @customer4.save

    @film1 = Film.new ({
      'title' => '2001: A Space Odyssey',
      'price' => 10
      })
    @film1.save
    @film2 = Film.new ({
      'title' => 'Clockwork Orange',
      'price' => 20
      })
    @film2.save
    @film3 = Film.new ({
      'title' => 'Sliding Doors',
      'price' => 30
      })
    @film3.save

    @screening1 = Screening.new ({
      'film_id' => @film1.id,
      'showtime' => '20:00',
      'capacity' => 7
      })
    @screening1.save
    @screening2 = Screening.new ({
      'film_id' => @film2.id,
      'showtime' => '20:00',
      'capacity' => 1
      })
    @screening2.save
    @screening3 = Screening.new ({
      'film_id' => @film1.id,
      'showtime' => '11:00',
      'capacity' => 10
      })
    @screening3.save

    @ticket1 = Ticket.new ({
      'customer_id' => @customer2.id,
      'film_id' => @screening1.film_id,
      'screening_id' => @screening1.id
      })
    @ticket1.save
    @ticket2 = Ticket.new ({
      'customer_id' => @customer3.id,
      'film_id' => @screening3.film_id,
      'screening_id' => @screening3.id
      })
    @ticket2.save
    @ticket3 = Ticket.new ({
      'customer_id' => @customer4.id,
      'film_id' => @screening3.film_id,
      'screening_id' => @screening3.id
      })
    @ticket3.save
    @ticket4 = Ticket.new ({
      'customer_id' => @customer4.id,
      'film_id' => @screening2.film_id,
      'screening_id' => @screening2.id
      })
    @ticket4.save
  end

  def test_which_films
    actual = @customer4.films.map { |customer| customer.title }
    expected = [@film1, @film2].map { |customer| customer.title }
    assert_equal(expected, actual)
  end

  def test_which_customers
    actual = @film1.customers.map { |customer| customer.name }
    expected = [@customer2, @customer3, @customer4].map { |customer| customer.name }
    assert_equal(expected, actual)
  end

  def test_decrease_funds
    actual = @customer4.funds
    expected = 370
    assert_equal(expected, actual)
  end

  def test_how_many_tickets
    actual = @customer4.number_of_tickets
    expected = 2
    assert_equal(expected, actual)
  end

  def test_how_many_customers
    actual = @film1.number_of_customers
    expected = 3
    assert_equal(expected, actual)
  end

  def test_too_poor_for_film
    assert_raises(TooPoorError) {
      ticket1 = Ticket.new ({
        'customer_id' => @customer1.id,
        'film_id' => @screening1.film_id,
        'screening_id' => @screening1.id
        })
      ticket1.save
    }
  end

  def test_too_full_for_people
    assert_raises(FilmOverflowError) {
      ticket1 = Ticket.new ({
        'customer_id' => @customer3.id,
        'film_id' => @screening2.film_id,
        'screening_id' => @screening2.id
        })
      ticket1.save
    }
  end

  def test_most_popular_time
    actual = @film1.most_popular_time
    expected = '11:00:00'
    assert_equal(expected, actual)
  end
end
