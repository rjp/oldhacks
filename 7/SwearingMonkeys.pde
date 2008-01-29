ArrayList ps;

void setup() 
{
  size(300, 300);
  background(255);
  frameRate(30);
  colorMode(RGB,255);
  smooth();
  PFont f = loadFont("VladimirScript-36.vlw");
  textFont(f,36);
  ps = new ArrayList();
  ParticleSystem p = new ParticleSystem(0,new Vector3D(100,70,0),0xffff0000);
  ParticleSystem q = new ParticleSystem(0,new Vector3D(200,70,0),0xff0000ff);
  if (p!=null) {
  ps.add(p);
  ps.add(q);
  }
}

void monkey(int x, int y, int s)
{
  int hs=s/2,tts=2*s/3,ts=s/3, fs=s/5, es=s/8;
  
  noStroke();
  fill(#655130);
  ellipse(x+ts,y-s/2,s/4,s/4);
  ellipse(x-ts,y-s/2,s/4,s/4);
  ellipse(x,y-es,6*s/8,hs);
  ellipse(x,y-ts,tts,tts);
  fill(255);
  ellipse(x-es,y-ts,fs,fs);
  ellipse(x+es,y-ts,fs,fs);
  fill(0);
  ellipse(x-es,y-ts,es,es);
  ellipse(x+es,y-ts,es,es);
  noFill();
  stroke(0);
  strokeWeight(2);
  arc(x,y-fs,s/2,s/3,PI/8,7*PI/8);
}

void draw() 
{
  background(255);
  monkey(100,70,40);
  monkey(200,70,40);
  ParticleSystem x = (ParticleSystem) ps.get(0);
  x.run();
  if (frameCount % 15 < random(5)) {
    if (frameCount % 2 == 1) {
    x.addParticle("fuck");
    } else {
      x.addParticle("fucking");
    }
  }
  x = (ParticleSystem) ps.get(1);
  x.run();
  if (frameCount % 15 < random(5)) {
    x.addParticle("cunt");
  }

}

// lifted wholesale from the SimpleParticleSystem example



// A simple Particle class

class Particle {
  Vector3D loc;
  Vector3D vel;
  Vector3D acc;
  float r;
  float timer;
  int myColor;
  String myWord;
  float myAngle;

  // One constructor
  Particle(Vector3D a, Vector3D v, Vector3D l, float r_) {
    acc = a.copy();
    vel = v.copy();
    loc = l.copy();
    r = r_;
    timer = 100.0;
  }
  
  // Another constructor (the one we are using here)
  Particle(Vector3D l, int c, String w) {
    acc = new Vector3D(0,0.05,0);
    vel = new Vector3D(random(-1,1),random(-2,0),0);
    loc = l.copy();
    r = 10.0;
    timer = 100.0;
    myColor = c;
    myWord = w;
    myAngle = random(-PI/6,PI/6);
  }


  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

  // Method to display
  void render() {
    textAlign(CENTER);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(myAngle);
    fill(myColor,timer*2);
    text(myWord,0,0);
    popMatrix();
  }
  
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  Vector3D origin;        // An origin point for where particles are birthed
  int myColor;

  ParticleSystem(int num, Vector3D v, int c) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.copy();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin, c, "fish"));    // Add "num" amount of particles to the arraylist
    }
    myColor = c;
  }

  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle(String w) {
    particles.add(new Particle(origin, myColor, w));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}



// Simple Vector3D Class 

public class Vector3D {
  public float x;
  public float y;
  public float z;

  Vector3D(float x_, float y_, float z_) {
    x = x_; y = y_; z = z_;
  }

  Vector3D(float x_, float y_) {
    x = x_; y = y_; z = 0f;
  }
  
  Vector3D() {
    x = 0f; y = 0f; z = 0f;
  }

  void setX(float x_) {
    x = x_;
  }

  void setY(float y_) {
    y = y_;
  }

  void setZ(float z_) {
    z = z_;
  }
  
  void setXY(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void setXYZ(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }

  void setXYZ(Vector3D v) {
    x = v.x;
    y = v.y;
    z = v.z;
  }
  public float magnitude() {
    return (float) Math.sqrt(x*x + y*y + z*z);
  }

  public Vector3D copy() {
    return new Vector3D(x,y,z);
  }

  public Vector3D copy(Vector3D v) {
    return new Vector3D(v.x, v.y,v.z);
  }
  
  public void add(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  public void sub(Vector3D v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  public void mult(float n) {
    x *= n;
    y *= n;
    z *= n;
  }

  public void div(float n) {
    x /= n;
    y /= n;
    z /= n;
  }

  public void normalize() {
    float m = magnitude();
    if (m > 0) {
       div(m);
    }
  }

  public void limit(float max) {
    if (magnitude() > max) {
      normalize();
      mult(max);
    }
  }

  public float heading2D() {
    float angle = (float) Math.atan2(-y, x);
    return -1*angle;
  }

  public Vector3D add(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x + v2.x,v1.y + v2.y, v1.z + v2.z);
    return v;
  }

  public Vector3D sub(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x - v2.x,v1.y - v2.y,v1.z - v2.z);
    return v;
  }

  public Vector3D div(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x/n,v1.y/n,v1.z/n);
    return v;
  }

  public Vector3D mult(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x*n,v1.y*n,v1.z*n);
    return v;
  }

  public float distance (Vector3D v1, Vector3D v2) {
    float dx = v1.x - v2.x;
    float dy = v1.y - v2.y;
    float dz = v1.z - v2.z;
    return (float) Math.sqrt(dx*dx + dy*dy + dz*dz);
  }

}
