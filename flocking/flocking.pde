import java.util.Arrays;

ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList[] flocks = new ArrayList[2];
ScrollBar[] bars = new ScrollBar[5];
String[] bartitles = {"Cohere", "Avoid", "Align", "Max Speed", "Max Steering"};
Button[] buttons = new Button[4];
String[] buttontitles = {"Collide", "Follow", "Random Coordinates", "Smash"};
int[] nextLine = {1, 0, 1, 1};
PVector mouse = new PVector();
int width = 800;
int height = 600;
Bird[][] space = new Bird[width + 1][height + 1];

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
    line ++;  line -= nextLine[i]*line;
    buttons[i] = new Button(33+line*50, lines*50 + bars.length*50, 15, 15, buttontitles[i]);
  }
}
void addBird(int f, float x, float y) {
  Bird bird = new Bird(x, y);
  birds.add(bird);
  flocks[f].add(bird);
  bird.flockWith(f);
}

void draw() {
  mouse.set(mouseX, mouseY);
  background(50);
  for (int i = 0; i < bars.length; i++) {
    bars[i].run();
  }
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].run();
  }
  for (Bird b : birds) {
    b.display();
    b.flock();
    b.update();
  }
}

void keyPressed() {
  if (key > '0' && key < ':' && key - 49 < flocks.length) {
    for (int i = 0; i < 10; i++) {
      addBird(key - 49, giveX(), giveY());
    }
  } else {
    int r = (int)random(flocks.length);
    if (r == flocks.length) { r -= 1; }
    for (int i = 0; i < 10; i++) {
      addBird(r, giveX(), giveY());
    }
  }
  
  if (key == '0') {
    birds = new ArrayList<Bird>();
    flocks = new ArrayList[1];
    for (ArrayList f : flocks) {
      f = new ArrayList<Bird>();
    }
    space = new Bird[width + 1][height + 1];
  }
  
  if (key == 'c') {
    
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
