
class SarahsEcosystem{  
// all classes  
 //Dictator
 
 class Dictator {
  float mass;
  PVector location;
  PVector velocity; 
  PVector acceleration; 
  float G; 
  float maxSpeed; 
  float maxForce; 
  int shapeWidth; 
  color dictColor;



  Dictator(float _x, float _y) {

    mass = 50; 
    location = new PVector(_x, _y); 
    velocity = new PVector(0, 0); 
    acceleration = new PVector(0.2, 0.1); 
    dictColor = color(217, 32, 38); 
    shapeWidth = 90; 
    maxSpeed = 1.5;
    maxForce = 1.6;
  }

  //apply force function
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); 
    acceleration.add(f);
  }

  //Function that seeks revolutionaries to kill them
  void seekRevs(Rev r, Dictator dict, PVector target) {
    if (r.mass < dict.mass) {
      PVector desired = PVector.sub(target, location);
      desired.normalize();
      desired.mult(maxSpeed);
      PVector steer = PVector.sub(desired, velocity);

      // Limit the magnitude of the steering force.
      steer.limit(maxForce);

      applyForce(steer);
    }
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    rectMode(RADIUS);
    noStroke();
    fill(dictColor); 
    rect(location.x, location.y, shapeWidth, shapeWidth, 20);
  }

  //bouncing off edges of the screen/ shelter
  void checkEdges() {
    if (location.x > width - shapeWidth) {
      velocity.x *= -1;
    } else if (location.x < 400 + shapeWidth) {
      velocity.x *= -1;
    }

    if (location.y > height - shapeWidth) {
      velocity.y *= -1;
    } else if (location.y < 0 + shapeWidth) {
      velocity.y *= -1;
    }
  }
}

//Elites

class Elite {

  float mass;
  PVector location;
  PVector velocity; 
  PVector acceleration; 
  float G; 
  float maxSpeed; 
  float maxForce; 
  int shapeWidth; 
  color eliteColor;


  Elite(float _x, float _y) {

    mass = 20; 
    location = new PVector(_x, _y); 
    velocity = new PVector(0, 0); 
    acceleration = new PVector(0.2, 0.1); 
    eliteColor = color(200, 90, 38); 
    shapeWidth = 30; 
    maxSpeed = 0.5;
    maxForce = 1.3;
  }


  //apply force function
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); 
    acceleration.add(f);
  }



  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    rectMode(RADIUS);
    stroke(0);
    fill(eliteColor); 
    rect(location.x, location.y, shapeWidth, shapeWidth, 20);
  }

  //bouncing off edges of the screen/shelter
  void checkEdges() {
    if (location.x > width - shapeWidth) {
      velocity.x *= -1;
    } else if (location.x < 400 + shapeWidth) {
      velocity.x *= -1;
    }

    if (location.y > height - shapeWidth) {
      velocity.y *= -1;
    } else if (location.y < 0 + shapeWidth) {
      velocity.y *= -1;
    }
  }
  
  //for elite-elite collisions
  void checkCollisionAmongElites(Elite e1, Elite e2) {
    PVector vectorBtwnCenters = PVector.sub(e1.location, e2.location); 
    float distBtwnCenters = vectorBtwnCenters.mag(); 

    //upon collision:
    if (distBtwnCenters <= e1.shapeWidth/2 + e2.shapeWidth/2) {

      //they bounce off
      e1.velocity.mult(-1);
      e2.velocity.mult(-1);
    }
  }

  //for elite-dictator collisions
  void checkCollisionWDictator(Dictator dict, Elite e) {
    PVector vectorBtwnCenters = PVector.sub(e.location, dict.location); 
    float distBtwnCenters = vectorBtwnCenters.mag(); 

    if (distBtwnCenters <= e.shapeWidth + dict.shapeWidth ) {
      e.velocity.mult(-1); 
      dict.velocity.mult(-1);
    }
  }
}
//Revolutionaries
class Rev {
  PVector location;
  PVector velocity; 
  PVector acceleration;
  float mass;
  float maxSpeed; 
  float maxForce; 
  float G = 0.4; 
  float radius;
  color revColor;
  //alpha value as the indicator of strength
  int alphaVal; 



  Rev(float _mass, float _x, float _y) {
    mass = _mass;
    radius = 20*mass; 
    location = new PVector(_x, _y); 
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxSpeed = .001;
    maxForce = 0.003; 
    revColor = color(217, 32, 38, alphaVal);
  }


  // apply force function
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); 
    f.limit(maxForce);
    acceleration.add(f);
  }


  //attraction function
  PVector attract(Rev r) {
    PVector force = PVector.sub(location, r.location);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();
    float strength = (G * mass * r.mass) / (distance * distance);
    force.mult(strength);



    return force;
  }

  // The elite are attracted to the revolutionaries, to subtract a bit of their strength 
  PVector attractElite(Elite e) {
    PVector force = PVector.sub(location, e.location);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();
    float strength = (G * mass * e.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }


  //rev-rev collisions
  void checkLikeCollisions(Rev r1, Rev r2) {
    //Pythagorean theorem to check for collisions 
    PVector vectorBtwnCenters = PVector.sub(r1.location, r2.location); 
    float distBtwnCenters = vectorBtwnCenters.mag(); 

    //upon collision:
    if (distBtwnCenters <= r1.radius + r2.radius) {

      //they bounce off
      r1.velocity.mult(-1);
      r2.velocity.mult(-1);



      //if the revs are still weaker than the predator (mass < 50) then increment their mass and the alpha value
      if (r1.mass <= 50 || r2.mass <= 50) {

        r1.mass += 0.1;
        r2.mass += 0.1;
        alphaVal += 1;
        //when the strength of the rev = that of the dictator, they will have the same color (full opacity)
        if (r1.mass >= 50) {
          r1.alphaVal = 255;
        }
        if (r2.mass >= 50) {
          r2.alphaVal = 255;
        }
        //alpha value as a visual cue
        revColor = color(217, 32, 38, alphaVal);
      }
    }
  }


  //Rev-dictator collisions
  void checkDictatorCollisions(Rev r, Dictator dict) {
    PVector vectorBtwnCenters = PVector.sub(r.location, dict.location); 
    float distBtwnCenters = vectorBtwnCenters.mag(); 

    if (distBtwnCenters <= r.radius + dict.shapeWidth  && r.mass <= 50) {
      //remove revolutionaries form arrayList (death) if they're too "weak" to bounce of dictator 
      revs.remove(r);
      //otherwise, they just bounce off
    } else if (distBtwnCenters <= r.radius + dict.shapeWidth && r.mass >= 50) {
      r.velocity.mult(-1);
      dict.velocity.mult(-1);
    }
  }


  //Elite-Rev collisions
  void checkEliteCollisions(Rev r, Elite e) {
    PVector vectorBtwnCenters = PVector.sub(r.location, e.location); 
    float distBtwnCenters = vectorBtwnCenters.mag(); 
    //upon collisions they bounce off
    if (distBtwnCenters <= r.radius + e.shapeWidth) {
      r.velocity.mult(-1);
      e.velocity.mult(-1); 

      //any interaction with an elite, reduces the revolutionary's strength, achieved through a decrease in mass
      //the alpha value is also decreased for the visual cue
      r.mass -= 0.2;
      alphaVal -= 2;
    }
  }

  //a seek function where the revolutionaries that are "too weak" seek shelter - it also applies the arrive functionality so things don't get too chaotic within the shelter
  void seekShelter(Rev r, PVector target) {
    if (r.mass < 50) {

      PVector desired = PVector.sub(target, location);
      float d = desired.mag();
      desired.normalize();
      if (d<100) {
        float m = map(d, 0, 200, 0, maxSpeed);
        desired.mult(m);
      } else {
        desired.mult(maxSpeed);
      }


      PVector steer = PVector.sub(desired, velocity);

      // Limit the magnitude of the steering force.
      steer.limit(maxForce);

      applyForce(steer);
    }
  }
  
  
  //a function to escape the dictator's attraction, revereses seek functionality
  void fleeDictator(Rev r, Dictator dict, PVector target) {
    if (r.mass < dict.mass) {
      PVector desired = PVector.sub(target, location);
      desired.normalize();
      desired.mult(maxSpeed);
      PVector steer = PVector.sub(desired, velocity);

      // Limit the magnitude of the steering force.
      steer.limit(maxForce);
      steer.mult(-1); 

      applyForce(steer);
    }
  }



  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    stroke(0); 
    strokeWeight(3);
    fill(revColor);
    ellipseMode(RADIUS);
    ellipse(location.x, location.y, radius, radius);
  }

  //bouncing off edges of the screen
  void checkEdges() {
    if (location.x < width - radius) {
      velocity.x *= -1;
    } else if (location.x > 0 + radius) {
      velocity.x *= -1;
    }

    if (location.y > height - radius) {
      velocity.y *= -1;
    } else if (location.y < 0 + radius) {
      velocity.y *= -1;
    }
  }
}


//SafeZone
//a class for the shelter, perhaps unnecessary but allowed for better organization

class safeZone {
  color safeZoneColor = color(149, 213, 178); 

  int x = 0; 
  int y = 0; 
  int w = 400; 
  int h = height;
  PVector center = new PVector(x+w/2, y+h/2); 



  safeZone() {
  }

  void display() {
    noStroke();
    fill(safeZoneColor);
    rect(x, y, w, h);
  }
}
 
ArrayList<Rev> revs = new ArrayList<Rev>();
ArrayList<Elite> elites = new ArrayList<Elite>();
int numberOfRevs;
int numberOfElites; 
Dictator dict; 
color backgroundColor = color(245, 245, 220);
safeZone shelter; 
boolean startEcoSystem; 




void setup() {
  
  numberOfRevs = 15;
  numberOfElites = 4; 
  dict = new Dictator(width/2, height/2); 
  shelter = new safeZone(); 

  for (int i = 0; i < numberOfRevs; i++) {
    revs.add(new Rev(random(0.1, 2.5), random(width), random(height))); // initial location
  }

  for (int i = 0; i < numberOfElites; i++) {
    elites.add(new Elite(random(400+30, width), random(height))); // initial location
  }
  
}

void draw() {
  //mouse pressed is only for the purpose of a clear recording
 

  
  shelter.display();



    dict.update();
    dict.display();
    dict.checkEdges(); 
    //checking the number of revolutionaries alive "alive" 
    numberOfRevs = revs.size(); 


    for (int i = 0; i < numberOfRevs; i++) {

      //avoiding index error
      int numberOfRevs2 = revs.size();
      if (numberOfRevs2 < numberOfRevs) {
        break;
      }

      Rev r = revs.get(i);

      //this loop navigates the relationship between the elites and other elements on the screen 
      for (int k=0; k<numberOfElites; k++) {

        Elite e = elites.get(k);

        //checking Elite - Rev collisions, the elite are attracted to the revolutionaries
        r.checkEliteCollisions(r, e); 
        r.attractElite(e); 


        //Elite-Dictator Collisions
        e.checkCollisionWDictator(dict, e);
        for (int l=0; l<numberOfElites; l++) {
          Elite e2 = elites.get(l);
          if (e != e2) {
            //ELite-Elite Collisions
            e.checkCollisionAmongElites(e, e2);
          }
        }
        e.update();
        e.display();
        e.checkEdges();
      }








      //nested loop for rev-rev attraction and rev-rev collisions
      for (int j = 0; j < numberOfRevs; j++) {
        Rev r2 = revs.get(j); 
        if (r != r2) {
          PVector force = r2.attract(r);
          r.applyForce(force);
          
          r.checkLikeCollisions(r2, r);
          
        }
      }
      
      //dictator-rev interactions 
      dict.seekRevs(r, dict, r.location); 
      r.fleeDictator(r, dict, dict.location); 
      r.seekShelter(r, shelter.center);
      r.checkDictatorCollisions(r, dict);



      r.checkEdges();
      r.update();
      r.display();
    }
  
} 

void mouseClicked(){}

void keyPressed(){}


}

SarahsEcosystem systemS = new SarahsEcosystem();
void setup(){
  size (1200, 800);
  systemS.setup(); // call setup for each ecosystem
}

void draw() {
  background(200);
  systemS.draw();// call draw for each ecosystem
}

void mouseClicked() {
  systemS.mouseClicked(); // call mouseClicked for each ecosystem
}
