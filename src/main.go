package main

import (
	"bufio"
	"encoding/hex"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
)

var inputFile string

// supposed to parse args here; somthings wrong tho
func init() {
	flag.StringVar(&inputFile, "input", "", "input file")
	flag.StringVar(&inputFile, "i", "", "input file")

}

func main() {
	flag.Parse()

	// early exit on failure
	if inputFile == "" {
		log.Fatalf("no file provided")
	}

	fmt.Println(inputFile)

	f, err := os.Open(inputFile)

	if err != nil {
		log.Fatal(err)
	}

	defer f.Close()

	reader := bufio.NewReader(f)
	buf := make([]byte, 256)

	for {
		_, err := reader.Read(buf)

		if err != nil {
			if err != io.EOF {
				fmt.Println(err)
			}
			break
		}

		dst := make([]byte, hex.EncodedLen(len(buf)))

		hex.Encode(dst, buf)

		// fmt.Println(line + "=====break====")
		// fmt.Println(line[0:58])
		fmt.Printf("%s", dst)
	}
}

// 000000f0  4a 3a 2c d3 a7 42 0c bc  4d e2 df a2 a9 9a 0f 56  |J
