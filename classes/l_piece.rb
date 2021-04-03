require_relative 'game_piece'

class LPiece < GamePiece
  def initialize(board, window)
    @object_array = [
      [0, 0, 0, 0, 3, 3],
      [0, 0, 0, 0, 3, 3],
      [3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ]
    super(board, window)
    @position[:x] -= 2
    @position[:y] = 0
  end
end