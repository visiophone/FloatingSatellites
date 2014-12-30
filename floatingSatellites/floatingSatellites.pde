import peasy.*;

// MIDI 
import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus
//MidiBus myBus2; // The MidiBus

// Array that stores each satellite
Satellite[] Sat;
// String that stores the name of ech satellite
String[] satList = {"ISS", "AJISAI", "AKARI", "ALOS", "AQUA", "ASTEX1", "COSMO_SKYMED1", "ENVISAT", "ERBS",  "ERS1", "ERS2", "GENESIS1", "GENESIS2", "HUBLE", "INTERCOSMOS24", "INTERCOSMOS25", "JB_3", "KORONAS_FOTON", "METEOR_PRIRODA", "ADEOS_II", "OAO_2", "OAO_3", "OKEAN_3", "OKEAN_0", "ORBVIEW_2", "RESURS_DK_1", "SEASAT_1", "SUZAKU","TIANGONG_1", "SERT_2" };
int[] category = {0,3,2,1,1,3,1,1,1,1,1,3,3,2,1,1,1,1,1,2,2,2,1,1,1,1,1,2,3,3};
  PeasyCam cam;
  
//Dubai coordinates (from wikipedia) 24.57N and 55.20E, in radians  lat 0.42 lng 0.61  (alt = 400);
//translated into cartesian xyz. check skectch dubaicoordinates.pde
PVector dubaiPos = new PVector (298.71896,207.61507,166.32187);
//distance to dubai, where satts became active
float dubaiDist = 0.5;

// ARRAY that stores the LAT of each satellite. to make it smooth
// when connecting to the arc
//PVector []  prevArcPos;
float [] prevLat= new float [30];
//var to chech if the time as changed, to add history trails
float prevTime=0;
  
float sounding =0.0;  

//camera zoom
float zoom;

boolean reset=false;
  
void setup() {
  //size(1024, 768, P3D);  
  size(displayWidth, displayHeight,P3D);
  
  //osc
   /* start oscP5, listening for incoming messages at port 12000 */
   oscP5 = new OscP5(this,8000);
   myRemoteLocation = new NetAddress("10.117.17.163",9000);
  
  //MIDI STUFF
  myBus = new MidiBus(this, 1, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  //  myBus2 = new MidiBus(this, 1, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

 // size(displayWidth,displayHeight, P3D);
  texmap = loadImage("earth8.jpg");    
  initializeSphere(sDetail);
 
 //new window for the controls
  cf = addControlFrame("CONTROL CENTER", 250,400);
  
  rectMode(CENTER);
   
  //camera defs
  cam = new PeasyCam(this, r + 1000);
  cam.setResetOnDoubleClick(true);
  cam.rotateX(radians(-80));
  cam.rotateY(radians(40));
  cam.setMinimumDistance(800);
  cam.setMaximumDistance(3000);
  
  zoom=r+1000;
  
intdata();
frameRate(50);



//initiation the array with the satVars
for (int i=0;i<satList.length;i++){
  //prevArcPos[i]= new PVector(0.0,0.0,0.0);
  prevLat[i]=0.0;
}

}


void draw(){
  
background(0);  
updateData();

// moving the camera
cam.setDistance(zoom);


//MODE 1
directionalLight(226, 226, 226, 0, -0.9,0);
ambientLight(202, 202, 202);
//Inicio do planeta
pushMatrix();

if(mode==1)renderGlobe();

stroke(255);
if(mode==1){
//drawing centrer planet axe
line(0,0,450,00,0,-450);
// sphere on the top of the planet central line
pushMatrix();
translate(0,0,450);
sphere(6);
popMatrix();
pushMatrix();
translate(0,0,-450);
sphere(6);
popMatrix();
}
//Drawing arc
pushMatrix();
//rotateX(radians(25));
rotateZ(radians(-55));
rotateY(radians(90));
noFill();
//fill (255,10);
if(mode==1)arc(0,0, 800, 800, 0, PI, PIE);
popMatrix ();
if(mode!=3){
//drawing dubai line
line(0,0,0,dubaiPos.x, dubaiPos.y, dubaiPos.z);
//Sphere que representa o dubai
pushMatrix();
translate(dubaiPos.x, dubaiPos.y, dubaiPos.z);
sphere(8);
popMatrix();
}
// sphere on the top of the planet central line
////////////////////////////////////////////////////////////
//display planets
for(int i=0;i<satList.length;i++){
  //for(int i=0;i<20;i++){
if(mode!=3)Sat[i].display(); 

//println(time);
if(prevTime!=time && mode!=3) Sat[i].history.add(new PVector(Sat[i].x,Sat[i].y,Sat[i].z));

// ISTO TALVEZ DEVESSE SER FEITO DENTRO DA CLASS SATELITTES ou noutro TAB QQ
//check the distante of each sat to dubai. if is less than dubaiDist, then the sat is active
  // if the sat is closest that "dubaiDist then bool nearDubai True
if(abs(0.61-Sat[i].lnggN)<dubaiDist && Sat[i].active) {
  //line(Sat[i].x,Sat[i].y,Sat[i].z, dubaiPos.x, dubaiPos.y, dubaiPos.z);
  
  float arcLat = Sat[i].lattN;
  float arcLong= radians(90f-55.2);
  float arcAlt=400;
  
 
  prevLat[i]+=(arcLat-prevLat[i])*0.2;
  
  float arcLat2 = prevLat[i]+0.2;
  float arcLong2= radians(90f-55.2);
  float arcAlt2=400;
  
  float arcX=(arcAlt)*cos(prevLat[i])*cos(arcLong);
  float arcY=(arcAlt)*cos(prevLat[i])*sin(arcLong);
  float arcZ=(arcAlt)*sin(prevLat[i]);
  
  float arcX2=(arcAlt2)*cos(arcLat2)*cos(arcLong2);
  float arcY2=(arcAlt2)*cos(arcLat2)*sin(arcLong2);
  float arcZ2=(arcAlt2)*sin(arcLat2);
 
 if(mode==1){ 
  //smoothing the pos
 // prevArcPos[i].x+=(arcX-prevArcPos[i].x)*0.1;
 // prevArcPos[i].y+=(arcY-prevArcPos[i].y)*0.1;
 // prevArcPos[i].z+=(arcZ-prevArcPos[i].z)*0.1;
  stroke(Sat[i].colour,100);
 line(Sat[i].x,Sat[i].y,Sat[i].z, arcX, arcY, arcZ);
  line(Sat[i].x,Sat[i].y,Sat[i].z, arcX2, arcY2, arcZ2);


 // little sheres in the arc
  pushMatrix();
  translate(arcX, arcY, arcZ);
  noStroke();
  fill(255);
  sphere(4);
  popMatrix();
  //little spheres in the arc
   pushMatrix();
  translate(arcX2, arcY2, arcZ2);
  noStroke();
  fill(255);
  sphere(4);
  popMatrix();
}
////// drawww mode 1  
if(mode==1){  
beginShape();
fill(Sat[i].colour,200);
vertex(Sat[i].x, Sat[i].y, Sat[i].z);
fill(Sat[i].colour,10);
vertex(arcX,arcY, arcZ); 
fill(Sat[i].colour,10);
//vertex(dubaiPos.x,dubaiPos.y,dubaiPos.z); 
vertex(arcX2,arcY2, arcZ2);  
endShape(CLOSE);
} 
/////////////
if(mode==2){
 Vizz(); 
}



  
  //experimental vizz
  //Vizz();
  
 Sat[i].nearDubai=true; 
}
else Sat[i].nearDubai=false; 

//here is from where the midi Notes will be sent
Sat[i].play();

}


////////////////////////////////

prevTime=time;

//checking if satCat is active or not
catss[0]=cat0;catss[1]=cat1;catss[2]=cat2;catss[3]=cat3;

popMatrix();



//////////////////////////////////////////////////////////////

// HUD. quadros extra, nao afectados pela peasy cam. 
cam.beginHUD();

 
// 


//GUI
if(displays && mode!=3) timeline();
if(displays && mode!=3) satlisting();
if(displays && mode!=3) sequencer();

fill(255);
textSize(10);
//text(year()+"/"+month()+"/"+day()+" | "+hour()+":"+minute()+":"+second()+" | FPS: "+int(frameRate), 15,15);



//RADAR MODE
if(mode==3){
 
  noStroke();
  fill(0);
  noStroke();
  rect(0,0,width,height);
 
 /*
 if(sounding<width) sounding++;
 else sounding=0;
 
 for (int i=0; i<satList.length; i++) {
  stroke(255);
  noFill();
  if(Sat[i].satPlay) ellipse(width/2,height/2,sounding,sounding); 
 }
*/ 
 radarMode();
  
}

noFill();
stroke(255);
//rect(0,0,width,height);

//control cor para o pisca pisca
led();
//cp5.draw();
cam.endHUD();

//experiencia rotate cam

if(noTouch==false)camRotY+=(camX-camRotY)*0.1;

if(camX>0.0)camX--;
if(camX<0.0)camX++;
//if(camRotY!=0.0 )camRotY+=(0.0-camRotY)*0.1;
//if(camRotY<-0.1)camRotY=camRotY+0.1;

//se nao mexem ha muito rot vai para 0.1 outravez
if(noTouch==false)countNotouch++;

if(countNotouch>100){
  noTouch=true;
  countNotouch=0;
  camRotY=0.00;
  camX=0.0;
  
 
  //reset=true;
  //println("rota devagar "+camRotY);
}

// println(camRotY);
cam.rotateY(radians(camRotY));
//cam.rotateY(radians(-0.1));
cam.setYawRotationMode(); 

if(reset){
  
  zoom=1300;
  cam.setRotations(radians(-80),radians(40),0);
  resetRT=true;
  reset=false;
  vel=20;
}

//FAZER ASSIM OU ENTAO FAZER COM A VEL DE ROTAÇÃO // FAZER SMOOTH
//cam.setRotations(radians(-80),radians(camRotY),0);


 //////////////////////////////////////////////////////////////
// keyboard 
 
 if (keyPressed) {
   if(key=='r'){
//cam.reset(0);
//cam.rotateX(radians(-80));
//cam.rotateY(radians(40));
cam.setRotations(radians(-80),radians(40),0);

   }
      }
 
//println (cam.getRotations());



}
