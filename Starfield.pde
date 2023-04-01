class Starfield {

  ArrayList<Estrella> estrellas = new ArrayList<>();

  int numEstrellas = 500;  

  Starfield() {
    // Creamos las estrellas
    for(int i = 0; i < numEstrellas; i++) {
      Estrella e = new Estrella();
      estrellas.add(e);
      e.setPorcentajeVida(random(20, 100)); // cuando se crea por primera vez, el cielo tiene que tener estrellas
    }
  }

  void draw() {
    // Dibujar las numEstrellas estrellas en el fondo
    for(Estrella e : estrellas) {
      // Dibujar la estrella como un círculo blanco
      fill(e.vida());
      noStroke();
      ellipse(e.x, e.y, e.tamaño, e.tamaño);
    }
  }
}

class Estrella {

  float tamaño;
  float x, y;

  private float vidaActual; // porcentaje de vida de la estrella, cuando llegue a 0 morirá
  private float vidaInicial;
  private float vidaPorcentaje;

  Estrella() {
    init();
  }

  private void init() {
    this.tamaño = random(1, 3);
    this.x = random(width);
    this.y = random(height);
    vidaActual = vidaInicial = random(200, 1000);
    vidaPorcentaje = 0.0;
  }

  void setPorcentajeVida(float porcentaje) {
    vidaPorcentaje = porcentaje;
  }

  float vida() {

    // Si acaba de nacer, primero tiene que aparecer en difuminado
    if(vidaActual == vidaInicial && vidaPorcentaje < 100) {
      return vidaPorcentaje++ * 2.55;
    }

    vidaActual--;
    vidaPorcentaje = vidaActual/vidaInicial * 100;

    // Si muere, se recoloca
    if(vidaActual < 0) {
      init();
      return 0;
    }

    return vidaPorcentaje * 2.55;
  }
}
