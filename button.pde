Button btn;
Slider sld;
Toggle tog;
Dropdown drop;
Window win;
Tab tab;

void setup() {
  size(1000, 500);
  frameRate(60);
  btn = new Button(loadImage("test.png"), 50, 130, 50, 20, "btn1");
  sld = new Slider(loadImage("sld1.png"), loadImage("sld2.png"), 50, 160, 450, 50, 0, 10);
  tog = new Toggle(loadImage("sld1.png"), loadImage("sld2.png"), 50, 220, 100, 30);
  String[] str = {"Item1", "Item2", "Item3"};
  drop = new Dropdown(str, 50, 270, 100, 20, 20);
  win = new Window("Test.exe", 50, 100, 500, 200, 20);

  win.btns = new Button[1];
  win.slds = new Slider[1];
  win.togs = new Toggle[1];
  win.drops = new Dropdown[1];

  win.btns[0] = btn;
  win.slds[0] = sld;
  win.togs[0] = tog;
  win.drops[0] = drop;
  String[] st = {"w1", "w2"};
  tab = new Tab(st, 500, 0, 100, 50, 30);
}

void btn1() {
  println("Test");
}

void w1() {
  win.tick();
}

void w2() {
  sld.tick();
}

void draw() {
  background(120);
  tab.tick();
}
