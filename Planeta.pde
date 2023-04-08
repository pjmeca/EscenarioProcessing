abstract class Planeta {
    
    protected PImage textura; // Imagen de la textura del planeta
    protected PVector posicion;
    protected int diametro;
    protected int velocidad;
    protected int anguloRotacion = 0;
    
    // Si va muy rápido, puede reducirse la cantidad de veces que se ejecuta la rotación (equivale a saltar frames)
    private static final int DEFAULT_SPEEDCOUNTER = 1;
    private int speedCounter = DEFAULT_SPEEDCOUNTER;
    
    private PGraphics planeta;
    
    Planeta(String texturaURL, PVector posicion, int diametro, int velocidad, int angulo) {
        textura = loadImage(texturaURL);
        
        this.posicion = posicion;
        this.diametro = diametro;
        this.velocidad = velocidad;
        this.anguloRotacion = angulo;
    }
    
    void draw() {
        // Esperar los frames indicados
        if (speedCounter < 0)
            speedCounter = DEFAULT_SPEEDCOUNTER;
        else if (speedCounter-- == DEFAULT_SPEEDCOUNTER) 
            rotacion();
        
        dibujar();        
    }
    
    // Realiza un movimiento de rotación sobre el planeta 
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
    
    // Dibuja el planeta
    private void dibujar() {
        pushMatrix();
        
        // Aplicamos la rotación
        translate(posicion.x + diametro / 2, posicion.y + diametro / 2);
        rotate(radians(anguloRotacion));
        translate( - (posicion.x + diametro / 2), -(posicion.y + diametro / 2));
        
        // Primero dibujamos un fondo negro para que no se vean las estrellas detrás al difuminar el planeta
        fill(0);
        ellipse(posicion.x + diametro / 2, posicion.y + diametro / 2, diametro, diametro);
        
        // Crear un objeto PGraphics para la textura del planeta
        planeta = createGraphics(diametro, diametro);
        planeta.beginDraw();
        planeta.image(textura, 0, 0, textura.width * diametro / textura.height, diametro);
        planeta.endDraw();
        
        // Dibujar una elipse como máscara para la textura del planeta
        PGraphics mascara = createGraphics(diametro, diametro);
        mascara.beginDraw();
        mascara.endDraw();
        
        // Aplicar gradiente de color a la máscara
        float radioOpacidad = 10; // distancia desde el centro de la elipse hasta donde comienza la transparencia
        float exponente = 5; // exponente para la función exponencial
        
        for (int y = 0; y < mascara.height; y++) {
            for (int x = 0; x < mascara.width; x++) {
                float d = dist(x, y, mascara.width / 2, mascara.height / 2); // Distancia al centro de la elipse
                float t = pow(max(0,(d - radioOpacidad)) / (mascara.width / 2 - radioOpacidad), exponente); // Mappear la distancia utilizando la función exponencial
                color c = lerpColor(color(0, 0, 255), color(0, 255, 0), t); // Gradiente entre azul y verde
                mascara.pixels[x + y * mascara.width] = c; // Asignar el color a cada píxel de la máscara
            }
        }
        
        mascara.updatePixels();
        
        // Aplicar la distorsión para simular 3D
        PImage tmp = distorsionar(planeta);
        
        // Aplicar la máscara a la textura de la planeta
        tmp.mask(mascara);
        
        // Dibujar la textura del planeta en la ventana principal
        image(tmp, posicion.x, posicion.y, diametro, diametro);
        
        popMatrix();
    }
    
    private PImage distorsionar(PGraphics img) {
        
        int cx = diametro / 2; // Coordenada x del centro de la zona de distorsión
        int cy = diametro / 2; // Coordenada y del centro de la zona de distorsión
        int radio = (diametro * 11) / 20; // Radio de la zona de distorsión (cogemos 11/20 partes para que el radio sobresalga un poco de la máscara)
        float distorsion = 0.65; // Factor de distorsión de ojo de pez (<1 aumenta y >1 reduce)
        
        // Crear una imagen temporal para almacenar la imagen distorsionada
        PImage temp = createImage(diametro, diametro, RGB);
        
        // Iterar por cada píxel de la imagen
        for (int x = 0; x < diametro; x++) {
            for (int y = 0; y < diametro; y++) {
                // Calcular la distancia del píxel al centro de la zona de distorsión
                float dx = x - cx;
                float dy = y - cy;
                float dist = sqrt(dx * dx + dy * dy);
                
                // Si el píxel está dentro de la zona de distorsión
                if (dist <= radio) {
                    // Aplicar la transformación de mapeo radial
                    float amount = map(dist, 0, radio, distorsion, 1);
                    float nx = cx + dx * amount;
                    float ny = cy + dy * amount;
                    
                    // Copiar el píxel distorsionado a la imagen temporal
                    int c = img.get((int)nx,(int)ny);
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

class Tierra extends Planeta {
    
    static final String texturaURL = "resources/tierra.png";
    
    private Luna luna;
    private Bala bala;
    
    private PVector posLuna;
    
    Tierra(PVector posicion, int diametro, int velocidad, int angulo) {
        super(texturaURL, posicion, diametro, velocidad, angulo);
        
        posLuna = new PVector(posicion.x + 444, posicion.y + 100);
        
        luna = new Luna(posLuna, int(diametro * 0.27), 1, angulo);     
    }
    
    @Override
    void draw() {
        super.draw();
        
        // Si se hace click, comienza la animación
        if (!luna.isColision() && bala == null && triggerRaton(posicion, diametro, diametro, this)) {
            bala = new Bala(new PVector(posicion.x + 130, posicion.y + 80), 50); // la suma es para que aparezca por el centro de la Tierra
            bala.nuevaAnimacion(new PVector(posLuna.x + 20, posLuna.y + 30), 0.8);
            disableTriggerRaton(this);
        }
        
        // Cuando termine, avisa a la luna
        if (bala != null && bala.isAnimacionTerminada()) {
            luna.colision();
            bala = null;
        }
        
        luna.draw();
        if (bala != null)
            bala.draw();        
    }
}

class Luna extends Planeta {
    
    static final String texturaURL = "resources/luna/luna.jpg";
    static final String texturaMeliesURL = "resources/luna/luna_melies.png";
    private boolean texturaCambiada = false;
    
    Luna(PVector posicion, int diametro, int velocidad, int angulo) {
        super(texturaURL, posicion, diametro, velocidad, angulo);
    }
    
    @Override
    void draw() {        
        if (!texturaCambiada)
            super.draw();        
        else
            super.dibujar(); // se salta la rotación
    }
    
    // Cambia la textura tras una colisión
    void colision() {
        textura = loadImage(texturaMeliesURL);
        texturaCambiada = true;
    }
    
    boolean isColision() {
        return texturaCambiada;
    }
}

class Marte extends Planeta {
    
    static final String texturaURL = "resources/marte.jpg";
    
    Marte(PVector posicion, int diametro, int velocidad, int angulo) {
        super(texturaURL, posicion, diametro, velocidad, angulo);
    }
}

class Sol extends Planeta {
    static final String texturaURL = "resources/sol.jpg";
    
    protected PImage desenfoque;
    protected int tamDesenfoque = 150;
    
    private float escala = 1, objetivoEscalado = 1;
    
    Sol(PVector posicion, int diametro, int velocidad) {
        super(texturaURL, posicion, diametro, velocidad, 0);
        
        PGraphics pg = createGraphics((int)(tamDesenfoque * 2),(int)(tamDesenfoque * 2));
        pg.beginDraw();
        pg.fill(color(200, 150, 0), 130);
        pg.ellipse(diametro / 2 + tamDesenfoque, diametro / 2 + tamDesenfoque, tamDesenfoque, tamDesenfoque);
        pg.filter(BLUR,20);
        pg.endDraw();
        desenfoque = pg.get();
    }
    
    @Override
    void draw() {
        super.draw();
        
        // Si se clica, el brillo del sol aumenta
        if (triggerRaton(posicion, diametro, diametro, this)) {
            objetivoEscalado = 1.5;
            disableTriggerRaton(this);
        }
        
        if (escala < objetivoEscalado && objetivoEscalado == 1)
            escala = 1; // debido a imprecisiones de los float, es necesaria esta condición
        if (escala < objetivoEscalado)
            escala += 0.08;
        else if (escala > objetivoEscalado) {
            escala -= 0.1;
            objetivoEscalado = 1.0;
        }
        
        pushMatrix();
        scale(escala);
        image(desenfoque, posicion.x / escala - tamDesenfoque - (escala - 1) * diametro / 4, posicion.y / escala - tamDesenfoque - (escala - 1) * diametro / 4);
        popMatrix();
    }
}