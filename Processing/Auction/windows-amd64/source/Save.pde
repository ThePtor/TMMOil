void savePlayers() {
  PrintWriter output = createWriter(dataPath + "save.txt");
  output.println("year"  + " " + year);
  for (int i = 0; i < Players.length; i ++) {


    output.println(Players[i].name + " " + "money"+ " " +Players[i].money);
    output.println(Players[i].name + " " + "horse"+ " " + Players[i].horse + " " + Players[i].horse2+ " " + Players[i].horsePrice);
    output.println(Players[i].name + " " + "tank"+ " " + Players[i].tank + " " + Players[i].tank2+ " " + Players[i].tankPrice);
    output.println(Players[i].name + " " + "rig"+ " " + Players[i].rig + " " + Players[i].rig2+ " " + Players[i].rigPrice);
    output.println(Players[i].name + " " + "silo"+ " " + Players[i].silo + " " + Players[i].silo2+ " " + Players[i].siloPrice);
    output.println(Players[i].name + " " + "search"+ " " + Players[i].search + " " + Players[i].search2+ " " + Players[i].searchPrice);
    output.println(Players[i].name + " " + "pipe"+ " " + Players[i].pipe + " " + Players[i].pipe2+ " " + Players[i].pipePrice);
    output.println(Players[i].name + " " + "searchBonus"+ " " + Players[i].searchBonus);
    output.println(Players[i].name + " " + "onColor"+ " " + Players[i].onR + " " + Players[i].onG + " " + Players[i].onB);
    output.println(Players[i].name + " " + "offColor"+ " " + Players[i].offR + " " + Players[i].offG + " " + Players[i].offB);
  }
  
  output.flush();
  output.close();
}
