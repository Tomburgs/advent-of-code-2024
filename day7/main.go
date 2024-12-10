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

	in := map[int][]int{}

	for _, l := range strings.Split(strings.Trim(string(b), "\n"), "\n") {
		p := strings.Split(l, ": ")

		if len(p) != 2 {
			panic(fmt.Errorf("Invalid amount of parts for line %s, %v", l, p))
		}

		p1 := p[0]
		p2 := strings.Split(p[1], " ")
		nums := make([]int, len(p2))

		for idx, n := range p2 {
			nums[idx] = atoi(n)
		}

		in[atoi(p1)] = nums
	}

	sum1 := 0

	for total, nums := range in {
		sum1 += value(total, nums, false)
	}

	fmt.Printf("Part 1 sum: %d\n", sum1)

	sum2 := 0

	for total, nums := range in {
		sum2 += value(total, nums, true)
	}

	fmt.Printf("part 2 sum: %d\n", sum2)
}

func value(total int, nums []int, concat bool) int {
	if len(nums) == 1 {
		if total == nums[0] {
			return total
		}

		return 0
	}

	if n := value(total, append([]int{nums[0] + nums[1]}, nums[2:]...), concat); n != 0 {
		return n
	}

	if n := value(total, append([]int{nums[0] * nums[1]}, nums[2:]...), concat); n != 0 {
		return n
	}

	if concat {
		c := atoi(fmt.Sprintf("%d%d", nums[0], nums[1]))

		if n := value(total, append([]int{c}, nums[2:]...), concat); n != 0 {
			return n
		}
	}

	return 0
}

func atoi(r string) int {
	n, err := strconv.Atoi(r)

	if err != nil {
		panic(fmt.Errorf("Failed to convert %s to int, %w", r, err))
	}

	return n
}
