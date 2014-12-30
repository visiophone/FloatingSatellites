class Satellite {
  
  //initializing vars that define the satellite. 
  int id;
  float latt, lngg, altt, x, y, z, inter, lattN, lnggN, alttN,lattT, lnggT, alttT, xT, xN, yT, yN, zT, zN;
  String satName;
  
  //bool that checks if the sat is near the dubai
  boolean nearDubai = false;
  // bool to activate/desactivate midiNot if sat is near dubai
  boolean satPlay = false;
  
  // pitch for notes to be release (depend on the cat)
  int pitch = 0;
  
  // categoria satelite
  int cat=0;
  //is it active or not
  boolean active = true;
  
  // size of the sphere/sat
  int satSize=8;
  
  // color when active or not active
  color colour = color(255);
  
  ArrayList<PVector> history = new ArrayList<PVector>();
  
  PVector prevPos;
 
 // contructor, defining the vars 
  Satellite(int id, String _name, float _lat, float _lng, float _alt, int _cat) {
    this.id = id;
    //alt = _alt;
    //lat = _lat;
   // lng = _lng;
    satName=_name;
    cat=_cat;
    
    prevPos= new PVector (0.0 , 0.0, 0.0);
    
  }
  
  void display(){
    pushMatrix();
    // sphere that defines Sat
    translate(x, y, z);
    
    if(!satPlay && active) colour=color( 200,255);
    if(!satPlay && !active) colour=color( 200,255);
    if(satPlay){
      //if (cat==0) colour=color(188,6,132);
      //if (cat==1) colour=color(6,80,188);
      //if (cat==2) colour=color(6,154,188);
      //if (cat==3) colour=color(6,188,154);
     if (cat==0) colour=color(222,30,127);
      if (cat==1) colour=color(26,132,222);
      if (cat==2) colour=color(26,200,216);
      if (cat==3) colour=color(188,6,132); 
      
    }
   
    if(active)satSize=8;
    if(mode==2)satSize=5;
    if(!active)satSize=2;
    
    
    noStroke(); 
   fill(colour); 
    sphere(satSize);
 
    // sat info text
    float[] rotations = cam.getRotations(); 
    rotateX(rotations[0]);
    rotateY(rotations[1]);
    rotateZ(rotations[2]);  
   //if active write sat name
   if(active){
   fill( 255,255);
   textSize(20);
  if(mode==1) text("["+id+"] "+satName, 20,20);
   }
   
    popMatrix(); 

    
   // TRAIL
 if (history.size() > trailSize ) { history.remove(0);}

 for (int i=0;i<history.size();i++){  
   // If active draw orbit trail
    if(i!=history.size()-1 ){
     // stroke(255,2);
     //line(history.get(i).x,history.get(i).y,history.get(i).z,history.get(i+1).x,history.get(i+1).y,history.get(i+1).z);
  }    
   stroke(255);
   if(active )   point(history.get(i).x,history.get(i).y,history.get(i).z);    
    }
    
  }
  
  
  // here it checks if the sat is near or far and send the midiOn and midiOffs
  void play(){
    
    //if ISS
      // PARA DISPARAR VARIAS NOTAS ENQUANTO ESTÁ ACTIVO
   //if(nearDubai && satPlay) if framecount#10==0 note on   note Off
    if(cat==0){
    if(nearDubai && !satPlay && active) {
              satPlay=true;           
            if(lattN<-0.8)pitch=36;
             if(lattN>0.8)pitch=60;
             else pitch=48;
          // ver o que são 36, 60, 48,  meter mais algumas notas                 
          
             myBus.sendNoteOn(cat, pitch, 127);
            // println(satName+" midi noteOn - "+pitch);            
    }
    if(!nearDubai && satPlay){
              satPlay=false;
              myBus.sendNoteOff(cat, pitch, 127);
              //println(satName+" midi noteOff");
    }
    }
 
    
 
    // cat experiental
    if(cat==1){
    if(nearDubai && !satPlay && active) {
              satPlay=true;           
           
                           
            pitch=int(map(lattN,-1.6,1.6,24,127));
             myBus.sendNoteOn(1, pitch, 127);
            // println(satName+" midi noteOn - "+pitch);            
    }
    if(!nearDubai && satPlay){
              satPlay=false;
              myBus.sendNoteOff(1, pitch, 127);
              //println(satName+" midi noteOff");
    }
    }
    
   
        if(cat==2){
           //notas possiveis para o 2. para nao fugir do tom  
       int[] notas = { 48, 72, 84, 52, 76, 88, 55, 79, 91 }; 
    if(nearDubai && !satPlay && active) {
              satPlay=true;           
         
                        
            pitch=int(map(lattN,-1.6,1.6,1,9));
            myBus.sendNoteOn(2, notas[pitch], 127);
         
            // println(satName+" midi noteOn - "+pitch);            
    }
    if(!nearDubai && satPlay){
              satPlay=false;
              myBus.sendNoteOff(2, notas[pitch], 127);
           //   myBus2.sendNoteOff(2, 52, 127);
            //  myBus.sendNoteOff(2, 43, 127);
              //println(satName+" midi noteOff");
    }
    }
    
    if(cat==3){
           //notas possiveis para o 2. para nao fugir do tom  
       int[] notas = { 36, 48,60, 72, 84, 108, 96 }; 
    if(nearDubai && !satPlay && active) {
              satPlay=true;           
         
                            
            pitch=int(random(6));
            
             myBus.sendNoteOn(3, notas[pitch], 127);
           //  myBus2.sendNoteOn(2, 52, 127);
             //  myBus.sendNoteOn(2, 43, 127);
            // println(satName+" midi noteOn - "+pitch);            
    }
    
    if(!nearDubai && satPlay){
              satPlay=false;
              myBus.sendNoteOff(3, notas[pitch], 127);
           //   myBus2.sendNoteOff(2, 52, 127);
            //  myBus.sendNoteOff(2, 43, 127);
              //println(satName+" midi noteOff");
    }
    }
    
    
  }
  
  void update(float _latN, float _lngN, float _altN, float _latT, float _lngT, float _altT,float _inter ){
    // degrees to radians
    lattN = radians(_latN);
    lnggN = radians(90f-_lngN);
    alttN=_altN;
    
    lattT = radians(_latT);
    lnggT = radians(90f-_lngT);
    alttT=_altT;
    
    
 //converting spherical coordinates to xyz   
  xT = (alttT)*cos(lattT)*cos(lnggT);
  yT = (alttT)*cos(lattT)*sin(lnggT);
  zT = (alttT)*sin(lattT);
  
   //converting spherical coordinates to xyz   
  xN = (alttN)*cos(lattN)*cos(lnggN);
  yN = (alttN)*cos(lattN)*sin(lnggN);
  zN = (alttN)*sin(lattN);
  
// interpolation moment
    inter=_inter;
    
    x=lerp(xT, xN,inter);
    y=lerp(yT, yN,inter);
    z=lerp(zT, zN,inter);
  
// checking if it is active or not
active=catss[cat];
  
  }
 
}

