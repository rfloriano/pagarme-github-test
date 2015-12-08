.PHONY: test run

setup:
	@rm -rf build node_modules
	@npm install coffee-script grunt-cli
	@npm install .
	@./node_modules/.bin/grunt build

run:
	@./node_modules/.bin/grunt run

test:
	@PORT=3001 ./node_modules/.bin/grunt test
