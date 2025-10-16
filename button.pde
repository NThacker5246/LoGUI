Button btn;
Slider sld;
Toggle tog;
Dropdown drop;
Window win, win2, ab;
Tab tab;
TextField txt;

Plotter plt;
MainMenu menu;
boolean about, toExit, butanim;
int animate = 0;
Animator ani_button, aboutAnim;

GUIElem el;

void setup() {
  loadConsts();
  //noStroke();
  frameRate(60);
  textFont(createFont("Lucida Console", 16));
  size(1000, 500, P3D);
  
  btn = new Button(5, 25, 50, 20, "btn1");
  sld = new Slider(5, 55, 450, 50, color(50, 50, 200), color(200, 50, 50), "sld", -1, 10);
  sld.shiftText(455, 35).setShadows(5, 5);
  tog = new Toggle(5, 120, 100, 30, color(20, 50, 70), color(10, 200, 10), "tog");
  String[] str = {"Item1", "Item2", "Item3"};
  drop = new Dropdown(5, 160, 100, 20, color(75, 75, 200), 255, str, 20);
  win = new Window(50, 100, 500, 200, 20, "Test.exe");
  win2 = new Window(700, 100, 500, 200, 20, "Default.exe");

  plt = new Plotter(300, 0, 100, 200, 255, 0, "", 34, 5, 0, 255);

  win.elems = new GUIElem[4];
 
  win.elems[0] = btn;
  win.elems[1] = sld;
  win.elems[2] = tog;
  win.elems[3] = drop;
  
  btn.addParent(win, false);
  sld.addParent(win, false);
  tog.addParent(win, false);
  drop.addParent(win, false);
  
  ani_button = new Animator(btn, POPUP);
  String[] st = {"w1", "w2"};
  tab = new Tab(500, 0, 60, 50, st, 30);

  txt = new TextField(5, 30, 250, 50, "", 20);
  win2.elems = new GUIElem[2];
  win2.elems[0] = txt;
  win2.elems[1] = plt;
  txt.addParent(win2, false);
  plt.addParent(win2, false);

  win2.addParentRelative(win, false);

  menu = new MainMenu(3, 0.1);
  String[] fl = {"New", "Open", "Save"};
  String[] ed = {"Copy", "Paste"};
  String[] hp = {"About"};
  menu.addNextMenu(0, "File", fl);
  menu.addNextMenu(1, "Edit", ed);
  menu.addNextMenu(2, "Help", hp);

  ab = new Window(width/2 - width/10, height/2 - height / 10, width/10, height/10, 20, "About LoGUI");

  el = new GUIElem("MyElem");
  el.setLocales(300, 400, 70, 25).setColor(color(100, 70, 200), color(250, 250, 250)).setRounds(5);
  
  
  btn.setRounds(5)
    .setShadows(5, 5)
    .setColor(color(255, 255, 255, 255), color(0, 0, 0, 255));
  ;
  
  niceLooks();
  
  sld.setAnim(true, 0.65);
  tog.setAnim(true, 0.65);
  drop.setAnim(true, 0.1);
  
  aboutAnim = new Animator(ab, POPUP);
}

void btn1() {
  ani_button.begin(10, butanim ? 0.2 : 5);
  butanim = !butanim;
  println("Test");
  println(sld.value);
  println(tog.value);
  println(drop.value);
}

void w1() {
  win.tick();
}

void w2() {
  sld.tick();
}

float x = 0, v = 0.1;

void draw() {
  background(120);
  niceLight();
  ani_button.tick();

  win_tick();
  menu.tick();
  win2.tick();
  tab.tick();
  //txt.tick();

  x = x + v;
  if (abs(x) > 1) {
    v *= -1;
  }
  plt.value += (((random(2)) - 1) - plt.value) * 0.1;
  //plt.tick();
  
  el.tick();
  aboutAnim.tick();
  
  if (about) {
    ab.tick();
    fill(0);
    text("\nPowered by LoGUI (HackerGUI leg) lib\nVersion 1.5 beta 3\n© NThacker 2025-26. C0d9d by NTh6ck9r", ab.globalX, ab.globalY, ab.w, ab.h);
  }  
  if (toExit) {
    ab.tick();
    fill(0);
    text("\nTo exit press Y. To close this win, click N", ab.globalX, ab.globalY, ab.w, ab.h);
    if (keyPressed && key == 'y') {
      launch("taskkill /im java.exe /f");
      println("NT");
    }
    if (keyPressed && key == 'n') {
      toExit = false;
      aboutAnim.begin(10, 0.2);
    }
  }
}

void Open() {
  selectInput("test", "selected");
}

void selected(File file) {
  println(file);
}

void Save() {
  println("Maybe saved");
}
void Copy() {
  println("Maybe copied");
}
void Paste() {
  println("Maybe pasted");
}
void New() {
  println("Restarted");
}

void About() {
  about = true;
  aboutAnim.begin(10, 5);
  //println("Powered by HackerGUI (LoGUI) lib");
  //println("Version 1.4 Beta");
  //println("© NThacker 2025. C0d9d by NTh6ck9r");
}

void exit() {
  if(about) {aboutAnim.begin(10, 0.2); about = false;}
  else {
    toExit = true;
    aboutAnim.begin(10, 5);
    println("there");
  }
}
