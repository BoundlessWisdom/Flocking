class TargetString {
  ArrayList<PVector> targets = new ArrayList<PVector>();
  final String name;
  
  HashMap<String, TargetString> presets = new HashMap<String, TargetString>();
  final TargetString circle = new TargetString("circle");
  final int numberOfPresets = presets.size();
  
  TargetString(String name, PVector[] initialTargets) {
    this.name = name;
    targets = new ArrayList<PVector>(Arrays.asList(initialTargets));
  }
  TargetString(String name) {
    this.name = name;
  }
  
  TargetString place(String key, int x, int y) {
    return place(presets.get(key), x, y);
  }
  TargetString place(TargetString targetSet, int x, int y) {
    for (int i = 0; i < targetSet.targets.size(); i++) {
      PVector p = targetSet.targets.get(i);
      p.add(x, y, 0);
      if (p.x < 0 || p.x > width || p.y < 0 || p.y > height) {
        targetSet.targets.remove(i);
        i--;
      }
    }
    return targetSet;  //Not yet written.
  }
  
  TargetString size(float factor) {
    for (PVector t : targets) {
      t.mult(factor);
    }
    return this;
  }
  
  TargetString store(String name, PVector[] newTargets) {
    return store(name, new TargetString(name, newTargets));
  }
  TargetString store(String name, TargetString targetSet) {
    presets.put(name, targetSet);
    return targetSet;
  }
  
  void add(PVector[] targets) {
    this.targets.addAll(Arrays.asList(targets));
  }
  void add(PVector[] targets, int index) {
    this.targets.addAll(index, Arrays.asList(targets));
  }
}
