import ddf.minim.*;
import ddf.minim.ugens.*;

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

Minim minim;
AudioOutput out;
AudioInput in;

ArrayList<Decoration> decorations = new ArrayList<Decoration>();
ArrayList<Character> keyMappings = new ArrayList<Character>();

void setup()
{
  size(512, 200, P3D);
  
  println(Arduino.list());
  print("connecting");
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  print("connected");
  
  for (int i = 0; i <= 13; i++)
    arduino.pinMode(i, Arduino.INPUT);
  
  minim = new Minim(this);
  
  
  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  out = minim.getLineOut();
  
  for(int i=0; i<=13; i++)
  {
    decorations.add(new Decoration(i+".wav", in, out, "StartRecording.wav", "StopRecording.wav"));
    keyMappings.add(Character.forDigit(i, 10));
  }
  
  textFont(createFont("Arial", 12));
}

void draw()
{
  background(0); 
  stroke(255);
  
  //d.UpdateTouching(keyPressed);
  
 // boolean is13 = arduino.digitalRead(2) == Arduino.HIGH;
 // print("\nnr 13:"+ arduino.digitalRead(2));
  
  for (int i=0; i<decorations.size(); i++)
  {
    boolean on = (keyPressed && key == keyMappings.get(i)) ||  arduino.digitalRead(i) == Arduino.HIGH;
    decorations.get(i).UpdateTouching(on);
  }
}