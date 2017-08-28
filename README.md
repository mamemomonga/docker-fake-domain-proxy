


# Rebuild

	docker stop dfp01 && \
	docker rm dfp01 && \
	docker build -t fake-domain-proxy . && \
	docker run -d --name dfp01 -p 8888:8888 -v $(pwd)/data:/data fake-domain-proxy

