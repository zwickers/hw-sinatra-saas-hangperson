class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @word_with_guesses = ""
    @word.length.times do
      @word_with_guesses += "-"
    end
  end

  def check_win_or_lose
    if @word_with_guesses.include? "-" and wrong_guesses.length >= 7
      return :lose
    elsif @word_with_guesses.include? "-" and wrong_guesses.length < 7
      return :play
    else
      return :win
    end
  end

  def guess(letter)

    if letter == ""
      raise ArgumentError.new "A guess can't be empty!"
    end

    if letter.nil?
      raise ArgumentError.new "A guess has to be a letter!"
    end

    if /[^a-zA-Z]/.match letter.downcase
      raise ArgumentError.new "A guess has to be a letter!"
    end

    if @guesses.include? letter.downcase or @wrong_guesses.include? letter.downcase
      return false
    end

    if @word.include? letter
      @guesses += letter.downcase
    else
      @wrong_guesses += letter.downcase
    end

    idxs = indices_of_matches(@word, letter)

    idxs.each do |idx|
      @word_with_guesses[idx] = letter
    end

    return true
    
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

  def indices_of_matches(str, target)
    sz = target.size
    (0..str.size-sz).select { |i| str[i,sz] == target }
  end


end
