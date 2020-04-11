
//Effets
ArrayList<nuageSaut> nuageS = new ArrayList<nuageSaut>();


class nuageSaut{
  float xn,yn;
  int temps = 0;
  
  int nbNuages = 20;
  float x[] = new float[nbNuages];
  float y[] = new float[nbNuages];
  float taille[] = new float[nbNuages];
  
  boolean actif = true;
  nuageSaut(float xi,float yi){
    xn = xi;yn = yi;  
    for(int i = 0; i < nbNuages ; i ++){
      x[i] = random(xn-tB,xn+tB);
      y[i] = random(yn-tB/2.0,yn);
      taille[i] = random(tB/8.0,tB/2.0);
    }
  }
  
  void aff(){
    if(actif){
      temps ++;
      noStroke();
      fill(255);
      for(int i = 0; i < nbNuages ; i ++){
        ellipse( (x[i]) ,(y[i]),(taille[i]*(1-temps/50.0)),(taille[i]*(1-temps/50.0)) );
      }
      if(temps >= 50){
        actif = false;
      }
    }
  }
  
}


void affichageEffets(){
  int tailleNuageSaut = nuageS.size();
  if(tailleNuageSaut > 0){
    for(nuageSaut nuageS : nuageS){
      nuageS.aff();
    }
  }
}
