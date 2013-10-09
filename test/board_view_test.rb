require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/board'
require './lib/board_view'

class BoardViewTest < Minitest::Test

  attr_reader :board_view

  def setup
    tic_tac_toe = StubTac.new
    board = Board.new
    @board_view = BoardView.new(tic_tac_toe, board)
  end

  def test_board_view_exists
    assert_kind_of BoardView, board_view
  end

end

class StubTac

  def method_missing(name, params)
    
  end

end
