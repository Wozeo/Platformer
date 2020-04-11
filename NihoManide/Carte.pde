
//Carte
String carte[];
float tB = 30;
float camX = 0;
float camY = 0;
float xFin = 1220;
int nbBlocs = 14;
//-----------    0    1    2    3    4    5    6    7    8    9   10   11   12  13
char blocs[] = {' ', 'H', 'L', 'P', 'G', 'R', 'E', 'B', 'C', 'T', 'D', 'X', 'S','A'};//D -> 11
PImage Pblocs[] = new PImage[nbBlocs];
char blocInv[] = {' ', 'G', 'C','A'};
int largC, hautC;
int nbVarFinCarte = 1;

// Hauteur : 1 saut : (2-Large / 3-Serré)  2 sauts : (4-Large/5-Bien)          6-Impossible
// Largeur : 1 saut : (5-Bien  / 6-Serré)  2 sauts : (11-Bien/12-Très Serré)  13-Impossible

void importImage() {
  for (int i = 0; i < nbBlocs; i ++) {
    Pblocs[i] = loadImage("blocs/b"+blocs[i]+".png");
  }
  for(int i = 0; i < nbEnnemi ; i ++){
    Pennemi[i] = loadImage("ennemi/e"+enn[i]+".png");
  }
  PiPerso = loadImage("personnage/personnage.png");
}


void loadMap(int numCarte) {
  camX = 0;
  camY = 0;
  carte = loadStrings("Carte/"+numCarte+".txt");
  largC = carte[0].length();
  hautC = (carte.length);
  for(int i = 0; i < nbEnnCarte ; i ++){
    en[i].actif = false;
  }
  nbEnnCarte = 0;
  xJ = tB;
  yJ = tB;
  for(int i = 0; i < largC ; i ++){
    for(int j = 0; j < hautC-nbVarFinCarte ; j ++){
      if(carte[j].charAt(i) == 'A'){
        xJ = i*tB;
        yJ = j*tB-tB/2;
      }
    }
  }
  xFin = float(carte[hautC-nbVarFinCarte])*tB;
  
  xJI = xJ;
  yJI = yJ;
  loadEnnemis();
  
  xMa = largC*tB;
  xMi = 0;
  yMa = (hautC-2)*tB;
  yMi = 0;
  passEtat(4);
  
}


boolean estEnn(char c){
  boolean oui = false;
  for(int i = 0; i < nbEnnemi ; i ++){
    if(c == enn[i]){
      oui = true;
    }
  }
  return oui;
}


void defCam() {
  if ( camX > 0 && xJ < camX+(48*tB)*(0.33) ) { // gauche
    camX = (xJ)-(48*tB)*(0.33);
  }
  if ( (camX < (largC-49)*tB && xJ > camX+(48*tB)*(0.5-(1/10)) )) {//droite
    camX = (xJ)-(48*tB)*(0.5-(1/10));
  }
  
  if( camY > 0 && yJ < camY+(27*tB)*(0.33) ){//haut
    camY = (yJ)-(27*tB)*(0.33);
  }
  if( camY < (hautC-28-0.2)*tB && yJ > camY+(27*tB)*(0.5-(1/10)) ){//bas
    camY = (yJ)-(27*tB)*(0.5-(1/10));
  }
}


void sortieDeNiveau(int state) {
  passEtat(1);
}


void affMap() {
  defCam();

  int cXbl = int(camX/tB);
  int cYbl = int(camY/tB);
  int correctionX = 0,correctionY = 0;
  if (largC <= 48) {
    correctionX = -1;
  }
  if (hautC-nbVarFinCarte <= 27) {
    correctionY = -1;
  }
  for (int i = cXbl; i < 49+cXbl+correctionX; i ++) {// block : 30*30
    for (int j = cYbl; j < 28+cYbl+correctionY; j ++) {
      int nmB = numBloc(carte[j].charAt(i));
      image(Pblocs[nmB], (i)*(tB), (j)*(tB), (tB), (tB));
    }
  }
  stroke(255);
  line(r(xFin),0,r(xFin),r(hautC*tB));
}


int numBloc(char bloc) {
  int a = 0;
  while (bloc != blocs[a]) {
    a ++;
  }
  return a;
}


char blcCoo(float x, float y) {
  return carte[int(y/tB)].charAt(int(x/tB));
}
