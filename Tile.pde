abstract class Tile {
  
  abstract void update();

  abstract void show();
  
  abstract boolean isMine();
  
  abstract boolean isBlank();
  
  abstract boolean isNumber();
  
  abstract boolean isRevealed();
  
  abstract int getXPos();
  
  abstract int getYPos();
  
  abstract void flag();
  
  abstract boolean flagged();
  
  abstract void hoverShow();

}