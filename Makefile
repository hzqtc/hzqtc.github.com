all:
	jekyll --no-server --no-auto

clean:
	rm -rf _site

server:
	jekyll --server 8080 --auto
