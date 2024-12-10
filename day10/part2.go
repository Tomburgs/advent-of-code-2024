package main

import "fmt"

func part2(grid [][]int) {
	score := make([][]int, len(grid))

	for idx := range len(grid) {
		score[idx] = make([]int, len(grid[idx]))
	}

	for y, row := range grid {
		for x, col := range row {
			if col == 9 {
				search(x, y, grid, &score)
			}
		}
	}

	sum := 0

	for _, row := range score {
		for _, col := range row {
			sum += col
		}
	}

	fmt.Printf("Part 2 sum: %d\n", sum)
}

func search(x int, y int, grid [][]int, score *[][]int) {
	val := grid[y][x]

	if val == 0 {
		(*score)[y][x]++

		return
	}

	if y+1 < len(grid) && grid[y+1][x] == val-1 {
		search(x, y+1, grid, score)
	}

	if y-1 >= 0 && grid[y-1][x] == val-1 {
		search(x, y-1, grid, score)
	}

	if x+1 < len(grid[0]) && grid[y][x+1] == val-1 {
		search(x+1, y, grid, score)
	}

	if x-1 >= 0 && grid[y][x-1] == val-1 {
		search(x-1, y, grid, score)
	}
}
