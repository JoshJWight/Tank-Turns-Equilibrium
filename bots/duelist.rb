class Duelist

  def bot_init(index, r, c)
    @index = index
    @r = r
    @c = c
  end

  def move(board, moves, newr, newc)
    @r = newr
    @c = newc
    if enemies_in_range(board, @r, @c) == 1
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
      return "s " + tr.to_s + " " + tc.to_s
    else
      tr = 0
      tc = 0
      min = 20
      for r in 0..9
        for c in 0..9
          if enemies_in_range(board, r, c) == 1 && dist(r, c) < min
            tr = r
            tc = c
            min = dist(r,c)
          end
        end
      end
    end

    if (@r-tr).abs > (@c-tc).abs
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

  def enemies_in_range(board, pr, pc)
    n = 0
    for r in 0..9
      for c in 0..9
        if dist_between(r, c, pr, pc)<=3 && board[r][c] && board[r][c][:id] != @index
          n+=1
        end
      end
    end
    return n
  end

  def dist_between(r1, c1, r2, c2)
    return (r1-r2).abs + (c1-c2).abs
  end

  def dist(r, c)
    return (@r-r).abs + (@c-c).abs
  end
end

return Duelist.new
