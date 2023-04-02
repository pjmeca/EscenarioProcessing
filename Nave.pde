class Nave {
    public static final String imagenURL = "resources/nave.png";
    public static final int DEFAULT_ACELERACION = 5;
    public static final int VELOCIDAD_MAX = 100;
    public static final float STOP_THRESHOLD = 0.5;
    public static final float FRICCION = 0.75;

    PImage imagen;
    int x, y;
    float velocidadX, velocidadY, aceleracion, friccion, angulo;
    boolean impulsada;
    float tamaño;
    int incrementoAngulo = random(-1, 1) < 0 ? -1 : 1;

    Nave(int x, int y, int tamañoPorcentaje) {
        imagen = loadImage(imagenURL);

        this.x = x;
        this.y = y;
        this.tamaño = tamañoPorcentaje/100.0;
        imagen.resize(int(imagen.width*tamaño), int(imagen.height*tamaño));

        velocidadX = 0;
        velocidadY = 0;

        aceleracion = 0;

        angulo = random(-360, 360);

        impulsada = false;
    }

    void draw() {       
        // Movimiento
        if(triggerRaton()){
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
                incrementoAngulo = random(-1, 1) < 0 ? -1 : 1;
            }
        } else {
            // Girar la nave
            angulo += incrementoAngulo;
        }

        // Mover la nave
        x += velocidadX;
        y += velocidadY;

        wrapEdges();

        // Actualizar la posición
        pushMatrix();
        translate(x + imagen.width/2, y + imagen.height/2);
        rotate(radians(angulo));
        image(imagen, -imagen.width/2, -imagen.height/2);
        popMatrix();
    }

    boolean triggerRaton() {
        if (mouseX >= x && mouseX <= x + imagen.width && mouseY >= y && mouseY <= y + imagen.height) {
            cursor(HAND);
            return mousePressed;
        } else {
            cursor(ARROW);
            return false;
        }        
    }

    void wrapEdges() {
        float velocidadMultiplicador = 1.0;

        // Si se sale, la movemos al otro extremo
        if (x > width) {
            x = -imagen.width;
            velocidadMultiplicador = 1.5;
        } else if (x < -imagen.width) {
            x = width;
            velocidadMultiplicador = 1.5;
        }

        if (y > height) {
            y = -imagen.height;
            velocidadMultiplicador = 1.5;
        } else if (y < -imagen.height) {
            y = height;
            velocidadMultiplicador = 1.5;
        }

        // Si el centro sigue fuera, le damos un empujón
        if((x+imagen.width/2 >= width || x <= -imagen.width/2) && (y+imagen.height/2 >= height || y <= -imagen.height/2)) {
            velocidadMultiplicador += 1;
        }

        // Multiplicar la velocidad si la nave se mueve fuera de la pantalla
        velocidadX *= velocidadMultiplicador;
        velocidadY *= velocidadMultiplicador;
    }

}