// create objects for each ecosystem
adinasEcosystem system1 = new adinasEcosystem();


void setup(){
  size (1200, 800);
  system1.setup(); // call setup for each ecosystem
}

void draw() {
  background(200);
  system1.draw();// call draw for each ecosystem
}
