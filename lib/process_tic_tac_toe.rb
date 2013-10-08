require 'ruby-processing'
require './lib/board'

class TicTacToe < Processing::App

  attr_reader :board, :offset, :cursor
  attr_accessor :current_player

  def setup
    # coordinates
    @current_player = :x
    @board = Board.new
    @offset = 200
    smooth
  end

  def draw
    background(255,255,255)
    generate_board
    instructions
    evaluate_board
  end

  def evaluate_board
    unless board.winner?
      draw_past_moves
      draw_next_move(board.cursor_location)
    else
      draw_winner
    end
  end

  def draw_winner
    textSize(32)
    fill(20, 250, 25)
    textAlign(CENTER)
    text("WINNER IS... #{board.winner.to_s}", 400, 750)
    if board.winner == :x
      winner_x
    elsif board.winner == :o
      winner_o
    else
      winner_tie
    end
  end

  def winner_o
    d = 400
    stroke(25,250,25)
    strokeWeight(20)
    fill(255,255,255)
    ellipse(400,400,d,d)
  end

  def winner_x
    l = 250
    x = 400
    y = 400
    strokeWeight(20)
    stroke(25,250,25)
    line(x-l, y-l, x+l, y+l)
    line(x-l, y+l, x+l, y-l)
  end

  def winner_tie
    textSize(100)
    fill(255, 0, 0)
    textAlign(CENTER)
    text("TIE!!!", 400, 400)
  end

  def draw_past_moves
    board.status.each do |coordinates, availability|
      if availability == :x
        draw_x(*coordinates)
      elsif availability == :o
        draw_o(*coordinates)
      end
    end
  end

  def key_pressed
    if key == CODED
      new_location = board.cursor_location.dup
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
      board.cursor_location = board.default_cursor
    end

  end

  def process_move
    unless @invalid_placement
      board.update_status(board.cursor_location, current_player)
      toggle_player
    else
      draw_error(board.cursor_location, "you cant move there")
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
      @invalid_placement = false
      board.cursor_location = desired_location
    elsif board.status[desired_location] == :x ||
          board.status[desired_location] == :o
      board.cursor_location = desired_location
      @invalid_placement = true
    else
      draw_error(board.cursor_location, "You can't move there!")
      textSize(32)
      fill(100, 102, 153, 51)
      text("YOU CAN't MOVE THERE!", 10, 30)
    end
  end

  def instructions
    textSize(32)
    fill(0, 102, 153, 51)
    # fill(20, 250, 25)
    textAlign(CENTER)
    text("use arrows to place move, enter to confirm", 400, 50)
  end

  def generate_board
    strokeWeight(5)
    stroke(0,0,0)
    line(100, 300, 700, 300)
    line(100, 500, 700, 500)
    line(300, 100, 300, 700)
    line(500, 100, 500, 700)
  end

  def draw_next_move(cursor_location)
    x = cursor_location[0]
    y = cursor_location[1]
    unless @invalid_placement
      draw_rect(*cursor_location)
    else
      draw_invalid_rect(*cursor_location)
    end
    if current_player == :x
      draw_x(*cursor_location)
    else
      draw_o(*cursor_location)
    end
  end

  def draw_invalid_rect(x, y)
    x *= offset
    y *= offset
    textSize(25)
    fill(255,0,0)
    text("INVALID", x, y-75)
    rect(x-70,y-70,140,140)
  end

  def draw_rect(x, y)
    fill(215,215,215)
    x *= offset
    y *= offset
    rect(x-70,y-70,140,140)
  end

  def draw_error(cursor_location, error)
    x = cursor_location[0] * offset
    y = cursor_location[1] * offset
    fill(247,5,5)
    rect(x-70,y-70,140,140)

    #textSize(32)
    #fill(0, 102, 153, 51)
    #text(error)
  end

  def draw_o(x,y)
    d = 115
    fill(255,255,255)
    ellipse(x * offset,y * offset,d,d)
  end

  def draw_x(x,y)
    l = 50
    x *= offset
    y *= offset
    line(x-l, y-l, x+l, y+l)
    line(x-l, y+l, x+l, y-l)
  end

end

TicTacToe.new(:width => 800, :height => 800, :title => "Tic Tac Toe!")
