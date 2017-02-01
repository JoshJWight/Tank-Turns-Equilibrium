class Berserker

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
    for r in 0..9
      for c in 0..9
        if board[r][c] and dist(r, c) < min and dist(r, c)!=0
          tr = r
          tc = c
          min = dist(r,c)
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

return Berserker.new
