/**
 * Lamp by Jean Pierre Charalambos.
 * 
 * This class is part of the Luxo example.
 * 
 * Add a graphics handler to an InteractiveFrame to automatically pick
 * an object. The object is described in the graphics handler procedure.
 */

public class Lamp implements PConstants {
  Scene scene;
  LampShape[] frameArray;
  Lamp(Scene s) {
    scene = s;
    frameArray = new LampShape[4];

    for (int i = 0; i < 4; ++i) {
      frameArray[i] = new LampShape(scene);
      frame(i).setReference(i > 0 ? frameArray[i - 1] : null);
      frame(i).setHighlighting(OrbitShape.Highlighting.FRONT);
    }

    // Initialize frames
    frame(1).setTranslation(0f, 0f, 8f); // Base height
    frame(2).setTranslation(0, 0, 50);  // Arm length
    frame(3).setTranslation(0, 0, 50);  // Arm length

    frame(1).setRotation(new Quaternion(new Vector(1.0f, 0.0f, 0.0f), 0.6f));
    frame(2).setRotation(new Quaternion(new Vector(1.0f, 0.0f, 0.0f), -2.0f));
    frame(3).setRotation(new Quaternion(new Vector(1.0f, -0.3f, 0.0f), -1.7f));

    //graphics handlers
    frame(0).mode = 1;
    frame(1).mode = 2;
    frame(2).mode = 2;
    frame(3).mode = 3;

    // Set frame constraints
    WorldConstraint baseConstraint = new WorldConstraint();
    baseConstraint.setTranslationConstraint(AxisPlaneConstraint.Type.PLANE, new Vector(0.0f, 0.0f, 1.0f));
    baseConstraint.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vector(0.0f, 0.0f, 1.0f));
    frame(0).setConstraint(baseConstraint);

    LocalConstraint XAxis = new LocalConstraint();
    XAxis.setTranslationConstraint(AxisPlaneConstraint.Type.FORBIDDEN, new Vector(0.0f, 0.0f, 0.0f));
    XAxis.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vector(1.0f, 0.0f, 0.0f));
    frame(1).setConstraint(XAxis);
    frame(2).setConstraint(XAxis);

    LocalConstraint headConstraint = new LocalConstraint();
    headConstraint.setTranslationConstraint(AxisPlaneConstraint.Type.FORBIDDEN, new Vector(0.0f, 0.0f, 0.0f));
    frame(3).setConstraint(headConstraint);
    //print(frame(3).orientation());
    //scene.setEye(frame(3));
  }

  public LampShape frame(int i) {
    return frameArray[i];
  }

  public class LampShape extends OrbitShape {
    int mode;    
    PShader shdr;
    public LampShape(Scene scene) {
      super(scene);
       shdr=new PShader(scene.pApplet(), new String[] {"#version 150"
    ,"in vec4 position,normal;"
    +"uniform mat4 projectionMatrix,modelviewMatrix;"
    // the key here is flat default is smooth interpolation 
    +"flat out vec3 vN;"
    +"void main() {"
    // normal matrix
    +"mat4 nrm_Mtrx = transpose(inverse(modelviewMatrix));"
    // vertex normal
    +"vN = normalize(vec3(nrm_Mtrx*vec4(normal.xyz,0.)).xyz);"
    +"gl_Position = projectionMatrix*modelviewMatrix*position;"
    +"}"
    }, new String[] {"#version 150"
      ,"flat in vec3 vN;"
      +"uniform vec3 LDir;"
      +"uniform vec3 surfaceColor;"
      +"out vec4 fragColor;"
      +"void main() {"
      // simpel diffuse
      +"float brightness = clamp( max(0., dot(vN, normalize(LDir) ) ) ,0.,1.);"
      +"fragColor.rgb = brightness * surfaceColor;" 
      +"fragColor.a=1.0;"
      +"}"
    });
    }

    public void drawCone(PGraphics pg, float zMin, float zMax, float r1, float r2, int nbSub) {
      pg.translate(0.0f, 0.0f, zMin);
      Scene.drawCone(pg, nbSub, 0, 0, r1, r2, zMax - zMin);
      pg.translate(0.0f, 0.0f, -zMin);
    }

    @Override
    public void set(PGraphics pGraphics) {
      switch (mode) {
        case 1:
          pGraphics.fill(grabsInput() ? 255 : 0, 0, 255);
          drawCone(pGraphics, 0, 3, 15, 15, 30);
          drawCone(pGraphics, 3, 5, 15, 13, 30);
          drawCone(pGraphics, 5, 7, 13, 1, 30);
          drawCone(pGraphics, 7, 9, 1, 1, 10);
          break;
        case 2:
          pGraphics.pushMatrix();
          pGraphics.rotate(HALF_PI, 0, 1, 0);
          drawCone(pGraphics, -5, 5, 2, 2, 20);
          pGraphics.popMatrix();

          pGraphics.translate(2, 0, 0);
          drawCone(pGraphics, 0, 50, 1, 1, 10);
          pGraphics.translate(-4, 0, 0);
          drawCone(pGraphics, 0, 50, 1, 1, 10);
          pGraphics.translate(2, 0, 0);
          break;
        case 3:
          pGraphics.fill(0, 255, grabsInput() ? 0 : 255);
          drawCone(pGraphics, -2, 6, 4, 4, 30);
          drawCone(pGraphics, 6, 15, 4, 17, 30);
          drawCone(pGraphics, 15, 17, 17, 17, 30);
          
          shdr.set("LDir", this.orientation().x(),this.orientation().y(), this.orientation().z());
          println('x',this.orientation().x());
          println('y',this.orientation().y());
          println('z',this.orientation().z());
  // range from 0 - 1
          shdr.set("surfaceColor",.5f,.5f,1.f);
          shader(shdr);
          //pGraphics.spotLight(155, 255, 255, 0, 0, 0, 0, 0, 1, THIRD_PI, 1);
          break;
      }
    }
  }
}
