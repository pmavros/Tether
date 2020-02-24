 /**
 * Streaming Frame info to Grasshopper
 * by Panos Mavro, Future Cities Laboratory. 
 * 
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

import VLCJVideo.*;

import uk.co.caprica.vlcj.*;


OscP5 oscP5;
VLCJVideo myMovie = null;

//Movie myMovie = null;
File selection;
int myMovieLength = 0;
 
int x = 0;
int i = 0;

int myListeningPort = 32000;
int myBroadcastPort = 12000;

// how much to jump forward or backward
int timeStep = 10000; // in millis

NetAddress myRemoteLocation;

void setup() {
  // size should always be the 1st line in draw(): init
  size(640, 480); 
  
  oscP5 = new OscP5(this, myListeningPort);
  myRemoteLocation = new NetAddress("127.0.0.1", myBroadcastPort);
  
   myMovie = new VLCJVideo(this);
  
  
  // set default path for fileSelected
  selection = new File(dataPath("") + "//*");
  // start callback function 
  selectInput("Select a file to process:", "fileSelected", selection);
}

 
void draw() {
  
  background(0);
  // check whether the movie is already loaded
  if (myMovie != null && myMovie.width > 0) {
    
  //    float n = map(mouseX, 0.0, width, 0.0, 100.0);
  //  setFrame(n);
  
    // load success 
    image(myMovie, 0, 0, width, height);
     //myMovie.loop();
 
    float y = myMovie.time();
 
    //println("time = " + myMovie.time());
    //println("duration = " + myMovie.duration());
    
    textAlign(LEFT);
    
    text("Time (secs):  " + round(myMovie.time()/1000) + " / " + (round(myMovie.duration()/1000)), 10, 10);
    text("Timestamp (ms):  " + round(myMovie.time()) + " / " + (round(myMovie.duration())), 10, 30);
    text("Volume " + myMovie.volume(), 10, height - 30);
    text("Press: SPACE to play/pause | LEFT / RIGHT to go +/- 10 seconds | ENTER to stop and restart", 10, height - 10);

    
    
     OscMessage myMessage = new OscMessage("/timestamp");
     myMessage.add(myMovie.time()*1000); // convert timestamp to milliseconds
     myMessage.add(map(myMovie.time(), 0, myMovie.duration(), 0, 100)); // convert timestamp to percent of movie time, i.e.  1 - 100
   
      /* send the message */
      oscP5.send(myMessage, myRemoteLocation ); 

    if (y > myMovie.duration() - 0.1) {
      //exit(); // QUIT
    } 
    //
  } else {
    // wait for callBack Function fileSelected
    textAlign(CENTER);
    text("Wait, I am loading the movie file", width/2, height/2);
  } // else
} // func
 
// --------------------------------------------------
 
void fileSelected(File selection) 
{
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();  // QUIT
  } else {
    
    myMovie.open(selection.getAbsolutePath());
    myMovie.play();
    myMovie.setTime(1000); // set starting time in millis
    myMovie.pause();
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
    
    myMovie.setTime(myMovie.time()  + 1 * Integer.valueOf(theOscMessage.get(0).stringValue()));
    
  }
  else if (theOscMessage.addrPattern().equals("/control/slider")) {
    
    int jumpTo =  Integer.valueOf(theOscMessage.get(0).stringValue());
    int jumpToFrame = int ( map(jumpTo, 0.0, 100.0, 0, myMovie.duration()) );
    
    if( jumpToFrame < myMovie.duration() - 1) {
     myMovie.setTime(jumpToFrame);
    } 
    
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
    
    if(myMovie.volume() < 200) {
      int vol = myMovie.volume() + 10;
      myMovie.setVolume(vol);
    }
  }
  
  if(keyCode == DOWN) {
    if(myMovie.volume() > 0) {
      int vol = myMovie.volume() - 1;
      myMovie.setVolume(vol); 
    }
  }
  
  if(keyCode == LEFT) {
    myMovie.setTime(myMovie.time() - timeStep);
  }
  
  if(keyCode == RIGHT) {
    myMovie.setTime(myMovie.time() + timeStep);
  }
  
}

  
// END
