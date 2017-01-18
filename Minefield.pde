import java.util.Queue;
import java.util.LinkedList;

class Minefield {
  Tile[][] field; //[cols][rows]
  int numMines;
  int easy = 9;
  int medium = 16;
  int hard = 24;
  int cols; int rows;
  float sqdim;
  int size;
  int dif;
  boolean gameOver;
  int currCol;
  int currRow;
    
  
 Minefield(int difficulty) {
   dif = difficulty;
   switch (dif) {
       case 1:
           cols = easy; rows = easy;
           size = easy;
           sqdim = 25.6;
           field = new Tile[cols][rows];
           numMines = 10;
           initializeField();
           break;
       case 2:
           cols = medium; rows = medium;
           size = medium;
           sqdim = 25.6;
           field = new Tile[cols][rows];
           numMines = 40;
           initializeField();
           break;
       case 3:
           cols = hard; rows = hard;
           size = hard;
           sqdim = 25.6;
           field = new Tile[cols][rows];
           numMines = 99;
           initializeField();
           break;
   }
 }
 
 void show() {
   for (int y = 0; y < rows; y += 1) {
       for (int x = 0; x < cols; x += 1) {
           if (x == currCol && y == currRow) {
               field[x][y].hoverShow();
           } else {
               field[x][y].show();
           }
       }
   }
 }
 
 
 void initializeField() {
   int count = 0;
   for (int y = 0; y < rows; y += 1) {
       for (int x = 0; x < cols; x += 1) {
         field[x][y] = new Blank(x, y, dif);
       }
   }
   
   while (count < numMines) { //<>//
         int randx = floor(random(0, cols));
         int randy = floor(random(0, rows));
         if (!field[randx][randy].isMine()) {
            field[randx][randy] = new Mine(randx, randy, dif);
            count += 1;
         }
   }
   
   for (int y = 0; y < rows; y += 1) { //<>//
       for (int x = 0; x < cols; x += 1) {
           int mineCount = 0;
           if (!field[x][y].isMine()) {
              for (int dy = -1; dy <= 1; dy += 1) {
                  for (int dx = -1; dx <= 1; dx += 1) {
                      if (dx == 0 && dy == 0) {
                        continue;
                      } else {
                         try {
                             if (field[x + dx][y + dy].isMine()) {
                                mineCount += 1;
                             }
                         } catch (ArrayIndexOutOfBoundsException e) {
                             continue;
                             }
                      }
                  }
               }
               if (mineCount != 0) {
                  field[x][y] = new Number(x, y, mineCount, dif);
               }
           }
       }
   }   
 }
 
 
 void revealAdjacent(Tile piece) {
     fringe.add(piece);
     while(!fringe.isEmpty()) {
          Tile node = fringe.poll();
          if (node.isNumber()) {
               continue;
          }
          if (!marked(node)) {
             mark(node);
             node.update();
             for (int dy = -1; dy <= 1; dy += 1) {
                 for (int dx = -1; dx <= 1; dx += 1) {
                     if (dx == 0 && dy == 0) {
                         continue;
                     } else {
                        try {
                           if (!marked(field[node.getXPos() + dx][node.getYPos() + dy])) {
                               fringe.add(field[node.getXPos() + dx][node.getYPos() + dy]);
                               if (field[node.getXPos() + dx][node.getYPos() + dy].isNumber()) {
                                   field[node.getXPos() + dx][node.getYPos() + dy].update();
                               }
                           }
                       } catch (ArrayIndexOutOfBoundsException e) {
                           continue;
                       }
                    } 
                }
            }
        }
     }
 }
 
 boolean marked(Tile a) {
     return marked.contains(a);
 }
 
 void mark(Tile a) {
     if (marked(a)) {
       return;
     }
     marked.add(a);
 }
 
Queue<Tile> fringe = new LinkedList();
ArrayList<Tile> marked = new ArrayList();

 void flagUpdate(int c, int r) {
       field[c][r].flag();
 }
 
 void quickReveal(int c, int r) {
     for (int dy = -1; dy <= 1; dy += 1) {
         for (int dx = -1; dx <= 1; dx += 1) {
             if (dx == 0 && dy == 0) {
                 continue;
             } else {
                 try {
                   if (field[c + dx][r + dy].isBlank()) {
                      revealAdjacent(field[c + dx][r + dy]);
                   } else if (field[c + dx][r + dy].isMine() && !field[c + dx][r + dy].flagged()) {
                      gameOver();
                   }
                   field[c + dx][r + dy].update();
                 }
                 catch (ArrayIndexOutOfBoundsException e) {
                     continue;
                 }
             }
         }
     }
 }
 
 int getDif() {
     return dif;
 }
 
 void storeHover(int c, int r, boolean store) {
    if (store) {
       currCol = c;
       currRow = r;
    } else {
       currCol = -1;
       currRow = -1;
    }
 }
 
 void checkGameWin() {
     for (int y = 0; y < rows; y += 1) {
       for (int x = 0; x < cols; x += 1) {
           if ((field[x][y].isNumber() || field[x][y].isBlank()) && field[x][y].isRevealed()) {
               continue;
           } else if (field[x][y].isMine() && (field[x][y].flagged() || !field[x][y].isRevealed())) {
               continue;
           } else {
               return;
           }
       }
     }
     draw();
     pushMatrix();
     gameOver = true;
     translate(width/2, height/2);
     textSize(50);
     fill(0);
     text("CONGRATULATIONS", -250 + 5, 0 + 5);
     fill(200, 0, 200);
     text("CONGRATULATIONS", -250, 0);
     popMatrix();
 }
 
 
 void gameOver() {
   for (int y = 0; y < rows; y += 1) {
       for (int x = 0; x < cols; x += 1) {
           if (field[x][y].isMine()) {
               field[x][y].update();
           }
       }
   }
   draw();
   pushMatrix();
   gameOver = true;
   translate(width/2, height/2);
   textSize(50);
   fill(0);
   text("GAME OVER", -140 + 5, 0 + 5);
   fill(200, 0, 200);
   text("GAME OVER", -140, 0);
   popMatrix();
 }

}