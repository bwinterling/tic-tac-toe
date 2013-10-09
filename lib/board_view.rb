class BoardView

  attr_reader :app, :board, :width

  def initialize(app, board)
    @board = board
    @app = app
    @width = app.width
  end

  def offset
    width / 4
  end

  def border
    offset / 2
  end

  def render
    app.background(255,255,255)
    generate_board
    instructions
  end

  def draw_winner
    app.textSize(32)
    app.fill(20, 250, 25)
    app.center_text
    app.text("WINNER IS... #{board.winner.to_s}", 400, 750)
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
    app.stroke(25,250,25)
    app.strokeWeight(20)
    app.fill(255,255,255)
    app.ellipse(400,400,d,d)
  end

  def winner_x
    l = 250
    x = 400
    y = 400
    app.strokeWeight(20)
    app.stroke(25,250,25)
    app.line(x-l, y-l, x+l, y+l)
    app.line(x-l, y+l, x+l, y-l)
  end

  def winner_tie
    app.textSize(100)
    app.fill(255, 0, 0)
    app.center_text
    app.text("TIE!!!", 400, 400)
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

  def instructions
    app.textSize(32)
    app.fill(0, 102, 153, 51)
    # fill(20, 250, 25)
    app.center_text
    app.text("use arrows to place move, enter to confirm", 400, 50)
  end

  def generate_board
    app.strokeWeight(5)
    app.stroke(0,0,0)
    app.line(100, 300, 700, 300)
    app.line(100, 500, 700, 500)
    app.line(300, 100, 300, 700)
    app.line(500, 100, 500, 700)
  end

  def draw_cursor(cursor_location)
    x = cursor_location[0]
    y = cursor_location[1]
    unless board.invalid_placement
      draw_rect(*cursor_location)
    else
      draw_invalid_rect(*cursor_location)
    end
    if app.current_player == :x
      draw_x(*cursor_location)
    else
      draw_o(*cursor_location)
    end
  end

  def draw_invalid_rect(x, y)
    x *= offset
    y *= offset
    app.textSize(25)
    app.fill(255,0,0)
    app.text("INVALID", x, y-75)
    app.rect(x-70,y-70,140,140)
  end

  def draw_rect(x, y)
    app.fill(215,215,215)
    x *= offset
    y *= offset
    app.rect(x-70,y-70,140,140)
  end

  def draw_error(cursor_location, error)
    x = cursor_location[0] * offset
    y = cursor_location[1] * offset
    app.fill(247,5,5)
    app.rect(x-70,y-70,140,140)

    #app.textSize(32)
    #app.fill(0, 102, 153, 51)
    #app.text(error)
  end

  def draw_o(x,y)
    d = 115
    app.fill(255,255,255)
    app.ellipse(x * offset,y * offset,d,d)
  end

  def draw_x(x,y)
    l = 50
    x *= offset
    y *= offset
    app.line(x-l, y-l, x+l, y+l)
    app.line(x-l, y+l, x+l, y-l)
  end

end
