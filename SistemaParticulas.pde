class SistemaParticulas {

    public static final int MAX_PARTICULAS = 500;

    ArrayList<Particula> particulas;
    float fuerzaEmision, radio;
    int numParticulas;

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
        if(crear)
            for(int i=0; i<min(numParticulas, MAX_PARTICULAS-particulas.size()); i++)
                addParticula(x, y, angulo);

        // Actualizamos las partículas existentes       
        for (int i = particulas.size()-1; i >= 0; i--) {
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
    PVector posicion;
    PVector velocidad;
    float vida;
    float radio;
    color colorParticula;
    float fuerzaEmision;
    float maxDist;
    float angulo;

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
        vida -= fuerzaEmision*1.3;
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
