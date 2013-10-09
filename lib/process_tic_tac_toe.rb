require 'ruby-processing'
require './lib/board'
require './lib/board_view'

class TicTacToe < Processing::App

  attr_reader :board, :board_view
  attr_accessor :current_player, :cursor_location

  def setup
    # coordinates
    @current_player = :x
    @board = Board.new
    @board_view = BoardView.new(self, @board)
    @cursor_location = default_cursor
    smooth
    mouse_grid
  end

  def draw
    board_view.render
    evaluate_board
    mouse_grid
  end

  def default_cursor
    [1,1]
  end

  def evaluate_board
    unless board.winner?
      board_view.draw_past_moves
      board_view.draw_cursor(cursor_location)
    else
      board_view.draw_winner
    end
  end

  def key_pressed
    if key == CODED
      new_location = cursor_location.dup
      case key_code
        when UP
          new_location[1] -= 1
        when DOWN
          new_location[1] += 1
        when LEFT
          new_location[0] -= 1
        when RIGHT
          new_location[0] += 1
      end
      eval_next_move(new_location)
    elsif key == "\n" && ! board.winner
      process_move
    elsif key == "\n" && board.winner
      board.winner = nil
      board.status = board.default_status
      self.cursor_location = default_cursor
    end
  end

  def mouse_clicked
    unless board.winner
      process_move
    else
      board.winner = nil
      board.status = board.default_status
      self.cursor_location = default_cursor
    end
  end

  def mouse_moved
    mouse_location = []
    mouse_grid.each do |key, hash|
      if mouse_x < hash[:xmax] && mouse_x > hash[:xmin] && mouse_y < hash[:ymax] && mouse_y > hash[:ymin]
        eval_next_move(key)
      end
    end  
  end

  def mouse_grid
    @mouse_grid ||= build_mouse_grid
  end

  def build_mouse_grid
    mouse_grid = {}
    board.status.keys.each do |key|
      mouse_grid[key] = {
        :xmax => (key[0] * board_view.offset) + board_view.border,
        :xmin => ((key[0] - 1) * board_view.offset) + board_view.border,
        :ymax => (key[1] * board_view.offset) + board_view.border,
        :ymin => ((key[1] - 1) * board_view.offset) + board_view.border
      }
    end
    mouse_grid
  end 

  def process_move
    unless board.invalid_placement
      board.update_status(cursor_location, current_player)
      toggle_player
    else
      board_view.draw_error(cursor_location, "you cant move there")
    end
    # reset cursor
  end

  def toggle_player
    if current_player == :x
      self.current_player = :o
    elsif current_player == :o
      self.current_player = :x
    end
  end

  def eval_next_move(desired_location)
    if board.status[desired_location] == :open
      board.invalid_placement = false
      self.cursor_location = desired_location.dup
    elsif board.status[desired_location] == :x ||
          board.status[desired_location] == :o
      self.cursor_location = desired_location.dup
      board.invalid_placement = true
    else
      board_view.draw_error(cursor_location, "You can't move there!")
    end
  end

  def center_text
    textAlign(CENTER)
  end

end

TicTacToe.new(:width => 800, :height => 800, :title => "Tic Tac Toe!")
