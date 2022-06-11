package main

import (
	"fmt"
)

func main() {
	var min, max, dvr int
	fmt.Print("Enter minimum value: ")
	fmt.Scan(&min)
	fmt.Print("Enter maximum value: ")
	fmt.Scan(&max)
	fmt.Print("Enter divider: ")
	fmt.Scan(&dvr)
	fmt.Printf("These numbers are divisible by %v: ", dvr)
	fmt.Println(division(min, max, dvr))
}

func division(min, max, dvs int) (s []int) {
	for i := min; i < max+1; i++ {
		var c int = i % dvs
		if c == 0 {
			s = append(s, i)
		}
	}
	return
}
