class EhtishamsEcosystem {
  float houseSize;
  float legendSize;
  ArrayList<Mouse> mice = new ArrayList<Mouse>();
  ArrayList<PVector> housePoints = new ArrayList<PVector>(); //house is represented by a rectangle. There is a list of points at house and mouse can seek the closest when outside
  CatFlowField flowField;
  Cat cat;
  ArrayList<Food> food = new ArrayList<Food>();
  int miceInHouse;
  int houseOccupancy;
  int lastSpawnTime = 0; //used by spawnNewFood function to spawn food in room after certain time
  //---------------------------------------------------------------------------------//
  //setup
  //---------------------------------------------------------------------------------//
  void setup() {
    houseOccupancy = 150;
    houseSize = 200;
    legendSize = 100;

    for (int i = 0; i < 10; i++) { //start with 10 mice
      mice.add(new Mouse(random(width), random(houseSize), null, null));
    }

    //let's create 3 points in the house which mice can seek
    housePoints.add(new PVector(200, 100)); // a point on the left of the house
    housePoints.add(new PVector(width/2, 100)); // a point on the center of the house
    housePoints.add(new PVector(width - 200, 100)); // a point on the right of the house

    flowField = new CatFlowField(15);
    cat = new Cat(random(50, width-50), random(houseSize+50, height-(legendSize+50)));
    frameRate(60);
  }
  //---------------------------------------------------------------------------------//
  //draw
  //---------------------------------------------------------------------------------//
  void draw() {
    fill(175, 200);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, houseSize); //draw house

    //Below function call is commented in order to give us more control of food to observe various aspects of the simulation. Simply uncomment if you just want to see and not interact.
    //spawnNewFood();

    for (int i = 0; i < food.size(); i++) { //Display food
      food.get(i).display();
    }

    for (int i = 0; i < mice.size(); i++) {
      mice.get(i).update(); //display is called by update method in Mouse class
      if (mice.get(i).lifeRemaining <= 0) {
        mice.remove(mice.get(i)); //Remove dead mice from arrayList
      }
    }

    miceInHouse = 0; //reset to zero in order to make the below loop function correctly
    for (int i = 0; i < mice.size(); i++) {
      if (mice.get(i).location.y <= houseSize) { //Find number of mice in house every frame
        miceInHouse += 1;
      }
    }

    cat.update();
    flowField.shiftField(); //change field direction randomly after some time to exhibit random movement of cat
    displayLegend();
  }
  //---------------------------------------------------------------------------------//
  //Display Legend: It displays all the informative text on screen
  //---------------------------------------------------------------------------------//

  void displayLegend() {
    fill(0);
    noStroke();
    rectMode(CORNER);
    rect(0, height-legendSize, width, legendSize);
    PFont algerian = createFont("algerian", 16);
    textFont(algerian);
    text ("Mice Home", 10, 20);
    if (miceInHouse >= 145) {
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    text ("Current Occupancy: " + miceInHouse, 10, 40);

    fill(0);
    text ("Room: ", 10, houseSize + 20);

    text ("Click anywhere inside the room to put", 20, houseSize + 40);
    fill(255, 170, 51);
    text ("food", 340, houseSize + 40);

    fill(0);
    text ("Cat is represented by gray triangle:", 20, houseSize + 60);
    text ("Black outline of triangle: Cat is normal", 40, houseSize + 80);
    fill(255, 0, 0);
    text ("Red", 40, houseSize + 100);
    fill(0);
    text ("outline of triangle: Cat is aggressive", 75, houseSize + 100);



    PFont georgia = createFont("georgia", 16);
    textFont(georgia);
    fill(0, 255, 255);
    text ("Life Remaining - Indicated by a Rectangle:", 20, height-(legendSize-20));
    fill(0, 255, 0);
    text ("Green: > 80 ", 40, height-(legendSize-40));
    fill(0, 100, 255);
    text ("Blue: > 30 and < 80 (reproduction occurs in blue)", 40, height-(legendSize-60));
    fill (255, 0, 0);
    text ("Red: < 30 ", 40, height-(legendSize-80));

    fill(0, 255, 255);
    text ("Hunger - Indicated by inner color of triangle:", width - 350, height-(legendSize-20));
    fill(0, 255, 0);
    text ("Green: < 50 ", width - 300, height-(legendSize-40));
    fill (255, 233, 0);
    text ("Yellow: > 50 and < 80", width - 300, height-(legendSize-60));
    fill (128, 0, 0);
    text ("Maroon: > 80 ", width - 300, height-(legendSize-80));

    fill (0, 255, 255);
    text ("Gender - Indicated by triangle's outline (stroke):", width/2 - 150, height-(legendSize-20));
    fill (255, 53, 184);
    text ("Pink: Female", width/2 - 100, height-(legendSize-50));
    fill (0, 0, 255);
    text ("Blue: Male", width/2 - 100, height-(legendSize-80));
  }

  //---------------------------------------------------------------------------------//
  //spawn new food
  //---------------------------------------------------------------------------------//
  // On call in draw function, this fucntion spawns new food on a random location after every 600 frames (10 seconds)
  void spawnNewFood() {
    if (frameCount - lastSpawnTime > 600) {
      float x = random(30, width-30);
      float y = random(houseSize+30, height-(legendSize+30));
      food.add(new Food(x, y));
      lastSpawnTime = frameCount;
    }
  }


  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  //Flow Field Class                    Flow Field Class                    Flow Field Class                    Flow Field Class                    Flow Field Class                    Flow Field Class
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

  class CatFlowField {

    PVector[][] field;
    int cols, rows;
    int pixelsPerSquare; // Size of each square in the grid, in pixels
    float fromAngle, toAngle;
    float fieldChangeTime;
    //---------------------------------------------------------------------------------//
    //CatFlowField Constructor
    //---------------------------------------------------------------------------------//
    CatFlowField(int _res) { // Constructor takes the desired resolution as argument
      pixelsPerSquare = _res;
      cols = width/pixelsPerSquare;
      rows = height/pixelsPerSquare;
      // Declare the array of PVectors which will hold the field
      field = new PVector[cols][rows];
      fieldChangeTime = 0;
      newRandomField(); //makes new random field on start of the program
    }

    //---------------------------------------------------------------------------------//
    //Update Flowfield
    //---------------------------------------------------------------------------------//
    //Makes a perlin noise flow field from angle a to b
    //whenever called, this method updates the field based on angle a and b given in argument
    //Based on code from the The Nature of Code book

    void updateField(float a, float b) {
      float xoff = 0;
      for (int i = 0; i < cols; i++) {
        float yoff = 0;
        for (int j = 0; j < rows; j++) {

          // Moving through the noise() space in two dimensions
          // and mapping the result to an angle between 0 and 360
          float theta = map(noise(xoff, yoff), 0, 1, a, b);

          // Convert the angle (polar coordinate) to Cartesian coordinates
          field[i][j] = new PVector(cos(theta), sin(theta));

          // Move to neighboring noise in Y axis
          yoff += 0.1;
        }
        // Move to neighboring noise in X axis
        xoff += 0.1;
      }
    }

    //---------------------------------------------------------------------------------//
    //New Random Field
    //---------------------------------------------------------------------------------//
    //The following method assigns a new random flow field for the cat by calling updateField() and giving arguments to generate a flowfield in 1 of 4 directions randomly
    void newRandomField() {
      //using ceil() instead of round() so that every number from 1 to 4 gets equal chance. Function round() would give less chance to 1 and 4.
      int newField = ceil(random(0.1, 4)); //0.1 is inclusive and 4 is exclusive, so equal chance to each number

      if (newField == 1) {
        updateField(0, PI); // 0 degrees to 180 degrees (mainly skewed towards bottom)
      } else if (newField == 2) {
        updateField(PI/2, 1.5*PI);  // 90 degrees to 270 degrees (mainly skewed towards left)
      } else if (newField == 3) {
        updateField(1.5*PI, 2.5*PI); // 270 degrees to 450 degrees (mainly skewed towards right)
      } else {
        updateField(PI, 2*PI);  // 180 degrees to 360 degrees (mainly skewed towards top)
      }
    }
    //---------------------------------------------------------------------------------//
    //Lookup
    //---------------------------------------------------------------------------------//
    // Given a PVector which defines a location in the flow field,
    // return a copy of the value of the flow field at that location
    //Based on code from The Nature of Code
    PVector lookup(PVector lookup) {
      // Convert x and y values to row and column, and constrain
      // to stay within the field
      int column = int(constrain(lookup.x/pixelsPerSquare, 0, cols-1));
      int row = int(constrain(lookup.y/pixelsPerSquare, 0, rows-1));

      return field[column][row].copy();
    }
    //---------------------------------------------------------------------------------//
    //Shift Field
    //---------------------------------------------------------------------------------//
    //This method is called in draw function. It calls newRandomField function to randomly change the direction of flowfield after every 300 frames
    void shiftField() {
      if ( frameCount - fieldChangeTime > 300) {
        newRandomField();
        fieldChangeTime = frameCount;
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  //Cat class             Cat class             Cat class             Cat class             Cat class             Cat class             Cat class             Cat class             Cat class
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  class Cat {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float size;
    float maxforce;
    float maxspeed;
    float minWallDistance; //distance from wall where cat starts shifting direction
    float detectionRange; //distance from mouse where cat detects it and starts chasing
    Mouse closestMouse;
    float closestMouseDistance;
    float lastMouseEatTime;

    //Following array stores frame counts at last field on projected collision (of cat) with different walls. Used in boundaries() method.
    //Since cat doesn't immediately moves away from a wall, this array will help us to prevent cat from shaking due to continous change in flowfield's direction.
    int[] lastFieldChange = new int[4];

    //---------------------------------------------------------------------------------//
    //Cat Constructor
    //---------------------------------------------------------------------------------//
    Cat(float x, float y) { //Constructor
      acceleration = new PVector(0, 0);
      velocity = new PVector(0, 0);
      location = new PVector(x, y);
      maxspeed = 2;
      maxforce = 0.1;
      detectionRange = 300;
      size = 30;
      minWallDistance = 100;
      closestMouse = null;
      closestMouseDistance= 100000; //very large number so that we can compare it with distances from mouse instances and assign it the distance to closest mouse
      lastMouseEatTime = 0;

      //initialize all items of the array to zero
      for (int i = 0; i < 4; i++) {
        lastFieldChange[i] = 0; // left wall count would be assigned at 0th index, right to 1st, top to 2nd and bottom to 3rd.
      }
    }

    //---------------------------------------------------------------------------------//
    //Update
    //---------------------------------------------------------------------------------//

    // Update the velocity and location, based on the acceleration generated by the steering force
    // Calls all the functions that needs to be called every frame (since it is being called in draw itself)
    void update() {
      display();
      velocity.add(acceleration);
      velocity.limit(maxspeed);
      location.add(velocity);
      acceleration.mult(0); // reset acceleration for the next frame
      boundaries();
      findClosestMouse();
      roamOrCatch();
      checkMouseCaught();
    }

    //---------------------------------------------------------------------------------//
    //Find Closest Mouse
    //---------------------------------------------------------------------------------//
    //Finds closest mouse outside of the mice house
    void findClosestMouse() {
      closestMouseDistance= 100000; //initialized to a very large value to help us in comparison. Resets every frame to find correct distance every frame.
      closestMouse = null; //Resets every frame to find closest mouse every frame.
      for (int i = 0; i < mice.size(); i++) {
        if (mice.get(i).lifeRemaining > 0 && mice.get(i).location.y > houseSize) {
          float distance = location.dist(mice.get(i).location);
          if (distance < closestMouseDistance) {
            closestMouseDistance = distance;
            closestMouse = mice.get(i);
          }
        }
      }
    }

    //---------------------------------------------------------------------------------//
    //Roam or Catch
    //---------------------------------------------------------------------------------//
    //Decides whether to roam around the room or catch a mouse based on detection range
    //Decides at what speed to move in either situations (based on last mouse eat time)

    void roamOrCatch() {
      //if closest mouse is outside house and in range
      if (closestMouse != null && closestMouse.distanceFromCat < detectionRange && closestMouse.location.y > houseSize) {
        //Catch Mouse:
        if ((frameCount - lastMouseEatTime) > 500) { //Cat gets faster and aggressive if no mouse eaten in 500 frames
          maxspeed = 8;
          maxforce = 2;
          detectionRange = 500;
        } else {
          maxspeed = 5;
          maxforce = 1;
          detectionRange = 300;
        }
        seek(closestMouse);
      } else {
        //Roam Around the room
        if ((frameCount - lastMouseEatTime) > 500) {
          maxspeed = 4;
          maxforce = 0.5;
          detectionRange = 500;
        } else {
          maxspeed = 2;
          maxforce = 0.1;
          detectionRange = 400;
        }
        follow(flowField);
      }
    }

    //---------------------------------------------------------------------------------//
    //Check collision with mouse
    //---------------------------------------------------------------------------------//
    //checks whether a mouse is caught outside house

    void checkMouseCaught() {
      for (int i = 0; i < mice.size(); i++) {
        Mouse curr = mice.get(i);
        if (curr.location.y > 200) {
          if ((curr.location.x <= location.x+size && curr.location.x >= location.x-size) && (curr.location.y + curr.size <= location.y+(size*2) && curr.location.y + curr.size >= location.y-(size*2))) {
            mice.get(i).lifeRemaining = 0; //we don't need to remove it from arrayList here. We are doing that in draw function already.
            lastMouseEatTime = frameCount;
          }
        }
      }
    }

    //---------------------------------------------------------------------------------//
    //Boundaries
    //---------------------------------------------------------------------------------//

    //The following method ensures that the cat stays inside the room. When a cat is about to hit a wall, its flow field changes to the other direction

    void boundaries() {
      if (location.x < minWallDistance) { //Left Wall
        if (frameCount - lastFieldChange[0] > 30) { //give a second to cat to increase its distance from this wall before chnaging the flow field again
          flowField.updateField(1.5*PI, 2.5*PI); // 270 degrees to 450 degrees (mainly skewed towards right)
          lastFieldChange[0] = frameCount;
        }
      } else if (location.x > width - minWallDistance) { //Right Wall
        if (frameCount - lastFieldChange[1] > 30) { //give a second to cat to increase its distance from this wall before chnaging the flow field again
          flowField.updateField(PI/2, 1.5*PI); // 90 degrees to 270 degrees (mainly skewed towards left)
          lastFieldChange[1] = frameCount;
        }
      }

      if (location.y < (minWallDistance + houseSize)) { //Top Wall
        if (frameCount - lastFieldChange[2] > 30) { //give a second to cat to increase its distance from this wall before chnaging the flow field again
          flowField.updateField(0, PI);  // 0 degrees to 180 degrees (mainly skewed towards bottom)
          lastFieldChange[2] = frameCount;
        }
      } else if (location.y > height - (minWallDistance + legendSize)) { //Bottom Wall
        if (frameCount - lastFieldChange[3] > 30) { //give a second to cat to increase its distance from this wall before chnaging the flow field again
          flowField.updateField(PI, 2*PI);  // 0 degrees to 180 degrees (mainly skewed towards top)
          lastFieldChange[3] = frameCount;
        }
      }
    }

    //---------------------------------------------------------------------------------//
    //Apply Force
    //---------------------------------------------------------------------------------//
    void applyForce(PVector force) {
      acceleration.add(force);
    }
    //---------------------------------------------------------------------------------//
    //Seek Mouse
    //---------------------------------------------------------------------------------//

    //Calculate steering force to seek a target mouse
    //Based on code from The Nature of Code book
    void seek(Mouse target) {
      PVector desired = PVector.sub(target.location, location);
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }

    //---------------------------------------------------------------------------------//
    //Follow Flowfield
    //---------------------------------------------------------------------------------//
    //Calculate the steering force to follow a flow field
    //Based on code from The Nature of Code book
    void follow(CatFlowField flow) {
      // Look up the vector at that spot in the flow field
      PVector desired = flow.lookup(location);
      desired.mult(maxspeed);
      // Steering is desired minus velocity
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }

    //---------------------------------------------------------------------------------//
    //Display Cat
    //---------------------------------------------------------------------------------//

    void display() {
      fill (128, 137, 144);
      strokeWeight(4);
      if ((frameCount - lastMouseEatTime) > 500) {
        stroke(200, 0, 0); //aggressive cat is represented by red stroke
      } else {
        stroke(0);
      }
      //Draw a triangle rotated in the direction of velocity
      //Based on code from The Nature of Code book
      float theta = velocity.heading() + radians(90);
      pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -size*2);
      vertex(-size, size*2);
      vertex(size, size*2);
      endShape();
      popMatrix();
    }
  }

  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  //Mouse class            Mouse class            Mouse class            Mouse class            Mouse class            Mouse class            Mouse class            Mouse class            Mouse class
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

  class Mouse {

    PVector location;
    PVector velocity;
    PVector acceleration;
    float roamingSpeed; // mice casually roam at this speed when at home. More hungry and aggressive mice roam faster (check inTheHouse() method for more info)
    float roamingForce;
    float lifeRemaining;
    float hunger;
    char gender;
    boolean isFertile; //mouse can only reproduce during a certain timeframe in their lives
    float lastMatingTime; //used to determine when mouse can mate again
    Mouse parent1;
    Mouse parent2;
    float timePassed;
    float distanceFromCat;
    Food closestFood;
    float closestFoodDistance;
    PVector closestHousePoint;
    float closestPointDistance;
    Mouse closestPotentialMate;
    float closestMateDistance;
    Boolean seekingMate; //If mouse is seeking mate, it will seek food after mating

    // following attributes are used in separateFromCatAndWalls() method to make a mouse move in a certain direction (after turning from wall ) for some time before focusing solely on 
    // separating from the cat again. This is done to both avoid hitting a wall and getting caught by cat.
    float lastWallTurnTime;
    PVector velocityFromWall;

    //The following attributes depends on parents' attributes (or are set randomly at start of program):
    float size;
    float sizeIncreaseRate; //size of mouse increases until mouse has spent certain time in life
    float maxSpeed;
    float speedChangeRate; //speed of mouse increases until mouse has spent certain time in life
    float maxForce;
    float lifeDecreaseRate;
    float hungerIncreaseRate;

    //Since size and maxSpeed increases with time, we take these values at birth for inheritance in children
    float sizeAtBirth;
    float maxSpeedAtBirth;

    //---------------------------------------------------------------------------------//
    //Constructor
    //---------------------------------------------------------------------------------//
    Mouse(float x, float y, Mouse p1, Mouse p2) {
      acceleration = new PVector(0, 0);
      velocity = PVector.random2D(); //mice are always spawned/given birth in the house. So, they start with a random velocity there.
      location = new PVector(x, y);
      roamingSpeed = random(1, 2);
      roamingForce = 0.2;
      lifeRemaining = 100;
      hunger = 0;
      timePassed = 0;
      lastMatingTime = 0;
      parent1=p1;
      parent2=p2;

      // random gender
      if (ceil(random(0.1, 2)) == 1) {
        gender = 'M';
      } else {
        gender = 'F';
      }

      lastWallTurnTime= 0;
      velocityFromWall = null;
      seekingMate = false;

      //Inheriting attributes from parents or setting at random:
      //If parents doesn't exist
      if (parent1 == null) { // only need to check with one parent
        size = random(3, 6);
        sizeAtBirth = size;
        sizeIncreaseRate = random(0.05, 0.1);
        maxSpeed = random (2, 4);
        maxSpeedAtBirth = maxSpeed;
        speedChangeRate = random(0.05, 0.1);
        maxForce =  random(0.5, 1.5);
        lifeDecreaseRate = random(0.5, 2);
        hungerIncreaseRate = random(1, 3);
      } else {
        //average all attributes of parents:
        size = (p1.sizeAtBirth + p2.sizeAtBirth)/2;
        sizeAtBirth = size;
        sizeIncreaseRate = (p1.sizeIncreaseRate + p2.sizeIncreaseRate)/2;
        maxSpeed = (p1.maxSpeedAtBirth + p2.maxSpeedAtBirth)/2;
        maxSpeedAtBirth = maxSpeed;
        maxForce =  (p1.maxForce + p2.maxForce)/2;
        speedChangeRate = (p1.speedChangeRate + p2.speedChangeRate)/2;
        lifeDecreaseRate = (p1.lifeDecreaseRate + p2.lifeDecreaseRate)/2;
        hungerIncreaseRate = (p1.hungerIncreaseRate + p2.hungerIncreaseRate)/2;
      }
    }
    //---------------------------------------------------------------------------------//
    //Update
    //---------------------------------------------------------------------------------//
    // Update the velocity and location, based on the acceleration generated by the steering force
    // Runs other piece of code or calls the functions that needs to run every frame (since it is being called in draw itself),
    void update() {
      display();
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxSpeed);
      location.add(velocity);
      // Reset acceleration to 0 each cycle
      acceleration.mult(0);

      distanceFromCat = location.dist(cat.location);

      lifeCycle();
      findClosestFood();
      findClosestHousePoint();
      findClosestMate();
      checkFoodEaten();
      foodOrlife();
      separateExceptMate();
    }
    //---------------------------------------------------------------------------------//
    //lifecycle
    //---------------------------------------------------------------------------------//
    //update the remaining life and hunger every second
    //updates other factors that depends on remainingLife: fetility, size, maxSpeed, and death due to overcrowdness.
    void lifeCycle() {

      if (frameCount - timePassed > 60) {  //frameRate is 60. So, this code runs every second.

        if (lifeRemaining < 0) {
          lifeRemaining = 0;
        } else {
          lifeRemaining -= lifeDecreaseRate; //decrease life every second until death
        }

        if (hunger >= 100) {
          hunger = 100;
        } else {
          hunger += hungerIncreaseRate; //increase hunger every second until 100%
        }

        if (lifeRemaining > 70) {
          //increase size and speed with growth
          //After 30% of lifeRemaining has passed, size and speed does not increase.
          size += sizeIncreaseRate;
          maxSpeed += speedChangeRate;
        } else if (lifeRemaining < 30) {
          //decrease speed with old age
          maxSpeed -= speedChangeRate;
        }
        timePassed = frameCount;
      }

      if (lifeRemaining > 50 && lifeRemaining <= 80) { //can only reproduce from 20 years to 50 years of age
        isFertile = true;
      } else {
        isFertile = false;
      }

      //If home is overcrowded, very old and very young dies
      if (miceInHouse >= houseOccupancy) {
        if (lifeRemaining > 90 || lifeRemaining < 10) {
          lifeRemaining = 0;
        }
      }
    }
    //---------------------------------------------------------------------------------//
    //CheckFoodEaten
    //---------------------------------------------------------------------------------//
    //if food is eaten, hunger is reset to 0 and food is removed.
    void checkFoodEaten() {
      for (int i = 0; i < food.size(); i++) {
        //collision detection
        //+/-8 because food location coordinates are of the center of the food shape, but we want the collision to be detected as soon as a mouse hits the edges of the food shape.
        if ((location.x <= food.get(i).location.x + 8 && location.x >= food.get(i).location.x - 8) && (location.y <= food.get(i).location.y + 8 && location.y >= food.get(i).location.y - 8)) {
          hunger = 0;
          food.remove(i);
        }
      }
    }
    //---------------------------------------------------------------------------------//
    //ApplyForce
    //---------------------------------------------------------------------------------//
    void applyForce(PVector force) {
      acceleration.add(force);
    }
    //---------------------------------------------------------------------------------//
    //Seek PVector: For seeking home points
    //---------------------------------------------------------------------------------//
    void seek(PVector target) {
      PVector desired = PVector.sub(target, location);
      float distance = desired.mag();
      desired.normalize();
      if (distance < 100) {
        float speed = map(distance, 0, 100, 0, maxSpeed);
        desired.mult(speed);
      } else {
        desired.mult(maxSpeed);
      }
      PVector force = PVector.sub(desired, velocity);
      force.limit(maxForce);
      applyForce(force);
    }
    //---------------------------------------------------------------------------------//
    //Seek Food
    //---------------------------------------------------------------------------------//
    void seekFood(Food food) {
      PVector desired = PVector.sub(food.location, location);
      float distance = desired.mag();
      desired.normalize();
      if (distance < 100) { //mouse needs to stop for a bit in order to collect the food. Therefore, this arrive code is added.
        float speed = map(distance, 0, 100, 0, maxSpeed);
        desired.mult(speed);
      } else {
        desired.mult(maxSpeed);
      }
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      applyForce(steer);
    }

    //---------------------------------------------------------------------------------//
    //Seek Mate
    //---------------------------------------------------------------------------------//
    void seekMate(Mouse Mate) {
      seekingMate = true;
      PVector desired = PVector.sub(Mate.location, location);
      float distance = desired.mag();
      desired.normalize();
      if (distance < 100) {
        float speed = map(distance, 0, 100, 0, maxSpeed);
        desired.mult(speed);
      } else {
        desired.mult(maxSpeed);
      }
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      applyForce(steer);
    }

    //---------------------------------------------------------------------------------//
    //Closest Food
    //---------------------------------------------------------------------------------//
    //find which food instance is closest to the mouse
    //similar coding technique as in Cat class to find closest mouse
    void findClosestFood() {
      closestFoodDistance = 100000;
      for (int i = 0; i < food.size(); i++) {
        float distance = location.dist(food.get(i).location);
        if (distance < closestFoodDistance) {
          closestFood = food.get(i);
          closestFoodDistance = distance;
        }
      }
    }
    //---------------------------------------------------------------------------------//
    //Closest House Point
    //---------------------------------------------------------------------------------//
    //find which House point is closest to the mouse
    void findClosestHousePoint() {
      closestPointDistance = 100000;
      closestHousePoint = null;
      for (int i = 0; i < housePoints.size(); i++) {
        float distance = location.dist(housePoints.get(i));
        if (distance < closestPointDistance) {
          closestHousePoint = housePoints.get(i);
          closestPointDistance = distance;
        }
      }
    }
    //---------------------------------------------------------------------------------//
    // closestPotentialMate
    //---------------------------------------------------------------------------------//
    //Find which potential mate is closest to the mouse
    void findClosestMate() {
      closestMateDistance = 100000;
      closestPotentialMate = null;
      for (int i = 0; i < mice.size(); i++) {
        Mouse curr = mice.get(i);
        //If two mice have different genders, are both fertile, are in the house and have lastMatingTime > 500: 
        if ((gender != curr.gender) && isFertile && curr.isFertile && (location.y < houseSize) && (curr.location.y < houseSize) && (frameCount-lastMatingTime > 500) && (frameCount-curr.lastMatingTime > 500)) {
          float distance = location.dist(curr.location);
          if (distance < closestMateDistance) {
            closestPotentialMate = curr;
            closestMateDistance = distance;
          }
        }
      }
    }
    //---------------------------------------------------------------------------------//
    // Separation with all other mice except for potential mate
    //---------------------------------------------------------------------------------//
    //based on code from the Nature of Code
    void separateExceptMate () {
      float desiredseparation = 30;
      PVector sum = new PVector();
      int count = 0;
      seekingMate = false;

      for (int i = 0; i < mice.size(); i++) { //no separation from potential mate
        if ((closestPotentialMate != null) && (mice.get(i) == closestPotentialMate)) {
          seekMate(mice.get(i)); //seek potential mate
          reproduction(); //reproduce on collision with mate
        } else {
          float d = PVector.dist(location, mice.get(i).location);
          // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
          if ((d > 0) && (d < desiredseparation)) {
            // Calculate vector pointing away from neighbor
            PVector diff = PVector.sub(location, mice.get(i).location);
            diff.normalize();
            diff.div(d);        // Weight by distance
            sum.add(diff);
            count++;            // Keep track of how many
          }
        }
      }
      // Average -- divide by how many
      if (count > 0) {
        sum.setMag(roamingSpeed);
        // Implement Reynolds: Steering = Desired - Velocity
        PVector steer = PVector.sub(sum, velocity);
        //Applying roaming speed and limiting to roaming force here ensures that:
        //1) mice will not go outside house walls in order to separate (since we use maxSpeed and maxForce in avoiding walls)
        //2) they will prefer seeking food even if it means they get on top of each other (since we use maxSpeed and maxForce in seeking food)
        steer.limit(roamingForce);
        applyForce(steer);
      }
    }

    //---------------------------------------------------------------------------------//
    // Reproduction
    //---------------------------------------------------------------------------------//
    //This method detects collision between two mates and adds a child to the house
    void reproduction() {
      //only 1 mouse needs to do collision detection and it will be a female since she will give birth
      if (gender == 'F' && closestPotentialMate != null && (frameCount-lastMatingTime > 500)) {
        //Collision detection with male:
        if (closestPotentialMate.location.x <= location.x+size && closestPotentialMate.location.x >= location.x-size) {
          if (closestPotentialMate.location.y + closestPotentialMate.size <= location.y+(size*2) && closestPotentialMate.location.y + closestPotentialMate.size >= location.y-(size*2)) {
            mice.add(new Mouse(location.x, location.y, this, closestPotentialMate)); //new mouse on female's location
            lastMatingTime = frameCount;
            closestPotentialMate.lastMatingTime = frameCount;
          }
        }
      }
    }

    //---------------------------------------------------------------------------------//
    //When mouse is In The House
    //---------------------------------------------------------------------------------//
    //This method controls mice behavior while they are in the house
    //It includes their roaming speed, and staying within walls
    //This method is not directly called in update method. It is called by the below method goHomeOrRun()
    void inTheHouse() {
      if (hunger < 100) {
        velocity.limit(roamingSpeed); //move in home is at roaming speed rather than maximum
      } else {
        velocity.limit(roamingSpeed+2); //move faster when hunger level is higher to show aggression and to check for food from different points in house
      }
      //Stay within walls
      PVector desired = null;
      if (location.x < 20) {
        desired = new PVector(2, velocity.y);
      } else if (location.x > width - 20) {
        desired = new PVector(-2, velocity.y);
      } 

      if (location.y < 20) {
        desired = new PVector(velocity.x, 2);
      } else if (location.y > houseSize-20) {
        desired = new PVector(velocity.x, -2);
      } 

      if (desired != null) {
        desired.normalize();
        //force from wall is more than separation from other vehicles if we use roamingSpeed roamingForce in separationExceptMate() function and maxSpeed and maxForce here.
        //mice can get on top of each other but they can't go over the wall
        desired.mult(maxSpeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        applyForce(steer);
      }
    }
    //---------------------------------------------------------------------------------//
    //Go Home Or Run
    //---------------------------------------------------------------------------------//
    //This method decides whether mouse should run for home or separate from cat if it is outside home.
    //If mouse is in the house, it simply calls inTheHouse() method.
    //It is called by foodOrLife() when mouse is not seeking food
    void goHomeOrRun() {
      if (location.y > houseSize) {
        if ((cat.location.dist(closestHousePoint) < closestPointDistance) && distanceFromCat < 300) {
          separateFromCatAndWalls();
        } else {
          seek(closestHousePoint);
        }
      } else {
        inTheHouse();
      }
    }
    //---------------------------------------------------------------------------------//
    //Food Or life
    //---------------------------------------------------------------------------------//
    //This method decides whether a mouse should seek food or not
    //It is called in update method.
    void foodOrlife() {
      if (food.size() > 0) { //if food is present
        //based on hunger, mouse decides at which distance from cat it needs to go seek food.
        //On more hunger, it seeks food at lesser distances from cat (takes more risk).
        if (hunger < 50) {

          //Reasons for the 2 conditions in the below if statements:

          //Condition 1: 1) If food from mouse is adequately closer than cat, then mouse will not wait for cat to go very
          //                far and will go for the food. Note that how much is adequate depends on mouse's hunger level.
          //             2) Secondly, if mouse is extremely hungry, it might not risk certain death by getting out of house when food is too far and 
          //                cat is too close. But if food is very close to home, it might worth taking the risk.
          //             2) Furthermore, mouse may think that the food (other than what its already eaten) is also reachable without much extra effort
          //                but won't realize that it is going far away from home in its pursuit, and might not be able to come back without getting caught.
          //                This behavior, to some extent, imitates greediness, as mouse did not need the food and risked getting more and more.

          //Condition 2: if food is very far, mouse will leave the house when cat is at good distance in hope that
          //             cat will take some random path away from food and it will be able to get it.

          if ((closestFoodDistance + 300 < distanceFromCat) || (distanceFromCat > 600)) { 
            if (!seekingMate) { //if mouse is already seeking mate, dont't seek food
              seekFood(closestFood);
            }
          } else {
            goHomeOrRun(); //When mouse is outside, it will decide whether to seek home or run away from the cat
          }
        } else if (hunger >= 50 && hunger < 80) {
          if ((closestFoodDistance + 200 < distanceFromCat) || (distanceFromCat > 500)) {
            if (!seekingMate) {
              seekFood(closestFood);
            }
          } else {
            goHomeOrRun();
          }
        } else if (hunger >= 80) {
          if ((closestFoodDistance + 100 < distanceFromCat) || (distanceFromCat > 400)) {
            if (!seekingMate) {
              seekFood(closestFood);
            }
          } else {
            goHomeOrRun();
          }
        }
      } else {
        goHomeOrRun();
      }
    }
    //---------------------------------------------------------------------------------//
    //Separate from Cat AND Walls
    //---------------------------------------------------------------------------------//
    //This method is called when cat has less distance to mouse's closest home point than mouse itself.
    //It makes sure mouse runs away from cat a=while also staying inside the room
    void separateFromCatAndWalls() {
      PVector desired;
      PVector velocityFromCat = PVector.sub(location, cat.location);
      velocityFromCat.normalize();

      if (frameCount - lastWallTurnTime> 30) { //A second after turning from wall, allow mouse to separate from cat again without worrying about walls
        velocityFromWall = null;
      }
      //Check if mouse is too close to any wall and if it is, get a velocity in opposite direction
      if (location.x < 50) { //left wall
        velocityFromWall = new PVector(maxSpeed, velocity.y);
        lastWallTurnTime= frameCount;
      } else if (location.x > width - 50) { //right wall
        velocityFromWall = new PVector(-maxSpeed, velocity.y);
        lastWallTurnTime= frameCount;
      } 

      if (location.y > (height - (legendSize + 50))) { //bottom wall  (we don't add top wall as its mice house which mice can cross)
        velocityFromWall = new PVector(velocity.x, - maxSpeed);
        lastWallTurnTime= frameCount;
      }
      if (velocityFromWall != null) {
        velocityFromWall.normalize();
        velocityFromWall.mult(maxSpeed);
        desired = velocityFromWall;
        desired.add(velocityFromWall); //it is deliberately skewed towards turning away more from the wall. Because exact average would not turn mouse away but will make it move parallel to wall.
        desired.add(velocityFromCat);
        desired.div(3);
        desired.setMag(maxSpeed);

        // Apply Reynolds’s steering formula:
        // error is our current velocty minus our desired velocity
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        // Apply the force to the Vehicle’s
        // acceleration.
        applyForce(steer);
      } else {
        desired = velocityFromCat;
        desired.setMag(maxSpeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        applyForce(steer);
      }
    }
    //---------------------------------------------------------------------------------//
    //Display
    //---------------------------------------------------------------------------------//
    //Display Mouse:
    void display() {
      strokeWeight(2); 
      if (gender == 'M') {
        stroke(0, 0, 255); //blue
      } else {
        stroke(255, 53, 184); //pink
      }

      if (hunger < 50) {
        fill (0, 255, 0); //green
      } else if (hunger >= 50 && hunger < 80) {
        fill (255, 233, 0); //yellow
      } else {
        fill (128, 0, 0); //maroon
      }
      // Copy of code for triangle from lecture notes
      float theta = velocity.heading() + radians(90);
      pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -size*2);
      vertex(-size, size*2);
      vertex(size, size*2);
      endShape();
      popMatrix();

      if (lifeRemaining > 80) {
        noStroke();
        fill (0, 255, 0);
      } else if (lifeRemaining <= 80 && lifeRemaining > 30) {
        noStroke();
        fill (0, 0, 255);
      } else if (lifeRemaining <= 30) {
        noStroke();
        fill (255, 0, 0);
      }

      rect(location.x, location.y+(size*3), 10, 5);
    }
  }


  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  //Food Class                  Food class                  Food class                  Food class                  Food class                  Food class                  Food class
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
  class Food {
    PVector location;

    Food(float x, float y) {
      location = new PVector(x, y);
    }
    void display() {
      noStroke();
      fill(255, 170, 51);
      rectMode(CENTER);
      rect(location.x, location.y, 15, 15);
    }
  }

  //---------------------------------------------------------------------------------//
  //Mouse Clicked function
  //---------------------------------------------------------------------------------//
  void mouseClicked() {
    if (mouseY > (houseSize + 30) && mouseY < (height - (legendSize - 30))) {
      food.add(new Food(float(mouseX), float(mouseY)));
    }
  }
}
