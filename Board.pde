class Board {
  int boardSize = 640;
  int numMines = 45;
  int tileSize = 40;
  int boardWidth = 2 * (boardSize/tileSize) - 1;
  int boardHeight = (boardSize/tileSize);
  Tile[][] tiles;

  Board() {
    tiles =  new Tile[boardHeight][boardWidth];
    PVector a = new PVector(0, 0);
    PVector b = new PVector(tileSize/2, tileSize);
    PVector c = new PVector(tileSize, 0);
    boolean flag = false;

    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardWidth; j++) {
        tiles[i][j] = new Tile(a, b, c, flag);
        a = b.copy();
        b = c.copy();
        c = a.copy();
        c.x += tileSize;
        flag = !flag;
      }
      if (i%2 == 0) {
        a.set(0, a.y + tileSize);
        c.set(a.x + tileSize, a.y);
        b.set(a.x + tileSize/2, a.y - tileSize);
      } else {
        a.set(0, a.y + tileSize);
        c.set(tileSize, a.y);
        b.set(tileSize/2, b.y + tileSize);
      }
    }
    resetGame();
  }

  void show() {
    if (!win()) {
      showPlay();
    } else {
      showEnd();
    }
  }

  void showPlay() {
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardWidth; j++) {
        tiles[i][j].show();
      }
    }
  }

  void showEnd() {
    fill(0, 0, 255);
    text("Congradulations!", boardSize/3+50, boardSize/2);
  }

  void action() {
    if (win() && mouseButton == LEFT) {
      numMines += 5;
      resetGame();
    } else {
      for (int i = 0; i < boardHeight; i++) {
        for (int j = 0; j < boardWidth; j++) {
          if (mouseButton == LEFT) {
            if (tiles[i][j].click()) {
              if (tiles[i][j].mine) {
                resetGame();
              } else {
                lookAround(i, j);
              }
            }
          } else if (mouseButton == RIGHT) {
            tiles[i][j].cover();
          }
        }
      }
    }
  }

  boolean win() {
    boolean flag = true;
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardWidth; j++) {
        if (!tiles[i][j].visited && !tiles[i][j].check && !tiles[i][j].mine) {
          flag = false;
        }
      }
    }
    return flag;
  }

  void newGame() {
    int count = 0;
    int ran;

    //set the mines for the board
    while (count<numMines) {
      ran = int(random(0, boardHeight * boardWidth));
      if (ran < boardHeight*boardWidth && !tiles[ran/boardWidth][ran % boardWidth].space) {
        int i = ran/boardWidth;
        int j = ran % boardWidth;
        tiles[i][j].space = true;
        tiles[i][j].mine = true;
        //println("Mine: " + i + " " + j);

        if (j-1 >= 0) { //left
          if (i-1 >= 0) { //left top
            tiles[i-1][j-1].counter++;
            if (!tiles[i][j].up && j-2 >= 0) {//far left top
              tiles[i-1][j-2].counter++;
            }
          }
          if (i+1 < boardHeight) { //left bottom
            tiles[i+1][j-1].counter++;
            if (tiles[i][j].up && j-2 >= 0) { //far left bottom
              tiles[i+1][j-2].counter++;
            }
          }
          tiles[i][j-1].counter++; //left middle
          if (j-2 >= 0) {
            tiles[i][j-2].counter++; //far left middle
          }
        }

        if (i-1 >= 0) {
          tiles[i-1][j].counter++;  //top middle
        }
        if (i+1 < boardHeight) {
          tiles[i+1][j].counter++; //bottom middle
        }

        if (j+1 < boardWidth) {
          if (i-1 >= 0) {
            tiles[i-1][j+1].counter++; //top right
            if (!tiles[i][j].up && j+2 < boardWidth) { //far top right
              tiles[i-1][j+2].counter++;
            }
          }
          if (i+1 < boardHeight) {
            tiles[i+1][j+1].counter++; //bottom right
            if (tiles[i][j].up && j+2 < boardWidth) { //far bottom right
              tiles[i+1][j+2].counter++;
            }
          }
          tiles[i][j+1].counter++; // middle right
          if (j+2 < boardWidth) {
            tiles[i][j+2].counter++; //far middle right
          }
        }

        count++;
      }
    }
  }

  void resetGame() {
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardWidth; j++) {
        tiles[i][j].reset();
      }
    }
    newGame();
  }

  //add more to lookaround
  void lookAround(int i, int j) {
    if (!tiles[i][j].visited) {
      tiles[i][j].visited = true;
      tiles[i][j].check = true;
      if (tiles[i][j].counter == 0) {
        if (j-1 >= 0) { //left
          if (i-1 >= 0) { //left top
            lookAround(i-1, j-1);
            if (!tiles[i][j].up && j-2 >= 0) {//far left top
              lookAround(i-1, j-2);
            }
          }
          if (i+1 < boardHeight) { //left bottom
            lookAround(i+1, j-1);
            if (tiles[i][j].up && j-2 >= 0) { //far left bottom
              lookAround(i+1, j-2);
            }
          }
          lookAround(i, j-1); //left middle
          if (j-2 >= 0) {
            lookAround(i, j-2); //far left middle
          }
        }

        if (i-1 >= 0) {
          lookAround(i-1, j);  //top middle
        }
        if (i+1 < boardHeight) {
          lookAround(i+1, j); //bottom middle
        }

        if (j+1 < boardWidth) {
          if (i-1 >= 0) {
            lookAround(i-1, j+1); //top right
            if (!tiles[i][j].up && j+2 < boardWidth) { //far top right
              lookAround(i-1, j+2);
            }
          }
          if (i+1 < boardHeight) {
            lookAround(i+1, j+1); //bottom right
            if (tiles[i][j].up && j+2 < boardWidth) { //far bottom right
              lookAround(i+1, j+2);
            }
          }
          lookAround(i, j+1); // middle right
          if (j+2 < boardWidth) {
            lookAround(i, j+2); //far middle right
          }
        }
      }
    }
  }
}
