# frozen_string_literal: true

require_relative './classes/gameboard'
require_relative './classes/player'

def saves
  Dir['./saves/*']
end

def load_word
  word = ''
  File.open('./assets/filtered_ words.txt', 'r') do |file|
    r = rand(file.size / 15)
    file.each_with_index { |line, index| return word = line.chomp if index == r }
  end
  word
end

def start
  puts 'New game (0), Load game (1)'
  flag = gets.chomp

  case flag
  when '0'
    player = Player.new
    gameboard = Gameboard.init player, load_word.split('')
    gameboard.game_loop

  when '1'
    if saves.empty?
      puts 'No save games, restarting menu...'
      sleep(2)
      system('clear')
      start
    else
      system('clear')
      puts 'Choose a save game: '
      saves.each_with_index { |item, index| puts "#{index}) #{File.basename(item, '.json')}" }
      ans = gets.chomp.to_i
      gameboard = Gameboard.load_saved_game(saves[ans])
      gameboard.game_loop
    end
  else
    puts 'Good bye.'
  end
end

start
