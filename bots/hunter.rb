class Hunter

  def bot_init(index, r, c)
    @index = index
    @r = r
    @c = c
  end

  def move(board, moves, newr, newc)
    @r = newr
    @c = newc
    tr = 0
    tc = 0
    min = 20
    maxh = 0
    for r in 0..9
      for c in 0..9
        if board[r][c] && dist(r, c)!=0 && (board[r][c][:health] > maxh || (board[r][c][:health] == maxh && dist(r,c) < min))
          tr = r
          tc = c
          min = dist(r,c)
          maxh = board[r][c][:health]
        end
      end
    end
    if min <= 3
      return "s " + tr.to_s + " " + tc.to_s
    elsif (@r-tr).abs > (@c-tc).abs
      if tr<@r
        return "m u"
      else
        return "m d"
      end
    else
      if tc<@c
        return "m l"
      else
        return "m r"
      end
    end
  end

  def dist(r, c)
    return (@r-r).abs + (@c-c).abs
  end
end

return Hunter.new
