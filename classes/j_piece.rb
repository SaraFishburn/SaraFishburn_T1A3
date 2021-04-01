require_relative 'game_piece'

class JPiece < GamePiece
  def initialize(board, window)
    @piece_array = [
      [0, 0, 2, 2, 0, 0],
      [0, 0, 2, 2, 0, 0],
      [0, 0, 2, 2, 0, 0],
      [0, 0, 2, 2, 0, 0],
      [2, 2, 2, 2, 0, 0],
      [2, 2, 2, 2, 0, 0]
    ]
    super(board, window)
    @position[:y] = 0
  end
end