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

	in := strings.Trim(string(b), "\n")
	part1(in)
	part2(in)
}

func part1(input string) {
	blocks := []int{}
	mem := 0

	for idx, rune := range input {
		for range atoi(string(rune)) {
			if idx%2 == 0 {
				blocks = append(blocks, idx/2)
			} else {
				blocks = append(blocks, -1)
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

	fmt.Printf("Part 1 check sum: %d\n", sum)
}

type Node struct {
	id        int
	size      int
	freeSpace int
	next      *Node
	prev      *Node
}

func part2(b string) {
	input := string(b)

	// Create a linked list of the nodes
	start := Node{id: 0, size: atoi(string(input[0])), freeSpace: atoi(string(input[1]))}
	end := &start

	for idx, rune := range input {
		// Skip first (since we already made it) and free space values
		if idx == 0 || idx%2 != 0 {
			continue
		}

		n := &Node{id: idx / 2, size: atoi(string(rune))}

		if idx+1 < len(input) {
			n.freeSpace = atoi(string(input[idx+1]))
		}

		end.next = n
		n.prev = end
		end = n
	}

	n1 := end
	// Go end to start
	for n1 != nil {
		p := n1.prev
		// Go start to end
		for n2 := &start; n1 != n2 && n2 != nil; n2 = n2.next {
			// If our START node can fit our END node, move it
			if n2.freeSpace >= n1.size {
				n1.prev.next = n1.next
				n1.prev.freeSpace += n1.size + n1.freeSpace

				if n1.next != nil {
					n1.next.prev = n1.prev
				}

				if n2.next != nil {
					n2.next.prev = n1
					n1.next = n2.next
				}

				n1.freeSpace = n2.freeSpace - n1.size
				n2.freeSpace = 0
				n2.next = n1
				n1.prev = n2

				break
			}
		}
		n1 = p
	}

	sum, loc := 0, 0

	for n := &start; n != nil; n = n.next {
		for range n.size {
			sum += n.id * loc
			loc++
		}

		for range n.freeSpace {
			loc++
		}
	}

	fmt.Printf("Part 2 check sum: %d\n", sum)
}

func atoi(r string) int {
	n, err := strconv.Atoi(r)

	if err != nil {
		panic(fmt.Errorf("Failed to convert %s to int, %w", r, err))
	}

	return n
}
