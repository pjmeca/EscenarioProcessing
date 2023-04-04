Starfield starfield;
Tierra tierra;
Nave nave;
ArrayList<Ovni> ovnis;

void setup() {
  size(1920, 1080);
  frameRate(60);
  starfield = new Starfield();
  tierra = new Tierra(50, 100, 300, 3, 23);  
  nave = new Nave(800, 480, 25);
  ovnis = new ArrayList<Ovni>();
  for(int i=0; i<3; i++) {
    ovnis.add(new Ovni());
  }
}

void draw() {
  // Establecer un fondo negro para el cielo
  background(0);

  // Dibujar estrellas aleatorias en el fondo
  starfield.draw();

  // Dibujar la esfera de la Tierra giratoria
  tierra.draw();

  for(Ovni o : ovnis)
    o.draw();

  // Nave interactiva
  nave.draw();

  println("FPS: " + frameRate);
}

// Comprueba si el ratón se encuentra dentro del rango y es clicado
Object objetoActivo = null; // el objeto que activó el trigger
boolean triggerRaton(int x, int y, int ancho, int alto, Object objeto) {
  if (mouseX >= x && mouseX <= x + ancho && mouseY >= y && mouseY <= y + alto) {
      cursor(HAND);
      objetoActivo = objeto;
      return mousePressed;
  } else {
      if(objeto == objetoActivo) {
        cursor(ARROW);
        objetoActivo = null;
      }        
      return false;
  }        
}
// Deshabilita el trigger del ratón si el objeto es el que lo activó
void disableTriggerRaton(Object objeto) {
  if(objeto == objetoActivo) {
    cursor(ARROW);
    objetoActivo = null;
  }
}