require_relative 'models/customer'
require_relative 'models/film'
require_relative 'models/screening'
require_relative 'models/ticket'

class Seed
  def self.seed
    Ticket.delete_all
    Screening.delete_all
    Customer.delete_all
    Film.delete_all

    customer1 = Customer.new ({
      'name' => 'Jim',
      'funds' => 1
      })
    customer1.save
    customer2 = Customer.new ({
      'name' => 'Lisa',
      'funds' => 200
      })
    customer2.save
    customer3 = Customer.new ({
      'name' => 'Penelope',
      'funds' => 300
      })
    customer3.save
    customer4 = Customer.new ({
      'name' => 'Ralph',
      'funds' => 400
      })
    customer4.save

    film1 = Film.new ({
      'title' => '2001: A Space Odyssey',
      'price' => 10
      })
    film1.save
    film2 = Film.new ({
      'title' => 'Clockwork Orange',
      'price' => 20
      })
    film2.save
    film3 = Film.new ({
      'title' => 'Sliding Doors',
      'price' => 30
      })
    film3.save

    screening1 = Screening.new ({
      'film_id' => film1.id,
      'showtime' => '20:00',
      'capacity' => 7
      })
    screening1.save
    screening2 = Screening.new ({
      'film_id' => film2.id,
      'showtime' => '20:00',
      'capacity' => 1
      })
    screening2.save
    screening3 = Screening.new ({
      'film_id' => film1.id,
      'showtime' => '11:00',
      'capacity' => 10
      })
    screening3.save

    ticket1 = Ticket.new ({
      'customer_id' => customer2.id,
      'film_id' => screening1.film_id,
      'screening_id' => screening1.id
      })
    ticket1.save(customer2, screening1, film1)
    ticket2 = Ticket.new ({
      'customer_id' => customer3.id,
      'film_id' => screening3.film_id,
      'screening_id' => screening3.id
      })
    ticket2.save(customer3, screening3, film1)
    ticket3 = Ticket.new ({
      'customer_id' => customer4.id,
      'film_id' => screening3.film_id,
      'screening_id' => screening3.id
      })
    ticket3.save(customer4, screening3, film1)
    ticket4 = Ticket.new ({
      'customer_id' => customer4.id,
      'film_id' => screening2.film_id,
      'screening_id' => screening2.id
      })
    ticket4.save(customer4, screening2, film2)
  end
end
