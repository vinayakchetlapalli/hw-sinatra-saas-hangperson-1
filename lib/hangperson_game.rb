class HangpersonGame
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize()
    @word = self.get_random_word
    @guesses = ""
    @wrong_guesses = ""
  end
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end
  
  def isalpha?(letter) 
      /[[:alpha:]]/ =~ letter
  end
  
  def guess(letter)
    if isalpha?(letter) == nil
      raise ArgumentError.new("only letters are allowed")
    end
    
    
    letter = letter.downcase
    if guesses.include? letter or wrong_guesses.include? letter
      return false
    end 
    if word.include? letter
      guesses << letter
      true
    else 
      wrong_guesses << letter
      true
    end
  end
  
  def word_with_guesses
    chars = word.split("")
    result = ""
    chars.each { |c|
      if guesses.include? c 
        result << c
      else 
        result << "-"
      end
    }
    result
  end
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess_several_letters(game, letters)
    game.guess(letters[0])
    game.guess(letters[1])
  end
  
  def check_win_or_lose 
    if wrong_guesses.size() == 7
      return :lose
    elsif word_with_guesses == word
      return :win
    else 
      return :play
    end
  end
end
