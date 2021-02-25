   //Implement can Take!

   // Piece Ideas, teleport piece, revive piece
    enum Team{
        WHITE,
        BLACK,
        GREY
    }
    enum Type{
        BISHOP,
        KING,
        KNIGHT,
        PAWN,
        QUEEN,
        ROOK,
        UNKOWN
    }
class ChessPiece{
    

    
    ChessPiece(Board b){
        board = b;
        side = Team.WHITE;
        taken = false;
        row = 0;
        collumn = 0;
        type = pawn;
        board.grid[row][collumn].occupied = true;
        board.grid[row][collumn].addPiece(this);
        piece = Type.UNKOWN;
    }

    ChessPiece(Board b, Team c, Boolean istaken, int x, int y, PShape t){
        board = b;
        side = c;
        taken = istaken;
        row = x;
        collumn = y;
        type = t;
        board.grid[row][collumn].occupied = true;
        board.grid[x][y].addPiece(this);
        piece = Type.UNKOWN;
    }


    public String toString(){
        return side + " " + name;
    }
    
    String GetChessPos(){
        if(!taken){
            char[] pos = new char[2];
            pos[0] = (char) (collumn+'A');
            pos[1] = (char) ((row)+'1');
            return new String(pos);

        }
        else return "Taken";
    }


    boolean CanMove(int x, int y){
        if(taken || board.grid[x][y].occupied || pinned(x,y,pieces)){
            return false;
        }
        else{
            return true;
        }
    }

    void Move(int x, int y){
        if(CanMove(x,y)){
            board.grid[row][collumn].occupied = false;
            board.grid[row][collumn].removePiece();
            board.grid[x][y].occupied = true;
            board.grid[x][y].addPiece(this);
            row = x;
            collumn = y;
            System.out.println(name + " to " + this.GetChessPos());
        }
        else{
            System.out.println("Cannot move");
        }
    }



    boolean CanTake(ChessPiece other){
        if(taken || other.taken || (other.side != side) || pinned(other.row,other.collumn,pieces)){
            return false;
        }
        else{
            return true;
        }
    }

// Looks at taking regardless of pin, in other words can you move if you would win the game.
    boolean CanEnd(ChessPiece other){
      System.out.println("got to can end");
        if(taken || other.taken || (other.side != side) ){
            return false;
        }
        else{
            return true;
        }
    }

    void Take(ChessPiece other){
        if(CanTake(other)){
            other.taken = true;
            board.grid[row][collumn].removePiece();
            row = other.row;
            collumn = other.collumn;
            board.grid[row][collumn].addPiece(this);
            System.out.println(name + " takes " + other.name);
        }
        else{
            System.out.println("Cannot Take " + other.name);
        }

    }

    // Helps simulate a take in a situation where taking could be impossible
    void ForcedTake(ChessPiece other){
        //System.out.println("Too many forced Takes?");
        //other.taken = true;
        board.grid[row][collumn].occupied = false;
        other.taken = true;
        row = other.row;
        collumn = other.collumn;
        board.grid[row][collumn].addPiece(this);
        //System.out.println(name + " takes " + other.name);
    }

    void ForcedMove(int x, int y){
        board.grid[row][collumn].occupied = false;
        board.grid[row][collumn].removePiece();
        board.grid[x][y].occupied = true;
        board.grid[x][y].addPiece(this);
        row = x;
        collumn = y;
    }


    boolean IsChecked(ArrayList<ChessPiece> pieces){
        for(int i = 0; i < pieces.size(); i++){
            //System.out.println("got to can end");
            //System.out.println(this);
            if(!pieces.get(i).taken){
                if(pieces.get(i).CanEnd(this)){
                    return true;
                }
            }
        }
        return false;
    }


    boolean pinned(int x, int y, ArrayList<ChessPiece> pieces){
        int holdx = row;
        int holdy = collumn;
        boolean forcedTake = false;
        if(!board.grid[x][y].noPieces()){
            System.out.println("Forced Take happened: Taking " + board.grid[x][y].getLivePiece());
            this.ForcedTake(board.grid[x][y].getLivePiece());
            forcedTake = true;
        }
        else{
            this.ForcedMove(x,y);
        }
        row = x;
        collumn = y;
        // TODO: make a psuedo take method that simulates if the piece at x,y was gone
        for(int i = 0; i < pieces.size(); i++){
            if(pieces.get(i).piece == Type.KING && pieces.get(i).side == this.side){
                if(pieces.get(i).IsChecked(pieces)){
                    System.out.println("Still is Checked");
                    // row = holdx;
                    // collumn = holdy;
                    if(forcedTake){
                        row = holdx;
                        collumn = holdy;
                        board.grid[x][y].removePiece();
                        board.grid[x][y].getPiece().taken =false;
                    }
                    else{
                        this.ForcedMove(holdx,holdy);
                        board.grid[x][y].occupied = false;
                    }
                    return true;
                }
            }
        }
        // row = holdx;
        // collumn = holdy;
        if(forcedTake){

            System.out.println("Should be reverting take");
            row = holdx;
            collumn = holdy;
            board.grid[x][y].removePiece();
            board.grid[x][y].getPiece().taken =false;
        }
        else{
            this.ForcedMove(holdx,holdy);
            board.grid[x][y].occupied = false;
        }
        return false;
    }


    Board board;
    Team side;
    boolean taken;
    int row;
    int collumn;
    PShape type;
    Type piece;
    String name = "Generic Piece";




}


class Pawn extends ChessPiece{

    Pawn(Board b){
        super(b);
        piece = Type.PAWN;
        name = "pawn";
        hasMoved = false;
        }

    Pawn(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.PAWN;
        name = "pawn";
        hasMoved = false;
        }


// Pinned king rule!!!!
    boolean CanMove(int x,int y){
        if(!pinned(x,y,pieces) && !board.grid[x][y].occupied){
            // Pawns can move two spaces up if they havent moved yet
            if(!hasMoved){
                if(this.side == Team.WHITE){
                    if(row+2 == x && collumn == y) return true;
                }
                else if(this.side == Team.BLACK){
                    if(row-2 == x && collumn == y) return true;
                }
            }
            // Normal Movement
            if(this.side == Team.WHITE){
                if(row+1 == x && collumn == y) return true;
            }
            else if(this.side == Team.BLACK){
                if(row-1 == x && collumn == y) return true;
            }
            return false;
        }
        return false;
    }


    // Whith the addition of canTake this is unnecisary? It depends if can take is called from pawn or general

    void Move(int x, int y){
        if(CanMove(x,y)){
            board.grid[row][collumn].occupied = false;
            board.grid[row][collumn].removePiece();
            board.grid[x][y].occupied = true;
            board.grid[x][y].addPiece(this);
            row = x;
            collumn = y;
            hasMoved = true;
            System.out.println(name + " to " + this.GetChessPos());
        }
        else{
            System.out.println("Cannot move");
        }
    }



// TODO: En Passant
    boolean CanTake(ChessPiece other){
        if(!taken && !other.taken && other.side != side){
            int calc = collumn - other.collumn;
            if(side == Team.WHITE){
                if((row == other.row-1) && ((abs(calc) == 1) && !pinned(other.row,other.collumn,pieces))){
                    return true;
                }
                else return false;
            }
            else{
                if((row == other.row+1) && ((abs(calc) == 1) && !pinned(other.row,other.collumn,pieces))){
                    return true;
                    }
                else return false;
            }
        }
        else{
           return false;
        }        
    }



    boolean CanEnd(ChessPiece other){
        //System.out.println("got to can end");
        if(!taken && !other.taken && other.side != side){
            int calc = collumn - other.collumn;
            if(side == Team.WHITE){
                if((row == other.row-1) && ((abs(calc) == 1))){
                    return true;
                }
                else return false;
            }
            else{
                if((row == other.row+1) && ((abs(calc) == 1))){
                    return true;
                    }
                else return false;
            }
        }
        else{
           return false;
        }        
    }

    // This should also be true with take

    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }



    boolean hasMoved;
}




class King extends ChessPiece{

    King(Board b){
        super(b);
        piece = Type.KING;
        name = "King";
        hasMoved = false;
        }

    King(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.KING;
        name = "King";
        hasMoved = false;
        }


//
    boolean CanMove(int x,int y){
        int diffx = row-x;
        int diffy = collumn-y;
        System.out.println(x + " " + y + " " + diffx + " " + diffy);
        if(diffx < 2 && diffx > -2 && diffy < 2 && diffy > -2 && !taken && !board.grid[x][y].occupied){
            if(!pinned(x,y,pieces)){
                // TODO: FIX THIS
                return true;
            }
            System.out.print("King Pinned Problem");
        }
        return false;    
    }


    void Move(int x, int y){
        if(CanMove(x,y)){
            board.grid[row][collumn].occupied = false;
            board.grid[row][collumn].removePiece();
            board.grid[x][y].occupied = true;
            board.grid[x][y].addPiece(this);
            row = x;
            collumn = y;
            hasMoved = true;
            System.out.println(name + " to " + this.GetChessPos());
        }
        else{
            System.out.println("Cannot move");
        }
    }



// TODO: En Passant
    boolean CanTake(ChessPiece other){
        int diffx = row-other.row;
        int diffy = collumn-other.collumn;
        if(diffx < 2 && diffx > -2 && diffy < 2 && diffy > -2 && !taken && other.side != this.side){
            if(!pinned(other.row, other.collumn, pieces)){
                return true;
            }
        }
        return false;       
    }

    boolean CanEnd(ChessPiece other){
        int diffx = row-other.row;
        int diffy = collumn-other.collumn;
        if(diffx < 2 && diffx > -2 && diffy < 2 && diffy > -2 && !taken && other.side != this.side){
            return true;
        }
        return false;       
    }


    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }


    // For castling
    boolean hasMoved;
}




class Bishop extends ChessPiece{

    Bishop(Board b){
        super(b);
        piece = Type.PAWN;
        name = "pawn";
        hasMoved = false;
        }

    Bishop(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.BISHOP;
        name = "Bishop";
        hasMoved = false;
        }


// Pinned king rule!!!!
    boolean CanMove(int x,int y){
        if(!pinned(x,y,pieces) && board.grid[x][y].occupied == false){
            int tempx = x;
            int tempy = y;
            int calcx = row -x;
            int calcy = collumn -y;
            // if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
            //     while(abs(calcx) > 2 && abs(calcy) > 2){
            //         if(tempx > row){
            //             tempx--;
            //         }
            //         else{
            //             tempx++;
            //         }
            //         if(tempy > collumn){
            //             tempy--;
            //         }
            //         else{
            //             tempy++;
            //         }
            //         if(board.grid[tempx][tempy].occupied == true){
            //             return false;
            //         }
            //     }
            //     return true;
            // }

            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                return true;
            }


            else return false;
        }
        else return false;
    }


    // Whith the addition of canTake this is unnecisary? It depends if can take is called from pawn or general

    // void Move(int x, int y){
    //     if(CanMove(x,y)){
    //         board.grid[row][collumn].occupied = false;
    //         board.grid[x][y].occupied = true;
    //         row = x;
    //         collumn = y;
    //         System.out.println(name + " to " + this.GetChessPos());
    //     }
    // }



    boolean CanTake(ChessPiece other){
        if(!pinned(other.row,other.collumn,pieces) && other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row -tempx;
            int calcy = collumn -tempy;
            // if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
            //     while(abs(calcx) > 2 && abs(calcy) > 2){
            //         if(tempx > row){
            //             tempx--;
            //         }
            //         else{
            //             tempx++;
            //         }
            //         if(tempy > collumn){
            //             tempy--;
            //         }
            //         else{
            //             tempy++;
            //         }
            //         if(board.grid[tempx][tempy].occupied == true){
            //             return false;
            //         }
            //     }
            //     return true;
            // }
            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                return true;
            }            




            else return false;
        }
        else return false;
    }

    boolean CanEnd(ChessPiece other){
        if(other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row -tempx;
            int calcy = collumn -tempy;
            // if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
            //     while(abs(calcx) > 2 && abs(calcy) > 2){
            //         if(tempx > row){
            //             tempx--;
            //         }
            //         else{
            //             tempx++;
            //         }
            //         if(tempy > collumn){
            //             tempy--;
            //         }
            //         else{
            //             tempy++;
            //         }
            //         if(board.grid[tempx][tempy].occupied == true){
            //             return false;
            //         }
            //     }
            //     System.out.println("bishop can end failing");
            //     System.out.println(side + " " + row + " " + collumn);
            //     return true;
            // }

            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                return true;
            }


            else return false;
        }
        else return false;
    }

    // This should also be true with take

    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }



    boolean hasMoved;
}


class Queen extends ChessPiece{

    Queen(Board b){
        super(b);
        piece = Type.QUEEN;
        name = "Wueen";
        hasMoved = false;
        }

    Queen(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.QUEEN;
        name = "Queen";
        hasMoved = false;
        }


    boolean CanMove(int x,int y){
        if(!pinned(x,y,pieces) && board.grid[x][y].occupied == false){
            int tempx = x;
            int tempy = y;
            int calcx = row -x;
            int calcy = collumn -y;

            // Check for Diagonal
            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                return true;
            }

            // Check for Vertical
            else if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                return true;                
            }
            else return false;
        }
        else return false;
    }


    // Whith the addition of canTake this is unnecisary? It depends if can take is called from pawn or general

    // void Move(int x, int y){
    //     if(CanMove(x,y)){
    //         board.grid[row][collumn].occupied = false;
    //         board.grid[x][y].occupied = true;
    //         row = x;
    //         collumn = y;
    //         System.out.println(name + " to " + this.GetChessPos());
    //     }
    // }



    boolean CanTake(ChessPiece other){
        if(!pinned(other.row,other.collumn,pieces) && other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row - tempx;
            int calcy = collumn - tempy;

            // Check for Diagonal
            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                return true;
            }

            // Check for Vertical
            else if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                return true;                
            }
            else return false;
        }
        else return false;
    }










    boolean CanEnd(ChessPiece other){
        if(other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row - tempx;
            int calcy = collumn - tempy;

            // Check for Diagonal
            if(abs(calcx) > 0 && abs(calcx) == abs(calcy)){
                while(abs(calcx) > 1 && abs(calcy) > 1){
                    if(tempx > row){
                        tempx--;
                    }
                    else{
                        tempx++;
                    }
                    if(tempy > collumn){
                        tempy--;
                    }
                    else{
                        tempy++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row -tempx;
                    calcy = collumn -tempy;
                }
                //System.out.println("queen can end failing");
                return true;
            }

            // Check for Vertical
            else if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                //System.out.println("queen can end failing");
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                //System.out.println("queen can end failing");
                return true;                
            }
            else return false;
        }
        else return false;
    }



    // This should also be true with take

    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }



    boolean hasMoved;
}



class Rook extends ChessPiece{

    Rook(Board b){
        super(b);
        piece = Type.ROOK;
        name = "Rook";
        hasMoved = false;
        }

    Rook(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.ROOK;
        name = "Rook";
        hasMoved = false;
        }


    boolean CanMove(int x,int y){
        if(!pinned(x,y,pieces) && board.grid[x][y].occupied == false){
            int tempx = x;
            int tempy = y;
            int calcx = row -x;
            int calcy = collumn -y;


            // Check for Vertical
            if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                return true;                
            }
            else return false;
        }
        else return false;
    }


    // Whith the addition of canTake this is unnecisary? It depends if can take is called from pawn or general

    // void Move(int x, int y){
    //     if(CanMove(x,y)){
    //         board.grid[row][collumn].occupied = false;
    //         board.grid[x][y].occupied = true;
    //         row = x;
    //         collumn = y;
    //         System.out.println(name + " to " + this.GetChessPos());
    //     }
    // }



    boolean CanTake(ChessPiece other){
        if(!pinned(other.row,other.collumn,pieces) && other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row - tempx;
            int calcy = collumn - tempy;

            // Check for Vertical
            if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                return true;                
            }
            else return false;
        }
        else return false;
    }








    boolean CanEnd(ChessPiece other){
        if(other.side != side){
            int tempx = other.row;
            int tempy = other.collumn;
            int calcx = row - tempx;
            int calcy = collumn - tempy;

            // Check for Vertical
            if(row == tempx){
                while(abs(calcy) > 1){
                    if(tempy > collumn){
                        tempy --;
                    }
                    else{
                        tempy ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcy = collumn - tempy;
                }
                System.out.println("rook can end failing");
                return true;
            }

            // Check for Horizontal
            else if(collumn == tempy){
                while(abs(calcx) > 1){
                    if(tempx > row){
                        tempx --;
                    }
                    else{
                        tempx ++;
                    }
                    if(board.grid[tempx][tempy].occupied == true){
                        return false;
                    }
                    calcx = row - tempx;
                }
                System.out.println("rook can end failing");
                return true;                
            }
            else return false;
        }
        else return false;
    }





    // This should also be true with take

    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }



    boolean hasMoved;
}

class Knight extends ChessPiece{

    Knight(Board b){
        super(b);
        piece = Type.KNIGHT;
        name = "Knight";
        hasMoved = false;
        }

    Knight(Board b, Team c, Boolean istaken, Boolean hasMoved, int x, int y, PShape t){
        super(b,c,istaken,x,y,t);
        piece = Type.KNIGHT;
        name = "Knight";
        hasMoved = false;
        }


    boolean CanMove(int x,int y){
        if(!pinned(x,y,pieces) && board.grid[x][y].occupied == false){
            int xdiff = row -x;
            int ydiff = collumn -y;
            System.out.println("Xdiff: " +xdiff + "Ydiff: " + ydiff);
            if( (abs(xdiff) == 2 && abs(ydiff) == 1) || (abs(xdiff) == 1 && abs(ydiff) == 2) ){
                return true;
            }
        }
        return false;
    }


    // Whith the addition of canTake this is unnecisary? It depends if can take is called from pawn or general

    // void Move(int x, int y){
    //     if(CanMove(x,y)){
    //         board.grid[row][collumn].occupied = false;
    //         board.grid[x][y].occupied = true;
    //         row = x;
    //         collumn = y;
    //         System.out.println(name + " to " + this.GetChessPos());
    //     }
    // }



    boolean CanTake(ChessPiece other){
        if(!pinned(other.row,other.collumn,pieces) && other.side != side){
            int xdiff = row -other.row;
            int ydiff = collumn -other.collumn;
            if( (abs(xdiff) == 2 && abs(ydiff) == 1) || (abs(xdiff) == 1 && abs(ydiff) == 2) ){
                return true;
             }
        }
        return false;
    }



    boolean CanEnd(ChessPiece other){
        if(other.side != side){
            int xdiff = row -other.row;
            int ydiff = collumn -other.collumn;
            if( (abs(xdiff) == 2 && abs(ydiff) == 1) || (abs(xdiff) == 1 && abs(ydiff) == 2) ){
                System.out.println("knight can end failing");
                return true;
             }
        }
        return false;
    }


    // This should also be true with take

    // void Take(ChessPiece other){
    //     if(CanTake(other)){
    //         board.grid[row][collumn].occupied = false;
    //         row = other.row;
    //         collumn = other.collumn;
    //         System.out.println(name + " takes " + other.name);
    //     }
    //     else System.out.println("Cannot Take " + other.name);

    // }



    boolean hasMoved;
}