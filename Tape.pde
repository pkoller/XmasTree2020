public class Tape {
  AudioRecorder recorder;
  AudioOutput out;
  FilePlayer player;
  FilePlayer startRecordingPlayer;
  FilePlayer stopRecordingPlayer;
  String saveFileName;
  
  boolean recorderIsSaved;
  
  public Tape(String saveFileName, String startFileName, String endFileName, AudioOutput out){
    this.saveFileName = saveFileName;
    
    this.out = out;
    
    startRecordingPlayer = new FilePlayer ( minim.loadFileStream(startFileName));
    startRecordingPlayer.patch(out);
    
    stopRecordingPlayer = new FilePlayer(minim.loadFileStream(endFileName));
    stopRecordingPlayer.patch(out);
  }
  
  public void record(AudioInput in){
    if ( recorder != null && recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    recorder = minim.createRecorder(in, saveFileName);
    recorder.beginRecord();
    
    startRecordingPlayer.rewind();
    startRecordingPlayer.play();
    recorderIsSaved = false;
  }
  
  public void endRecord(){
  if ( recorder != null && recorder.isRecording() ) 
    {
      recorder.endRecord();
      stopRecordingPlayer.rewind();
      stopRecordingPlayer.play();
    }
  }
  
  public void play(){
    
    // cleanup in case of new recording
    if(recorder != null && !recorderIsSaved)
    {
      if (player != null)
      {
        if(this.out != null)
          player.unpatch(this.out);
        player.close();
      }
      player = new FilePlayer( recorder.save() );
      
      recorderIsSaved = true;
    }
    
    if(player != null)
    {
      player.patch(out);
      player.rewind();
      player.skip(900);
      player.play(); 
    }
  }
  
  public void stop(){
     if(player != null)
       player.pause();
  }
}