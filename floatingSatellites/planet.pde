PImage bg, texmap;
int sDetail = 60;  //Sphere detail
float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[], cosLUT[], sincos_precision = 0.5f;
int sincos_length = int(360.0f / sincos_precision);

float r = 300;
int inRange;


void initializeSphere(int res)
{
  sinLUT = new float[sincos_length];
  cosLUT = new float[sincos_length];
  for (int i = 0; i < sincos_length; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * sincos_precision);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * sincos_precision);
  }
  float delta = (float)sincos_length/res;
  float[] cx = new float[res];
  float[] cz = new float[res];

  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % sincos_length];
    cz[i] = sinLUT[(int) (i*delta) % sincos_length];
  }

  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;

  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (sincos_length*0.5f)/res;
  float angle = angle_step;

  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % sincos_length];
    float currY = -cosLUT[(int) angle % sincos_length];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}


///

public void texturedSphere(float r, PImage t) 
{
  int v1,v11,v2;
  beginShape(TRIANGLE_STRIP);
  texture(t);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0,v=iv;
  for (int i = 0; i < sDetail; i++) {
    vertex(0, -r, 0,u,0);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0,u,0);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();   

  // Middle rings
  int voff = 0;
  for(int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }

    // Close each ring
    v1=v11;
    v2=voff;
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;

  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    vertex(0, r, 0,u,v+iv);    
    u+=iu;
  }
  //vertex(0, r, 0,u, v+iv);
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
  endShape();
}




void renderGlobe() 
{
  pushMatrix();
  translate(0,0,0);
  //sphere(globeRadius*.5f+5);
  fill(255);
  stroke(0);
  //sphere(r);
  noFill();
  pushMatrix();
  rotateY(radians(270));
  rotateZ(radians(90));
 // rotateY(radians(rot));
  noStroke();
  textureMode(IMAGE);  
  texturedSphere(r, texmap);
  popMatrix();  
  popMatrix();
}
