import java.util.Arrays;

PVector mouse = new PVector();
int width = 1000;
int height = 700;

ArrayList[] flocks = new ArrayList[5];
int[] flockIndices = new int[flocks.length];
int currentFlock = 0;

Bird[][] space = new Bird[width + 1][height + 1];
ArrayList<Integer> destroyList = new ArrayList<Integer>();
int[] destroyCount = new int[flocks.length];

ArrayList<Explosion> explosions = new ArrayList<Explosion>();
int removeCount;

ScrollBar[] bars = new ScrollBar[5];
String[] bartitles = {"Cohere", "Avoid", "Align", "Max Speed", "Max Steering"};
Button[] buttons = new Button[5];
String[] buttontitles = {"Collide", "Smash", "Random Coordinates", "Follow", "Ripple"};
int[] nextLine = {1, 0, 1, 1, 1};

float[] variables = new float[bars.length];

void setup() {
  size(width, height);
  for (int i = 0; i < flocks.length; i++) {
    flocks[i] = new ArrayList<Bird>();
  }
  for (int i = 0; i < flocks.length*5; i++) {
    addBird(i/5, random(width), random(height));
  }
  for (int i = 0; i < 15; i++) {
    int r = (int)random(flocks.length);
    if (r == flocks.length) { r -= 1; }
    addBird(r, random(width), random(height));
  }
  for (int i = 0; i < bars.length; i++) {
    bars[i] = new ScrollBar(25, 50+i*50, 150, 15, bartitles[i]);
  }
  int lines = 0;
  int line = 0;
  for (int i = 0; i < buttons.length; i++) {
    lines += nextLine[i];
    line ++; line -= nextLine[i]*line;
    buttons[i] = new Button(33+line*50, lines*50 + bars.length*50, 15, 15, buttontitles[i]);
  }
  ellipseMode(RADIUS);
}
void addBird(int f, float x, float y) {
  flocks[f].add(new Bird(f, x, y, flockIndices[f]++));
}
void addNewBird(int f, float x, float y) {
  flocks[f].add(new newBird(f, x, y, flockIndices[f]++));
}
void addExplosion(int f, PVector loc) {
  explosions.add(new Explosion(loc, f));
}

void draw() {
  mouse.set(mouseX, mouseY);
  background(50);
  strokeWeight(3);
  for (int i = 0; i < bars.length; i++) {
    bars[i].run();
  }
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].run();
  }
  Selector.run();
  
  variables[0] = map(bars[0].position(), 0, 1, 0, 2.5);
  variables[1] = map(bars[1].position(), 0, 1, 0, 2.5);
  variables[2] = map(bars[2].position(), 0, 1, 0, 2.5);
  variables[3] = map(bars[3].position(), 0, 1, 0, 15);
  variables[4] = map(bars[4].position(), 0, 1, 0, .4);
  
  for (int i = 0; i < flocks.length; i++) {
    ArrayList<Bird> flockToDraw = flocks[i];
    if (flockToDraw.size() > 0) {
      flockToDraw.get(0).displayColor();
    }
    for (Bird b : flockToDraw) {
      b.display();
      b.flock();
      b.update();
    }
  }
  for (Integer i : destroyList) {
    
  }
  strokeWeight(1);
  removeCount = 0;
  fill(0, 0, 0, 0);
  for (Explosion e : explosions) {
    e.boom();
  }
  for (int i = 0; i < removeCount; i++) {
    explosions.remove(0);
  }
}

void keyPressed() {
  if (key > '0' && key < ':' && key - 49 < flocks.length) {
    for (int i = 0; i < 10; i++) {
      addNewBird(key - 49, giveX(), giveY());
    }
  } else {
    int r = (int)random(flocks.length);
    if (r == flocks.length) { r -= 1; }
    for (int i = 0; i < 10; i++) {
      addNewBird(r, giveX(), giveY());
    }
  }
  
  if (key == '0') {
    for (int i = 0; i < flocks.length; i++) {
      flocks[i] = new ArrayList<Bird>();
      flockIndices[i] = 0;
      destroyCount[i] = 0;
    }
    space = new Bird[width + 1][height + 1];
    
    explosions = new ArrayList<Explosion>();
  }
  
//  if (key == 'c') {
    
//  }
  
  if (keyCode == RIGHT) {
    Selector.scroll(1);
  } else if (keyCode == LEFT) {
    Selector.scroll(-1);
  }
}

float giveX() {
  if (buttons[2].pressed) { return random(width); }
  return mouseX;
}
float giveY() {
  if (buttons[2].pressed) { return random(height); }
  return mouseY;
}
