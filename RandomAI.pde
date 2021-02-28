class RandomAI{
    
  
  RandomAI(Board board1, Team side1){
        board = board1;
        side = side1;
        legalPieces = new ArrayList();
        legalMoves = new ArrayList();
    }


    void generateLegaPieces(){
        for(int i = 0; i < board.gridSizeX; i++){
            for(int j = 0; j < board.gridSizeY; j++){
                if(board.grid[i][j].getLivePiece() != null && board.grid[i][j].getLivePiece().side == side){
                    legalPieces.add(board.grid[i][j].getLivePiece());
                    if(board.grid[i][j].getLivePiece().piece == Type.PAWN){
                        //System.out.println("Addded" + board.grid[i][j].getLivePiece());
                    }
                }
            }
        }
    }


    void generateLegalMoves(ChessPiece piece){
        ChessPiece piece2 = null;
        for(int i = 0; i < board.gridSizeX; i++){
            for(int j = 0; j < board.gridSizeY; j++){
                piece2 = board.grid[i][j].getLivePiece();
                if(piece.CanMove(i,j) && !board.grid[i][j].occupied|| (piece2 != null & piece.CanTake(piece2)) ){
                    legalMoves.add(new Moves(piece,i,j));
                    //System.out.println( new Moves(piece,i,j));
                }
            }
        }

    }

    Moves randomMove(){
        generateLegaPieces();
        //System.out.println(board);
        for(int k = 0; k < legalPieces.size(); k++){
            generateLegalMoves(legalPieces.get(k));
        }
        if(legalMoves.size() > 0){
            return legalMoves.get(rand.nextInt(legalMoves.size()));
        }
        else System.out.println("No Legal Moves Left");
        return null;
    }

    void clearMoves(){
        legalPieces.clear();
        legalMoves.clear();
    }

    Random rand = new Random();
    ArrayList <ChessPiece> legalPieces;
    ArrayList <Moves> legalMoves;
    Board board;
    Team side;
}



public class Moves implements Comparable<Moves>{
    Moves(ChessPiece piece, int x, int y){
        p = piece;
        row = x;
        collumn = y;
        weight = 0;
    }

    Moves(ChessPiece piece, int x, int y, int w){
        p = piece;
        row = x;
        collumn = y;
        weight = w;
    }
    
    public int getWeight(){
      return weight;
    }

    @Override
    public int compareTo(Moves otherMove){
        return Integer.compare(weight,otherMove.weight);
        //return (this.weight &lt; otherMove.weight ) ? -1: (this.weight &gt; otherMove.weight) ? 1:0 ;
    }
    @Override
    public String toString(){
        return p + " to " +  row + ", " + collumn + " Weight: " + weight;
    }

    ChessPiece p;
    int row;
    int collumn;
    int weight;
}



class GreedyAI extends RandomAI{
  
  
  
  
  GreedyAI(Board board1, Team side1){
        super(board1,side1);
    }

    void generateLegalMoves(ChessPiece piece){
        ChessPiece piece2 = null;
        for(int i = 0; i < board.gridSizeX; i++){
            for(int j = 0; j < board.gridSizeY; j++){
                piece2 = board.grid[i][j].getLivePiece();
                if(piece.CanMove(i,j) && !board.grid[i][j].occupied){
                    legalMoves.add(new Moves(piece,i,j,0));
                    //System.out.println( new Moves(piece,i,j));
                }
                else if(piece2 != null & piece.CanTake(piece2)){
                    switch(piece2.piece){
                        case PAWN:
                            legalMoves.add(new Moves(piece,i,j,1));
                            break;
                        case KING:
                            legalMoves.add(new Moves(piece,i,j,999));
                            break;
                        case KNIGHT:
                            legalMoves.add(new Moves(piece,i,j,4));
                            break;
                        case ROOK:
                            legalMoves.add(new Moves(piece,i,j,5));
                            break;
                        case QUEEN:
                            legalMoves.add(new Moves(piece,i,j,9));
                            break;
                        case BISHOP:
                            legalMoves.add(new Moves(piece,i,j,3));
                            break;
                        default:
                            legalMoves.add(new Moves(piece,i,j,1));
                            break;                            
                    }
                }
            }
        }

    }



    Moves GreedyMove(){
        generateLegaPieces();
        //System.out.println("Got here");
        for(int k = 0; k < legalPieces.size(); k++){
            generateLegalMoves(legalPieces.get(k));
        }

        if(legalMoves.size() > 0){
            Collections.sort(legalMoves);
            //System.out.println(legalMoves);
            //System.out.println("\n\n\n");
            if(legalMoves.get(legalMoves.size()-1).weight > 0){
              return legalMoves.get(legalMoves.size()-1);
            }else return legalMoves.get(rand.nextInt(legalMoves.size()));
        }
        else System.out.println("No Legal Moves Left");
        return null;
    }








}
