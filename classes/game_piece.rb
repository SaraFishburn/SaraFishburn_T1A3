require 'curses'

class GamePiece
  def initialize(board, window)
    @board = board
    @window = window
    @position = {
      x: (@board[0].length / 2) - (@piece_array[0].length / 2),
      y: 0
    }
  end

  def rotate
    @piece_array = @piece_array.transpose.map(&:reverse)
  end

  def draw_to_board
    @piece_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero?

        @window.attron(Curses.color_pair(cell))
        @window.setpos(@position[:y] + y, @position[:x] + x)
        @window.addch(cell.to_s)
        @window.attroff(Curses.color_pair(cell))
      end
    end
  end

  def fall; end
end
