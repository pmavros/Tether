/* autogenerated by Processing revision 1289 on 2024-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import netP5.*;
import oscP5.*;
import controlP5.*;
import VLCJVideo.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Tether_Video extends PApplet {

/**
 * Tether
 * Tether connects a small video player with the computer aided software Rhinoceros.
 * Tether streams timestamp/frame information to Rhino/Grasshopper
 * Author: Panos Mavros, Future Cities Laboratory.
 *
 * Details:
 * Moves through the video one frame at the time by using the
 * arrow keys. It estimates the frame counts using the framerate
 * of the movie file, so it might not be exact in some cases.
 *
 * It broadcasts the timestamp of the current frame as OSC message;
 * It receives input from a remote program to advance the play / pause / advance frame.
 *
 
 * Using code from Processing example "frames" and https://forum.processing.org/two/discussion/12111/how-do-i-select-a-movie-using-selectinput
 */


//import processing.video. *;
//import processing.sound.*;






VLCJVideo video;
ControlP5 cp5;
OscP5 oscP5;

//Movie myMovie;
File selection;
//int videoLength = 0;
float currentTimeInSeconds;
float videoDurationInSeconds;
float currentTimePercent;

boolean isPlaying = false;
boolean AlwaysOnTop = false;
boolean toggle = false;

int toolbar_y_offset = 40;

int x = 0;
int i = 0;
int w = 640;
int h = 480;
ButtonBar b;
//Button c;
int myListeningPort = 32000;
int myBroadcastPort = 12000;

int skipDuration = 5 * 1000; // milliseconds if using VLCJVideo. Used to for forward / backward.

NetAddress myRemoteLocation;
public void settings() {
  size(w, h);
}
 CheckBox checkbox;
public void setup() {
  //surface.setAlwaysOnTop(true);
  //textSize(20);

  cp5 = new ControlP5(this);
   b = cp5.addButtonBar("bar")
    .setPosition(0, 0)
    .setSize(width *6/6, 20)
    .addItems(split("a b c d e", " "));
  b.changeItem("a", "text", "Load File");
  b.changeItem("b", "text", "Play");
  b.changeItem("c", "text", "Pause");
  b.changeItem("d", "text", "Forward");
  b.changeItem("e", "text", "Backward");
  
  cp5.addToggle("Always_Top")
    .setPosition(width-55, 25)
    .setSize(50, 20)
    .setValue(false) ;
    
  oscP5 = new OscP5(this, myListeningPort);
  myRemoteLocation = new NetAddress("127.0.0.1", myBroadcastPort);
}

public void draw() {

  background(0);
  surface.setAlwaysOnTop(AlwaysOnTop);


  // check whether the movie is already loaded
  if (video != null && video.width > 0) {


    // load success
    image(video, 0, toolbar_y_offset, width, height);


    // get current time, duration
    // NOTE that VLCJVideo returns time in milliseconds so we need to convert to seconds.
    currentTimeInSeconds = (float) video.time() / 1000;
    videoDurationInSeconds = (float) video.duration() / 1000;
    currentTimePercent = map(currentTimeInSeconds, 0, videoDurationInSeconds, 0, 100);

    textAlign(LEFT, CENTER);
    text("Time (secs):  " + nf(currentTimeInSeconds, 0, 2 ) + " / " + nf(videoDurationInSeconds, 0, 2), 10, 30);

    //noStroke();
    //fill(0);
    //rect(8, height - 20,  width -180, 15);

    fill(255);
    text("Press: SPACE to play/pause | LEFT / RIGHT to go +/- 5 seconds | ENTER to stop and restart", 10, height - 10);

    OscMessage myMessage = new OscMessage("/timestamp");
    myMessage.add(currentTimeInSeconds); // convert timestamp to milliseconds
    myMessage.add(currentTimePercent); // convert timestamp to percent of movie time, i.e.  1 - 100

    // /* send the message */
    oscP5.send(myMessage, myRemoteLocation );
  } else {
    // wait for callBack Function fileSelected
    textAlign(CENTER);
    text("Hey!\n Please load a file...", width/2, height/2);
  } // else
} // func

// --------------------------------------------------

public void fileSelected(File selection)
{
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    //exit();  // QUIT
  } else {
    video = new VLCJVideo(this);

    video.open( selection.getAbsolutePath());
    video.setRepeat(true);
    video.play();
    video.setVolume(100); //setVolume only works AFTER play()

    //myMovie.play();
    //myMovie.jump(1);
    //myMovie.pause();
  }
}

// This handles osc messages sent from Rhino/Grasshopper, to control playback.
public void oscEvent(OscMessage theOscMessage) {
  println(theOscMessage);
  /* check if the address pattern fits any of our patterns */
  String oscPattern = String.valueOf(theOscMessage.addrPattern());
  
  switch(oscPattern) {
  case "/control/time":
    video.setTime(video.time()  + 1 * Integer.valueOf(theOscMessage.get(0).stringValue()));
    break;
  case "/control/slider":
    int jumpTo =  Integer.valueOf(theOscMessage.get(0).stringValue());
    int jumpToFrame = (int) map(jumpTo, 0.0f, 100.0f, 0, video.duration() /1000 );

    if ( jumpToFrame < video.duration() - 0.1f) {
      video.setTime(jumpToFrame);
    }
    break;
  case "/control/play":
    if (video.isPlaying()) video.pause();
    else video.play();
    break;
  } // end switch
}

public void keyPressed() {
  if (key == ' ') {
    video.pause();
  }
  if (keyCode == ENTER) {
    if (video.isPlaying()) video.stop();
    else video.play();
  }
  if (keyCode == UP) {
    video.setVolume(video.volume() + 10);
  }
  if (keyCode == DOWN) {
    video.setVolume(video.volume() - 10);
  }
  if (keyCode == LEFT) {
    video.setTime(video.time() - skipDuration);
  }
  if (keyCode == RIGHT) {
    video.setTime(video.time() + skipDuration);
  }
  if (key == 'm') {
    video.setMute(!video.isMute());
  }
}

public void bar(int n) {
  println("bar clicked, item-value:", n);
  switch(n) {
  case 0: // load file
    selectInput("Select a file to process:", "fileSelected", selection);
    break;
  case 1: // play
    if (!video.isPlaying()) video.play();
    break;
  case 2: // pause
    video.pause();
    break;
  case 3: // forward
    video.setTime(video.time() + skipDuration );
    break;
  case 4: // backward
    video.setTime(video.time() - skipDuration );
    break;
  }
}
public void Always_Top(boolean theFlag) {
  println(theFlag);
     if (theFlag==true) {
      AlwaysOnTop = true;    
    } else {
      AlwaysOnTop = false;
    }
}


// END


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tether_Video" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
