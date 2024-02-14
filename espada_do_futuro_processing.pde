import oscP5.*;

// osc
OscP5 osc;

// Tiles
Tile[] tiles;

int minTileSize = 60;
int maxTileSize = 1000;
float tileSize;
int rows, columns;

// Colors 
JSONArray palettes;

void setup() {
  // basic setup
  size(900, 900);
  // fullScreen();
  frameRate(60);

  // osc setup
  osc = new OscP5(this,1200);
  osc.plug(this, "receiveMessage", "/button0");
  osc.plug(this, "receiveMessage", "/button1");
  osc.plug(this, "receiveMessage", "/button2");
  osc.plug(this, "receiveMessage", "/button3");
  osc.plug(this, "receiveMessage", "/button4");

  // tiles setup
  for (int i = minTileSize; i <= maxTileSize; i++) {
    if (width %  i== 0 && height % i == 0) {
      println(i);
      tileSize = i;
      break;
    }
  }

  columns = floor(width / tileSize);
  rows = floor(height / tileSize);
  // columns = 1;
  // rows = 4;
  int totalTiles = rows * columns;
  tiles = new Tile[totalTiles];

  int index = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
      tiles[index] = new Tile(j, i, tileSize, index);
      index++;
    }
  }

  // colors setup
  palettes = loadJSONArray("palettes.json");
  colorMode(HSB,360,100,100,255);
  changePalette(0);
  noFill();
}

void draw() {
  //background(backgroundColor);
  for (int i = 0; i < tiles.length; i++) {
    tiles[i].update();
    tiles[i].display();
  }
}

void receiveMessage (int pressed, String buttonName) {
  buttonFeedBask(buttonName);
  if (buttonName.equals("button0")) {
    changePalette(newPaletteIndex());
  }
  if (buttonName.equals("button1")) {
    fill(0, 255, 0);
  }
  if (buttonName.equals("button2")) {
    fill(0, 0, 255);
  }
  if (buttonName.equals("button3")) {
    fill(255, 255, 0);
  }
  if (buttonName.equals("button4")) {
    fill(255, 0, 255);
  }
}

// print which button was pressed
void buttonFeedBask (String name) {
  println(name, "pressed");
}

//void getColors(int index) {
  
//}

void changePalette(int index) {
  JSONObject chosenPalette = palettes.getJSONObject(index);
  JSONObject innerCurve = chosenPalette.getJSONObject("innerCurve");
  int innerHue = innerCurve.getInt("hue");
  int innerSaturation = innerCurve.getInt("saturation");
  int innerBrightness = innerCurve.getInt("brightness");
  color innerColor = color(innerHue, innerSaturation, innerBrightness);
  for (int i = 0; i < tiles.length; i++) {
    // tiles[i].getNewColors(innerColor, middleColor, outterColor);
  }
}

int newPaletteIndex() {
  return floor(random(14));
} 
  
