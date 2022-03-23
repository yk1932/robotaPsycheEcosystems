class adinasEcosystem {
  
  class Alpha {
  
  PVector location;
  PVector velocity;
  int interval; //to change the direction in intervals
  boolean randomChange; //to randomly change the direction of the alpha, so he is not just bouncing off the walls
  int ageLimit; //max age for alpha
  int age; //initial age of alpha
  int timeInit; //current time
  int timeFood; //time passed since last ate food
  float speed;
  int ageTime = 2000; //the amount of time needed for alpha to get older by one
  int foodScore; //current food score of alpha
  int foodMax; //max food score for alpha
  boolean running; 
  ArrayList<Wolf> wolves;
  //---------------------------------------------------------------------------------//
  //Alpha constructor
  //---------------------------------------------------------------------------------//
  Alpha() {
    location = new PVector(random(1, width) / 2, random(201, height));
    interval = frameCount;
    velocity = new PVector(random(3, 4), random(3, 4));
    randomChange = false;
    ageLimit = 50;
    age = 0;
    wolves = populateWolves();
    timeInit = millis();
    timeFood = millis();
    foodScore = 50;
    foodMax = 100;
    speed = 4.0;
    running = false;
  }
  //---------------------------------------------------------------------------------//
  //function for the wolves to follow the alpha
  //---------------------------------------------------------------------------------//
  void attract(Wolf wolf) {
    //for each wolf we give different rate of change and distance from the leader/alpha
    wolf.velocity.x = (location.x * wolf.positionX - wolf.location.x) * 0.05;
    wolf.velocity.y = (location.y * wolf.positionY - wolf.location.y) * 0.05;
  }
  //---------------------------------------------------------------------------------//
  //function that creates wolves array list for the alpha
  //---------------------------------------------------------------------------------//
  ArrayList<Wolf> populateWolves() {
    ArrayList<Wolf> wolvesPack = new ArrayList<Wolf>();
    for (int i = 0; i < 10; i++) { //start with 10 wolves in the pack
      wolvesPack.add(new Wolf(random(0.6, 0.9), random(0.6, 0.9), random(width), random(height))); //create of random sizes
    }
    return wolvesPack;
  }
  //---------------------------------------------------------------------------------//
  //Update function
  //---------------------------------------------------------------------------------//
  void update() {
    // change the direction of the alpha if the wall is met
    if (location.x <= 0 || location.x >= width) {
      velocity.x *= -1;
    }
    if (location.y <= 200 || location.y >= height) {
      velocity.y *= -1;
    }
    //allowing to change the direction only if the alpha is inside the boundaries and the interval is met
    //we are checking the interval by substracting the frameCount from the interval that checked the frameCount last time
    //the interval is set to 3 seconds.
    if (location.x > 0 && location.x < width && location.y > 200 && location.y < height && (frameCount - interval) > 180  && !running) {
      randomChange = true; //allow for a random change of direction
    }
    if (randomChange) {
      //we are setting the velocity here, so it will be random between -3 and 3
      Integer[] mult = { -1, 1 };
      int first = mult[int(random(mult.length))]; //first random value
      int second = mult[int(random(mult.length))]; //second random value
      velocity.x = random( speed - 2, speed-0.5) * first; 
      velocity.y = random( speed - 2, speed-0.5) * second; 
      randomChange = false; //update randomChange value
      interval = frameCount;
    }
    location.add(velocity); //add new velocity
  }
  //---------------------------------------------------------------------------------//
  //Make alpha grow older after time
  //---------------------------------------------------------------------------------//
  void getOlder() {
    //check the amount of time passed
    int passedTime = millis() - timeInit;
    //check if 5secs passed
    if (passedTime > ageTime) {
      //update age value
      age = passedTime / ageTime + age;
      //save current time to restart the timer
      timeInit = millis();
    }
    speed = 4 - age * 0.01;
    //check if alpha reached the age limit
    if (age > ageLimit) {
      death(); //call death function in case if it did
    }
  }
  //---------------------------------------------------------------------------------//
  //check for collisions with rabbits
  //---------------------------------------------------------------------------------//
  void checkCollisionsRabbit() {
    // checking collisions with rabbits
    for (int i = 0; i < rabbits.size(); i++) {
      // if the distance between the alpha and the rabbit is smaller than 25, alpha eats the rabbit
      if (distance(location, rabbits.get(i).location) < 25) {
        rabbits.remove(i);
        foodScore += 5;
      }
      // if the rabbit is in the range of the alpha, alpha will run after him with a speed that is determined by his age
      else if (i < rabbits.size() && distance(location, rabbits.get(i).location) < 50 && distance(location, rabbits.get(i).location) > 25) {
        running = true;
        velocity = new PVector(rabbits.get(i).location.x - location.x, rabbits.get(i).location.y - location.y);
        velocity.mult(0.0209 * speed);
        rabbits.get(i).velocity = new PVector(rabbits.get(i).location.x - location.x, rabbits.get(i).location.y - location.y);
        rabbits.get(i).velocity.mult(random(0.05, 0.1));
        break;
        // running is needed to change the direction sometime after running
      } else {
        running = false;
      }
    }
  }
  //---------------------------------------------------------------------------------//
  //Alpha's death function
  //---------------------------------------------------------------------------------//
  void death() {
    //update age value
    age = 0;
    //find the biggest member of the pack
    float big = 0;
    int biggest = 0;
    for (int i = 0; i < wolves.size(); i++) {
      if (big < wolves.get(i).wolfWeight) { //compare wolves by wolfWeight value they were assigned at random
        big = wolves.get(i).wolfWeight; //update the value to compare with
        biggest = i; //if bigger than the last one, then assigned as the new biggest
      }
    }
    foodScore = 50; //reset foodscore to default value of 50
    wolves.remove(biggest); //remove the biggest one from the pack
  }
  //---------------------------------------------------------------------------------//
  //Alpha's feeding function
  //---------------------------------------------------------------------------------//
  void feed() {
    int passedTime = millis() - timeFood; 
    //check if 5 secs passed
    if (passedTime > 5000) {
      //update foodScore value
      foodScore = foodScore - passedTime / 2000;
      //save current time to restart the timer
      timeFood = millis();
    }
    //check if foodMax is reached
    if (foodScore > foodMax) {
      wolves.add(new Wolf(random(0.6, 0.9), random(0.6, 0.9), random(width), random(height))); //add a member to the pack
      foodScore = 50; //reset the foodscore value to the default of 50
    }
  }
  //---------------------------------------------------------------------------------//
  //Display function
  //---------------------------------------------------------------------------------//
  void display(int[] colors, int index) {
    checkCollisionsRabbit();
    update();
    getOlder();
    feed();
    //---------------------------------------------------------------------------------//
    //Display alpha's age
    //---------------------------------------------------------------------------------//
    String ageString = (index + 1) + " alpha's age: " + age;
    fill(colors[0], colors[1], colors[2]);
    textSize(20);
    text(ageString, 15 + width/2.7 * index, 30);
    //---------------------------------------------------------------------------------//
    //Display food score
    //---------------------------------------------------------------------------------//
    String foodString = "Food score (max is 100): " + foodScore;
    fill(220);
    textSize(15);
    text(foodString, 15 + width/2.7 * index, 60);
    //---------------------------------------------------------------------------------//
    //Display pack count number
    //---------------------------------------------------------------------------------//
    String packString = "Pack size: " + wolves.size();
    textSize(15);
    text(packString, 15 + width/2.7 * index, 80);
    //---------------------------------------------------------------------------------//
    //Color the Alpha
    //---------------------------------------------------------------------------------//
    for (Wolf w : wolves) {
      attract(w);
      w.display(this, colors);
    }
    stroke(0);
    fill(colors[0], colors[1], colors[2]);
    //---------------------------------------------------------------------------------//
    //Display pack
    //---------------------------------------------------------------------------------//
    pushMatrix();
    translate(location.x, location.y); // Translate to the center of the move
    rotate(velocity.heading()); // rotate the mover to point in the direction of travel
    triangle(0, 5, 0, -5, 30, 0);
    popMatrix();
  }
}
//---------------------------------------------------------------------------------//
//Wolf class
//---------------------------------------------------------------------------------//
class Wolf {

  PVector location;
  PVector velocity;
  //position is needed to make the distance of the pack from the alpha diverse
  float positionX;
  float positionY;
  float wolfWeight;
  //---------------------------------------------------------------------------------//
  //Wolf class constructor
  //---------------------------------------------------------------------------------//
  Wolf(float posX, float posY, float _x_, float _y_) {
    location = new PVector(_x_, _y_);
    velocity = new PVector(1, 1);
    positionX = posX;
    positionY = posY;
    wolfWeight = random(1, 10); //randomly assing the size of each member
  }
  //---------------------------------------------------------------------------------//
  //Update function
  void update() {
    //updating the location of the wolf by adding hte velocity
    location.add(velocity);
  }
  //---------------------------------------------------------------------------------//
  //Display function
  //---------------------------------------------------------------------------------//
  void display(Alpha alpha, int[] colors) {
    update();
    //---------------------------------------------------------------------------------//
    //Color the pack
    //---------------------------------------------------------------------------------//
    stroke(0);
    fill(colors[0], colors[1], colors[2], 80);
    //---------------------------------------------------------------------------------//
    //Display the wolves
    //---------------------------------------------------------------------------------//
    //translate to the center of the move
    pushMatrix();
    translate(location.x, location.y);
    //so the pointer of the triangle is looking at the alpha, not on anything else
    PVector check = new PVector(alpha.location.x - location.x, alpha.location.y - location.y);
    rotate(check.heading()); //rotate the mover to point in the direction of travel
    triangle(0, wolfWeight, 0, -5, 20, 0);
    popMatrix();
  }
}
//---------------------------------------------------------------------------------//
//Rabbit class
//---------------------------------------------------------------------------------//
class Rabbit {
  PVector location;
  PVector velocity;
  //---------------------------------------------------------------------------------//
  //Rabbit class constructor
  //---------------------------------------------------------------------------------//
  Rabbit() {
    location = new PVector(random(0, width), random(100, height));
    velocity = new PVector(2, 2);
  }
  //---------------------------------------------------------------------------------//
  //Update function
  //---------------------------------------------------------------------------------//
  void update() {
    // change the direction of the alpha if the wall is met
    if (location.x <= 0 || location.x >= width) {
      velocity.x *= -1;
    }
    if (location.y <= 100 || location.y >= height) {
      velocity.y *= -1;
    }

    location.add(velocity); //add velocity to the rabbits
  }
  //---------------------------------------------------------------------------------//
  //Check for collisions
  //---------------------------------------------------------------------------------//
  void checkCollision(Rabbit other) {
    if (distance(location, other.location) < 10) {
      if ((frameCount%60<20 || frameCount%60>40) && rabbits.size() < 20) {
        rabbits.add(new Rabbit());
      }
    } else if (rabbits.size() < 5 && distance(location, other.location) < 800 && distance(location, other.location) > 10) {
      velocity = new PVector((other.location.x - location.x) * 0.03, (other.location.y -location.y) * 0.03);
      other.velocity = new PVector((location.x - other.location.x) * 0.03, (location.y - other.location.y) * 0.03);
    }
  }
  //---------------------------------------------------------------------------------//
  //Display function
  //---------------------------------------------------------------------------------//
  void display() {
    update();
    stroke(0);
    fill(255, 255, 0);
    circle(location.x, location.y, 10);
  }
}
//---------------------------------------------------------------------------------//
//Distance function
//---------------------------------------------------------------------------------//
double distance(PVector a, PVector b) {
  return Math.sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y));
}
//---------------------------------------------------------------------------------//
//Display the legend box
//---------------------------------------------------------------------------------//
void legendDisplay() {
  fill(0);
  rect(0, height-620, width, -100);
}

//---------------------------------------------------------------------------------//
//creating first pack
//---------------------------------------------------------------------------------//
import java.io.*;
import java.util.*;
//---------------------------------------------------------------------------------//
//global variables
//---------------------------------------------------------------------------------//
int numofpacks = 3; //number of packs on screen
int numofrabbits = 5; //initial number of rabbits on screen
int[][] colors = {{0, 128, 255}, {255, 0, 0}, {255, 0, 255}}; //list of colors for each pack
ArrayList<Alpha> alphas = new ArrayList<Alpha>(numofpacks); 
ArrayList<Rabbit> rabbits = new ArrayList<Rabbit>(numofrabbits); 
//---------------------------------------------------------------------------------//
//setup
//---------------------------------------------------------------------------------//
void setup() {
  //create alpha and packs based on the numofpacks value
  for (int j = 0; j < numofpacks; j++) { 
    Alpha alphaPack = new Alpha();
    alphas.add(alphaPack);
  }
  //create rabbits based on the numofrabbits value
  for (int i = 0; i < numofrabbits; i++) { 
    rabbits.add(new Rabbit());
  }
}

//---------------------------------------------------------------------------------//
//Draw function
//---------------------------------------------------------------------------------//
void draw() {
  legendDisplay();

  for (int j = 0; j < numofpacks; j++) {
    alphas.get(j).display(colors[j], j);
  }

  for (int i = 0; i < rabbits.size(); i++) {
    rabbits.get(i).display();
    for (int j = i+1; j < rabbits.size(); j++) {
      rabbits.get(i).checkCollision(rabbits.get(j));
    }
  }
}

}
