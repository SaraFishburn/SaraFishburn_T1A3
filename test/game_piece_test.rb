# frozen_string_literal: true

require 'test/unit'
require_relative '../classes/game_board'
require_relative '../classes/i_piece'

class GamePieceTest < Test::Unit::TestCase
  def setup
    @game_board = GameBoard.new(nil)
  end

  def test_new_instance
    [IPiece, JPiece, LPiece, OPiece, SPiece, TPiece, ZPiece].each do |piece_class|
      new_piece = piece_class.new(@game_board.object_array, @game_board.window)
      assert_not_nil(new_piece)
    end
  end

  def test_rotate_r
    new_i_piece = IPiece.new(@game_board.object_array, @game_board.window)
    new_i_piece.rotate_r
    assert_equal(
      new_i_piece.object_array,
      [
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0]
      ]
    )

    new_t_piece = TPiece.new(@game_board.object_array, @game_board.window)
    new_t_piece.rotate_r
    assert_equal(
      new_t_piece.object_array,
      [
        [0, 0, 6, 6, 0, 0],
        [0, 0, 6, 6, 0, 0],
        [0, 0, 6, 6, 6, 6],
        [0, 0, 6, 6, 6, 6],
        [0, 0, 6, 6, 0, 0],
        [0, 0, 6, 6, 0, 0]
      ]
    )
  end

  def test_rotate_l
    new_i_piece = IPiece.new(@game_board.object_array, @game_board.window)
    new_i_piece.rotate_l
    assert_equal(
      new_i_piece.object_array,
      [
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0]
      ]
    )

    new_t_piece = TPiece.new(@game_board.object_array, @game_board.window)
    new_t_piece.rotate_l
    assert_equal(
      new_t_piece.object_array,
      [
        [0, 0, 6, 6, 0, 0],
        [0, 0, 6, 6, 0, 0],
        [6, 6, 6, 6, 0, 0],
        [6, 6, 6, 6, 0, 0],
        [0, 0, 6, 6, 0, 0],
        [0, 0, 6, 6, 0, 0]
      ]
    )
  end
end
