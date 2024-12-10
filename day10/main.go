package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	b, err := os.ReadFile("./data/input.txt")

	if err != nil {
		panic(fmt.Errorf("Failed to read input, %w", err))
	}

	lines := strings.Split(strings.Trim(string(b), "\n"), "\n")
	grid := make([][]int, len(lines))

	for y, l := range lines {
		s := strings.Split(l, "")
		row := make([]int, len(s))

		for x, v := range s {
			row[x] = atoi(v)
		}

		grid[y] = row
	}

	part1(grid)
	part2(grid)
}

func atoi(r string) int {
	n, err := strconv.Atoi(r)

	if err != nil {
		panic(fmt.Errorf("Failed to convert %s to int, %w", r, err))
	}

	return n
}
