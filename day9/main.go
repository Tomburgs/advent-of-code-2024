package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	b, err := os.ReadFile("./data/input.txt")

	if err != nil {
		panic(fmt.Errorf("Failed to read input, %w", err))
	}

	blocks := make([]int, 2000000)

	mem := 0
	for idx, rune := range string(b) {
		num, _ := strconv.Atoi(string(rune))

		for range num {
			if idx%2 == 0 {
				blocks[mem] = idx / 2
			} else {
				blocks[mem] = -1
			}
			mem++
		}
	}

	for i := 0; mem > i; i++ {
		if blocks[i] == -1 {
			blocks[i] = blocks[mem-1]
			mem--

			for blocks[mem-1] == -1 {
				mem--
			}
		}
	}

	sum := 0

	for idx := range mem {
		sum += idx * blocks[idx]
	}

	fmt.Printf("Check sum: %d\n", sum)
}
