 
void selectFile(File selection){
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    //println("User selected " + selection.getAbsolutePath());
    if(selection.isFile()) {
      Path path = Paths.get(selection.getAbsolutePath());
      BasicFileAttributes attr;
      try {
         attr = Files.readAttributes(path, BasicFileAttributes.class);
         creationTime = attr.creationTime();
         println("Creation time: " + creationTime);     
       
         
       
     
    } catch (IOException e) {
     System.out.println("oops un error! " + e.getMessage());
    }
    fileName = selection.getName();  
    
    movieFile = selection.getAbsolutePath();
    mov = new Movie(this, movieFile);
    
    //frameSize = width/mov.duration();
    // print( frameSize );
     
    //println(getLength()+" "+ mov.duration() +" "+mov.time());
    //movFrames = getLength();
    //movDuration = mov.duration();
    //movTime = mov.time();
    //frameDuration = 1.0 / mov.frameRate;
    println(mov.frameRate);
    // Pausing the video at the first frame. 
    //mov.play();
    //mov.jump(10);
    //mov.pause();
    
    createFile();
      
    }
   
  }
  
 
}
