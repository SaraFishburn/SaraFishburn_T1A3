require 'test/unit'
require_relative '../classes/game_board'

# Test class to check that elements of the GameBoard class are working as expected
class GamePieceTest < Test::Unit::TestCase
  def setup
    @game_board = GameBoard.new(nil)
  end

  # Test that when genearted, the game pieces exist and are not nil
  def test_new_instance
    new_board = GameBoard.new(nil)
    assert_not_nil(new_board)
  end

  # Test that the score alculation method produces the correct figure
  def test_calculate_score
    @game_board.deleted_indexes = [1, 2]
    @game_board.level = 5
    @game_board.calculate_score
    assert_equal(
      @game_board.score,
      240
    )

    @game_board.deleted_indexes = [1, 2, 3, 4, 5, 6, 7, 8]
    @game_board.level = 15
    @game_board.calculate_score

    assert_equal(
      @game_board.score,
      240 + 19_200
    )
  end

  # Test that the level alculation method produces the correct figure
  def test_calculate_level
    @game_board.lines_cleared = 67
    @game_board.calculate_level
    assert_equal(
      @game_board.level,
      6
    )

    @game_board.lines_cleared = 123
    @game_board.calculate_level
    assert_equal(
      @game_board.level,
      12
    )
  end
end
