/** Click that selects difficulty. */
boolean initialClick = true;
/** Click that ensures first square is blank. */
boolean startClick = true;
/** The mine field. */
Minefield board;
/** Offset of mouse location depending on difficulty. */
float offset;
/** Current mouse position. */
int[] hover = new int[2];

/** Initialize background. */
void setup() {
    size(640, 640);
    actualSetup(0);
}

/** Repeatedly draws board. */
void draw() {
  update();
  if (board != null && !board.gameOver) {
     background(128, 128, 128);
     board.show();
  }
}

/** Find current mouse position. */
void update() {
  if (initialClick) {
     if (overSetting() == 1) {
         actualSetup(1);
     } else if (overSetting() == 2) {
         actualSetup(2);
     } else if (overSetting() == 3) {
         actualSetup(3);
     } else {
         actualSetup(0);
     }
  }
  if (board != null && board.gameOver) {
     int c = 18;
     if (overReset()) {
       rectMode(CENTER);
       fill(150, 150, 150);
       rect(width/2, height/2 + 40, 100, 40, c, c, c, c);
     } else {
       rectMode(CENTER);
       fill(255);
       rect(width/2, height/2 + 40, 100, 40, c, c, c, c);
     }
     fill(77, 77, 77);
     textSize(28);
     text("reset", width/2 - 34, height/2 + 50);
  } else if (board != null && !board.gameOver) {
     if (overSquare()) {   
       board.storeHover(hover[0], hover[1], true);
    } else {
       board.storeHover(0, 0, false);
    }
  }
}

/** Shows mouse over tile in the board. */
boolean overSquare() {
  if (board.dif == 1) {
        offset = 207.5;
    } else if (board.dif == 2) {
        offset = 115.2;
    } else if (board.dif == 3) {
        offset = 12.8;
    }
  int mouseCol = floor((mouseX - offset)/board.sqdim);
  int mouseRow = floor((mouseY - offset)/board.sqdim);
  hover[0] = mouseCol; hover[1] = mouseRow;
  if (mouseCol < 0 || mouseCol > board.size - 1 || mouseRow < 0 || mouseRow > board.size - 1) {
      return false;
  }
  return true;
}

/** Shows mouse over current setting. */
int overSetting() {
  if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 30 && mouseY < height/2 + 70) {
    return 1;
  } else if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 80 && mouseY < height/2 + 120) {
    return 2;
  } else if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 130 && mouseY < height/2 + 170) {
    return 3;
  } else {
    return 0;
  }
}

/** Shows mouse over reset button. */
boolean overReset() {
  if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 20 && mouseY < height/2 + 60) {
    return true;
  } else {
    return false;
  }
}

/** Has effect when clicked, setting, tile, or reset. */
void mouseClicked() {
  if (board != null && board.gameOver) {
    if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 20 && mouseY < height/2 + 60) {
       actualSetup(0);
       initialClick = true;
       startClick = true;
       board.gameOver = false;
       board = null;
       return;
    }
  }
  if (initialClick) {
    if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 30 && mouseY < height/2 + 70) {
        board = new Minefield(1);
        initialClick = false;
    } else if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 80 && mouseY < height/2 + 120) {
        board = new Minefield(2);
        initialClick = false;
    } else if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 130 && mouseY < height/2 + 170) {
        board = new Minefield(3);
        initialClick = false;
    }
  } else {
    if (board.dif == 1) {
        offset = 207.5;
    } else if (board.dif == 2) {
        offset = 115.2;
    } else if (board.dif == 3) {
        offset = 12.8;
    }
    int mouseCol = floor((mouseX - offset)/board.sqdim);
    int mouseRow = floor((mouseY - offset)/board.sqdim);
    if (mouseCol < 0 || mouseCol > board.size - 1 || mouseRow < 0 || mouseRow > board.size - 1) {
      return;
    }
    while(startClick) {
        if (board.field[mouseCol][mouseRow].isBlank()) {
            startClick = false;
        } else {
            int dif = board.getDif();
            board = new Minefield(dif);
        } 
    }
    if (mouseButton == RIGHT && !board.field[mouseCol][mouseRow].isRevealed()) {
        board.flagUpdate(mouseCol, mouseRow);
        return;
    } else if (mouseButton == RIGHT || board.field[mouseCol][mouseRow].flagged()) {
        return;
    }
    if (board.field[mouseCol][mouseRow].isBlank()) {
        board.revealAdjacent(board.field[mouseCol][mouseRow]);
    } else if (board.field[mouseCol][mouseRow].isNumber() && board.field[mouseCol][mouseRow].isRevealed()) { 
        board.quickReveal(mouseCol, mouseRow);
    } else if (board.field[mouseCol][mouseRow].isMine()  && !board.field[mouseCol][mouseRow].flagged()) {
        board.gameOver();
    } else {
        board.field[mouseCol][mouseRow].update();
    }
    board.checkGameWin();
    
  }
}

/** Sets up start up screen. */
void actualSetup(int loc) {
    int c = 18;
    background(128, 128, 128);
    textSize(72);
    fill(0);
    text("Minesweeper", 105, 255);
    fill(255);
    text("Minesweeper", 100, 250);
    fill(255);
    rectMode(CENTER);
    if (loc == 1) {
       fill(150, 150, 150);
       rect(width/2, height/2 + 50, 100, 40, c, c, c, c);
       fill(255);
       rect(width/2, height/2 + 100, 100, 40, c, c, c, c);
       rect(width/2, height/2 + 150, 100, 40, c, c, c, c);  
    } else if (loc == 2) {
       fill(150, 150, 150);
       rect(width/2, height/2 + 100, 100, 40, c, c, c, c);
       fill(255);
       rect(width/2, height/2 + 50, 100, 40, c, c, c, c);
       rect(width/2, height/2 + 150, 100, 40, c, c, c, c);  
    } else if (loc == 3) {
       fill(150, 150, 150);
       rect(width/2, height/2 + 150, 100, 40, c, c, c, c);
       fill(255);
       rect(width/2, height/2 + 50, 100, 40, c, c, c, c);
       rect(width/2, height/2 + 100, 100, 40, c, c, c, c);
    } else {
        rect(width/2, height/2 + 50, 100, 40, c, c, c, c);
        rect(width/2, height/2 + 100, 100, 40, c, c, c, c);
        rect(width/2, height/2 + 150, 100, 40, c, c, c, c);   
    }
    fill(77, 77, 77);
    textSize(23);
    text("Easy", width/2 - 24, height/2 + 58);
    text("Medium", width/2 - 44, height/2 + 108);
    text("Hard", width/2 - 26, height/2 + 158);
    fill(255);
    rectMode(CORNER);
}