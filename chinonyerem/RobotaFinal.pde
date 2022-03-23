/*
 Chinonyerem Ukaegbu
 Final Project
 "Unnamed"
 23 March, 2022
 */

class ChinonyeremsEcosystem {
  //initial size of the respective array lists
  int initial_zoink = 100;
  int initial_food = 1;
  int initial_jeeper = 2;
  int initial_jinkie = 10;

  ArrayList<Zoink> zoinks = new ArrayList<Zoink>();
  ArrayList<Food> foods = new ArrayList<Food>();
  ArrayList<Jeeper> jeepers = new ArrayList<Jeeper>();
  ArrayList<Jinkie> jinkies = new ArrayList<Jinkie>();
  Incubator incubator;

  void setup() {
    size(1400, 800);

    // initialize zoinks
    for (int i = 0; i < initial_zoink; i++) {
      zoinks.add(new Zoink(random(width-200), random(500, height))); //the zoinks spawn close to each other rather than spread apart
    }

    //initialize food
    for (int i = 0; i < initial_food; i++) {
      foods.add(new Food());
    }

    //initialize jeepers
    for (int i = 0; i < initial_jeeper; i++) {
      jeepers.add(new Jeeper(1.5, 
        random(width), random(height)));
    }

    //initialize jinkies
    for (int i = 0; i < initial_jinkie; i++) {
      jinkies.add(new Jinkie(1.5, 
        random(width), random(height)));
    }

    //initialize incubator
    incubator = new Incubator((width-100), (height-500));
  }

  void draw() {
    background(2, 7, 20);

    //displays population sizes
    displayPopulation();

    //displays incubator and activates breeding
    incubator.breed();

    //for each food
    for (int i = 0; i < foods.size(); i++) {
      foods.get(i).update();
      foods.get(i).checkEdges();
      foods.get(i).display();
    }

    //for each zoink
    for (int i=0; i<zoinks.size(); i++) {
      for (int j=0; j<foods.size(); j++)
      {
        //Path following and separation are worked on in this function
        zoinks.get(i).applyBehaviors(zoinks, foods.get(j));

        zoinks.get(i).eat(foods.get(j));
      }

      // Call the generic run method (update, borders, display, etc.)
      zoinks.get(i).update();
      zoinks.get(i).checkEdges();
      zoinks.get(i).display();
    }

    //Every 5 seconds, if there is no food on the screen, add 1;
    if (frameCount%300 == 0)
    {
      if (foods.size()==0)
      {
        foods.add(new Food());
      }
    }

    //for each jeeper
    for (int i = 0; i < jeepers.size(); i++) {

      // Now apply the force from all the other jeepers on this jeeper
      for (int j = 0; j < jeepers.size(); j++) {
        // Don’t repel yourself!
        if (i != j) {
          PVector force = jeepers.get(j).repel(jeepers.get(i));
          jeepers.get(i).applyForce(force);
        }
      }

      jeepers.get(i).update();
      jeepers.get(i).checkEdges();
      jeepers.get(i).display();

      //check if jeeper can eat any zoink around
      for (int j = 0; j < zoinks.size(); j++) {
        jeepers.get(i).eat(zoinks.get(j));
      }
    }

    // for each jinkie
    for (int i = 0; i < jinkies.size(); i++) {

      // repel the jeepers
      for (int j = 0; j < jeepers.size(); j++) {
        PVector force = jinkies.get(i).repel(jeepers.get(j));
        jeepers.get(j).applyForce(force);
      }

      jinkies.get(i).update();
      jinkies.get(i).checkEdges();
      jinkies.get(i).display();

      // check if jinkie can feed from any zoink around
      for (int j = 0; j < zoinks.size(); j++) {
        jinkies.get(i).feedFrom(zoinks.get(j));
      }
    }

    // sets stored food of the jinkies back to default after certain time period
    resetFeeding();

    // Instructions
    fill(255);
    text("Click to add more food. You can have no more than 2 at a time", 10, height-16);
  }


  void mouseClicked() {
    if (foods.size()<2) //limits amount of food on screen to 2
    {
      foods.add(new Food(mouseX, mouseY)); //add food on mouse click
    }
  }

  // every 20 seconds, reset food variables of jinkies to default
  void resetFeeding() {
    if (frameCount%1200 == 0)
    {
      for (int i = 0; i < jinkies.size(); i++) {
        jinkies.get(i).stored_food=5;
        jinkies.get(i).can_feed=true;
      }
    }
  }

  // display population of each creature
  void displayPopulation() {
    fill(255);
    text("Zoinks: "+zoinks.size(), 20, 50);
    text("Jinkies: "+jinkies.size(), 20, 70);
    text("Jeepers: "+jeepers.size(), 20, 90);
    text("Food: "+foods.size(), 20, 110);
  }



  class Zoink {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce;    // Maximum steering force
    float maxspeed;    // Maximum speed
    int stored_food = 10; // amount of food each zoink stoes
    boolean store_empty = true; // zoink can only eat the food particles if the store is empty. Max capacity is 50 (10 (initial capacity)+40(amount gotten from eating one particle))
    boolean breedable = true; //variable to check if zoink has been in the incubator before

    // Constructor initialize all values
    Zoink(float x, float y) {
      location = new PVector(x, y);
      r = 12;
      maxspeed = 2; //previously 3
      maxforce = 0.2;
      acceleration = new PVector(0, 0);
      velocity = new PVector(0, 0);
    }

    void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
    }

    //function to apply both seeking and separating force so zoinks follow the food particles but are separated from one another
    void applyBehaviors(ArrayList<Zoink> zoinks, Food f) {
      PVector separateForce = separate(zoinks);
      PVector seekForce = seek(new PVector(f.location.x, f.location.y));
      separateForce.mult(2);
      seekForce.mult(1);
      applyForce(separateForce);
      applyForce(seekForce);
    }

    // A method that calculates a steering force towards a target
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector target) {
      PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target

      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);  // Limit to maximum steering force

      return steer;
    }

    // Separation
    // Method checks for nearby zoinks and steers away
    PVector separate (ArrayList<Zoink> zoinks) {
      float desiredseparation = r*3; //previously r*2
      PVector sum = new PVector();
      int count = 0;
      // For every zoink in the system, check if it's too close
      for (Zoink other : zoinks) {
        float d = PVector.dist(location, other.location);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        sum.div(count);
        // Our desired vector is the average scaled to maximum speed
        sum.normalize();
        sum.mult(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
        sum.sub(velocity);
        sum.limit(maxforce);
      }
      return sum;
    }

    // Method to update location
    void update() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      location.add(velocity);
      // Reset acceleration to 0 each cycle
      acceleration.mult(0);
    }

    // method to display zoink
    void display() {
      // color changes depending on whether the store is empty or not
      if (store_empty==true)
      {
        fill(65, 82, 92);
      } else
      {
        fill(184, 190, 25);
      }
      stroke(0);
      pushMatrix();
      translate(location.x, location.y);
      ellipse(0, 0, r, r);
      fill(255);
      text(stored_food, r, -r); // text showing how much food each zoink is storing
      popMatrix();
    }

    //if zoink reaches the edge, it reappears on the opposite boundary
    void checkEdges() {
      if (location.x > width) {
        location.x = 0;
      } else if (location.x < 0) {
        location.x = width;
      }

      if (location.y > height) {
        location.y = 0;
      } else if (location.y < 0) {
        location.y = height;
      }
    }

    // If the zoink collides with the food, it will eat it
    void eat(Food f) {
      if (dist(location.x, location.y, f.location.x, f.location.y)<(r+f.mass))
      {
        if (store_empty==true)
        {
          f.nutrient-=40; // decrements nutrient counter of food
          store_empty=false;
          stored_food+=40;
        }
        if (f.nutrient<=0) //if two different zoinks collide with a food particle, they each decrement 40 from the nutrient counter and since each food has a nutrient value of 80, it is removed from the array list
        {
          foods.remove(f);
        }
      }
    }
  }

  class Food {

    float mass;
    PVector location;
    float G;
    int nutrient = 80;

    Food() {
      location = new PVector(random(20, width-20), random(0, 40));
      mass = 20; // Big mass so the force is greater than zoink-zoink force
      G = 0.4;
    }

    Food(int _x, int _y) {
      // Will be updated to the mouse location
      //location = new PVector(0,0);
      location = new PVector(_x, _y);

      // Big mass so the force is greater than vehicle-vehicle force
      // You can play with this number to see different results
      mass = 20;
      G = 0.4;
    }

    // Food particles move downwards
    void update() {
      location.y+=1;
    }

    void display() {
      stroke(0);
      fill(201, 169, 166);
      ellipse(location.x, location.y, mass*2, mass*2);
    }

    //if food reaches the edge, it reappears on the opposite boundary
    void checkEdges() {
      if (location.x > width) {
        location.x = 0;
      } else if (location.x < 0) {
        location.x = width;
      }

      if (location.y > height) {
        location.y = 0;
      } else if (location.y < 0) {
        location.y = height;
      }
    }
  }


  class Jeeper {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float mass;
    float G = 0.4;

    Jeeper(float _mass_, float _x_, float _y_) {
      mass = _mass_;
      location = new PVector(_x_, _y_);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
    }

    // Newton’s second law.
    void applyForce(PVector force) {
      // Receive a force, divide by mass, and add to acceleration.
      PVector f = PVector.div(force, mass);
      acceleration.add(f);
    }

    // The Jeeper now knows how to repel another Jeeper.
    PVector repel(Jeeper j) {

      PVector force = PVector.sub(location, j.location);
      float distance = force.mag();
      distance = constrain(distance, 5.0, 25.0);
      force.normalize();
      force.mult(-.03);

      return force;
    }

    void update() {
      velocity.add(acceleration);
      location.add(velocity);
      acceleration.mult(0);
    }

    void display() {
      stroke(0);
      fill(99, 82, 163);
      // Rotate the jeeper to point in the direction of travel
      // Translate to the center of the shark
      pushMatrix();
      translate(location.x, location.y);
      rotate(velocity.heading());
      triangle(0, mass*17, 0, -(mass*17), mass*40, 0);
      popMatrix();
    }

    //if jeeper reaches the edge, it reappears on the opposite boundary
    void checkEdges() {
      if (location.x > width) {
        location.x = 0;
      } else if (location.x < 0) {
        location.x = width;
      }

      if (location.y > height) {
        location.y = 0;
      } else if (location.y < 0) {
        location.y = height;
      }
    }

    //If the jeeper collides with the zoink, it will eat it
    void eat(Zoink z) {
      //if (location.x >= z.location.x && location.x <= z.location.x+0.5)
      if (dist(location.x, location.y, z.location.x, z.location.y)<(25+z.r))
      {
        zoinks.remove(z);
      }
    }
  }

  class Jinkie {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float mass;
    float G = 0.4;
    int stored_food = 5;
    boolean can_feed = true;

    Jinkie(float _mass_, float _x_, float _y_) {
      mass = _mass_;
      location = new PVector(_x_, _y_);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
    }

    // Newton’s second law.
    void applyForce(PVector force) {
      // Receive a force, divide by mass, and add to acceleration.
      PVector f = PVector.div(force, mass);
      acceleration.add(f);
    }

    // The Jinkie now knows how to repel a Jeeper.
    PVector repel(Jeeper j) {

      PVector force = PVector.sub(location, j.location);
      float distance = force.mag();
      distance = constrain(distance, 10.0, 20.0);
      force.normalize();

      float strength = (G * mass * j.mass) / (distance * distance); //didn't use this value in the end
      force.mult(-.01);

      return force;
    }

    // Function to move jinkies vertically
    void update() {
      velocity.add(acceleration);
      location.add(velocity);
      acceleration.mult(0);
      location.y++;
    }

    void display() {
      stroke(0);
      // changes color depending on whether or not the jinkie can feed
      if (can_feed==true) {
        fill(164, 65, 56);
      } else {
        fill (199, 12, 71);
      }

      // Rotate the jinkie to point in the direction of travel
      // Translate to the center of the move
      pushMatrix();
      translate(location.x, location.y);
      rotate(velocity.heading());
      //triangle(0, mass*4, 0, -(mass*4), mass*19, 0);
      ellipse(0, 0, mass*4+5, mass*19);
      fill(255);
      text(stored_food, -mass*4, mass*19); //text displaying how much food the jinkie has
      popMatrix();
    }

    //if jinkie reaches the edge, it reappears on the opposite boundary
    void checkEdges() {
      if (location.x > width) {
        location.x = 0;
      } else if (location.x < 0) {
        location.x = width;
      }

      if (location.y > height) {
        location.y = 0;
      } else if (location.y < 0) {
        location.y = height;
      }
    }

    //function to feed from a zoink that it collides if the zoink's food level hasn't dropped below 10 and if the jinkie is able to feed
    void feedFrom(Zoink z) {
      if (dist(location.x, location.y, z.location.x, z.location.y)<((mass*8)+z.r))
      {
        if ((z.stored_food>10) && (can_feed==true)) {
          stored_food+=5;
          z.stored_food-=5;
          can_feed = false;
        }
      }
    }
  }

  class Incubator {
    PVector location;
    int counter;

    Incubator(float _x_, float _y_) {
      location = new PVector(_x_, _y_);
      counter = 0;
    }

    void display() {
      fill(192, 192, 192);
      rect(location.x, location.y, 100, 300);
    }

    void breed() {
      //default display
      if (counter==0)
      {
        display();
      }

      //For all the zoinks (only zoinks can reproduce)
      for (int i = 0; i<zoinks.size(); i++)
      {
        //if the zoink is in the incubator region and hasn't been there before, then increment the counter variable and set breedability of the zoink to false;
        //incubator is activated only if the population drops below 31
        if (zoinks.get(i).location.x >= location.x && zoinks.get(i).location.x <= location.x+100 && zoinks.get(i).location.y >= 300 && zoinks.get(i).location.y <= 600 && zoinks.get(i).breedable == true && zoinks.size()<=30)
        {
          counter++;
          zoinks.get(i).breedable = false;
          break;
        }
      }


      if (counter%2==0 && counter!=0) { //if 2 zoinks have been in the incubator one after the other (I'll refer to this as one 'iteration', a new tzoink is spawned and the color of the incubator changes to grey
        fill(192, 192, 192);
        rect(location.x, location.y, 100, 300);
        counter = 0;
        zoinks.add(new Zoink(random(width), random(height)));
      } else if (counter%2!=0 && counter!=0) { //if only 1 zoink has been in the incubator in that 'iteration' then the color of the incubator changes but 1 more zoink is needed for a new zoink to be spawned
        fill(81, 1, 160);
        rect(location.x, location.y, 100, 300);
      }
    }
  }
}
