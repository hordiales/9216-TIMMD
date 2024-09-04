import java.util.Arrays;

import oscP5.*; //libraries required
import netP5.*;
import controlP5.*;

OscP5 oscP5;
NetAddress sonicPi;

int sound = 0;
int b = 0;
int n2 = 2;

String[] lines;
int index = 0;
String path;

int xc, yc;

float tsne_min = -22;
float tsne_max = 22;
float aplifyed_factor = 6;
  // load tsne matrix
float[] x ;
float[] y ;
color[] cols;
PVector velocity;  // Velocity of shape
int iter = 0;
int offSet_x =+100;
int offSet_y =-150;
//float[] distances;

void setup() {
  size(960,720);
  background(210);
  noStroke();
  frameRate(4);
  path = "/Users/xaviergonzalez/Documents/repos/dji/djiP3/loops_xy_test.csv";
  lines = loadStrings(path);
  xc = width/2;
  yc = height/2;
  
  velocity = new PVector(-3,-3);
  
  x = new float[lines.length];
  y = new float[lines.length];
  cols = new color[lines.length];

  print(lines.length);
  print("this");
  //print(lines);
  
  for (int index = 0; index < lines.length; index++) {
    String[] pieces = split(lines[index], ',');
    if (pieces.length >= 4) {
      y[index] = float(pieces[2])*aplifyed_factor + width/2 +offSet_y;
      x[index] = float(pieces[1])*aplifyed_factor + height/2 + offSet_x;
      //cols[index] = color(unhex(pieces[4]));
    }
  }
 
  //println(x);
  oscP5 = new OscP5(this,12000);
  sonicPi =   new NetAddress("127.0.0.1",4560); //new NetAddress("192.168.0.159",8000);

  
}

void draw() {
  background(190);
  //print(lines.length);
  // Go to the next line for the next run through draw()
  
  trace_tsne(x,y,cols);
  fill(255, 0, 0);
  ellipse(xc, yc, 5, 5);
  //println(get_n_nearest_ids(3,xc,yc,x,y));
  stroke(0);
  int[] n_near = get_n_nearest_ids(3,xc,yc,x,y);
  trace_n_nearest(n_near,  xc, yc);
  print(n_near[0]);
  send_n_nearest(n_near,  x, y);
   
   // move one time in 8
   
   

   if (iter == 8) {
     xc = xc - int(velocity.x);
     yc = yc + int(velocity.y);
     iter = 0;
   } else {
     iter += 1;
   }
   
}

void send_n_nearest(int[] n_near, float[] x,float[] y) {
  
        //send osc

  
  OscMessage m = new OscMessage("/trigger/prophet");
  for(int i = 0; i < n_near.length; i++) {
    
    //println(x[n_near[i]]);
      
      m.add(n_near[i]);
      //m.add(120);
      //m.add(1);
//println(n_near);
      
  }
  oscP5.send(m, sonicPi);
  //println("---");
  
}


void trace_n_nearest(int[] n_near, float xc,float yc) {
  for(int i = 0; i < n_near.length; i++) {
    if (i==0) {
      strokeWeight(3);
     } 
    else{
      strokeWeight(1);
     } 
    line(xc, yc, x[n_near[i]], y[n_near[i]]);
    //println(x[n_near[i]]);
  }
  //println("---");
  
}


void trace_tsne(float[] x, float [] y, color[] cols) {
  
    for (int index = 0; index < lines.length; index++) {
      text(index, x[index], y[index]);
      fill(cols[index]); 
      ellipse(x[index], y[index], 5, 5);
    }
  }

int[] get_n_nearest_ids(int n,float xc, float yc ,float[] x, float[] y) {
  
  int n_nearest[] = new int[n];
  float distances[] = new float[x.length]; 

  for (int index = 0; index < x.length; index++) {
    //### todo calculate distances 
    

    distances[index] =  - abs(xc -x[index]) - abs(yc - y[index]);
    //println("ddd");
    //println(distances[index] );
  }
  
   return (getIndexesOfHighestNValues(distances,4));//,n));
}

int[] indexesOfTop3Elements(float[] orig, int nummax) {
        //float[] copy = Arrays.copyOf(orig,orig.length);
        //Arrays.sort(copy);
        //float[] honey = Arrays.copyOfRange(copy,copy.length - nummax, copy.length);
        int[] result = new int[2];
        //int resultPos = 0;
        float min_temp1 = 99999;
        float min_temp2 = 99999;
        float min_temp3 = 99999;
        result[0] = 99999;
        
        for(int i = 0; i < orig.length; i++) {
            if (orig[i] <= min_temp1) {
              //the las maximum is stored
              result[1] = result[0];
              
              if (orig[i] <= min_temp2) {
                 min_temp2 = orig[i];
                 result[1] = i;
              } 
              min_temp1 = orig[i];
              result[0] = i;
              continue;
            }
            if (orig[i] <= min_temp2) {
              min_temp2 = orig[i];
              result[1] = i;
              continue;
            }
            if (orig[i] <= min_temp3) {
              min_temp3 = orig[i];
              //result[2] = i;
              continue;
            }
            //float onTrial = orig[i];
            //int index = Arrays.binarySearch(honey,onTrial);
            //if(index < 0) continue;
            //result[resultPos++] = i;

        }
        //println("result:");
        //println(result[0],result[1],min_temp1,min_temp2,min_temp3);
        return result;

}

int[] getIndexesOfHighestNValues(float[] inputArray, int n) {
    int[] result = new int[n];

    // Copy input array to a new array to avoid modifying the original array
    float[] sortedArray = Arrays.copyOf(inputArray, inputArray.length);

    // Sort the copied array in descending order
    Arrays.sort(sortedArray);
    for (int i = 0; i < n; i++) {
        float highestValue = sortedArray[inputArray.length - 1 - i];
        for (int j = 0; j < inputArray.length; j++) {
            if (inputArray[j] == highestValue) {
                result[i] = j;
                break;
            }
        }
    }
    return result;
}


int[] secondMaxIndex(float[] floatArray)
  {
    float largest  = floatArray[0];
    float largest2 = -9999;
    int maxIndex = 0;
    int maxIndex2 = 0;


    for( int i = 0; i < floatArray.length ; i++)
    {
        if( largest < floatArray[i] )
        {
            largest2 = largest;
            maxIndex2 = maxIndex;
            largest = floatArray[i];
            maxIndex = i;
        }
        else if(floatArray[i] > largest2)
        {
             largest2 = floatArray[i];
             maxIndex2 = i;
        }
    }
    println("i12",maxIndex,maxIndex2);
    int[] out = {maxIndex, maxIndex2};
    return out ;
}

int[] indexesOfTopElements(float[] orig, int nummax) {
        float[] copy = Arrays.copyOf(orig,orig.length);
        Arrays.sort(copy);
        float[] honey = Arrays.copyOfRange(copy,copy.length - nummax, copy.length);
        int[] result = new int[nummax];
        int resultPos = 0;
        for(int i = 0; i < orig.length; i++) {
            float onTrial = orig[i];
            int index = Arrays.binarySearch(honey,onTrial);
            if(index < 0) continue;
            result[resultPos++] = i;
        }
        return result;
}

void sendChanges() {
  
  
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) yc--;
    if (keyCode == RIGHT) xc++;
    if (keyCode == DOWN) yc++;
    if (keyCode == LEFT) xc--;
  }
  //sendCanges();
}

void mouseClicked() {
  xc = mouseX;
  yc = mouseY;
}
