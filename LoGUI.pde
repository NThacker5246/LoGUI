boolean mouseOPressed = false, mp1 = false;

int _FONT = 16;
boolean _STRK = true;
PShader G_BLUR;

void loadConsts(){
   G_BLUR = loadShader("blur.glsl");
}

void win_tick() {
  if (!mp1 && mousePressed) {
    mp1 = true;
    mouseOPressed = true;
  } else if (mp1 && mousePressed) {
    mouseOPressed = false;
  } else if (!mousePressed && mp1) {
    mp1 = false;
  }
}

void niceLooks(){
  _STRK = false;
  noStroke();
  lights();
}

void niceLight(){
  pointLight(230, 230, 230, width/2, height/2, 504);
  ambient(120);
  specular(120);
}

class GUIElem {
  int x, y, w, h;
  int shadsX, shadsY, stX, stY;
  int roundsX, roundsY, roundsW, roundsH;
  int back, txt;
  String text;
  PImage img, bob;

  GUIElem(int px, int py, int pw, int ph, int bcol, int col, String name) {
    x = px;
    y = py;
    w = pw;
    h = ph;
    back = bcol;
    txt = col;
    text = name;
  }

  GUIElem(int px, int py, int pw, int ph, String name) {
    x = px;
    y = py;
    w = pw;
    h = ph;
    back = 255;
    txt = 0;
    text = name;
  }

  GUIElem(String name) {
    x = 0;
    y = 0;
    w = 100;
    h = 50;
    back = 255;
    txt = 0;
    text = name;
  }

  void tick() {
    if(shadsX != 0 || shadsY != 0){
      fill(0);
      if(_STRK) noStroke();
      shader(G_BLUR);
      rect(x + shadsX, y + shadsY, w, h, roundsX, roundsY, roundsW, roundsH);
      resetShader();
      if(_STRK) stroke(0);
    }
    if (img != null) {
      image(img, x, y, w, h, roundsX, roundsY, roundsW, roundsH);
    } else {
      fill(back);
      rect(x, y, w, h, roundsX, roundsY, roundsW, roundsH);
      if (text != "") {
        fill(txt);
        text(text, x + stX, y + stY, w, h);
      }
    }
    //fill(255); 
    tickUI();

    tickEvent();
  }

  void tickEvent() {
  }

  void tickUI() {
  }

  void drawBobishka(float curPos) {
    if (bob != null) {
      image(bob, x + curPos, y, 20, h);
    } else {

      fill(txt);
      rect(x + curPos, y, 20, h);
    }
  }


  GUIElem setLocales(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    return this;
  }

  GUIElem setLocsRelative(GUIElem rel, int x, int y) {
    this.x = rel.x + x;
    this.y = rel.y + y;
    return this;
  }

  GUIElem setColor(int bcol, int tcol) {
    back = bcol;
    txt = tcol;
    return this;
  }

  GUIElem setNameUp(String name) {
    text = name;
    return this;
  }

  GUIElem setRounds(int rounds) {
    roundsX = rounds;
    roundsY = rounds;
    roundsW = rounds;
    roundsH = rounds;
    return this;
  }

  GUIElem setRounds(int rX, int rY, int rW, int rH) {
    roundsX = rX;
    roundsY = rY;
    roundsW = rW;
    roundsH = rH;
    return this;
  }

  GUIElem setImage(PImage img) {
    this.img = img;
    return this;
  }
  
  GUIElem setShadows(int px, int py){
    shadsX = px;
    shadsY = py;
    return this;
  }
  
  GUIElem shiftText(int px, int py){
    stX = px;
    stY = py;
    return this;
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Button extends GUIElem {
  String func;
  boolean flag;

  Button(int px, int py, int pw, int ph, int bcol, int col, String name, String func) {
    super(px, py, pw, ph, bcol, col, name);
    this.func = func;
  }

  Button(int px, int py, int pw, int ph, String name, String func) {
    super(px, py, pw, ph, name);
    this.func = func;
  }

  Button(String name, String func) {
    super(name);
    this.func = func;
  }

  Button(int px, int py, int pw, int ph, int bcol, int col, String func) {
    super(px, py, pw, ph, bcol, col, func);
    this.func = func;
  }

  Button(int px, int py, int pw, int ph, String func) {
    super(px, py, pw, ph, func);
    this.func = func;
  }

  Button(String func) {
    super(func);
    this.func = func;
  }

  void tickEvent() {
    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
      method(func);
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }
  }
}

class Slider extends GUIElem {
  float value, minV, maxV;
  boolean flag;

  Slider(int px, int py, int pw, int ph, int bcol, int col, String name, float minV, float maxV) {
    super(px, py, pw, ph, bcol, col, name);
    this.minV = minV;
    this.maxV = maxV;
  }

  Slider(int px, int py, int pw, int ph, String name, float minV, float maxV) {
    super(px, py, pw, ph, name);
    this.minV = minV;
    this.maxV = maxV;
  }

  Slider(String name, float minV, float maxV) {
    super(name);
    this.minV = minV;
    this.maxV = maxV;
  }

  void tickEvent() {
    float curPos = (value - minV) / (abs(minV) + abs(maxV));
    curPos *= (w - 20);
    if ((mouseOPressed || flag) && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value += (((float) (mouseX - curPos - x) / w) * (abs(minV) + abs(maxV)));
      value = clamp(value, minV, maxV);
      flag = true;
    } else {
      flag = false;
    }

    drawBobishka(curPos);
  }
}

class Toggle extends GUIElem {

  boolean flag, value;

  Toggle(int px, int py, int pw, int ph, int bcol, int col, String name) {
    super(px, py, pw, ph, bcol, col, name);
  }

  Toggle(int px, int py, int pw, int ph, String name) {
    super(px, py, pw, ph, name);
  }

  Toggle(String name) {
    super(name);
  }

  void tickEvent() {
    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value = !value;
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    drawBobishka(value ? w - 20 : 0);
  }
}

class Dropdown extends GUIElem {
  boolean open, flag;
  String[] mens;
  int value, d;

  Dropdown(int px, int py, int pw, int ph, int bcol, int col, String[] name, int d) {
    super(px, py, pw, ph, bcol, col, name[0]);
    mens = name;
    this.d = d;
  }

  Dropdown(int px, int py, int pw, int ph, String[] name, int d) {
    super(px, py, pw, ph, name[0]);
    mens = name;
    this.d = d;
  }

  Dropdown(String[] name) {
    super(name[0]);
    mens = name;
    d = h;
  }

  void tickEvent() {
    if (mouseOPressed && flag != mouseOPressed && abs((x + (w >> 1)) - mouseX) <= w/2 && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      open = !open;
      flag = mouseOPressed;
    } else if (!mouseOPressed) {
      flag = false;
    }

    if (open) {
      for (int i = 0; i < mens.length; i++) {
        int yn = y + d * (i+1);

        fill(back);
        rect(x, yn, w, h);
        fill(txt);
        text(mens[i], x, yn + (h - _FONT)/2, w, h);

        if (mouseOPressed && flag != mouseOPressed && abs((x + (w >> 1)) - mouseX) <= w && abs((yn + (h >> 1)) - mouseY) <= (h/2)) {
          value = i;
          open = false;
          flag = mouseOPressed;
        } else if (!mouseOPressed) {
          flag = false;
        }
      }
    }


    text = mens[value];
  }
}

class TextField extends GUIElem {

  TextField(int px, int py, int pw, int ph, int bcol, int col, String name, int buf) {
    super(px, py, pw, ph, bcol, col, name);
    cnt = 0;
    value = new char[buf + 1];
    value[0] = '\0';
  }

  TextField(int px, int py, int pw, int ph, String name, int buf) {
    super(px, py, pw, ph, name);
    cnt = 0;
    value = new char[buf + 1];
    value[0] = '\0';
  }

  TextField(String name, int buf) {
    super(name);
    cnt = 0;
    value = new char[buf + 1];
    value[0] = '\0';
  }

  char[] value;
  int cnt, trc;
  int tmr = 0;
  boolean flag = false, isTaken;

  void tickEvent() {
    if (isTaken) {
      if (keyPressed && (!flag || millis() - tmr >= 200)) {
        flag = true;
        if (key != '' && keyCode == 0) {
          freeKey(value, trc);
          value[trc] = key;
          trc += 1;
          cnt += 1;
        } else if (key == '') {
          deleteKey(value, trc-1);
          trc -= 1;
          cnt -= 1;
        } else {
          switch(keyCode) {
          case LEFT:
            trc -= 1;
            break;
          case RIGHT:
            trc += 1;
            break;
          }
        }
        cnt = (int) clamp(cnt, 0, value.length - 1);
        trc = (int) clamp(trc, 0, value.length - 1);
        tmr = millis();
      } else if (!keyPressed) {
        flag = false;
      }

      if (mouseOPressed) isTaken = false;
    }

    if (mouseOPressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) isTaken = true;

    fill(txt);
    text(value, 0, cnt, x, y +(h + _FONT/2)/2);
    if(_STRK) stroke(txt);
    line(x + (9.75 / 16 * _FONT) * trc, y, x + (9.75 / 16 * _FONT) * trc, y + h);
    if(_STRK) stroke(0);
  }

  int parseInt() {
    int result = 0;
    for (int i = 0; i < cnt; i++) {
      result *= 10;
      result += value[i] - '0';
    }
    return result;
  }

  float parseFloat() {
    int result = 0;
    int sig = 0;
    boolean sg = true;
    for (int i = 0; i < cnt; i++) {
      if (value[i] == ',' || value[i] == '.') {
        sg = true;
        continue;
      }
      if (sg) sig *= 10;
      result *= 10;
      result += value[i] - '0';
    }
    return (float) result / (float) sig;
  }
}

class Plotter extends GUIElem {
  int buf, dtm, tc;
  float[] dots;
  float value, tv, ix;

  Plotter(int px, int py, int pw, int ph, int bcol, int col, String name, int dotCount, int tickCount, float min, float max) {
    super(px, py, pw, ph, bcol, col, name);
    dots = new float[dotCount];
    dtm = dotCount;
    tc = tickCount;
    tv = (max - min) / tc;
    ix = min;
  }

  Plotter(int px, int py, int pw, int ph, String name, int dotCount, int tickCount, float min, float max) {
    super(px, py, pw, ph, name);
    dots = new float[dotCount];
    dtm = dotCount;
    tc = tickCount;
    tv = (max - min) / tc;
    ix = min;
  }

  Plotter(String name, int dotCount, int tickCount, float min, float max) {
    super(name);
    dots = new float[dotCount];
    dtm = dotCount;
    tc = tickCount;
    tv = (max - min) / tc;
    ix = min;
  }

  void tick() {
    buf = (buf + 1) % dtm;
    dots[buf] = value;
    fill(255);
    rect(x, y, w, h);
    fill(0);
    for (int i = 0; i < dtm; i++) circle(i*3 + x, -dots[(buf + i) % dtm] * (h*0.4) + y + h/2, 2);
    int ttc = h / tc;
    for (int i = 0; i <= tc; i++) text(int(ix + tv * i), x - 45, y + ttc * (tc - i));
  }
}

class Window extends GUIElem {
  Window(int px, int py, int pw, int ph, int d, int bcol, int col, String name) {
    super(px, py, pw, ph, bcol, col, name);
    this.d = d;
  }

  Window(int px, int py, int pw, int ph, int d, String name) {
    super(px, py, pw, ph, name);
    this.d = d;
  }

  Window(String name, int d) {
    super(name);
    this.d = d;
  }

  boolean flag = false;
  int d, tDX, tDY, delX, delY;

  GUIElem[] elems;

  void tickEvent() {
    if (flag || (mouseOPressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (d >> 1)) - mouseY) <= (d / 2))) {
      if (!mousePressed) {
        flag = false;
        delX = 0;
        delY = 0;
        return;
      }
      if (!flag) {
        tDX = mouseX - x;
        tDY = mouseY - y;
      }
      flag = true;
      delX = mouseX - x - tDX;
      delY = mouseY - y - tDY;
      move();
    }

    if (elems != null) for (int i = 0; i < elems.length; i++) {
      elems[i].tick();
    }
  }

  void tickUI() {
    noFill();
    rect(x, y, w, d);
  }

  void move() {
    if (elems != null) for (int i = 0; i < elems.length; i++) elems[i].move(delX, delY);
    x += delX;
    y += delY;
  }

  boolean isOverlapping(Window other) {
    return (!(x + w < other.x || x > other.x + other.w || y + h < other.y || y > other.y + other.h));
  }
}

class Tab extends GUIElem {
  String[] subTabs;
  int d, value;
  boolean flag;

  Tab(int px, int py, int pw, int ph, int bcol, int col, String[] name, int dw) {
    super(px, py, pw, ph, bcol, col, "");
    subTabs = name;
    d = dw;
  }

  Tab(int px, int py, int pw, int ph, String[] name, int dw) {
    super(px, py, pw, ph, "");
    subTabs = name;
    d = dw;
  }

  Tab(String[] name, int dw) {
    super("");
    subTabs = name;
    d = dw;
  }

  void tickEvent() {
    for (int i = 0; i < subTabs.length; i++) {
      int xn = x + i * d;
      fill(255);
      rect(xn, y, d, h);
      fill(0);
      text(subTabs[i], xn, y + (h - _FONT)/2, w, h);

      if (mouseOPressed && flag != mouseOPressed && abs((xn + (d >> 1)) - mouseX) <= (d/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
        value = i;
        flag = mouseOPressed;
      } else if (!mouseOPressed) {
        flag = false;
      }
    }
    method(subTabs[value]);
  }
}

class MainMenu {
  String[] top_text;
  String[][] funcs;
  int value;
  boolean spamclick, closer;

  boolean[] flg;

  MainMenu(int count) {
    top_text = new String[count];
    funcs = new String[count][];
    flg = new boolean[count];
  }

  void addNextMenu(int id, String name, String[] dropNames) {
    top_text[id] = name;
    funcs[id] = dropNames;
  }

  void tick() {
    fill(255);
    for (int i = 0; i < top_text.length; i++) {
      if (mouseOPressed && spamclick != mousePressed && abs((i * (20 * top_text[i].length()) + (20 * top_text[i].length() >> 1)) - mouseX) <= (10 * top_text[i].length()) && abs(15 - mouseY) <= 15) {

        if (i != value) {
          flg[i] = true;
          flg[value] = false;
        } else flg[i] = !flg[i];
        value = i;
        closer = true;
        spamclick = mousePressed;
      } else {
        spamclick = false;
      }

      if (flg[i]) {
        for (int j = 0; j < funcs[i].length; j++) {
          rect(i * (20 * top_text[i].length()), 30 + j * 30, 20 * top_text[i].length(), 30);
          fill(0);
          text(funcs[i][j], i * (20 * top_text[i].length()), 30 + j * 30 + (30 - _FONT/2));
          fill(255);
          if (mouseOPressed && spamclick != mousePressed && abs((i * (20 * top_text[i].length()) + (20 * top_text[i].length() >> 1)) - mouseX) <= (10 * top_text[i].length()) && abs(30*0.75 + 30 + j * 30 - mouseY) <= 15) {
            method(funcs[i][j]);
            flg[i] = false;
          }
        }
      }

      rect(i * (20 * top_text[i].length()), 0, 20 * top_text[i].length(), 30);
      fill(0);
      text(top_text[i], i * (20 * top_text[i].length()), (30 - _FONT/2));
      fill(255);
    }
  }
}


float clamp(float val, float minV, float maxV) {
  return min(max(val, minV), maxV);
}

int clamp(int val, int minV, int maxV) {
  return min(max(val, minV), maxV);
}

void freeKey(char[] value, int snuf) {
  for (int i = value.length-1; i > snuf; i--) {
    value[i] = value[clamp(i - 1, i, value.length-1)];
  }
}

void deleteKey(char[] value, int snuf) {
  for (int i = clamp(snuf, 0, value.length-1); i < value.length - 1; i++) {
    value[i] = value[clamp(i + 1, i, value.length-1)];
  }
}
