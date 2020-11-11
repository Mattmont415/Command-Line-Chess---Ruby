#Let's build CHESS!

class Chess

  attr_accessor :WP, :BP, :STRING

  #Getting unicode symbols for the pieces of the chess set
  def initialize
    @WP = "♙" 
    @WB = "♗"
    @WK = "♘"
    @WR = "♖"
    @WQ = "♕"
    @WKg = "♔"

    @BP = "♟︎"
    @BB = "♝"
    @BK = "♞"
    @BR = "♜"
    @BQ = "♛"
    @BKg = "♚"
  
    #Initializes an empty board
    @b = [[" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "],
          [" "," "," "," "," "," "," "," "]]
  end

  def draw_board_start
    #Places the pawns
    8.times do |x|
      @b[x][1] = @WP
      @b[x][6] = @BP
    end
    #white, on bottom, the opaque pieces
    @b[0][0] = @WR #WR = white rook...
    @b[7][0] = @WR
    @b[1][0] = @WK #knight etc
    @b[6][0] = @WK
    @b[2][0] = @WB
    @b[5][0] = @WB
    @b[3][0] = @WQ
    @b[4][0] = @WKg
    #black, on top, the filled in pieces
    @b[0][7] = @BR
    @b[7][7] = @BR
    @b[1][7] = @BK
    @b[6][7] = @BK
    @b[2][7] = @BB
    @b[5][7] = @BB
    @b[3][7] = @BQ
    @b[4][7] = @BKg

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
  end

  def convert_coord(strcoord)
    strcoord[0] = "0" if strcoord[0] == "A"
    strcoord[0] = "1" if strcoord[0] == "B"
    strcoord[0] = "2" if strcoord[0] == "C"
    strcoord[0] = "3" if strcoord[0] == "D"
    strcoord[0] = "4" if strcoord[0] == "E"
    strcoord[0] = "5" if strcoord[0] == "F"
    strcoord[0] = "6" if strcoord[0] == "G"
    strcoord[0] = "7" if strcoord[0] == "H"
    #Returns integer coordinates from the @# (letter,number)
    [strcoord[0].to_i,strcoord[1].to_i - 1]
  end


  def white_owned(x,y)
    puts x.to_s + " " + y.to_s
    if @b[x][y] == @WP || @b[x][y] == @WB || @b[x][y] == @WK || @b[x][y] == @WR || @b[x][y] == @WQ || @b[x][y] == @WKg
      puts "White owns this!"
      return true
    else
      return false
    end
  end


  def black_owned(x,y)
    puts x.to_s + " " + y.to_s
    if @b[x][y] == @BP || @b[x][y] == @BB || @b[x][y] == @BK || @b[x][y] == @BR || @b[x][y] == @BQ || @b[x][y] == @BKg
      puts "Black owns this!"
      return true
    else
      return false
    end
  end


  def valid_white_pawn(x,y)
    if y == 1 
      if @b[x][y+1] == " "
        puts "Valid pawn"
        return true
      end
      #if @b[x+1][y+1] == black_owned()
    elsif y > 1
      if @b[x][y+1] == " "
        return true
      end
    end
    return false
  end


  def white_turn
    strcoord = ""
    #destination coordinate
    descoord = ""
    #Boolean for coordinate format
    corfor = false
    x = 0
    y = 0

    #Valid for correct coordinate
    while !corfor
      puts "Choose a valid starting coordinate (one of your pieces)"
      strcoord = gets.chomp
      strcoord.upcase!
      x = val_coord(strcoord)[0]
      y = val_coord(strcoord)[1]
      while !white_owned(x,y)
        puts "Incorrect coordinate, please try again."
        puts "Choose a space with your piece by entering a 'Letter' 'Number'. No quotes and no spaces!"
        corfor = false
        strcoord = gets.chomp
        strcoord.upcase!
        if strcoord[0] >= "A" && strcoord[0] <= "H" && strcoord[1] >= "1" && strcoord[1] <= "8" && strcoord.length == 2
          corfor = true
          x = convert_coord(strcoord)[0]
          y = convert_coord(strcoord)[1]
        end
      end
    end
    #If white pawn is chosen...
    if @b[x][y] == @WP
      #Check valid pawn. If invalid, "No possible moves!" send back up
      valid_white_pawn(x,y)
      puts "Where is the target destination?"
      descoord = gets.chomp
      
      
    end
  end

  def val_coord(strcoord)
    puts "Choose a valid starting piece"
    valid = false
    x = 0
    y = 0
    while !valid
      if strcoord.length == 2
        if strcoord[0] >= "A" && strcoord[0] <= "H" && strcoord[1] >= "1" && strcoord[1] <= "8" && strcoord.length == 2
          return true
        else
          puts "Incorrect formatting. Please try again"
          strcoord = gets.chomp
        end
      else
        puts "Incorrect formatting. Just choose one letter followed immediately by a number"
        strcoord = gets.chomp
      end
    end
    return false
  end



end






chess = Chess.new

chess.draw_board_start

puts "\nWhite goes first! Let's play :)"

chess.white_turn
chess.white_turn