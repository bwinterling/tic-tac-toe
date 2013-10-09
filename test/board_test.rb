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

  def test_winner_default_is_false
    refute board.winner?
  end

  def test_it_updates_status
    board.update_status([1,1], :x)
    assert_equal :x, board.status[[1,1]]
  end

  def test_it_can_reset
    board.update_status([1,1], :x)
    board.winner = :x
    board.reset
    assert_equal board.default_status, board.status
    assert_equal nil, board.winner
  end

  def test_vertical_winner
    board.update_status([1,1], :x)
    board.update_status([1,2], :x)
    board.update_status([1,3], :x)
    assert board.winner?
    assert_equal :x, board.winner

    board.reset
    board.update_status([2,1], :o)
    board.update_status([2,2], :o)
    board.update_status([2,3], :o)
    assert board.winner?
    assert_equal :o, board.winner

    board.reset
    board.update_status([2,1], :o)
    board.update_status([2,2], :o)
    board.update_status([2,3], :o)
    assert board.winner?
    assert_equal :o, board.winner
  end

  def test_horizontal_winner
    board.update_status([1,1], :x)
    board.update_status([2,1], :x)
    board.update_status([3,1], :x)
    assert board.winner?
    assert_equal :x, board.winner

    board.reset
    board.update_status([1,2], :o)
    board.update_status([2,2], :o)
    board.update_status([3,2], :o)
    assert board.winner?
    assert_equal :o, board.winner

    board.reset
    board.update_status([1,3], :o)
    board.update_status([2,3], :o)
    board.update_status([3,3], :o)
    assert board.winner?
    assert_equal :o, board.winner
  end

  def test_diagonal_winner
    board.update_status([1,1], :x)
    board.update_status([2,2], :x)
    board.update_status([3,3], :x)
    assert board.winner?
    assert_equal :x, board.winner

    board.reset
    board.update_status([1,3], :o)
    board.update_status([2,2], :o)
    board.update_status([3,1], :o)
    assert board.winner?
    assert_equal :o, board.winner
  end

  def test_tie
    board.status = {
      [1,1] => :x,
      [2,1] => :o,
      [3,1] => :x,
      [1,2] => :x,
      [2,2] => :o,
      [3,2] => :x,
      [1,3] => :o,
      [2,3] => :x,
      [3,3] => :o,
    }
    board.tie
    assert_equal :tie, board.winner
  end

end
