Starfield starfield;
Tierra tierra;
Luna luna;


void setup() {
  size(1920, 1080);
  frameRate(60);
  starfield = new Starfield();
  tierra = new Tierra(20, 20, 300, 1);  
  luna = new Luna(500, 20, 300, 1);  
}

void draw() {
  // Establecer un fondo negro para el cielo
  background(0);

  // Dibujar estrellas aleatorias en el fondo
  starfield.draw();

  // Dibujar la esfera de la Tierra giratoria
  tierra.draw();
  luna.draw();
}