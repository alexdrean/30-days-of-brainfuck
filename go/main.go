package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	for _, arg := range os.Args[1:] {
		rom, err := ioutil.ReadFile(arg)
		if err != nil {
			println(err.Error())
			continue
		}

		length := len(rom)

		tab := make([]byte, 30000)
		tabIndex := 0

		readbuf := make([]byte, 1)
		for romIndex := 0; romIndex < length; romIndex++ {
			switch rom[romIndex] {
			case '+':
				tab[tabIndex]++
			case '-':
				tab[tabIndex]--
			case '>':
				tabIndex++
			case '<':
				tabIndex--
			case '.':
				fmt.Printf("%c", tab[tabIndex])
			case ',':
				os.Stdin.Read(readbuf)
				tab[tabIndex] = readbuf[0]
			case '[':
				if tab[tabIndex] == 0 {
					handleLoop(rom, &romIndex)
				}
			case ']':
				if tab[tabIndex] != 0 {
					handleLoop(rom, &romIndex)
				}
			}
		}
	}
}
func handleLoop(rom []byte, i *int) {
	op := 1
	if rom[*i] == ']' {
		op = -1
	}
	for counter := 0;; *i += op {
		switch rom[*i] {
		case '[':
			counter++
		case ']':
			counter--
		}
		if counter == 0 {
			break
		}
	}
}
