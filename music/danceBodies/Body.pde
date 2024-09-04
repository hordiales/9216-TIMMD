class Body { 
  color c;
  float xpos;
  float ypos;
  float h;
  float xHead,yHead;
  float xLeftArm, yLeftArm;
  float xRightArm, yRightArm;
  float xHip,xHipMoving,yHip;
  float xLeftLeg, yLeftLeg;
  float xRightLeg, yRightLeg;
  float width_;
  boolean alone;
  float armLeftAlpha ;
  float armLeftAlpha_moving;
  float armLeftWidth ;
  float armLeftHeight;
  float armRightAlpha ;
  float armRightAlpha_moving;
  float armRightWidth ;
  float armRightHeight;
  int radious_preference;
  // The Constructor is defined with arguments.
  Body(color tempC, float tempXpos, float tempYpos, float tempH, boolean alone_) { 
    alone = alone_;
    c = tempC;
    //neck
    xpos = tempXpos;
    ypos = tempYpos;
    h = tempH;
    width_ = 2 + int(random(3));
    
    //head
    xHead = xpos;
    yHead = ypos-h/6;
    
    //hip
    xHip = xpos + random(-h/8*2/3/2, +h/8*2/3/2);
    yHip = ypos + h*3/8;
    
    //legs
    //left
    float legLeftAlpha = random(PI/32,PI/8);  
    float legLeftWidth = sin(legLeftAlpha)*h*4/8;
    float legLeftHeight = cos(legLeftAlpha)*h*4/8;
    
    xLeftLeg = xHip - legLeftWidth;
    yLeftLeg = yHip + legLeftHeight;
    
    //right
    float legRightAlpha = random(PI/32,PI/8);  
    float legRightWidth = sin(legRightAlpha)*h*4/8;
    float legRightHeight = cos(legRightAlpha)*h*4/8;
    
    xRightLeg = xHip + legRightWidth;
    yRightLeg = yHip + legRightHeight;
    
    //arms
    //left
    armLeftAlpha = random(PI/2+PI/8,PI-PI/8);
    armLeftHeight = sin(armLeftAlpha)*h*3/8;
    armLeftWidth = cos(armLeftAlpha)*h*3/8;
    
    xLeftArm = xpos + armLeftWidth;
    yLeftArm = ypos + armLeftHeight;
    
    //right
    armRightAlpha = random(PI/2+PI/8,PI-PI/8) +PI/2;
    armRightHeight = sin(armRightAlpha)*h*3/8;
    armRightWidth = cos(armRightAlpha)*h*3/8;
    
    xRightArm = xpos + armRightWidth;
    yRightArm = ypos + armRightHeight;
    float r = random(1);
    if (r>0.5) {
    radious_preference = 0;
    } else {
    radious_preference = 1;
    }
  }

  void display() {
    stroke(0);
    fill(c);
    rectMode(CENTER);

    //rect(xpos,ypos,20,10);
  }

  void drive() {
    xpos = xpos + h;
    if (xpos > width) {
      xpos = 0;
    }
  }
  void trace(float[] pulse, color tempC) {
      if (alone) {
       fill(tempC);
       strokeWeight(width_);
       //trace head
       //fill(0);
       xHipMoving = xHip + h/12*(pulse[radious_preference]/100);
       //trace body
       line(xpos,ypos,xHipMoving,yHip);
       
       //trace legs
       //left
       line(xHipMoving,yHip,xLeftLeg,yLeftLeg);
      
       //right
       line(xHipMoving,yHip,xRightLeg,yRightLeg);
       
       //trace arms
           //arms
    //left
    armLeftAlpha_moving =   pulse[radious_preference]/100*PI/8 + armLeftAlpha;
    armLeftWidth = sin(armLeftAlpha_moving)*h*3/8;
    armLeftHeight = cos(armLeftAlpha_moving)*h*3/8;

    xLeftArm = xpos + armLeftWidth;
    yLeftArm = ypos + armLeftHeight;
       
           //right
    armRightAlpha_moving = - pulse[radious_preference]/100*PI/8 + armRightAlpha;
    armRightWidth = sin(armRightAlpha_moving)*h*3/8;
    armRightHeight = cos(armRightAlpha_moving)*h*3/8;
    
    xRightArm = xpos + armRightWidth;
    yRightArm = ypos + armRightHeight;
       
       //left
       line(xpos,ypos,xLeftArm,yLeftArm);
       //right
       line(xpos,ypos,xRightArm,yRightArm);
  
       ellipse(xpos,ypos-h/12*1.5+h/24/100*pulse[radious_preference],h/8*2/3,h/3/2);
     }
  }
  int[][] getPoints() {
    int[][] temp = {
                  {round(xpos),round(ypos)},
                  {round(xHead),round(yHead)},
                  {round(xHip),round(yHip)},
                  {round(xLeftLeg),round(yLeftLeg)},
                  {round(xRightLeg),round(yRightLeg)},
                  {round(xLeftArm),round(yLeftArm)},
                  {round(xRightArm),round(yRightArm)}
                };
                  
    
    return(temp);
  
  }
  
  boolean matchImage(Table img, float thres) {
    boolean tempOut;
    int[][] tempPoints = getPoints();
    float tempValue=0;
    float tempCount=0;
    for (int i = 0; i < tempPoints.length; i++) {
      tempValue= tempValue + img.getInt(tempPoints[i][1],tempPoints[i][0]);
      tempCount ++;
    }
    tempOut = tempValue/tempCount < 1-thres;
    //print(tempOut);
    return(tempOut);  
  }
}
