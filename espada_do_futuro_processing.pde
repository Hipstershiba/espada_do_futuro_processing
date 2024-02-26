import oscP5.*;

// osc
OscP5 osc;

// Tiles
Tile[] tiles;

int minTileSize = 60;
int maxTileSize = 200;
float tileSize;
int rows, columns;

// Colors 
JSONArray palettes;
int paletteIndex = 1;

void setup() {
  // basic setup
  //  size(900, 900);
  fullScreen(2);
  frameRate(60);

  // osc setup
  osc = new OscP5(this,1200);
  osc.plug(this, "receiveMessage", "/button0");
  osc.plug(this, "receiveMessage", "/button1");
  osc.plug(this, "receiveMessage", "/button2");
  osc.plug(this, "receiveMessage", "/button3");
  osc.plug(this, "receiveMessage", "/button4");

  // tiles setup
  // for (int i = minTileSize; i <= maxTileSize; i++) {
  //   if (width % i == 0 && height % i == 0) {
  //     println(i);
  //     tileSize = i;
  //     break;
  //   }
  // }

  rows = 12;
  tileSize = height / rows;
  columns = ceil(width / tileSize);
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
  colorMode(HSB,360,100,100,255);
  noFill();
  palettes = loadJSONArray("palettes.json");
  changePalette(paletteIndex);
}

void draw() {
  // ToDo: draw the background in the tile class
  // background(getBackgroundColor(paletteIndex));
  for (int i = 0; i < tiles.length; i++) {
    tiles[i].update();
    tiles[i].display();
  }
}

void receiveMessage (int pressed, String buttonName) {
  buttonFeedBask(buttonName);
  if (buttonName.equals("button0")) {
    changePalette(paletteIndex);
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

color getBackgroundColor(int index) {
  JSONObject chosenPalette = palettes.getJSONObject(index);
  JSONObject backgroundColor = chosenPalette.getJSONObject("background");
  int backgroundHue = backgroundColor.getInt("hue");
  int backgroundSaturation = backgroundColor.getInt("saturation");
  int backgroundBrightness = backgroundColor.getInt("brightness");
  return color(backgroundHue, backgroundSaturation, backgroundBrightness);
}

color getInnerColor(int index) {
  JSONObject chosenPalette = palettes.getJSONObject(index);
  JSONObject innerCurve = chosenPalette.getJSONObject("innerCurve");
  int innerHue = innerCurve.getInt("hue");
  int innerSaturation = innerCurve.getInt("saturation");
  int innerBrightness = innerCurve.getInt("brightness");
  return color(innerHue, innerSaturation, innerBrightness);
}

color getMiddleColor(int index) {
  JSONObject chosenPalette = palettes.getJSONObject(index);
  JSONObject middleCurve = chosenPalette.getJSONObject("middleCurve");
  int middleHue = middleCurve.getInt("hue");
  int middleSaturation = middleCurve.getInt("saturation");
  int middleBrightness = middleCurve.getInt("brightness");
  return color(middleHue, middleSaturation, middleBrightness);
}

color getOuterColor(int index) {
  JSONObject chosenPalette = palettes.getJSONObject(index);
  JSONObject outerCurve = chosenPalette.getJSONObject("outerCurve");
  int outerHue = outerCurve.getInt("hue");
  int outerSaturation = outerCurve.getInt("saturation");
  int outerBrightness = outerCurve.getInt("brightness");
  return color(outerHue, outerSaturation, outerBrightness);
}

void changePalette(int index) {
  color innerColor = getInnerColor(index);
  color middleColor = getMiddleColor(index);
  color outerColor = getOuterColor(index);
  for (int i = 0; i < tiles.length; i++) {
    tiles[i].getNewColors(innerColor, middleColor , outerColor );
  }
  newPaletteIndex();
}
  
void newPaletteIndex() {
  paletteIndex =  floor(random(palettes.size()));
  println("palette index:", paletteIndex);
}
