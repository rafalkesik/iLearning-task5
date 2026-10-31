module CopyHelper

  def roll_amount_from_float(float_input)
    amount = float_input.floor()
    addition = rand < (float_input % 1) ? 1 : 0
    
    amount + addition
  end

  def generate_film_data_object(seed, likes_input, reviews_input)
    { title: 'More Girls, Please',
      genre: 'Comedy',
      cast: ['John Smith', 'Lee K. Clare', 'DJ Queue'],
      year: '2023',
      length: '144',
      age: '13',
      director: 'Lee Jarmush',
      likes: roll_amount_from_float(likes_input),
      tag: 'Top 10',
      description: 'After years apart, a mother is forced to reunite with her husband.',
      reviews: generate_reviews(roll_amount_from_float(reviews_input))
      }
  end

  def generate_reviews(amount)
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
end
