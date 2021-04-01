require_relative 'game_piece'

class OPiece < GamePiece
  def initialize(board, window)
    @piece_array = [
      [4, 4, 4, 4],
      [4, 4, 4, 4],
      [4, 4, 4, 4],
      [4, 4, 4, 4]
    ]
    super(board, window)
    @position[:y] = 0
  end
end