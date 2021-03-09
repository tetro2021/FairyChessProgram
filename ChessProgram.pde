//Ethan Kane
import java.util.ArrayList;
import java.util.Random;
import java.util.Comparator;
import java.util.Collections;

// Simple loading Setup
PImage space;
PImage textureBlack;
PImage textureWhite;
PVector drawlocation;


// Players & gamemode
int numPlayers = 2;
ArrayList<Player> playerList;
int gameMode = 2;
RandomAI eloOf1;
GreedyAI eloOf20;

// Keeps track of live game
ChessPiece currentPiece = null;
boolean firstSelect = true;
int selectRow;
int selectCollumn;
Cell curentCell = null;
int playerTurn = 0;
boolean promotionAvailable = false;



// Default size: 100
int size = 100;


// Load all shapes outside of cell on setup?

Board board;
ArrayList<ChessPiece> pieces;
//ArrayList<PShape> shapelist;
ArrayList<ShapeAndType> shapelist;
PShape bishop;
PShape king;
PShape knight;
PShape pawn;
PShape queen;
PShape rook;
float xtrack = 0;
float ytrack = 0;


float scale = 6;
float temp = 100/6; 

void setup(){
  //Set up backround and camera
  size(2560, 1440); noStroke(); 
  //camera = new Camera(469,1246,404,-6.3,1.5,50,1.57);
  surface.setTitle("Chess, regular 2D");
  space = loadImage("space.jpg");
  strokeWeight(0.5); //Draw thicker lines 
  textSize(32);  



  //Set up players
  
  






  // Set up physical board and cells
  loadBoard();
  
  
  
  
  // Testing normal chess
  
  
  
  // Example of moveing and take
  
  // Load chess set
  pieces = new ArrayList<ChessPiece>();
  loadPieces();
  


  // Load AI
  eloOf1 = new RandomAI(board,Team.BLACK);
  eloOf20 = new GreedyAI(board,Team.BLACK);



  //Load Players
  playerList = new ArrayList<Player>();


  // Assuming that gamemodes over the 5th are more than 2 player, might change later
  if(gameMode < 5){
    Player p1 = new Player(Team.WHITE);
    Player p2 = new Player(Team.BLACK);
    System.out.println(p1.side);
    playerList.add(p1);
    playerList.add(p2);
  }


}






void loadPieces(){
  shapelist = new ArrayList<ShapeAndType>();
  bishop = loadShape("bishop.svg");
  ShapeAndType bShape = new ShapeAndType(bishop,Type.BISHOP);
  shapelist.add(bShape);
  king = loadShape("king.svg");
  ShapeAndType kShape = new ShapeAndType(king,Type.KING);
  shapelist.add(kShape);
  knight = loadShape("knight.svg");
  ShapeAndType knShape = new ShapeAndType(knight,Type.KNIGHT);
  shapelist.add(knShape);
  pawn = loadShape("pawn.svg");
  ShapeAndType pShape = new ShapeAndType(pawn,Type.PAWN);
  shapelist.add(pShape);
  queen = loadShape("queen.svg");
  ShapeAndType qShape = new ShapeAndType(queen,Type.QUEEN);
  shapelist.add(qShape);
  rook = loadShape("rook.svg");
  ShapeAndType rShape = new ShapeAndType(rook,Type.ROOK);
  shapelist.add(rShape);
  
  
  
  
  selfStyle(shapelist);


  

  // WHITE
  
  
  Pawn pawnPiece = new Pawn(board,Team.WHITE, false,false, 1,0,pawn);
  pieces.add(pawnPiece);
  
  Pawn pawnPiece2 = new Pawn(board,Team.WHITE, false,false, 1,1,pawn);
  pieces.add(pawnPiece2);
  
  Pawn pawnPiece3 = new Pawn(board,Team.WHITE, false,false, 1,2,pawn);
  pieces.add(pawnPiece3);
  
  Pawn pawnPiece4 = new Pawn(board,Team.WHITE, false,false, 1,3,pawn);
  pieces.add(pawnPiece4);
  
  Pawn pawnPiece5 = new Pawn(board,Team.WHITE, false,false, 1,4,pawn);
  pieces.add(pawnPiece5);
  
  Pawn pawnPiece6 = new Pawn(board,Team.WHITE, false,false, 1,5,pawn);
  pieces.add(pawnPiece6);
  
  Pawn pawnPiece7 = new Pawn(board,Team.WHITE, false,false, 1,6,pawn);
  pieces.add(pawnPiece7);
  
  Pawn pawnPiece8 = new Pawn(board,Team.WHITE, false,false, 1,7,pawn);
  pieces.add(pawnPiece8);
  
  
  Bishop bishopPiece = new Bishop(board,Team.WHITE, false,false, 0,2,bishop);
  pieces.add(bishopPiece);
  Bishop bishopPiece2 = new Bishop(board,Team.WHITE, false,false, 0,5,bishop);
  pieces.add(bishopPiece2);


  Rook rookPiece = new Rook(board,Team.WHITE, false,false, 0,0,rook);
  pieces.add(rookPiece);
  Rook rookPiece2 = new Rook(board,Team.WHITE, false,false, 0,7,rook);
  pieces.add(rookPiece2);
  
  
  Knight knightPiece = new Knight(board,Team.WHITE, false,false, 0,1,knight);
  pieces.add(knightPiece);
  Knight knightPiece2 = new Knight(board,Team.WHITE, false,false, 0,6,knight);
  pieces.add(knightPiece2);

  Queen queenPiece = new Queen(board, Team.WHITE, false,false, 0,3,queen);
  pieces.add(queenPiece);

  King kingPiece = new King(board,Team.WHITE, false,false, 0,4,king);
  pieces.add(kingPiece);
  
  
  
  
  
  //BLACK
  
  
  Pawn bpawnPiece = new Pawn(board,Team.BLACK, false,false, 6,0,pawn);
  pieces.add(bpawnPiece);
  
  Pawn bpawnPiece2 = new Pawn(board,Team.BLACK, false,false, 6,1,pawn);
  pieces.add(bpawnPiece2);
  
  Pawn bpawnPiece3 = new Pawn(board,Team.BLACK, false,false, 6,2,pawn);
  pieces.add(bpawnPiece3);
  
  Pawn bpawnPiece4 = new Pawn(board,Team.BLACK, false,false, 6,3,pawn);
  pieces.add(bpawnPiece4);
  
  Pawn bpawnPiece5 = new Pawn(board,Team.BLACK, false,false, 6,4,pawn);
  pieces.add(bpawnPiece5);
  
  Pawn bpawnPiece6 = new Pawn(board,Team.BLACK, false,false, 6,5,pawn);
  pieces.add(bpawnPiece6);
  
  Pawn bpawnPiece7 = new Pawn(board,Team.BLACK, false,false, 6,6,pawn);
  pieces.add(bpawnPiece7);
  
  Pawn bpawnPiece8 = new Pawn(board,Team.BLACK, false,false, 6,7,pawn);
  pieces.add(bpawnPiece8);
  
  Bishop bbishopPiece = new Bishop(board,Team.BLACK, false,false, 7,2,bishop);
  pieces.add(bbishopPiece);
  Bishop bbishopPiece2 = new Bishop(board,Team.BLACK, false,false, 7,5,bishop);
  pieces.add(bbishopPiece2);


  Rook brookPiece = new Rook(board,Team.BLACK, false,false, 7,0,rook);
  pieces.add(brookPiece);
  Rook brookPiece2 = new Rook(board,Team.BLACK, false,false, 7,7,rook);
  pieces.add(brookPiece2);
  
  
  Knight bknightPiece = new Knight(board,Team.BLACK, false,false, 7,1,knight);
  pieces.add(bknightPiece);
  Knight bknightPiece2 = new Knight(board,Team.BLACK, false,false, 7,6,knight);
  pieces.add(bknightPiece2);

  Queen bqueenPiece = new Queen(board, Team.BLACK, false,false, 7,3,queen);
  pieces.add(bqueenPiece);

  King bkingPiece = new King(board,Team.BLACK, false,false, 7,4,king);
  pieces.add(bkingPiece);
  


}



void keyPressed()
{
  if ( key == 'w' ){
    System.out.print(playerList.get((playerTurn+1)%2).getPreviousMove());
  }
  if ( key == 'e' ){
  //    if(currentPiece != null){
  //      selectCell();
  //      if(board.grid[selectRow][selectCollumn].getLivePiece() != null){
  //        currentPiece.Take(board.grid[selectRow][selectCollumn].getLivePiece());
  //      }
  //      else currentPiece.Move(selectRow,selectCollumn);
  //    }
  }
}

void keyReleased()
{
  //if ( key == 'w' ){
  //  // Do nothing
  //}
}


void mouseClicked(){
  
    if(promotionAvailable){
    
    Type promotion = SelectNewPiece();
    if(promotion != null){
      System.out.println("TYPE: " + promotion);
      //generateNewPiece(promotion).promote(playerList.get(playerTurn).getPreviousMove().p);
      System.out.println(playerList.get(playerTurn).getPreviousMove().p);
      if(playerTurn == 0){
        generateNewPiece(promotion).promote(playerList.get(playerList.size()-1).getPreviousMove().p);
        promotionAvailable = false;        
      }
      else{
        generateNewPiece(promotion).promote(playerList.get(playerTurn-1).getPreviousMove().p);
        promotionAvailable = false;      
      }
    }
    else{
      return;
    }
    
  }
  
  
  if(gameMode == 0){
    TwoPlayerClick();
  }
  else if(gameMode == 1){
    vsAI();
  }
  else if(gameMode == 2){
    vsGreedy();
  }
   
}




ChessPiece generateNewPiece(Type t){
                      switch(t){
                        case PAWN:
                            return new Pawn(board,Team.WHITE, pawn);
                            //break;
                        case KING:
                            return new King(board,Team.WHITE, king);
                            //break;
                        case KNIGHT:
                            return new Knight(board,Team.WHITE, knight);
                            //break;
                        case ROOK:
                            return new Rook(board,Team.WHITE, rook);
                            //break;
                        case QUEEN:
                            return new Queen(board,Team.WHITE, queen);
                            //break;
                        case BISHOP:
                            return new Bishop(board,Team.WHITE, bishop);
                            //break;
                        default:
                            return new ChessPiece(board,Team.WHITE,pawn);
                            //break;                            
                    }
}










void selectCell(){
  for(int x = 0; x < board.gridSizeX; x++){
    for(int y = 0; y < board.gridSizeY; y++){
      // Check X
      board.grid[x][y].selected = false;
      if (mouseX > board.grid[x][y].location.x && mouseX < board.grid[x][y].location.x + size){
        // Check Y
        if (mouseY > board.grid[x][y].location.y && mouseY < board.grid[x][y].location.y + size){
          board.grid[x][y].selected = true;
          selectRow = x;
          selectCollumn = y;
          //if(board.grid[x][y].getPiece() != null){
            //currentPiece = board.grid[x][y].getLivePiece();
          //}
          //System.out.println(board.grid[x][y].getPiece());
          //System.out.println(x + " " + y);
        }
      }
      if(board.grid[x][y].getLivePiece() != null){
        board.grid[x][y].livePiece = true;
      }
      else board.grid[x][y].livePiece = false;
    }
  }
  //firstSelect = false;
}

void selectSecondCell(){
  for(int x = 0; x < board.gridSizeX; x++){
    for(int y = 0; y < board.gridSizeY; y++){
      // Check X
      board.grid[x][y].selected = false;
      if (mouseX > board.grid[x][y].location.x && mouseX < board.grid[x][y].location.x + size){
        // Check Y
        if (mouseY > board.grid[x][y].location.y && mouseY < board.grid[x][y].location.y + size){
          board.grid[x][y].selected = true;
          selectRow = x;
          selectCollumn = y;
          if(currentPiece != null){
            System.out.println(currentPiece);
            if(board.grid[x][y].getLivePiece() != null){
                currentPiece.Take(board.grid[x][y].getPiece());
            }
            else{
              currentPiece.Move(selectRow,selectCollumn);
            }
          }
        }
      }
    }
  }
  firstSelect = true;
}


void loadBoard(){
  //textureBlack = loadImage("black.jpg");
  //textureWhite = loadImage("white.jpg");
  board = new Board();
}






void selfStyle(ArrayList<ShapeAndType> shapes){
  for(int i = 0; i < shapes.size(); i++){
    shapes.get(i).GetShape().disableStyle();
    //shapes.get(i).setFill(100);
  }
}




void drawChess(){
  board.DrawBoardSquare();
  


  for(int i = 0; i < pieces.size(); i++){
    drawlocation = board.grid[pieces.get(i).row][pieces.get(i).collumn].GetLocation();
    //pushMatrix();
    //translate(drawlocation.x,drawlocation.y+size/2,drawlocation.z);
    //scale(scale);
    //rotate(PI);
    if(pieces.get(i).side == Team.BLACK) {
      fill(90,255,90);
    }
    else fill(90,50,150);
    
    if(pieces.get(i).IsChecked(pieces)){
      if(pieces.get(i).side == Team.BLACK) {
        fill(200,240,90);
      }
      else fill(120,50,150);
    }
    
    if(!pieces.get(i).taken){
      shape(pieces.get(i).type,drawlocation.x,drawlocation.y,size,size);
    }
    //popMatrix();
  }
  
}




void AskPromotion(){
  if(promotionAvailable){
    fill(200);
    square(100,100,500);
    fill(50);
    text("Promote?",100,100,500,500);
    int y = 0;
    int x = 0;
    for(int i = 0; i < shapelist.size(); i++){
      shape(shapelist.get(i).GetShape(),100+100*x,150+100*y,size,size);
      x++;
      if(x % 4 == 0){
        y++;
        x = 0;
      }
    }
    // TODO: DRAW ALL PIECE TYPES TO CLICK ON
  }

}





Type SelectNewPiece(){
  int x =0;
  int y = 0;
  Type temp = null;
  for(int i = 0; i < shapelist.size(); i++){
    if( mouseX >= (100 + 100*x) && mouseX < (100+100*x)+size && mouseY >= (150+100*y) && mouseY < (150+100*y)+size)   
    temp = shapelist.get(i).GetPiece();
    x++;
    if(x % 4 == 0){
      y++;
      x = 0;
    }
  }
  if(temp == null){
    System.out.println("cant find?");
    //System.out.println(mouseX + " " + (100 + 100*x));
    return temp;
  }
  return temp;
}




void draw(){
  
  
  //camera();
  //system.out.println(frameRate);
  //setup
  background(space);
 
  //board.DrawBoardSquare();
  drawChess();
  AskPromotion();
  //Light setup
  //specular(120, 120, 180);   
  //ambientLight(100,100,100);  
  //directionalLight(200, 200, 200, -1, 1, -1); 
  
  //Create Board
  //drawChess();
  //System.out.println(frameRate);
  
}
  
  
  
  
  
  
 
