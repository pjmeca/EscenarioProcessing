class Ovni {

  public static final int SIZE = 100;

  PImage sprite;
  float xoff;
  float yoff;
  float velocidad;
  boolean vivo;
  SistemaParticulas particulas; // para la explosión
  
  String[] imagenes = {
    "resources/ovni/1.png",
    "resources/ovni/2.png",
    "resources/ovni/3.png",
    "resources/ovni/4.png"
  };

  Ovni() {
    sprite = loadImage(imagenes[int(random(imagenes.length))]); // Carga la imagen del sprite
    xoff = random(width);
    yoff = random(height);
    velocidad = random(0.1, 1);
    vivo = true;

    particulas = new SistemaParticulas(8, 20, 500);
  }

  void draw() {
    
    // Calcula la posición del OVNI basándose en la función de ruido Perlin 2D
    float x = noise(xoff, yoff) * width;
    float y = noise(xoff + SIZE, yoff + SIZE) * height;

    disableTriggerRaton(this); // Como se mueve, tiene que desactivarlo para que no se quede la colisión en el vacío
    boolean haMuerto = vivo && triggerRaton(int(x), int(y), SIZE, SIZE, this);
    vivo = vivo && !haMuerto;
    particulas.draw(haMuerto, x+SIZE/2, y+SIZE/2);

    if(vivo) {
      // Dibuja el OVNI
      image(sprite, x, y, SIZE, SIZE); // Dibuja el sprite en la posición calculada
    
      // Ajusta los valores de xoff y yoff para animar el OVNI
      xoff += velocidad * 0.01;
      yoff += velocidad * 0.01;
    }
  }
}
