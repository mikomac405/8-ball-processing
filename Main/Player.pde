class Player{
  String name;
  int group;
  int ballsInPits;
   
  Player(String name){
    this.name = name;
    this.group = 0;
    this.ballsInPits = 0;
  };
  
  String toString(){
    String gr;
    if(this.group == 1){
      gr = "solids";
    }
    else if(this.group == 2){
      gr = "stripes";
    }
    else{
      gr = "NONE";
    }
    return String.format("%s | group: %s | hits: %d", this.name, gr, this.ballsInPits);
  }
}
