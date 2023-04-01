class Tierra {
    
    PImage textura; // Imagen de la textura de la Tierra
    int x, y;
    int height, width;
    int velocidad;
    
    // Como la Tierra rota muy rápido incluso a 1 de velocidad,
    // reduciremos la cantidad de veces que se ejecuta la rotación (equivale a saltar frames)
    private static final int DEFAULT_SPEEDCOUNTER = 2;
    private int speedCounter = DEFAULT_SPEEDCOUNTER;

    private PGraphics earthGraphic;

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
        // Crear un objeto PGraphics para la textura de la Tierra
        earthGraphic = createGraphics(width, height);
        earthGraphic.beginDraw();
        earthGraphic.image(textura, 0, 0, textura.width * height/textura.height, height);
        earthGraphic.endDraw();

        // Dibujar una elipse como máscara para la textura de la Tierra
        PGraphics mask = createGraphics(width, height);
        mask.beginDraw();
        mask.noStroke();
        mask.fill(255);
        mask.ellipse(width/2, height/2, width, height);
        mask.endDraw();

        // Aplicar la máscara a la textura de la Tierra
        earthGraphic.mask(mask);

        // Dibujar la textura de la Tierra en la ventana principal
        image(earthGraphic, x, y, width, height);
    }
}