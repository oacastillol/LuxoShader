public class Box {
  public Node iFrame;
  float w, h, d;
  int c;

  public Box() {
    iFrame = new OrbitNode(scene);
    //iFrame.setPrecision(Node.Precision.ADAPTIVE);
    iFrame.setPrecisionThreshold(25);
    setSize(30,30,30);
    setColor();
    //iFrame.randomize();
  }

  public void draw() {
    draw(false);
  }

  public void draw(boolean drawAxes) {
    pushMatrix();
    iFrame.applyWorldTransformation();
    if (drawAxes)
      //scene.drawAxes(PApplet.max(w, h, d) * 1.3f);
    noStroke();
    if (iFrame.grabsInput(scene.mouse()))
      fill(255, 0, 0);
    else
      fill(getColor());
    //Draw a box
    box(w, h, d);
    popMatrix();
  }

  public void setSize() {
    w = random(10, 40);
    h = random(10, 40);
    d = random(10, 40);
    iFrame.setPrecisionThreshold(PApplet.max(w, h, d));
  }

  public void setSize(float myW, float myH, float myD) {
    w = myW;
    h = myH;
    d = myD;
  }

  public int getColor() {
    return c;
  }

  public void setColor() {
    c = color(random(0, 255), random(0, 255), random(0, 255));
  }

  public void setColor(int myC) {
    c = myC;
  }

  public Vector getPosition() {
    return iFrame.position();
  }

  public void setPosition(Vector pos) {
    iFrame.setPosition(pos);
  }

  public Quaternion getOrientation() {
    return (Quaternion) iFrame.orientation();
  }

  public void setOrientation(Vector v) {
    Vector to = Vector.subtract(v, iFrame.position());
    iFrame.setOrientation(new Quaternion(new Vector(0, 1, 0), to));
  }
}