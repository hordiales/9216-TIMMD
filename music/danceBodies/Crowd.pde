import java.util.Arrays;   
import java.util.Collections;   
class Crowd { 
  Body[] bodys;
  Body body1;
  float separation = 0.375; // the lower the closer could be >1
  int nBodies; 
  // declare empty matrix representing the canvas
  int[][] screen = new int[height][width];
  // The Constructor is defined with arguments.
  Crowd(int nBodies_, float hMax_, float hMin_) { 
  
    nBodies = nBodies_;
    bodys = new Body[nBodies];
    float hMin = hMin_;
    float hMax = hMax_;
    float tempY[];
    tempY = new float[nBodies];
 
    for (int i = 0; i<nBodies;i++) {
      tempY[i] = random(hMin,height-hMax);
    }
    
    Arrays.sort(tempY);  
    
    for (int i = 0; i<nBodies;i++) {
      //float tempY = random(0,height);
      
      float A = (hMax-hMin)/(height+hMax+hMin);
      float B = (1-A)*hMin;
      float tempH = A*tempY[i] + B;
      float tempX = random(hMax,width-hMax);
    
      //mask the matrix
      int tempXint = round(tempX);
      int tempYint = round(tempY[i]);
        
      //cond 1 another body NOY around;
      boolean cond1 = screen[tempYint][tempXint]!=1;
      //println(color(255,0,0),tempX,tempY,tempH, cond1);
      
      body1 = new Body(color_vect[int(random(10))],tempX,tempY[i],tempH, cond1);
      
      bodys[i] = body1;
      //println(separation);
      
      // mark suroundings
      int stepInt = round(tempH*separation);// + separation;
      /*if (random(1)>0.4) {stepInt = round(tempH/4) ;//+ separation;}*/
    
      if (stepInt>0) {
        for (int j=-stepInt;j<=+stepInt;j++) {
          for (int k=-stepInt;k<=+stepInt;k++) {
            screen[tempYint+j][tempXint+k]=1;
          } 
        }
      }
    screen[tempYint][tempXint]=1;
    }
  }
  
  //void trace(float[] pulse,color tempC) {
  void trace(float[] pulse) {
    
        for (int i = 0; i<nBodies;i++) {
          
          bodys[i].trace(pulse,bodys[i].c);
        }
        
  }
}
