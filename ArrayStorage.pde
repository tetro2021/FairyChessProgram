class ShapeAndType{
  
  
  ShapeAndType(PShape shape, Type piece){
    s = shape;
    p = piece;
  }
  
  
  Type GetPiece(){
    return p;
  }
  
  PShape GetShape(){
    return s;
  }
  
  
  
  void setPiece(Type piece){
    p = piece;
    
  }
  
  void setShape(PShape shape){
    s = shape;
  }
  
  PShape s;
  Type p;


}
