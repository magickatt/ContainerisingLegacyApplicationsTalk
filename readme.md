# Containerising legacy applications talk

## Setup

		git clone --depth=1 --branch=mybb_1820 https://github.com/mybb/mybb.git application
		rm -rf ./application/.git

    docker run -p 80:80 mybb:latest
