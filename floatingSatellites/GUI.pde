// initiace GUI
import controlP5.*;
ControlP5 cp5;
// controls in separate window
import java.awt.Frame;
import java.awt.BorderLayout;
//frame for a new window
ControlFrame cf;

// trail size
int trailSize=20;

// booleans for the categories;
boolean cat0=true;
boolean cat1=true;
boolean cat2=true;
boolean cat3=true;

boolean[] catss = {cat0, cat1, cat2, cat3};

float camRotY=0;
float camRotX=0;

float smoothCamT=40;

// reset and vel to Real Time
boolean resetRT=false;

// boolean to show or hide info displays
boolean displays=true;




// mode 1 basico, planeta + menus
// mode 2 wierd vizz
// mode 3 scanner
int mode=2;

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  int abc = 10;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
   
   
  // add a horizontal sliders, the value of this slider will be linked
   cp5.addFrameRate().setInterval(10).setPosition(0,height - 10);
     
     
     
       cp5.addSlider("mode")
     .plugTo(parent,"mode")
     .setPosition(20 ,100)
     .setSize(150,15)
     .setRange(1, 3)
     
     ;
     
      cp5.addSlider("zoom")
     .plugTo(parent,"zoom")
     .setPosition(20 ,60)
     .setSize(150,15)
     .setRange(800, 3000)
     
     ;
  
     
     
     
      cp5.addSlider("vel")
     .plugTo(parent,"vel")
     .setPosition(20 ,140)
     .setSize(150,15)
     .setRange(1, 600)
     
     ;
  
   
     /// size of the trail
  // cp5.addFrameRate().setInterval(10).setPosition(0,height - 10);
      cp5.addSlider("trailSize")
     .plugTo(parent,"trailSize")
     .setPosition(20 ,160)
     .setSize(150,15)
     .setRange(1, 50)
     
     ;
  
     
     // Categories fo the satellites
       
     cp5.addToggle("cat0")
    .plugTo(parent,"cat0")
     .setPosition(20,200)
     .setSize(30,15)
     ;
     
      cp5.addToggle("cat1")
     .plugTo(parent,"cat1")
     .setPosition(60,200)
     .setSize(30,15)
     ;
     
      cp5.addToggle("cat2")
     .plugTo(parent,"cat2")
     .setPosition(100,200)
     .setSize(30,15)
     ;
     
      cp5.addToggle("cat3")
     .plugTo(parent,"cat3")
     .setPosition(140,200)
     .setSize(30,15)
     ;
     
     

      //rotating camera
      cp5.addSlider("camRotY")
     .plugTo(parent,"camRotY")
     .setPosition(20 ,240)
     .setSize(150,15)
     .setRange(40-180, 40+180)
     
     
     ;
     
          
    
       cp5.addBang("resetRT")
       .plugTo(parent,"resetRT")
     .setPosition(20, 300)
     .setSize(60, 14)
     .setTriggerEvent(Bang.RELEASE)
     
     ;
     
     
      cp5.addToggle("displays")
     .plugTo(parent,"displays")
     .setPosition(20, 80)
     .setSize(30,15)
     ;
     
     
     cp5.loadProperties(("hello.properties"));
     
  }

  public void draw() {
      background(abc);
      
    
     
    if (keyPressed) {
    if (key == 's' ) cp5.saveProperties(("hello.properties"));
    if (key == 'l' ) cp5.loadProperties(("hello.properties"));
    
      }
      
 
  ////////////////////////////////////////////////    
      
  }
  
  
  
/// class and stuff to open a ew   



  
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}

