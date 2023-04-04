// Comprueba si el ratón se encuentra dentro del rango y es clicado
Object objetoActivo = null; // el objeto que activó el trigger
boolean triggerRaton(int x, int y, int ancho, int alto, Object objeto) {
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