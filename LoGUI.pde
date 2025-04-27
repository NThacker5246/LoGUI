class Button {
  PImage sprite;
  int x, y, w, h;
  boolean flag;
  String name;

  Button(PImage img, int px, int py, int pw, int ph, String nam) {
    sprite = img;
    x = px;
    y = py;
    w = pw;
    h = ph;
    flag = false;
    name = nam;
  }

  void tick() {
    if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
      method(name);
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    image(sprite, x, y, w, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Slider {
  PImage bg, fg;
  int x, y, w, h;
  float value, minV, maxV;

  Slider(PImage b, PImage f, int px, int py, int pw, int ph, float minValue, float maxValue) {
    bg = b;
    fg = f;
    x = px;
    y = py;
    w = pw;
    h = ph;
    value = 0;
    minV = minValue;
    maxV = maxValue;
  }

  void tick() {
    float curPos = (value + minV) / (abs(minV) + abs(maxV));
    curPos *= w;
    if (mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value += (((float) (mouseX - curPos - x) / w) * (abs(minV) + abs(maxV))) - minV;
      value = clamp(value, minV, maxV);
    }

    image(bg, x, y, w, h);
    image(fg, x + curPos, y, 20, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Toggle {
  PImage bg, fg;
  int x, y, w, h;
  boolean flag, value;

  Toggle(PImage b, PImage f, int px, int py, int pw, int ph) {
    bg = b;
    fg = f;
    x = px;
    y = py;
    w = pw;
    h = ph;
    flag = false;
  }

  void tick() {
    if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      value = !value;
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    image(bg, x, y, w, h);
    image(fg, value ? x + w - 20 : x, y, 20, h);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Dropdown {
  int x, y, w, h, d;
  boolean open, flag;
  String[] mens;
  int value;

  Dropdown(String[] values, int px, int py, int pw, int ph, int dh) {
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dh;
    mens = values;
  }

  void tick() {
    if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((y + (h >> 1)) - mouseY) <= (h/2)) {
      open = !open;
      flag = mousePressed;
    } else if (!mousePressed) {
      flag = false;
    }

    if (open) {
      for (int i = 0; i < mens.length; i++) {
        int yn = y + d * (i+1);
        fill(color(75, 75, 200));
        rect(x, yn, w, h);
        fill(255);
        text(mens[i], x, yn+d/2);
        if (mousePressed && flag != mousePressed && abs((x + (w >> 1)) - mouseX) <= w && abs((yn + (h >> 1)) - mouseY) <= (h/2)) {
          value = i;
          open = false;
          flag = mousePressed;
        } else if (!mousePressed) {
          flag = false;
        }
      }
    }
    fill(color(75, 75, 200));
    rect(x, y, w, h);
    fill(255);
    text(mens[value], x, y + d/2);
  }

  void move(int deltaX, int deltaY) {
    x += deltaX;
    y += deltaY;
  }
}

class Window {
  boolean flag = false;
  int x, y, w, h, d;
  String name;
  Slider[] slds;
  Button[] btns;
  Toggle[] togs;
  Dropdown[] drops;

  Window(String name1, int px, int py, int pw, int ph, int dh) {
    name = name1;
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dh;
  }

  void tick() {
    fill(255);
    rect(x, y, w, h);
    fill(150);
    rect(x, y, w, d);
    fill(255);
    text(name, x, y + (d/2));
    if (flag || (mousePressed && abs((x + (w >> 1)) - mouseX) <= (w/2) && abs((y + (d >> 1)) - mouseY) <= (d / 2))) {
      if (!mousePressed) {
        flag = false;
        return;
      }
      int deltaX = mouseX - x;
      int deltaY = mouseY - y;
      for (int i = 0; i < slds.length; i++) {
        slds[i].move(deltaX, deltaY);
      }
      for (int i = 0; i < btns.length; i++) {
        btns[i].move(deltaX, deltaY);
      }
      for (int i = 0; i < togs.length; i++) {
        togs[i].move(deltaX, deltaY);
      }
      for (int i = 0; i < drops.length; i++) {
        drops[i].move(deltaX, deltaY);
      }
      x = mouseX;
      y = mouseY;
      flag = true;
    }

    for (int i = 0; i < slds.length; i++) {
      slds[i].tick();
    }
    for (int i = 0; i < btns.length; i++) {
      btns[i].tick();
    }
    for (int i = 0; i < togs.length; i++) {
      togs[i].tick();
    }
    for (int i = 0; i < drops.length; i++) {
      drops[i].tick();
    }
  }
}

class Tab {
  String[] subTabs;
  int x, y, w, h, d, value;
  boolean flag;

  Tab(String[] subTb, int px, int py, int pw, int ph, int dw) {
    subTabs = subTb;
    x = px;
    y = py;
    w = pw;
    h = ph;
    d = dw;
  }

  void tick() {
    for (int i = 0; i < subTabs.length; i++) {
      int xn = x + i * d;
      fill(255);
      rect(xn, y, d, h);
      fill(0);
      text(subTabs[i], xn, y + h/2);

      if (mousePressed && flag != mousePressed && abs((xn + (d >> 1)) - mouseX) <= (d/2) && abs((y + (h >> 1)) - mouseY) <= (h / 2)) {
        value = i;
        flag = mousePressed;
      } else if (!mousePressed) {
        flag = false;
      }
    }
    method(subTabs[value]);
  }
}

float clamp(float val, float minV, float maxV) {
  return min(max(val, minV), maxV);
}
