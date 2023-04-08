class Nave {
    static final String imagenURL = "resources/nave.png";
    static final int DEFAULT_ACELERACION = 5;
    static final int VELOCIDAD_MAX = 100;
    static final float STOP_THRESHOLD = 0.5;
    static final float FRICCION = 0.75;
    
    private PImage imagen;
    private PVector posicion;
    private float velocidadX, velocidadY, aceleracion, friccion, angulo;
    private boolean impulsada;
    private float tamaño;
    private int incrementoAngulo = random( - 1, 1) < 0 ? - 1 : 1;
    
    private SistemaParticulas particulas;
    
    Nave(PVector posicion, int tamañoPorcentaje) {
        imagen = loadImage(imagenURL);
        
        this.posicion = posicion;
        this.tamaño = tamañoPorcentaje / 100.0;
        imagen.resize(int(imagen.width * tamaño), int(imagen.height * tamaño));
        
        velocidadX = 0;
        velocidadY = 0;
        
        aceleracion = 0;
        
        angulo = random( - 360, 360);
        
        impulsada = false;
        
        particulas = new SistemaParticulas(8, 20, 500);
    }
    
    void draw() {       
        // Movimiento
        if (triggerRaton(posicion, imagen.width, imagen.height, this)) {
            impulsada = true;
            aceleracion += DEFAULT_ACELERACION;
        }            
        
        if (impulsada) {
            // Calcular la nueva velocidad de la nave
            velocidadX += aceleracion * cos(radians(angulo));
            velocidadY += aceleracion * sin(radians(angulo));
            velocidadX *= FRICCION;
            velocidadY *= FRICCION;
            aceleracion *= FRICCION;
            
            // Limitar la velocidad máxima
            float velocidadActual = dist(0, 0, velocidadX, velocidadY);
            
            if (velocidadActual < STOP_THRESHOLD) {
                impulsada = false;
                velocidadX = 0;
                velocidadY = 0;
                aceleracion = 0;
                
                // Cambiamos el ángulo
                incrementoAngulo = random( - 1, 1) < 0 ? - 1 : 1;
            }
        } else {
            // Girar la nave
            angulo += incrementoAngulo;
        }
        
        // Mover la nave
        posicion.x += velocidadX;
        posicion.y += velocidadY;
        
        checkSalirPantalla();
        
        // Actualizar la posición
        pushMatrix();
        translate(posicion.x + imagen.width / 2, posicion.y + imagen.height / 2);
        rotate(radians(angulo));
        particulas.draw(triggerRaton(posicion, imagen.width, imagen.height, this), -imagen.height / 2, 0, radians(180)); // fuego al encender el motor
        image(imagen, -imagen.width / 2, -imagen.height / 2);
        popMatrix();
    }
    
    void checkSalirPantalla() {
        float velocidadMultiplicador = 1.0;
        
        // Si se sale, la movemos al otro extremo
        if (posicion.x > width) {
            posicion.x = -imagen.width;
            velocidadMultiplicador = 1.5;
        } else if (posicion.x < - imagen.width) {
            posicion.x = width;
            velocidadMultiplicador = 1.5;
        }
        
        if (posicion.y > height) {
            posicion.y = -imagen.height;
            velocidadMultiplicador = 1.5;
        } else if (posicion.y < - imagen.height) {
            posicion.y = height;
            velocidadMultiplicador = 1.5;
        }
        
        // Si el centro sigue fuera, le damos un empujón
        if ((posicion.x + imagen.width / 2 > width || posicion.x < - imagen.width / 2) || (posicion.y + imagen.height / 2 > height || posicion.y < - imagen.height / 2)) {
            velocidadMultiplicador = 1.5;
            angulo += 1; // movemos un poco el ángulo para que no quede atrapado en un eje
        }
        
        // Multiplicar la velocidad si la nave se mueve fuera de la pantalla
        velocidadX *= velocidadMultiplicador;
        velocidadY *= velocidadMultiplicador;
    }
    
}
