Starfield starfield;
Tierra tierra;
Nave nave;

void setup() {
  size(1920, 1080);
  frameRate(60);
  starfield = new Starfield();
  tierra = new Tierra(50, 100, 300, 3, 23);  
  nave = new Nave(20, 20, 25);
}

void draw() {
  // Establecer un fondo negro para el cielo
  background(0);

  // Dibujar estrellas aleatorias en el fondo
  starfield.draw();

  // Dibujar la esfera de la Tierra giratoria
  tierra.draw();

  // Nave interactiva
  nave.draw();

  println("FPS: " + frameRate);
}