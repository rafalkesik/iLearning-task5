class PagesController < ApplicationController
  def home
    @animations = %w[pulse grow pulse]
    # @animations = %w[slide-in drop-in grow] # slide-in może być z 4 stron przynajmniej
    # @animations = %w[shrink grow-and-shrink fade-in]

    @texts = [
      ["This fall", "Brad Pitt", "INCEPTION"],
      ["Best film ever", "Penelopa Cruz", "Code, Inc."]
    ]

    @copy = [
      { title: 'More Girls, Please',
        genre: 'Comedy',
        cast: ['John Smith', 'Lee K. Clare', 'DJ Queue'],
        year: '2023',
        length: '144',
        age: '13',
        director: 'Lee Jarmush',
        likes: 4,
        tag: 'Top 10',
        description: 'After years apart, a mother is forced to reunite with her husband.',
        reviews: [{ review: 'Best film eva!', author: 'Jack Smith', company: 'Hyatt Inc' },
                  { review: 'I didnt like it. pretty bad', author: 'Elison D. Joel', company: 'Lang - Hahn' },
                  { review: 'None of it makes sence to me... But i think i liked it.', author: 'Lake Antonina', company: 'Boter - Becker' }]
      },
      { title: 'Code, Inc.',
        genre: 'Drama',
        cast: ['John Smith', 'Nina Jones-Ackels'],
        year: '2025',
        length: '122',
        age: '18',
        director: 'Bob Kowalsky',
        likes: 1,
        tag: 'Top 100',
        description: 'Will machines take over the world? Find out!',
        reviews: [{ review: 'Bad', author: 'Unknown', company: 'N/A' },
                  { review: 'Terrible. Never go to watch this movie, yopu will not enjoy it', author: 'Mark Zuckerberg', company: 'Meta' },
                  { review: 'We need to regulate AI, before its too late.', author: 'Elon Musk', company: 'Twitter' }]
      }
    ]
  end
end