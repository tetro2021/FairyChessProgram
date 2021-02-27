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
          currentPiece.Take(board.grid[selectRow][selectCollumn].getLivePiece());
        }
        else currentPiece.Move(selectRow,selectCollumn);
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
        System.out.println(aiMoveG);
        aiMoveG.p.Move(aiMoveG.row,aiMoveG.collumn);
        if(playerTurn == 1){
            aiMoveG.p.Take(board.grid[aiMoveG.row][aiMoveG.collumn].getLivePiece());
        }
        eloOf1.clearMoves();
    }
}
