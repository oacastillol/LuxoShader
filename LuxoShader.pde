/**
 * Luxo.
 * by Jean Pierre Charalambos.
 * 
 * A more complex example that combines Shapes, selection and constraints.
 * 
 * This example displays a famous luxo lamp (Pixar) that can be interactively
 * manipulated with the mouse.
 * 
 * Hover over lamp elements to select them, and then drag them with the mouse.
 */

import frames.processing.*;
import frames.input.*;
import frames.core.*;
import frames.primitives.*;
import frames.primitives.constraint.*;

Scene scene;
Lamp lamp;
PShader lightShader;
Box caja;

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  OrbitShape eye = new OrbitShape(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.setRadius(100);
  scene.fitBallInterpolation();
  lamp = new Lamp(scene);
  caja = new Box();
 // lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {
  background(0);
//  lights();
  //shader(lightShader);
  //draw the lamp
  scene.traverse();

  //draw the ground
  noStroke();
  //fill(120, 120, 120);
  float nbPatches = 10;
  boolean p = true;
  normal(0.0f, 0.0f, 1.0f);
  for (int j = 0; j < nbPatches; ++j) {
    //beginShape(QUAD_STRIP);
    for (int i = 0; i <= nbPatches; ++i) {
      if(p){
        fill(120, 120, 120);
        p = false;
      }
      else{
        fill(255);
        p = true;
      }
      beginShape();
      vertex((200 * (float) i / nbPatches - 100), (200 * j / nbPatches - 100));
      vertex((200 * (float) i / nbPatches - 100), (200 * (float) (j + 1) / nbPatches - 100));
 
      vertex((200 * (float) (i+1) / nbPatches - 100), (200 * (float) (j + 1) / nbPatches - 100));
      vertex((200 * (float) (i+1) / nbPatches - 100), (200 * j / nbPatches - 100));
      endShape(CLOSE);
    }
    //endShape();
  }
  caja.setPosition(new Vector(50.0f, 50.0f, 15.0f));
  caja.draw(true);
}
