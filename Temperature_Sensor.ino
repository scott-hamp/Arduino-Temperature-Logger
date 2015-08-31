

const int temperaturePin = 0;
const int led1Pin = 12;
const int led2Pin = 13;


void setup()
{

  // Set LED pins to output
  
  pinMode(led1Pin, OUTPUT);
  pinMode(led2Pin, OUTPUT);
  
  // Light LED2 to indicate that the program has started
  
  digitalWrite(led2Pin, HIGH);
  
  Serial.begin(9600);
}


void loop()
{

  float voltage, degreesC;

  // Get voltage
  
  voltage = getVoltage(temperaturePin);

  // Convert to deg C
  
  degreesC = (voltage - 0.5) * 100.0;
  
  // Print to serial
  
  Serial.println(degreesC);
  
  // Flash LED1 to indicate that a reading has taken place
  
  digitalWrite(led1Pin, HIGH);
  
  delay(1000);
  
  digitalWrite(led1Pin, LOW);
  
  // Delay one minute before another reading
  
  delay(59000);
  
}


// Read the pin and return the voltage

float getVoltage(int pin)
{
  
  return (analogRead(pin) * 0.004882814);
  
}

