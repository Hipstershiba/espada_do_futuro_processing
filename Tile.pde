class Tile {
  int index;
  float position_x, position_y, 
        size, 
        rotation, nextRotation, 
        weightModifier, nextWeightModifier, lerpWeightModifierIndex,
        lerpColorIndex;
  private color innerColor, middleColor, outterColor,
        nextInnerColor, nextMiddleColor, nextOutterColor;

  Tile (int position_x, int position_y, float size, int index) {
    this.size = size;
    this.position_x = position_x * size;
    this.position_y = position_y * size;
    this.index = index;
    this.innerColor = color(0);
    this.middleColor = color(127);
    this.outterColor = color(255);
    lerpColorIndex = 0;
    this.weightModifier = 1;

    this.rotation = floor(random(2)) * HALF_PI;
    this.nextRotation = this.rotation;
    // this.nextColors = {color1: this.color1, color2: this.color2, color3: this.color3};
  }

  void display() {
    push();
    strokeCap(SQUARE);
    translate(this.position_x  + this.size / 2, this.position_y + this.size / 2);
    strokeWeight(max(1, this.size / 2 + this.weightModifier * 4));
    stroke(innerColor);
    makeArc();
    strokeWeight(max(1, this.size / 4 + this.weightModifier * 2));
    stroke(middleColor);
    makeArc();
    strokeWeight(max(1, this.size / 10 + this.weightModifier * 0.5));
    stroke(outterColor);
    makeArc();
    pop();
  }

  void update() {
    updateColors();
  }

  void makeArc() {
    arc(this.size / 2, -this.size / 2, this.size, this.size, PI * 0.5, PI);
    arc(-this.size / 2, this.size / 2, this.size, this.size, -PI * 0.5, 0);
  }
  void getNewColors(color newInnerColor, color newMiddleColor, color newOutterColor) {
    this.lerpColorIndex = 0;
    this.nextInnerColor = newInnerColor;
    this.nextMiddleColor = newMiddleColor;
    this.nextOutterColor = newOutterColor;
  }

  void updateColors() {
    this.innerColor = lerpColor(this.innerColor, this.nextInnerColor, this.lerpColorIndex);
    this.middleColor = lerpColor(this.middleColor, this.nextMiddleColor, this.lerpColorIndex);
    this.outterColor = lerpColor(this.outterColor, this.nextOutterColor, this.lerpColorIndex);
    this.lerpColorIndex += 0.01;
    this.lerpColorIndex = constrain(this.lerpColorIndex, 0, 1);
  }

  void getNewWeightModifier(float newWeightModifier) {
    this.lerpWeightModifierIndex = 0;
    this.nextWeightModifier = newWeightModifier;
  }

  void updateWeightModifier() {
    this.weightModifier = lerp(this.weightModifier, this.nextWeightModifier, this.lerpWeightModifierIndex);
    this.lerpWeightModifierIndex += 0.01;
    this.lerpWeightModifierIndex = constrain(this.lerpWeightModifierIndex, 0, 1);
  }
}
