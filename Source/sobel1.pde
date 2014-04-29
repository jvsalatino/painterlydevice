//import cc.arduino.*;

PImage g_img;
SobelEdgeDetection sobel;
String imageFilename = "raquel.jpg";
PrintWriter output; 
BufferedReader reader1;
BufferedReader reader2;
String line1 = " ";
String line2 = " ";
int flag = 0;
int grid = 5;
int stroke1 = 15;
int stroke2 = 6;

 
void setup()
{
 
  colorMode(HSB, 360, 255,255); 
  
 
  // Load an image
  g_img = loadImage(imageFilename);
 output = createWriter("salida.nc");
  image(g_img,0,0,width,height);
  size(g_img.width,g_img.height);

  background(200,200,200);
  // Initialize and create a new sobel object
  sobel = new SobelEdgeDetection();
  
}
 
 
 
void draw()
{
 
}
 
void keyPressed()
{
  if(key == 'r')
  {
    resetImage();
  }
  if(key == 'g')
  {
    grabImage();
  }
  
  
}
void mousePressed()
{
 
  if(mouseButton == LEFT)
  {
 
    getEdges(g_img);
 
  }
 
  if(mouseButton == RIGHT)
  {
    background(0);
  g_img = loadImage(imageFilename);
 
 //   g_img = sobel.noiseReduction(g_img, 1);
    image(g_img, 0, 0, width, height);
  }
 
}
 
void grabImage(){
  
  
  reader1 = createReader("salida.nc");
  
  while(line1 != null){
    try {
    line1 = reader1.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line1 = null;
  }
  if (line1 == null) {
    // Stop reading because of an error or file is empty
 //  println("NoEntro");
    noLoop();  
  } else {
 //  println("Entro1");
    String[] pieces = split(line1, ',');
    int xr = int(pieces[0]);
    int yr = int(pieces[1]);
    int gradr = int(pieces[2]);
    int br = int(pieces[3]);
    int hr = int(pieces[4]);
    int sr = int(pieces[5]);
    stroke(hr, sr, br);
    strokeWeight(stroke1);
    strokeCap(ROUND);
    int plusx = int(40*cos(radians(gradr+90)));
    int plusy = int(40*sin(radians(gradr+90)));

   line(xr,yr,xr+plusx,yr+plusy);
  
  } 
 }

////////////////

reader2 = createReader("salida.nc");
while(line2 != null){
    try {
    line2 = reader2.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line2 = null;
  }
  if (line2 == null) {
    // Stop reading because of an error or file is empty

    noLoop();  
  } else {
 
    String[] pieces = split(line2, ',');
    int xr = int(pieces[0]);
    int yr = int(pieces[1]);
    int gradr = int(pieces[2]);
    int br = int(pieces[3]);
    int hr = int(pieces[4]);
    int sr = int(pieces[5]);
    stroke(hr, sr, br);
    strokeWeight(stroke2);
  //  strokeCap(SQUARE);
    int plusx = int(8*cos(radians(gradr+90)));
    int plusy = int(8*sin(radians(gradr+90)));

   line(xr,yr,xr+plusx,yr+plusy);

    
  } 
 }

/////////////////////////////////////////
}

void resetImage()
{
  background(200,200,200);
  g_img = loadImage(imageFilename);
  image(g_img, 0,0, width, height);
}
 
void getEdges(PImage img)
{
 
  // Performs the edge detection routine,
  g_img = sobel.findEdgesAll(img, 90);
 
  // Remove some noise from the conversion
//  g_img = sobel.noiseReduction(g_img, 1);
 
  image(g_img, 0 , 0, width,height);
 
}



// *******************************************
// Sobel Edge Detection
// Credits to: http://www.pages.drexel.edu/~weg22/edge.html for description and source
// *******************************************
class SobelEdgeDetection
{
 
  // Sobel Edge Detection strandard, this applies the edge detection algorithm across the entire image and returns the edge image
  public PImage findEdgesAll(PImage img, int tolerance)
  {
    PImage buf = createImage( img.width, img.height, ARGB );
 
    int GX[][] = new int[3][3];
    int GY[][] = new int[3][3];
    int sumRx = 0;
    int sumGx = 0;
    int sumBx = 0;
    int sumRy = 0;
    int sumGy = 0;
    int sumBy = 0;
    int briy = 0;
    int finalSumR = 0;
    int finalSumG = 0;
    int finalSumB = 0;
 
    // 3x3 Sobel Mask for X
    GX[0][0] = -1;
    GX[0][1] = 0;
    GX[0][2] = 1;
    GX[1][0] = -2;
    GX[1][1] = 0;
    GX[1][2] = 2;
    GX[2][0] = -1;
    GX[2][1] = 0;
    GX[2][2] = 1;
 
    // 3x3 Sobel Mask for Y
    GY[0][0] =  1;
    GY[0][1] =  2;
    GY[0][2] =  1;
    GY[1][0] =  0;
    GY[1][1] =  0;
    GY[1][2] =  0;
    GY[2][0] = -1;
    GY[2][1] = -2;
    GY[2][2] = -1;
 
    buf.loadPixels(); 
 
    for(int y = 0; y < img.height; y+=grid)
    {
      for(int x = 0; x < img.width; x+=grid)
      {
        if(y==0 || y==img.height-1) {
        }
        else if( x==0 || x == img.width-1 ) {
        }
        else
        {
 
          // Convolve across the X axis and return gradiant aproximation
          for(int i = -1; i <= 1; i++)
            for(int j = -1; j <= 1; j++)
            {
              color col =  img.get(x + i, y + j);
              
            //float r = red(col);
              float r = hue(col);
            //  float g = green(col);
              float g = saturation(col);
               //  float b = blue(col);
              float b = brightness(col);
            
             sumRx = int(r);
             sumGx = int(g);
 
           //   sumRx += r * GX[ i + 1][ j + 1];
            //  sumGx += g * GX[ i + 1][ j + 1];
              sumBx += b * GX[ i + 1][ j + 1];
 
            }
 
          // Convolve across the Y axis and return gradiant aproximation
          for(int i = -1; i <= 1; i++)
            for(int j = -1; j <= 1; j++)
            {
              color col =  img.get(x + i, y + j);
           //   float r = red(col);
              float r = hue(col);
            //  float g = green(col);
              float g = saturation(col);
            //   float b = blue(col);  
              float b = brightness(col);
           
                sumRy = int(r);
                sumGy = int(g);
                briy = int(b);
        //      sumRy += r * GY[ i + 1][ j + 1];
        //      sumGy += g * GY[ i + 1][ j + 1];
              sumBy += b * GY[ i + 1][ j + 1];
 
            }
 
    //      finalSumR = abs(sumRx) + abs(sumRy);
    //      finalSumG = abs(sumGx) + abs(sumGy);
          finalSumB = abs(sumBx) + abs(sumBy);
          stroke(255,255,255);
      
        int suma= int(finalSumB);
    
          int grad = int(map (suma, 0, 255, 0 ,360));
          output.println(x+","+y+","+grad+","+briy+","+sumRy+","+sumGy);
          
         
  
 
 
 
         buf.pixels[ x + (y * img.width) ] = color(finalSumR, finalSumG, finalSumB);
         
          sumRx=0;
          sumGx=0;
          sumBx=0;
          sumRy=0;
          sumGy=0;
          sumBy=0;
 
        }
 
      }
 
    }
    output.flush(); // Write the remaining data
  output.close(); // Finish the file
    buf.updatePixels();
 
    return buf;
  }
 
 
 
  public PImage noiseReduction(PImage img, int kernel)
  {
    PImage buf = createImage( img.width, img.height, ARGB );
     
 
    buf.loadPixels();
 
    for(int y = 0; y < img.height; y+=grid)
    {
      for(int x = 0; x < img.width; x+=grid)
      {
 
        int sumR = 0;
        int sumG = 0;
        int sumB = 0;
 
        // Convolute across the image, averages out the pixels to remove noise
        for(int i = -kernel; i <= kernel; i++)
        {
          for(int j = -kernel; j <= kernel; j++)
          {
            color col = img.get(x+i,y+j);
            float r = red(col);
            float g = green(col);
            float b = blue(col);
 
            if(r==255) sumR++;
            if(g==255) sumG++;
            if(b==255) sumB++;
          }
        }
 
        int halfKernel = (((kernel*2)+1) * ((kernel*2)+1)) / 2 ;
 
        if(sumR > halfKernel  ) sumR=255;
        else sumR= 0;
        if(sumG > halfKernel  ) sumG=255;
        else sumG= 0;
        if(sumB > halfKernel  ) sumB=255;
        else sumB= 0;
 
 
        buf.pixels[ x + (y * img.width) ] = color(sumR, sumG, sumB);
 
      }
 
 
    }
    buf.updatePixels();
 
    return buf;
  }
 
 
}
