
// Collecting the data from the Text Files
String[][] satData = new String[32][];

// reference to calculate the orbits from the GEO avr Orbirts 35785
// in the feed the altitude if difference from GEO avr
int geo=35785;

float xx=0.0;
float yy=0.0;
float zz=0.0;

float lat=0.0;
float lng=0.0;
float alt=0.0;

//values of the Sat next posicion, so we can interpolate between them. 
float latN=0.0;
float lngN=0.0;
float altN=0.0;

// cordenadas temporarias
float lngTemp=0.0;
float latTemp=0.0;
float altTemp=0.0;


// timeline. controlar a vel com  que passa de linha para linha
//velocity reading/timmer
int time=1;
int timeline=0;
// var vel-> velocidade com que avança de linha
int vel=1;
int checkVel=1;
boolean check=true;

// valor para interpolar entre duas linhas de posiçao nos satData. 
float interpolate=0.00f;
int mapFrom;
int mapTo;


// var to store the current time of the intellation for the timelime
int currentHour=0;
int currentMinute=0;

// var to check when is real time
int checkHour=0;
int checkMinute=0;



// First Read, when the app starts
void intdata() {

  //coordinates of the satellite
  // initialigin satellites[]
  Sat = new Satellite[32];

  //Read each text file with the sat positions
  for (int i=0; i<satList.length; i++) {

    //aqui por o dia
    int day=30;
    
    satData [i] = loadStrings("satdata/"+day+"-"+satList[i]+".txt");

    String[] split1 = split(satData[i][1], " ");

    lng=Float.parseFloat(split1[12]);
    lat=Float.parseFloat(split1[14]);
    alt= geo+Float.parseFloat(split1[19]);

    // coordinates are giving as west or east, north south. 
    if (split1[13].equals("West")) lng=lng*-1;
    if (split1[15].equals("South")) lat=lat*-1;

    // TIME split [5]
    String[] split2 = split(split1[5], ":");
   
    
    // aqui definir as cat de cada um 
    int catt = 0;
    if (i==0) catt=0;
    if (i>0 && i<=10 ) catt=1;
    if (i>10 && i<=20) catt=2;
    if (i>20 && i<=29) catt=3;

    
    
    Sat[i] = new Satellite(i, satList[i], lat, lng, alt, category[i]) ;
    Sat[i].update(lat, lng, alt,lat, lng, alt,1 );
  }
}


////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////


// UPDATE AT DRAW() 
void updateData () { 
  //controlling the time, faster, slower, or realTime. Time is controled by millis()
  //millis is divided, so each unit is 1/10 of second
  if (timeline!=millis()/100) { 
    timeline=millis()/100;  
    check=true;
  };

  // %600 - 1min é o valor minimo. // %100 - 10 segundos. // %10 - 1 sec // %1 - 1/10 sec
  // isto define a velocidade com que passa de linha em linha do satData. Em RT cada linha é 1min.
  if (timeline%vel==0 && check) {
    //println(" MODDUL "+timeline); 
    check=false; 
    time++;
    mapFrom=millis();
    mapTo=mapFrom+(vel*100);
  }

  if (checkVel!=vel) {
    checkVel=vel;
    mapFrom=millis();
    mapTo=mapFrom+(vel*100);
  }

  //mapping entre cada intervalo de tempo 0.0 -> 1.0. dai sai o valor do interpolate
  interpolate=map(millis(), mapFrom, mapTo, 0.000, 1.000);
  interpolate=(round(interpolate*100))/100.00;
//println(interpolate);

  // Quando chega 1440, linhas do satData chega ao fim, loop volta ao principio. 
  if (time>1439) time=1;

  // Checar o tempo actual. usamos o primeiro pq é igual para todos
  String[] split = split(satData[0][time], " ");



  ////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////



  // Looping through each line at satData. for each satelite.
  for (int i=0; i<satList.length; i++) {
     //for (int i=26; i<satList.length; i=26) {

    // Cada linha dividir pelos espaços
   String[] split1 = split(satData[i][time], " ");

    
      // Lee a linha a seguir. (time+1). para depois fazer a interpolaçao entre os dois. 
      String[] splitNext = split(satData[i][time+1], " "); 
      lngN=Float.parseFloat(splitNext[12]);
      latN=Float.parseFloat(splitNext[14]);
      altN= geo+Float.parseFloat(splitNext[19]);
  


   if (splitNext[13].equals("West")) lngN=lngN*-1;
   if (splitNext[15].equals("South")) latN=latN*-1;

    // Var temporaria. Le os valores de cada linha (vindo do split1). 
    // Para dps ser usado no interpolate para os valores reais.

    lngTemp=Float.parseFloat(split1[12]);
    latTemp=Float.parseFloat(split1[14]);
    altTemp= geo+Float.parseFloat(split1[19]);
 
    if (split1[13].equals("West")) lngTemp=lngTemp*-1;
    if (split1[15].equals("South")) latTemp=latTemp*-1;


    Sat[i].update(latN, lngN, altN,latTemp, lngTemp, altTemp,interpolate);
    
   
    
   //vars for checking the current time of the app, virtual time
  String[] timexx=split(splitNext[5],":");
  currentHour=Integer.parseInt(timexx[0]);
   currentMinute=Integer.parseInt(timexx[1]);
 

    
  }
 
  
   //////////////////////////
    //// CHECKING REAL AND VIRTUAL TIME
    
   if(resetRT){    
    // println(timexx[0]);
   for(int k=1; k<1439;k++){
   String[] splitNext = split(satData[0][k], " ");
 
  String[] timeCheck=split(splitNext[5],":");
  checkHour=Integer.parseInt(timeCheck[0]);
  checkMinute=Integer.parseInt(timeCheck[1]);
 
     
     if(checkHour==hour() && checkMinute==minute()) {
      println("é igual em "+ k);
      time=k;
     }
   }
   
   resetRT=false;
   
   }   
     
}

