
//Menu
int nBouton = 10;             
bouton boutons[] = {//x,y,lx,ly,Dtxt,etat,txt,corX,test,effet,color
  new bouton(0, 0, -1, -1, 40, 1, "Retour", 0, false, 0, color(50)), 
  new bouton(50, 150, 570, 150, 50, 0, "Niveaux", 0, false, 1, color(50)), 
  new bouton(1240, 150, 570, 150, 50, 0, "Crédit", 0, false, 2, color(50)), 
  new bouton(620, 700, 570, 150, 50, 0, "Paramètre", 0, false, 3, color(50)), 
  new bouton(0, 0, -1, -1, 40, 2, "Retour", 0, false, 31, color(50)), 
  new bouton(0, 0, -1, -1, 40, 3, "Retour", 0, false, 32, color(50)), 

  new bouton(810, 300, 300, 100, 35, 5, "Reprendre", 0, false, 33, color(50)), 
  new bouton(810, 500, 300, 100, 35, 5, "Menu", 0, false, 34, color(50)), 
  new bouton(810, 700, 300, 100, 35, 5, "Paramètre", 0, false, 35, color(50)),
  
  new bouton(1720, 1010, 200, 70, 40, 0, "Quitter", 0, false, 36, color(50))
};
bouton boutonsNv[] = new bouton[28];


class bouton {
  float xB, yB, dimTxtB, corrXB;
  int etatB, effetB;
  String texteB;
  boolean testB;
  color contour = color(240, 245, 40);
  color fondB;
  float lxB, lyB;

  bouton(float xBI, float yBI, float lxBI, float lyBI, float dimTxtBI, int etatBI, String texteBI, float corrXBI, boolean testBI, int effetBI, color fondBI) {
    xB = xBI;
    yB = yBI;
    etatB = etatBI;
    texteB = texteBI;
    dimTxtB = dimTxtBI;
    corrXB = corrXBI;
    testB = testBI;
    effetB = effetBI;
    fondB = fondBI;
    lxB = lxBI;
    lyB = lyBI;
    if (lxB < 0) {
      lxB = (texteB.length()+1)*dimTxtB/1.5-corrXB;
    }
    if (lyB < 0) {
      lyB =  dimTxtB*2;
    }
  }

  void affichageB() {
    if (etat == etatB) {

      pushStyle();
      strokeCap(ROUND);
      strokeWeight(r(dimTxtB/8));
      stroke(contour);
      fill(fondB);
      if (testB) {
        rect(r(xB+(mouseX-width/2)), r(yB+(mouseY-height/2)), r(lxB), r(lyB));
        println(mouseX-width/2, mouseY-height/2);
      } else {
        rect(r(xB), r(yB), r(lxB), r(lyB));
      }
      popStyle();

      pushStyle();
      noStroke();
      fill(255);
      textSize(r(dimTxtB));
      if (testB) {
        text(texteB, r(xB+dimTxtB/1.6+(mouseX-width/2)+(lxB-((texteB.length()+1)*dimTxtB/1.5-corrXB))/2), r(yB+1.5*dimTxtB+(mouseY-height/2)+(lyB-dimTxtB*2)/2));
      } else {
        text(texteB, r(xB+dimTxtB/1.6+(lxB-((texteB.length()+1)*dimTxtB/1.5-corrXB))/2), r(yB+1.5*dimTxtB+(lyB-dimTxtB*2)/2) );
      }
      popStyle();
    }
  }

  void animationB() {
    if (etat == etatB) {
      if (mouseX > rS(xB) && mouseX < rS(xB+lxB) && mouseY > rS(yB) && mouseY < rS(yB+lyB)) {
        contour = color(130, 80, 40);
        if (mouseClicked) {
          effetBouton(effetB);
        }
      } else {
        contour = color(240, 245, 40);
      }
    }
  }
}


void effetBouton(int i) {
  if (i > 3 && i < 28+3) {
    loadMap(i-3);
  } else {
    switch(i) {
      case(0)://Retour menu 1
      passEtat(0);
      break;
      case(1):
      passEtat(1);
      break;
      case(2):
      passEtat(3);
      break;
      case(3):
      passEtat(2);
      paraRetour = 0;
      break;
      case(31):
      passEtat(paraRetour);
      break;
      case(32):
      passEtat(0);
      break;
      case(33):
      passEtat(4);
      break;
      case(34):
      sortieDeNiveau(0);
      break;
      case(35):
      passEtat(2);
      paraRetour = 5;
      break;
      case(36):
      exit();
      break;
    }
  }
}
