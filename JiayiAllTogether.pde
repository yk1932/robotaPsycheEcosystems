JiayiEcosystem system1 = new JiayiEcosystem();


void setup(){
  size (1200, 800);
  system1.setup(); // call setup for each ecosystem
}

void draw() {
  background(200);
  system1.draw();// call draw for each ecosystem
}

void mouseClicked() {
  system1.mouseClicked(); // call mouseClicked for each ecosystem
}





class JiayiEcosystem {
 
  class Algae{
  PVector location;
  float G;
  float mass;

//the larger mass, the larger attractiveness the algae has to the tadpoles
  Algae(float x, float y,float mass_) {
    location = new PVector(x, y);
    G = 0.9;
    mass=mass_;
  }

//Algae(food) attracts the tadpoles
  PVector attract(Tadpole m) {
  PVector force = PVector.sub(location, m.location);
  float distance = force.mag();
    distance = constrain(distance, 50.0, 100.0);

    force.normalize();
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

//size is affected by mass
  void display() {
    noStroke();
    fill(85,180,180);
    ellipse(location.x, location.y, mass*0.15, mass*0.15);
  }      
}

class Frog{
 PVector velocity;
 PVector acceleration;
 PVector location;
 float mass;
 float G;
  
 Frog(float x,float y,float aX, float aY){
  mass=50;
  velocity = new PVector(0,0);
  location = new PVector (x,y); 
  acceleration = new PVector (aX,aY);
  G = 0.4;
 }
 
  //Frog is the green round shape with two-dot eyes
 void display() {
    noStroke();
    fill(0,150,150);
    pushMatrix();
    translate(location.x,location.y);
    rotate(acceleration.heading());
    ellipse(0,0,mass*3,mass*2);
    fill(0);
    ellipse(60,10,20,20);
    ellipse(60,-10,20,20);
    popMatrix();
  }
   
   
 //Frog moves and accelerates for a while and then stops repeatedly
  void update(){
   velocity.add(acceleration);
   location.add(velocity);
    if (abs(velocity.x)>6){
    velocity.mult(0);
   }
  }
  
  //Frog changes directions when it feels it is close to the edge
 void checkEdges(){
    if (location.x > width-100) {
      location.x = width-100;
      velocity.x *= -1;
      acceleration.x *= -1;
      velocity.y *= -1;
      acceleration.y *= -1;

    } else if (location.x <100) {
      location.x = 100;
      velocity.x *= -1;
      acceleration.x *= -1;

    }

    if (location.y > height-100) {
      location.y = height- 100;
      velocity.y *= -1;
      acceleration.y *= -1;
  
    } else if (location.y < 100) {
      location.y =100;
      velocity.y *= -1;
      acceleration.y *= -1;

    }
  }
}

class Tadpole{

  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float mass;
  float G = 0.4;
  int Color;
  float hunger;
  float lifespan=50;
  float x;
  float y;
  float scale = 1;
  float growLevel=1;
  float maxspeed= 10;
  float maxforce =10;


  
  
  Tadpole(float x,float y,float _mass_, int myColor) {
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    topspeed = 4;
    acceleration = new PVector(0, 0);
    mass = _mass_;
    Color = myColor;
    hunger = random(0,1.5);
  }
  
  //Newton's second law
  void applyForce(PVector force){
   PVector f = PVector.div(force,mass);
   acceleration.add(f);   
  }


//Hunger makes the acceleration speed varies
  void update() {
    acceleration.mult(hunger);
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

//Tadpoles are triangle,one group of tadpoles are black, the other is gray
    void display() {
   noStroke();
     if (Color == 1){
     fill(0);
     }   else{ 
     fill (150);
     }
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    scale(scale);
    triangle(0, 5, 0, -5, 20, 0);
    popMatrix();
  }
  
  //the lifespan decreases with time
  void live(){
   lifespan = lifespan -0.5;
  }


//tadpoles eats the algae when coming close and they grow big
  void eat(){
 for (int j = 0; j < algae.length;j++) {
    float distance = PVector.dist(location,algae[j].location);
          if (distance<algae[j].mass*0.15 ){
            growLevel =growLevel +0.01; 
            if(scale<2.5){
            scale = scale  +0.01;
            }

  }
 
  }
  }


//the tadpoles arrive at the frog when seeking 
void seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  PVector arrive(PVector target) {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    desired.normalize();

    if (d < 1) {
      float m = map(d, 0, 10, 0, maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return(steer);
  }

//tadpoles swims away from neighbour tadpoles when coming too close
void separate () {
    float desiredseparation = 20;
    int count = 0;
    PVector sum = new PVector(0, 0);

    for (Tadpole other : tadpoles1) {
      float d = PVector.dist(location, other.location);

      if ((d > 0) && (d < desiredseparation)) {

        PVector diff = PVector.sub(location, other.location); 

        diff.normalize(); 

        sum.add(diff); 
        count++;
      }
    }

 
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxspeed);

 
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
 
        for (Tadpole other : tadpoles2) {

      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location); 
        diff.normalize(); 
        sum.add(diff); 
        count++;
      }
    }
    if (count > 0) { 
      sum.div(count);
      sum.setMag(maxspeed);
      PVector steer2 = PVector.sub(sum, velocity);
      steer2.limit(maxforce);
      applyForce(steer2);
    }
  }
}

class LilFrog{
 PVector velocity;
 PVector acceleration;
 PVector location;
 
 LilFrog(float x,float y,float aX, float aY){
  velocity = new PVector(0,0);
  location = new PVector (x,y); 
  acceleration = new PVector (aX,aY);

 }

//Little frogs are smaller round shapes
 void display() {
    noStroke();
    fill(0,150,150);
    pushMatrix();
    translate(location.x,location.y);
    rotate(acceleration.heading());
    ellipse(0,0,50,30);

    popMatrix();
  }
   
   
 //Little Frog also moves and accelerates for a while and then stops repeatedly
  void update(){
   velocity.add(acceleration);
   location.add(velocity);
    if (abs(velocity.x)>3){
    velocity.mult(0);
   }
  
}

void checkEdges(){
    if (location.x > width-100) {
      location.x = width-100;
      velocity.x *= -1;
      acceleration.x *= -1;
      velocity.y *= -1;
      acceleration.y *= -1;

    } else if (location.x <100) {
      location.x = 100;
      velocity.x *= -1;
      acceleration.x *= -1;

    }

    if (location.y > height-100) {
      location.y = height- 100;
      velocity.y *= -1;
      acceleration.y *= -1;
  
    } else if (location.y < 100) {
      location.y =100;
      velocity.y *= -1;
      acceleration.y *= -1;

    }
  }
}

//the light moves with the mouse
class Light{
float x;
float y;
 Light(float x_, float y_){ 
x=x_;
y=y_;
  
}
void display(){
  x=mouseX;
  y=mouseY;
  fill(250,250,210);
  ellipse(x,y,100,100);
}

}


 void mouseClicked() {
  }
  
void keyPressed() {
  }



Frog a;
Frog b;

//Light
Light c;

//Tadpole
ArrayList<Tadpole> tadpoles1 = new ArrayList<Tadpole>();
ArrayList<Tadpole> tadpoles2 = new ArrayList<Tadpole>();

//Little Frog
ArrayList<LilFrog> lilfrogs = new ArrayList<LilFrog>();

//Food
Algae[]algae = new Algae[6];

//little frog and mature tadpole count
int countlfrog;
int countmtadpole;

void setup() {
  countlfrog = 0;
  countmtadpole= 0;
  //create 2 frogs, 1 light, and 6 algaes
  a = new Frog (random(width),random(height),0.06,0.06);
  b = new Frog (random(width),random(height),-0.035,0.05);
  c = new Light (mouseX,mouseY);
  for (int i = 0; i < algae.length; i++) {
  algae [i] = new Algae(random(1600),random(800),random(1000,2000));      
  }
}

void draw() {
  
  //display algae
   for (int j = 0; j < algae.length; j++) {
 algae[j].display();
 }
 
 //record the mouse location to make the light move with the mouse
  PVector mouse = new PVector (mouseX,mouseY);
  c.display();

  //Create first group of tadpoles
 for (int i = 0; i < tadpoles1.size(); i++) {
   Tadpole t = tadpoles1.get(i);
   PVector arriveForce = t.arrive(a.location);
   t.applyForce(arriveForce);
 for (int j = 0; j < algae.length; j++) {
      PVector aforce =algae[j].attract(t);
   t.applyForce(aforce);
     }
   t.update();
   t.display();
   t.live();
   t.separate();
   t.eat();
  
  //if tadpoles doesn't eat enough food, they die. If they eat enough food and get the light, they grow into little frogs.
  if(t.lifespan<0)
      {
        if(t.growLevel<3){
        tadpoles1.remove(i);      
      }
        if (t.growLevel>10){
          countmtadpole = 1;
         if( PVector.dist(mouse,t.location)<100){
          tadpoles1.remove(i);
          lilfrogs.add(new LilFrog(mouseX,mouseY, random(-0.05,0.05),random(-0.05,0.05)));
          countlfrog++;
      }
    }
   }
 }
 
   for(int i = 0;i<lilfrogs.size();i++){   
    lilfrogs.get(i).display(); 
    lilfrogs.get(i).update(); 
    lilfrogs.get(i).checkEdges(); 
  }
  
 //Create second group of tadpoles
   for (int i = 0; i < tadpoles2.size(); i++) {
   Tadpole t2 = tadpoles2.get(i);
     PVector arriveForce2 = t2.arrive(b.location);
     t2.applyForce(arriveForce2);
 for (int j = 0; j < algae.length; j++) {
   PVector bforce = algae[j].attract(t2);
   t2.applyForce(bforce);
 }

   t2.update();
   t2.display();
   t2.live();
   t2.separate();
   t2.eat();
      
        if(t2.lifespan<0)
      {
        if(t2.growLevel<3){
        tadpoles2.remove(i);      
      }
      if (t2.growLevel>10){
        countmtadpole =1;
         if( PVector.dist(mouse,t2.location)<100){
          tadpoles2.remove(i);
          lilfrogs.add(new LilFrog(mouseX,mouseY, random(-0.05,0.05),random(-0.05,0.05)));
         countlfrog++;
      }
  }
}
}   


  a.display();
  a.update();
  a.checkEdges();
  
  b.display();
  b.update();
  b.checkEdges();
 
  tadpoles1.add( new Tadpole(a.location.x,a.location.y,random(10,25),1));
  tadpoles2.add( new Tadpole(b.location.x,b.location.y,random(10,25),0));
  
  
  
 //Legend

  textAlign(LEFT);
  textSize(30);
  text("Welcome to the Frog Pond!",50,50);
  text("Little Frog Number:",50,200);
  if (countmtadpole == 0){
  text("There isn't any mature tadpole.",50,150);
  }else{ 
    text("There are mature tadpoles!",50,150);  
  }
  text(countlfrog, 300 ,200);
  text("Move Your Mouse as Light Source to grow Little Tadpoles!", 50 ,100);
 
}


}
