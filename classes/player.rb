# frozen_string_literal: true

# Class for player
class Player
  attr_reader :guesses

  def initialize(guesses = [])
    @guesses = guesses
  end

  def make_guess
    puts 'Enter a guess ("*" for save): '
    guess = gets.chomp[0].downcase
    unless @guesses.include?(guess)
      @guesses << guess unless guess == '*'
      return guess
    end

    puts "You've already tried this letter, try again."
    make_guess
  end
end
