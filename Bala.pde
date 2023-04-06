class Bala {

    float x, y, size, sizeInicial;
    Animacion a;

    Bala(float x, float y, float size) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.sizeInicial = size;
    }

    void draw() {

        if(a == null || a.isTerminada()) 
            return;

        PVector v = new PVector(x, y, 1);
        if(!a.isTerminada())
            v = a.update();

        x = v.x;
        y = v.y;
        size = sizeInicial * v.z;

        int r = 100;
        int g = 100;
        int b = 100;

        stroke(0);
        
        fill(color(r, g, b));

        rect(x+size*0.25, y, size*1.25, size); // cuerpo
        arc(x+size*1.5, y+size/2, size*1.2, size, radians(-90), radians(90)); // punta
        arc(x+size*0.75, y+size/2, size*0.55, size, radians(-90), radians(90)); // primer arco del cuerpo
        arc(x+size*1.3, y+size/2, size*0.6, size, radians(-90), radians(90)); // segundo arco del cuerpo

        noFill();
        bezier(x+size/4, y+size*0.65, x+size, y+size*0.7, x+size*2.1, y+size*0.7, x+size*2.1, y+size/2); // curva atravesando el cuerpo para dar sensación de profundidad
        fill(color(r, g, b));

        // Puntos de soldadura
        ellipseMode(CENTER);
        for(int i=0; i<size*1.25; i += 10)
            ellipse(x+size*0.25 + i+10, y+size/16, 1, 1);

        ellipseMode(CORNER);
        ellipse(x, y, size/2, size); // parte trasera
        ellipseMode(CENTER);
        ellipse(x+size/4, y+size/2, size/6, size/3); // centro de la parte trasera
        // Puntos de soldadura del centro de la parte trasera
        dibujarElipseDiscontinua(x+size/4, y+size/2, size/3, size/1.8, 20);
    }

    private void dibujarElipseDiscontinua(float x, float y, float w, float h, int numPuntos) {
        pushMatrix();
        translate(x, y);
        float angleStep = TWO_PI / numPuntos; // Divide la elipse en numPuntos puntos
        for (float angle = 0; angle < TWO_PI; angle += angleStep) {
            float px = cos(angle) * w / 2;
            float py = sin(angle) * h / 2;
            point(px, py);
        }
        popMatrix();
    }

    public void nuevaAnimacion(int xf, int yf, float velocidad) {
        a = new Animacion(x, y, xf, yf, velocidad);
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

    public Animacion(float x0, float y0, float xf, float yf, float velocidad) {
        posInicial = new PVector(x0, y0);
        posFinal = new PVector(xf, yf);
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
