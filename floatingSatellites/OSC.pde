import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

   float camX=0; 
    float camY=0; 
    
  boolean noTouch=true;
  int countNotouch=0;

//RECEIVING FROM THE TABLET
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
 // println("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
 // println(" typetag: "+theOscMessage.typetag());
 
  noTouch=false;
  
  //RECEIVING VELOCITY
  if(theOscMessage.checkAddrPattern("/1/vel")==true) {
    float velocity = theOscMessage.get(0).floatValue();
   if(velocity<=0.3) {vel=600;}
   else if(velocity>=0.7) {vel=1;}
   else vel=20;
//   if (velocity<0.3 && velocity>0.7 ) vel=20;

myBus.sendControllerChange(5, 5, int(map(velocity,0,1,1,127)));
    
    println(velocity+" "+vel);
  }
  
   if(theOscMessage.checkAddrPattern("/1/cam")==true) {
     camX = theOscMessage.get(0).floatValue();
    camY = theOscMessage.get(1).floatValue();
    
    
    myBus.sendControllerChange(5, 5, int(map(camX,0,1,1,127)));

   //myBus.sendControllerChange(5, 5, int(map(camX,0,1,1,127)));
    //myBus.sendControllerChange(5, 3, int(map(camY,0,1,20,100)));
   camX=map(camX,0,1,20,-20);
   
   
   
  

  }
  
  // geeting categories
     if(theOscMessage.checkAddrPattern("/1/cat0")==true) {
     float catt0 = theOscMessage.get(0).floatValue();  
     if(catt0>0)cat0=true;
     else cat0=false;     
     
     
             myBus.sendNoteOn(0, 30, 127);
            delay(100);
             myBus.sendNoteOff(0, 30, 127);
     
  }
  
    // geeting categories
     if(theOscMessage.checkAddrPattern("/1/cat1")==true) {
     float catt1 = theOscMessage.get(0).floatValue();  
     if(catt1>0)cat1=true;
     else cat1=false;   
   
    myBus.sendNoteOn(0, 54, 127);
            delay(100);
             myBus.sendNoteOff(0, 54, 127);
     
  }
  
      // geeting categories
     if(theOscMessage.checkAddrPattern("/1/cat2")==true) {
     float catt2 = theOscMessage.get(0).floatValue();  
     if(catt2>0)cat2=true;
     else cat2=false;    
    
     myBus.sendNoteOn(0, 46, 127);
            delay(100);
             myBus.sendNoteOff(0, 46, 127);
     
  }
  
        // geeting categories
     if(theOscMessage.checkAddrPattern("/1/cat3")==true) {
     float catt3 = theOscMessage.get(0).floatValue();  
     if(catt3>0)cat3=true;
     else cat3=false;     

 myBus.sendNoteOn(0, 40, 127);
            delay(100);
             myBus.sendNoteOff(0, 40, 127);  

}
  
      // reset botton
     if(theOscMessage.checkAddrPattern("/1/reset")==true) {
     float res = theOscMessage.get(0).floatValue(); 
    println(res); 
     if(res>0)reset=true;
    // else reset=false;  
 
  myBus.sendNoteOn(0, 84, 127);
            delay(100);
             myBus.sendNoteOff(0, 84, 127);
    
  }
  
        // reset botton
     if(theOscMessage.checkAddrPattern("/1/display")==true) {
     float disp = theOscMessage.get(0).floatValue(); 
    //println(res); 
     if( disp>0)displays=!displays;
    // else reset=false;     
    
     myBus.sendNoteOn(0, 58, 127);
            delay(100);
             myBus.sendNoteOff(0, 58, 127);
    
  }
  
  if(theOscMessage.checkAddrPattern("/1/ZOOM")==true) {
     float zz = theOscMessage.get(0).floatValue(); 
    //println(res); 
     zoom=map(zz,0,1,100,6000);
    // else reset=false;     
  }
  
  
}




void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/1/led1");
 
  float led1=1.0;
  myMessage.add(led1); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
 println(myMessage); 
 
}
