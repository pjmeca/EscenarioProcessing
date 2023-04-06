class Bala {

    PVector posicion;
    float size, sizeInicial;
    Animacion a;

    Bala(PVector posicion, float size) {
        this.posicion = posicion;
        posicion.z = 1;
        this.size = size;
        this.sizeInicial = size;
    }

    void draw() {

        if(a == null || a.isTerminada()) 
            return;

        if(!a.isTerminada())
            posicion = a.update();

        size = sizeInicial * posicion.z;

        int r = 100;
        int g = 100;
        int b = 100;

        stroke(0);
        
        fill(color(r, g, b));

        rect(posicion.x+size*0.25, posicion.y, size*1.25, size); // cuerpo
        arc(posicion.x+size*1.5, posicion.y+size/2, size*1.2, size, radians(-90), radians(90)); // punta
        arc(posicion.x+size*0.75, posicion.y+size/2, size*0.55, size, radians(-90), radians(90)); // primer arco del cuerpo
        arc(posicion.x+size*1.3, posicion.y+size/2, size*0.6, size, radians(-90), radians(90)); // segundo arco del cuerpo

        noFill();
        bezier(posicion.x+size/4, posicion.y+size*0.65, posicion.x+size, posicion.y+size*0.7, posicion.x+size*2.1, posicion.y+size*0.7, posicion.x+size*2.1, posicion.y+size/2); // curva atravesando el cuerpo para dar sensación de profundidad
        fill(color(r, g, b));

        // Puntos de soldadura
        ellipseMode(CENTER);
        for(int i=0; i<size*1.25; i += 10)
            ellipse(posicion.x+size*0.25 + i+10, posicion.y+size/16, 1, 1);

        ellipseMode(CORNER);
        ellipse(posicion.x, posicion.y, size/2, size); // parte trasera
        ellipseMode(CENTER);
        ellipse(posicion.x+size/4, posicion.y+size/2, size/6, size/3); // centro de la parte trasera
        // Puntos de soldadura del centro de la parte trasera
        dibujarElipseDiscontinua(new PVector(posicion.x+size/4, posicion.y+size/2), size/3, size/1.8, 20);
    }

    private void dibujarElipseDiscontinua(PVector posicion, float w, float h, int numPuntos) {
        pushMatrix();
        translate(posicion.x, posicion.y);
        float angleStep = TWO_PI / numPuntos; // Divide la elipse en numPuntos puntos
        for (float angle = 0; angle < TWO_PI; angle += angleStep) {
            float px = cos(angle) * w / 2;
            float py = sin(angle) * h / 2;
            point(px, py);
        }
        popMatrix();
    }

    public void nuevaAnimacion(PVector posicionFinal, float velocidad) {
        a = new Animacion(new PVector(posicion.x, posicion.y), new PVector(posicionFinal.x, posicionFinal.y), velocidad);
    }

    public boolean isAnimacionTerminada() {
        return a.isTerminada();
    }
}

// Esta clase guarda una animación parabólica que se actualiza con cada llamada a update()
class Animacion {

    PVector posInicial, posFinal;
    float t; // tiempo transcurrido
    float velocidad;

    public Animacion(PVector posicionInicial, PVector posicionFinal, float velocidad) {
        posInicial = posicionInicial;
        posFinal = posicionFinal;
        t = 0;
        this.velocidad = velocidad*0.01;
    }

    // Devuelve la nueva posición después de aplicar la animación
    private PVector update() {
        if(t>=1)
            return posFinal;
        return getPuntoInParabola(posInicial, posFinal, nextT());
    }

    private float nextT() {
        if(t>=1)
            return 1;

        float aux = t;
        t += velocidad;
        return aux;
    }

    public boolean isTerminada() {
        return t>=1;
    }

    // Función que crea una parábola simétrica entre dos puntos
    // t: valor entre 0 y 1 que indica en qué punto de la parábola se encuentra
    // p1: punto inicial de la parábola
    // p2: punto final de la parábola
    private PVector getPuntoInParabola(PVector p1, PVector p2, float t) {

        //Calcular el punto medio entre los dos puntos
        PVector centro = PVector.add(p1, p2).mult(0.5);

        float radio = sqrt(pow(p1.x-centro.x, 2) + pow(p1.y-centro.y, 2)); 
        float angulo = atan2(p1.y-centro.y, p1.x-centro.x); 
        // Obtener el angulo del siguiente punto
        float siguiente_angulo = angulo + t * PI;

        // Valor del siguiente punto
        float siguiente_x = centro.x + radio * cos(siguiente_angulo); 
        float siguiente_y = centro.y + radio * sin(siguiente_angulo); 

        // Devolvemos la nueva posición,
        // aprovechamos la z para devolver la proporción de tamaño
        return new PVector(siguiente_x, siguiente_y, t <= 0.5 ? map(t, 0, 0.5, 0, 1) : map(t, 0.5, 1, 1, 0)); 
    }
}
