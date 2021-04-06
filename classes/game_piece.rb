require_relative '../modules/draw'

class GamePiece
  attr_accessor :position, :board, :object_array

  include Draw
  def initialize(board, window)
    @board = board
    @window = window
    @position = {
      x: (@board[0].length / 2) - ((@object_array[0].length / 2 / 2.0).floor * 2),
      y: 0
    }
    @rotation_state = [0, 0]
  end

  def rotate_r
    original_state = @rotation_state.dup
    @object_array = @object_array.transpose.map(&:reverse)
    @rotation_state[0] = @rotation_state[1]
    @rotation_state[1] = (@rotation_state[1] + 1) % 4

    return if check_wall_kick

    @object_array = @object_array.transpose.reverse
    @rotation_state = original_state
  end

  def rotate_l
    original_state = @rotation_state.dup
    @object_array = @object_array.transpose.reverse
    @rotation_state[0] = @rotation_state[1]
    @rotation_state[1] = (@rotation_state[1] - 1) % 4

    return if check_wall_kick

    @object_array = @object_array.transpose.map(&:reverse)
    @rotation_state = original_state
  end

  def move_left
    @position[:x] -= 2
    @position[:x] += 2 unless is_valid_position?
  end

  def move_right
    @position[:x] += 2
    @position[:x] -= 2 unless is_valid_position?
  end

  def move_down(speed, main_piece: true)
    @position[:y] += speed * 2
    return true if is_valid_position?

    @position[:y] -= speed * 2
    add_to_board if main_piece
    false
  end

  def hard_drop(main_piece: true)
    while move_down(1, main_piece: main_piece)
    end
  end

  def is_valid_position?
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero? || (position_y + y).negative?

        if position_y + y >= @board.length ||
           (@position[:x] + x).negative? || @position[:x] + x >= @board[0].length ||
           !@board[position_y + y][@position[:x] + x].zero?
          return false
        end
      end
    end
    true
  end

  def check_wall_kick
    return true if is_valid_position?

    wall_kick_data[@rotation_state[0]][@rotation_state[1]].each do |pair|
      @position[:x] += pair[:x] * 2
      @position[:y] += pair[:y] * 2
      return true if is_valid_position?

      @position[:x] -= pair[:x] * 2
      @position[:y] -= pair[:y] * 2
    end
    false
  end

  def add_to_board
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero?

        @board[position_y + y][@position[:x] + x] = cell
      end
    end
  end
end
