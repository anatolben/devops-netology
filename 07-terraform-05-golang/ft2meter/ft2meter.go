package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Print("Enter a value in international foot 'ft': ")
	var input float64
	fmt.Scanf("%f", &input)
	fmt.Printf("It's %v meters.\n", Round(input*0.3048, 3))
}

func Round(x float64, prec int) (val float64) {
	var rounder float64
	pow := math.Pow(10, float64(prec))
	intermed := x * pow
	_, frac := math.Modf(intermed)
	if frac >= 0.5 {
		rounder = math.Ceil(intermed)
	} else {
		rounder = math.Floor(intermed)
	}
	val = rounder / pow
	return
}
