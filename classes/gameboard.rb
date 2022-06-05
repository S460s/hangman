# frozen_string_literal: true

require 'json'
require_relative '../util/util'
require_relative './player'

# Gameboard class for the game
class Gameboard
  @@MAX_TURNS = 6

  def initialize(wrong_guesses, word, guess_arr, player)
    @wrong_guesses = wrong_guesses
    @word = word
    @guess_arr = guess_arr
    @player = player
  end

  def self.load_saved_game(path)
    data = JSON.parse File.read(path)
    player = Player.new data['guesses']
    new(data['wrong_guesses'], data['word'], data['guess_arr'], player)
  end

  def self.init(player, word)
    new(0, word, Array.new(word.length, '_'), player)
  end

  def game_loop
    until gameover?
      print_info
      make_guess
    end
    handle_gg
  end

  private

  def handle_gg
    print_info
    if win?
      puts 'You won!'
    else
      puts 'You lost!'
    end
  end

  def print_info
    p @word
    puts "Previous tries: #{@player.guesses.join(' ')}"
    puts "Tries left: #{@@MAX_TURNS - @wrong_guesses}"
    puts Util::STAGES[@wrong_guesses]
    puts @guess_arr.join(' ')
  end

  def gameover?
    win? || @wrong_guesses == @@MAX_TURNS
  end

  def win?
    @word == @guess_arr
  end

  def make_guess
    guess = @player.make_guess
    if guess == '*'
      system('clear')
      save
    else
      @word.each_index do |i|
        @guess_arr[i] = guess if @word[i] == guess
      end
      @wrong_guesses += 1 unless @word.include?(guess)
      system('clear')
    end
  end

  def save
    print 'Enter save name: '
    name = gets.chomp
    if File.exist?("./saves/#{name}.json")
      puts 'There is already a save with this name.'
      save
    else
      json = JSON.dump({ wrong_guesses: @wrong_guesses, word: @word, guess_arr: @guess_arr, guesses: @player.guesses })
      File.open("./saves/#{name}.json", 'w') { |file| file.puts json }
      puts 'Game saved!'
    end
  end
end
