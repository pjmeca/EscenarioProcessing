/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene la clase Ovni, que representa a un ovni en el escenario.
    Un ovni se caracteriza por una posición y una velocidad. Para aportar variedad, existen sprites
    diferentes de ovnis, al crear un ovni, se escoge un sprite de forma aleatoria. Para simular un
    movimiento orgánico, los ovnis basan su posición en un ruido Perlin.
    Cuando se hace clic sobre un ovni, este explotará y desaparecerá del escenario.
    ------------------------------------------------------------------------------------------------ 
*/

class Ovni {

    static final int SIZE = 100;

    private PImage sprite;
    private float xoff;
    private float yoff;
    private float velocidad;
    private boolean vivo;
    private SistemaParticulas particulas; // para la explosión
    
    private String[] imagenes = {
        "resources/ovni/1.png",
        "resources/ovni/2.png",
        "resources/ovni/3.png",
        "resources/ovni/4.png"
    };

    Ovni() {
        sprite = loadImage(imagenes[int(random(imagenes.length))]); // Carga la imagen del sprite
        xoff = random(width);
        yoff = random(height);
        velocidad = random(0.1, 1);
        vivo = true;

        particulas = new SistemaParticulas(8, 20, 500);
    }

    void draw() {
        
        // Calcula la posición del OVNI basándose en la función de ruido Perlin 2D
        float x = noise(xoff, yoff) * width;
        float y = noise(xoff + SIZE, yoff + SIZE) * height;

        disableTriggerRaton(this); // Como se mueve, tiene que desactivarlo para que no se quede la colisión en el vacío
        boolean haMuerto = vivo && triggerRaton(new PVector(x, y), SIZE, SIZE, this);
        vivo = vivo && !haMuerto;
        particulas.draw(haMuerto, x+SIZE/2, y+SIZE/2);

        if(vivo) {
            // Dibuja el OVNI
            image(sprite, x, y, SIZE, SIZE); // Dibuja el sprite en la posición calculada
            
            // Ajusta los valores de xoff y yoff para animar el OVNI
            xoff += velocidad * 0.01;
            yoff += velocidad * 0.01;
        }
    }
}
