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
    generate_board
    instructions
  end

  def draw_background
    app.background(255,255,255)
    bg = app.load_image('./resources/images/bg-tic-tag-toe.png', 'png')
    app.image(bg, 0, 0)
  end

  def draw_winner
    if board.winner == :x
      winner_x
    elsif board.winner == :o
      winner_o
    else
      winner_tie
    end
  end

  def winner_o
    img = app.load_image('./resources/images/winner_o.png', 'png')
    app.image(img, 200, 155)
  end

  def winner_x
    img = app.load_image('./resources/images/winner_x.png', 'png')
    app.image(img, 200, 155)
  end

  def winner_tie
    img = app.load_image('./resources/images/tie.png', 'png')
    app.image(img, 90, 185)
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
    draw_background
  end

  def draw_cursor(cursor_location)
    x = cursor_location[0]
    y = cursor_location[1]
    unless board.invalid_placement
      if app.current_player == :x
        draw_move_x(*cursor_location)
      else
        draw_move_o(*cursor_location)
      end
    else
      draw_invalid_move(*cursor_location)
    end
  end

  def draw_move_o(x,y)
    x *= offset
    y *= offset
    img = app.load_image('./resources/images/move_o.png', 'png')
    app.image(img, x - 70, y - 70)
  end

  def draw_move_x(x,y)
    x *= offset
    y *= offset
    img = app.load_image('./resources/images/move_x.png', 'png')
    app.image(img, x - 70, y - 70)
  end

  def draw_invalid_move(x, y)
    if app.current_player == :x
      draw_x(x,y)
    else
      draw_o(x,y)
    end
    x *= offset
    y *= offset
    img = app.load_image('./resources/images/error.png', 'png')
    app.image(img, x - 70, y - 70)
  end

  def draw_error(cursor_location, error)
    draw_invalid_move(*cursor_location)
  end

  def draw_o(x,y)
    #d = 115
    #app.fill(255,255,255)
    x *= offset
    y *= offset
    img = app.load_image('./resources/images/o.png', 'png')
    app.image(img, x - 70, y - 70)
  end

  def draw_x(x,y)
    l = 50
    x *= offset
    y *= offset
    img = app.load_image('./resources/images/x.png', 'png')
    app.image(img, x - 70, y - 70)
  end

end
