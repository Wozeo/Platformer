int nbEnnemi = 1;
char enn [] = {'0'};
PImage Pennemi[] = new PImage[nbEnnemi];
int nbEnnCarte = 0;
enne en[] = new enne[666];


void loadEnnemis() {
  for (int i = 0; i < largC; i ++) {
    for (int j = 0; j < hautC-nbVarFinCarte; j ++) {
      if ( estEnn(carte[j].charAt(i)) == true) {

        en[nbEnnCarte] = new enne(i*tB, j*tB, (int(carte[j].charAt(i)))-48 );
        nbEnnCarte ++;

        String s = "";
        for (int k = 0; k < carte[j].length(); k ++) {
          if (k == i) {
            s += ' ';
          } else {
            s += carte[j].charAt(k);
          }
        }

        carte[j] = s;
      }
    }
  }
}


class enne {
  float x, y;
  int type = 0;
  boolean actif = true;
  boolean sG = false;
  float vE = 3;
  int vieEnn = 3;
  float lx = tB,ly = tB;
  enne(float xI, float yI, int t) {
    x = xI;
    y = yI;
    type = t;
  }

  void enneAff() {
    if (actif == true) {
      image(Pennemi[type], x, y, lx, ly);
    }
  }

  void degat(int degEnn) {
    vieEnn += degEnn;
    if (vieEnn <= 0) {
      actif = false;
    }
  }

  void deplaEnn() {
    switch(type) {
      case(0):
      if (sG) {
        if (contactBloc(blcCoo(x, y+tB*1.5)) == true) {
          sG = false;
        }
      } else {
        if (contactBloc(blcCoo(x+tB, y+tB*1.5)) == true) {
          sG = true;
        }
      }

      if (sG) {
        x -= vE;
      } else {
        x += vE;
      }
      break;
    }
  }
  void degats() {
    if (actif) {
      if ( x > xJ && x < xJ+tB && y > yJ && y < yJ+tB || x+tB > xJ && x+tB < xJ+tB && y > yJ && y < yJ+tB || x > xJ && x < xJ+tB && y+tB > yJ && y+tB < yJ+tB || x+tB > xJ && x+tB < xJ+tB && y+tB > yJ && y+tB < yJ+tB) {
        vie(-1);
      }
    }
  }
}
