# frozen_string_literal: true

require 'json'
require_relative '../util/util'

# Gameboard class for the game
class Gameboard
  @@MAX_TURNS = 6

  def self.load_saved_game(path)
    data = JSON.parse File.read(path)
  end

  def initialize(player)
    @wrong_guesses = 0
    @word = load_word.split('')
    @guess_arr = Array.new(@word.length, '_')
    @player = player
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
        if @word[i] == guess
          @guess_arr[i] = guess
          @wrong_guesses -= 1
        end
      end
      @wrong_guesses += 1
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

  # HACK
  def load_word
    word = ''
    File.open('./assets/filtered_ words.txt', 'r') do |file|
      r = rand(file.size / 15)
      file.each_with_index { |line, index| return word = line.chomp if index == r }
    end
    word
  end
end
