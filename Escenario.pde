Starfield starfield;
Tierra tierra;
Marte marte;
Sol sol;
Nave nave;
ArrayList<Ovni> ovnis;
Asteroides asteroidesBack, asteroidesMid, asteroidesFront;

void setup() {
  size(1920, 1080);
  frameRate(60);
  starfield = new Starfield();
  tierra = new Tierra(new PVector(50, 100), 300, 3, 23);  
  marte = new Marte(new PVector(1200, 800), 150, 2, 25);
  sol = new Sol(new PVector(1500, 200), 100, 1);
  nave = new Nave(new PVector(800, 480), 25);
  ovnis = new ArrayList<Ovni>();
  for(int i=0; i<3; i++) {
    ovnis.add(new Ovni());
  }
  asteroidesBack = new Asteroides(20, 20);
  asteroidesMid = new Asteroides(8, 80);
  asteroidesFront = new Asteroides(2, 100);
}

void draw() {
  // Establecer un fondo negro para el cielo
  background(0);

  // Dibujar estrellas aleatorias en el fondo
  starfield.draw();

  sol.draw();

  asteroidesBack.draw();

  // Dibujar los planetas
  tierra.draw();
  marte.draw();

  asteroidesMid.draw();  

  for(Ovni o : ovnis)
    o.draw();

  // Nave interactiva
  nave.draw();

  asteroidesFront.draw();  

  FPS();
}

boolean primeraVez = true;
void FPS() {
  if(primeraVez) {
    primeraVez = false;
  } else {
    print("                     \033[F\r");
  }
  println("FPS: " + frameRate);
}