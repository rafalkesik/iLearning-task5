module CopyHelper
  require 'faker'

  REVIEW_START = [
    -> { "A #{Faker::Adjective.positive} take on #{Faker::Verb.ing_form}." },
    -> { "I went in expecting #{Faker::Food.dish}, and left feeling #{Faker::Adjective.negative}." },
    -> { "#{Faker::Name.first_name} steals every scene." },
    -> { "Somehow both #{Faker::Adjective.positive} and #{Faker::Adjective.negative}." }
  ].freeze
  REVIEW_ENDING = [
    -> { "Would watch again." },
    -> { "Skip it." },
    -> { "Bring snacks." },
    -> { "Not for everyone, but it was for me." }
  ].freeze
  MOVIE_GENRES = [
    'Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi', 'Thriller', 'Romance', 'Documentary'
  ].freeze
  TEASER_TEXTS = [
    'This fall', 'Long awaited film...', 'THIS YEAR', 'This summer', 'True masterpiece', 'Nominated to Oscars', 'Critically aclaimed...'
  ]

  def generate_seed
    8.times.map { rand(10) }.join
  end

  def roll_amount_from_float(float_input)
    amount = float_input.floor()
    addition = rand < (float_input % 1) ? 1 : 0
    
    amount + addition
  end

  def generate_film_data_object(seed, likes_input, reviews_input)
    rng = Random.new(seed.to_i)
    Faker::Config.random = rng
    actors = Array.new(rng.rand(1..3)) { Faker::Name.name }.uniq
    film_title = generate_random_movie_title(rng)
    
    film = {
      title: film_title,
      likes: roll_amount_from_float(likes_input),
      genre: MOVIE_GENRES.sample(random: rng),
      year: rng.rand(1968..2026),
      length: rng.rand(100..150),
      age: rng.rand(7..18),
      director: Faker::Name.name,
      tag: ['Top 10', 'Top 50', 'Top 100'].sample(random: rng),
      description: "Quote of the movie: \"#{Faker::Quote.fortune_cookie}\"",
      cast: actors,
      film_texts: generate_film_texts(rng, actors[0], film_title),
      reviews: generate_reviews(rng, roll_amount_from_float(reviews_input)),
    }
    Rails.logger.info "SEED #{seed}: year=#{film[:year]} reviews=#{film[:reviews].size} genre=#{film[:genre]}"
    film
  end

  def generate_reviews_old(amount)
    [
      { review: 'Best film eva!', author: 'Jack Smith', company: 'Hyatt Inc' },
      { review: 'I didnt like it. pretty bad', author: 'Elison D. Joel', company: 'Lang - Hahn' },
      { review: 'None of it makes sence to me... But i think i liked it.', author: 'Lake Antonina', company: 'Boter - Becker' },
      { review: 'Bad', author: 'Unknown', company: 'N/A' },
      { review: 'Terrible. Never go to watch this movie, yopu will not enjoy it', author: 'Mark Zuckerberg', company: 'Meta' },
      { review: 'We need to regulate AI, before its too late.', author: 'Elon Musk', company: 'Twitter' },
      { review: 'Hi, I liked this film', author: 'Rafal Kesik', company: 'Wolters Kluwer' },
      { review: "I've never been a big fan of the Friday the 13th franchise, and the movies never really did much for me. But Crystal Lake turned out to be a pleasant surprise.", author: 'Nik Yaylor', company: 'IMDB' },
      { review: "Amazing lead actress, missing some horror elements", author: 'Laura Evans', company: 'Filmweb' },
      { review: "We need a second season NOW!!", author: 'Ray Kizon', company: 'IMDB' },
    ].shuffle.slice(0, amount)
  end

  def generate_random_movie_title(rng)
    templates = [
      "The #{Faker::Adjective.positive.to_s.capitalize} #{Faker::Creature::Animal.name.to_s.capitalize}",
      "#{Faker::Name.first_name}'s #{Faker::Science.element_state.to_s.capitalize}",
      "Return to #{Faker::Space.planet}",
      "The #{Faker::Job.field} from #{Faker::Address.city}",
      "#{Faker::Verb.ing_form.to_s.capitalize} in the #{Faker::Color.color_name.to_s.capitalize} #{Faker::Space.star_cluster}",
      "Attack of the #{Faker::Number.number(digits: 2)}ft #{Faker::Food.vegetables.to_s.capitalize}s",
      "How to #{Faker::Verb.base} Your #{Faker::Creature::Dog.breed}"
    ]

    templates.sample(random: rng)
  end

  def generate_review(rng)
    { author: Faker::Name.name.to_s.titleize,
      company: Faker::Company.name,
      review: [REVIEW_START, REVIEW_ENDING]
                .map{ |group| group.sample(random: rng).call}
                .join(" ")
    }
  end

  def generate_reviews(rng, amount)
    Array.new(amount.to_i) { generate_review(rng) }
  end

  def generate_film_texts(rng, actor_name, film_title)
    [TEASER_TEXTS.sample(random: rng), actor_name, film_title]
  end
end
