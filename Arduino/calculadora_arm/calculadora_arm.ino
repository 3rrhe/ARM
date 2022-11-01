/*
  Calculado cientifica ARM
*/

#include "calculadora_arm.h"    // Para declarar las funciones de la calculadora
#include <stdlib.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd_1(12, 11, 5, 4, 3, 2);

void setup() {
  Serial.begin(9600);     // Habilita la comunicación por el puerto serie
  // Set up the number of columns and rows on the LCD.
  lcd_1.begin(16, 2);
}

void loop() {
  int num1 = 3;
  int num2 = 2;
  int resultado = 0;
  lcd_1.clear(); // Limpiamos el LCD 

  Serial.println("Bienvenido a la calculadora ARM");
  lcd_1.print("Calculadora ARM");

  delay(2000); // Espera 5 segundos antes de volver a empezar
  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("Num1: ");
  lcd_1.print(num1);
  lcd_1.print("  Num2: ");
  lcd_1.print(num2);

  delay(5000); // Espera 5 segundos antes de volver a empezar
  
  resultado = suma(num1, num2);
  char sumaChar = resultado;
  Serial.print("El resultado de la suma es: ");
  Serial.println(sumaChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("La suma es: ");
  lcd_1.print(sumaChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar

  resultado = resta(num1, num2);
  char restaChar = resultado;
  Serial.print("El resultado de la resta es: ");
  Serial.println(restaChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("La resta es: ");
  lcd_1.print(restaChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar

  resultado = multi(num1, num2);
  char multiChar = resultado;
  Serial.print("El resultado de la multiplicacion es: ");
  Serial.println(multiChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("La multi es: ");
  lcd_1.print(multiChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar

  resultado = divi(num1, num2);
  char diviChar = resultado;
  Serial.print("El resultado de la division es: ");
  Serial.println(diviChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("La divi es: ");
  lcd_1.print(diviChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar

  resultado = expo(num1, num2);
  char expoChar = resultado;
  Serial.print("El resultado de numero1 exponente numero1 es: ");
  Serial.println(expoChar);
 
  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("EX n1, n2 es: ");
  lcd_1.print(expoChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar
  
  resultado = expo(num1, num1);
  char expoChar = resultado;
  Serial.print("El resultado del factorial de numero1 es: ");
  Serial.println(expoChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("Fact n1 es: ");
  lcd_1.print(expoChar);

  delay(5000); // Espera 5 segundos antes de volver a empezar
  
  resultado = expo(num2, num2);
  char expoChar = resultado;
  Serial.print("El resultado del factorial de numero2 es: ");
  Serial.println(expoChar);

  lcd_1.clear(); // Limpiamos el LCD
  lcd_1.print("Fact n2 es: ");
  lcd_1.print(expoChar);
  
  Serial.println("");
  
  delay(5000); // Espera 5 segundos antes de volver a empezar
}
