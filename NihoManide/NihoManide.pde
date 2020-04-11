

//Fenetre
int LargEcran = 1366, HautEcran = 768;//1920,1080
boolean scale = true;

//Menu
int etat = 0; //0 = Ecran d'acceuil ; 1 = Panneau de niveau ; 2 = Paramètre ; 3 = Credit ; 4 = Jeu ; 5 = Pause
int paraRetour = 0;

//Visuel
color couleurFinalLimite = 120;
float angleMeteor = random(PI/4.0-0.09, PI/4.0+0.09);
color backcolor = color(random(0, 10), random(0, 10), random(0, 10));
int nMeteor = int(random(4, 10));
float meteorCoo[][] = new float[nMeteor][7];//x,y,vd,d,r,v,b
int diamMeteor[] = {5, 12};
PImage fond0;
int nBulle = 20;
float bulle[][] = new float [nBulle][7];
PImage fondPara;
long seedLiane;
float noiseSound = 1;


void setup() {
  fullScreen(P3D);
  tB = r(40);
  LargEcran = width;
  HautEcran = height;
  importImage();

  for (int i = 0; i < nMeteor; i ++) {
    defMeteor(i, true);
  }
  for (int i = 0; i < 7; i ++) {//x,y,lx,ly,Dtxt,etat,txt,corX,test,effet,color
    for (int j = 0; j < 4; j ++) {//rect(r(70+(220+40)*i+(220-txMenu)/2.0), r(80+(200+40)*j+(200-tyMenu)/2.0), r(txMenu), r(tyMenu), 7);
      color cB = color(50, 175-(i)*45/6.0, 80-70/6.0);
      switch(j) {
        case(0):
        cB = color(50, 175-(i)*45/6.0, 80-70/6.0);//vert 50 130 10
        break;
        case(1):
        cB = color(70-(i)*50/6.0, 95-(i)*50/6.0, 240-90/6.0);//bleu 20,45,150
        break;
        case(2):
        cB = color(250-(i)*40/6.0, 110-(i)*80/6.0, 30);//rouge 210 30 30
        break;
        case(3):
        cB = color(50-i*40/6.0);//noir
        break;
      }
      boutonsNv[j*7+i] = new bouton(50+(220+40)*i+(220-txMenu)/2.0, 80+(200+40)*j+(200-tyMenu)/2.0, txMenu, tyMenu, 30, 1, str(j*7+i+1), 0, false, 4+j*7+i, cB);
    }
  }
}


void draw() {
  //println(frameRate);
  if (scale == true) {
    pushMatrix();
    scale(width/1920.0);

    switch(etat) {
      case(0):
      pushStyle();
      aff0();
      popStyle();
      break;

      case(1):
      pushStyle();
      aff1();
      popStyle();
      break;

      case(2):
      pushStyle();
      aff2();
      popStyle();
      break;

      case(3):
      pushStyle();
      aff3();
      popStyle();
      break;

      case(4):
      pushStyle();
      aff4();
      popStyle();
      break;

      case(5):
      pushStyle();
      aff5();
      popStyle();
      break;
    }
    if (nBouton > 0) {
      for (int i = 0; i < nBouton; i ++) {
        boutons[i].animationB();
        boutons[i].affichageB();
      }
    }
    popMatrix();
  }
  mouseClicked = false;
}


float r(float x) {
  float a = x*width/1920.0;
  if (scale == true) {
    a = x;
  }
  return a;
}


float rS(float x) {
  return x*width/1920.0;
}


float rSi(float x) {
  return x*1920.0/width;
}


void aff0() {
  background(230);
  fondAff0();
}


void aff1() {
  image(fond0, 0, 0, 1920, 1080);
  for (int i = 0; i < 28; i ++) {
    boutonsNv[i].animationB();
    boutonsNv[i].affichageB();
  }
}


void aff2() {
  fondAff0();
  fill(150);
  textSize(r(50));
  text("Paramètre", r(830), r(100));
}


void aff3() {
  fondAff0();

  textSize(r(50));
  fill(150);
  stroke(0);
  text("Crédit", r(840), r(100));

}


void aff4() {
  background(50, 50, 220);
  pushMatrix();
  translate(r(-camX), r(-camY));
  affMap();
  affHUD();
  angleSourisPerso = angle(xJ-camX, yJ-camY, rSi(mouseX), rSi(mouseY));
  if (armeDist) {
    arme.Utilisation();
  }
  armeC.ut();
  affPerso();
  for (int i = 0; i < nbEnnCarte; i ++) {
    en[i].deplaEnn();
    en[i].enneAff();
    en[i].degats();
  }

  affichageEffets();

  popMatrix();
  detectColli();
  deplaPerso();
  detectePique();
  collisions();
  testFin();
}


void aff5() {
  pushMatrix();
  scale(1920.0/width);
  image(fondPara, 0, 0, width, height);
  popMatrix();
}


void affHUD() {
  textSize(30);
  fill(0);
  text("Vie : "+vie, 20+camX, 50+camY);
}


void bulles() {
  for (int i = 0; i < bulle.length; i ++) {
    float tBulle = bulle[i][0];
    float xBulle = bulle[i][1];
    float yBulle = bulle[i][2];
    strokeWeight(5);
    stroke(bulle[i][3], 120);
    fill(bulle[i][4], bulle[i][5], bulle[i][6]);
    ellipse(xBulle, yBulle, tBulle, tBulle);
  }
}


void defBulles(float xMin, float xMax, float yMin, float yMax, int nBulles) {
  for (int i = 0; i < nBulles; i ++) {
    bulle[i][0] = random(30, 120);
    bulle[i][1] = random(bulle[i][0]+xMin, xMax-bulle[i][0]);
    bulle[i][2] = random(bulle[i][0]+yMin, yMax-bulle[i][0]);
    bulle[i][3] = random(235, 255);
    bulle[i][4] = random(60, 80);
    bulle[i][5] = random(80, 110);
    bulle[i][6] = random(230, 255);
  }
}


void passEtat(int sta) {
  if (sta == 1) {

    pushMatrix();
    if (etat == 0 || etat == 5) {
      scale(1920.0/width);
    }
    defBulles(-50, 1920+50, 1080/4.0, 1080/2.0, nBulle);
    seedLiane = int(random(0, 10000));
    getFond(etat);
    popMatrix();
  } else if (sta == 0) {
    backcolor = color(random(0, 10), random(0, 10), random(0, 10));
    angleMeteor = random(PI/4.0-0.09, PI/4.0+0.09);
    nMeteor = int(random(4, 10));
    meteorCoo = new float[nMeteor][7];
    for (int i = 0; i < nMeteor; i ++) {
      defMeteor(i, true);
    }
  }

  etat = sta;
}


void liane(float yminl, float ymaxl, float tl, long seed) {
  noiseSeed(seed);
  for (int i = 0; i < 1920; i ++) {
    noStroke();
    fill(50, 130, 10);
    ellipse(i, yminl+(ymaxl-yminl)*noise(i*noiseSound), tl, tl);
  }
}


void getFond(int etat) {
  pushMatrix();
  if (etat != 4) {
    scale(width/1920.0);
  }
  background(230);
  noStroke();

  //Fond
  fill(50, 175, 80);//vert
  rect(0, 0, 1920, 1080/4);
  fill(70, 95, 240);//bleu
  rect(0, 1080/4, 1920, 1080/4);
  fill(250, 110, 30);//rouge
  rect(0, 2*1080/4, 1920, 1080/4);
  fill(50);//noir
  rect(0, 3*1080/4, 1920, 1080/4);

  //Decor de fond
  bulles();
  liane(0, 270, 25, seedLiane);
  feu(1080/2.0, 3*1080/4.0);
  yeux(3*1080/4.0, 1080);
  fond0 = get();
  popMatrix();
}


void feu(float yMi, float yMa) {
  //def
  float tBase = 25;
  int nPart = int(random(1920/60.0, 1920/55.0));
  int nLevel = int((yMa-yMi)/4);
  float particules[][][] = new float [nLevel][nPart][3];//x,y,taille
  color coulPart[][] = new color[nLevel][nPart];
  float tRedu = (tBase)/float(nLevel);
  for (int i = 0; i < nLevel; i ++) {
    for (int j = 0; j < nPart; j ++) {
      particules[i][j][0] = random(0, 1920);
      particules[i][j][1] = yMa-80*tRedu;
      particules[i][j][2] = tBase;
      coulPart[i][j] = color(240, random(10, 140), 10);
      if (i > 0) {
        for (int k = 0; k < i; k ++) {
          particules[i][j][1] -= 3;
          particules[i][j][2] -= tRedu;
        }
      }
    }
  }
  for (int i = 0; i < nLevel; i ++) {
    for (int j = 0; j < nPart; j ++) {
      float x = particules[i][j][0];
      float y = particules[i][j][1];
      float t = particules[i][j][2];
      noStroke();
      fill(coulPart[i][j]);
      quad(x-t/2.0, y, x, y-t, x+t/2.0, y, x, y+t);
    }
  }
}


void yeux(float yMin, float yMax) {
  int nbYeux = int(random(2, 12));
  //float yeux[][] = new float [nbYeux][4];//x,y,ty,tp
  for (int i = 0; i < nbYeux; i ++) {
    float ty = random(20, 40);
    float ecart = ty/3;
    float tp = random(3, 5);
    float x = random(ty+ecart, 1920-ty-ecart);
    float y = random(yMin+ty, yMax-ty);
    noStroke();
    fill(255);
    ellipse(x+ecart/2.0+ty/2.0, y, ty, ty/2.0);
    ellipse(x-ecart/2.0-ty/2.0, y, ty, ty/2.0);

    fill(220, 30, 30);
    ellipse(x+ecart/2.0+ty/2.0, y, tp, tp);
    ellipse(x-ecart/2.0-ty/2.0, y, tp, tp);
  }
}


void fondAff0() {
  background(backcolor);
  deplaMeteor();
}


void defMeteor(int i, boolean start) {
  if (start) {
    meteorCoo[i][0] = random(1920*0.06-1920/2.0, 1920*0.85);
    meteorCoo[i][1] = random(1080*0.35-1080, 1080*0.96);
  } else {
    meteorCoo[i][0] = random(1920*0.06, 1920*0.85)-1920/2.0;
    meteorCoo[i][1] = random(1080*0.35, 1080*0.96)-1080;
  }

  float tpass = sqrt(meteorCoo[i][0]*meteorCoo[i][0]+meteorCoo[i][1]*meteorCoo[i][1]);
  meteorCoo[i][2] = random(5, 10);
  meteorCoo[i][3] = random(tpass/2.5, tpass/1.25);
  meteorCoo[i][4] = random(couleurFinalLimite, 255);
  meteorCoo[i][5] = random(couleurFinalLimite, 255);
  meteorCoo[i][6] = random(couleurFinalLimite, 255);
}


void deplaMeteor() {
  pushMatrix();
  //scale(1920/width);
  for (int i = 0; i < nMeteor; i ++) {
    gradient(meteorCoo[i][0]-cos(angleMeteor)*meteorCoo[i][3], meteorCoo[i][1]-sin(angleMeteor)*meteorCoo[i][3], meteorCoo[i][0], meteorCoo[i][1], random(diamMeteor[0], diamMeteor[1]), backcolor, color(meteorCoo[i][4], meteorCoo[i][5], meteorCoo[i][6]) );
    meteorCoo[i][0] += cos(angleMeteor)*meteorCoo[i][2];
    meteorCoo[i][1] += sin(angleMeteor)*meteorCoo[i][2];
    if (meteorCoo[i][0]-cos(angleMeteor)*meteorCoo[i][3] > 1920 ||meteorCoo[i][1]-sin(angleMeteor)*meteorCoo[i][3] > 1080) {
      defMeteor(i, false);
    }
  }
  popMatrix();
}


void gradient(float x, float y, float xf, float yf, float diam, color base, color fin) {

  float taille = sqrt((x-xf)*(x-xf)+(y-yf)*(y-yf));
  float coef = 2;
  int n = int((int(taille)+1)/coef);
  float tx = (xf-x)/(n-1);
  float ty = (yf-y)/(n-1);

  for (int i = 0; i < n; i += coef) {
    noStroke();
    color c = lerpColor(base, fin, float(i)/n);

    fill(c);
    ellipse(x+i*tx, y+i*ty, diam, diam);
  }
}
