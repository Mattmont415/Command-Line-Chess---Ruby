

class Chess


  def initialize
    #White pieces as instance constants
    @WP = "♙"; @WB = "♗"; @WK = "♘"; @WR = "♖"; @WQ = "♕"; @WKg = "♔"
    #Black pieces as instance constants
    @BP = "♟︎"; @BB = "♝"; @BK = "♞"; @BR = "♜"; @BQ = "♛"; @BKg = "♚"

    #Arrays keeping track of captured pieces
    @white_piece = []
    @black_piece = []

    #For castling
    @wht_king_move = false
    @wht_rook_left_move = false
    @wht_rook_right_move = false
    @blk_king_move = false
    @blk_rook_left_move = false
    @blk_rook_right_move = false
  
    #Initializes an empty board
    @b = []
    8.times do
      @b.push([" "," "," "," "," "," "," "," "])
    end
  end


  def draw_board_start
    #Places the pawns
    8.times do |x|
      @b[x][1] = @WP
      @b[x][6] = @BP
    end
    #white, on bottom, the opaque pieces
    @b[0][0] = @WR; @b[7][0] = @WR
    @b[1][0] = @WK; @b[6][0] = @WK
    @b[2][0] = @WB; @b[5][0] = @WB
    @b[3][0] = @WQ
    @b[4][0] = @WKg
    #black, on top, the filled in pieces
    @b[0][7] = @BR; @b[7][7] = @BR
    @b[1][7] = @BK; @b[6][7] = @BK
    @b[2][7] = @BB; @b[5][7] = @BB
    @b[3][7] = @BQ
    @b[4][7] = @BKg
  
    #TESTING PIECES HERE


    draw_board
  end

  def draw_board
    #Displays the board with helpful coordinates
    puts "   |  A  |  B  |  C  |  D  |  E  |  F  |  G  |  H  |"
    puts "   |_____|_____|_____|_____|_____|_____|_____|_____|"
    7.downto(0) do |y|
      puts "   |     |     |     |     |     |     |     |     |"
      puts " #{y+1} |  #{@b[0][y]}  |  #{@b[1][y]}  |  #{@b[2][y]}  |  #{@b[3][y]}  |  #{@b[4][y]}  |  #{@b[5][y]}  |  #{@b[6][y]}  |  #{@b[7][y]}  | #{y+1}"
      puts "   |_____|_____|_____|_____|_____|_____|_____|_____|"
    end
    puts "   |  A  |  B  |  C  |  D  |  E  |  F  |  G  |  H  |"
    print "White pieces captured: "
    print @white_piece.join
    puts
    print "Black pieces captured: "
    print @black_piece.join
    puts
  end

  #Converts the LET/NUM to valid indicies [x,y] for the board matrix [0-6][0-6]
  def convert_coord(strcoord)
    strcoord[0] = "0" if strcoord[0] == "A"
    strcoord[0] = "1" if strcoord[0] == "B"
    strcoord[0] = "2" if strcoord[0] == "C"
    strcoord[0] = "3" if strcoord[0] == "D"
    strcoord[0] = "4" if strcoord[0] == "E"
    strcoord[0] = "5" if strcoord[0] == "F"
    strcoord[0] = "6" if strcoord[0] == "G"
    strcoord[0] = "7" if strcoord[0] == "H"
    #Returns integer coordinates from the input:@# (letter,number)
    [strcoord[0].to_i,strcoord[1].to_i - 1]
  end

  #Does white own this space?
  def white_owned(x,y)
    if @b[x][y] == @WP || @b[x][y] == @WB || @b[x][y] == @WK || @b[x][y] == @WR || @b[x][y] == @WQ || @b[x][y] == @WKg
      return true
    else
      return false
    end
  end

  #How about black own this space?
  def black_owned(x,y)
    if @b[x][y] == @BP || @b[x][y] == @BB || @b[x][y] == @BK || @b[x][y] == @BR || @b[x][y] == @BQ || @b[x][y] == @BKg
      return true
    else
      return false
    end
  end


  #White's turn
  def white_turn
    #starting coord
    stacoord = ""
    #destination coord
    descoord = ""
    #boolean coordinate format
    cordform = false
    #coordinate array
    crarr = []
    #dest coordinate array
    dsarr = []
    x = y = 0

    #CHOOSE STARTING PIECE
    until cordform
      puts "Choose a valid white starting piece, format: 'Letter','Number' - no quotes or commas"
      stacoord = gets.chomp
      stacoord.upcase!
      if val_coord(stacoord)
        crarr = convert_coord(stacoord)
        x = crarr[0]; y = crarr[1]
        if !white_owned(x,y)
          puts "Please choose one of your pieces"
        else
          cordform = true
        end
      end
    end

    #If pawn is chosen
    if @b[x][y] == @WP
      puts "This is a white pawn!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"

      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_pawn(crarr,dsarr)
          draw_board
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    #If Bishop is chosen
    if @b[x][y] == @WB
      puts "This is a white bishop!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_bishop(crarr,dsarr)
          draw_board
          puts "Bishop moved!"
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    #If Rook is chosen
    if @b[x][y] == @WR
      puts "This is a white rook!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_rook(crarr,dsarr)
          draw_board
          puts "Rook moved!"
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    #If Knight is chosen
    if @b[x][y] == @WK
      puts "This is a white knight!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_knight(crarr,dsarr)
          draw_board
          puts "Knight moved!"
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    #If Queen is chosen
    if @b[x][y] == @WQ
      puts "This is a white queen!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_queen(crarr,dsarr)
          draw_board
          puts "Queen moved!"
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    #If King is chosen
    if @b[x][y] == @WKg
      puts "This is the white king!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        white_turn
        return
      end
      if !val_coord(descoord)
        white_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_white_king(crarr,dsarr)
          draw_board
          puts "King moved!"
        else
          puts "Move is invalid"
          white_turn
          return
        end
      end
    end

    puts "Left white rook moved? " + @wht_rook_left_move.to_s
    puts "Right white rook moved? " + @wht_rook_right_move.to_s
  end #white turn end













  #Black's turn
  def black_turn
    #starting coord
    stacoord = ""
    #destination coord
    descoord = ""
    #boolean coordinate format
    cordform = false
    #coordinate array
    crarr = []
    #dest coordinate array
    dsarr = []
    x = y = 0

    #CHOOSE STARTING PIECE
    until cordform
      puts "Choose a valid black starting piece, format: 'Letter','Number' - no quotes or commas"
      stacoord = gets.chomp
      stacoord.upcase!
      if val_coord(stacoord)
        crarr = convert_coord(stacoord)
        x = crarr[0]; y = crarr[1]
        if !black_owned(x,y)
          puts "Please choose one of your pieces"
        else
          cordform = true
        end
      end
    end

    #If pawn is chosen
    if @b[x][y] == @BP
      puts "This is a black pawn!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_pawn(crarr,dsarr)
          draw_board
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

    #If Bishop is chosen
    if @b[x][y] == @BB
      puts "This is a black bishop!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_bishop(crarr,dsarr)
          draw_board
          puts "Bishop moved!"
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

    #If Rook is chosen
    if @b[x][y] == @BR
      puts "This is a black rook!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_rook(crarr,dsarr)
          draw_board
          puts "Rook moved!"
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

    #If Knight is chosen
    if @b[x][y] == @BK
      puts "This is a black knight!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_knight(crarr,dsarr)
          draw_board
          puts "Knight moved!"
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

    #If Queen is chosen
    if @b[x][y] == @BQ
      puts "This is a black queen!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_queen(crarr,dsarr)
          draw_board
          puts "Queen moved!"
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

    #If King is chosen
    if @b[x][y] == @BKg
      puts "This is the black king!"
      puts "Enter the target destination, or type 'B' to go back to coordinate selection"
      descoord = gets.chomp
      descoord.upcase!
      if descoord == "B"
        black_turn
        return
      end
      if !val_coord(descoord)
        black_turn
        return
      else
        dsarr = convert_coord(descoord)
        if valid_black_king(crarr,dsarr)
          draw_board
          puts "King moved!"
        else
          puts "Move is invalid"
          black_turn
          return
        end
      end
    end

  end #black turn end


  def val_coord(strcoord)
    valid = false
    strcoord.upcase!
    while !valid
      if strcoord.length == 2
        if strcoord[0] >= "A" && strcoord[0] <= "H" && strcoord[1] >= "1" && strcoord[1] <= "8" && strcoord.length == 2
          return true
          break
        else
          puts "Incorrect formatting. Please try again"
          strcoord = gets.chomp
          strcoord.upcase!
        end
      else
        puts "Incorrect formatting. Just choose one letter followed immediately by a number"
        strcoord = gets.chomp
        strcoord.upcase!
      end
    end
    return false
  end

  ############################################
  ###
  ###       VALID WHITE PIECE MOVES
  ###
  ############################################

  def valid_white_pawn(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    pawncross = ""

    return false if white_owned(x1,y1)

    if x1 == x && y1 == y+1 && @b[x1][y1] == " "
      @b[x][y] = " "
      @b[x1][y1] = @WP
      if y1 == 7
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @WK
        elsif pawncross == "Q"
          @b[x1][y1] = @WQ
        end
      end
      return true
    elsif x1 == x && y1 == y+2 && y == 1 && @b[x1][y1] == " " && @b[x][y+1] == " "
      @b[x][y] = " "
      @b[x1][y1] = @WP
      return true
    elsif x1 == x+1 && y1 == y+1 && black_owned(x1,y1)
      @black_piece.push(@b[x1][y1])
      @b[x1][y1] = @WP
      @b[x][y] = " "
      if y1 == 7
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @WK
        elsif pawncross == "Q"
          @b[x1][y1] = @WQ
        end
      end
      return true
    elsif x1 == x-1 && y1 == y+1 && black_owned(x1,y1)
      @black_piece.push(@b[x1][y1])
      @b[x1][y1] = @WP
      @b[x][y] = " "
      if y1 == 7
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @WK
        elsif pawncross == "Q"
          @b[x1][y1] = @WQ
        end
      end
      return true
    end
    return false
  end


  def valid_white_bishop(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    #Return false if the dest is white owned
    return false if white_owned(x1,y1)
    #Return false if the dest isn't in line with bishop movement
    return false if (x1-x).abs() != (y1-y).abs()

    #Variables for checking clearspaces
    xtrans = x; ytrans = y

    #Do four cases first of one on each side? 1,1
    if x1 == x+1 && y1 == y+1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 == x-1 && y1 == y+1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 == x-1 && y1 == y-1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 == x+1 && y1 == y-1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    end

    #four cases. First x1>x,y1>y
    if x1 > x+1 && y1 > y+1 
      while xtrans < x1-1 do
        xtrans += 1
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 < x-1 && y1 > y+1 
      while xtrans > x1+1 do
        xtrans -= 1
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 < x-1 && y1 < y-1 
      while xtrans > x1+1 do
        xtrans -= 1
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    elsif x1 > x+1 && y1 < y-1 
      while xtrans < x1-1 do
        xtrans += 1
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WB
      return true
    end
    return false
  end


  #Checking validity of Rook spaces
  def valid_white_rook(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    xtrans = x
    ytrans = y

    return false if white_owned(x1,y1)

    #Getting the one space moves for the square around the rook
    if x1 == x+1 && y1 == y
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 == x-1 && y1 == y
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 == x && y1 == y+1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 == x && y1 == y-1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    end

    #The spaces that are +1 further away
    if x1 > x+1 && y1 == y
      while xtrans < x1-1 do
        xtrans += 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 < x-1 && y1 == y
      while xtrans > x1+1 do
        xtrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 == x && y1 > y+1
      while ytrans < y1-1 do
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    elsif x1 == x && y1 < y-1
      while ytrans > y1+1 do
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_rook_left_move = true if x == 0 && y == 0
      @wht_rook_right_move = true if x == 7 && y == 0
      @b[x1][y1] = @WR
      return true
    end
    return false
  end


  def valid_white_knight(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if !(@b[x][y] == @WK)
    return false if white_owned(x1,y1)

    #Eight possible moves for the horsey
    if x1 == x+2 && y1 == y+1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x+1 && y1 == y+2
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x-1 && y1 == y+2
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x-2 && y1 == y+1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x-1 && y1 == y-2
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x-2 && y1 == y-1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x+1 && y1 == y-2
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    elsif x1 == x+2 && y1 == y-1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @WK
      return true
    end
    return false
  end


  def valid_white_queen(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if white_owned(x1,y1)

    #But can we call valid bishop and valid rook?

    if valid_white_bishop([x,y],[x1,y1])
      @b[x1][y1] = @WQ
      return true
    end
    if valid_white_rook([x,y],[x1,y1])
      @b[x1][y1] = @WQ
      return true
    end

    return false

  end

  def valid_white_king(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if white_owned(x1,y1)

    #Castle LEFT!
    if x == 4 && y == 0 && x1 == 2 && y1 == 0 && @b[1][0] == " " && @b[2][0] == " " && @b[3][0] == " " && @wht_rook_left_move == false && @wht_king_move == false && @b[0][0] == @WR
      @b[2][0] = @WKg
      @b[3][0] = @WR
      @b[0][0] = " "
      @b[4][0] = " "
      @wht_rook_left_move = true
      @wht_rook_right_move = true
      @wht_king_move = true
      return true
    end

    #Castle RIGHT
    if x == 4 && y == 0 && x1 == 6 && y1 == 0 && @b[5][0] == " " && @b[6][0] == " " && @wht_rook_right_move == false && @wht_king_move == false && @b[7][0] == @WR
      @b[6][0] = @WKg
      @b[5][0] = @WR
      @b[7][0] = " "
      @b[4][0] = " "
      @wht_rook_left_move = true
      @wht_rook_right_move = true
      @wht_king_move = true
      return true
    end

    #Bishop/diagonal move one over
    if x1 == x+1 && y1 == y+1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x-1 && y1 == y+1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x-1 && y1 == y-1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x+1 && y1 == y-1 && !white_owned(x1,y1)
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    end

    #Rook move one over
    if x1 == x+1 && y1 == y
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x-1 && y1 == y
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x && y1 == y+1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    elsif x1 == x && y1 == y-1
      @black_piece.push(@b[x1][y1]) if black_owned(x1,y1)
      @b[x][y] = " "
      @wht_king_move = true
      @b[x1][y1] = @WKg
      return true
    end

  end


  ############################################
  ###
  ###       VALID BLACK PIECE MOVES
  ###
  ############################################


  def valid_black_pawn(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    pawncross = ""

    return false if black_owned(x1,y1)

    if x1 == x && y1 == y-1 && @b[x1][y1] == " "
      @b[x][y] = " "
      @b[x1][y1] = @BP
      if y1 == 0
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @BK
        elsif pawncross == "Q"
          @b[x1][y1] = @BQ
        end
      end
      return true
    elsif x1 == x && y1 == y-2 && y == 6 && @b[x1][y1] == " " && @b[x][y-1] == " "
      @b[x][y] = " "
      @b[x1][y1] = @BP
      return true
    elsif x1 == x-1 && y1 == y-1 && white_owned(x1,y1)
      @white_piece.push(@b[x1][y1])
      @b[x1][y1] = @WP
      @b[x][y] = " "
      if y1 == 0
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @BK
        elsif pawncross == "Q"
          @b[x1][y1] = @BQ
        end
      end
      return true
    elsif x1 == x+1 && y1 == y-1 && white_owned(x1,y1)
      @white_piece.push(@b[x1][y1])
      @b[x1][y1] = @BP
      @b[x][y] = " "
      if y1 == 0
        puts "You made it to the other side! Choose: Queen 'Q' or Knight 'K'"
        pawncross = gets.chomp
        pawncross.upcase!
        unless pawncross == "K" || pawncross == "Q"
          puts "Please choose 'Q' for queen, or 'K' for knight"
          pawncross = gets.chomp
          pawncross.upcase!
        end
        if pawncross == "K"
          @b[x1][y1] = @BK
        elsif pawncross == "Q"
          @b[x1][y1] = @BQ
        end
      end
      return true
    end
    return false
  end


  def valid_black_bishop(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    #Return false if the dest is white owned
    return false if black_owned(x1,y1)
    #Return false if the dest isn't in line with bishop movement
    return false if (x1-x).abs() != (y1-y).abs()

    #Variables for checking clearspaces
    xtrans = x; ytrans = y

    #Do four cases first of one on each side? 1,1
    if x1 == x+1 && y1 == y+1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 == x-1 && y1 == y+1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 == x-1 && y1 == y-1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 == x+1 && y1 == y-1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    end

    #four cases. First x1>x,y1>y
    if x1 > x+1 && y1 > y+1 
      while xtrans < x1-1 do
        xtrans += 1
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 < x-1 && y1 > y+1 
      while xtrans > x1+1 do
        xtrans -= 1
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 < x-1 && y1 < y-1 
      while xtrans > x1+1 do
        xtrans -= 1
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    elsif x1 > x+1 && y1 < y-1 
      while xtrans < x1-1 do
        xtrans += 1
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #Move is blockaded
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BB
      return true
    end
    return false
  end


  #Checking validity of Rook spaces
  def valid_black_rook(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    xtrans = x
    ytrans = y

    return false if black_owned(x1,y1)

    #Getting the one space moves for the square around the rook
    if x1 == x+1 && y1 == y
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 == x-1 && y1 == y
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 == x && y1 == y+1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 == x && y1 == y-1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    end

    #The spaces that are +1 further away
    if x1 > x+1 && y1 == y
      while xtrans < x1-1 do
        xtrans += 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 < x-1 && y1 == y
      while xtrans > x1+1 do
        xtrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 == x && y1 > y+1
      while ytrans < y1-1 do
        ytrans += 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    elsif x1 == x && y1 < y-1
      while ytrans > y1+1 do
        ytrans -= 1
        if @b[xtrans][ytrans] != " "
          return false #blockaded!
        end
      end
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_rook_left_move = true if x == 0 && y == 7
      @blk_rook_right_move = true if x == 7 && y == 7
      @b[x1][y1] = @BR
      return true
    end
    return false
  end


  def valid_black_knight(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if !(@b[x][y] == @BK)
    return false if black_owned(x1,y1)

    #Eight possible moves for the horsey
    if x1 == x+2 && y1 == y+1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x+1 && y1 == y+2
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x-1 && y1 == y+2
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x-2 && y1 == y+1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x-1 && y1 == y-2
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x-2 && y1 == y-1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x+1 && y1 == y-2
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    elsif x1 == x+2 && y1 == y-1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @b[x1][y1] = @BK
      return true
    end
    return false
  end


  def valid_black_queen(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if black_owned(x1,y1)

    if valid_black_bishop([x,y],[x1,y1])
      @b[x1][y1] = @BQ
      return true
    end
    if valid_black_rook([x,y],[x1,y1])
      @b[x1][y1] = @BQ
      return true
    end

    return false

  end

  def valid_black_king(start,dest)
    x = start[0]; y = start[1]
    x1 = dest[0]; y1 = dest[1]

    return false if white_owned(x1,y1)

    #Castle LEFT!
    if x == 4 && y == 7 && x1 == 2 && y1 == 7 && @b[1][7] == " " && @b[2][7] == " " && @b[3][7] == " " && @blk_rook_left_move == false && @blk_king_move == false && @b[0][7] == @BR
      @b[2][7] = @BKg
      @b[3][7] = @BR
      @b[0][7] = " "
      @b[4][7] = " "
      @blk_rook_left_move = true
      @blk_rook_right_move = true
      @blk_king_move = true
      return true
    end

    #Castle RIGHT
    if x == 4 && y == 7 && x1 == 6 && y1 == 7 && @b[5][7] == " " && @b[6][7] == " " && @blk_rook_right_move == false && @blk_king_move == false && @b[7][7] == @BR
      @b[6][7] = @BKg
      @b[5][7] = @BR
      @b[7][7] = " "
      @b[4][7] = " "
      @blk_rook_left_move = true
      @blk_rook_right_move = true
      @blk_king_move = true
      return true
    end

    #Bishop/diagonal move one over
    if x1 == x+1 && y1 == y+1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x-1 && y1 == y+1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x-1 && y1 == y-1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x+1 && y1 == y-1 && !black_owned(x1,y1)
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    end

    #horiz/vert move one over
    if x1 == x+1 && y1 == y
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x-1 && y1 == y
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x && y1 == y+1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    elsif x1 == x && y1 == y-1
      @white_piece.push(@b[x1][y1]) if white_owned(x1,y1)
      @b[x][y] = " "
      @blk_king_move = true
      @b[x1][y1] = @BKg
      return true
    end

  end


end

chess = Chess.new

chess.draw_board_start

loop do
puts "White's turn!"
chess.white_turn
puts "Black's turn!"
chess.black_turn
end
