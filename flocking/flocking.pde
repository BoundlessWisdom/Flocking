ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList[] flocks = new ArrayList[3];
ScrollBar[] bars = new ScrollBar[8];
String[] bartitles = {"Cohere", "Avoid", "Align","Max Speed","Max Steering","Cohere distance","Avoid distance","Align distance"};
Button[] buttons = new Button[1];
String[] buttontitles = {"Follow"};
PVector mouse = new PVector();
int width = 800;
int height = 600;
Bird[][] space = new Bird[width + 1][height + 1];

void setup() {
  size(width, height);
  for (int i = 0; i < flocks.length; i++) {
    flocks[i] = new ArrayList<Bird>();
  }
  for (float i = 0; i < flocks.length*5; i++) {
    addBird((int)(i/5.0f));
  }
  for (int i = 0; i < 15; i++) {
    int r = (int)random(flocks.length);
    if(r == 3) { r = 2; }
    addBird(r);
  }
  for (int i = 0; i < bars.length; i++) {
    bars[i] = new ScrollBar(25, 50+i*50, 150, 15, bartitles[i]);
  }
  for (int i = 0; i < buttons.length; i++) {
    buttons[i] = new Button(40+i*50, bars.length*50, 15, 15, buttontitles[i]);
  }
}
void addBird(int f) {
  Bird bird = new Bird(random(width), random(height));
  birds.add(bird);
  flocks[f].add(bird);
  bird.flockWith(flocks[f]);
}

void draw() {
  mouse.set(mouseX, mouseY);
  background(50);
  for (int i = 0; i < bars.length; i++) {
    bars[i].run();
  }
  for (Bird b : birds) {
    b.display();
    b.flock();
    b.update();
  }
}

void keyPressed() {
  birds.add(new Bird(mouseX, mouseY));
}
