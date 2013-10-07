require 'ruby-processing'

class TicTacToe < Processing::App

  attr_accessor :cursor_location, :current_player, :status

  def setup
    @cursor_location = default_cursor
    @status = default_status
    @current_player = :x
    coordinates
    smooth
  end

  def default_status
    {
      [200,200] => :open,
      [400,200] => :open,
      [600,200] => :open,
      [200,400] => :open,
      [400,400] => :open,
      [600,400] => :open,
      [200,600] => :open,
      [400,600] => :open,
      [600,600] => :open,
    }
  end

  def default_cursor
    [200,200]
  end

  def draw
    background(255,255,255)
    generate_board
    instructions
    evaluate_board
  end

  def evaluate_board
    unless winner?
      draw_past_moves
      draw_next_move(@cursor_location)
    else
      draw_winner
    end
  end

  def winner?
    vertical_winner || horizontal_winner || diagonal_winner
  end

  def vertical_winner

    @winner = nil

    if status[[200,200]] == :x && status[[200,400]] == :x && status[[200,600]] == :x
      @winner = :x
    end

    if status[[400,200]] == :x && status[[400,400]] == :x && status[[400,600]] == :x
      @winner = :x
    end

    if status[[600,200]] == :x && status[[600,400]] == :x && status[[600,600]] == :x
      @winner = :x
    end

    if status[[200,200]] == :o && status[[200,400]] == :o && status[[200,600]] == :o
      @winner = :o
    end

    if status[[400,200]] == :o && status[[400,400]] == :o && status[[400,600]] == :o
      @winner = :o
    end

    if status[[600,200]] == :o && status[[600,400]] == :o && status[[600,600]] == :o
      @winner = :o
    end

    @winner
  end

  def horizontal_winner

    @winner = nil

    if status[[200,200]] == :x && status[[400,200]] == :x && status[[600,200]] == :x
      @winner = :x
    end

    if status[[200,400]] == :x && status[[400,400]] == :x && status[[600,400]] == :x
      @winner = :x
    end

    if status[[200,600]] == :x && status[[400,600]] == :x && status[[600,600]] == :x
      @winner = :x
    end

    if status[[200,200]] == :o && status[[400,200]] == :o && status[[600,200]] == :o
      @winner = :o
    end

    if status[[200,400]] == :o && status[[400,400]] == :o && status[[600,400]] == :o
      @winner = :o
    end

    if status[[200,600]] == :o && status[[400,600]] == :o && status[[600,600]] == :o
      @winner = :o
    end

    @winner
  end

  def diagonal_winner

    @winner = nil

    if status[[200,200]] == :x && status[[400,400]] == :x && status[[600,600]] == :x
      @winner = :x
    end

    if status[[200,600]] == :x && status[[400,400]] == :x && status[[600,200]] == :x
      @winner = :x
    end

    if status[[200,200]] == :o && status[[400,400]] == :o && status[[600,600]] == :o
      @winner = :o
    end

    if status[[200,600]] == :o && status[[400,400]] == :o && status[[600,200]] == :o
      @winner = :o
    end


    @winner

  end


  def draw_winner
    textSize(32)
    fill(20, 250, 25)
    textAlign(CENTER)
    text("WINNER IS... #{@winner.to_s}", 400, 750)
    if @winner == :x
      winner_x
    else
      winner_o
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

  def draw_past_moves
    status.each do |coordinates, availability|
      if availability == :x
        draw_x(*coordinates)
      elsif availability == :o
        draw_o(*coordinates)
      end
    end
  end

  def key_pressed
    if key == CODED
      new_location = cursor_location.dup
      case key_code
        when UP
          new_location[1] -= 200
        when DOWN
          new_location[1] += 200
        when LEFT
          new_location[0] -= 200
        when RIGHT
          new_location[0] += 200
      end
      eval_next_move(new_location)
    elsif key == "\n" && ! @winner
      process_move
    elsif key == "\n" && @winner
      @winner == nil
      @status = default_status
      @cursor_location = default_cursor
    end

  end

  def process_move
    unless @invalid_placement
      status[cursor_location] = current_player
      toggle_player
    else
      draw_error(cursor_location, "you cant move there")
    end
    # reset cursor
  end

  def coordinates
    @a1 = status[[200,200]]
    @a2 = status[[400,200]]
    @a3 = status[[600,200]]
    @b1 = status[[200,400]]
    @b2 = status[[400,400]]
    @b3 = status[[600,400]]
    @c1 = status[[200,600]]
    @c2 = status[[400,600]]
    @c3 = status[[600,600]]
  end

  def toggle_player
    if current_player == :x
      self.current_player = :o
    elsif current_player == :o
      self.current_player = :x
    end
  end

  def eval_next_move(desired_location)
    if status[desired_location] == :open
      @invalid_placement = false
      @cursor_location = desired_location
    elsif status[desired_location] == :x ||
          status[desired_location] == :o
      @cursor_location = desired_location
      @invalid_placement = true
    else
      draw_error(@cursor_location, "You can't move there!")
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
      fill(215,215,215)
    else
      textSize(25)
      fill(255,0,0)
      text("INVALID", x-45, y-75)
    end
    rect(x-70,y-70,140,140)
    if current_player == :x
      draw_x(x, y)
    else
      draw_o(x, y)
    end
  end

  def draw_error(cursor_location, error)
    x = cursor_location[0]
    y = cursor_location[1]
    fill(247,5,5)
    rect(x-70,y-70,140,140)

    #textSize(32)
    #fill(0, 102, 153, 51)
    #text(error)
  end

  def draw_o(x,y)
    d = 115
    fill(255,255,255)
    ellipse(x,y,d,d)
  end

  def draw_x(x,y)
    l = 50
    line(x-l, y-l, x+l, y+l)
    line(x-l, y+l, x+l, y-l)
  end

end

TicTacToe.new(:width => 800, :height => 800, :title => "Tic Tac Toe!")

