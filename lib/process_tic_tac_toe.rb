require 'ruby-processing'

class TicTacToe < Processing::App

  attr_accessor :cursor_location, :current_player, :current_availability

  def setup
    @cursor_location = default_cursor
    @current_availability = default_availability
    @current_player = 'player_x'
    coordinates
    smooth
  end

  def default_availability
    {
      [200,200] => "available",
      [400,200] => "available",
      [600,200] => "available",
      [200,400] => "available",
      [400,400] => "available",
      [600,400] => "available",
      [200,600] => "available",
      [400,600] => "available",
      [600,600] => "available",
    }
  end

  def default_cursor
    [200,200]
  end

  def draw
    background(255,255,255)
    generate_board
    instructions
    draw_past_moves
    evaluate_board
  end

  def evaluate_board
    unless winner?
      draw_next_move(@cursor_location)
    else
      draw_winner
    end
  end

  def winner?
    winning_combinations.each do |combination|
      winner = combination.all? { |location|
        location == combination[0] && combination[0] != "available"
      }
      puts winner
      if winner
        @winner = combination[0]
        puts "WINNER! #{@winner}"
      end
    end
    if @winner
      true
    else
      false
    end
  end

  def draw_winner
    puts @winner
  end

  def coordinates
    @a1 = current_availability[[200,200]]
    @a2 = current_availability[[400,200]]
    @a3 = current_availability[[600,200]]
    @b1 = current_availability[[200,400]]
    @b2 = current_availability[[400,400]]
    @b3 = current_availability[[600,400]]
    @c1 = current_availability[[200,600]]
    @c2 = current_availability[[400,600]]
    @c3 = current_availability[[600,600]]
  end

  def winning_combinations
    [
      [@a1, @a2, @a3],
      [@b1, @b2, @b3],
      [@c1, @c2, @c3],
      [@a1, @b1, @c1],
      [@a2, @b2, @c2],
      [@a3, @b3, @c3],
      [@a1, @b2, @c3],
      [@a3, @b2, @c1]
    ]
  end


  def draw_past_moves
    current_availability.each do |coordinates, availability|
      if availability == "player_x"
        draw_x(*coordinates)
      elsif availability == "player_o"
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
    elsif key == "\n"
      process_move
    end

  end

  def process_move
    unless @invalid_placement
      current_availability[cursor_location] = current_player
      toggle_player
    else
      draw_error(cursor_location, "you cant move there")
    end
    # reset cursor
  end

  def toggle_player
    if current_player == "player_x"
      self.current_player = "player_o"
    elsif current_player == "player_o"
      self.current_player = "player_x"
    end
  end

  def eval_next_move(desired_location)
    if current_availability[desired_location] == "available"
      @invalid_placement = false
      @cursor_location = desired_location
    elsif current_availability[desired_location] == "player_x" ||
          current_availability[desired_location] == "player_o"
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
    #text("use arrows to place move, enter to confirm", 10, 30)
  end

  def generate_board
    strokeWeight(5)
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
    if current_player == 'player_x'
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

