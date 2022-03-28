// Import all the files from all the ecosystems

// create objects for each ecosystem
MichaelsEcosystem system1 = new MichaelsEcosystem();
//BriansEcosystem system2 = new BriansEcosystem();
ChinonyeremsEcosystem system3 = new ChinonyeremsEcosystem();

void setup(){
  size (1200, 800);
  system1.setup(); // call setup for each ecosystem
  system3.setup();
}


void draw() {
  background(200);
  system1.draw();// call draw for each ecosystem
  system3.draw();// call draw for each ecosystem
}

void mouseClicked() {
  system1.mouseClicked(); // call mouseClicked for each ecosystem
  system3.mouseClicked();
}
