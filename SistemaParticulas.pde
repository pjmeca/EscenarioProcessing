/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene las clases relacionadas con el sistema de partículas.
    - SistemaParticulas: representa el sistema de partículas, se encarga de crear y actualizar
    todas las partículas.
    - Particula: representa a una partícula del sistema de partículas, se caracteriza por tener
    una posición, velocidad, vida y ángulo, entre otros.
    
    El sistema de partículas es usado en dos ocasiones por el escenario. Por un lado, se utiliza como
    propulsión de la nave cuando el usuario clica sobre ella, en este caso, las partículas se emiten
    con un ángulo opuesto al que mira la nave, con cierta dispersión (llamada a randomGaussian para
    que la dispersión sea realista, siendo más probable obtener valores más cercanos al ángulo real).
    Por otro lado, se utiliza cuando el usuario clica sobre los ovnis para realizar la animación de
    explosión. En este caso, las partículas son emitidas cada una con un ángulo diferente, de manera
    que se produce una dispersión circular respecto al centro de emisión del sistema de partículas.    
    ------------------------------------------------------------------------------------------------ 
*/

class SistemaParticulas {
    
    static final int MAX_PARTICULAS = 500;
    
    private ArrayList<Particula> particulas;
    private float fuerzaEmision, radio;
    private int numParticulas;
    
    SistemaParticulas(float radio, float fuerzaEmision, int numParticulas) {
        this.radio = radio;
        this.fuerzaEmision = fuerzaEmision;
        this.numParticulas = numParticulas;
        particulas = new ArrayList<Particula>();
    }
    
    void addParticula(float x, float y, float angulo) {
        Particula p = new Particula(x, y, radio, fuerzaEmision, angulo);
        particulas.add(p);
    }
    
    void draw(boolean crear, float x, float y, float angulo) {
        // Crear nuevas partículas
        if (crear)
            for (int i = 0; i < min(numParticulas, MAX_PARTICULAS - particulas.size()); i++)
                addParticula(x, y, angulo);
            
        // Actualizamos las partículas existentes  
        actualizarParticulas();
    }
    
    void draw(boolean crear, float x, float y) {
        // Crear nuevas partículas
        if (crear)
            for (int i = 0; i < min(numParticulas, MAX_PARTICULAS - particulas.size()); i++)
                addParticula(x, y, random(radians(360)));
            
        // Actualizamos las partículas existentes  
        actualizarParticulas();
    }
    
    private void actualizarParticulas() {
        
        for (int i = particulas.size() - 1; i >= 0; i--) {
            Particula p = particulas.get(i);
            p.update();
            p.mostrar();
            if (!p.isViva()) {
                particulas.remove(i);
            }
        }
    }
}

class Particula {
    private PVector posicion;
    private PVector velocidad;
    private float vida;
    private float radio;
    private color colorParticula;
    private float fuerzaEmision;
    private float maxDist;
    private float angulo;
    
    Particula(float x, float y, float radio, float fuerzaEmision, float angulo) {
        posicion = new PVector(x, y);
        this.radio = radio;
        this.fuerzaEmision = fuerzaEmision;
        this.angulo = angulo;
        
        velocidad = PVector.fromAngle(angulo);
        velocidad.mult(random(fuerzaEmision));
        this.vida = random(100, 255);
        colorParticula = color(255, 165, 0, vida);
    }
    
    void update() {
        posicion.add(velocidad);
        velocidad.y += randomGaussian(); // le damos un poco de dispersión
        vida -= fuerzaEmision * 1.3;
        colorParticula = color(255, 165, 0, vida);
    }
    
    void mostrar() {
        fill(colorParticula);
        noStroke();
        ellipse(posicion.x, posicion.y, radio, radio);
    }
    
    boolean isViva() {
        return vida > 0.0;
    }
}
