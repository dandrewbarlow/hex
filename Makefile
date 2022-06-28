main:
	go build -o bin/main src/main.go

test:
	go build -o bin/main src/main.go
	bin/main -i bin/don.jpg
