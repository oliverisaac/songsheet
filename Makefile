.PHONY: build run

lyrics.js:
	./generate-lyrics.sh | tee lyrics.js

build:
	docker build -t test .

run: build
	docker run --publish 8080:80 test
