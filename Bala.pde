/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene las clases relacionadas con la animación disparada al hacer click en el
    planeta Tierra.
    - Bala: representa a una bala dibujada con Processing, se caracteriza por una posición y un
    tamaño. Llama al objeto Animacion para actualizar su posición y tamaño conforme a una parábola.
    - Animacion: representa a una animación parabólica desde una posicion inicial hasta una posición
    final a una determinada velocidad. Con cada llamada a update(), la animación recupera el punto
    siguiente en la parábola. El punto se obtiene a partir de aumentar el ángulo producido entre la
    posición inciial y el centro en t * PI radianes, donde t es el tiempo de la animación, que va de
    0 (posición inicial) a 1 (posición final).
    ------------------------------------------------------------------------------------------------ 
*/

class Bala {
    
    private PVector posicion;
    private float size, sizeInicial;
    private Animacion a;
    
    Bala(PVector posicion, float size) {
        this.posicion = posicion;
        posicion.z = 1;
        this.size = size;
        this.sizeInicial = size;
    }
    
    void draw() {
        
        if (a == null || a.isTerminada()) 
            return;
        
        if (!a.isTerminada())
            posicion = a.update();
        
        size = sizeInicial * posicion.z;
        
        int r = 100;
        int g = 100;
        int b = 100;
        
        stroke(0);
        
        fill(color(r, g, b));
        
        rect(posicion.x + size * 0.25, posicion.y, size * 1.25, size); // cuerpo
        arc(posicion.x + size * 1.5, posicion.y + size / 2, size * 1.2, size, radians( - 90), radians(90)); // punta
        arc(posicion.x + size * 0.75, posicion.y + size / 2, size * 0.55, size, radians( - 90), radians(90)); // primer arco del cuerpo
        arc(posicion.x + size * 1.3, posicion.y + size / 2, size * 0.6, size, radians( - 90), radians(90)); // segundo arco del cuerpo
        
        noFill();
        bezier(posicion.x + size / 4, posicion.y + size * 0.65, posicion.x + size, posicion.y + size * 0.7, posicion.x + size * 2.1, posicion.y + size * 0.7, posicion.x + size * 2.1, posicion.y + size / 2); // curva atravesando el cuerpo para dar sensación de profundidad
        fill(color(r, g, b));
        
        // Puntos de soldadura
        ellipseMode(CENTER);
        for (int i = 0; i < size * 1.25; i += 10)
            ellipse(posicion.x + size * 0.25 + i + 10, posicion.y + size / 16, 1, 1);
        
        ellipseMode(CORNER);
        ellipse(posicion.x, posicion.y, size / 2, size); // parte trasera
        ellipseMode(CENTER);
        ellipse(posicion.x + size / 4, posicion.y + size / 2, size / 6, size / 3); // centro de la parte trasera
        // Puntos de soldadura del centro de la parte trasera
        dibujarElipseDiscontinua(new PVector(posicion.x + size / 4, posicion.y + size / 2), size / 3, size / 1.8, 20);
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
    
    void nuevaAnimacion(PVector posicionFinal, float velocidad) {
        a = new Animacion(new PVector(posicion.x, posicion.y), new PVector(posicionFinal.x, posicionFinal.y), velocidad);
    }
    
    boolean isAnimacionTerminada() {
        return a.isTerminada();
    }
}

// Esta clase guarda una animación parabólica que se actualiza con cada llamada a update()
class Animacion {
    
    private PVector posInicial, posFinal;
    private float t; // tiempo transcurrido (0 - 1)
    private float velocidad;
    
    Animacion(PVector posicionInicial, PVector posicionFinal, float velocidad) {
        posInicial = posicionInicial;
        posFinal = posicionFinal;
        t = 0;
        this.velocidad = velocidad * 0.01;
    }
    
    // Devuelve la nueva posición después de aplicar la animación
    private PVector update() {
        if (t >=  1)
            return posFinal;
        return getPuntoInParabola(posInicial, posFinal, nextT());
    }
    
    private float nextT() {
        if (t >=  1)
            return 1;
        
        float aux = t;
        t += velocidad;
        return aux;
    }
    
    boolean isTerminada() {
        return t>= 1;
    }
    
    // Función que crea una parábola simétrica entre dos puntos
    // t: valor entre 0 y 1 que indica en qué punto de la parábola se encuentra
    private PVector getPuntoInParabola(PVector p1, PVector p2, float t) {
        
        //Calcular el punto medio entre los dos puntos
        PVector centro = PVector.add(p1, p2).mult(0.5);
        
        float radio = sqrt(pow(p1.x - centro.x, 2) + pow(p1.y - centro.y, 2)); 
        float angulo = atan2(p1.y - centro.y, p1.x - centro.x); 
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
