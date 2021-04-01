require_relative 'game_piece'

class IPiece < GamePiece
  def initialize(board, window)
    @piece_array = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1]
    ]
    super(board, window)
    @position[:y] = -2
  end
end