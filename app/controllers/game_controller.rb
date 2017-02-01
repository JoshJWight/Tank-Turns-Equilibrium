class GameController < ApplicationController
  def index
  end

  def play
    winner = run_game(Array.new(10){|i| select_bot})
    if winner
      bot = Bot.find(winner.id)
      log "Adding 10 population to: " + bot.name
      bot.population +=10
      bot.save
    end
  end

  def log(s)
    puts s
    if !@log
      @log = ""
    end
    @log += s + "\n"
  end

  def logBoard(b)
    hline = Array.new(53).join("_")
    log hline
    log "   " + ((0..9).map(&:to_s)).join("  | ")
    log hline
    for r in 0..9
      for c in 0..9
        if b[r][c] == nil
          b[r][c] = "    "
        else
          b[r][c] = b[r][c][:id].to_s + "(" + b[r][c][:health].to_s + ")"
        end
      end
      log r.to_s + "|" + b[r].join("|") + "|"
      log hline
    end
  end

  def select_bot
    total_pop = 0
    Bot.all.each do |bot|
      total_pop += bot.population
    end
    n = rand(total_pop)
    i = 0
    Bot.all.each do |bot|
      i += bot.population
      if i > n
        bot.population-=1
        bot.save
        return bot
      end
    end
  end

  def instantiate_bot(bot)
    eval(bot.code)
  end

  #bots is an array of Bot objects
  #returns the Bot that is the winner, or nil if there is no winner
  def run_game(bots)
    players = Array.new(bots.length)
    board = Array.new(10) {|i| Array.new(10)}
    bots.each_with_index do |bot, index|
      botObj = instantiate_bot(bot)
      done = false;
      begin
        r = rand(10)
        c = rand(10)
        if board[r][c] == nil
          botObj.try(:bot_init, index, r, c)
          board[r][c] = {id: index, health: 3}
          players[index] = {bot: botObj, name: bot.name, id: index, health: 3, r: r, c: c}
          log( "Player " + index.to_s + " (" + players[index][:name] + ") starts at " + r.to_s + ", " + c.to_s)
          done = true
        end
      end while !done
    end

    nPlayers = players.length
    drainTimer = 0;
    lastMoves = Array.new(players.length)

    #GAME LOOP STARTS HERE
    while nPlayers>1 do
      logBoard(copyBoard(board))
      #Get moves from all players
      moves = Array.new(players.length)
      players.each do |player|
        if player[:health]>0
          moves[player[:id]] = player[:bot].try(:move, copyBoard(board), copyMoves(lastMoves), player[:r], player[:c])
          log( "Submitted by Player " + player[:id].to_s + " (" + player[:name] + "): " + moves[player[:id]].to_s)
        end
      end
      lastMoves = Array.new(players.length)
      #Execute all valid "shoot" moves
      moves.each_with_index do |move, index|
        if move and  move.is_a? String
          args = move.split(" ")
          if args.length>=3 and args[0]=="s"
            player = players[index]
            r = args[1].to_i
            c = args[2].to_i
            if (player[:r]-r).abs + (player[:c]-c).abs <=3 and player[:health]>0 and board[r][c]
              drainTimer=0
              lastMoves[index] = move
              target = board[r][c]
              target[:health] = target[:health]-1;
              players[target[:id]][:health] = target[:health]
              if target[:health]<=0
                board[r][c] = nil
                nPlayers -= 1
              end
              log "Player " + player[:id].to_s + " (" + player[:name] + ") shoots Player " + target[:id].to_s + " (" + players[target[:id]][:name] + ") down to " + target[:health].to_s
            end
          end
        end
      end
      #Execute all valid "move" moves
      moves.each_with_index do |move, index|
        if move and  move.is_a? String
          args = move.split(" ")
          if args.length>=2 and args[0]=="m"
            player = players[index]
            r=player[:r]
            c=player[:c]
            valid = true
            case args[1]
            when "u"
              r -= 1
            when "d"
              r += 1
            when "l"
              c -= 1
            when "r"
              c += 1
            else
              valid = false
            end
            if valid and player[:health]>0 and r.between?(0,9) and c.between?(0,9) and board[r][c]==nil
              log "Player " + player[:id].to_s + " (" + player[:name] + ") moves to " + r.to_s + ", " + c.to_s
              lastMoves[index] = move
              board[r][c] = board[player[:r]][player[:c]]
              board[player[:r]][player[:c]] = nil
              player[:r] = r
              player[:c] = c
            end
          end
        end
      end

      drainTimer +=1
      #drain everyone if 10 rounds have passed since damage was dealt
      if drainTimer>=20
        players.each do |player|
          if player[:health] > 0
            player[:health] = player[:health] - 1
            log "Player " + player[:id].to_s + " (" + player[:name] + ") drained to " + player[:health].to_s
            board[player[:r]][player[:c]][:health] = board[player[:r]][player[:c]][:health] - 1
            if player[:health] <= 0
              nPlayers-=1
              board[player[:r]][player[:c]] = nil
            end
          end
        end
        drainTimer=0
      end

    end
    players.each do |player|
      if player[:health]>0
        log "Player " + player[:id].to_s + " (" + player[:name] + ") wins!"
        @winner = player[:id].to_s + " (" + player[:name] + ")"
        return bots[player[:id]]
      end
    end
    log "All players eliminated. Game ends in a draw."
    @winner = "None"
    return nil
  end

  def copyBoard(board)
    dupBoard = Array.new(10) {|i| Array.new(10)}
    for r in 0..9
      for c in 0..9
        dupBoard[r][c] = board[r][c].try(:dup)
      end
    end
    return dupBoard
  end

  def copyMoves(moves)
    moves.map do |move| move.try(:dup) end
  end
end
