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
 
 
//import processing.video.*;
import netP5.*;
import oscP5.*;
import controlP5.*;
import VLCJVideo.*;

import uk.co.caprica.vlcj.player.events.MediaPlayerEventType;


ControlP5 cp5;
OscP5 oscP5;
VLCJVideo myMovie = null;

//Movie myMovie = null;
File selection;
int myMovieLength = 0;

int toolbar_y_offset = 40;
 
int x = 0;
int i = 0;
int w = 640;
int h = 480;

int myListeningPort = 32000;
int myBroadcastPort = 12000;

NetAddress myRemoteLocation;
void settings() {
  size(w, h); 
}

void setup() {
  // size should always be the 1st line in draw(): init
  surface.setAlwaysOnTop(true);

  cp5 = new ControlP5(this);
  ButtonBar b = cp5.addButtonBar("bar")
     .setPosition(0, 0)
     .setSize(width, 20)
     .addItems(split("a b c d e"," "))
     ;
     println(b.getItem("a"));
  b.changeItem("a","text","Load File");
  b.changeItem("b","text","Play");
  b.changeItem("c","text","Pause");
  b.changeItem("d","text","Forward");
  b.changeItem("e","text","Backward");

  //b.onMove(new CallbackListener(){
  //  public void controlEvent(CallbackEvent ev) {
  //    ButtonBar bar = (ButtonBar)ev.getController();
  //    println("hello ", bar.hover());
  //  }
  //});
  
  oscP5 = new OscP5(this, myListeningPort);
  myRemoteLocation = new NetAddress("127.0.0.1", myBroadcastPort);
  
   myMovie = new VLCJVideo(this);
   bindVideoEvents();
  
}


void bar(int n) {
  println("bar clicked, item-value:", n);
  switch(n) {
    case 0: // load file
      selectInput("Select a file to process:", "fileSelected", selection);
      break;
    case 1: // play
       if(!myMovie.isPlaying()) myMovie.play();
      break;
    case 2: // pause
      if(myMovie.isPlaying()) myMovie.pause();
      break;
    case 3: // forward
      myMovie.jump(myMovie.time() + 10);
      break;
    case 4: // backward
      myMovie.jump(myMovie.time() - 10);
      break;
  }
}
 
void draw() {
  
  background(0);
    surface.setAlwaysOnTop(true);

  
  // check whether the movie is already loaded
  if (myMovie != null && myMovie.width > 0) {
    
  
    // load success 
    image(myMovie, 0, toolbar_y_offset, width, height);
     myMovie.loop();
 
    float y = myMovie.time();
     
    textAlign(LEFT,CENTER);
    
    text("Time (secs):  " + round(myMovie.time()) + " / " + (round(myMovie.duration())) + 
    "  |  Timestamp (ms):  " + round(myMovie.time()*1000) + " / " + (round(myMovie.duration() * 1000)), 10, 30);
    //text("Timestamp (ms):  " + round(myMovie.time()*1000) + " / " + (round(myMovie.duration() * 1000)), 10, 50);
        
    //noStroke();
    //fill(0);
    //rect(8, height - 20,  width -180, 15);
    
    fill(255);
    text("Press: SPACE to play/pause | LEFT / RIGHT to go +/- 10 seconds | ENTER to stop and restart", 10, height - 10);
    
     OscMessage myMessage = new OscMessage("/timestamp");
     myMessage.add(myMovie.time()); // convert timestamp to milliseconds
     myMessage.add(map(myMovie.time(), 0, myMovie.duration(), 0, 100)); // convert timestamp to percent of movie time, i.e.  1 - 100
   
     // /* send the message */
      oscP5.send(myMessage, myRemoteLocation ); 

    //if (y > myMovie.duration() - 0.1) {
    //  //exit(); // QUIT
    //} 
  } else {
    // wait for callBack Function fileSelected
    textAlign(CENTER);
    text("Hey!\n Please load a file...", width/2, height/2);
  } // else
} // func
 
// --------------------------------------------------
 
void fileSelected(File selection) 
{
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    //exit();  // QUIT
  } else {
    
    myMovie.openMedia(selection.getAbsolutePath());
    myMovie.play();
    myMovie.jump(10);
    myMovie.pause();
  }
}


  
void oscEvent(OscMessage theOscMessage) {
  println(theOscMessage);
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals("/control/time")) {
    
    println(theOscMessage);
    
    //int moveTime =  Integer.valueOf(theOscMessage.get(0).stringValue());
    myMovie.jump(myMovie.time()  + 1 * Integer.valueOf(theOscMessage.get(0).stringValue()));
    
  }
  else if (theOscMessage.addrPattern().equals("/control/slider")) {
    
    int jumpTo =  Integer.valueOf(theOscMessage.get(0).stringValue());
    float jumpToFrame = map(jumpTo, 0.0, 100.0, 0, myMovie.duration());
    
    if( jumpToFrame < myMovie.duration() - 0.1) {
     myMovie.jump(jumpToFrame);
    }
    
    
} else if (theOscMessage.addrPattern().equals("/control/play")) {
          println(theOscMessage);
         if(myMovie.isPlaying()) myMovie.pause();
          else myMovie.play();
    }
 
}

void keyPressed() {
  if(key == ' ') {
    if(myMovie.isPlaying()) myMovie.pause();
    else myMovie.play();
  }
  if(keyCode == ENTER) {
    if(myMovie.isPlaying()) myMovie.stop();
    else myMovie.play();
  }
  if(keyCode == UP) {
    myMovie.setVolume(myMovie.volume() + 0.1);
  }
  if(keyCode == DOWN) {
    myMovie.setVolume(myMovie.volume() - 0.1);
  }
  if(keyCode == LEFT) {
    myMovie.jump(myMovie.time() - 10);
  }
  if(keyCode == RIGHT) {
    myMovie.jump(myMovie.time() + 10);
  }
}

void bindVideoEvents() {
  myMovie.bind( MediaPlayerEventType.FINISHED, new Runnable() { public void run() {
    println( "finished" );
  } } );
  myMovie.bind( MediaPlayerEventType.OPENING, new Runnable() { public void run() {
    println( "opened" );
  } } );
  myMovie.bind( MediaPlayerEventType.ERROR, new Runnable() { public void run() {
    println( "error" );
  } } );
  myMovie.bind( MediaPlayerEventType.PAUSED, new Runnable() { public void run() {
    println( "paused" );
  } } );
  myMovie.bind( MediaPlayerEventType.STOPPED, new Runnable() { public void run() {
    println( "stopped" );
  } } );
  myMovie.bind( MediaPlayerEventType.PLAYING, new Runnable() { public void run() {
    println( "playing" );
  } } );
  myMovie.bind( MediaPlayerEventType.MEDIA_STATE_CHANGED, new Runnable() { public void run() {
    println( "state changed" );
  } } );
}
  
// END
