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
//import VLCJVideo.*;
import VLCJVideo.*;
import processing.video.*;


//import uk.co.caprica.vlcj.player.events.MediaPlayerEventType;


ControlP5 cp5;
OscP5 oscP5;

VLCJVideo myMovie;

//VLCJVideo myMovie = null;
//Movie myMovie;

//Movie myMovie = null;
File selection;
int myMovieLength = 0;

int toolbar_y_offset = 40;
 
int x = 0;
int i = 0;

int myListeningPort = 32000;
int myBroadcastPort = 12000;

int units = 1000; // if using VLCJ time units come in milliseconds

NetAddress myRemoteLocation;

void setup() {
  // size should always be the 1st line in draw(): init
  size(640, 480); 
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
  b.changeItem("d","text","Backward");
  b.changeItem("e","text","Forward");

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
    case 3: // backward
      myMovie.setTime(myMovie.time() - 10*units);
      break;
    case 4: // forward 
      myMovie.setTime(myMovie.time() + 10*units);
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
     //myMovie.loop();
     myMovie.setRepeat(true);

 
    //float y = myMovie.time();
     
    textAlign(LEFT,CENTER);
    // " | Listening @ " + myListeningPort+
    // " | Streaming @ " + myBroadcastPort
    text("Timestamp (seconds):  " + round(myMovie.time()/1000) + " / " + (round(myMovie.duration())/1000) + 
    "  | (milliseconds):  " + round(myMovie.time()*1) + " / " + (round(myMovie.duration() * 1)), 10, 30);
    //text("Timestamp (ms):  " + round(myMovie.time()*1000) + " / " + (round(myMovie.duration() * 1000)), 10, 50);
        
    //noStroke();
    //fill(0);
    //rect(8, height - 20,  width -180, 15);
    
    fill(255);
    text("Press: SPACE to play/pause | LEFT / RIGHT to go +/- 10 seconds | ENTER to stop and restart", 10, height - 10);
    
     OscMessage myMessage = new OscMessage("/timestamp");
     myMessage.add(myMovie.time()); // convert timestamp to milliseconds
   
     // /* send the message */
      oscP5.send(myMessage, myRemoteLocation ); 

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
    //myMovie = new Movie(this, selection.getAbsolutePath());
    
    myMovie.open(selection.getAbsolutePath());
    myMovie.play();
    //myMovie.jump(10);
    //myMovie.pause();
  }
}
 
 //Called every time a new frame is available to read
//void movieEvent(Movie m) {
//  m.read();
//}


  
  void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage);
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals("/control/time")) {
    
    println(theOscMessage);
    
    //int moveTime =  Integer.valueOf(theOscMessage.get(0).stringValue());
    myMovie.setTime(myMovie.time()  + 1 * Integer.valueOf(theOscMessage.get(0).stringValue()));
    
  }
  else if (theOscMessage.addrPattern().equals("/control/slider")) {
    
    //int jumpTo =  Integer.valueOf(theOscMessage.get(0).stringValue());
    //float jumpToFrame = map(jumpTo, 0.0, 100.0, 0, myMovie.duration());
    
    //if( jumpToFrame < myMovie.duration() - 0.1) {
    //  myMovie.setTime(jumpToFrame);
    //}
    
    
    
  
    
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
    //myMovie.setVolume(myMovie.volume() + 0.1);
  }
  if(keyCode == DOWN) {
    //myMovie.setVolume(myMovie.volume() - 0.1);
  }
  if(keyCode == LEFT) {
    myMovie.setTime(myMovie.time() - 10*units);
  }
  if(keyCode == RIGHT) {
    myMovie.setTime(myMovie.time() + 10*units);
  }
}

void bindVideoEvents() {

  myMovie.bind( VLCJVideo.MediaPlayerEventType.BACKWARD, new Runnable() { public void run() {
    println("BACKWARD");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.BUFFERING, new Runnable() { public void run() {
    println("BUFFERING");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.ERROR, new Runnable() { public void run() {
    println("ERROR");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.FINISHED, new Runnable() { public void run() {
    println("FINISHED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.FORWARD, new Runnable() { public void run() {
    println("FORWARD");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.LENGTH_CHANGED, new Runnable() { public void run() {
    println("LENGTH_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.MEDIA_CHANGED, new Runnable() { public void run() {
    println("MEDIA_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.MEDIA_PLAYER_READY, new Runnable() { public void run() {
    println("MEDIA_PLAYER_READY");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.MUTED, new Runnable() { public void run() {
    println("MUTED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.OPENING, new Runnable() { public void run() {
    println("OPENING");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.PAUSABLE_CHANGED, new Runnable() { public void run() {
    println("PAUSABLE_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.PAUSED, new Runnable() { public void run() {
    println("PAUSED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.PLAYING, new Runnable() { public void run() {
    println("PLAYING");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.POSITION_CHANGED, new Runnable() { public void run() {
    println("POSITION_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.SEEKABLE_CHANGED, new Runnable() { public void run() {
    println("SEEKABLE_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.STOPPED, new Runnable() { public void run() {
    println("STOPPED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.TIME_CHANGED, new Runnable() { public void run() {
    println("TIME_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.TIME_CHANGED, new Runnable() { public void run() {
    println("TIME_CHANGED");
  } } );

  myMovie.bind( VLCJVideo.MediaPlayerEventType.VOLUME_CHANGED, new Runnable() { public void run() {
    println("VOLUME_CHANGED");
  } } );

//Any Event
  myMovie.bind( VLCJVideo.MediaPlayerEventType.ALL, new Runnable() { public void run() {
    //println( "ALL" );
  } } );
}
  
  
// END
