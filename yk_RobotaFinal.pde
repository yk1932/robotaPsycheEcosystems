/*
 An environment wrapped in one big class
 
 Yeji Kwon
 
 Based on examples from The Nature of Code by Daniel Shiffman
 
 Change log:
 23 Mar 2022 - created
 
 This code is in the public domain
 */

class YejisEcosystem {

  /**************************************************************************
   The flow field class, more or less straight from the book
   with the addition of the display() function and different
   initialization options (each of which is from the book)
   **************************************************************************/

  //Ecosystem Midterm - Yeji Kwon

  // There are four entities

  // 1. Seabug: The smallest round entities that collide with each other and move randomly.
  // 2. Eels: They move in flocks and eat seabugs (Mouse pressing leads to reproducing eels)
  // 3. Whales: They move and eat eels. Whenever they eat 100 eels, they give birth.
  // 4. Diver Human: They move around according to the user pressing the keys WASD. Divers hunt for whales. 

  //Initialize Flock and arraylists of entities

  Flock flock;

  ArrayList<Seabug> seabugs;
  ArrayList<Whale> whales;
  ArrayList<Human> humans; //divers in the ocean
  ArrayList<Eel> eels; 

  //Counters for everytime entity gets eaten

  float counter = 0;
  float counterTwo = 0;
  float humanHuntWhale = 0;

  // Keypressed function WASD to move the diver (human)
  // Pressing a key changes the acceleration direction of the diver

  void keyPressed() {
    if (key == 'a') {
      println("left");
      humans.get(0).acceleration.x = -5;
    }
    if (key == 'd') {
      println("right");
      humans.get(0).acceleration.x = 5;
    }
    if (key == 'w') {
      println("up");
      humans.get(0).acceleration.y = -5;
    }
    if (key == 's') {
      println("down");
      humans.get(0).acceleration.y = 5;
    }
  }

  //Setup Function

  void setup() {

    //Size of canvas
    size(1500, 900);

    //Creating Entities

    //Flock of eels
    flock = new Flock();
    for (int i = 0; i < 10; i++) {
      Eel e = new Eel(width/2, height/2);
      flock.addEel(e);
    }

    // Fifty Seabugs
    seabugs = new ArrayList<Seabug>();
    for (int i = 0; i < 50; i++) {
      seabugs.add(new Seabug(random(width), random(height)));
    }

    // One Diver
    humans = new ArrayList<Human>();
    for (int i = 0; i < 1; i++) {
      humans.add(new Human(width/2, height/2));
    }

    //Ten Whales
    whales = new ArrayList<Whale>();
    for (int i = 0; i < 10; i++) {
      whales.add(new Whale(random(width), random(height)));
    }
  }

  //Draw Function

  void draw() {
    //Background set to black
    background(0);
    flock.run();

    //When eel collides with seabug, seabug is eaten (removed from array list)
    for (int i = 0; i<seabugs.size(); i++) {
      for (int k = 0; k<eels.size(); k++) {
        float d = dist(eels.get(k).position.x, eels.get(k).position.y, seabugs.get(i).position.x, seabugs.get(i).position.y);
        if (d < eels.get(k).r + seabugs.get(i).r) {
          counter += 1;
          seabugs.remove(i);
          seabugs.add(new Seabug(random(width), random(height)));
        }
      }
    }

    //When diver collides with whale, whale is killed (removed from array list)
    for (int i = 0; i<whales.size(); i++) {
      for (int k = 0; k<humans.size(); k++) {
        float d = dist(humans.get(k).position.x, humans.get(k).position.y, whales.get(i).position.x, whales.get(i).position.y);
        if (d < humans.get(k).r + whales.get(i).r-60) {
          whales.remove(i);
          humanHuntWhale += 1;
          whales.add(new Whale(random(width), random(height)));
        }
      }
    }

    //When whale collides with eel, eel is eaten (removed from array list)
    for (int k = 0; k<eels.size(); k++) {
      for (int w = 0; w<whales.size(); w++) {
        float d = dist(whales.get(w).position.x, whales.get(w).position.y, eels.get(k).position.x, eels.get(k).position.y);
        if (d < whales.get(w).r + eels.get(k).r - 30) {
          counterTwo += 1;
          eels.remove(k);
          eels.add(new Eel(-20, -20));
        }
      }
    }

    //When whales eats 100 eels, they give birth to more whales
    if (counterTwo % 100 == 0 && counterTwo != 0) {
      whales.add(new Whale(width/3, height/3));
    }

    //Seabug update
    for (Seabug s : seabugs) {
      s.separate(seabugs);
      s.update();
      s.borders();
      s.display();
    }

    //Whale update
    for (Whale w : whales) {
      // Path following and separation are worked on in this function
      w.separate(whales);
      // Call the generic run method (update, borders, display, etc.)
      w.update();
      w.borders();
      w.display();
    }

    //Human update
    for (Human h : humans) {
      // Path following and separation are worked on in this function
      h.separate(humans);
      // Call the generic run method (update, borders, display, etc.)
      h.update();
      h.borders();
      h.display();
    }

    // Instructions

    fill(255);
    text("Eels: "+int(eels.size()), 10, 20);
    text("Seabug: "+int(seabugs.size()), 10, 40);
    text("Divers: "+int(humans.size()), 10, 60);
    text("Whales: "+int(whales.size()), 10, 80);
    text("Click to produce more Eels!", 600, 20);
    text("Use WASD to move the diver!", 600, 40);
    text("Number of eels eaten by Whale: "+int(counterTwo), 1260, 20);
    text("Number of whales hunted by divers: "+int(humanHuntWhale), 1260, 40);
    text("Number of seabugs eaten by Eel: "+int(counter), 1260, 60);
  }

  // Add a new eel into the System by mouse drag
  void mouseDragged() {
    flock.addEel(new Eel(mouseX, mouseY));
  }

  // Flock Class

  class Flock {
    Flock() {
      eels = new ArrayList<Eel>(); // Initialize the ArrayList
    }

    void run() {
      for (Eel b : eels) {
        b.run(eels);  // Passing the entire list of eels to each eel individually
      }
    }

    void addEel(Eel b) {
      eels.add(b);
    }
  }

  //Eel Class

  class Eel {

    PVector position;
    PVector velocity;
    PVector acceleration;
    float r;
    float l;
    float maxforce;    // max steering force
    float maxspeed;    

    Eel(float x, float y) {
      acceleration = new PVector(0, 0);
      velocity = new PVector(random(-1, 1), random(-1, 1));
      position = new PVector(x, y);
      r = 3.0;
      l = 3.0; 
      maxspeed = 3;
      maxforce = 0.05;
    }

    void run(ArrayList<Eel> eels) {
      flock(eels);
      update();
      borders();
      render();
    }

    void applyForce(PVector force) {
      acceleration.add(force);
    }

    void flock(ArrayList<Eel> eels) {
      PVector sep = separate(eels);   
      PVector ali = align(eels);      
      PVector coh = cohesion(eels);   
      sep.mult(1.5);
      ali.mult(1.0);
      coh.mult(1.0);

      // Add the force vectors to acceleration
      applyForce(sep);
      applyForce(ali);
      applyForce(coh);
    }

    void update() {
      // velocity update
      velocity.add(acceleration);
      // speed limit
      velocity.limit(maxspeed);
      position.add(velocity);
      // acceleration reset to 0
      acceleration.mult(0);
    }

    // From Nature of Code
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector target) {
      PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      return steer;
    }

    void render() {
      // Draw a triangle rotated in the direction of velocity
      float theta = velocity.heading2D() + radians(90);
      noFill();
      //fill(175);
      stroke(255);
      pushMatrix();
      translate(position.x, position.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -r*10);
      vertex(-r, r*random(5, 30));
      vertex(r, r*random(5, 30));
      endShape();
      popMatrix();
    }

    // Wraparound
    void borders() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }

    // Separation
    // Method checks for nearby eels and steers away
    PVector separate (ArrayList<Eel> eels) {
      float desiredseparation = 35.0f;
      PVector steer = new PVector(0, 0, 0);
      int count = 0;
      // For every eel in the system, check if it's too close
      for (Eel other : eels) {
        float d = PVector.dist(position, other.position);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);        // Weight by distance
          steer.add(diff);
          count++;            // Keep track of how many
        }
      }
      if (count > 0) {
        steer.div((float)count);
      }

      // As long as the vector is greater than 0
      if (steer.mag() > 0) {
        // Implement Reynolds: Steering = Desired - Velocity
        steer.normalize();
        steer.mult(maxspeed);
        steer.sub(velocity);
        steer.limit(maxforce);
      }
      return steer;
    }

    // Alignment
    // For every nearby eel in the system, calculate the average velocity
    PVector align (ArrayList<Eel> eels) {
      float neighbordist = 50;
      PVector sum = new PVector(0, 0);
      int count = 0;
      for (Eel other : eels) {
        float d = PVector.dist(position, other.position);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.velocity);
          count++;
        }
      }
      if (count > 0) {
        sum.div((float)count);
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        return steer;
      } else {
        return new PVector(0, 0);
      }
    }

    // Cohesion
    // For the average position (i.e. center) of all nearby eels, calculate steering vector towards that position
    PVector cohesion (ArrayList<Eel> eels) {
      float neighbordist = 50;
      PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
      int count = 0;
      for (Eel other : eels) {
        float d = PVector.dist(position, other.position);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.position); // Add position
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        return seek(sum);  // Steer towards the position
      } else {
        return new PVector(0, 0);
      }
    }
  }

  // Class Whale

  class Whale {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;    // Maximum steering force
    float maxspeed;    // Maximum speed

    // code for attraction
    float mass;
    float G;
    // Constructor initialize all values
    Whale(float x, float y) {
      position = new PVector(x, y);
      r = random(100, 150);
      maxspeed = 0.2;
      maxforce = 0.6;
      acceleration = new PVector(0, 0);
      velocity = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    // Separation
    // Method checks for nearby seabugs and steers away
    void separate (ArrayList<Whale> whales) {
      float desiredseparation = r*5;
      PVector sum = new PVector();
      int count = 0;
      // For every seabug in the system, check if it's too close
      for (Whale other : whales) {
        float d = PVector.dist(position, other.position);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        // Our desired vector is moving away maximum speed
        sum.setMag(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        applyForce(steer);
      }
    }

    // Method to update position
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      position.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    void display() {
      fill(#131417);
      pushMatrix();
      stroke(100);
      translate(position.x, position.y);
      ellipse(0, 0, r, r);
      popMatrix();
    }


    // Wraparound
    void borders() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }
  }


  //Class Seabug

  class Seabug {

    PVector position;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;    // Maximum steering force
    float maxspeed;    // Maximum speed

    // code for attraction
    float mass;
    float G;

    // Constructor initialize all values
    Seabug(float x, float y) {
      position = new PVector(x, y);
      r = 10;
      maxspeed = 5;
      maxforce = 0.6;
      acceleration = new PVector(1, 1);
      velocity = new PVector(0, 0);
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    // Separation
    // Method checks for nearby seabugs and steers away
    void separate (ArrayList<Seabug> seabugs) {
      float desiredseparation = r*2;
      PVector sum = new PVector();
      int count = 0;
      // For every seabug in the system, check if it's too close
      for (Seabug other : seabugs) {
        float d = PVector.dist(position, other.position);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        // Our desired vector is moving away maximum speed
        sum.setMag(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        applyForce(steer);
      }
    }


    // Method to update position
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      position.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    void display() {
      noFill();
      pushMatrix();
      stroke(100);
      translate(position.x, position.y);
      ellipse(0, 0, r, r);
      popMatrix();
    }


    // Wraparound
    void borders() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }
  }

  // Class Human

  class Human {

    PVector position;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;    // Maximum steering force
    float maxspeed;    // Maximum speed

    // code for attraction
    float mass;
    float G;

    // Constructor initialize all values
    Human(float x, float y) {
      position = new PVector(x, y);
      r = 15;
      maxspeed = 2;
      maxforce = 0.6;
      acceleration = new PVector(0, 0);
      velocity = new PVector(0, 0);
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    // Separation
    // Method checks for nearby seabugs and steers away
    void separate (ArrayList<Human> humans) {
      float desiredseparation = r*2;
      PVector sum = new PVector();
      int count = 0;
      // For every seabug in the system, check if it's too close
      for (Human other : humans) {
        float d = PVector.dist(position, other.position);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        // Our desired vector is moving away maximum speed
        sum.setMag(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        applyForce(steer);
      }
    }


    // Method to update position
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      position.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    void display() {
      fill(255);
      pushMatrix();
      stroke(100);
      translate(position.x, position.y);
      ellipse(0, 0, r, r);
      popMatrix();
    }


    // Wraparound
    void borders() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }
  }
}
