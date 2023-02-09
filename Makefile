.PHONY: build run

lyrics.js:
	./generate-lyrics.sh | tee lyrics.js

build:
	docker build -t test .

run: build
	docker run --mount type=bind,source=${PWD}/index.html,target=/usr/share/nginx/html/index.html --publish 8080:80 test
