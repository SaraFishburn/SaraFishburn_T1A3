require_relative 'game_piece'

class SPiece < GamePiece
  def initialize(board, window)
    @object_array = [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 5, 5, 5, 5],
      [0, 0, 5, 5, 5, 5],
      [5, 5, 5, 5, 0, 0],
      [5, 5, 5, 5, 0, 0]
    ]
    super(board, window)
    @position[:y] = -2
  end
end
