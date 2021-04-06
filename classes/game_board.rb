require_relative '../modules/draw'
require_relative 'i_piece'
require_relative 'j_piece'
require_relative 'l_piece'
require_relative 'o_piece'
require_relative 's_piece'
require_relative 't_piece'
require_relative 'z_piece'

class GameBoard
  include Draw
  attr_reader :object_array, :current_piece, :next_piece

  def initialize(window, game_board_width = 20, game_board_height = 40)
    @window = window
    @game_board_width = game_board_width
    @object_array = Array.new(game_board_height) { [0] * @game_board_width }
    @position = {
      x: 0,
      y: 0
    }
    @score = 0
    @level = 0
    @lines_cleared = 0
    @pieces = [IPiece, JPiece, LPiece, OPiece, SPiece, TPiece, ZPiece]
    assign_next_piece
    assign_next_piece
  end

  def calculate_ghost_piece
    @ghost_piece = @in_play.class.new(@object_array, @window)
    @ghost_piece.position[:x] = @in_play.position[:x]
    @ghost_piece.position[:y] = @in_play.position[:y]
    @ghost_piece.object_array = @in_play.object_array.map do |row|
      row.map { |cell| cell.zero? ? 0 : cell + 10 }
    end
    @ghost_piece.hard_drop(main_piece: false)
  end

  def create_piece
    @in_play = @current_piece.new(@object_array, @window)
    calculate_ghost_piece
  end

  def assign_next_piece
    @pieces -= [@next_piece]
    @pieces = [IPiece, JPiece, LPiece, OPiece, SPiece, TPiece, ZPiece] if @pieces.length.zero?

    @current_piece = @next_piece
    @next_piece = @pieces.sample
  end

  def user_input
    key = @window.getch
    case key
    when Curses::KEY_LEFT
      @in_play.move_left
      calculate_ghost_piece
    when Curses::KEY_RIGHT
      @in_play.move_right
      calculate_ghost_piece
    when Curses::KEY_UP
      @in_play.rotate_r
      calculate_ghost_piece
    when 'z'
      @in_play.rotate_l
      calculate_ghost_piece
    when Curses::KEY_DOWN
      @in_play.position = @ghost_piece.position
      @in_play.add_to_board
    end
  end

  def fall(content)
    create_piece
    display_next_piece(content[:next_window])
    loop do
      start_time = Time.now
      @speed = (0.8 - ((@level - 1) * 0.007))**(@level - 1)

      @window.erase
      @ghost_piece.draw
      @in_play.draw
      draw
      @window.noutrefresh

      unless @in_play.move_down((Time.now - start_time) / @speed)
        assign_next_piece
        create_piece
        display_next_piece(content[:next_window])
        break if game_over
      end
      user_input
      remove_lines
      calculate_level
      calculate_score
      stats(content[:lines_window], @lines_cleared)
      stats(content[:lvl_window], @level)
      stats(content[:score_window], @score)

      Curses.doupdate

      sleep([0, (1 / 60) - (Time.now - start_time)].max)
    end
  end

  def remove_lines
    @deleted_indexes = []
    @object_array.each_with_index do |line, i|
      next if line.include?(0)

      @lines_cleared += 0.5
      @deleted_indexes << i
    end
    @deleted_indexes.reverse.each { |i| @object_array.delete_at(i) }
    @object_array = Array.new(@deleted_indexes.length) { [0] * @game_board_width } + @object_array
    @deleted_indexes
  end

  def calculate_level
    @level = (@lines_cleared / 10).floor
  end

  def calculate_score
    case (@deleted_indexes.length / 2)
    when 1
      @score += 40 * (@level + 1)
    when 2
      @score += 100 * (@level + 1)
    when 3
      @score += 300 * (@level + 1)
    when 4
      @score += 1200 * (@level + 1)
    end
  end

  def display_next_piece(next_window)
    next_window.erase
    piece = @next_piece.new([[0] * next_window.maxx] * next_window.maxy, next_window)
    piece.position[:y] = (piece.board.length / 2) - (piece.object_array.length / 2)
    piece.position[:x] = (piece.board[0].length / 2) - (piece.object_array[0].length / 2)
    piece.draw
    next_window.noutrefresh
  end

  def stats(window, stat)
    stat = stat.to_i.to_s
    window.erase
    window.setpos((window.maxy / 2), (window.maxx / 2) - (stat.length / 2))
    window.addstr(stat)
    window.noutrefresh
  end

  def game_over
    return false if @object_array[0].all?(&:zero?)

    message = 'game over :('
    @window.clear
    @window.setpos(@window.maxy / 2 - 1, @window.maxx / 2 - message.length / 2)
    @window.addstr(message)
    @window.refresh
    true
  end
end
