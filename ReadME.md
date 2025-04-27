Библиотека Processing для пользовательского интерфейса <b>LoGUI</b>

<ol>
	<li>Предыстория</li>
	<li>
		Референс
		<ol>
			<li><a href="#b">Button</a></li>
			<li><a href="#s">Slider</a></li>
			<li><a href="#t">Toggle</a></li>
			<li><a href="#d">Dropdown</a></li>
			<li><a href="#w">Window</a></li>
			<li><a href="#tb">Tab</a></li>
		</ol>
	</li>
</ol>

<h2>Предыстория</h2>
<p>Библиотека (скорее модуль) появилась абсолютно случайно. Изначально мы делали проект CrispClip c библиотекой интерфейса ControlP5. Мне эта библиотека нравилась - приятные сине-фиолетовые тона, но GiMaker пожаловался мне на низкую кастомизацию ControlP5 и отсутствие нормальных библиотек для интерфейса на Processing. Я сделал с нуля кнопку, и GiMaker'у понравилась возможность помещения картинок в неё. Так или иначе появилась библиотека. В 2-3 строчки кода она позвоялет написать GUI для приложения на Processing и связать его с Arduino Nano, например.</p>

<h2>Референс</h2>

<h3 id="b">Button</h3>
<p>Button - простая кнопка, по нажатию на которую срабатывает событие в функции-обработчике</p>
Простейший код
<pre>
Button btn; //кнопка
PImage img; //спрайт
void setup(){
	size(1000, 500);
	img = loadImage("test.png");
	btn = new Button(img, 0, 0, 50, 25, "btn"); //кнопка x, y, w, h
}

void btn(){
	println("Clicked!")
}

void draw(){
	background(120);
	btn.tick(); //опрашиваем кнопку (не должно быть delay)
}
</pre>

Кнопка имеет автоматическую защиту от дребезга. По нажатию в консоли будет сообщение "Clicked!".
Можно добавить другие кнопки, и для них свои обработчики события.

<h3 id="s">Slider</h3>
<p>Slider - слайдер, при перемещении ползунка меняется значение. Можно управлять, например, углом сервомашинки</p>
Простейший код
<pre>
Slider sld;
int tmr = 0;

void setup(){
	size(1000, 500);
	sld = new Slider(loadImage("sld1.png"), loadImage("sld2.png"), 50, 160, 450, 50, 0, 10); //sld1 - фон, sld2 - ползунок. x, y, w, h, minV, maxV
}

void draw(){
	background(120);
	sld.tick(); //опрашиваем слайдер (не должно быть delay)
	if(millis() - tmr <= 10){ //таймер на millis (dt = 10 ms)
		println(sld.value); //получаем значение
		tmr = millis();
	}
}
</pre>

Значение полученное через sld.value будет между minV и maxV.
Таймер на millis нужен, чтобы не заполнять слишком сильно консоль (можно и без него).

<h3 id="t">Toggle</h3>
<p>Toggle - флажок. Имеет значение true и false. Им можно открывать/закрывать транзистор/реле</p>
Простейший код
<pre>
Toggle tog;

void setup(){
	tog = new Toggle(loadImage("tog1.png"), loadImage("tog2.png"), 50, 220, 100, 30); //tog1 - фон, tog2 - ползунок, x, y, w, h 
}

void draw(){
	background(120);
	tog.tick();
	println(tog.value);
}
</pre>

Значение tog.value false если флажок опущен и true если поднят.

<h3 id="d">Dropdown</h3>
<p>Dropdown - выпадное меню. По нажатию открываются элементы, среди которых можно выбрать нужный параметр</p>
Простейший код
<pre>

Dropdown drop;
int tmr = 0;

void setup(){
	String[] str = {"Item1", "Item2", "Item3"}; //элементы
	drop = new Dropdown(str, 50, 270, 100, 20, 20); // elems, x, y, w, h, d - размер элементов
}

void draw(){
	background(120);
	drop.tick();
	if(millis() - tmr <= 10){
		switch(drop.value){
			case 0:
				println("lol");
				break;
			case 1:
				println("kek");
				break;
			case 2:
				println("4eburek");
				break;
		}
		tmr = millis;
	}
}
</pre>
Получив значение drop.value, мы засовываем его в switch. Причём drop.value - индекс на слово в массиве str.

<h3 id="w">Window</h3>
Вот теперь мы переходим к комплексным элементам интерфейса. Окна - их можно двигать, в них группируются схожие элементы интерфейса. Пример кода:
<pre>
Button btn;
Slider sld;
Toggle tog;
Dropdown drop;
Window win;

void setup() {
	size(1000, 500);
	frameRate(60);
	btn = new Button(loadImage("test.png"), 50, 130, 50, 20, "btn1");
	sld = new Slider(loadImage("sld1.png"), loadImage("sld2.png"), 50, 160, 450, 50, 0, 10);
	tog = new Toggle(loadImage("sld1.png"), loadImage("sld2.png"), 50, 220, 100, 30);
	String[] str = {"Item1", "Item2", "Item3"};
	drop = new Dropdown(str, 50, 270, 100, 20, 20);
	win = new Window("Test.exe", 50, 100, 500, 200, 20); //x, y, w, h, d - размер верхней панели

	//добавим кнопки как часть окна
	win.btns = new Button[1];
	win.slds = new Slider[1];
	win.togs = new Toggle[1];
	win.drops = new Dropdown[1];

	win.btns[0] = btn;
	win.slds[0] = sld;
	win.togs[0] = tog;
	win.drops[0] = drop;
}

void btn1() {
	println("Test");
}

void draw() {
	background(120);
	win.tick();
}
</pre>
Дальше можно двигать окно, и все элементы тоже будут двигаться.

<h3 id="tb">Tab</h3>
Tab - вкладки. Они удобны, когда у нас нет места для окна, а сгруппировать элементы надо.
Добавим вкладки к примеру с окном
<pre>
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
	tab = new Tab(st, 500, 0, 100, 50, 30); //x, y, w, h, d
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
</pre>
Теперь при нажатии на w2, будет показываться только слайдер.