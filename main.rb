# frozen_string_literal: true

require_relative './classes/gameboard'
require_relative './classes/player'

def saves
  Dir['./saves/*']
end

def start
  puts 'New game (0), Load game (1)'
  flag = gets.chomp

  case flag
  when '0'
    player = Player.new
    gameboard = Gameboard.new player
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
      Gameboard.load_saved_game(saves[ans])
    end
  else
    puts 'Good bye.'
  end
end

start
