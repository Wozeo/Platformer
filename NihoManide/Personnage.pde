
//Personnage
float xJ, yJ, xJI, yJI;
boolean touches[] = new boolean[256];
float vitJ = 5;
float xMa, xMi, yMa, yMi;
boolean sol = false, plafond = false;
float vS = 0, grav = 0.4;
char lbt = ' ';//last bloc touch
int tapisRoulant = 0;
int vieDep = 10;
int vie = vieDep;
boolean invincibilite = false;
boolean doubleSaut = false;
boolean attRelach = false;
int t = 0;
PImage PiPerso;
boolean droite = true;


void affPerso() {
  if (invincibilite == true) {
    t ++;
    if (t > 120) {
      t = 0;
      invincibilite = false;
    }
  }
  if (t%2 == 0) {
    image(PiPerso, xJ, yJ, tB, 1.5*tB);
  }
}


void deplaPerso() {
  if (touches[65] || touches[37]) {//q gauche
    xJ -= vitJ;
    droite = false;
  }
  if (touches[68] || touches[39]) {//d droite
    xJ += vitJ;
    droite = true;
  }
  if (touches[32] && sol == true && lbt != 'T') {
    vS = 9;
    attRelach = true;
  } else if (touches[32] && doubleSaut == true && sol == false && attRelach == false) {
    doubleSaut = false;
    vS = 9;
    nuageS.add(new nuageSaut(xJ+tB/2, yJ+2*tB));
  }

  if (attRelach == true && touches[32] == false) {
    attRelach = false;
  }

  if (doubleSaut == false && sol == true) {
    doubleSaut = true;
  }


  if (tapisRoulant != 0) {
    xJ += tapisRoulant*vitJ*1.2;
  }

  if ((sol == true && vS < 0)|| plafond == true && vS > 0) {//
    vS = 0;
    plafond = false;
    sol = false;
  }

  if (vS > -19) {
    vS -= grav;
  }
  yJ -= vS;
}


void keyPressed() {
  //println(keyCode);
  touches[keyCode] = true;
  if (keyCode == 80) {
    if (etat == 4) {
      fondPara = get();
      passEtat(5);
    } else if (etat == 5) {
      passEtat(4);
    }
  }
}


void keyReleased() {
  touches[keyCode] = false;
}


void collisions() {
  if (yJ > yMa) {
    yJ = yMa;
    sol = true;
  }
  if (yJ < yMi) {
    yJ = yMi;
    plafond = true;
  }
  if (xJ > xMa) {
    xJ = xMa;
  }
  if (xJ < xMi) {
    xJ = xMi;
  }
}


void testFin() {
  if (xJ >= xFin) {
    passEtat(1);
  }
}


void mort() {
  xJ = xJI;
  yJ = yJI;
  vS = 0;
  camX = 0;
  camY = 0;
  invincibilite = false;
  doubleSaut = false;
  vie = vieDep;
}


void testBas(char b) {
  vitJ = 5;
  switch(b) {
    case('T'):
    vS = 12.5;
    break;

    case('L'):
    mort();
    break;

    case('D'):
    tapisRoulant = 1;
    break;

    case('X'):
    tapisRoulant = -1;
    break;

    case('E'):
    vitJ = 2.5;
    break;
  }
  lbt = b;
}


void detectColli() {
  tapisRoulant = 0;
  boolean oui = false;
  int blocTouch[] = new int[nbBlocs];

  if (xJ%tB == 0) {//bas
    char bloc = blcCoo(xJ+0.5*tB, yJ+2*tB-tB/4);
    if (contactBloc(bloc) == false) {
      oui = true;
    }
    testBas(bloc);
    blocTouch[numBloc(bloc)] += 1;
  } else {
    char bloc = blcCoo(xJ, yJ+2*tB);
    char bloc2 = blcCoo(xJ+tB, yJ+2*tB-tB/4);
    if (contactBloc(bloc) == false || contactBloc(bloc2) == false) {
      oui = true;
    }
    testBas(bloc);
    testBas(bloc2);
    blocTouch[numBloc(bloc)] += 1;
    blocTouch[numBloc(bloc2)] += 1;
  }
  if (oui  == true) {
    yMa = (int(yJ/tB))*tB+tB/2;
  } else {
    yMa = (hautC-2)*tB;
    sol = false;
  }


  oui = false;
  if (xJ%tB == 0) {//haut
    char bloc = blcCoo(xJ+0.5*tB, yJ-tB);
    if (contactBloc(bloc)  == false) {
      oui = true;
    }
    blocTouch[numBloc(bloc)] += 1;
  } else {
    char bloc = blcCoo(xJ, yJ-tB);
    char bloc2 = blcCoo(xJ+tB, yJ-tB);
    if (contactBloc(bloc) == false || contactBloc(bloc2) == false) {
      oui = true;
    }
    blocTouch[numBloc(bloc)] += 1;
    blocTouch[numBloc(bloc2)] += 1;
  }
  if (oui  == true) {
    yMi = (int(yJ/tB))*tB;
  } else {
    yMi = 0;
    plafond = false;
  }


  oui = false;
  char bloc = blcCoo(xJ-0.5*tB, yJ+tB);
  char bloc2 = blcCoo(xJ-0.5*tB, yJ);
  if (contactBloc(bloc) == false || contactBloc(bloc2) == false) { // gauche
    oui = true;
  }
  if (oui  == true) {
    xMi = (int((xJ-tB/2)/tB)+1)*tB;
  } else {
    xMi = 0;
  }
  blocTouch[numBloc(bloc)] += 1;
  blocTouch[numBloc(bloc2)] += 1;

  oui = false;
  char bloc3 = blcCoo(xJ+1.5*tB, yJ+tB);
  char bloc4 = blcCoo(xJ+1.5*tB, yJ);
  if (contactBloc(bloc3) == false || contactBloc(bloc4) == false) {
    oui = true;
  }
  if (oui  == true) {
    xMa = (int((xJ-tB/2)/tB)+1)*tB;
  } else {
    xMa = largC*tB;
  }
  blocTouch[numBloc(bloc3)] += 1;
  blocTouch[numBloc(bloc4)] += 1;

  testContactBloc(blocTouch);
}


void vie(int pvD) {
  if (invincibilite == false) {
    vie += pvD;
    invincibilite = true;
    if (vie <= 0) {
      mort();
    }
  }
}


void testContactBloc(int liste[]) {
  if (liste[3] > 0) {
    //vie(-1);
  }
}


void detectePique() {
  if ( estPique(xJ+0.5*tB, yJ) || estPique(xJ+0.5*tB, yJ+1.5*tB)|| estPique(xJ, yJ+0.25*tB)|| estPique(xJ, yJ+1.25*tB)|| estPique(xJ+tB, yJ+0.25*tB)|| estPique(xJ+tB, yJ+1.25*tB) ) {//xJ+1.5*tB, yJ+tB
    vie(-1);
  }
}


boolean estPique(float x, float y) {
  boolean a = false;
  if (blcCoo(x, y) == blocs[3]) {
    a = true;
  }
  return a;
}


boolean contactBloc(char b) {
  boolean oui = false;
  for (int i = 0; i  < blocInv.length; i ++) {
    if (b == blocInv[i]) {
      oui = true;
    }
  }
  return oui;
}
