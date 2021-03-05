class ShapeAndPiece{
  
  
  ShapeAndPiece(PShape shape, ChessPiece piece){
    s = shape;
    p = piece;
  }
  
  
  ChessPiece GetPiece(){
    return p;
  }
  
  PShape GetShape(){
    return s;
  }
  
  
  
  void setPiece(ChessPiece piece){
    p = piece;
    
  }
  
  void setShape(PShape shape){
    s = shape;
  }
  
  PShape s;
  ChessPiece p;


}
