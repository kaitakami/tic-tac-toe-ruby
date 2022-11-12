# frozen_string_literal: true

# The game class controls the board game and saves the winning combinations
class Game
  def initialize
    @@board = Array.new(9, false)
    @@WINNING_COMBINATIONS = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]
    @@turn = 1 # 1 for player_one and 2 for player_two
    @@finished = false
  end

  def self.turn
    @@turn
  end

  def self.change_turn
    @@turn = @@turn == 1 ? 2 : 1
  end

  def self.add_new_position(position)
    if !@@board[position]
      @@board[position] = true
      true
    else
      false
    end
  end

  def self.finish_game
    @@finished = !@@finished
  end

  def self.finished?
    @@finished
  end

  def self.restart
    @@board = Array.new(9, false)
    @@turn = 1
  end
end

# There can be two instances of the Player Class. The instances use the Game superclass to check if a player has won
class Player < Game
  attr_accessor :board

  def initialize(player_number)
    super()
    @player_number = player_number
    @board = []
  end

  def end_round
    game_won?
  end

  private

  def game_won?
    @@WINNING_COMBINATIONS.any? do |combination|
      combination.all? { |number| @board.include?(number) }
    end
  end
end

# Play Game documentaion
module PlayGame
  def self.start_game
    player_one = Player.new(1)
    player_two = Player.new(2)
    play_round(player_one, player_two)
  end

  def self.play_round(player_one, player_two)
    until Game.finished?
      puts "🔴 Player 1 board is #{player_one.board}"
      puts "❌ Player 2 board is #{player_two.board}"
      puts "Is Player #{Game.turn} turn 👇"
      ask_player(player_one, player_two)
    end
  end

  def self.ask_player(player_one, player_two)
    until Game.finished?
      player_class = player_one if Game.turn == 1
      player_class = player_two if Game.turn == 2
      print 'Input your next position: '
      position = gets.chomp.to_i - 1
      check_position(position, player_class, player_one, player_two)
    end
  end

  def self.check_position(position, player_class, player_one, player_two)
    if player_two.board.length < 4
      if position.between?(0, 8) && Game.add_new_position(position)
        player_class.board.push(position)
        if player_class.end_round
          game_end(player_one, player_two)
          return
        else
          Game.change_turn
          play_round(player_one, player_two)
        end
      else
        puts 'The position is already ocuppied, choose a different position'
      end
    else
      puts "It's a tie 😞"
      restart_game?(player_one, player_two)
    end
  end

  def self.game_end(player_one, player_two)
    puts "🎉 Congrats player #{Game.turn} won! 🎉"
    restart_game?(player_one, player_two)
  end

  def self.restart_game?(player_one, player_two)
    print 'Want to reset❔ (Y/N) '
    reset = gets.chomp == 'Y'
    if reset
      puts 'Restarting game...⏳'
      player_one.board = []
      player_two.board = []
      Game.restart
      start_game
    else
      Game.finish_game
      puts 'Thank you for playing 🙋'
    end
  end
end

PlayGame.start_game
