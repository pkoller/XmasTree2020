class Decoration {
  
  Tape tape;
  
  AudioInput audioIn;
  AudioOutput audioOut;
  
  boolean isTouching;
  int lastTouchStart=0;
  
  boolean recording;
  
  public Decoration(String fileName, AudioInput audioIn, AudioOutput audioOut, String startFileName, String stopFileName){
    this.tape = new Tape(fileName, startFileName, stopFileName, audioOut);
    this.audioIn = audioIn;
    this.audioOut = audioOut;
  }
  
  public void UpdateTouching(boolean isTouching)
  {
    if(!this.isTouching && isTouching)
      touchStart();
    
    else if(this.isTouching && !isTouching)
      touchStop();
      
    if(isTouching)
      touch();
      
    this.isTouching = isTouching;
  }
  
  void touchStart()
  {
    lastTouchStart = millis();
    tape.play();
    println("start playing");
  }
  
  void touchStop()
  {
    int duration = millis() - lastTouchStart;
    
    if(recording)
    {
      recording = false;
      println("stop recording");
      tape.endRecord();
    }
    
    else
    {
      // TODO start playing 
      // println("start playing");
      // tape.play();
    }
  }
  
  void touch()
  {
    int duration = millis() - lastTouchStart;
    
    if (duration > 2000 && !recording)
    {
      println("record");
      recording = true;
      tape.stop();
      tape.record(audioIn);
    }
  }
}