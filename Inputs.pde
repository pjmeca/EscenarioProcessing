/* RATÓN */

// Comprueba si el ratón se encuentra dentro del rango y es clicado
Object objetoActivo = null; // el objeto que activó el trigger
boolean triggerRaton(PVector posicion, int ancho, int alto, Object objeto) {
    int x = (int) posicion.x;
    int y = (int) posicion.y;

    if (mouseX >= x && mouseX <= x + ancho && mouseY >= y && mouseY <= y + alto) {
        cursor(HAND);
        objetoActivo = objeto;
        return mousePressed;
    } else {
        if(objeto == objetoActivo) {
            cursor(ARROW);
            objetoActivo = null;
        }        
        return false;
    }        
}

// Deshabilita el trigger del ratón si el objeto es el que lo activó
void disableTriggerRaton(Object objeto) {
    if(objeto == objetoActivo) {
        cursor(ARROW);
        objetoActivo = null;
    }
}


/* TECLADO */

// Comprueba si se ha pulsado una tecla
boolean prevKeyPressed = false; // para que solo devuelva true en el frame en el que se pulsa
boolean triggerTecla(char tecla) {
    boolean isTriggered = keyPressed && key == tecla && !prevKeyPressed;
    prevKeyPressed = keyPressed;
    return isTriggered;
}