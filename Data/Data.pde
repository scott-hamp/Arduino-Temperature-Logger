
import processing.serial.*;

Serial myPort;        // The serial port

Table dataTable;

final int READINGS_INTERVAL = 1;  // Number of minutes between each reading
float degreesC;
float tempHigh = 0;
float tempLow = 999;
float tempAverage = 0;
float tempTotal = 0;
int periodReadings = 0;  // Number of readings during the period
int periodMinutes = 0;   // Number of minutes elapsed during the period

int drawX = 1;         // horizontal position of the graph

PFont font1;


void setup () {

  // List all the available serial ports

  println(Serial.list());

  // Open serial port (2nd port = COM3)

  myPort = new Serial(this, Serial.list()[1], 9600);

  // Don't generate a serialEvent() unless you get a newline character:

  myPort.bufferUntil('\n');

  // Setup data table

  dataTable = new Table();

  dataTable.addColumn("time");
  dataTable.addColumn("minutes elapsed");
  dataTable.addColumn("temperature");

  // Set the window size:

  size(600, 300);        

  // Setup font

  font1 = createFont("Arial", 12, true); 
  
  // Set inital background:

  background(255);
}

void draw () {
  
  // Everything happens in the serialEvent()
  
}

void serialEvent (Serial myPort) {

  // Get the ASCII string:

  String inString = myPort.readStringUntil('\n');

  if (inString != null) {

    // Trim off any whitespace:

    inString = trim(inString);

    // Convert string read into float

    float degreesC = float(inString); 

    // Keep track of total readings, temp total, temp average, temp high and temp low

    periodReadings++;
    periodMinutes+=READINGS_INTERVAL;
    tempTotal += degreesC;
    tempAverage = tempTotal/periodReadings;

    if (degreesC > tempHigh) {
      tempHigh = degreesC;
    }

    if (degreesC < tempLow) {
      tempLow = degreesC;
    }

    // Save to data table

    TableRow newRow = dataTable.addRow();
    newRow.setString("time", hour()+":"+minute()+":"+second());
    newRow.setInt("minutes elapsed", periodMinutes);
    newRow.setFloat("temperature", degreesC);

    saveTable(dataTable, "data - "+year()+"-"+month()+"-"+day()+".csv");

    // Map the temperature between 0 and 50 deg C

    float drawValue = map(degreesC, 0, 50, 0, height);

    // Display the high and low data

    textFont(font1);       
    textAlign(LEFT);
    fill(255);
    noStroke();
    rect(0, 0, 500, 30);
    fill(0);
    text("HIGH: "+tempHigh+"  -  LOW: "+tempLow+"  -  AVERAGE: "+tempAverage, 5, 20); 

    // Draw the line on the graph

    stroke(0, 0, 0);
    line(drawX, height, drawX, height - drawValue);

    // If the graph is at the edge of the screen, go back to the beginning:

    if (drawX >= width) {

      drawX = 0;
      background(0);
    } else {

      // Increment the horizontal position

      drawX++;
    }

  }
}

