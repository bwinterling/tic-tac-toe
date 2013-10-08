require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'

class BoardTest < Minitest::Test

  attr_reader :board

  def setup
    @board = Board.new
  end

  def test_board_exists
    assert_kind_of Board, board
  end

  def test_default_status_returns_correct_values
    sample = {
      [1,1] => :open,
      [2,1] => :open,
      [3,1] => :open,
      [1,2] => :open,
      [2,2] => :open,
      [3,2] => :open,
      [1,3] => :open,
      [2,3] => :open,
      [3,3] => :open,
    }
    assert_equal sample, board.default_status
  end

  def test_default_cursor_location
    assert_equal [1,1], board.default_cursor
  end

  def test_winner_default_is_false
    refute board.winner?
  end

  def test_it_updates_status
    board.update_status([1,1], :x)
    assert_equal :x, board.status[[1,1]]
  end

  def test_vertical_winner
   
  end

end
