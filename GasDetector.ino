#define MQ_PIN A0        
#define BUZZER_PIN 11     
int threshold = 200;     
const int numReadings = 10; 
int gasReadings[numReadings]; 
int gasIndex = 0;       
void setup() {
  Serial.begin(9600);
  pinMode(MQ_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);

  
  for (int i = 0; i < numReadings; i++) {
    gasReadings[i] = 0;
  }
}

void loop() {
  int gasValue = analogRead(MQ_PIN); 
  Serial.print("Raw Gas Value: ");
  Serial.println(gasValue);

  
  int smoothedValue = getSmoothedValue(gasValue);

  Serial.print("Smoothed Gas Value: ");
  Serial.println(smoothedValue);

  if (smoothedValue > threshold) {
    Serial.println("Gas detected! Activating buzzer.");
    digitalWrite(BUZZER_PIN, HIGH); // Turn on the buzzer
  } else {
    Serial.println("No gas detected. Buzzer off.");
    digitalWrite(BUZZER_PIN, LOW);  // Turn off the buzzer
  }

  delay(1000); 
}

int getSmoothedValue(int rawValue) {
  
  gasReadings[gasIndex] = rawValue;
  gasIndex = (gasIndex + 1) % numReadings;

  
  int average = 0;
  for (int i = 0; i < numReadings; i++) {
    average += gasReadings[i];
  }
  average /= numReadings;

  return average;
}

