class Bird {
  final int flock;
  final int flockIndex;
  PVector loc, vel, acc;
  int size;
  float maxspeed;
  float maxsteer;

  Bird(int f, float x, float y, int i) {
    flock = f;
    flockIndex = i;
    loc = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    size = (int)random(12) + 3;
    maxspeed = 5;
    maxsteer = .06;
  }
  
  Bird(int f, int i, PVector v0, PVector v1, PVector v2, int s, float sp, float st) {
    flock = f;
    flockIndex = i;
    loc = v0;
    vel = v1;
    acc = v2;
    size = s;
    maxspeed = sp;
    maxsteer = st;
  }

  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(vel.heading());
    triangle(-size/2, -size/2, -size/2, size/2, size, 0);
    popMatrix();
  }
  void displayColor() {
    switch (flock) {
    case 0:
      stroke(255);
      fill(150);
      return;
    case 1:
      stroke(0, 255, 0);
      fill(0, 150, 0);
      return;
    case 2:
      stroke(255, 0, 0);
      fill(150, 0, 0);
      return;
    case 3:
      stroke(5, 5, 255);
      fill(50, 50, 150);
      return;
    default:
      stroke(0);
      fill(0);
    }
  }
  void update() {
    space[bind((int)loc.x, 0, width)][bind((int)loc.y, 0, height)] = null;
    maxspeed = variables[3];
    maxsteer = variables[4];
    acc.mult(10.0f/size);
    vel.add(acc);
    vel.limit(maxspeed);
    if (buttons[0].pressed) {
      collide();
    }
    loc.add(vel);
    wrap();
    place();
    acc.set(0, 0);
  }

  void flock() {

    PVector coh = cohere(flocks[flock]);
    PVector avo = avoid(flocks[flock]);
    PVector ali = align(flocks[flock]);

    coh.mult(variables[0]);
    avo.mult(variables[1]);
    ali.mult(variables[2]);

    applyForce(coh);
    applyForce(avo);
    applyForce(ali);
    if (buttons[3].pressed) {
      applyForce(follow());
    }
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxsteer);
    return steer;
  }
  PVector avoid(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = 50;
    PVector sum = new PVector();
    for (Bird other : everybody) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        PVector diff = PVector.sub(loc, other.loc);
        diff.normalize();
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxsteer);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  PVector align(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = 100;
    PVector sum = new PVector();
    for (Bird other : everybody) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxsteer);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }

  PVector cohere(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = 100;
    PVector sum = new PVector();
    for (Bird other : everybody) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        sum.add(other.loc);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      PVector desired = PVector.sub(sum, loc);
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxsteer);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  PVector follow() {
    PVector lure = new PVector(mouseX, mouseY);
    if (lure.x > 0 && lure.x < width && lure.y > 0 && lure.y < height) {
      PVector desired = PVector.sub(lure, loc);
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxsteer);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  void collide() {
    for(int i = -2; i < 3; i++) {
      for(int j = -2; j < 3; j++) {
        if(i != 0 || j != 0) {
          Bird other = space[bind((int)loc.x + i, 0, width)][bind((int)loc.y + j, 0, height)];
          if (other != null) {
            if (other.flock != this.flock) {
              if (buttons[1].pressed || buttons[4].pressed) {
                addExplosion(flock, loc);
              }
              applyForce(mult(PVector.sub(loc, other.loc), 100));
              other.applyForce(mult(PVector.sub(other.loc, loc), 100));
              if (buttons[1].pressed) {
                //Destroy bird.
              }
  } } } } } }
  
  void destroy() {
    destroyList.add(flockIndex - destroyCount[flock]);
    destroyCount[flock]++;
  }
  
  PVector mult(PVector vector, int factor) {
    vector.mult(factor);
    return vector;
  }
  
  void place() {
    space[bind((int)loc.x, 0, width)][bind((int)loc.y, 0, height)] = this;
  }
  
  int bind(int attr, int min, int max) {
    if(attr < min) {
      return min;
    }
    if(attr > max) {
      return max;
    }
    return attr;
  }
  
  void wrap() {
    if (loc.x < 0) {
      loc.x = width;
    }
    if (loc.x > width) {
      loc.x = 0;
    }
    if (loc.y < 0) {
      loc.y = height;
    }
    if (loc.y > height) {
      loc.y = 0;
    }
  }
}



class newBird extends Bird {
  final int expireTime = 100;
  int time = 0;
  
  void update() {
    super.update();
    time++;
    if (time == expireTime) {
      flocks[flock].set(flockIndex - destroyCount[flock], new Bird(flock, flockIndex, loc, vel, acc, size, maxspeed, maxsteer));
    }
  }
  
  void collide() {}
  
  newBird(int f, float x, float y, int i) {
    super(f, x, y, i);
  }
}
