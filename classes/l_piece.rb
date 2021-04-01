require_relative 'game_piece'

class LPiece < GamePiece
  def initialize(board, window)
    @piece_array = [
      [0, 0, 3, 3, 0, 0],
      [0, 0, 3, 3, 0, 0],
      [0, 0, 3, 3, 0, 0],
      [0, 0, 3, 3, 0, 0],
      [0, 0, 3, 3, 3, 3],
      [0, 0, 3, 3, 3, 3]
    ]
    super(board, window)
    @position[:y] = 0
  end
end