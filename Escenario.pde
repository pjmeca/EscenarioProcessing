/*  Escenario espacial SIMU 2023 por Pablo Jesús Meca Martínez.
    ------------------------------------------------------------------------------------------------ 
    Este archivo contiene los métodos para la ejecución del escenario. Todos los archivos deben
    meterse en una directorio "Escenario" para que Processing funcione correctamente.
    ------------------------------------------------------------------------------------------------ 
*/

Estrellas estrellas;
Tierra tierra;
Marte marte;
Sol sol;
Nave nave;
ArrayList<Ovni> ovnis;
Asteroides asteroidesBack, asteroidesMid, asteroidesFront;

void setup() {
    size(1920, 1080);
    frameRate(30);

    estrellas = new Estrellas();
    tierra = new Tierra(new PVector(50, 100), 300, 3, 23);  
    marte = new Marte(new PVector(1200, 800), 150, 2, 25);
    sol = new Sol(new PVector(1500, 200), 100, 1);
    nave = new Nave(new PVector(800, 480), 25);

    ovnis = new ArrayList<Ovni>();
    for(int i=0; i<3; i++) {
        ovnis.add(new Ovni());
    }

    asteroidesBack = new Asteroides(20, 20);
    asteroidesMid = new Asteroides(8, 80);
    asteroidesFront = new Asteroides(2, 100);
}

void draw() {
    // Establecer un fondo negro para el cielo
    background(0);

    // Dibujar estrellas en el fondo
    estrellas.draw();

    // El sol es el que está más lejos
    sol.draw();

    // Primera capa de asteroides
    asteroidesBack.draw();

    // Dibujar los planetas
    tierra.draw();
    marte.draw();

    // Segunda capa de asteroides
    asteroidesMid.draw();  

    // Ovnis
    for(Ovni o : ovnis)
        o.draw();

    // Nave interactiva
    nave.draw();

    // Última capa de asteroides
    asteroidesFront.draw();  

    // Imprime en la terminal el número de FPS
    FPS();
}

boolean primeraVez = true;
void FPS() {
    if(primeraVez) {
        primeraVez = false;
    } else {
        print("                     \033[F\r");
    }
    println("FPS: " + frameRate);
}