/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene las clases relacionadas con los asteroides:
    - Asteroides: representa al conjunto de asteroides dibujados en pantalla, su función es la de
    recorrer todos los asteroides y actualizar sus posiciones siguiendo un movimiento sinusoidal.
    - Asteroide: representa a un asteroide, se caracteriza por una posición, velocidad de
    desplazamiento, tamaño y un ángulo de rotación que aumenta conforme se desplaza para simular una
    rotación.
    - Crater: esta clase representa a un cráter en el asteroide. Los cráteres se dibujan usando
    elipses de processing en posiciones aleatorias del asteroide.
    ------------------------------------------------------------------------------------------------ 
*/

class Asteroides {
    
    private int numAsteroides;
    private ArrayList<Asteroide> asteroides;
    
    Asteroides(int numAsteroides, int tam) {
        this.numAsteroides = numAsteroides;
        asteroides = new ArrayList<Asteroide>();
        for (int i = 0; i < numAsteroides; i++)
            asteroides.add(new Asteroide(new PVector(width + random(0, width), random(height)), random(1.5, 5), random(360), random(tam / 2, tam)));
    }
    
    void draw() {
        for (Asteroide a : asteroides) {
            a.draw();
            a.update();
        }
    }
}

class Asteroide {
    private PVector posicion;
    private float velocidad;
    private float anguloActual;
    private float size;
    private ArrayList<Crater> crateres;
    
    Asteroide(PVector posicion, float velocidad, float angulo, float size) {
        this.posicion = posicion;
        this.velocidad = velocidad;
        anguloActual = angulo;
        this.size = size;
        init();
    }
    
    void init() {
        crateres = new ArrayList<Crater>();
        
        // "Cráteres"
        float numCrateres = random(10, 20);
        for (int i = 0; i < numCrateres; i++) {
            crateres.add(new Crater(size));
        }
    }
    
    void draw() {
        pushMatrix();
        translate(posicion.x, posicion.y);
        rotate(radians(anguloActual));
        fill(100);
        ellipse(0, 0, size, size);
        for (Crater crater : crateres) {
            crater.draw();
        }
        popMatrix();
    }
    
    void update() {
        checkMuerto();
        posicion.x -= velocidad;
        posicion.y += sin(radians(anguloActual)) * velocidad;
        anguloActual -= velocidad;
    }
    
    private void checkMuerto() {
        if (posicion.x < - size) {
            posicion.x = width + size;
            init();
        }
    }
}

class Crater {
    
    private PVector posicionRel;
    private float r, sombra;
    
    Crater(float size) {
        
        float cx = random( - size / 2, size / 2);
        float cy = random( - size / 2, size / 2);
        float r = random(size / 10, size / 3);
        float sombra = random(50, 150);
        
        this.posicionRel = new PVector(cx, cy);
        this.r = r;
        this.sombra = sombra;
    }
    
    void draw() {
        noStroke();
        fill(sombra);
        ellipse(posicionRel.x, posicionRel.y, r, r);
    }
}
