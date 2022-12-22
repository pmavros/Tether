/* 

  ** VIDEO AND AUDIO TRANSCRIPTOR **
  
  AUTHOR:  PANOS MAVROS, 2016, FUTURE CITIES LABORATORY

*/

/* 

STEPS
1. READ VIDEO SOURCE = DRAG AND DROP
2. EXTRACT START TIME AND FRAME RATE
3. PLAYBACK
4. BUTTONS TO ANNOTATE
5. BUTTON BEHAVIOUR ADDS TIMESTAMPS TO CSV file
6. TRANSCRIBE TEXT IN FORM. SAVE ON THE FLY to avoid data loss.
*/

// LIBRARIES

import controlP5.*;
import drop.*;
import processing.video.*;
import java.nio.file.*;
import java.nio.file.Files;
import java.nio.file.attribute.*;
import java.nio.file.attribute.FileTime;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.concurrent.TimeUnit;
import java.text.SimpleDateFormat;
import java.util.Map;
import oscP5.*;
import netP5.*;


// GLOBAL VARIABLES
Movie myMovie;
Movie mov;
SDrop drop;
ControlP5 cp5;
OscP5 oscP5;
NetAddress myRemoteLocation;


String movieFile;
int newFrame;
boolean paused = true;
int myColor = color(255);
int c1,c2;
float n,n1;
FileTime creationTime;
int currentFrame = 0;
float frameSize = 0;
float movDuration = 0;
float movTime = 0;
int movFrames = 0;
float frameDuration;

PrintWriter output;

Table table;
int movieEventsTimes [] = {0};
String movieEvents [] = {"0"};
String fileName;
SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");
 
void setup (){
  
    size(640, 640);
    background(0);
   
    cp5 = new ControlP5(this);
    uiSetup();
    
    myRemoteLocation = new NetAddress("127.0.0.1",6000);
 
    //selectInput("Select a file to process:", "selectFile");


    if(true){ // mov != null
      
      mov = new Movie(this, "transit.mov"); // movieFile
  
      // Pausing the video at the first frame. 
      mov.play();
      mov.jump(10);
      mov.pause();
      println("framerate "+mov.frameRate);
      //frameDuration = 1.0 / mov.frameRate;
    }

}



void draw() {
  background(0);
  if(mov != null){
    
     /* in the following different ways of creating osc messages are shown by example */
 
  image(mov, 0, 50, width, 50+width/2);
  frameDuration = 1.0 / mov.frameRate;
  fill(255);
  text(getFrame() + " / " + (getLength() - 1), 10, 30);
  
  
  if(getLength()>0){
    fill(255, 0, 0 );
    noStroke();
    rectMode(CORNERS);
    rect(0,40, mov.time()*(width/mov.duration()), 50);
  }

  //long  timestamp = (long) (creationTime.to(TimeUnit.MILLISECONDS))+(long)((getFrame()*frameDuration)*1000);
  //String dateCreated = df.format(timestamp);
  //text(dateCreated+"  ", 100, 30);
  
  if(paused){
    mov.pause();
  } else {
    mov.play();
  }
  
    
  
  }
  
  OscMessage myMessage = new OscMessage("/timestamp");
  myMessage.add(currentFrame); /* add an int to the osc message */
  // oscP5.send(myMessage, myRemoteLocation);   /* send the message */

  
}



void keyPressed() {
  
  frameDuration = 1.0 / mov.frameRate;
  
  println(getFrame()*frameDuration);
  println(key);
   
   if (key == 'p') {
      if(paused){
        paused = false;
      } else {
        paused = true;
      }
    }
    
  if (key == 'r') {
      restart();
    }  
    
  if (key == CODED) {
    
    if (keyCode == LEFT) {
      if (0 < newFrame) newFrame = getFrame()-1; 
    } else if (keyCode == RIGHT) {
      if (newFrame < getLength() - 1) newFrame= getFrame()+1;
    }
    
      //setFrame(newFrame);  

  } 
  
  
}

void createFile(){
    String outputName = "data/"+fileName+"_events.csv";
    output = createWriter(outputName); 
      
     // setup header
     logEvents("eventSecondFromStart, timestamp, eventName");
     logEvents("0, "+ df.format(creationTime.to(TimeUnit.MILLISECONDS))+", Start of File");
}


void movieEvent(Movie m) {
  m.read();
  frameDuration = 1.0 / mov.frameRate;
}
  
int getFrame() {    
  return ceil(mov.time() * mov.frameRate);
}

//void setFrame(int n) {
//  mov.play();
    
//  // The duration of a single frame:
//  frameDuration = 1.0 / mov.frameRate;
    
//  // We move to the middle of the frame by adding 0.5:
//  float where = (n + 0.5) * frameDuration; 
    
//  // Taking into account border effects:
//  float diff = mov.duration() - where;
//  if (diff < 0) {
//    where += diff - 0.25 * frameDuration;
//  }
    
//  mov.jump(where);
//  mov.play();
//  //mov.pause();  
//}  

int getLength() {
  return int(mov.duration() * mov.frameRate);
}



public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getName());
 
  if(mov != null){
    //long  timestamp = (long) (creationTime.to(TimeUnit.MILLISECONDS))+(long)((getFrame()*frameDuration)*1000);
    //String dateCreated = df.format(timestamp);
 
    //logEvents((String) (mov.time()+", "+ dateCreated + ", "+ theEvent.getController().getName()));
    
     if (theEvent.getController().getName().equals("Restart")) {
       restart();
    }
  }
  //if (theEvent.getController().getName().equals("Trial Start")) {
  //     //println(getLength()+" "+ mov.duration() +" "+mov.time());
  //}
}

void restart (){
  mov.jump(0);
  mov.play();
}

void logEvents (String thisLog){
  println(thisLog);
  output.println(thisLog);
  output.flush(); // Writes the remaining data to the file
}


void exit() {
  //put code to run on exit here
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  super.exit();
}
