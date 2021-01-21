/*
 *
 * 2D Image 3D Color Shredder
 * 
 * Loads a 2D Image. Finds the RGB value for each pixel
 * and maps that to an XYZ coordinate in 3D space. You 
 * can then click and drag to rotate the resulting 3D image.
 *
 */

// 2D Image instance
PImage img;

// Resultant 3D Shape of vectors
PShape s;

// Rotational values
float xRotVal;
float yRotVal;

PVector mouseVector;
PVector rotDir;



void setup()
{
  fullScreen(P3D);
  
  // initialize variables
  xRotVal     = 0.0f;
  yRotVal     = 0.0f;
  mouseVector = new PVector(0.0f, 0.0f);
  rotDir      = new PVector(0.0f, 0.0f);
  
  // Put your image in the sketch's Pics directory
  // and put its name in path. Example:
  // img = loadImage("Pics/MyPic.jpg");
  img = loadImage("Pics/ ");
  
  // Load pixels from the image
  img.loadPixels();
  
  // Drawing paramters
  strokeWeight(4);
  noFill();
  
  // Create shape and add vertexes with colors
  s = createShape();
  s.beginShape();
  
  // iterate through each pixel
  for (int x=0; x<img.width; x++)
  {
    for (int y=0; y<img.height; y++)
    {      
      // get color at image coordinates (x, y)
      color c = img.get(x, y);
      
      // Translate RBG to XYZ values,
      // irrespective of pixel's XY position
      // in 2D image
      translateColorToPoint(c);
    }
  }
  
  s.endShape();
  
}



void draw()
{
  background(0);
  
  // pull camera back to see full 3D shape
  camera( width/2.0, height/2.0, height * 3.0f, 
          width/2.0, height/2.0, 0.0, 
          0.0f, 1.0f, 0.0f );
  
  // Rotate 3D shape on mouseDragged
  rotateX(xRotVal);
  rotateY(yRotVal);
  
  // Draw the shape
  shape(s);
}



// Gets a color and translates RGB to XYZ values and 
// sets the vertex stroke color to RGB values
void translateColorToPoint(color col)
{
  float rX = col >> 16 & 0xFF;
  float gY = col >> 8  & 0xFF;
  float bZ = col & 0xFF;
  
  s.stroke(col);
  s.vertex    ( map(rX, 0.0f, 255.0f, 0.0f, width),
                map(gY, 0.0f, 255.0f, 0.0f, height),
                map(bZ, 0.0f, 255.0f, -height, height) );
                
}


// Sets the position of the mouse on press
void mousePressed()
{
  mouseVector = new PVector(mouseX, mouseY);
}


// Calculates X and Y axis rotations based on 
// mouse drag direction and distance
void mouseDragged()
{  
  PVector mouseDrag = new PVector(mouseX, mouseY);
  PVector mouseDir  = PVector.sub(mouseDrag, mouseVector);
  mouseDir.normalize();
  
  rotDir.add(mouseDir);
  
  xRotVal = map(rotDir.y, 0.0f, 100.0f, 0.0f, TWO_PI);
  yRotVal = map(rotDir.x, 0.0f, 100.0f, 0.0f, TWO_PI);
}
