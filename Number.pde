class Number extends Tile {
  int _surround;
  int _posx;
  int _posy;
  boolean revealed;
  boolean flagged;
  int _dif;
  float eS = 207.5;
  float mS = 115.2;
  float hS = 12.8;
  float s;
  
  Number(int posx, int posy, int surround, int dif) {
    _posx = posx;
    _posy = posy;
    _surround = surround;
    _dif = dif;
    switch (_dif) {
      case 1:
         s = eS;
         break;
      case 2:
         s = mS;
         break;
      case 3:
         s = hS;
         break;
    }
  }
  
  @Override
  void update() {
        revealed = true;
  }
  
  @Override
  void show() {
    if (flagged) {
       pushMatrix();
       translate(s, s);
       fill(255);
       rect(_posx * 25.6, _posy * 25.6, 25.6, 25.6);
       fill(255, 0, 0);
       ellipseMode(CENTER);
       ellipse(_posx * 25.6 + 12.8, _posy * 25.6 + 12.8, 10, 10);
       popMatrix();
       return;
    }
    if (!revealed) {
        pushMatrix();
        translate(s, s);
        fill(255);
        rect(_posx * 25.6, _posy * 25.6, 25.6, 25.6);
        popMatrix();
    } else {
        pushMatrix();
        translate(s, s);
        fill(255);
        rect(_posx * 25.6, _posy * 25.6, 25.6, 25.6);
        fill(255, 0, 0);
        textSize(25);
        float xp = _posx * 25.6 + 4;
        float yp = (_posy + 1) * 25.6 - 4;
        text(String.format("%s", _surround), xp, yp);
        popMatrix();
    }
  }
  
  @Override
  void hoverShow() {
    if (!revealed && !flagged) {
        pushMatrix();
        translate(s, s);
        fill(150, 150, 150);
        rect(_posx * 25.6, _posy * 25.6, 25.6, 25.6);
        noStroke();
        fill(255);
        float t = 25.6 * .095;
        rect(_posx * 25.6 + t + .1, _posy * 25.6 + t,
              25.6 - t - .99 + .1, 25.6 - t - .99, 6, 0, 0, 0);
        popMatrix(); 
        stroke(0);
    } else {
        show();
    }
  }
  
  @Override
  boolean isMine() {
    return false;
  }
  
  @Override
  boolean isBlank() {
    return false;
  }
  
  @Override
  boolean isNumber() {
    return true;
  }
   
  @Override
  boolean isRevealed() {
    return revealed;
  }
  
    @Override
  int getXPos() {
    return _posx;
  }
  
  @Override
  int getYPos() {
    return _posy;
  }
  
  @Override
  void flag() {
    flagged = !flagged;
  }
  
  @Override
  boolean flagged() {
    return flagged;
  }

}