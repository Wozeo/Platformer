

float angleSourisPerso = 0;
boolean armeDist = false;
armesDist arme = new armesDist(0);
armeCaC armeC = new armeCaC(0);
boolean enCoup = false;


class armeCaC {
  int type;
  float degat, tx, ty, txi, CDP, CDG, CDPI;
  int nCoups;
  int tc;

  boolean repos = false;
  int t1 = 0;
  int t2 = 0;
  int nCombo = 0;
  int tempsCoup = 100;

  armeCaC(int typeI) {
    type = typeI;
    switch(type) {
      case(0):
      degat = 1;
      txi = 75;
      tx = txi;
      ty = 20;
      CDP = 10;
      CDPI = 30;
      CDG = 50;
      nCoups = 3;
      tc = 5;
      break;
    }
  }

  void ut() {
    if (enCoup == false) {
      if (droite) {
        tx = txi;
      } else {
        tx = -txi;
      }
    }
    if (repos) {
      if (mousePressed && t2 > CDG) {
        repos = false;
        t2 = 0;
        nCombo = 0;
      }
    } else {
      if (mousePressed && t1 > CDP) {
        t1 = 0;
        nCombo ++;
        if (nCombo >= nCoups) {
          repos = true;
          t2 = 0;
        }
        donneCoup();
      }
    }

    if (tempsCoup < tc) {
      enCoup = true;
      coup();
      tempsCoup ++;
    } else if (tempsCoup <= tc) {
      enCoup = false;
      tempsCoup ++;
    } else {
      enCoup = false;
    }

    if (t1 <= CDP) {
      t1 ++;
    }
    if (t2 <= CDG) {
      t2 ++;
    }
  }

  void coup() {
    pushStyle();
    noStroke();
    fill( 255*(tc-tempsCoup)/tc );
    rect(xJ+tB/2, yJ+tB*1.5/2, tx, ty);
    popStyle();
  }

  void donneCoup() {
    tempsCoup = 0;
    if (nbEnnCarte > 0) {
      for (int i = 0; i < nbEnnCarte; i ++) {
        float xE = en[i].x;
        float yE = en[i].y;
        float lxE = en[i].lx;
        float lyE = en[i].ly;
        boolean toucher = false;
        for (float xP = (xJ+tB/2); xP <= xJ+tB/2+tx; xP += tx/5.0) {
          for (float yP = yJ+tB*1.5/2; yP <= yJ+tB*1.5/2+ty; yP +=ty/3.0) {
            if (xP > xE && xP < xE+lxE && yP > yE && yP < yE+lyE) {
              toucher = true;
            }
          }
        }
        if (toucher) {
          en[i].degat(int(-degat));
        }
      }
    }
  }
}


class armesDist {
  int type;
  float CD, degats, tailleMis, typeMis, vitesseMis, imprecision;
  float tx, ty;

  //ArrayList<missile> missiles = new ArrayList<missile>();
  missile missiles[] = new missile[100];
  int nbMissile = 0;
  boolean depasse = false;

  armesDist(int typeArme) {
    type = typeArme;
    switch(type) {
      case(0):
      CD = 10;
      degats = 10;
      tailleMis = 10;
      typeMis = 0;
      tx = 30;
      ty = 10;
      vitesseMis = 25;
      imprecision = radians(2);
      break;
    }
  }

  int temps = 0;

  void Utilisation() {
    //affichage :

    pushMatrix();
    translate(xJ+tB/2.0, yJ+tB/2.0);
    rotate(angleSourisPerso);

    noStroke();
    fill(88);
    rect(0, -ty/2.0, tx, ty);

    popMatrix();
    if (temps >= CD && mousePressed == true) {
      temps = 0;
      missiles[nbMissile] = new missile(xJ+tB/2.0+tx*cos(angleSourisPerso), yJ+tB/2.0+tx*sin(angleSourisPerso), angleSourisPerso+random(-imprecision, imprecision), degats, tailleMis, vitesseMis);
      nbMissile ++;
      if (nbMissile >= 100) {
        nbMissile = 0;
        depasse = true;
      }
    }
    temps ++;

    if (depasse) {
      for (int i = 0; i < 100; i ++) {
        missiles[i].deplaff();
      }
    } else if (nbMissile > 0) {
      for (int i = 0; i < nbMissile; i ++) {
        missiles[i].deplaff();
      }
    }
  }
}


boolean contactCircle(float x, float y, float r, float x2, float y2) {
  boolean a = false;
  if ( (x-x2)*(x-x2)+(y-y2)*(y-y2) <= r*r) {
    a = true;
  }
  return a;
}


class missile {

  float pxm, pym, xm, ym, angle, vitesse, degats, dimension;
  boolean actif = true;

  missile(float xi, float yi, float angleI, float degat, float dimensionI, float vitesseI) {
    xm = xi;
    ym = yi;
    pxm = xm;
    pym = ym;
    angle = angleI;
    degats = degat;
    dimension = dimensionI;
    vitesse = vitesseI;
  }

  void deplaff() {
    if (actif) {
      //deplacement
      pxm = xm;
      pym = ym;
      xm += vitesse*cos(angle);
      ym += vitesse*sin(angle);

      if (xm > largC*tB || xm < 0 || ym < 0 || ym > hautC*tB) {
        actif = false;
      }

      if (contactBloc(blcCoo(xm, ym)) == false) {
        actif = false;
      }

      if (actif) {
        for (int i = 0; i < nbEnnCarte; i ++) {
          if (xm+dimension > en[i].x && xm-dimension < en[i].x+tB && ym+dimension > en[i].y && ym-dimension < en[i].x+tB) {
            en[i].degat(-1);
            actif = false;
          }
        }
        if (actif) {
          //affichage
          noStroke();
          fill(235, 20, 20);
          ellipse(xm, ym, dimension, dimension);
        }
      }
    }
  }
}


float angle(float x1, float y1, float x2, float y2) {
  return atan2(y2-y1, x2-x1);
}
