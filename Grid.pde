//TODO:
// Interopolation, could be fun to have cells be able to change shapes & color by slider
// Cells should have unique positions
// Make chess pieces
// Particle physics and physical blockers, recognzied by cells to mean occupied?

//Big Picture Ideas: Chess with physics to add fun game types! since each individual cell should be able to sense its physical surrounding, a 
// board could start for example "under water", flooded in some ares where no piece can occupy, or the board could even slowly start to flood, making some areas
// unplayable as the game progresses. Moving objects could also be on the field, that blocks pieces from moving forward.

class Board
{
  
  
  //Default board White's view
  Board(){
    gridSizeX = 8;
    gridSizeY = 8;
    //Physical size
    size = 100;
    grid = new Cell[gridSizeX][gridSizeY];
    PVector location = new PVector(720,800,0);
    String image = "white.jpg";
    for(int x = 0; x < gridSizeX; x++){
      for(int y = 0; y < gridSizeY; y++){
        
        // Set up Location
        location.add(size,0,0);
        
        
        
        // Set up Color or image
         if((x+y)%2 == 0){
           image = "black.jpg";
         }
         else{
           image = "white.jpg";
         }  
        
         
         
        grid[x][y] = new Cell(false,image,location,size);
        //System.out.print(grid[x][y].GetLocation());
        //System.out.print(location.x);
      }
      
      // Move to next row
      location.add((-size*gridSizeY),-size,0);
    } 
  }




  void DrawBoardSquare(){
    stroke(0);
    for(int x = 0; x < gridSizeX; x++){
      for(int y = 0; y < gridSizeY; y++){
         grid[x][y].DrawCellSquare();
         }
      }  
  }



  //void DrawBoardCube(){
  //  stroke(0);
  //  for(int x = 0; x < gridSizeX; x++){
  //    for(int y = 0; y < gridSizeY; y++){
  //       grid[x][y].DrawCellBox();
  //       }
  //    }  
  //}
  
  
  //void DrawBoardSphere(){
  //  stroke(0);
  //  for(int x = 0; x < gridSizeX; x++){
  //    for(int y = 0; y < gridSizeY; y++){
  //       grid[x][y].DrawCellSphere();
  //       }
  //    }  
  //}
  
  
  //void DrawBoardPyramid(){
  //  stroke(0);
  //  for(int x = 0; x < gridSizeX; x++){
  //    for(int y = 0; y < gridSizeY; y++){
  //       grid[x][y].DrawCellPyramid(size);
  //       }
  //    }  
  //}
  
  


  
    int size;
    int gridSizeX;
    int gridSizeY;
    Cell[][] grid;
}



class Cell
{
  Cell(PVector pos){
    occupied = false;
    selected = false;
    livePiece = false;
    image = "white.jpg";
    texture = loadImage(image);
    location = new PVector(0,0,0);
    location.add(pos);
    sphere = createShape(SPHERE, 100);
    sphere.setTexture(texture);
    cube = createShape(BOX, 100);
    cube.setTexture(texture);
    
    
    currentPieces = new ArrayList<ChessPiece>();
  }
  
  Cell(Boolean occ, String img, PVector pos, int size){
    selected = false;
    occupied = occ;
    image = img;
    //texture = loadImage(image);
    
    //Set location
    location = new PVector(0,0,0);
    location.add(pos);
    
    // Load Sphere texture
    //sphere = createShape(SPHERE, size);
    //sphere.setTexture(texture);
    
    // Load Cube texture
    //cube = createShape(BOX, size);
    //cube.setTexture(texture);
    
    
    currentPieces = new ArrayList<ChessPiece>();
  }
  
  
  
  float xPos(){
    return location.x;
  }
  
  float yPos(){
    return location.y;
  }
  
  float zPos(){
    return location.z;
  }
  
  PVector GetLocation(){
    return location;
  }
  
  void addPiece(ChessPiece piece){
    //System.out.println(piece);
    //System.out.println(piece.row);
    currentPieces.add(piece);
  }

  void removePiece(){
    if(!currentPieces.isEmpty()){
      currentPieces.remove(currentPieces.size()-1);
    }
  }

  ChessPiece getPiece(){
    if(!currentPieces.isEmpty()){
      return currentPieces.get(currentPieces.size()-1);
    }
    else return null;
  }
  
  ChessPiece getLivePiece(){
    if(!currentPieces.isEmpty() && !currentPieces.get(currentPieces.size()-1).taken){
      return currentPieces.get(currentPieces.size()-1);
    }
    else return null;
  }

  boolean noPieces(){
    if(currentPieces.isEmpty() || currentPieces.get(currentPieces.size()-1).taken){
      return true;
    }
    else return false;
  }



  void DrawCellSquare(){
    //translate(location.x,location.y);
    pushMatrix();
    if(image.equals("black.jpg")){
      fill(0);
    }
    else fill(255);
    
    if(livePiece){
      fill(100);
    }
    if(selected){
      fill(255,220,0);
    } 
    translate(location.x,location.y);
    square(0,0,size);
    popMatrix();
  }

  //void DrawCellBox(){
  //  pushMatrix();
  //  translate(location.x,location.y,location.z);
  //  shape(cube);
  //  popMatrix();
  //}
  
  //void DrawCellSphere(){
  //  pushMatrix();
  //  translate(location.x,location.y,location.z);
  //  shape(sphere);
  //  popMatrix();
  //} 
  
  
  
  //void DrawCellPyramid(int size){
  //  pushMatrix();
  //  translate(location.x,location.y,location.z);
  //  fill(255);
  //  beginShape();

    
    
  //  texture(texture);
  //  vertex(-size, -size, -size,0,0);
  //  vertex( size, -size, -size,size,0);
  //  vertex(   0,    0,  size,0,size);

  //  vertex( size, -size, -size,0,0); 
  //  vertex( size,  size, -size,0,0);
  //  vertex(   0,    0,  size,0,0);

  //  vertex( size, size, -size,0,0);
  //  vertex(-size, size, -size,0,0);
  //  vertex(   0,   0,  size,0,0);

  //  vertex(-size,  size, -size,0,0);
  //  vertex(-size, -size, -size,0,0);
  //  vertex(   0,    0,  size,0,0);
  //  endShape();
  //  popMatrix();
  //}
  
  
  
  
  ArrayList<ChessPiece> currentPieces;
  PShape sphere;
  PShape cube;
  PImage texture;
  boolean occupied;
  String image;
  PVector location;
  boolean selected;
  boolean livePiece;
  
}
