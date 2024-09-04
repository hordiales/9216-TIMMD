import processing.svg.*;
Table img;
color[]color_vect = {#001219, #005f73, #0a9396, #94d2bd, #e9d8a6, #ee9b00, #ca6702, #bb3e03, #ae2012, #9b2226};

Body[] bodys;
Body body1;
int nBodies = 300;
float hMin = 90;
float hMax = 120;
Crowd crowd;

int beat_dur_ms = int(1000/2.033333333);
int m, m2;
int m_temp =  5*int(1000/2.0333333333);
int delta = 0;
int delta_bo = 0;
float radious=0;
float radious2=0;
int i = 1;
int t_ini = 2000;
int new_time = 0;
float R = random(255);
float G = random (255);
float B = random (255);
int n=0;  
boolean break_out_now = false;
import themidibus.*; //Import the library
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus; // The MidiBus
boolean starting = true;
import static java.lang.Math.*;
color tempC;

void setup() {
  //fullScreen(2);
  background(255);
  size(600,1080);
  frameRate(25);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.
  myBus = new MidiBus(this, "MIDI Mix", -1); 
  crowd = new   Crowd(nBodies, hMax, hMin);
}

void draw() {
  background(200);
  m = millis();
  m2 = m - t_ini;

  //radious = 50+ 50*pow(cos(1*PI/beat_dur_ms*m2 -2*PI*delta/130 ),8);
  radious = -50 + 100*pow(cos(1*PI/beat_dur_ms*m2 -2*PI*delta/130 ),3);
  radious2 = -50 + 100*pow(cos(1*PI/beat_dur_ms*m2 -2*PI*delta/130 ),8);
  float[]radious_vect = {radious,radious2};
  crowd.trace(radious_vect);
}

void switch_viz() {
     R = random(255);
     G = random (255);
     B = random (255);
     tempC = color(R,G,B);
       crowd = new   Crowd(nBodies + int(random(100))-50, 
       hMax - int(random(200)),
       hMin - int(random(100)));
}

void reset_timing(){
  t_ini = m - int(2*PI*delta/130);
}



void break_out_mark() {
     reset_timing();
     switch_viz();

     n = 0;  
 }
 
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  break_out_mark();
}
