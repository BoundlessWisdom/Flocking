class Bird {
  PVector loc, vel, acc;
  int size;
  float maxspeed;
  float maxforce;
  float ncoh,nali,navo;

  Bird(float x, float y) {
    loc = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    size = 10;
    maxspeed = 5;
    maxforce = .06;
  }

  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(vel.heading());
    stroke(255);
    strokeWeight(3);
    fill(150);
    triangle(-size/2, -size/2, -size/2, size/2, size, 0);
    popMatrix();
  }
  void update() {
    space[(int)loc.x][(int)loc.y] = null;
    maxspeed =map(bars[3].position(), 0, 1, 0, 15);
    maxforce = map(bars[4].position(),0,1,0,.4);
    vel.add(acc);
    vel.limit(maxspeed);
    loc.add(vel);
    wrap();
    place();
    acc.set(0, 0);
  }

  void flock(ArrayList<Bird> everyone) {

    PVector coh = cohere(everyone);
    PVector avo = avoid(everyone);
    PVector ali = align(everyone);

    coh.mult(map(bars[0].position(), 0, 1, 0, 2.5));
    ncoh = map(bars[5].position(),0,1,0,min(width,height));
    avo.mult(map(bars[1].position(), 0, 1, 0, 2.5));
    navo = map(bars[6].position(),0,1,0,min(width,height));
    ali.mult(map(bars[2].position(), 0, 1, 0, 2.5));
    nali = map(bars[7].position(),0,1,0,min(width,height));

    applyForce(coh);
    applyForce(avo);
    applyForce(ali);
    collide();
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxspeed); 
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }
  PVector avoid(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = navo;
    PVector sum = new PVector();
    for (Bird other : birds) {
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
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  PVector align(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = nali;
    PVector sum = new PVector();
    for (Bird other : birds) {
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
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }

  PVector cohere(ArrayList<Bird> everybody) {
    int count = 0;
    float neighborhood = ncoh;
    PVector sum = new PVector();
    for (Bird other : birds) {
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
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  
  void collide() {
    for(int i = -1; i < 2; i++) {
      for(int j = -1; j < 2; j++) {
        if(i != 0 || j != 0) {
          Bird other = space[(int)loc.x + i][(int)loc.y + j];
          if(other != null) {
            applyForce(mult(PVector.sub(loc, other.loc), 100));
            other.applyForce(mult(PVector.sub(other.loc, loc), 100));
  } } } } }
  
  PVector mult(PVector vector, int factor) {
    vector.mult(factor);
    return vector;
  }
  
  void place() {
    space[loc.x][loc.y] = this;
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

