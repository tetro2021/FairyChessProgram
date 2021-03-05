






class Player{
  
  Player(Team s){
    side = s;
    canPassant = false;
  }

  void setPreviousMove(Moves p){
    previous = p;
  }
  Moves getPreviousMove(){
    if(previous != null){
      return previous;
    }
    else{
      System.out.print("No Previous MOVE! ERROR");
      return previous;
    }
  }

Team side;
Moves previous = null;
boolean canPassant;
}






void checkPromotion(){
  Moves prev;
  if(playerTurn == 0){
    prev = playerList.get(playerList.size()-1).previous;
  }
  else prev = playerList.get(playerTurn-1).previous; 
  if(prev != null && prev.p.piece == Type.PAWN && (prev.row == board.gridSizeX-1 || prev.row == 0)){
    triggerPromotion(prev.p);
  } 
}


void triggerPromotion(ChessPiece oldPiece){
  
  return;
}








void gameCommands(){
  
}

void TwoPlayerClick(){
    if(firstSelect){
    selectCell();
    if(board.grid[selectRow][selectCollumn].getLivePiece() != null){
      currentPiece = board.grid[selectRow][selectCollumn].getLivePiece();
    }
    else {
      System.out.println("EMPTY CELL");
        return;
      }
    firstSelect = false;
  }
  else{
    if(currentPiece != null){
        selectCell();
        if(board.grid[selectRow][selectCollumn].getLivePiece() != null){
          if(currentPiece.CanTake(board.grid[selectRow][selectCollumn].getLivePiece())){
            Moves playerMove = new Moves(currentPiece,selectRow,selectCollumn);
            playerList.get(playerTurn).setPreviousMove(playerMove);
          }
          currentPiece.Take(board.grid[selectRow][selectCollumn].getLivePiece());
        }
        else if(currentPiece.CanMove(selectRow,selectCollumn)){
            Moves playerMove = new Moves(currentPiece,selectRow,selectCollumn);
            playerList.get(playerTurn).setPreviousMove(playerMove);
        } 
        currentPiece.Move(selectRow,selectCollumn);
      }
     firstSelect = true;
  }
}

void vsAI(){
    if(playerTurn == 0){
        TwoPlayerClick();
    }
    else{
        Moves aiMove = eloOf1.randomMove();
        playerList.get(playerTurn).setPreviousMove(aiMove);
        System.out.println(aiMove);
        aiMove.p.Move(aiMove.row,aiMove.collumn);
        if(playerTurn == 1){
            aiMove.p.Take(board.grid[aiMove.row][aiMove.collumn].getLivePiece());
        }
        eloOf1.clearMoves();
    }
}


void vsGreedy(){
    if(playerTurn == 0){
        TwoPlayerClick();
    }
    else{
        Moves aiMoveG = eloOf20.GreedyMove();
        playerList.get(playerTurn).setPreviousMove(aiMoveG);
        System.out.println(aiMoveG);
        aiMoveG.p.Move(aiMoveG.row,aiMoveG.collumn);
        if(playerTurn == 1){
            aiMoveG.p.Take(board.grid[aiMoveG.row][aiMoveG.collumn].getLivePiece());
        }
        eloOf20.clearMoves();
    }
}
