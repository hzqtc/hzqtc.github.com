all:
	jekyll build

clean:
	rm -rf _site

server:
	jekyll serve --watch --port 8080
