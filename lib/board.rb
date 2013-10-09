class Board

  attr_accessor :status, :winner, :cursor_location, :invalid_placement,
                :most_recent_move

  def initialize
    @status          = default_status
    @invalid_placement = false
    @most_recent_move = nil
  end

  def default_status
    {
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
  end

  def reset
    @status            = default_status
    @winner            = nil
    @invalid_placement = false
    @most_recent_move = nil
  end

  def update_status(location, player)
    status[location] = player
  end

  def winner?
    vertical_winner || horizontal_winner || diagonal_winner || tie
  end

  def tie
    if !status.has_value?(:open)
      @winner = :tie
    end
  end

  def vertical_winner

    @winner = nil

    if status[[1,1]] == :x && status[[1,2]] == :x && status[[1,3]] == :x
      @winner = :x
    end

    if status[[2,1]] == :x && status[[2,2]] == :x && status[[2,3]] == :x
      @winner = :x
    end

    if status[[3,1]] == :x && status[[3,2]] == :x && status[[3,3]] == :x
      @winner = :x
    end

    if status[[1,1]] == :o && status[[1,2]] == :o && status[[1,3]] == :o
      @winner = :o
    end

    if status[[2,1]] == :o && status[[2,2]] == :o && status[[2,3]] == :o
      @winner = :o
    end

    if status[[3,1]] == :o && status[[3,2]] == :o && status[[3,3]] == :o
      @winner = :o
    end

    @winner
  end

  def horizontal_winner

    @winner = nil

    if status[[1,1]] == :x && status[[2,1]] == :x && status[[3,1]] == :x
      @winner = :x
    end

    if status[[1,2]] == :x && status[[2,2]] == :x && status[[3,2]] == :x
      @winner = :x
    end

    if status[[1,3]] == :x && status[[2,3]] == :x && status[[3,3]] == :x
      @winner = :x
    end

    if status[[1,1]] == :o && status[[2,1]] == :o && status[[3,1]] == :o
      @winner = :o
    end

    if status[[1,2]] == :o && status[[2,2]] == :o && status[[3,2]] == :o
      @winner = :o
    end

    if status[[1,3]] == :o && status[[2,3]] == :o && status[[3,3]] == :o
      @winner = :o
    end

    @winner
  end

  def diagonal_winner

    @winner = nil

    if status[[1,1]] == :x && status[[2,2]] == :x && status[[3,3]] == :x
      @winner = :x
    end

    if status[[1,3]] == :x && status[[2,2]] == :x && status[[3,1]] == :x
      @winner = :x
    end

    if status[[1,1]] == :o && status[[2,2]] == :o && status[[3,3]] == :o
      @winner = :o
    end

    if status[[1,3]] == :o && status[[2,2]] == :o && status[[3,1]] == :o
      @winner = :o
    end
    @winner
  end  

end
