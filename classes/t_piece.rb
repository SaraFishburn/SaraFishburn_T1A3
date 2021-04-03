require_relative 'game_piece'

class TPiece < GamePiece
  def initialize(board, window)
    @object_array = [
      [0, 0, 6, 6, 0, 0],
      [0, 0, 6, 6, 0, 0],
      [6, 6, 6, 6, 6, 6],
      [6, 6, 6, 6, 6, 6],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ]
    super(board, window)
    @position[:y] = 0
  end
end
