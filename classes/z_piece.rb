require_relative 'game_piece'

class ZPiece < GamePiece
  def initialize(board, window)
    @piece_array = [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [7, 7, 7, 7, 0, 0],
      [7, 7, 7, 7, 0, 0],
      [0, 0, 7, 7, 7, 7],
      [0, 0, 7, 7, 7, 7]
    ]
    super(board, window)
    @position[:y] = -2
  end
end
