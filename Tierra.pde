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

        // Aplicar la distorsión para simular 3D
        PImage tmp = distorsionar(tierra);

        // Aplicar la máscara a la textura de la Tierra
        tmp.mask(mascara);

        // Dibujar la textura de la Tierra en la ventana principal
        image(tmp, x, y, width, height);
    }

    private PImage distorsionar(PGraphics img) {

        int cx = x+width/2; // Coordenada x del centro de la zona de distorsión
        int cy = y+height/2; // Coordenada y del centro de la zona de distorsión
        int radio = max(height, width)/20 * 11; // Radio de la zona de distorsión (cogemos 11/20 partes para que el radio sobresalga un poco de la máscara)
        float distorsion = 0.65; // Factor de distorsión de ojo de pez (<1 aumenta y >1 reduce)

        // Crear una imagen temporal para almacenar la imagen distorsionada
        PImage temp = createImage(width, height, RGB);

        // Iterar por cada píxel de la imagen
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                // Calcular la distancia del píxel al centro de la zona de distorsión
                float dx = x - cx;
                float dy = y - cy;
                float dist = sqrt(dx*dx + dy*dy);
                
                // Si el píxel está dentro de la zona de distorsión
                if (dist <= radio) {
                    // Aplicar la transformación de mapeo radial
                    float amount = map(dist, 0, radio, distorsion, 1);
                    float nx = cx + dx * amount;
                    float ny = cy + dy * amount;
                    
                    // Copiar el píxel distorsionado a la imagen temporal
                    int c = img.get((int)nx, (int)ny);
                    temp.set(x, y, c);
                } else {
                    // Copiar el píxel sin distorsión a la imagen temporal
                    int c = img.get(x, y);
                    temp.set(x, y, c);
                }
            }
        }

        return temp;
    }
}