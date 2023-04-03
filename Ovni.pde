class Ovni {
  PImage sprite;
  float xoff;
  float yoff;
  float velocidad;

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
  }

  void draw() {
    // Calcula la posición del OVNI basándose en la función de ruido Perlin 2D
    float x = noise(xoff, yoff) * width;
    float y = noise(xoff + 100, yoff + 100) * height;
  
    // Dibuja el OVNI
    image(sprite, x, y, 100, 100); // Dibuja el sprite en la posición calculada
  
    // Ajusta los valores de xoff y yoff para animar el OVNI
    xoff += velocidad * 0.01;
    yoff += velocidad * 0.01;
  }
}
