final int COLOR_SWAP = 1, FADE = 2, POPUP = 3, COLOR_CHANGE = 4, BRIGHTEN = 5;

class Animator {
  GUIElem el;
  int type, state, booted, c1, c2, x, y, w, h;
  float scale;


  Animator(GUIElem el, int type) {
    this.el = el;
    this.type = type;
  }

  void tick() {
    if (--state == 0) {
      switch(type) {
      case COLOR_SWAP:
        int tmp = el.back;
        el.back = el.txt;
        el.txt = tmp;
        break;
      case FADE:
        el.txt = color(red(el.txt), green(el.txt), blue(el.txt), 1);
        el.back = color(red(el.back), green(el.back), blue(el.back), 1);
        break;

      case BRIGHTEN:
        el.txt = color(red(el.txt), green(el.txt), blue(el.txt), 255);
        el.back = color(red(el.back), green(el.back), blue(el.back), 255);
        break;

      case COLOR_CHANGE:
        tmp = el.back;
        el.back = c1;
        el.txt = c2;
        break;

      case POPUP:
        el.x = (int) (x / scale);
        el.y = (int) (y / scale);
        el.w = (int) (w * scale);
        el.h = (int) (h * scale);
        break;
      }
    } else if (state > 0) {
      switch(type) {
      case FADE:
        float alpha = ((float) state / (float) booted);
        el.txt = color(red(el.txt), green(el.txt), blue(el.txt), alpha*255);
        el.back = color(red(el.back), green(el.back), blue(el.back), alpha*255);
        break;

      case BRIGHTEN:
        alpha = ((float) state / (float) booted);
        el.txt = color(red(el.txt), green(el.txt), blue(el.txt), (1 - alpha)*255);
        el.back = color(red(el.back), green(el.back), blue(el.back), (1 - alpha)*255);
        break;

      case COLOR_CHANGE:
        alpha = ((float) state / (float) booted);
        el.txt = (int) ((c1 * alpha) + (c2 * (1-alpha)));
        el.back = (int) ((c2 * alpha) + (c1 * (1-alpha)));
        break;

      case POPUP:
        float size = ((float) state / (float) booted) * scale;
        el.x = (int) (x / size);
        el.y = (int) (y / size);
        el.w = (int) (w * size);
        el.h = (int) (h * size);
        break;
      }
    }
  }

  void begin(int tmr) {
    state = tmr;
    booted = tmr;
    switch(type) {
    case COLOR_SWAP:
      int tmp = el.back;
      el.back = el.txt;
      el.txt = tmp;
      break;
    case FADE:
      el.txt = color(red(el.txt), green(el.txt), blue(el.txt), 255);
      el.back = color(red(el.back), green(el.back), blue(el.back), 255);
      break;
    case BRIGHTEN:
      el.txt = color(red(el.txt), green(el.txt), blue(el.txt), 1);
      el.back = color(red(el.back), green(el.back), blue(el.back), 1);
      break;
    case COLOR_CHANGE:
      c1 = el.txt;
      c2 = el.back;
      break;
    }
  }
  void begin(int tmr, float scale) {
    state = tmr;
    booted = tmr;
    switch(type) {
    case POPUP:
      this.scale = scale;
      x = el.x;
      y = el.y;
      w = el.w;
      h = el.h;
      break;
    }
  }
}
