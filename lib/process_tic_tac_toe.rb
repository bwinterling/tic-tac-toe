require 'ruby-processing'
require './lib/board'
require './lib/board_view'

class TicTacToe < Processing::App

  attr_reader :board, :board_view, :cursor_location
  attr_accessor :current_player

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
      new_location = cursor_location
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
      cursor_location = default_cursor
    end
  end

  def mouse_moved

  end

  def mouse_grid
    # mouse_grid = board.status.keys.each_with_object({}) do |key, grid|
    #   max_mins = Hash.new
    #   max_mins[:xmax] = key[0] * board_view.offset + board_view.border
    #   max_mins[:xmin] = key[0] * board_view.border
    #   max_mins[:ymax] = key[1] * board_view.offset + board_view.border
    #   max_mins[:ymin] = key[1] * board_view.border
    #   grid[key] = max_mins
    # end
    # pp mouse_grid
  end 

  # def mouse_grid
  #   {
  #     [1,1] => {
  #       "xmax" => 1 * board_view.offset + board_view.border,
  #       "xmin" => 1 * board_view.border,
  #       "ymax" => 1 * board_view.offset + board_view.border,
  #       "ymin" => 1 * board_view.border
  #     },
  #     [2,1] => :open,
  #     [3,1] => :open,
  #     [1,2] => :open,
  #     [2,2] => :open,
  #     [3,2] => :open,
  #     [1,3] => :open,
  #     [2,3] => :open,
  #     [3,3] => :open,
  #   }
  # end

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
      cursor_location = desired_location
    elsif board.status[desired_location] == :x ||
          board.status[desired_location] == :o
      cursor_location = desired_location
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
