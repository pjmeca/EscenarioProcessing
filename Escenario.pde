Starfield starfield;

void setup() {
  size(1920, 1080);
  starfield = new Starfield();
}

void draw() {
  // Establecer un fondo negro para el cielo
  background(0);

  // Dibujar estrellas aleatorias en el fondo
  starfield.drawStars();
}
