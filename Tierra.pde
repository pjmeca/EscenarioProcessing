class Tierra {
    
    PImage textura; // Imagen de la textura de la Tierra
    int x, y;
    int height, width;
    int velocidad;
    
    // Como la Tierra rota muy rápido incluso a 1 de velocidad,
    // reduciremos la cantidad de veces que se ejecuta la rotación (equivale a saltar frames)
    private static final int DEFAULT_SPEEDCOUNTER = 2;
    private int speedCounter = DEFAULT_SPEEDCOUNTER;

    private PGraphics tierra;

    Tierra(String texturaURL, int x, int y, int height, int width, int velocidad) {
        textura = loadImage(texturaURL);
        // imageMode(CENTER); // coloca el punto x, y en el centro de la Tierra

        this.x = x;
        this.y = y;
        this.height = height;
        this.width = width;
        this.velocidad = velocidad;
    }

    void draw() {
        if (speedCounter < 0)
            speedCounter = DEFAULT_SPEEDCOUNTER;
        else if(speedCounter-- == DEFAULT_SPEEDCOUNTER) 
            rotacion();

        dibujar();        
    }

    // Realiza un movimiento de rotación sobre la Tierra 
    private void rotacion() {
        // Desplazar el rectángulo de la textura en el eje X
        textura.loadPixels();
        for (int y = 0; y < textura.height; y++) {
            for (int x = textura.width - 1; x > 0; x--) {
                int loc = x + y * textura.width;
                int prevLoc = Math.floorMod(int(x - velocidad), textura.width) + y * textura.width;
                textura.pixels[loc] = textura.pixels[prevLoc];
            }
            int firstLoc = y * textura.width;
            textura.pixels[firstLoc] = textura.pixels[firstLoc + textura.width - 1];
        }
        textura.updatePixels();
    }

    // Dibuja la Tierra
    private void dibujar() {
        // Primero dibujamos un fondo negro para que no se vean las estrellas detrás al difuminar la Tierra
        fill(0);
        ellipse(x+width/2, y+height/2, width, height);

        // Crear un objeto PGraphics para la textura de la Tierra
        tierra = createGraphics(width, height);
        tierra.beginDraw();
        tierra.image(textura, 0, 0, textura.width * height/textura.height, height);
        tierra.endDraw();

        // Dibujar una elipse como máscara para la textura de la Tierra
        PGraphics mascara = createGraphics(width, height);
        mascara.beginDraw();
        mascara.endDraw();

        // Aplicar gradiente de color a la máscara
        float radioOpacidad = 10; // distancia desde el centro de la elipse hasta donde comienza la transparencia
        float exponente = 5; // exponentee para la función exponencial

        for (int y = 0; y < mascara.height; y++) {
            for (int x = 0; x < mascara.width; x++) {
                float d = dist(x, y, mascara.width/2, mascara.height/2)+5; // Distancia al centro de la elipse (+5 para ajustar la elipse dentro del rectángulo)
                float t = pow(max(0, (d - radioOpacidad)) / (mascara.width/2 - radioOpacidad), exponente); // Mappear la distancia utilizando la función exponencial
                color c = lerpColor(color(0, 0, 255), color(0, 255, 0), t); // Gradiente entre azul y verde
                mascara.pixels[x + y * mascara.width] = c; // Asignar el color a cada píxel de la máscara
            }
        }

        mascara.updatePixels();

        // Aplicar la máscara a la textura de la Tierra
        tierra.mask(mascara);

        // Dibujar la textura de la Tierra en la ventana principal
        image(tierra, x, y, width, height);
    }
}