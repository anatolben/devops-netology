package main

import "fmt"

func main() {
	fmt.Println("To find the minimum value\nenter a list of integer values\n​​separated by any characters:")
	x := input([]int{}, nil)

	if len(x) > 0 {
		min := findMin(x)
		fmt.Println("Minimum value: ", min)
	} else {
		fmt.Println("Slice is empty.")
	}
}

func findMin(arr []int) (min int) {
	min = arr[0]

	for _, value := range arr {
		if value < min {
			min = value
		}
	}
	return
}

func input(x []int, err error) (val []int) {
	if err != nil {
		return x
	}
	var d int
	n, err := fmt.Scanf("%d", &d)
	if n == 1 {
		x = append(x, d)
	}
	val = input(x, err)
	return
}
