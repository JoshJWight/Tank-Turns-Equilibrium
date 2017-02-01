class Coward

  def bot_init(index, r, c)
    @index = index
    @r = r
    @c = c
  end

  def move(board, moves, newr, newc)
    @r = newr
    @c = newc
    dist = dist_to_enemy(board, @r, @c)
    if dist<=2
      enemy = nearest_enemy(board)
      return "s " + enemy[:r].to_s + " " + enemy[:c].to_s
    elsif is_valid(@r-1, @c) && dist_to_enemy(board, @r-1, @c)>dist
      return "m u"
    elsif is_valid(@r+1, @c) && dist_to_enemy(board, @r+1, @c)>dist
      return "m d"
    elsif is_valid(@r, @c-1) && dist_to_enemy(board, @r, @c-1)>dist
      return "m l"
    elsif is_valid(@r, @c+1) && dist_to_enemy(board, @r, @c+1)>dist
      return "m r"
    elsif dist <=3
      enemy = nearest_enemy(board)
      return "s " + enemy[:r].to_s + " " + enemy[:c].to_s
    else
      return "do nothing"
    end
  end

  def dist_to_enemy(board, pr, pc)
    min = 20
    for r in 0..9
      for c in 0..9
        if dist_between(pr, pc, r, c) < min && (board[r][c] && board[r][c][:id] != @index)
          min = dist_between(pr, pc, r, c)
        end
      end
    end
    return min
  end

  def nearest_enemy(board)
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
    return {r: tr, c: tc}
  end

  def is_valid(r, c)
    return r>=0 && r<=9 && c>=0 && c<=9
  end

  def is_safe(board, tr, tc)
    for r in 0..9
      for c in 0..9
        if dist_between(r, c, tr, tc)<=3 && board[r][c] && board[r][c][:id] != @index
          return false
        end
      end
    end
    return true
  end

  def dist(r, c)
    return (@r-r).abs + (@c-c).abs
  end

  def dist_between(r1, c1, r2, c2)
    return (r1-r2).abs + (c1-c2).abs
  end
end

return Coward.new
