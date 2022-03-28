/**********
 Name: Brian Kim
 Course: IM-UH 3313 Robota Psyche
 Final Project: Ecology of Pond
 Date:
 
 Things to add:
 - reproduction
 - too much food is not good for you
 - introduce another creature
 
 Change log:
 - Mar 28 - make a separate file with just the class in root repo
 - Mar 23 - copy midterm content, put everything in Ecosystem class
 **********/
 
class BriansEcosystem {
  /**********
   food class
   **********/
  class Food {
    float radius = 4;
    float gravity = 1;
    PVector location;

    //constructor
    Food(float x, float y) {
      location = new PVector(x, y); //food is created inside mouseClicked()
    }

    //from class exercise
    PVector attract(Fish f) {
      PVector force = PVector.sub(location, f.location);
      float distance = force.mag();
      distance = constrain(distance, 5.0, 25.0);
      force.normalize();
      float strength = (gravity * radius * f.mass) / (distance * distance);
      force.mult(strength);
      return force;
    }

    //push and pop to not affect other styling
    void display() {
      push();
      fill(0);
      ellipse(location.x, location.y, radius*2, radius*2);
      pop();
    }
  }


  /**********
  fish class
  **********/
  class Fish {
    float mass = 10; //increased as fish eats food, decreased over time, consider this as radius
    float gravity = 0.01;

    //int timer; //switched hunger logic from timer to mass, but still kept in the code for reference
    PVector location;
    PVector velocity;
    PVector acceleration;

    // array for object trail - implemented in display()
    // source - https://hellocircuits.com/2013/10/08/simple-object-trails-in-processing/
    int numShapes = 20;
    int currentShape = 0; // counter
    float[] shapeX; // x coordinates
    float[] shapeY; // y coordinates
    float[] shapeA; // alpha values

    Fish() {
      location = new PVector(random(width), random(height)); // random so starting points are different
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      currentShape = 0;
      shapeX = new float[numShapes];
      shapeY = new float[numShapes];
      shapeA = new float[numShapes];
      //timer = millis();
    }

    // Newton's second law
    void applyForce(PVector force) {
      PVector f = PVector.div(force, mass);
      acceleration.add(f);
    }

    //class exercise
    PVector repel(Fish f) {
      PVector force = PVector.sub(location, f.location);
      float distance = force.mag();
      distance = constrain(distance, 5.0, 25.0);
      force.normalize();
      float strength = (gravity * mass * f.mass) / (distance * distance);
      force.mult(-strength); //-strength for repel
      return force;
    }

    //class exercise
    void update() {
      velocity.add(acceleration);
      velocity.limit(5); //limit the velocity's magnitude to 5
      location.add(velocity);
      acceleration.mult(0); // clear the acceleration each time
    }

    boolean eatCheck(Food f) {
      if (
        //horizontal check
        (location.x - mass <= f.location.x) && (location.x + mass >= f.location.x)
        &&
        //vertical check
        (location.y - mass <= f.location.y) && (location.y + mass >= f.location.y)
        ) {
        mass += 2; //small increase in mass for every food eaten

        //reset timer if fish eats food
        //timer = millis();
        return true;
      } else {
        return false;
      }
    }

    //it dies of starvation when mass is below a certain limit
    boolean diesHungry() {
      //int runtime = millis() - timer;
      //if (runtime >= 20000) { //20 seconds
      //  return true;
      //} else
      if (mass <= 5) { //it slowly thinned out
        return true;
      } else {
        return false;
      }
    }

    // source - https://hellocircuits.com/2013/10/08/simple-object-trails-in-processing/
    // leaves a water trail
    void display() {
      push();

      shapeX[currentShape] = location.x;
      shapeY[currentShape] = location.y;
      shapeA[currentShape] = 255; //alpha value

      for (int i=0; i<numShapes; i++) {
        // color
        if (mass <= 7) {
          fill(246, 70, 91, shapeA[i]); //hungry fish are shown as red
        } else {
          fill(255, shapeA[i]); //otherwise they are just white
        }
        shapeA[i] -= 255/numShapes; //for gradation for water trail

        // shape
        pushMatrix();
        translate(shapeX[i], shapeY[i]);
        rotate(velocity.heading());

        /*
      from Processing docs: A triangle is a plane created by connecting three points.
         The first two arguments specify the first point, the middle two arguments specify the second point, and the last two arguments specify the third point.
         */
        triangle(0, mass, 0, -mass, mass, 0); // eating food increases fish's size (aka triangle)

        popMatrix();
      }

      currentShape++;     // increment counter
      currentShape %= numShapes;  // rollover counter to 0 when up to numShapes

      pop();

      mass -= 0.003; //decrease mass ever so slightly every time this function is called per frame
    }
  }
  
  
  /**********
   actual setup, draw, etc.
   **********/

  //use ArrayList for dynamic size - no need for NullPointerException handling
  //fishes and foods declared here - global variables
  ArrayList<Fish> fishes;
  ArrayList<Food> foods;

  //called at the beginning of a new session - first in the setup() and then in mouseClicked()
  //fishes and foods instantiated in here - new () called per session so the leftovers don't transfer to the next try
  void addFoodAndFish() {
    fishes = new ArrayList<Fish>();
    for (int i=0; i<10; i++) { //10 fish at the start
      fishes.add(new Fish());
    }

    foods = new ArrayList<Food>();
    for (int i=0; i<2; i++) { //2 food at the start
      foods.add(new Food(random(width), random(height)));
    }
  }

  void setup() {
    smooth();
    noStroke();
    addFoodAndFish();
  }

  //built-in function that responds to mouseClick event
  void mouseClicked() {
    // drop more food on mouse position
    if (fishes.size() > 0) {
      foods.add(new Food(mouseX, mouseY));
    }
    // restart
    else {
      addFoodAndFish();
    }
  }

  void draw() {
    //text settings
    fill(0);
    textSize(20);

    // no fish on the screen
    if (fishes.size() == 0) {
      // restart screen - looks "static" because there is nothing else on display
      textAlign(CENTER);
      text("No More Fish...", width/2, height/4);
      text("Try again? Click the mouse", width/2, height*3/4);
    }

    // there are fish on the screen
    else {
      //for every fish
      for (int i=0; i<fishes.size(); i++) {

        //fish repel each other
        for (int j=0; j<fishes.size(); j++) {
          if (i != j) { // do not repel yourself
            PVector fishForce = fishes.get(j).repel(fishes.get(i));
            fishes.get(i).applyForce(fishForce);
          }
        }

        //for every food
        for (int k=0; k<foods.size(); k++) {
          //food attracts fish
          PVector foodForce = foods.get(k).attract(fishes.get(i));
          fishes.get(i).applyForce(foodForce);

          //did this fish eat the food?
          boolean foodEaten = fishes.get(i).eatCheck(foods.get(k));
          if (foodEaten) foods.remove(k);
        }

        //update all forces and display fish
        fishes.get(i).update();
        fishes.get(i).display();

        //if fish doesn't eat in time...
        if (fishes.get(i).diesHungry()) {
          fishes.remove(i);
        }
      }

      //display food
      for (int k=0; k<foods.size(); k++) {
        foods.get(k).display();
      }

      //text should be on top of the fish and food so they come after the display()
      textAlign(LEFT);
      text("Click to drop food for the fish", width/8, height/12);
      textAlign(RIGHT);
      text(fishes.size() + " fish left", width*7/8, height/12);
    }
  }
}
