ArrayList<Bird> birds = new ArrayList<Bird>();
ScrollBar[] bars = new ScrollBar[8];
String[] titles = {"Cohere", "Avoid", "Align","Max Speed","Max Steering","Cohere distance","Avoid distance","Align distance"};
PVector mouse = new PVector();
int width = 800;
int height = 600;
Bird[][] space = new Bird[width + 1][height + 1];

void setup() {
  size(width, height);
  for (int i = 0; i < 25; i++) {
    birds.add(new Bird(random(width), random(height)));
  }
  for (int i = 0; i < bars.length; i++) {
    bars[i] = new ScrollBar(25, 50+i*50, 150,15,titles[i]);
  }
}

void draw() {
  mouse.set(mouseX, mouseY);
  background(50);
  for (int i = 0; i < bars.length; i++) {
    bars[i].run();
  }
  for (Bird b : birds) {
    b.display();
    b.flock(birds);
    b.update();
  }
}

void keyPressed() {
  birds.add(new Bird(mouseX, mouseY));
}
