/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene las clases relacionadas con las estrellas del espacio:
    - Estrellas: es la clase principal que controla a las otras dos.
    - Estrella: representa una estrella normal del fondo, tiene una vida que va disminuyendo con
    cada frame hasta morir y reaparecer en otro punto de la pantalla.
    - EstrellaFugaz: esta estrella aparece cuando el usuario pulsa la barra espaciadora y se dibuja
    en el fondo dejando una estela tras de sí.
    ------------------------------------------------------------------------------------------------ 
*/

class Estrellas {
    
    private ArrayList<Estrella> estrellas = new ArrayList<>(); // estrellas normales del fondo
    private ArrayList<EstrellaFugaz> estrellasFugaces = new ArrayList<>(); // estrellas con estelas
    
    static final int NUM_ESTRELLAS = 500;  
    
    Estrellas() {
        // Creamos las estrellas
        for (int i = 0; i < NUM_ESTRELLAS; i++) {
            Estrella e = new Estrella();
            estrellas.add(e);
            e.setPorcentajeVida(random(20, 100)); // cuando se crea por primera vez, el cielo tiene que tener estrellas
        }
    }
    
    void draw() {
        // Dibujar las numEstrellas estrellas en el fondo
        for (Estrella e : estrellas) {
            // Dibujar la estrella como un círculo blanco
            fill(e.vida());
            noStroke();
            ellipse(e.x, e.y, e.tamaño, e.tamaño);
        }
        // Si hay alguna o se pulsa el espacio, se tratan las estrellas fugaces
        dibujarEstrellasFugaces();
    }
    
    private void dibujarEstrellasFugaces() {
        if (triggerTecla(' '))
            estrellasFugaces.add(new EstrellaFugaz());
        for (EstrellaFugaz e : estrellasFugaces) {
            e.draw();
        }
    }
}

class Estrella {
    
    private float tamaño;
    private float x, y;
    
    private float vidaActual; // porcentaje de vida de la estrella, cuando llegue a 0 morirá
    private float vidaInicial;
    private float vidaPorcentaje;
    
    private boolean omitirTransicionInicial = false;
    
    Estrella() {
        init();
    }
    
    Estrella(PVector posicion, float tamaño, float vida, boolean omitirTransicionInicial) {
        init(posicion, tamaño, vida, omitirTransicionInicial);
    }
    
    private void init(PVector posicion, float tamaño, float vida, boolean omitirTransicionInicial) {
        this.x = posicion.x;
        this.y = posicion.y;
        this.tamaño = tamaño;
        vidaActual = vidaInicial = vida;
        vidaPorcentaje = 0.0;
        this.omitirTransicionInicial = omitirTransicionInicial;
    }
    
    private void init() {
        init(new PVector(random(width), random(height)), random(1, 3), random(200, 1000), false);
    }
    
    void setPorcentajeVida(float porcentaje) {
        vidaPorcentaje = porcentaje;
    }
    
    float vida() {
        
        // Si acaba de nacer, primero tiene que aparecer en difuminado
        if (!omitirTransicionInicial && vidaActual == vidaInicial && vidaPorcentaje < 100) {
            return vidaPorcentaje++ * 2.55;
        }
        
        vidaActual--;
        vidaPorcentaje = vidaActual / vidaInicial * 100;
        
        // Si muere, se recoloca
        if (vidaActual < 0) {
            init();
            return 0;
        }
        
        return vidaPorcentaje * 2.55;
    }
}

class EstrellaFugaz {
    
    public static final int MIN_DURACION = 80;
    public static final int MAX_DURACION = 200;

    private PVector posicion;
    private int duracion, duracionInicial;
    private ArrayList<Estrella> estela;
    private int tamaño;
    
    EstrellaFugaz(PVector posicion, int duracion) {
        init(posicion, duracion);
    }
    
    EstrellaFugaz() {
        int duracion = (int) random(MIN_DURACION, MAX_DURACION);
        init(new PVector(random(duracion, width), random(0, height - duracion)), duracion);
    }
    
    private void init(PVector posicion, int duracion) {
        this.posicion = posicion;
        this.duracion = this.duracionInicial = duracion;
        estela = new ArrayList<Estrella>();
        tamaño = 3;
    }
    
    void draw() {
        if (duracion >= 0)
            estela.add(new Estrella(posicion, tamaño, duracionInicial, true));
        for (int i = estela.size() - 1; i >= 0; i--) {
            Estrella e = estela.get(i);
            float colorEstrella = e.vida();
            fill(colorEstrella);
            noStroke();
            ellipse(e.x, e.y, e.tamaño, e.tamaño);
            
            // Si ha muerto, la eliminamos para que no se recoloque
            if (colorEstrella == 0)
                estela.remove(e);
        }
        posicion.x -= 1;
        posicion.y += 1;
        duracion = duracion < 0 ? - 1 : --duracion;
    }
}
