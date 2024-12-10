package main

import "fmt"

func part1(grid [][]int) {
	score := make([][]int, len(grid))

	for idx := range len(grid) {
		score[idx] = make([]int, len(grid[idx]))
	}

	for y, row := range grid {
		for x, col := range row {
			if col == 9 {
				m := make([][]int, len(grid))

				for idx := range len(grid) {
					m[idx] = make([]int, len(grid[idx]))
				}

				searchWithMask(x, y, grid, &score, &m)
			}
		}
	}

	sum := 0

	for _, row := range score {
		for _, col := range row {
			sum += col
		}
	}

	fmt.Printf("Part 1 sum: %d\n", sum)
}

func searchWithMask(x int, y int, grid [][]int, score *[][]int, mask *[][]int) {
	val := grid[y][x]

	if val == 0 {
		if (*mask)[y][x] == 0 {
			(*score)[y][x]++
			(*mask)[y][x] = 1
		}

		return
	}

	if y+1 < len(grid) && grid[y+1][x] == val-1 {
		searchWithMask(x, y+1, grid, score, mask)
	}

	if y-1 >= 0 && grid[y-1][x] == val-1 {
		searchWithMask(x, y-1, grid, score, mask)
	}

	if x+1 < len(grid[0]) && grid[y][x+1] == val-1 {
		searchWithMask(x+1, y, grid, score, mask)
	}

	if x-1 >= 0 && grid[y][x-1] == val-1 {
		searchWithMask(x-1, y, grid, score, mask)
	}
}
