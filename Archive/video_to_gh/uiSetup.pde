void uiSetup(){
  
  // create a new button with name 'buttonA'
  cp5.addButton("Play")
     .setValue(0)
     .setPosition(10,width/2+30)
     .setSize(100,30)
     ;
  
  // and add another 2 buttons
  cp5.addButton("Pause")
     .setValue(100)
     .setPosition(120,width/2+30)
     .setSize(100,30)
     ;
     
  cp5.addButton("Restart")
     .setPosition(230,width/2+30)
     .setSize(100,30)
     .setValue(0)
     ;
     
     // create a new button with name 'buttonA'
  cp5.addButton("Trial Start")
     .setValue(0)
     .setPosition(10,width/2+70)
     .setSize(100,30)
     ;
     
     // create a new button with name 'buttonA'
  cp5.addButton("Trial End")
     .setValue(0)
     .setPosition(120,width/2+70)
     .setSize(100,30)
     ;
     
     // create a new button with name 'buttonA'
  cp5.addButton("Route A")
     .setValue(0)
     .setPosition(230,width/2+70)
     .setSize(100,30)
     ;
     
 cp5.addButton("Route B")
     .setValue(0)
     .setPosition(340,width/2+70)
     .setSize(100,30)
     ;

    
}
