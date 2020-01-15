docker-build:
	docker build -t x-blagues .

docker-run:
	docker run --rm --name x-blagues --network host -d -e SLACK_API_TOKEN=$$SLACK_API_TOKEN x-blagues

docker-stop:
	docker stop x-blagues

docker-rm:
	docker rm x-blagues
