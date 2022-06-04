# frozen_string_literal: true

# Gameboard class for the game
class Gameboard
  def initialize(player)
    @word = load_word.split('')
    @guess_arr = Array.new(@word.length, '_')
    @player = player
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

  def print_info
    @guess_arr.each { |letter| print " #{letter} " }
  end
end

g = Gameboard.new 'asd'
g.print_info
