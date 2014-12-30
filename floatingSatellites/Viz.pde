
// DUBAI RADAR

//var to interpolate the sats 2d position
float xxN;
float yyN;
float xxT;
float yyT;

float pisca = 0;
float theta=0;

void led(){
 
 pisca=map(sin(theta),-1,1,40,255);
 // With each cycle, increment theta
  theta += 0.5; 
  
 // fill(pisca);
  //ellipse(20,20,300,300);
  
}

void sequencer() {

  //size of the box
  int w=300;
  int h=400;

  //Fazer caixilho 
  pushMatrix();
  translate(width-w-10, 0);

  //centrar ao meio
  translate(w/2, h/2);
  //titulo Dubai + coordenadas
  textSize(10);
  fill(255);
  text(" DUBAI | 24.57N / 55.20E ", -60, -((w/2)+10));

  //ciruclo radar
  stroke(255);
  fill(25, 200);
  ellipse(0, 0, w-20, w-20);

  //lihha vertical
  stroke(200);
  //line(0,(w/2)-10,0,-((w/2)-10));
  for (int k=10; k< (w)-10; k=k+10) {
    point (0, k-(w/2));
  }

  //ponto Dubai
  noStroke();
  fill(255);
  ellipse(0, map(25, -90, 90, (w/2)-10, -((w/2)-10)), 15, 15);
  //text(int(degrees(Sat[0].lattN))+"  "+(degrees(Sat[0].lnggN)),20,20);
  float xx=0;
  float yy=0;
  // percorre todos os sats usa os lat /lng em graus para os colocar num espaço 2d. tipo radar.
  for (int i=0; i<satList.length; i++) {
    //Só o faz se está activo
    if (Sat[i].active==true) {

      xxN=-(degrees(Sat[i].lnggN)-52);
      yyN=-(degrees(Sat[i].lattN));

      xxT=-(degrees(Sat[i].lnggT)-52);
      yyT=-(degrees(Sat[i].lattT));

      //se está dentro da area do radar pinta a bolinha
      if (xxT<(w/2)-30 && xxT>-((w/2)-30)) {
        xx=lerp(xxT, xxN, Sat[i].inter);
        yy=lerp(yyT, yyN, Sat[i].inter);
        xx=xx-(52/2);

        yy=map(yy, 90, -90, (w/2)-10, -((w/2)-10));
        xx=map(xx, 180, -180, (w/2)-10, -((w/2)-10));

        ellipse(xx, yy, 5, 5);
      }
      //se está a tocar faz uma linha a ligar
      if (Sat[i].satPlay==true) {

        stroke(255);
        // line(xx,yy,0,0);
        line(xx, yy, 0, yy);
      }
    }
  }

  popMatrix();
}

void satlisting() {

  // text("NUMBER OF SATELLITES: "+ satList.length,30,30);
  for (int i=0; i<satList.length; i++) {
    textSize(10);
    fill(255);
    if (Sat[i].active==false) fill(20);

    String catName = " ";
    if (Sat[i].cat==0)catName="SPACE STATION";
    if (Sat[i].cat==1)catName="EARTH SCIENCE";
    if (Sat[i].cat==2)catName="COSMOS SCIENCE";
    if (Sat[i].cat==3)catName="OTHER";


    //if(Sat[i].active==false)fill(180);
    //text( i+" "+satList[i]+" | "+int(degrees(Sat[i].lattN))+"º / "+int(degrees(Sat[i].lnggN))+"º / "+int(degrees(Sat[i].alttN))+"km", 30,30+((i+1)*15));
    text( i+" "+satList[i]+" | "+int(degrees(Sat[i].lattN))+"º / "+int(degrees(Sat[i].lnggN))+"º  |  "+ catName, 30, 30+((i+1)*15));

    noStroke();
    if (Sat[i].satPlay==true)fill(255);
    if (Sat[i].satPlay==false)fill(255, 70);

    ellipse(20, 26+((i+1)*15), 8, 8);
    //text( degrees(Sat[i].latt)+" "+degrees(Sat[i].lngg), 140,30+((i+1)*15));
  }
}


// timeline display
void timeline () {

  //size of the box
  //int w=900;
  int w=width-40;
  int h=80;

  pushMatrix();
  translate(20, height-100);

  stroke(200);
  line(0, 0, w, 0);

  rectMode(CORNER);
  fill(25, 200);
  noStroke();
  rect(0, 0, w, h);

  noStroke();
  fill(50);
  // real time bar bse
  rect(10, 37, w-20, 10);
  // app time bar base
  rect(10, 65, w-20, 10);
  fill(255);
  textSize(10);
  //legenda
  text("REAL TIME - "+hour()+" : "+minute(), 10, 33);
  text("VIRTUAL TIME - "+currentHour+" : "+currentMinute, 10, 61);


  // time bars interactive
  fill(100);
  // adapting the bar to the time status
  float barCT=int(map(hour(), 0, 23, 0, w-20));
  float barVT=int(map(currentHour, 0, 23, 0, w-20));
  rect(10, 37, barCT, 10);
  rect(10, 65, barVT, 10);

  // drawing little smallbars
  stroke(155);
  int barss=(w-20)/6;
  for (int i=10; i<= (w-20); i=i+barss) {
    if (i!=10)line(i+10, 37, i+10, 47);
    if (i!=10)line(i+10, 65, i+10, 75);
  }

  //draw bars
  popMatrix();
}



void Vizz() {

  for (int i=0; i<satList.length; i++) {  
    //println(Sat[i].active);
    noStroke();
    if (Sat[i].active && Sat[i].satPlay) {
      beginShape();
      //fill(55,100,150, 10);
      fill(Sat[i].colour);
      vertex(Sat[i].x, Sat[i].y, Sat[i].z);
      fill(0, 150);
      vertex(dubaiPos.x, dubaiPos.y, dubaiPos.z); 
      fill(0, 150);
      vertex(0, 0, 0); 
      endShape(CLOSE);
    }

    if (Sat[i].active && Sat[i].satPlay==false) {
      beginShape();

      fill(255, 20);
      stroke(255);
      vertex(Sat[i].x, Sat[i].y, Sat[i].z);
      vertex(0, 0, 0);
      endShape(CLOSE);
      line(Sat[i].x, Sat[i].y, Sat[i].z, 0, 0, 0);
      /*
beginShape();
       fill(255,50);
       vertex(Sat[i].x, Sat[i].y, Sat[i].z);
       fill(255,0);
       vertex(dubaiPos.x,dubaiPos.y, dubaiPos.z); 
       fill(255,0);
       vertex(0,0,0); 
       endShape(CLOSE);
       */
    }
  }
}




/////////
//MODE 3 RADAR
void radarMode() {

  //size of the box
  int w=int(width*0.5);
  int h=int(height*0.5);

  //Fazer caixilho 
  pushMatrix();
  translate(0, 0);

  //centrar ao meio
  translate(width/2, height/2);
  
  
  
  
  
  //titulo Dubai + coordenadas
  textSize(10);
  fill(255);
  text(" DUBAI | 24.57N / 55.20E ", -60, -((w/2)+10));

  //ciruclo radar
  stroke(255);
  fill(25, 200);
  ellipse(0, 0, w-20, w-20);

  //lihha vertical
  stroke(200);
  //line(0,(w/2)-10,0,-((w/2)-10));
  for (int k=10; k< (w)-10; k=k+10) {
    point (0, k-(w/2));
  }

  //ponto Dubai
  noStroke();
  fill(255);
  ellipse(0, map(25, -90, 90, (width/2)-10, -((width/2)-10)), 15, 15);
  //text(int(degrees(Sat[0].lattN))+"  "+(degrees(Sat[0].lnggN)),20,20);
  float xx=0;
  float yy=0;
  // percorre todos os sats usa os lat /lng em graus para os colocar num espaço 2d. tipo radar.
  for (int i=0; i<satList.length; i++) {
    
  
    
    //Só o faz se está activo
    if (Sat[i].active==true) {

      xxN=-(degrees(Sat[i].lnggN)-52);
      yyN=-(degrees(Sat[i].lattN));

      xxT=-(degrees(Sat[i].lnggT)-52);
      yyT=-(degrees(Sat[i].lattT));

      //se está dentro da area do radar pinta a bolinha
     // if (xxT<(w/2)-200 && xxT>-((w/2)-200)) {
       if (dist(xxT,yyT,0,0)<90) {
        xx=lerp(xxT, xxN, Sat[i].inter);
        yy=lerp(yyT, yyN, Sat[i].inter);
        xx=xx-(52/2);

        yy=map(yy, 90, -90, (w/2)-10, -((w/2)-10));
        xx=map(xx, 180, -180, (w/2)-10, -((w/2)-10));

        ellipse(xx, yy, 5, 5);
      }
      //se está a tocar faz uma linha a ligar
      if (Sat[i].satPlay==true) {

        stroke(255);
        // line(xx,yy,0,0);
        line(xx, yy, 0, yy);
      }
    }
  }

  popMatrix();
}

