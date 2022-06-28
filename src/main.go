package main

import (
	"bufio"
	"encoding/hex"
	"flag"
	"fmt"
	"io"
	"log"
	"math/rand"
	"os"
	"time"
)

// IO VARS
var inputFile string
var outputFile string

// SETTINGS VARS
var corruptionRate float64

func init() {

	// INPUT FLAGS
	flag.StringVar(&inputFile, "i", "", "input file")

	// OUTPUT FLAGS
	flag.StringVar(&outputFile, "o", "", "output file")

	// CORRUPTION RATE FLAGS?
	flag.Float64Var(&corruptionRate, "c", 0.005, "corruption rate")

}

func main() {

	s1 := rand.NewSource(time.Now().UnixNano())
	r1 := rand.New(s1)

	// parse provided arguments
	flag.Parse()

	// open file
	f, err := os.Open(inputFile)

	if err != nil {
		log.Fatal(err)
	}

	// create a reader and buffer
	reader := bufio.NewReader(f)
	buf := make([]byte, 256)

	// create output file
	out, err := os.Create(outputFile)

	if err != nil {
		log.Fatal(err)
	}

	// defer closing input & output file
	defer f.Close()
	defer out.Close()

	for {
		// read file into buffer
		_, err := reader.Read(buf)

		if err != nil {
			if err != io.EOF {
				fmt.Println(err)
			}
			break
		}

		// hacky way to get 5% corruption
		if r1.Float64() < corruptionRate {

			// create buffer for byte in hex format
			hexBuf := make([]byte, hex.EncodedLen(len(buf)))

			// encode as hex
			hex.Encode(hexBuf, buf)

			// randomly zer0 a byte (and try to avoid headers)
			// TODO : more rigorous probability

			outBuf := make([]byte, hex.DecodedLen(len(hexBuf)))

			hex.Decode(hexBuf, outBuf)

			out.Write(outBuf)

			hexBuf[rand.Intn(len(hexBuf))] = 0

		} else {
			// don't waste the cpu timer if we're not changing the file
			out.Write(buf)
		}
	}

}
